unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.MultiView, FMX.Styles.Objects,
  System.Actions, FMX.ActnList, FMX.Menus, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Beacon, System.Bluetooth, System.Beacon.Components;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    ActionList1: TActionList;
    Action1: TAction;
    BeaconDevice1: TBeaconDevice;
    procedure Action1Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonStyleObject1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.Action1Execute(Sender: TObject);
begin
  showmessage('teste');
end;

procedure TFrmPrincipal.Button1Click(Sender: TObject);
begin
  if MultiView1.Mode = TMultiViewMode.Panel then
    MultiView1.Mode := TMultiViewMode.NavigationPane
  else
    MultiView1.Mode := TMultiViewMode.Panel;
end;

procedure TFrmPrincipal.ButtonStyleObject1Click(Sender: TObject);
begin
   showmessage('teste');
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
