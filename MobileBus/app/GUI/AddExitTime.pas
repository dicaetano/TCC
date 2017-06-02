unit AddExitTime;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.DateTimeCtrls, FMX.Layouts, BusLine, BusLineController,
  Generics.Collections, BusExitController, BusExitTime;

type
  TAddExitTimeForm = class(TForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Button1: TButton;
    Layout1: TLayout;
    rbQuarta: TRadioButton;
    rbSegunda: TRadioButton;
    rbTerca: TRadioButton;
    rbDomingo: TRadioButton;
    rbQuinta: TRadioButton;
    rbSexta: TRadioButton;
    rbSabado: TRadioButton;
    Label1: TLabel;
    TimeEdit1: TTimeEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    FLineList: TList<TBusLine>;
    procedure CarregarHorariosLinhaSelecionada;
    function GetWeekDay: TWeekDay;
  public
    { Public declarations }
  end;

var
  AddExitTimeForm: TAddExitTimeForm;

implementation

uses
  Utils;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TAddExitTimeForm.Button1Click(Sender: TObject);
begin
  Layout1.Enabled := True;
end;

procedure TAddExitTimeForm.CarregarHorariosLinhaSelecionada;
var
  BusExitCtr: TBusExitController;
  BusExitList: TList<TBusExitTime>;
  BusExit: TBusExitTime;
begin
  BusExitCtr := TBusExitController.create;
  try
    BusExitList := BusExitCtr.getTimes(FLineList[ComboBox1.ItemIndex]);
    if Assigned(BusExitList) and (BusExitList.Count > 0) then
    begin
      Memo1.Lines.Clear;    
      for BusExit in BusExitList do
      begin
        Memo1.Lines.Add(Format('Horário: %s - Dia - %s', [BusExit.ExitTime, WeekDayToStr(BusExit.WeekDay)]))
      end;    
    end;
  finally
    BusExitCtr.Free;
  end;
end;

procedure TAddExitTimeForm.ComboBox1Change(Sender: TObject);
begin
  CarregarHorariosLinhaSelecionada;
end;

procedure TAddExitTimeForm.FormShow(Sender: TObject);
var
  BLCtr: TBusLineController;
  BusLine: TBusLine;
begin
  BLCtr := TBusLineController.Create;
  try
    FLineList := BLCtr.getAll;
    if Assigned(FLineList) and (FLineList.Count > 0) then
    begin
      for BusLine in FLineList do
        ComboBox1.Items.Add(BusLine.Description);
    end;
  finally
    BLCtr.Free;
  end;
end;

function TAddExitTimeForm.GetWeekDay: TWeekDay;
begin
  if rbSegunda.IsChecked then 
    Result := wdMonday;
  if rbTerca.IsChecked then 
    Result := wdTuesday;
  if rbQuarta.IsChecked then 
    Result := wdWednesday;
  if rbQuinta.IsChecked then 
    Result := wdThursday;
  if rbSexta.IsChecked then 
    Result := wdFriday;
  if rbSabado.IsChecked then 
    Result := wdSaturday;
  if rbDomingo.IsChecked then 
    Result := wdSunday;
end;

procedure TAddExitTimeForm.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TAddExitTimeForm.SpeedButton2Click(Sender: TObject);
var
  BusExitTime: TBusExitTime;
  Ctr: TBusExitController;
begin
  BusExitTime := TBusExitTime.Create;                              
  BusExitTime.BusLine := FLineList[ComboBox1.ItemIndex];
  BusExitTime.ExitTime := TimeEdit1.Text;
  BusExitTime.WeekDay := GetWeekDay;
  Ctr := TBusExitController.create;
  try
    Ctr.Save(BusExitTime);
    CarregarHorariosLinhaSelecionada;
  finally
    Ctr.Free;
    BusExitTime.Free;
    Layout1.Enabled := False;
  end;
end;

end.
