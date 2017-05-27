unit EditConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit,
  Configs, DBConnection, Aurelius.Engine.ObjectManager,
  Aurelius.Criteria.Linq, Aurelius.Criteria.Projections, Generics.Collections;

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
    BtnConfirmar: TButton;
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
     FManager: TObjectManager;
  public
    { Public declarations }
  end;

var
  EditConfigForm: TEditConfigForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TEditConfigForm.btnConfirmarClick(Sender: TObject);
var
  Configs: TList<TConfigs>;
  Config: TConfigs;
begin
  Configs := FManager.Find<TConfigs>
    .Take(1)
    .OrderBy('ID').List;
  if Assigned(Configs) and (Configs.Count > 0) then
    Config := Configs.First
  else
    Config := TConfigs.Create;
  Config.DeathTime := edtDeathTime.Text.ToInteger();
  Config.SPC := edtSPC.Text.ToDouble();
  Config.ScanningSleep := edtScanningSleep.Text.ToInteger();
  Config.ScanningTime := edtScanningTime.Text.ToInteger();
  Config.TimerScan := edtTimerScan.Text.ToInteger();
  Config.URLServer := edtServerURL.Text;
  FManager.SaveOrUpdate(Config);
  FManager.Flush;
end;

procedure TEditConfigForm.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TEditConfigForm.FormCreate(Sender: TObject);
var
  Configs: TList<TConfigs>;
  Config: TConfigs;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
  Configs := FManager.Find<TConfigs>
    .Take(1)
    .OrderBy('ID').List;
  if Assigned(Configs) and (Configs.Count > 0) then
  begin
    Config := Configs.First;
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

end.
