unit RoutesController;

interface

uses
  Routes, BusLine, BusStop,Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces;

type
  TRouteController = class(TInterfacedObject, IController<TRoute>)
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure Delete(Route: TRoute);
    function GetAll: TList<TRoute>;
    function GetRoute(ID: integer): TRoute;
    function PriorStopExists(BusStop: TBusStop): Boolean;
    function NextStopExists(BusStop: TBusStop): Boolean;
    procedure Save(Route: TRoute);
    procedure Update(Route:TRoute);
    function GetRouteIfExists(PriorBusStop,
      NextBusStop: TBusStop; BusLine: TBusLine): TRoute; overload;
    function GetRouteIfExists(PriorBusStop, NextBusStop: TBusStop): TRoute; overload;
    function Refresh(Route: TRoute):TRoute;

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
  FManager.Clear;
  Result := FManager.FindAll<TRoute>;
end;

function TRouteController.GetRoute(ID: integer): TRoute;
begin
  Result := FManager.Find<TRoute>(ID);
end;

function TRouteController.GetRouteIfExists(PriorBusStop,
  NextBusStop: TBusStop; BusLine: TBusLine): TRoute;
var
  Route: TRoute;
  Routes: TList<TRoute>;
  Found: Boolean;
begin
  Found := False;
  Routes := Self.GetAll;
  for Route in Routes do
  begin
    if (BusLine.ID = Route.BusLine.ID) then
    begin
      if (PriorBusStop.ID = Route.PriorStop.ID) then
      begin
        if (NextBusStop.ID = Route.NextStop.ID) then
        begin
          Result := Route;
          Found := True;
        end;
      end;
    end;
  end;
  if not Found then
    Result := nil;
end;

function TRouteController.GetRouteIfExists(PriorBusStop,
  NextBusStop: TBusStop): TRoute;
var
  Route: TRoute;
  Routes: TList<TRoute>;
  Found: Boolean;
begin
  Found := False;
  Routes := Self.GetAll;
  for Route in Routes do
  begin
    if (PriorBusStop.ID = Route.PriorStop.ID) then
    begin
      if (NextBusStop.ID = Route.NextStop.ID) then
      begin
        Result := Route;
        Found := True;
      end;
    end;
  end;
  if not Found then
    Result := nil;
end;


function TRouteController.NextStopExists(BusStop: TBusStop): Boolean;
var
  Routes: TList<TRoute>;
  Route: TRoute;
begin
  Routes := FManager.FindAll<TRoute>;
  Result := False;
  for Route in Routes do
  begin
    if Route.NextStop.ID = BusStop.ID then
      Result := True;
  end;
end;

function TRouteController.PriorStopExists(BusStop: TBusStop): Boolean;
begin

end;

function TRouteController.Refresh(Route: TRoute): TRoute;
begin
 FManager.Refresh(Route);
 result := Route;
end;

procedure TRouteController.Save(Route: TRoute);
begin
  FManager.Save(Route);
end;

procedure TRouteController.Update(Route: TRoute);
begin
  FManager.Update(Route);
  FManager.Flush;
end;

end.
