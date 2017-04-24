unit BeaconSensor;

interface

uses
  System.Classes, System.Beacon, System.Beacon.Components, Generics.Collections,
  System.Bluetooth, System.SysUtils, DBConnection;

type
  TOnNewBeaconFound = procedure(Beacon: IBeacon) of object;
  TOnBeaconOutOfReach = procedure(Beacon: IBeacon) of object;
  TOnBeaconUpdate = procedure(Beacon: IBeacon) of object;

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
    FOnBeaconOutOfReach: TOnBeaconOutOfReach;
    FOnBeaconUpdate: TOnBeaconUpdate;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy;
    property OnNewBeaconFound: TOnNewBeaconFound read FOnNewBeaconFound write FOnNewBeaconFound;
    property OnBeaconOutOfReach: TOnBeaconOutOfReach read FOnBeaconOutOfReach write FOnBeaconOutOfReach;
    property OnBeaconUpdate: TOnBeaconUpdate read FOnBeaconUpdate write FOnBeaconUpdate;
  end;

implementation

uses
  Configs, ConfigsController;

{ TBeaconSensor }

constructor TBeaconSensor.Create;
var
  Config: TConfigs;
begin
  inherited Create(True);

  Config := TConfigsController.GetInstance.GetFirst;
  FreeOnTerminate := True;
  FBeaconsFound := TDictionary<string, IBeacon>.Create;
  FBeacon := TBeacon.Create(nil);
  with FBeacon do
  begin
    ModeExtended := [iBeacons, AltBeacons, Eddystones];
    if Assigned(Config) then
    begin
      BeaconDeathTime := Config.DeathTime;
      SPC := Config.SPC;
      ScanningTime := Config.ScanningTime;
      ScanningSleepingTime := Config.ScanningSleep;
    end
    else
    begin
      BeaconDeathTime := 100;
      SPC := 2.0;
      ScanningTime := 1000;
    end;
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
            //Verificar forma de fazer beacon ser retirado da lista e verificar se ele
           //já não está na lista
            if (Beacon <> nil) and (Beacon.DeviceIdentifier.Equals(BLE.Identifier)) then
            begin
              //if Assigned(FOnBeaconUpdate) then
              //  FOnBeaconUpdate(Beacon);

              if (Beacon.ItsAlive) {and not (FBeaconsFound.ContainsKey(Beacon.DeviceIdentifier)) }then
              begin
//                FBeaconsFound.AddOrSetValue(Beacon.DeviceIdentifier, Beacon);
                if Assigned(FOnNewBeaconFound) then
                  FOnNewBeaconFound(Beacon);
              end
              else
              if not (Beacon.ItsAlive) and (FBeaconsFound.ContainsKey(Beacon.DeviceIdentifier)) then
              begin
             //   FBeaconsFound.Remove(Beacon.DeviceIdentifier);
             //   if Assigned(FOnBeaconOutOfReach) then
             //     FOnBeaconOutOfReach(Beacon);
              end;
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

