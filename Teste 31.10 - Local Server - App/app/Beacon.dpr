program Beacon;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmPrincipal},
  uDMService in '..\service\uDMService.pas' {DM: TAndroidService};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
