program MobileBusApp;

uses
  {$IFDEF ANDROID}
  {$ENDIF }
  {$ENDIF }
  BeaconSensor in 'BeaconSensor.pas' {$ENDIF},
  {$ENDIF }
  System.StartUpCopy,
  FMX.Forms,
  DBConnection in 'DBConnection.pas',
  DmConnection in 'DmConnection.pas' {DMConn: TDataModule},
  FMX.MultiView.CustomPresentation in 'FMX.MultiView.CustomPresentation.pas',
  Main in 'Main.pas' {frmPrincipal},
  Utils in 'Utils.pas',
  BeaconController in 'Controllers\BeaconController.pas',
  BusExitController in 'Controllers\BusExitController.pas',
  BusLineController in 'Controllers\BusLineController.pas',
  BusStopController in 'Controllers\BusStopController.pas',
  ControllerInterfaces in 'Controllers\ControllerInterfaces.pas',
  RoutesController in 'Controllers\RoutesController.pas',
  BeaconItem in 'Entities\BeaconItem.pas',
  BusExitTime in 'Entities\BusExitTime.pas',
  BusLine in 'Entities\BusLine.pas',
  BusStop in 'Entities\BusStop.pas',
  Routes in 'Entities\Routes.pas',
  EditConfig in 'GUI\EditConfig.pas' {EditConfigForm},
  ListBeacons in 'GUI\ListBeacons.pas' {ListBeaconsForm},
  AddBusStop in 'GUI\AddBusStop.pas' {AddBusStopForm},
  Configs in 'Entities\Configs.pas',
  ConfigsController in 'Controllers\ConfigsController.pas',
  BusRouteTime in 'Entities\BusRouteTime.pas',
  BusRouteTimeController in 'Controllers\BusRouteTimeController.pas',
  Test in 'GUI\Test.pas' {TestForm},
  Test2 in 'GUI\Test2.pas' {Test2Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TTest2Form, Test2Form);
  Application.Run;
end.
