unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Android.Service,
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
  FireDAC.Comp.UI, Fmx.Bind.Editors, System.IOUtils;

type
  TForm1 = class(TForm)
    pnlMain: TPanel;
    tbTop: TToolBar;
    TabControl1: TTabControl;
    Lista: TTabItem;
    Mapa: TTabItem;
    SpeedButton1: TSpeedButton;
    ListView: TListView;
    MapView: TMapView;
    Notification: TNotificationCenter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Conexao: TFDConnection;
    QueryCreate: TFDQuery;
    QryInsert: TFDQuery;
    QryDelete: TFDQuery;
    BindingsList1: TBindingsList;
    PrototypeBindSource1: TPrototypeBindSource;
    BindSourceDB1: TBindSourceDB;
    FDQuery2: TFDQuery;
    LinkFillControlToFieldDESCRIPTION: TLinkFillControlToField;
    QryConsulta: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure NotificationReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);
    procedure ConexaoBeforeConnect(Sender: TObject);
  private
    { Private declarations }

    FService : TLocalServiceConnection;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TForm1.ConexaoBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  Conexao.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'BusDB.db');
  {$ENDIF}
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FService := TLocalServiceConnection.Create;
  FService.startService('TestDatabaseService');
end;

procedure TForm1.NotificationReceiveLocalNotification(Sender: TObject;
  ANotification: TNotification);
  var
    ListItem : TListViewItem;
begin
//
end;

end.
