unit Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  System.Beacon, System.Bluetooth, System.Beacon.Components,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TTestForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Beacon: TBeacon;
    MemoEvents: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure BeaconBeaconProximity(const Sender: TObject;
      const ABeacon: IBeacon; Proximity: TBeaconProximity);
    procedure BeaconBeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestForm: TTestForm;

implementation

uses
  Utils, BeaconItem, DBConnection, Aurelius.Engine.ObjectManager;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TTestForm.BeaconBeaconEnter(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  MemoEvents.Lines.Add('Beacon encontrado: ');
  MemoEvents.Lines.Add('Beacon UUID: '+ABeacon.GUID.ToString);
  MemoEvents.Lines.Add('Beacon Major: '+ABeacon.Major.ToString);
  MemoEvents.Lines.Add('Beacon Minor: '+ABeacon.Minor.ToString);
  MemoEvents.Lines.Add('Beacon RSSI: '+ABeacon.Rssi.ToString);
  MemoEvents.Lines.Add('Beacon Distance: '+ABeacon.Distance.ToString+'m');
  MemoEvents.Lines.Add('Beacon Proximity: '+ProximityToString(ABeacon.Proximity));
  MemoEvents.Lines.Add('====');
  MemoEvents.GoToTextEnd;
end;

procedure TTestForm.BeaconBeaconProximity(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
begin
  MemoEvents.Lines.Add('Proximidade alterada: ');
  MemoEvents.Lines.Add('Beacon UUID: '+ABeacon.GUID.ToString);
  MemoEvents.Lines.Add('Beacon Major: '+ABeacon.Major.ToString);
  MemoEvents.Lines.Add('Beacon Minor: '+ABeacon.Minor.ToString);
  MemoEvents.Lines.Add('Beacon RSSI: '+ABeacon.Rssi.ToString);
  MemoEvents.Lines.Add('Beacon Distance: '+ABeacon.Distance.ToString+'m');
  MemoEvents.Lines.Add('Beacon Proximity: '+ProximityToString(ABeacon.Proximity));
  MemoEvents.Lines.Add('====');
  MemoEvents.GoToTextEnd;
end;

procedure TTestForm.Button1Click(Sender: TObject);
begin
  if not Beacon.Enabled then
  begin
     Button1.Text := 'Parar';
     Beacon.Enabled := True;
  end
  else
  begin
    Beacon.Enabled := False;
    Button1.Text := 'Iniciar';
    MemoEvents.Lines.Clear;
  end;

end;

end.

