unit Aurelius.Drivers.AnyDac;

{$I Aurelius.inc}

interface

uses
  Classes, DB, Variants, Generics.Collections, FMX.Dialogs, System.SysUtils, FireDAC.Stan.Error,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Param,
  Aurelius.Drivers.Base,
  Aurelius.Drivers.Interfaces;

type
  TAnyDacResultSetAdapter = class(TDriverResultSetAdapter<TFDQuery>)
  end;

  TAnyDacStatementAdapter = class(TInterfacedObject, IDBStatement, IDBDatasetStatement)
  private
    FFDQuery: TFDQuery;
    function GetDataset: TDataset;
  public
    constructor Create(AADQuery: TFDQuery);
    destructor Destroy; override;
    procedure SetSQLCommand(SQLCommand: string);
    procedure SetParams(Params: TEnumerable<TDBParam>);
    procedure Execute;
    function ExecuteQuery: IDBResultSet;
  end;

  TAnyDacConnectionAdapter = class(TDriverConnectionAdapter<TFDConnection>, IDBConnection)
  public
    procedure Connect;
    procedure Disconnect;
    function IsConnected: Boolean;
    function CreateStatement: IDBStatement;
    function BeginTransaction: IDBTransaction;
    function RetrieveSqlDialect: string; override;
  end;

  TAnyDacTransactionAdapter = class(TInterfacedObject, IDBTransaction)
  private
    FADConnection: TFDConnection;
  public
    constructor Create(ADConnection: TFDConnection);
    procedure Commit;
    procedure Rollback;
  end;

implementation

{ TAnyDacStatemenTFDapter }

uses
  Aurelius.Drivers.Exceptions;

constructor TAnyDacStatemenTAdapter.Create(AADQuery: TFDQuery);
begin
  FFDQuery := AADQuery;
end;

destructor TAnyDacStatemenTAdapter.Destroy;
begin
  FFDQuery.Free;
  inherited;
end;

procedure TAnyDacStatemenTAdapter.Execute;
begin
  FFDQuery.ExecSQL;
end;

function TAnyDacStatemenTAdapter.ExecuteQuery: IDBResultSet;
var
  ResultSet: TFDQuery;
  I: Integer;
begin
  ResultSet := TFDQuery.Create(nil);
  try
    ResultSet.Connection := FFDQuery.Connection;
    ResultSet.SQL := FFDQuery.SQL;

    for I := 0 to FFDQuery.Params.Count - 1 do
    begin
      ResultSet.Params[I].DataType := FFDQuery.Params[I].DataType;
      ResultSet.Params[I].Value := FFDQuery.Params[I].Value;
    end;

    try
      ResultSet.Open;
    except on E: EFDException do
      if E.FDCode = 308 then
        try
          ResultSet.Execute();
        except on E: Exception do
          raise;
        end;
      
    end;
  except
    ResultSet.Free;
    raise;
  end;
  Result := TAnyDacResultSetAdapter.Create(ResultSet);
end;

function TAnyDacStatemenTAdapter.GetDataset: TDataset;
begin
  Result := FFDQuery;
end;

procedure TAnyDacStatemenTAdapter.SetParams(Params: TEnumerable<TDBParam>);
var
  P: TDBParam;
  Parameter: TFDParam;
begin
  for P in Params do
  begin
    Parameter := FFDQuery.ParamByName(P.ParamName);

    Parameter.DataType := P.ParamType;
    Parameter.Value := P.ParamValue;
  end;
end;

procedure TAnyDacStatemenTAdapter.SetSQLCommand(SQLCommand: string);
begin
  FFDQuery.SQL.Text := SQLCommand;
end;

{ TAnyDacConnectionAdapter }

procedure TAnyDacConnectionAdapter.Disconnect;
begin
  if Connection <> nil then
    Connection.Connected := False;
end;

function TAnyDacConnectionAdapter.RetrieveSqlDialect: string;
begin
  if Connection = nil then
    Exit('');

  case Connection.RDBMSKind of
    2:
      result := 'MSSQL';
    4:
      result := 'MySQL';
    8:
      result := 'Firebird';
    1:
      result := 'Oracle';
    10:
      result := 'SQLite';
    11:
      result := 'PostgreSQL';
    5:
      result := 'DB2';
    7:
      result := 'ADVANTAGE';
  else
//    mkUnknown: ;
//    mkOracle: ;
//    mkMSAccess: ;
//    mkDB2: ;
//    mkASA: ;
//    mkADS: ;
//    mkSQLite: ;
//    mkPostgreSQL: ;
//    mkNexus: ;
//    mkOther: ;
    result := 'NOT_SUPPORTED';
  end;
end;

function TAnyDacConnectionAdapter.IsConnected: Boolean;
begin
  if Connection <> nil then
    Result := Connection.Connected
  else
    Result := false;
end;

function TAnyDacConnectionAdapter.CreateStatement: IDBStatement;
var
  Statement: TFDQuery;
begin
  if Connection = nil then
    Exit(nil);

  Statement := TFDQuery.Create(nil);
  try
    Statement.Connection := Connection;
  except
    Statement.Free;
    raise;
  end;
  Result := TAnyDacStatemenTAdapter.Create(Statement);
end;

procedure TAnyDacConnectionAdapter.Connect;
begin
  if Connection <> nil then
    Connection.Connected := True;
end;

function TAnyDacConnectionAdapter.BeginTransaction: IDBTransaction;
begin
  if Connection = nil then
    Exit(nil);

  Connection.Connected := true;

  if not Connection.InTransaction then
  begin
    Connection.StartTransaction;
    Result := TAnyDacTransactionAdapter.Create(Connection);
  end else
    Result := TAnyDacTransactionAdapter.Create(nil);
end;

{ TAnyDacTransactionAdapter }

procedure TAnyDacTransactionAdapter.Commit;
begin
  if (FADConnection = nil) then
    Exit;

  FADConnection.Commit;
end;

constructor TAnyDacTransactionAdapter.Create(ADConnection: TFDConnection);
begin
  FADConnection := ADConnection;
end;

procedure TAnyDacTransactionAdapter.Rollback;
begin
  if (FADConnection = nil) then
    Exit;

  FADConnection.Rollback;
end;

end.
