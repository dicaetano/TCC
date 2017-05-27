unit addBusLine;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ListBox, Generics.Collections;

type
  TaddBusLineForm = class(TForm)
    pnlMain: TPanel;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    label1: TLabel;
    EditDescription: TEdit;
    BtnAdd: TButton;
    CbbBeacon: TComboBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  addBusLineForm: TaddBusLineForm;

implementation

uses
  BusLine, BusLineController, BeaconItem, BeaconController;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TaddBusLineForm.BtnAddClick(Sender: TObject);
var
  BusLineController: TBusLineController;
  BusLine: TBusLine;
  BeaconController: TBeaconController;
  Beacon: TBeaconItem;
begin
  if EditDescription.Text = '' then
    exit;
  BusLineController := TBusLineController.create;
  BusLine := TBusLine.Create;
  BeaconController := TBeaconController.Create;
  Beacon := BeaconController.GetBeacon(CbbBeacon.Items.Names[CbbBeacon.ItemIndex].ToInteger);
  try
    BusLine.Description := EditDescription.Text;
    BusLine.Beacon := Beacon;
    BusLineController.Save(BusLine);
  finally
    BusLine.Free;
    BusLineController.Free;
    EditDescription.Text := '';
  end;
end;

procedure TaddBusLineForm.FormCreate(Sender: TObject);
var
  Beacon: TBeaconItem;
  BeaconCtr: TBeaconController;
  Beacons: TList<TBeaconItem>;
begin
  BeaconCtr := TBeaconController.Create;
  Beacons := BeaconCtr.GetAll;
  for Beacon in Beacons do
    CbbBeacon.Items.AddPair(Beacon.ID.ToString,Beacon.UUID);
end;

procedure TaddBusLineForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
