unit AddBusStop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Maps, FMX.Objects, Aurelius.Engine.ObjectManager,
  DBConnection, Aurelius.Schema.SQLite, Generics.Collections, FMX.ListBox;

type
  TAddBusStopForm = class(TForm)
    MapView: TMapView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    CbbBeacons: TComboBox;
    Image2: TImage;
    procedure MapViewMapDoubleClick(const Position: TMapCoordinate);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddBusStopForm: TAddBusStopForm;

implementation

uses BeaconItem, BusStop, BusStopController, BeaconController, ListBeacons;
{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TAddBusStopForm.FormShow(Sender: TObject);
var
  BusStopCtr: TBusStopController;
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Beacon: TBeaconItem;
  BeaconCtr: TBeaconController;
  Beacons: TList<TBeaconItem>;
  Coordinate: TMapCoordinate;
begin
  BusStopCtr := TBusStopController.Create;
  BusStops := BusStopCtr.GetAll;

  for BusStop in BusStops do
  begin
    Coordinate.Latitude := BusStop.Latitude;
    Coordinate.Longitude := BusStop.Longitude;
    MapIcon := TMapMarkerDescriptor.Create(Coordinate,'teste');
    MapIcon.Title := BusStop.Description;
    MapIcon.Icon := Image2.Bitmap;
    MapIcon.Visible := True;
    MapView.AddMarker(MapIcon);
  end;

  BeaconCtr := TBeaconController.Create;
  Beacons := BeaconCtr.GetAll;
  for Beacon in Beacons do
    CbbBeacons.Items.AddPair(Beacon.ID.ToString,Beacon.UUID);
end;

procedure TAddBusStopForm.MapViewMapDoubleClick(const Position: TMapCoordinate);
var
  MapIcon: TMapMarkerDescriptor;
  BeaconItem: TBeaconItem;
  BusStop : TBusStop;
  Manager : TObjectManager;
  BeaconCtr: TBeaconController;
begin
  if CbbBeacons.ItemIndex = -1 then
  begin
    ShowMessage('Escolha um beacon');
    exit;
  end;
  MapIcon := TMapMarkerDescriptor.Create(Position,'Teste');
  MapIcon.Icon := Image2.Bitmap;
  MapIcon.Visible := True;
  MapView.AddMarker(MapIcon);
  BeaconItem := TBeaconItem.Create;
  BeaconCtr := TBeaconController.Create;
  BeaconItem := BeaconCtr.GetBeacon(CbbBeacons.Items.Names[CbbBeacons.ItemIndex].ToInteger);
  BusStop := TBusStop.Create;
  try
    Manager := TDBConnection.GetInstance.CreateObjectManager;
    BusStop.Beacon := BeaconItem;
    BusStop.Latitude := Position.Latitude;
    BusStop.Longitude := Position.Longitude;
    BusStop.Description := MapIcon.Title;
    Manager.Save(BusStop);
  finally
    Manager.Free;
    BeaconItem.Free;
    BusStop.Free;
  end;
end;

procedure TAddBusStopForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
