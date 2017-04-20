program VCLServer;

uses
  Vcl.Forms,
  Server in 'Server.pas',
  ConnectionModule in 'ConnectionModule.pas' {FireDacSQLiteConnection: TDataModule},
  MainForm in 'MainForm.pas' {fmServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmServer, fmServer);
  Application.Run;
end.
