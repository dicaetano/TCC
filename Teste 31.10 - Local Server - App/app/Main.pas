unit Main;

interface

uses
  Aurelius.Engine.ObjectManager, Aurelius.Schema.SQLite, DBConnection, BeaconSensor,
  IOUtils, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Beacon,
  FMX.MultiView, Data.Bind.Components, FMX.Maps, FMX.Objects,
  Data.Bind.ObjectScope, Data.Bind.GenData, Fmx.Bind.GenData, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.MultiView.Types, FMX.Colors, FMX.MultiView.CustomPresentation,
  FMX.MultiView.Presentations, FMX.Edit, FMX.Effects, System.Notification,
  FMX.Gestures, FMX.TabControl, System.Actions, FMX.ActnList, System.ImageList,
  FMX.ImgList, Data.DB, Data.Bind.DBScope, Generics.Collections
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
    TabTestes: TTabItem;
    PnlBotoesTeste: TPanel;
    Panel1: TPanel;
    lvTestes: TListView;
    BtnLimparLista: TButton;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    BtnListarSelecionados: TButton;
    HabilitarBeaconSensor: TSwitch;
    BtnCadastrarSelecionado: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HabilitarBeaconSensorSwitch(Sender: TObject);
    procedure BtnLimparListaClick(Sender: TObject);
    procedure BtnCadastrarSelecionadoClick(Sender: TObject);
    procedure BtnListarSelecionadosClick(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF ANDROID}
    FService : TLocalServiceConnection;
    {$ENDIF}
    FRssiToDistance: TRssiToDistance;
    FTXCount: Integer;
    FTXArray: Array [0..99] of integer;

    FBeaconSensor: TBeaconSensor;
    procedure NewBeaconFound(Beacon: IBeacon);
    function GetLVItem(DeviceId: string): TListViewItem;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  EditConfig, BeaconItem, Routs, BusExitTime, BusLine, BusStop,
  ListBeacons, Utils;

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

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  TDBConnection.GetInstance.CreateObjectManager;
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
begin
  DeviceId := Beacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId);

  if Item = nil then
    Item := lvTestes.Items.Add;
  Item.Text := DeviceId;
  Item.Detail := ProximityToString(Beacon.Proximity)+'-'+Beacon.Distance.ToString+'m';
end;

procedure TfrmPrincipal.BtnCadastrarSelecionadoClick(Sender: TObject);
var
  BeaconItem: TBeaconItem;
  Manager: TObjectManager;
begin
  if LvTestes.Selected = nil then
  begin
    ShowMessage('Selecione um item na lista');
    exit;
  end;
  BeaconItem := TBeaconItem.Create;
  Manager := TDBConnection.GetInstance.CreateObjectManager;
  BeaconItem.UUID := TListViewItem(lvTestes.Selected).Text;
  try
    Manager.Save(BeaconItem);
    ShowMessage(Format('Beacon %s cadastrado.', [BeaconItem.UUID]));
  finally
    Manager.Free;
  end;
end;

procedure TfrmPrincipal.BtnLimparListaClick(Sender: TObject);
begin
  HabilitarBeaconSensor.IsChecked := False;
  lvTestes.Items.Clear;
end;

procedure TfrmPrincipal.BtnListarSelecionadosClick(Sender: TObject);
begin
  ListBeaconsForm := TListBeaconsForm.Create(Self);
  try
{$IFDEF ANDROID}
    ListBeaconsForm.Show;
{$ELSE}
    ListBeaconsForm.ShowModal;
{$ENDIF}
  finally
    ListBeaconsForm.Free;
  end;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  EditConfigForm := TEditConfigForm.Create(Self);
  try
{$IFDEF ANDROID}
    EditConfigForm.Show;
{$ELSE}
    EditConfigForm.ShowModal;
{$ENDIF}
  finally
    EditConfigForm.Free;
  end;
end;

procedure TfrmPrincipal.HabilitarBeaconSensorSwitch(Sender: TObject);
begin
  if not HabilitarBeaconSensor.IsChecked then
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
