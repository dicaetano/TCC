program Beacon;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmPrincipal},
  {$IFDEF ANDROID}
  uDMService in '..\service\uDMService.pas' {DM: TAndroidService},
  {$ENDIF }
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
  EditConfig in 'GUI\EditConfig.pas' {EditConfigForm},
  BeaconSensor in 'BeaconSensor.pas',
  ListBeacons in 'GUI\ListBeacons.pas' {ListBeaconsForm},
  DmConnection in 'DmConnection.pas' {DMConn: TDataModule},
  ControllerInterfaces in 'Controllers\ControllerInterfaces.pas',
  Utils in 'Utils.pas',
  AddBusStop in 'GUI\AddBusStop.pas' {AddBusStopForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
