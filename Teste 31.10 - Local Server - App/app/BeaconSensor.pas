unit BeaconSensor;

interface

uses
  System.Beacon, System.Beacon.Components, Generics.Collections, System.Bluetooth,
  System.SysUtils;

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
begin
  BeaconList := FBeacon.BeaconList;
  BluetoothLEDeviceList := TBluetoothLEManager.Current.LastDiscoveredDevices

  try
    Result := nil;

  except on E: Exception do
  end;
end;

end.
