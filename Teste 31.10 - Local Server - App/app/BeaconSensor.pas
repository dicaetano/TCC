unit BeaconSensor;

interface

uses
  System.Classes, System.Beacon, System.Beacon.Components, Generics.Collections,
  System.Bluetooth, System.SysUtils;

type
  TOnNewBeaconFound = procedure(Beacon: IBeacon) of object;

  TBeaconConfig = record
    DeathTime: Integer;
    SPC: Double;
    ScanningTime: Integer;
    ScanningSleep: Integer;
    TimerScan: Integer;
  end;

  TBeaconSensor = class(TThread)
  private
    FBeacon: TBeacon;
    FBeaconsFound: TDictionary<string, IBeacon>;
    FOnNewBeaconFound: TOnNewBeaconFound;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy;
    property OnNewBeaconFound: TOnNewBeaconFound read FOnNewBeaconFound write FOnNewBeaconFound;
  end;

implementation

{ TBeaconSensor }


constructor TBeaconSensor.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FBeaconsFound := TDictionary<string, IBeacon>.Create;
  FBeacon := TBeacon.Create(nil);
  with FBeacon do
  begin
    ModeExtended := [iBeacons, AltBeacons, Eddystones];
    BeaconDeathTime := 100;
    SPC := 2.0;
    ScanningTime := 1000;
  end;
end;

destructor TBeaconSensor.Destroy;
begin
  FBeacon.Free;
  FBeaconsFound.Free;
end;

procedure TBeaconSensor.Execute;
var
  BeaconList: TBeaconList;
  BluetoothLEDeviceList: TBluetoothLEDeviceList;
  BLE: TBluetoothLEDevice;
  Beacon: IBeacon;
begin
  FBeacon.Enabled := True;

  while not Terminated do
  begin
    FBeacon.StartScan;
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
            begin
              FBeaconsFound.AddOrSetValue(Beacon.DeviceIdentifier, Beacon);
              if Assigned(FOnNewBeaconFound) then
                FOnNewBeaconFound(Beacon);
            end;
          end;
        end;
      finally
        TMonitor.Exit(BluetoothLEDeviceList);
      end;
    end;
    Sleep(1000);
  end;
end;

end.
