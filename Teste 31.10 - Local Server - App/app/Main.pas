unit Main;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Beacon, System.Bluetooth,
  System.Beacon.Components, FMX.MultiView, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.Bind.GenData, Fmx.Bind.GenData, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.MultiView.Types, FMX.Colors, FMX.MultiView.CustomPresentation,
  FMX.MultiView.Presentations, FMX.Edit, FMX.Effects, System.Notification,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FMX.Gestures, FMX.TabControl,
  System.Actions, FMX.ActnList, FireDAC.Comp.Client, System.ImageList,
  FMX.ImgList, Data.DB, FireDAC.Comp.DataSet, Data.Bind.DBScope,
  FireDAC.Comp.UI, FMX.Maps, FMX.Objects, System.Android.Service;

type
  TRssiToDistance = function (ARssi, ATxPower: Integer; ASignalPropagationConst: Single): Double of object;
  TfrmPrincipal = class(TForm)
    Beacon: TBeacon;
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
    BindSourceDB1: TBindSourceDB;
    BindSourceDB2: TBindSourceDB;
    Conexao: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    FDQuery2ID_BUS_STOP: TFDAutoIncField;
    FDQuery2UUID: TWideStringField;
    FDQuery2LATITUDE: TFloatField;
    FDQuery2LONGITUDE: TFloatField;
    FDQuery2DESCRIPTION: TWideStringField;
    FDTransaction1: TFDTransaction;
    GestureManager1: TGestureManager;
    ImageList1: TImageList;
    Notification: TNotificationCenter;
    QryCreate: TFDQuery;
    MultiView: TMultiView;
    Label3: TLabel;
    edtScanSleep: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    edtScanTime: TEdit;
    edtDeathTime: TEdit;
    edtSPC: TEdit;
    Label4: TLabel;
    edtTimer: TEdit;
    BevelEffect1: TBevelEffect;
    Label9: TLabel;
    ToolBar1: TToolBar;
    BtnDone: TSpeedButton;
    AniIndicator2: TAniIndicator;
    StyleBookAndroid: TStyleBook;
    StyleBookWindows: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure ListView1PullRefresh(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MultiViewShown(Sender: TObject);
    procedure MultiViewHidden(Sender: TObject);
  private
    { Private declarations }
    FService : TLocalServiceConnection;
    FBeacon : IBeacon;
    FRssiToDistance: TRssiToDistance;
    FCurrentBeaconList: TBeaconList;
    FTXCount: Integer;
    FTXArray: Array [0..99] of integer;
    FBluetoothLEDeviceList: TBluetoothLEDeviceList;

    procedure atualizar;
    procedure fillListConfig;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TfrmPrincipal.atualizar;
var
  I,B: Integer;
  Pos, NOfDevices: Integer;
  ST1, ST2, TX: string;
  DeviceName, DeviceIdentifier: string;
  LEddystoneTLM: TEddystoneTLM;
  LEddyHandler: IEddystoneBeacon;
  LiBeacon: IiBeacon;
  LAltBeacon: IAltBeacon;
  MSData: TBytes;

  procedure PrintIt(const Line1: string = ''; const Line2: string = '');
  var
    LItem: TListViewItem;
  begin
   Inc(Pos);
   if (LVParadas.Items.Count - 1) < Pos then
     LItem := LVParadas.Items.Add;
    LVParadas.Items[Pos].Text := Line1;
    LVParadas.Items[Pos].Detail := Line2;
  end;

begin
  try
    FCurrentBeaconList := Beacon.BeaconList;

    // This is a Backdoor to get acces to the BLE devices (TBluetoothLEDevice) associated to Beacons.
    if FBluetoothLEDeviceList = nil then
      FBluetoothLEDeviceList := TBluetoothLEManager.Current.LastDiscoveredDevices;

    Pos := -1;

    if Length(FCurrentBeaconList) > 0 then
    begin
      // The access to BLE Devices is not Thread Safe so we must protect it under its objectList Monitor
      TMonitor.Enter(FBluetoothLEDeviceList);
      try
        NOfDevices := FBluetoothLEDeviceList.Count;

        for B := 0 to NOfDevices - 1 do
        begin
          DeviceIdentifier := FBluetoothLEDeviceList[B].Identifier;
          DeviceName := FBluetoothLEDeviceList[B].DeviceName;
          if DeviceName = '' then
            DeviceName := 'No Name';

          for I := 0 to Length(FCurrentBeaconList) - 1 do
            if (FCurrentBeaconList[I] <> nil) and (FCurrentBeaconList[I].itsAlive) and
              ((DeviceIdentifier = FCurrentBeaconList[I].DeviceIdentifier)) then // There are BLE Devices that advertised two or more kind of beacons.
            begin
              ST1 := '';
              ST2 := '';
              TX := '';
              case FCurrentBeaconList[I].KindofBeacon of
                TKindofBeacon.iBeacons:
                  if (Supports(FCurrentBeaconList[I], IiBeacon, LiBeacon)) then
                  begin
                    ST1 := 'iBeacon, GUID: ' + LiBeacon.GUID.ToString+#13+'Major: ' + LiBeacon.Major.ToString+' Minor: ' + LiBeacon.Minor.ToString;
                    MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ManufacturerSpecificData;
                    if Length(MSData) = STANDARD_DATA_LENGTH  then // There are BLE Devices that advertised two or more kind of beacons, so The MSData might Change.
                      TX := ShortInt(MSData[Length(MSData) - 1]).ToString
                    else
                      TX := ShortInt(MSData[Length(MSData) - 2]).ToString;
                  end;
               end;

             ST2 := ST2 +#13+ DeviceName + ', ID: '+   DeviceIdentifier+#13;
             ST2 := ST2 +'TX: '+TX+', ';
             ST2 := ST2+'RSSI:'+FCurrentBeaconList[I].Rssi.ToString+', Distance: '+FCurrentBeaconList[I].Distance.ToString+' m';
             PrintIt(ST1,ST2);
           end;
        end;

      finally
        TMonitor.Exit(FBluetoothLEDeviceList);
      end;

      if (LVParadas.Items.Count - 1) > Pos then
        for I := LVParadas.Items.Count - 1 downto Pos + 1 do
          LVParadas.Items.Delete(I);
    end;

  except
    On E : Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  if not(Beacon.Enabled) then
  begin
    Beacon.Enabled := True;
  end
  else
  begin
    Beacon.StartScan;
  end;

  Timer1.Enabled := True;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  edtDeathTime.Text := Beacon.BeaconDeathTime.ToString;
  edtSPC.Text := Beacon.SPC.ToString;
  edtScanTime.Text := Beacon.ScanningTime.ToString;
  edtScanSleep.Text := Beacon.ScanningSleepingTime.ToString;
  Beacon.StartScan;
  fillListConfig;

  FService := TLocalServiceConnection.Create;
  FService.startService('BeaconService');
end;

procedure TfrmPrincipal.fillListConfig;
var
  i : Integer;
  LItem: TListViewItem;
begin
  {LItem := ListView2.Items.Add;
  LItem.Text := 'Death Time';
  LItem.Detail := Beacon.BeaconDeathTime.ToString;

  LItem := ListView2.Items.Add;
  LItem.Text := 'SPC';
  LItem.Detail := Beacon.SPC.ToString;}
end;

procedure TfrmPrincipal.ListView1PullRefresh(Sender: TObject);
begin
  Beacon.StartScan;
end;

procedure TfrmPrincipal.MultiViewHidden(Sender: TObject);

  procedure salvarConfig;
  begin
    Timer1.Enabled := False;
    Beacon.StopScan;
    Beacon.Enabled := False;

    Beacon.BeaconDeathTime := edtDeathTime.Text.ToInteger();
    Beacon.SPC := edtSPC.Text.ToSingle();
    Beacon.ScanningTime := edtScanTime.Text.ToInteger();
    Beacon.ScanningSleepingTime := edtScanSleep.Text.ToInteger();
    Timer1.Interval := edtTimer.Text.ToInteger();

    Beacon.Enabled := True;
    Timer1.Enabled := True;
    Beacon.StartScan;
  end;


begin
  salvarConfig;
  MultiView.MasterButton := BtnMaster;
end;

procedure TfrmPrincipal.MultiViewShown(Sender: TObject);
begin
  edtDeathTime.Text := Beacon.BeaconDeathTime.ToString;
  edtSPC.Text := Beacon.SPC.ToString;
  edtScanTime.Text := Beacon.ScanningTime.ToString;
  edtScanSleep.Text := Beacon.ScanningSleepingTime.ToString;
  edtTimer.Text := Timer1.Interval.ToString;

  MultiView.MasterButton := BtnDone;
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  atualizar;
end;

end.
