program Beacon;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmPrincipal},
  {$IFDEF ANDROID}
  uDMService in '..\service\uDMService.pas' {DM: TAndroidService},
  {$ENDIF}
  DmGeral in 'DmGeral.pas' {DataModule1: TDataModule},
  DBConnection in 'DBConnection.pas',
  BeaconItem in 'Entities\BeaconItem.pas',
  BusExitTime in 'Entities\BusExitTime.pas',
  BusLine in 'Entities\BusLine.pas',
  BusStop in 'Entities\BusStop.pas',
  Routs in 'Entities\Routs.pas',
  BeaconController in 'Controllers\BeaconController.pas',
  BusExitController in 'Controllers\BusExitController.pas',
  BusLineController in 'Controllers\BusLineController.pas',
  BusStopController in 'Controllers\BusStopController.pas',
  RoutsController in 'Controllers\RoutsController.pas',
  BeaconSensor in 'BeaconSensor.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
