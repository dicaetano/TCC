unit ConfigsController;

interface

uses
  Configs, Generics.Collections, Aurelius.Engine.ObjectManager,
  ControllerInterfaces;

type
  TConfigsController = class(TInterfacedObject, IController<TConfigs>)
  private
    class var FConfigsCtr: TConfigsController;
    FManager: TObjectManager;
  public
    class function GetInstance: TConfigsController;
    constructor Create;
    destructor Destroy; override;
    procedure Delete(Config: TConfigs);
    function GetAll: TList<TConfigs>;
    function GetFirst: TConfigs;

  end;

implementation

uses
  DBConnection;

{ TConfigsController }

constructor TConfigsController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TConfigsController.Delete(Config: TConfigs);
begin
  if not FManager.IsAttached(Config) then
    Config := FManager.Find<TConfigs>(Config.Id);
  FManager.Remove(Config);
end;

destructor TConfigsController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TConfigsController.GetAll: TList<TConfigs>;
begin
  Result := FManager.FindAll<TConfigs>;
end;

function TConfigsController.GetFirst: TConfigs;
var
  Configs: TList<TConfigs>;
  Config: TConfigs;
begin
  Configs := FManager.Find<TConfigs>
    .Take(1)
    .OrderBy('ID').List;
  Config := Configs.First;
end;

class function TConfigsController.GetInstance: TConfigsController;
begin
  if FConfigsCtr = nil then
    FConfigsCtr := TConfigsController.Create;
  Result := FConfigsCtr;
end;

initialization

finalization

if TConfigsController.FConfigsCtr <> nil then
begin
  TConfigsController.FConfigsCtr.Free;
  TConfigsController.FConfigsCtr := nil;
end;

end.
