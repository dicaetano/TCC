unit DBConnection;

interface

uses
  IOUtils,
  Generics.Collections, Classes, IniFiles,
  Aurelius.Commands.Listeners,
  Aurelius.Drivers.Interfaces,
  Aurelius.Engine.AbstractManager,
  Aurelius.Engine.ObjectManager,
  Aurelius.Engine.DatabaseManager,
  Aurelius.Sql.SQLite,
  RemoteDB.Client.Database,
  Aurelius.Drivers.RemoteDB,
  Aurelius.Mapping.Explorer,
  DMConnection,Fmx.Dialogs;

type
  TDBConnection = class sealed
  private
    class var FInstance: TDBConnection;
  private
    FConnection: IDBConnection;
    FDMConnection: TDMConn;
    FMappingExplorer: TMappingExplorer;
    FListeners: TList<ICommandExecutionListener>;
    procedure PrivateCreate;
    procedure PrivateDestroy;

    function DatabaseFileName: string;

    function GetConnection: IDBConnection;
    procedure AddListeners(AManager: TAbstractManager);
    procedure MapClasses;
  public
    class function GetInstance: TDBConnection;
    procedure AddCommandListener(Listener: ICommandExecutionListener);
    class procedure AddLines(List: TStrings; Sql: string;
      Params: TEnumerable<TDBParam>);

    property Connection: IDBConnection read GetConnection;
    function HasConnection: boolean;
    function CreateObjectManager: TObjectManager;
    function GetNewDatabaseManager: TDatabaseManager;
    procedure UnloadConnection;
    function CreateConnection: IDBConnection;
  end;

implementation

uses
  Variants, DB, SysUtils, TypInfo,
  BeaconItem, Routes, BusExitTime, BusLine, BusStop, Aurelius.Mapping.Setup,
  BusRouteTime, Configs,ConfigsController, Main;

{ TConexaoUnica }

procedure TDBConnection.AddCommandListener(Listener: ICommandExecutionListener);
begin
  FListeners.Add(Listener);
end;

class procedure TDBConnection.AddLines(List: TStrings; Sql: string;
  Params: TEnumerable<TDBParam>);
var
  P: TDBParam;
  ValueAsString: string;
  HasParams: boolean;
begin
  List.Add(Sql);

  if Params <> nil then
  begin
    HasParams := False;
    for P in Params do
    begin
      if not HasParams then
      begin
        List.Add('');
        HasParams := True;
      end;

      if P.ParamValue = Variants.Null then
        ValueAsString := 'NULL'
      else if P.ParamType = ftDateTime then
        ValueAsString := '"' + DateTimeToStr(P.ParamValue) + '"'
      else if P.ParamType = ftDate then
        ValueAsString := '"' + DateToStr(P.ParamValue) + '"'
      else
        ValueAsString := '"' + VarToStr(P.ParamValue) + '"';

      List.Add(P.ParamName + ' = ' + ValueAsString + ' (' +
        GetEnumName(TypeInfo(TFieldType), Ord(P.ParamType)) + ')');
    end;
  end;

  List.Add('');
  List.Add('================================================');
end;

procedure TDBConnection.AddListeners(AManager: TAbstractManager);
var
  Listener: ICommandExecutionListener;
begin
  for Listener in FListeners do
    AManager.AddCommandListener(Listener);
end;

function TDBConnection.DatabaseFileName: string;
begin
  Result :=
    IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, 'aurelius.sqlite');
end;

procedure TDBConnection.UnloadConnection;
begin
  if FConnection <> nil then
  begin
    FConnection.Disconnect;
    FConnection := nil;
    FDMConnection := nil;
    FMappingExplorer := nil;
  end;
end;

function TDBConnection.CreateConnection: IDBConnection;
var
  XDB: TRemoteDBDatabase;
begin
  if FConnection <> nil then
    Exit(FConnection);
  FDMConnection := TDMConn.Create(nil);
  //FDMConnection.FDConnection.Params.Values['Database'] := DatabaseFileName;
  //FDMConnection.FDConnection.Connected := True;
  //FConnection := TAnyDacConnectionAdapter.Create(FDMConnection.FDConnection, False);
  XDB := TRemoteDBDatabase.Create(nil);
  FConnection := TRemoteDBConnectionAdapter.Create(XDB, true);
//  XDB.ServerUri := Format('http://%s/tms/remotedb',[Configs.URLServer]);
//  XDB.ServerUri := 'http://192.168.1.100:2002/tms/remotedb';
  XDB.ServerUri := 'http://'+MainForm.IPServer+'/tms/remotedb';
  XDB.UserName := 'remotedb';
  XDB.Password := 'business';
  try
    XDB.Connected := True;
  except on E: Exception do
    ShowMessage('Favor informar o endereço do servidor');
  end;
  MapClasses;
  //GetNewDatabaseManager.BuildDatabase;
  Result := FConnection;
end;


function TDBConnection.GetConnection: IDBConnection;
begin
  Result := CreateConnection;
  if Result = nil then
    raise Exception.Create
      ('Não foi possível se conectar ao banco de dados.');
  if not Result.IsConnected then
    Result.Connect;
end;

class function TDBConnection.GetInstance: TDBConnection;
begin
  if FInstance = nil then
  begin
    FInstance := TDBConnection.Create;
    FInstance.PrivateCreate;
  end;
  Result := FInstance;
end;

function TDBConnection.GetNewDatabaseManager: TDatabaseManager;
begin
  Result := TDatabaseManager.Create(Connection);
  AddListeners(Result);
end;

function TDBConnection.CreateObjectManager: TObjectManager;
begin
  Result := TObjectManager.Create(Connection);
  Result.OwnsObjects := True;
  AddListeners(Result);
end;

function TDBConnection.HasConnection: boolean;
begin
  Result := CreateConnection <> nil;
end;

procedure TDBConnection.MapClasses;
var
  MapSetupSQLite: TMappingSetup;
begin
  MapSetupSQLite := TMappingSetup.Create;
  try
    MapSetupSQLite.MappedClasses.RegisterClass(TBeaconItem);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusStop);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusLine);
    MapSetupSQLite.MappedClasses.RegisterClass(TRoute);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusExitTime);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusRouteTime);

    FMappingExplorer := TMappingExplorer.Create(MapSetupSQLite);
  finally
    MapSetupSQLite.Free;
  end;
end;

procedure TDBConnection.PrivateCreate;
begin
  FListeners := TList<ICommandExecutionListener>.Create;
end;

procedure TDBConnection.PrivateDestroy;
begin
  UnloadConnection;
  FListeners.Free;
end;

initialization

finalization

if TDBConnection.FInstance <> nil then
begin
  TDBConnection.FInstance.PrivateDestroy;
  TDBConnection.FInstance.Free;
  TDBConnection.FInstance := nil;
end;

end.
