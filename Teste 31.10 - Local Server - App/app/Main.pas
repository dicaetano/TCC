unit Main;

interface

uses
  Aurelius.Mapping.Attributes, Aurelius.Drivers.Interfaces,
  Aurelius.SQL.SQLite, Aurelius.Engine.DatabaseManager,
  Aurelius.Engine.ObjectManager, Aurelius.Mapping.Metadata, DBConnection,
  Aurelius.Drivers.SQLite,  Aurelius.Drivers.AnyDac, Aurelius.Schema.SQLite,
  IOUtils, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FireDAC.DApt,
  FMX.MultiView, Data.Bind.Components, FireDAC.FMXUI.Wait,
  Data.Bind.ObjectScope, Data.Bind.GenData, Fmx.Bind.GenData, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.MultiView.Types, FMX.Colors, FMX.MultiView.CustomPresentation,
  FMX.MultiView.Presentations, FMX.Edit, FMX.Effects, System.Notification,
  FMX.Gestures, FMX.TabControl, System.Actions, FMX.ActnList, System.ImageList,
  FMX.ImgList, Data.DB, Data.Bind.DBScope, Generics.Collections,
  FMX.Maps, FMX.Objects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Comp.UI,
  FireDAC.Comp.Client, Aurelius.Mapping.Setup, Aurelius.Mapping.Explorer,
  Aurelius.Mapping.MappedClasses, Aurelius.Global.Config, BeaconSensor,
  System.Beacon
  {$IFDEF ANDROID}
  ,System.Android.Service
  {$ENDIF}
  ;

type
  TRssiToDistance = function (ARssi, ATxPower: Integer; ASignalPropagationConst: Single): Double of object;
  TfrmPrincipal = class(TForm)
    Timer1: TTimer;
    pnlMain: TPanel;
    tbTop: TToolBar;
    btnMaster: TSpeedButton;
    Label5: TLabel;
    AniIndicator1: TAniIndicator;
    TabControl1: TTabControl;
    Lista: TTabItem;
    TabItem1: TTabItem;
    Mapa: TTabItem;
    MapView: TMapView;
    LVLinhas: TListView;
    LVParadas: TListView;
    Image1: TImage;
    Image2: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    GestureManager1: TGestureManager;
    ImageList1: TImageList;
    Notification: TNotificationCenter;
    SpeedButton1: TSpeedButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDConnection: TFDConnection;
    TabTestes: TTabItem;
    PnlBotoesTeste: TPanel;
    Button1: TButton;
    Panel1: TPanel;
    lvTestes: TListView;
    Switch1: TSwitch;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF ANDROID}
    FService : TLocalServiceConnection;
    {$ENDIF}
    FRssiToDistance: TRssiToDistance;
    FTXCount: Integer;
    FTXArray: Array [0..99] of integer;

    FMappingExplorer: TMappingExplorer;
    FBeaconSensor: TBeaconSensor;

    function Connection: IDBConnection;
    procedure Scann;
    procedure NewBeaconFound(Beacon: IBeacon);
    function GetLVItem(DeviceId: string): TListViewItem;
  public
    { Public declarations }
    MyConnection: IDBConnection;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  EditConfig, BeaconItem, Routs, BusExitTime, BusLine, BusStop;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
  //FService := TLocalServiceConnection.Create;
  //FService.startService('BeaconService');
  {$ENDIF}
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FMappingExplorer.Free;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  DBManager : TDatabaseManager;
  Manager: TObjectManager;
  GlobalConfig: TGlobalConfigs;
  MapSetupSQLite: TMappingSetup;
begin
  FDConnection.Params.Values['Database'] :=
    IOUtils.TPath.Combine(IOUtils.TPath.GetDocumentsPath, 'aurelius.sqlite');
  FDConnection.Connected := True;

//  GlobalConfig := TGlobalConfigs.GetInstance;
  MapSetupSQLite := TMappingSetup.Create;
  try
    MapSetupSQLite.MappedClasses.RegisterClass(TBeaconItem);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusStop);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusLine);
    MapSetupSQLite.MappedClasses.RegisterClass(TRout);
    MapSetupSQLite.MappedClasses.RegisterClass(TBusExitTime);

    FMappingExplorer := TMappingExplorer.Create(MapSetupSQLite);
  finally
    MapSetupSQLite.Free;
  end;

  MyConnection := TAnyDacConnectionAdapter.Create(FDConnection, False);
  DBManager := TDatabaseManager.Create(MyConnection);
  DBManager.UpdateDatabase;
  DBManager.Free;
end;

function TfrmPrincipal.GetLVItem(DeviceId: string): TListViewItem;
var
  Item: TListViewItem;
begin
  Result := nil;
  for Item in lvTestes.Items do
    if Item.Text.Equals(DeviceId) then
      Result := Item;
end;

procedure TfrmPrincipal.NewBeaconFound(Beacon: IBeacon);
var
  Item: TListViewItem;
  DeviceId: string;

  //Colocar em unit BeaconUtils
  function ProximityToString(Proximity: TBeaconProximity): string;
  begin
    case Proximity of
      Immediate: Result := 'Immediate';
      Near: Result := 'Near';
      Far: Result := 'Far';
      Away: Result := 'Away';
    end;
  end;
begin
  DeviceId := Beacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId);

  if Item = nil then
    Item := lvTestes.Items.Add;
  Item.Text := DeviceId;
  Item.Detail := ProximityToString(Beacon.Proximity)+'-'+Beacon.Distance.ToString+'m';
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Scann;
end;

function TfrmPrincipal.Connection: IDBConnection;
begin
  Result := TDBConnection.GetInstance.Connection;
end;

procedure TfrmPrincipal.Scann;
var
  Beacons: TList<IBeacon>;
  Beacon: IBeacon;
  Sensor: TBeaconSensor;
  Item: TListViewItem;
begin
 { Sensor := TBeaconSensor.Create;
  try
    Beacons := Sensor.CurrentBeaconList;
    if Beacon = nil then
      Exit;
    for Beacon in Beacons do
    begin
      Item := lvTestes.Items.Add;
      Item.Text := Beacon.DeviceIdentifier;
      Item.Detail := Beacon.Distance.ToString;
    end;
  finally
    Sensor.Free;
  end;   }
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  EditConfigForm := TEditConfigForm.Create(Self);
  try
    EditConfigForm.Show;
  finally
    EditConfigForm.Free;
  end;
end;

procedure TfrmPrincipal.Switch1Switch(Sender: TObject);
begin
  if not Switch1.IsChecked then
  begin
    FBeaconSensor.Terminate;
    lvTestes.Items.Clear;
    Exit;
  end;

  FBeaconSensor := TBeaconSensor.Create;
  FBeaconSensor.OnNewBeaconFound := NewBeaconFound;
  FBeaconSensor.Start;
end;

end.
