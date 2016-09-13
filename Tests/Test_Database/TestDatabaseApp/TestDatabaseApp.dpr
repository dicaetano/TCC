program TestDatabaseApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1}
  {$IF DEFINED (IOS) || (ANDROID)}
  ,uDMService in '..\TestDatabaseService\uDMService.pas' {DM: TAndroidService}
  {$ENDIF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
