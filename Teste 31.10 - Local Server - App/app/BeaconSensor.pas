unit BeaconSensor;

interface

uses
  System.Beacon, System.Beacon.Components, Generics.Collections, System.Bluetooth,
  System.SysUtils, FMX.Dialogs;

type
  TBeaconSensor = class
  private
    FBeacon: TBeacon;
    function GetCurrentBeaconList: TList<IBeacon>;

  public
    constructor Create;
    destructor Destroy;
    property CurrentBeaconList: TList<IBeacon> read GetCurrentBeaconList;
  end;

implementation

{ TBeaconSensor }

constructor TBeaconSensor.Create;
begin
  FBeacon := TBeacon.Create(nil);
  with FBeacon do
  begin
    ModeExtended := [iBeacons, AltBeacons, Eddystones];
    BeaconDeathTime := 50;
    SPC := 2.0;
    ScanningTime := 1000;
  end;
end;

destructor TBeaconSensor.Destroy;
begin
  FBeacon.Free;
  inherited;
end;

function TBeaconSensor.GetCurrentBeaconList: TList<IBeacon>;
var
  BeaconList: TBeaconList;
  BluetoothLEDeviceList: TBluetoothLEDeviceList;
  BLE: TBluetoothLEDevice;
  Beacon: IBeacon;
begin
  try
    BeaconList := FBeacon.BeaconList;
    BluetoothLEDeviceList := TBluetoothLEManager.Current.LastDiscoveredDevices;

    if Length(BeaconList) > 0 then
    begin
      TMonitor.Enter(BluetoothLEDeviceList);
      try
        for BLE in BluetoothLEDeviceList do
        begin
          for Beacon in BeaconList do
          begin
            if (Beacon <> nil) and (Beacon.ItsAlive) and (Beacon.DeviceIdentifier.Equals(BLE.Identifier)) then
              Result.Add(Beacon);
          end;
        end;
      finally
        TMonitor.Exit(BluetoothLEDeviceList);
      end;
    end;
  except
  on E: Exception do
    ShowMessage(E.Message);
  end;
end;

end.
