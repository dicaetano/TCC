program TestDatabaseApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1},
  uDMService in '..\TestDatabaseService\uDMService.pas' {DM: TAndroidService};

{DM: TAndroidService}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
