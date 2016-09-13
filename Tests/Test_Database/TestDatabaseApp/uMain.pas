unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.Maps, FMX.ListView, System.Notification,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Data.Bind.GenData,
  Fmx.Bind.GenData, Data.Bind.DBScope, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI, Fmx.Bind.Editors, System.IOUtils

  {$IF DEFINED (IOS) || (ANDROID)}
  ,System.Android.Service
  {$ENDIF};

type
  TForm1 = class(TForm)
    pnlMain: TPanel;
    tbTop: TToolBar;
    TabControl1: TTabControl;
    Lista: TTabItem;
    Mapa: TTabItem;
    SpeedButton1: TSpeedButton;
    ListView: TListView;
    MapView: TMapView;
    Notification: TNotificationCenter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Conexao: TFDConnection;
    QueryCreate: TFDQuery;
    QryInsert: TFDQuery;
    QryDelete: TFDQuery;
    BindingsList1: TBindingsList;
    PrototypeBindSource1: TPrototypeBindSource;
    BindSourceDB1: TBindSourceDB;
    FDQuery2: TFDQuery;
    LinkFillControlToFieldDESCRIPTION: TLinkFillControlToField;
    QryConsulta: TFDQuery;
    FDQuery2ID: TFDAutoIncField;
    FDQuery2DESCRIPTION: TWideStringField;
    FDQuery2ID_1: TIntegerField;
    FDQuery2BUS_ID: TIntegerField;
    FDQuery2EXIT_TIME: TWideStringField;
    FDQuery2WEEK_DAY: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure ConexaoBeforeConnect(Sender: TObject);
  private
    { Private declarations }

    {$IF DEFINED (IOS) || (ANDROID)}
    FService : TLocalServiceConnection;
    {$ENDIF}
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TForm1.ConexaoBeforeConnect(Sender: TObject);
begin
  with Conexao do
  begin
    {$IF DEFINED (IOS) || (ANDROID)}
      Params.Values['DriverID'] := 'SQLite';
      try
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'BusDB.s3db');
      except on E: Exception do
      begin
        raise Exception.Create('Erro de conexão com o banco de dados!');
      end;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    try
        Params.Values['Database'] := 'D:\Área de Trabalho\TCC Delphi\workspace\trunk\Tests\Test_Database\database\BusDB.s3db';
      except on E: Exception do
      begin
        raise Exception.Create('Erro de conexão com o banco de dados!');
      end;
    end;
    {$ENDIF}
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IF DEFINED (IOS) || (ANDROID)}
  FService := TLocalServiceConnection.Create;
  FService.startService('TestDatabaseService');
{$ENDIF}
end;


end.
