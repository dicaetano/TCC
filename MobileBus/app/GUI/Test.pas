unit Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  BeaconSensor, System.Beacon, System.Bluetooth, System.Beacon.Components,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TTestForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    ListView: TListView;
    Beacon1: TBeacon;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Beacon1BeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure Beacon1BeaconExit(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure Beacon1BeaconProximity(const Sender: TObject;
      const ABeacon: IBeacon; Proximity: TBeaconProximity);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FBeaconSensor: TBeaconSensor;
    procedure NewBeaconFound(const Sender: TObject;
      const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
    procedure BeaconOutOfReach(const Sender: TObject;
      const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
    procedure BeaconProxUpdate(const Sender: TObject;
      const ABeacon: IBeacon; Proximity: TBeaconProximity);
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

procedure TTestForm.Button1Click(Sender: TObject);
begin
  Beacon1.Enabled := True;
end;

procedure TTestForm.Button2Click(Sender: TObject);
var
  BeaconItem: TBeaconItem;
  Manager: TObjectManager;
begin
  if ListView.Selected = nil then
  begin
    ShowMessage('Selecione um item na lista');
    exit;
  end;
  BeaconItem := TBeaconItem.Create;
  Manager := TDBConnection.GetInstance.CreateObjectManager;
  BeaconItem.UUID := TListViewItem(ListView.Selected).Text;
  try
    Manager.Save(BeaconItem);
    ShowMessage(Format('Beacon %s cadastrado.', [BeaconItem.UUID]));
  finally
    Manager.Free;
  end;
end;

procedure TTestForm.NewBeaconFound(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
var
  Item: TListViewItem;
  DeviceId: string;
begin
  DeviceId := ABeacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId, ListView);

  if Item = nil then
    Item := ListView.Items.Add;
  Item.Text := DeviceId;
  Item.Detail := ProximityToString(ABeacon.Proximity)+'-'+ABeacon.Distance.ToString+'m';
end;

procedure TTestForm.Beacon1BeaconEnter(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  NewBeaconFound(Sender, ABeacon, CurrentBeaconList);
end;

procedure TTestForm.Beacon1BeaconExit(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  BeaconOutOfReach(Sender, ABeacon, CurrentBeaconList);
end;

procedure TTestForm.Beacon1BeaconProximity(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
begin
  BeaconProxUpdate(Sender, ABeacon, Proximity);
end;

procedure TTestForm.BeaconOutOfReach(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
var
  Item: TListViewItem;
begin
  for Item in ListView.Items do
    if Item.Text.Equals(ABeacon.DeviceIdentifier) then
      ListView.Items.Delete(Item.Index);
end;


procedure TTestForm.BeaconProxUpdate(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
var
  Item: TListViewItem;
  DeviceId: string;
begin
  DeviceId := ABeacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId, ListView);

  if Item = nil then
    Exit;

  Item.Detail := ProximityToString(ABeacon.Proximity)+'-'+ABeacon.Distance.ToString+'m';
end;

end.
