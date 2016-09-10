//---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit TabbedMap;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Maps, FMX.TabControl, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts, System.Sensors,
  System.Sensors.Components;

type
  TForm2 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    MapPiter: TMapView;
    MapFrisco: TMapView;
    CameraInfo: TLabel;
    ZoomOut: TButton;
    ZoomIn: TButton;
    BitmapSource: TImage;
    Button2: TButton;
    TabItem3: TTabItem;
    MapView1: TMapView;
    BottomToolBar: TToolBar;
    GridPanelLayout1: TGridPanelLayout;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    edLat: TEdit;
    edLong: TEdit;
    btnGO: TButton;
    TrackBar1: TTrackBar;
    LocationSensor1: TLocationSensor;
    TabItem4: TTabItem;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure CameraChanged(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure btnGOClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MapView1MapClick(const Position: TMapCoordinate);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
    { Private declarations }

    procedure SnapShotReady(const Bitmap: TBitmap);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TForm2.ZoomOutClick(Sender: TObject);
begin
  MapPiter.Zoom := MapPiter.Zoom - 1;
  MapFrisco.Zoom := MapFrisco.Zoom - 1;
end;

procedure TForm2.ZoomInClick(Sender: TObject);
begin
  MapPiter.Zoom := MapPiter.Zoom + 1;
  MapFrisco.Zoom := MapFrisco.Zoom + 1;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  //MapPiter.Location := TMapCoordinate.Create(59.965, 30.35);
  MapPiter.Location := TMapCoordinate.Create(-28.936119, -49.492301);
  MapPiter.Zoom := 10;

  MapFrisco.Location := TMapCoordinate.Create(37.82, -122.5);
  MapFrisco.Zoom := 10;
end;

procedure TForm2.LocationSensor1LocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin
  edLat.Text := NewLocation.Latitude.ToString;
  edLong.Text := NewLocation.Longitude.ToString;
end;

procedure TForm2.MapView1MapClick(const Position: TMapCoordinate);
var
  MyMarker: TMapMarkerDescriptor;
begin
  MyMarker := TMapMarkerDescriptor.Create(Position, 'MyMarker');
  MyMarker.Draggable := True;
  MyMarker.Visible :=True;
  MapView1.AddMarker(MyMarker);
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
  MapView1.MapType := TMapType.Normal;
  TrackBar1.Value := 0.0;

end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
  MapView1.MapType := TMapType.Satellite;
  TrackBar1.Value := 0.0;

end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
  MapView1.MapType := TMapType.Hybrid;
  TrackBar1.Value := 0.0;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  MapView1.Bearing := TrackBar1.Value;
end;

procedure TForm2.btnGOClick(Sender: TObject);
var
  mapCenter: TMapCoordinate;
begin
  MapView1.Snapshot(SnapShotReady);
  mapCenter := TMapCoordinate.Create(StrToFloat(edLat.Text, TFormatSettings.Invariant),
    StrToFloat(edLong.Text, TFormatSettings.Invariant));
  MapView1.Location := mapCenter;
end;

procedure TForm2.SnapShotReady(const Bitmap: TBitmap);
begin
  Image1.Bitmap.Assign(Bitmap);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  Descr: TMapMarkerDescriptor;
begin
  Descr := TMapMarkerDescriptor.Create(MapPiter.Location, 'Teste');
  Descr.Icon := BitmapSource.Bitmap;
  BitmapSource.Visible := True;
  Descr.Draggable := True;
  MapPiter.AddMarker(Descr);
end;

procedure TForm2.CameraChanged(Sender: TObject);
begin
  CameraInfo.Text := Format('Camera at %3.3f, %3.3f Zoom=%2f', [TMapView(Sender).Location.Latitude,
    TMapView(Sender).Location.Longitude, TMapView(Sender).Zoom]);
end;

end.
