program BeaconService;

uses
  System.Android.ServiceApplication,
  uDMService in 'uDMService.pas' {DM: TAndroidService};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
