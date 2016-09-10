unit SurfSpotMapView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  IPPeerClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.StdCtrls, FMX.Controls.Presentation, REST.Response.Adapter,
  Data.Bind.DBScope, REST.Client, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Maps,
  FMX.Objects;

type
  TForm26 = class(TForm)
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    LinkFillControlToField3: TLinkFillControlToField;
    LinkFillControlToField4: TLinkFillControlToField;
    RESTClient1: TRESTClient;
    FDMemTable1: TFDMemTable;
    FDMemTable1county_name: TWideStringField;
    FDMemTable1latitude: TWideStringField;
    FDMemTable1longitude: TWideStringField;
    FDMemTable1spot_id: TWideStringField;
    FDMemTable1spot_name: TWideStringField;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    BindSourceDB1: TBindSourceDB;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    SurfSpotDetailsToolbar: TToolBar;
    Label1: TLabel;
    MapView1: TMapView;
    BitmapSource: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form26: TForm26;

implementation

{$R *.fmx}

procedure TForm26.FormCreate(Sender: TObject);
var
  LongitudeField: TField;
  LatitudeField: TField;
  MyLocation: TMapCoordinate;
  Descr: TMapMarkerDescriptor;
  SpotName : TField;
begin
  RESTRequest1.Execute;
begin
  LongitudeField := FDMemtable1.FieldByName('longitude');
  LatitudeField := FDMemtable1.FieldByName('latitude');
  SpotName := FDMemTable1.FieldByName('spot_name');
  FDMemTable1.First;
   while not FDMemTable1.EOF do
    begin
      MyLocation := TMapCoordinate.Create(StrToFloat(LatitudeField.AsWideString),StrToFloat(LongitudeField.AsWideString));
      MapView1.Location :=  MyLocation;
      Descr := TMapMarkerDescriptor.Create(MyLocation, SpotName.AsWideString);
      Descr.Icon := BitmapSource.Bitmap;
      BitmapSource.Visible := True;
      Descr.Draggable := True;
      MapView1.AddMarker(Descr);
      MapView1.Zoom := 8;
      FDMemTable1.Next;
  end;
end;
end;

end.