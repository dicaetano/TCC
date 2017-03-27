unit uDMService;

interface

uses

  System.SysUtils,
  System.Classes,
  System.Android.Service,
  AndroidApi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Os, System.Beacon, System.Bluetooth, System.Notification,
  System.Beacon.Components;

type
  TDM = class(TAndroidService)
    Beacon: TBeacon;
    Notification: TNotificationCenter;
    procedure AndroidServiceCreate(Sender: TObject);
    function AndroidServiceStartCommand(const Sender: TObject;
      const Intent: JIntent; Flags, StartId: Integer): Integer;
    procedure BeaconBeaconProximity(const Sender: TObject;
      const ABeacon: IBeacon; Proximity: TBeaconProximity);
    procedure BeaconBeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
  private
    { Private declarations }

    procedure NotifyBeaconProximity(const Msg, UUID: string);
  public
    { Public declarations }
  end;


var
  DM: TDM;

implementation

uses
  Androidapi.JNI.App;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.AndroidServiceCreate(Sender: TObject);
begin
  Beacon.Enabled := True;
end;

function TDM.AndroidServiceStartCommand(const Sender: TObject;
  const Intent: JIntent; Flags, StartId: Integer): Integer;
begin
  Beacon.Enabled := True;
  Result := TJService.JavaClass.START_STICKY;
end;

procedure TDM.BeaconBeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
  const CurrentBeaconList: TBeaconList);
var
  msg : string;
begin
  Msg := 'Parada de ônibus detectada. Clique para visualizar horários';
  NotifyBeaconProximity(Msg, ABeacon.GUID.ToString);
end;

procedure TDM.BeaconBeaconProximity(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
var
  Msg : string;
begin
  if Proximity = TBeaconProximity.Near then
  begin
    Msg := 'Parada de ônibus (próxima) detectada. Clique para visualizar horários';
    NotifyBeaconProximity(Msg, ABeacon.GUID.ToString);
  end;
//    NotifyBeaconProximity(ABeacon.GUID.ToString + ':' + ABeacon.Major.ToString + ',' + ABeacon.Minor.ToString);
end;

procedure TDM.NotifyBeaconProximity(const Msg, UUID: string);
var
  MyNotification: TNotification;
begin
  MyNotification := Notification.CreateNotification;
  try
    MyNotification.Name := 'BusStopNotification';
    MyNotification.AlertBody := Msg;
    MyNotification.AlertAction := UUID;
    Notification.PresentNotification(MyNotification);
  finally
    MyNotification.Free;
  end;
end;

end.
