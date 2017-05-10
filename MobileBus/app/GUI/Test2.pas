unit Test2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Maps;

type
  TTest2Form = class(TForm)
    MainLayout: TLayout;
    MultiView: TMultiView;
    tbTop: TToolBar;
    pbMain: TSpeedButton;
    ListView1: TListView;
    MapView1: TMapView;
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Test2Form: TTest2Form;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

end.
