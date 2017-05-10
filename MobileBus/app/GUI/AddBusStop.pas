unit AddBusStop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Maps, FMX.Objects, Aurelius.Engine.ObjectManager,
  DBConnection, Aurelius.Schema.SQLite, Generics.Collections, FMX.ListBox,
  System.Sensors, System.Sensors.Components, BusStopController, BusStop,
  FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TAddBusStopForm = class(TForm)
    MapView: TMapView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    CbbBeacon: TComboBox;
    Image2: TImage;
    EditDescription: TEdit;
    LvBusStop: TListView;
    procedure MapViewMapDoubleClick(const Position: TMapCoordinate);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MapViewMarkerDoubleClick(Marker: TMapMarker);
    procedure MapViewMarkerDragEnd(Marker: TMapMarker);
    procedure LoadBusStopOrRouts;
    procedure LoadBusStops;
    procedure LoadBeacons;
    procedure LoadRoutes;
    procedure AddBusStop(const Position: TMapCoordinate);
    procedure AddBusStopToRoute(Marker: TMapMarker);
    procedure FormShow(Sender: TObject);
    procedure RemoveBusStopToRoute(Marker: TMapMarker);
  private
    { Private declarations }
    FMarkersMap: TDictionary<TMapMarker,TBusStop>;
    FBusStopCtr: TBusStopController;
    procedure LoadRouts;
  public
    { Public declarations }
    Source: Integer;
  end;

var
  AddBusStopForm: TAddBusStopForm;
const
  ADD_BUS_STOP = 1;
  ADD_ROUTS = 2;

implementation

uses BeaconItem, BeaconController, ListBeacons, Routes, RoutesController;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TAddBusStopForm.AddBusStop(const Position: TMapCoordinate);
var
  BeaconItem: TBeaconItem;
  BeaconCtr: TBeaconController;
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Coordinate: TMapCoordinate;
begin
  if CbbBeacon.ItemIndex = -1 then
  begin
    ShowMessage('Escolha um beacon');
    exit;
  end;
  MapIcon := TMapMarkerDescriptor.Create(Position,EditDescription.text);
  MapIcon.Icon := Image1.Bitmap;
  MapIcon.Visible := True;
  MapView.AddMarker(MapIcon);
  BeaconItem := TBeaconItem.Create;
  BeaconCtr := TBeaconController.Create;
  BeaconItem := BeaconCtr.GetBeacon(CbbBeacon.Items.Names[CbbBeacon.ItemIndex].ToInteger);
  BusStop := TBusStop.Create;
  try
    BusStop.Beacon := BeaconItem;
    BusStop.Latitude := Position.Latitude;
    BusStop.Longitude := Position.Longitude;
    BusStop.Description := MapIcon.Title;
    FBusStopCtr.Save(BusStop);
  finally
    BeaconItem.Free;
    BusStop.Free;
    EditDescription.Text := '';
    CbbBeacon.ItemIndex := -1;
  end;
end;

procedure TAddBusStopForm.AddBusStopToRoute(Marker: TMapMarker);
var
  ListViewItem: TListViewItem;
begin
//
  ListViewItem := LvBusStop.Items.Add;
  ListViewItem.IndexTitle := (LvBusStop.Items.Count+1).ToString;
  ListViewItem.Detail := Marker.Descriptor.Title;
  ListViewItem.Bitmap := Marker.Descriptor.Icon;
end;

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
begin
  LoadBusStopOrRouts;
end;

procedure TAddBusStopForm.LoadBeacons;
var
  Beacon: TBeaconItem;
  BeaconCtr: TBeaconController;
  Beacons: TList<TBeaconItem>;

begin
  BeaconCtr := TBeaconController.Create;
  Beacons := BeaconCtr.GetAll;
  for Beacon in Beacons do
    CbbBeacon.Items.AddPair(Beacon.ID.ToString,Beacon.UUID);
end;

procedure TAddBusStopForm.LoadBusStops;
var
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Coordinate: TMapCoordinate;
begin
  BusStops := FBusStopCtr.GetAll;
  for BusStop in BusStops do
  begin
    Coordinate.Latitude := BusStop.Latitude;
    Coordinate.Longitude := BusStop.Longitude;
    MapIcon := TMapMarkerDescriptor.Create(Coordinate,BusStop.Description);
    MapIcon.Draggable := True;
    MapIcon.Title := BusStop.Description;
    MapIcon.Icon := Image1.Bitmap;
    MapIcon.Visible := True;
    FMarkersMap.Add(MapView.AddMarker(MapIcon), BusStop);
  end;

  if BusStops.Count > 0 then
  begin
    MapView.Location := TMapCoordinate.Create(BusStops.Last.Latitude, BusStops.Last.Longitude);
    MapView.Zoom := 15;
  end;
end;

procedure TAddBusStopForm.LoadRoutes;
var
  RoutesController: TRouteController;
  Routes: TList<TRoute>;
  Route: TRoute;
begin
//
  RoutesController := TRouteController.Create;
  Routes := RoutesController.GetAll;
  for Route in Routes do
  begin
    Route.ID
  end;
end;

procedure TAddBusStopForm.LoadBusStopOrRouts;
begin
  LoadBusStops;
  if source = ADD_BUS_STOP then
  begin
    LoadBeacons;
    CbbBeacon.Visible := True;
    LvBusStop.Visible := False;
  end
  else
  begin
    CbbBeacon.Visible := False;

  end;
end;

procedure TAddBusStopForm.MapViewMapDoubleClick(const Position: TMapCoordinate);
begin
  if Source = ADD_BUS_STOP then
    AddBusStop(Position);
end;

procedure TAddBusStopForm.MapViewMarkerDoubleClick(Marker: TMapMarker);
var
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
begin
  if Source = ADD_BUS_STOP then
  begin
    if FMarkersMap.TryGetValue(Marker, BusStop) then
      FBusStopCtr.Delete(BusStop);
    Marker.Remove;
  end
  else
  begin
    if Marker.Descriptor.Icon = Image1.Bitmap then
    begin
      MapIcon := Marker.Descriptor;
      MapIcon.Icon := Image2.Bitmap;
      MapIcon.Visible := True;
      AddBusStopToRoute(Marker);
    end
    else
    begin
      MapIcon.Icon := Image2.Bitmap;
      MapIcon.Visible := True;
      RemoveBusStopToRoute(Marker);
    end;
  end;
end;

procedure TAddBusStopForm.MapViewMarkerDragEnd(Marker: TMapMarker);
begin
  //Atualizar no banco
end;

procedure TAddBusStopForm.RemoveBusStopToRoute(Marker: TMapMarker);
var
  i: integer;
begin
  for i := 0 to LvbusStop.Items.Count - 1 do
  begin
    if LvBusStop.Items[i].Detail = Marker.Descriptor.Title then
       LvBusStop.Items.Delete(i);
  end;
end;

procedure TAddBusStopForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
