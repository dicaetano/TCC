unit ListRoutes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation, Generics.Collections,
  FMX.ScrollBox, FMX.Memo;

type
  TFrmListRoutes = class(TForm)
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Memo1: TMemo;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmListRoutes: TFrmListRoutes;

implementation

uses
  Routes, RoutesController;
{$R *.fmx}

procedure TFrmListRoutes.FormShow(Sender: TObject);
var
  Route: TRoute;
  RouteCtr: TRouteController;
  Routes: TList<TRoute>;
begin
  RouteCtr := TRouteController.Create;
  Routes := RouteCtr.GetAll;
  for Route in Routes do
  begin
    Memo1.Lines.Add('=='+Route.ID.ToString+'==');
    Memo1.Lines.Add('Onibus: '+ Route.BusLine.Description);
    Memo1.Lines.Add('Prior: '+Route.PriorStop.Description);
    Memo1.Lines.Add('Next: '+Route.NextStop.Description);
    Memo1.Lines.Add('Tempo médio: '+Route.BusRouteTime.ToString);
    Memo1.Lines.Add('');
  end;
end;

procedure TFrmListRoutes.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

end.
