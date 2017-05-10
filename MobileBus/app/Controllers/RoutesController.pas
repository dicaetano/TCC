unit RoutesController;

interface

uses
  Routes, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces;

type
  TRouteController = class(TInterfacedObject, IController<TRoute>)
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure Delete(Route: TRoute);
    function GetAll: TList<TRoute>;
    function GetRoute(ID: Integer): TRoute;
    procedure Save(Route: TRoute);
  end;

implementation

uses
  DBConnection;

{ TRouteController }

constructor TRouteController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TRouteController.Delete(Route: TRoute);
begin
  if not FManager.IsAttached(Route) then
    Route := FManager.Find<TRoute>(Route.Id);
  FManager.Remove(Route);
end;

destructor TRouteController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TRouteController.GetAll: TList<TRoute>;
begin
  Result := FManager.FindAll<TRoute>;
end;

function TRouteController.GetRoute(ID: integer): TRoute;
begin
  Result := FManager.Find<TRoute>(ID);
end;

procedure TRouteController.Save(Route: TRoute);
begin
  FManager.Save(Route);
end;

end.
