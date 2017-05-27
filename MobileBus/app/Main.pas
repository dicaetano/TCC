unit Main;

interface

uses
  Aurelius.Engine.ObjectManager, Aurelius.Schema.SQLite, DBConnection,
  IOUtils, System.SysUtils, System.Diagnostics, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Beacon,
  FMX.MultiView, Data.Bind.Components, FMX.Maps, FMX.Objects,
  Data.Bind.ObjectScope, Data.Bind.GenData, Fmx.Bind.GenData, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.MultiView.Types, FMX.Colors, FMX.MultiView.CustomPresentation,
  FMX.MultiView.Presentations, FMX.Edit, FMX.Effects, System.Notification,
  FMX.Gestures, FMX.TabControl, System.Actions, FMX.ActnList, System.ImageList,
  FMX.ImgList, Data.DB, Data.Bind.DBScope, Generics.Collections, FMX.ScrollBox,
  FMX.Memo, System.Bluetooth, System.Beacon.Components,Routes,RoutesController,BusStop,BusLine
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
    BindingsList1: TBindingsList;
    BtnListarSelecionados: TButton;
    HabilitarBeaconSensor: TSwitch;
    BtnCadastrarSelecionado: TButton;
    BtnAddBusStop: TButton;
    BtnAtualizarBanco: TButton;
    BtnAddBusLine: TButton;
    BtnAdd: TButton;
    BtnAddRoute: TButton;
    BtnStartTest: TButton;
    Beacon: TBeacon;
    Button1: TButton;
    BtnListRoutes: TButton;
    MemoEvents: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HabilitarBeaconSensorSwitch(Sender: TObject);
    procedure BtnLimparListaClick(Sender: TObject);
    procedure BtnCadastrarSelecionadoClick(Sender: TObject);
    procedure BtnListarSelecionadosClick(Sender: TObject);
    procedure BtnAddBusStopClick(Sender: TObject);
    procedure BtnAtualizarBancoClick(Sender: TObject);
    procedure BtnAddBusLineClick(Sender: TObject);
    procedure BtnTesteClick(Sender: TObject);
    procedure BtnAddRouteClick(Sender: TObject);
    procedure BtnStartTestClick(Sender: TObject);
    procedure BeaconBeaconExit(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure BeaconBeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure BeaconBeaconProximity(const Sender: TObject;
      const ABeacon: IBeacon; Proximity: TBeaconProximity);
    procedure Button1Click(Sender: TObject);
    procedure BtnListRoutesClick(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF ANDROID}
    FService : TLocalServiceConnection;
    {$ENDIF}
    FRssiToDistance: TRssiToDistance;
    FTXCount: Integer;
    FTXArray: Array [0..99] of integer;
    TestStarted: Boolean;
    AchouPontoPartida: Boolean;
    EntrouOnibus: Boolean;
    Timer :TStopWatch;
    PriorStop: TBusStop;
    NextStop: TBusStop;
    Bus: TBusLine;
    Route: TRoute;
    procedure BeaconUpdate(Beacon: IBeacon);
    procedure SearchForBeacons(const ABeacon: IBeacon);
    procedure SearchForBusStopsBeacons(const ABeacon: IBeacon);
    procedure UpdateRouteTime(Route: TRoute; Time:Double);
  public

  end;
var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  EditConfig, BeaconItem, BusExitTime, AddBusLine,
  ListBeacons, Test, Utils, AddBusStop, Configs, BusStopController, BeaconController,
  ListRoutes,BusLineController;


{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
  //FService := TLocalServiceConnection.Create;
  //TLocalServiceConnection.startService('BeaconService');
  {$ENDIF}
  Timer := TStopwatch.Create;
  Route := TRoute.Create;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  FManager: TObjectManager;
  BusStopController: TBusStopController;
  ListItem: TListViewItem;
begin
  BusStopController := TBusStopController.Create;
  try
    BusStops := BusStopController.GetAll;
    for BusStop in BusStops do
    begin
       ListItem := LVParadas.Items.Add;
       ListItem.IndexTitle := IntToStr(BusStop.ID);
       ListITem.Text := BusStop.Description;
       ListItem.Bitmap := Image1.Bitmap;
    end;
  finally
    BusStopController.Free;
  end;
end;

procedure TfrmPrincipal.BeaconBeaconEnter(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  if TestStarted then
    SearchForBusStopsBeacons(ABeacon)
  else
    SearchForBeacons(ABeacon);
end;

procedure TfrmPrincipal.BeaconBeaconExit(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
var
  Item: TListViewItem;
begin
  for Item in lvTestes.Items do
    if Item.Text.Equals(ABeacon.DeviceIdentifier) then
      lvTestes.Items.Delete(Item.Index);
end;

procedure TfrmPrincipal.BeaconBeaconProximity(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
begin
  if not TestStarted then
    BeaconUpdate(ABeacon)
  else
    SearchForBusStopsBeacons(ABeacon);
end;

procedure TfrmPrincipal.BeaconUpdate(Beacon: IBeacon);
var
  Item: TListViewItem;
  DeviceId: string;
begin
  DeviceId := Beacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId, lvTestes);

  if Item = nil then
    Exit;

  Item.Detail := ProximityToString(Beacon.Proximity)+'-'+Beacon.Distance.ToString+'m';
end;

procedure TfrmPrincipal.BtnAddBusLineClick(Sender: TObject);
begin
  try
    AddBusLineForm := TAddBusLineForm.Create(Self);
    AddBusLineForm.show;
  finally
    AddBusLineForm.Free;
  end;
end;

procedure TfrmPrincipal.BtnAddBusStopClick(Sender: TObject);
begin
  AddBusStopForm := TAddBusStopForm.Create(self);
  try
    AddBusStopForm.Source := ADD_BUS_STOP;
    AddBusStopForm.Show;
  finally
    AddBusStopForm.Free;
  end;
end;

procedure TfrmPrincipal.BtnAddRouteClick(Sender: TObject);
begin
  try
    AddBusStopForm := TAddbusStopForm.Create(Self);
    AddBusStopForm.Source :=  ADD_ROUTS;
    AddBusStopForm.Show
  finally
    AddBusStopForm.Free;
  end;
end;

procedure TfrmPrincipal.BtnAtualizarBancoClick(Sender: TObject);
begin
  TDBConnection.GetInstance.GetNewDatabaseManager.BuildDatabase;
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

procedure TfrmPrincipal.BtnListRoutesClick(Sender: TObject);
begin
  FrmListRoutes := TFrmListRoutes.Create(Self);
  try
     FrmListRoutes.Show;
  finally
    FrmListRoutes.Free;
  end;
end;

procedure TfrmPrincipal.BtnStartTestClick(Sender: TObject);
begin
  TestStarted := True;
  PriorStop := nil;
  NextStop := nil;
  Bus := nil;
  AchouPontoPartida := False;
  EntrouOnibus := False;
  MemoEvents.Lines.Clear;
  HabilitarBeaconSensor.IsChecked := True;
  HabilitarBeaconSensorSwitch(Sender);
end;

procedure TfrmPrincipal.BtnTesteClick(Sender: TObject);
begin
  TestForm := TTestForm.Create(Self);
  try
  {$IFDEF ANDROID}
    TestForm.Show;
  {$ELSE}
    TestForm.ShowModal;
  {$ENDIF}
  finally
    TestForm.Free;
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
 TDBConnection.GetInstance.GetNewDatabaseManager.DestroyDatabase;
 TDBConnection.GetInstance.GetNewDatabaseManager.BuildDatabase;
end;

procedure TfrmPrincipal.SearchForBeacons(const ABeacon: IBeacon);
var
  Item: TListViewItem;
  DeviceId: string;
begin
  DeviceId := ABeacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId, lvTestes);

  if Item = nil then
    Item := lvTestes.Items.Add;
  Item.Text := DeviceId;
  Item.Detail := FloatToStr(ABeacon.Distance)+'-'+ABeacon.Distance.ToString+'m';
end;

procedure TfrmPrincipal.SearchForBusStopsBeacons(const ABeacon: IBeacon);
var
  DeviceID: string;
  BusStopController: TBusStopController;
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  BusLine: TBusLine;
  BusLines: TList<TBusLine>;
  BusLineController: TBusLineController;
  RouteController: TRouteController;
  Route: TRoute;
begin
  BusStopController := TBusStopController.Create;
  BusStops := BusStopController.GetAll;
  DeviceId := ABeacon.DeviceIdentifier;
  BusLineController := TBusLineController.Create;
  BusLines := BusLineController.getAll;
  for BusStop in BusStops do
  begin
    if DeviceId = BusStop.getBeacon.UUID then
    begin
      if (PriorStop = nil) and (not AchouPontoPartida) and (ABeacon.Proximity  = TBeaconProximity.Near) then
      begin
        PriorStop := BusStop;
        AchouPontoPartida := True;
         MemoEvents.Lines.Add(Format('Parada encontrada : %s Hora: %s',
          [BusStop.Description,DateTimeToStr(Now)]));
      end;
      if (AchouPontoPartida) and (EntrouOnibus) and (ABeacon.Proximity = TBeaconProximity.Near) then
      begin
        NextStop := BusStop;
        Timer.Stop;
        RouteController := TRouteController.Create;
        Route := RouteController.GetRouteIfExists(Bus,PriorStop,NextStop);
        if Route <> nil then
          UpdateRouteTime(Route,Timer.Elapsed.TotalMinutes);
        MemoEvents.Lines.Add(Format('Parada encontrada : %s Hora: %s',
          [BusStop.Description,DateTimeToStr(Now)]));
      end;
    end;
  end;
  if (not EntrouOnibus) and (AchouPontoPartida) and (ABeacon.Proximity = TBeaconProximity.Far) then
  begin
    for BusLine in BusLines do
    begin
      if BusLine.Beacon.UUID = DeviceID then
      begin
         Bus := BusLine;
         EntrouOnibus := True;
         Timer.Start;
         MemoEvents.Lines.Add(Format('Entrou no onibus: %s Hora %s',
                  [BusLine.Description,DateTimeToStr(Now)]));
      end;
    end;
  end;
  BusStops.Free;
  BusLineController.Free;
  BusLines.Free;
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

procedure TfrmPrincipal.UpdateRouteTime(Route: TRoute; Time: Double);
var
  RouteController: TRouteController;
begin
  RouteController := TRouteController.Create;
  if Route.BusRouteTime = 0 then
    Route.BusRouteTime := Time
  else
    Route.BusRouteTime := ((Route.BusRouteTime + Time)/2.0);
  RouteController.Update(Route);
end;

procedure TfrmPrincipal.HabilitarBeaconSensorSwitch(Sender: TObject);
begin
  if not HabilitarBeaconSensor.IsChecked then
  begin
    Beacon.Enabled := False;
    lvTestes.Items.Clear;
    Exit;
  end;
  Beacon.Enabled := True;
end;

end.
