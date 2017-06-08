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
  FMX.Memo, System.Bluetooth, System.Beacon.Components,Routes,RoutesController,BusStop,BusLine, FMX.Layouts, FMX.ListBox,
  FMX.SearchBox
  {$IFDEF ANDROID}
  ,System.Android.Service
  {$ENDIF}
  ;

type
  TRssiToDistance = function (ARssi, ATxPower: Integer; ASignalPropagationConst: Single): Double of object;
  TMainForm = class(TForm)
    Timer1: TTimer;
    pnlMain: TPanel;
    tbTop: TToolBar;
    btnMaster: TSpeedButton;
    AniIndicator1: TAniIndicator;
    TabControl1: TTabControl;
    Mapa: TTabItem;
    MapView: TMapView;
    ActionList1: TActionList;
    Action1: TAction;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    GestureManager1: TGestureManager;
    ImageList1: TImageList;
    Notification: TNotificationCenter;
    SpeedButton1: TSpeedButton;
    TabTestes: TTabItem;
    PnlBotoesTeste: TScrollBox;
    BtnLimparLista: TSpeedButton;
    BindingsList1: TBindingsList;
    BtnListarSelecionados: TSpeedButton;
    HabilitarBeaconSensor: TSwitch;
    BtnCadastrarSelecionado: TSpeedButton;
    BtnAddBusStop: TSpeedButton;
    BtnAtualizarBanco: TSpeedButton;
    BtnAddBusLine: TSpeedButton;
    BtnAdd: TSpeedButton;
    BtnAddRoute: TSpeedButton;
    BtnStartTest: TSpeedButton;
    Beacon: TBeacon;
    BtnListRoutes: TSpeedButton;
    MapView2: TMapView;
    Image4: TImage;
    Timer2: TTimer;
    Button4: TSpeedButton;
    Panel1: TPanel;
    lvTestes: TListView;
    pnAtualizarZerarBD: TPanel;
    Button6: TSpeedButton;
    Button7: TSpeedButton;
    StyleBook1: TStyleBook;
    Image1: TImage;
    Image2: TImage;
    TabControl2: TTabControl;
    tabTeste: TTabItem;
    tabHorarios: TTabItem;
    Panel2: TPanel;
    Label1: TLabel;
    btnIniciar: TSpeedButton;
    MemoEvents: TMemo;
    btnLimpar: TSpeedButton;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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
    procedure Button4Click(Sender: TObject);
    procedure MapView2MarkerDoubleClick(Marker: TMapMarker);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure NotificationReceiveLocalNotification(Sender: TObject; ANotification: TNotification);
    procedure BtnListRoutesClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure pnAtualizarZerarBDExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchBox1Enter(Sender: TObject);
    procedure SearchBox1Exit(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
  private
    { Private declarations }
    {$IFDEF ANDROID}
    FService : TLocalServiceConnection;
    {$ENDIF}
    FPrior, FNext: TBusStop;
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
    UpdatedRoute: TRoute;
    FMarkerList: TList<TMapMarker>;
    procedure BeaconUpdate(Beacon: IBeacon);
    procedure AddBeaconInfoToListView(const ABeacon: IBeacon);
    procedure SearchForBusStopsBeacons(const ABeacon: IBeacon);
    procedure UpdateRouteTime(Route: TRoute; Time:Double);
  public
    procedure CarregarParadasMapa(BusID: Integer = -1);
  end;
var
  MainForm: TMainForm;

implementation

uses
  EditConfig, BeaconItem, BusExitTime, AddBusLine,
  ListBeacons, Test, Utils, AddBusStop, Configs, BusStopController, BeaconController,
  ListRoutes,BusLineController, AddExitTime, BusExitController, System.Threading;


{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  IPServer := '192.168.0.6:2002';
  {$IFDEF ANDROID}
  FService := TLocalServiceConnection.Create;
  FService.startService('BeaconService');
  FService.bindService('BeaconService');
  {$ENDIF}
  Timer := TStopwatch.Create;
  Route := TRoute.Create;
  UpdatedRoute := TRoute.Create;
  FMarkerList := TList<TMapMarker>.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMarkerList.Free;
  Route.Free;
  UpdatedRoute.Free;
end;

procedure TMainForm.BeaconBeaconEnter(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  if TestStarted then
    SearchForBusStopsBeacons(ABeacon)
  else
    AddBeaconInfoToListView(ABeacon);
end;

procedure TMainForm.BeaconBeaconExit(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
var
  Item: TListViewItem;
begin
  for Item in lvTestes.Items do
    if Item.Text.Equals(ABeacon.DeviceIdentifier) then
      lvTestes.Items.Delete(Item.Index);
end;

procedure TMainForm.BeaconBeaconProximity(const Sender: TObject;
  const ABeacon: IBeacon; Proximity: TBeaconProximity);
begin
  if not TestStarted then
    BeaconUpdate(ABeacon)
  else
    SearchForBusStopsBeacons(ABeacon);
end;

procedure TMainForm.BeaconUpdate(Beacon: IBeacon);
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

procedure TMainForm.BtnAddBusLineClick(Sender: TObject);
begin
  try
    AddBusLineForm := TAddBusLineForm.Create(Self);
    AddBusLineForm.show;
  finally
    AddBusLineForm.Free;
  end;
end;

procedure TMainForm.BtnAddBusStopClick(Sender: TObject);
begin
  AddBusStopForm := TAddBusStopForm.Create(self);
  try
    AddBusStopForm.Source := ADD_BUS_STOP;
    AddBusStopForm.Show;
  finally
    AddBusStopForm.Free;
  end;
end;

procedure TMainForm.BtnAddRouteClick(Sender: TObject);
begin
  try
    AddBusStopForm := TAddbusStopForm.Create(Self);
    AddBusStopForm.Source :=  ADD_ROUTS;
    AddBusStopForm.Show
  finally
    AddBusStopForm.Free;
  end;
end;

procedure TMainForm.BtnAtualizarBancoClick(Sender: TObject);
begin
  pnAtualizarZerarBD.Visible := True;
end;

procedure TMainForm.BtnCadastrarSelecionadoClick(Sender: TObject);
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
  BeaconItem.MAC := TListViewItem(lvTestes.Selected).Text;
  BeaconItem.UUID := TListViewItem(lvTestes.Selected).ButtonText;
  try
    Manager.Save(BeaconItem);
    ShowMessage(Format('Beacon %s cadastrado.', [BeaconItem.UUID]));
  finally
    Manager.Free;
  end;
end;

procedure TMainForm.BtnLimparListaClick(Sender: TObject);
begin
  HabilitarBeaconSensor.IsChecked := False;
  lvTestes.Items.Clear;
end;

procedure TMainForm.BtnListarSelecionadosClick(Sender: TObject);
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

procedure TMainForm.BtnListRoutesClick(Sender: TObject);
begin
  FrmListRoutes := TFrmListRoutes.Create(Self);
  try
{$IFDEF ANDROID}
    FrmListRoutes.Show;
{$ELSE}
    FrmListRoutes.ShowModal;
{$ENDIF}
  finally
    FrmListRoutes.Free;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  AddExitTimeForm := TAddExitTimeForm.Create(Self);
  try
{$IFDEF ANDROID}
    AddExitTimeForm.Show;
{$ELSE}
    AddExitTimeForm.ShowModal;
{$ENDIF}
  finally
    AddExitTimeForm.Free;
  end;
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  TDBConnection.GetInstance.GetNewDatabaseManager.DestroyDatabase;
  TDBConnection.GetInstance.GetNewDatabaseManager.BuildDatabase;
  pnAtualizarZerarBD.Visible := False;
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  TDBConnection.GetInstance.GetNewDatabaseManager.UpdateDatabase;
  pnAtualizarZerarBD.Visible := False;
end;

procedure TMainForm.CarregarParadasMapa(BusID: Integer = -1);
var
  BusStops: TList<TBusStop>;
  BusStop: TBusStop;
  MapIcon: TMapMarkerDescriptor;
  Coordinate: TMapCoordinate;
  BusStopCtr: TBusStopController;
  Marker: TMapMarker;
  s: TSizeF;
begin
  for Marker in FMarkerList do
    Marker.Remove;
  BusStopCtr := TBusStopController.Create;
  BusStops := BusStopCtr.GetAll;
  for BusStop in BusStops do
  begin
    Coordinate.Latitude := BusStop.Latitude;
    Coordinate.Longitude := BusStop.Longitude;
    MapIcon := TMapMarkerDescriptor.Create(Coordinate,BusStop.Description);
    MapIcon.Draggable := True;
    MapIcon.Title := BusStop.Description;
    if BusStop.ID = BusID then
    begin
      //s := TSizeF.Create(16, 16);
      //MapIcon.Icon := ImageList1.Bitmap(s, 1);
      MapIcon.Icon := Image2.Bitmap;
    end
    else
    begin
      //s := TSizeF.Create(16, 16);
      //MapIcon.Icon := ImageList1.Bitmap(s, 0);
      MapIcon.Icon := Image1.Bitmap;
    end;
    MapIcon.Visible := True;
    FMarkerList.Add(MapView2.AddMarker(MapIcon));
  end;

  if BusStops.Count > 0 then
  begin
    MapView2.Location := TMapCoordinate.Create(BusStops.Last.Latitude, BusStops.Last.Longitude);
    MapView2.Zoom := 15;
  end;
  BusStopCtr.Free;
end;

procedure TMainForm.BtnStartTestClick(Sender: TObject);
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

procedure TMainForm.BtnTesteClick(Sender: TObject);
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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TDBConnection.GetInstance.GetNewDatabaseManager.DestroyDatabase;
  TDBConnection.GetInstance.GetNewDatabaseManager.BuildDatabase;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  FPrior := nil;
  FNext := nil;
  MemoEvents.Text := '';
  Label1.Text := 'Selecione dois pontos';
  Timer2.Enabled := False;
end;

procedure TMainForm.AddBeaconInfoToListView(const ABeacon: IBeacon);
var
  Item: TListViewItem;
  DeviceId: string;
begin
  DeviceId := ABeacon.DeviceIdentifier;
  Item := GetLVItem(DeviceId, lvTestes);

  if Item = nil then
    Item := lvTestes.Items.Add;
  Item.Text := DeviceId;
  Item.Detail := ProximityToString(ABeacon.Proximity)+'-'+ABeacon.Distance.ToString+'m';
  Item.ButtonText := ABeacon.GUID.ToString;
end;

procedure TMainForm.SearchBox1Enter(Sender: TObject);
begin
  MapView2.Visible := False;
end;

procedure TMainForm.SearchBox1Exit(Sender: TObject);
begin
  MapView2.Visible := True;
end;

procedure TMainForm.SearchForBusStopsBeacons(const ABeacon: IBeacon);
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
        Route := RouteController.GetRouteIfExists(PriorStop,NextStop,Bus);
        if Route <> nil then
          UpdateRouteTime(Route,(Timer.Elapsed.Seconds));
        MemoEvents.Lines.Add(Format('Parada encontrada : %s Hora: %s',
          [BusStop.Description,DateTimeToStr(Now)]));
      end;
    end;
  end;
  if (not EntrouOnibus) and (AchouPontoPartida) and (ABeacon.Proximity = TBeaconProximity.Near) then
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

procedure TMainForm.SpeedButton1Click(Sender: TObject);
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

procedure TMainForm.Timer2Timer(Sender: TObject);
var
  RouteController: TRouteController;
begin

  if (FPrior <> nil) and (FNext <> nil) then
  begin
    RouteController := TRouteController.Create;
    UpdatedRoute := RouteController.GetRouteIfExists(FPrior,FNext);
    try
      MemoEvents.Lines.Clear;
      RouteController.Refresh(UpdatedRoute);
      MemoEvents.Lines.Add(Format('Rota: %s - %s -- tempo médio %s segundos',
        [UpdatedRoute.PriorStop.Description,UpdatedRoute.NextStop.Description,UpdatedRoute.BusRouteTime.ToString]));
    finally
      RouteController.Free;
    end;
  end;
end;

procedure TMainForm.UpdateRouteTime(Route: TRoute; Time: Double);
var
  RouteController: TRouteController;
begin
  RouteController := TRouteController.Create;
  if Route.BusRouteTime = 0 then
    Route.BusRouteTime := Time
  else
    Route.BusRouteTime := ((Route.BusRouteTime+Time)/2.0);
  RouteController.Update(Route);
end;

procedure TMainForm.HabilitarBeaconSensorSwitch(Sender: TObject);
begin
  if not HabilitarBeaconSensor.IsChecked then
  begin
    Beacon.Enabled := False;
    lvTestes.Items.Clear;
    Exit;
  end;
  Beacon.Enabled := True;
end;

procedure TMainForm.ListBox1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  showmessage('Mostrar rotas e preço da linha');
end;

procedure TMainForm.MapView2MarkerDoubleClick(Marker: TMapMarker);
var
  RouteController: TRouteController;
  Route: TRoute;

  function GetBusStop(description:String):TBusStop;
  var
    BusStopCtr: TBusStopController;
  begin
    BusStopCtr := TBusStopController.Create;
    try
      Result := BusStopCtr.GetBusStopByDescription(description.Trim);
    finally
      BusStopCtr.Free;
    end;
  end;
begin
  if FPrior = nil then
  begin
    FPrior := GetBusStop(Marker.Descriptor.Title);
    Label1.Text := 'Selecione o destino';
  end
  else
  begin
    Timer2.Enabled := True;
    FNext := GetBusStop(Marker.Descriptor.Title);
    RouteController := TRouteController.Create;
    UpdatedRoute := RouteController.GetRouteIfExists(FPrior, FNext);
    MemoEvents.Lines.Add(Format('Rota: %s - %s tempo médio %s segundos',
      [UpdatedRoute.PriorStop.Description,UpdatedRoute.NextStop.Description,UpdatedRoute.BusRouteTime.ToString]));
    Label1.Text := 'Mostrando dados da rota';
  end;
end;

procedure TMainForm.NotificationReceiveLocalNotification(Sender: TObject; ANotification: TNotification);
begin
  TTask.Run(
    procedure
    var
      UUID: string;
      BusLine: TBusLine;
      BusExitList: TList<TBusExitTime>;
      BusExit: TBusExitTime;
      BusExitCtr: TBusExitController;
      BusStop: TBusStop;
      BSCtrl: TBusStopController;
      BusLineList: TList<TBusLine>;
      RouteCtrl: TRouteController;
      ListBoxItem : TListBoxItem;
      ListBoxGroupHeader : TListBoxGroupHeader;

      s: string;
      procedure show(s: string);
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            ShowMessage(s);
          end
        );
      end;

    begin
      TThread.Synchronize(nil,
        procedure
        begin
          AniIndicator1.Enabled := True;
          AniIndicator1.Visible := True;
        end
      );
      UUID := ANotification.AlertAction;
      BusExitCtr := TBusExitController.create;
      BSCtrl := TBusStopController.Create;
      BusStop := BSCtrl.getByUUID(UUID);
      RouteCtrl := TRouteController.Create;
      try
        if Assigned(BusStop) then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              Mapa.IsSelected := True;
              tabHorarios.IsSelected := True;
              CarregarParadasMapa(BusStop.ID);
            end
          );

          BusLineList := RouteCtrl.getLinesByBusStop(BusStop);
          for BusLine in BusLineList do
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                ListBox1.BeginUpdate;
                ListBoxGroupHeader := TListBoxGroupHeader.Create(ListBox1);
                ListBoxGroupHeader.Text := BusLine.Description;
                ListBox1.AddObject(ListBoxGroupHeader);
              end
            );
            BusExitList := BusExitCtr.getTimes(BusLine);
            for BusExit in BusExitList do
            begin
              TThread.Synchronize(nil,
                procedure
                begin
                  ListBoxItem := TListBoxItem.Create(ListBox1);
                  ListBoxItem.Text := Format('Horário: %s - Dia - %s', [BusExit.ExitTime, WeekDayToStr(BusExit.WeekDay)]);
                  ListBoxItem.ItemData.Detail := BusLine.Description;
                  ListBoxItem.ItemData.Accessory := TListBoxItemData.TAccessory(1);
                  ListBox1.AddObject(ListBoxItem);
                end
              );
            end;
            ListBox1.EndUpdate;
          end;
        end;
      finally
        BusExitCtr.Free;
        RouteCtrl.Free;
      end;
      TThread.Synchronize(nil,
        procedure
        begin
          AniIndicator1.Enabled := False;
          AniIndicator1.Visible := False;
        end
      );
    end
  );
end;

procedure TMainForm.pnAtualizarZerarBDExit(Sender: TObject);
begin
  pnAtualizarZerarBD.Visible := False;
end;

end.
