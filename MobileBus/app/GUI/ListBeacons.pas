unit ListBeacons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Aurelius.Engine.ObjectManager, DBConnection, Generics.Collections;

type
  TListBeaconsForm = class(TForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    ListView1: TListView;
    StyleBook1: TStyleBook;
    BtnFechar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ListBeaconsForm: TListBeaconsForm;

implementation

uses
  BeaconItem, ControllerInterfaces, BeaconController;

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TListBeaconsForm.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TListBeaconsForm.FormCreate(Sender: TObject);
var
  Item: TListViewItem;
  Beacon: TBeaconItem;
  Beacons: TList<TBeaconItem>;
  BeaconCtrl: IController<TBeaconItem>;
begin
  BeaconCtrl := TBeaconController.Create;
  Beacons := BeaconCtrl.GetAll;

  for Beacon in Beacons do
  begin
    Item := ListView1.Items.Add;

    Item.Text := Beacon.ID.ToString;
    Item.Detail := Beacon.UUID;
  end;
end;

procedure TListBeaconsForm.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Beacon: TBeaconItem;
  BeaconController: TBeaconController;
begin
  BeaconController := TBeaconController.Create;
  Beacon := BeaconController.GetBeacon(AItem.Text.ToInteger);
  BeaconController.Delete(Beacon);
end;

end.
