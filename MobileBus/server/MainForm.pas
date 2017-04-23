unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmServer = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
  end;

var
  fmServer: TfmServer;

implementation

uses
  Server;

{$R *.dfm}

procedure TfmServer.Button1Click(Sender: TObject);
begin
  StartServer;
  Label1.Caption := 'Server running!';
end;

procedure TfmServer.Button2Click(Sender: TObject);
begin
  StopServer;
  Label1.Caption := 'Server is not running!';
end;

procedure TfmServer.FormCreate(Sender: TObject);
begin
  StartServer;
  Label1.Caption := 'Server running!';
end;

procedure TfmServer.FormDestroy(Sender: TObject);
begin
  StopServer;
end;

end.
