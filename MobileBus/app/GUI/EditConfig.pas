unit EditConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit;

type
  TEditConfigForm = class(TForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    StyleBook1: TStyleBook;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label9: TLabel;
    Edit5: TEdit;
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
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

procedure TEditConfigForm.SpeedButton2Click(Sender: TObject);
begin
  Close;
end;

end.
