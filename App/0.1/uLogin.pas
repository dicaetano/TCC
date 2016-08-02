unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TFrmLogin = class(TForm)
    Panel1: TPanel;
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    BtnAutentica: TButton;
    Conexao: TFDConnection;
    Query: TFDQuery;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    procedure EdtPasswordValidate(Sender: TObject; var Text: string);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAutenticaClick(Sender: TObject);
    procedure EdtUsernameValidate(Sender: TObject; var Text: string);
  private
    { Private declarations }
    FLoginSucceed : Boolean;

    function Validar(Usuario, Senha: String) : Boolean;
    function UsuarioExiste(Text : String) : Boolean;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses uPrincipal;

procedure TFrmLogin.BtnAutenticaClick(Sender: TObject);
begin
  Validar(EdtUsername.Text, EdtPassword.Text);
end;

procedure TFrmLogin.EdtPasswordValidate(Sender: TObject; var Text: string);
begin
  Validar(EdtUsername.Text, Text);
end;

procedure TFrmLogin.EdtUsernameValidate(Sender: TObject; var Text: string);
begin
  if not UsuarioExiste(Text) then
    ShowMessage('Usuario nao existe');
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FLoginSucceed then
    Application.Terminate;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  EdtUsername.SetFocus;
end;

function TFrmLogin.UsuarioExiste(Text: String): Boolean;
begin
  Result := True;
end;

function TFrmLogin.Validar(Usuario, Senha: String) : Boolean;
begin
  FLoginSucceed := False;
  if Usuario.IsEmpty or Senha.IsEmpty then
    Exit;

  with Query do
  begin
    SQL.Clear;
    SQL.Add('SELECT usu_senha FROM USUARIOS WHERE UPPER(usu_login) = '+
      Usuario.ToUpper.QuotedString);
    Open;

    if FieldByName('usu_senha').AsString.ToUpper.CompareTo(Senha.ToUpper) = 0 then
    begin
      FLoginSucceed := True;
      ModalResult := mrOk;
    end;

  end;
end;

end.
