unit AddBusStop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Maps, FMX.Objects, Aurelius.Engine.ObjectManager,
  DBConnection, Aurelius.Schema.SQLite, Generics.Collections, FMX.ListBox,
  System.Sensors, System.Sensors.Components, BusStopController, BusStop;

type
  TAddBusStopForm = class(TForm)
    MapView: TMapView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    CbbBeacons: TComboBox;
    Image2: TImage;
    LocationSensor: TLocationSensor;
    procedure MapViewMapDoubleClick(const Position: TMapCoordinate);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MapViewMarkerDoubleClick(Marker: TMapMarker);
    procedure MapViewMarkerDragEnd(Marker: TMapMarker);
  private
    { Private declarations }
    FMarkersMap: TDictionary<TMapMarker,TBusStop>;
    FBusStopCtr: TBusStopController;
  public
    { Public declarations }
  end;

var
  AddBusStopForm: TAddBusStopForm;

implementation

uses BeaconItem, BeaconController, ListBeacons;
{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TAddBusStopForm.FormCreate(Sender: TObject);
begin
  FMarkersMap := TDictionary<TMapMarker,TBusStop>.Create;
  FBusStopCtr := TBusStopController.Create;
end;

procedure TAddBusStopForm.FormDestroy(Sender: TObject);
var
  Marker: TMapMarker;
begin
  for Marker in FMarkersMap.Keys do
    Marker.Free;
  FMarkersMap.Free;
  FBusStopCtr.Free;
end;

procedure TAddBusStopForm.FormShow(Sender: TObject);
var
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Beacon: TBeaconItem;
  BeaconCtr: TBeaconController;
  Beacons: TList<TBeaconItem>;
  Coordinate: TMapCoordinate;
begin
  BusStops := FBusStopCtr.GetAll;

  for BusStop in BusStops do
  begin
    Coordinate.Latitude := BusStop.Latitude;
    Coordinate.Longitude := BusStop.Longitude;
    MapIcon := TMapMarkerDescriptor.Create(Coordinate,'teste');
    MapIcon.Draggable := True;
    MapIcon.Title := BusStop.Description;
    MapIcon.Icon := Image2.Bitmap;
    MapIcon.Visible := True;
    FMarkersMap.Add(MapView.AddMarker(MapIcon), BusStop);
  end;

  if BusStops.Count > 0 then
  begin
    MapView.Location := TMapCoordinate.Create(BusStops.Last.Latitude, BusStops.Last.Longitude);
    MapView.Zoom := 15;
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

procedure TAddBusStopForm.MapViewMarkerDoubleClick(Marker: TMapMarker);
var
  BusStop: TBusStop;
begin
  if FMarkersMap.TryGetValue(Marker, BusStop) then
    FBusStopCtr.Delete(BusStop);
  Marker.Remove;
end;

procedure TAddBusStopForm.MapViewMarkerDragEnd(Marker: TMapMarker);
begin
  //Atualizar no banco
end;

procedure TAddBusStopForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
