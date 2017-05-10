unit addRoutsForms;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Maps, FMX.ListBox, Generics.Collections;

type
  TaddRoutsForm = class(TForm)
    MapView: TMapView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    CbbBusLines: TComboBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  addRoutsForm: TaddRoutsForm;

implementation

uses BusStopController,BusLineController, BusLine,BusStop;
{$R *.fmx}

procedure TaddRoutsForm.FormShow(Sender: TObject);
var
  BusStopController: TBusStopController;
  BusLineController: TBusLineController;
  BusLines: TList<TBusLine>;
  BusStops: TList<TBusStop>;
  BusLine: TBusLine;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Coordinates: TMapCoordinate;
begin
  BusStopController := TBusStopController.Create;
  BusLineController := TBusLineController.Create;
  BusStop := TBusStop.Create;
  BusLine := TBusLine.Create;
  try
    BusLines := BusLineController.GetAll;
    BusStops := BusStopController.GetAll;
    
    for BusLine in BusLines do
      CbbBusLines.Items.AddPair(BusLine.ID.ToString,BusLine.Description);  
    for BusStop in BusStops do
    begin
      Coordinates.Latitude := BusStop.Latitude;
      Coordinates.Longitude := BusStop.Longitude;
      MapIcon := TMapMarkerDescriptor.Create(Coordinates,BusStop.Description);
    end;  
  finally
    BusStopController.Free;
    BusLineController.Free;
    BusStop.Free;
    BusLine.Free;
  end;
end;

procedure TaddRoutsForm.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

end.
