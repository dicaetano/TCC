unit Server;

interface

uses
  ConnectionModule,
  RemoteDB.Server.Module,
  System.SysUtils,
  Sparkle.HttpSys.Server,
  Sparkle.HttpServer.Context,
  Sparkle.HttpServer.Module,
  Sparkle.Logger;

type
  TLogger = class(TInterfacedObject, ILogEngine)
    procedure Log(const Msg: string);
  end;

procedure StartServer(ServerURI: string);
procedure StopServer;

implementation

uses
  System.IOUtils, MainForm;

var
  SparkleServer: THttpSysServer;
  Logger: TLogger;

procedure StartServer(ServerURI: string);
var
  Module : TRemoteDBModule;
begin
  if Assigned(SparkleServer) then
     Exit;

  Logger := TLogger.Create;
  SparkleServer := THttpSysServer.Create;

  Module := TRemoteDBModule.Create(
    'http://'+ServerURI+'/tms/remotedb',
    TFireDacSQLiteConnection.CreateFactory
  );
  SparkleServer.AddModule(Module);

  SparkleServer.Start;
  Module.LogEngine := Logger;
  SparkleServer.LogEngine := Logger;
end;

procedure StopServer;
begin
  FreeAndNil(SparkleServer);
end;

{ TLog }

procedure TLogger.Log(const Msg: string);
begin
  fmServer.Memo1.Lines.Add(Msg);
end;

initialization
  SparkleServer := nil;
  Logger := nil;
finalization
  StopServer;
end.
