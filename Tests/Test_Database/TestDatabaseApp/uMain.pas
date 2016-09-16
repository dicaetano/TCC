unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.Maps, FMX.ListView, System.Notification,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Data.Bind.GenData,
  Fmx.Bind.GenData, Data.Bind.DBScope, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI, Fmx.Bind.Editors, Data.DbxSqlite,
  Data.SqlExpr ,System.Android.Service, System.ImageList, FMX.ImgList,
  FMX.Objects, System.IOUtils;

type
  TForm1 = class(TForm)
    pnlMain: TPanel;
    tbTop: TToolBar;
    TabControl1: TTabControl;
    Lista: TTabItem;
    Mapa: TTabItem;
    SpeedButton1: TSpeedButton;
    LVLinhas: TListView;
    MapView: TMapView;
    Notification: TNotificationCenter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Conexao: TFDConnection;
    BindSourceDB1: TBindSourceDB;
    FDQuery1: TFDQuery;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    TabItem1: TTabItem;
    LVParadas: TListView;
    BindSourceDB2: TBindSourceDB;
    FDQuery2: TFDQuery;
    ImageList1: TImageList;
    LinkFillControlToField2: TLinkFillControlToField;
    QryCreate: TFDQuery;
    FDQuery2ID_BUS_STOP: TFDAutoIncField;
    FDQuery2UUID: TWideStringField;
    FDQuery2LATITUDE: TFloatField;
    FDQuery2LONGITUDE: TFloatField;
    FDQuery2DESCRIPTION: TWideStringField;
    FDTransaction1: TFDTransaction;
    PrototypeBindSource1: TPrototypeBindSource;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ConexaoBeforeConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConexaoAfterConnect(Sender: TObject);
    procedure LVParadasUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }

    FService : TLocalServiceConnection;

    procedure createTables;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TForm1.ConexaoAfterConnect(Sender: TObject);
begin
  createTables;
  FDQuery1.Open();
  FDQuery2.Open();
end;

procedure TForm1.ConexaoBeforeConnect(Sender: TObject);
begin
  Conexao.Params.Values['Database'] :=
    TPath.Combine(TPath.GetDocumentsPath, 'BusDB2.s3db');
end;

procedure TForm1.createTables;
begin
  with QryCreate do
  begin
    Transaction.StartTransaction;
    SQL.Clear;
    SQL.Add('CREATE TABLE IF NOT EXISTS BUS_LINE ( '+
            'ID_BUS_LINE INTEGER PRIMARY KEY AUTOINCREMENT '+
            'NOT NULL, '+
            'DESCRIPTION STRING '+
            ');');
    ExecSQL;
    Transaction.Commit;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if not Conexao.Connected then
    Conexao.Connected := True;
  FService := TLocalServiceConnection.Create;
  FService.startService('TestDatabaseService');
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  Conexao.Connected := False;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  MyMarker: TMapMarkerDescriptor;
  Position: TMapCoordinate;
  i : Integer;
begin
  FDQuery2.First;

  while not FDQuery2.Eof do
  begin
    Position := TMapCoordinate.Create(FDQuery2LATITUDE.AsFloat, FDQuery2LONGITUDE.AsFloat);
    MyMarker := TMapMarkerDescriptor.Create(Position, FDQuery2DESCRIPTION.AsString);
    MyMarker.Draggable := True;
    MyMarker.Visible :=True;
    MapView.AddMarker(MyMarker);

    with LVParadas.Items.Add do begin
      Data['Description'] := FDQuery2DESCRIPTION.AsString;
      Data['StopId'] := FDQuery2ID_BUS_STOP.AsString;
      //Objects.FindObjectT<TListItemImage>('GotoMap').ImageIndex := 0;
         //ImageList1.Source.Items[0].MultiResBitmap[0].Bitmap;
    end;
    FDQuery2.Next;
  end;

  MapView.Location := TMapCoordinate.Create(-28.9360196, -49.482976);
  MapView.Zoom := 10;

end;

procedure TForm1.LVParadasUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TListItemImage(AItem.View.FindDrawable('GotoMap')).Bitmap :=
    Image1.Bitmap;
end;

end.
