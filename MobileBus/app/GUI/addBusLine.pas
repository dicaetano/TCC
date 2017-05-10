unit addBusLine;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TaddBusLineForm = class(TForm)
    pnlMain: TPanel;
    descriptionEdit: TEdit;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    label1: TLabel;
    BtnAdd: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  addBusLineForm: TaddBusLineForm;

implementation

uses
  BusLine, BusLineController;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TaddBusLineForm.BtnAddClick(Sender: TObject);
var
  BusLineController: TBusLineController;
  BusLine: TBusLine;
begin
  if descriptionEdit.Text = '' then
    exit;
  BusLineController := TBusLineController.create;
  BusLine := TBusLine.Create;
  try
    BusLine.Description := descriptionEdit.Text;
    BusLineController.Save(BusLine);
  finally
    BusLine.Free;
    BusLineController.Free;
    descriptionEdit.Text := '';
  end;
end;

procedure TaddBusLineForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.
