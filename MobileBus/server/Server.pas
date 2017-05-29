unit Server;

interface

uses
  ConnectionModule,
  RemoteDB.Server.Module,
  System.SysUtils,
  Sparkle.HttpSys.Server,
  Sparkle.HttpServer.Context,
  Sparkle.HttpServer.Module;

procedure StartServer(ServerURI: string);
procedure StopServer;

implementation

uses
  System.IOUtils;

var
  SparkleServer: THttpSysServer;

procedure StartServer(ServerURI: string);
var
  Module : TRemoteDBModule;
begin
  if Assigned(SparkleServer) then
     Exit;

  SparkleServer := THttpSysServer.Create;

  Module := TRemoteDBModule.Create(
    'http://'+ServerURI+'/tms/remotedb',
    TFireDacSQLiteConnection.CreateFactory
  );
  SparkleServer.AddModule(Module);

  SparkleServer.Start;
end;

procedure StopServer;
begin
  FreeAndNil(SparkleServer);
end;

initialization
  SparkleServer := nil;
finalization
  StopServer;
end.
