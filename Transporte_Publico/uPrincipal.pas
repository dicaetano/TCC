unit uPrincipal;

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
  FMX.MultiView.Presentations, FMX.Edit;

type
  TRssiToDistance = function (ARssi, ATxPower: Integer; ASignalPropagationConst: Single): Double of object;
  TfrmPrincipal = class(TForm)
    PnlPrincipal: TPanel;
    tbTop: TToolBar;
    tbBottom: TToolBar;
    btnMaster: TSpeedButton;
    btnAtualizar: TSpeedButton;
    Beacon: TBeacon;
    Timer1: TTimer;
    ListView1: TListView;
    AniIndicator1: TAniIndicator;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField2: TLinkFillControlToField;
    Label1: TLabel;
    edtDeathTime: TEdit;
    Label2: TLabel;
    edtSPC: TEdit;
    MultiView: TMultiView;
    Panel3: TPanel;
    Label3: TLabel;
    edtScanSleep: TEdit;
    Label4: TLabel;
    edtScanTime: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblDT: TLabel;
    lblSPC: TLabel;
    lblSS: TLabel;
    lblST: TLabel;
    label111: TLabel;
    lblTimer: TLabel;
    edtTimer: TEdit;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure ListView1PullRefresh(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnConfiguracoesClick(Sender: TObject);
    procedure MultiViewShown(Sender: TObject);
    procedure MultiViewHidden(Sender: TObject);
  private
    { Private declarations }
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
   if (ListView1.Items.Count - 1) < Pos then
     LItem := ListView1.Items.Add;
    ListView1.Items[Pos].Text := Line1;
    ListView1.Items[Pos].Detail := Line2;
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
                {
                TKindofBeacon.AltBeacons:
                  if (Supports(FCurrentBeaconList[I], IAltBeacon, LAltBeacon)) then
                  begin
                    ST1 := 'AltBeacon, GUID: ' + LAltBeacon.GUID.ToString+#13+'Major: ' + LAltBeacon.Major.ToString+' Minor: ' + LAltBeacon.Minor.ToString;
                    MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ManufacturerSpecificData;
                    if Length(MSData) = STANDARD_DATA_LENGTH  then // There are BLE Devices that advertise tw0 or more kind of beacons, so The MSData might Change.
                      TX := ShortInt(MSData[Length(MSData) - 1]).ToString
                    else
                      TX := ShortInt(MSData[Length(MSData) - 2]).ToString;
                  end;

                 TKindofBeacon.Eddystones:
                   begin
                     if (Supports(FCurrentBeaconList[I], IEddystoneBeacon, LEddyHandler)) then
                     begin
                       ST1 := 'Eddystone'+#13+' ';
                       MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ServiceData[0].Value;

                       if  (TKindofEddystone.UID in LEddyHandler.KindofEddystones) then
                       begin
                         ST1 := 'Eddystone, UID-NameSpace: '+LEddyHandler.EddystoneUID.NamespaceToString
                           +#13+ 'UID-Instance: '+LEddyHandler.EddystoneUID.InstanceToString;
                         TX := ShortInt(MSData[EDDY_TX_POS] - EDDY_SIGNAL_LOSS_METER).ToString + '/UID';
                       end;

                       if TKindofEddystone.URL in LEddyHandler.KindofEddystones then
                       begin
                         ST2 := ST2 +#13+'URL: ' + LEddyHandler.EddystoneURL.URL;
                         TX := ShortInt(MSData[EDDY_TX_POS] - EDDY_SIGNAL_LOSS_METER).ToString + '/URL';
                       end;

                       if TKindofEddystone.TLM in LEddyHandler.KindofEddystones then
                       begin
                         ST2 := ST2 +#13+'TLM:  BattVol: '+ LEddyHandler.EddystoneTLM.BattVoltageToString +
                         ', B.Temp: '+LEddyHandler.EddystoneTLM.BeaconTempToString;
                         ST2 := ST2 +#13+'  AdvPDUCount: '+LEddyHandler.EddystoneTLM.AdvPDUCountToString+
                         ', SincePOn: '+LEddyHandler.EddystoneTLM.TimeSincePowerOnToString;

                         TX := '/TLM';
                       end;

                     end;
                   end;        }
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

      if (ListView1.Items.Count - 1) > Pos then
        for I := ListView1.Items.Count - 1 downto Pos + 1 do
          ListView1.Items.Delete(I);
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

procedure TfrmPrincipal.btnConfiguracoesClick(Sender: TObject);
begin
//  MultiView2.
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  edtDeathTime.Text := Beacon.BeaconDeathTime.ToString;
  edtSPC.Text := Beacon.SPC.ToString;
  edtScanTime.Text := Beacon.ScanningTime.ToString;
  edtScanSleep.Text := Beacon.ScanningSleepingTime.ToString;
  Beacon.StartScan;
  fillListConfig;
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

    lblDT.Text := Beacon.BeaconDeathTime.ToString;
    lblSPC.Text := Beacon.SPC.ToString;
    lblSS.Text := Beacon.ScanningSleepingTime.ToString;
    lblST.Text := Beacon.ScanningTime.ToString;
    lblTimer.Text := Timer1.Interval.ToString;

    Beacon.Enabled := True;
    Timer1.Enabled := True;
    Beacon.StartScan;
  end;


begin
  salvarConfig;
  btnMaster.StyleLookup := 'drawertoolbutton';
end;

procedure TfrmPrincipal.MultiViewShown(Sender: TObject);
begin
  edtDeathTime.Text := Beacon.BeaconDeathTime.ToString;
  edtSPC.Text := Beacon.SPC.ToString;
  edtScanTime.Text := Beacon.ScanningTime.ToString;
  edtScanSleep.Text := Beacon.ScanningSleepingTime.ToString;
  edtTimer.Text := Timer1.Interval.ToString;
  btnMaster.StyleLookup := 'donetoolbutton';
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  atualizar;
end;

end.
