unit EditConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit,
  Configs, DBConnection, Aurelius.Engine.ObjectManager;

type
  TEditConfigForm = class(TForm)
    ToolBar1: TToolBar;
    btnSair: TSpeedButton;
    edtDeathTime: TEdit;
    lbDeathTime: TLabel;
    lbSPC: TLabel;
    lbScanningSleep: TLabel;
    edtSPC: TEdit;
    edtScanningSleep: TEdit;
    lbScanningTime: TLabel;
    edtScanningTime: TEdit;
    lbTimerScan: TLabel;
    edtTimerScan: TEdit;
    lbServerURL: TLabel;
    edtServerURL: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
     FManager: TObjectManager;
  public
    { Public declarations }
  end;

var
  EditConfigForm: TEditConfigForm;

implementation

uses
 BeaconSensor;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TEditConfigForm.btnConfirmarClick(Sender: TObject);
var
  Config: TConfigs;
begin
  Config := TConfigs.Create;
  try
    Config.DeathTime := edtDeathTime.Text.ToInteger();
    Config.SPC := edtSPC.Text.ToDouble();
    Config.ScanningSleep := edtScanningSleep.Text.ToInteger();
    Config.ScanningTime := edtScanningTime.Text.ToInteger();
    Config.TimerScan := edtTimerScan.Text.ToInteger();
    Config.URLServer := edtServerURL.Text;
    FManager.Save(Config);
  finally
    Config.Free;
  end;
end;

procedure TEditConfigForm.FormCreate(Sender: TObject);
var
  Config: TConfigs;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
  Config := FManager.Find<TConfigs>(1);
  if Assigned(Config) then
  begin
    edtDeathTime.Text := Config.DeathTime.ToString;
    edtSPC.Text := Config.SPC.ToString;
    edtScanningSleep.Text := Config.ScanningSleep.ToString;
    edtScanningTime.Text := Config.ScanningTime.ToString;
    edtTimerScan.Text := Config.TimerScan.ToString;
    edtServerURL.Text := Config.URLServer;
  end;
end;

procedure TEditConfigForm.FormDestroy(Sender: TObject);
begin
  FManager.Free;
end;

procedure TEditConfigForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
