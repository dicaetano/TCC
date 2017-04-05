unit BusStopController;

interface

uses
  BusStop, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces;

type
  TBusStopController = class(TInterfacedObject, IController<TBusStop>)
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure Delete(BusStop: TBusStop);
    function GetAll: TList<TBusStop>;
  end;

implementation

uses
  DBConnection;

{ TBeaconController }

constructor TBusStopController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBusStopController.Delete(BusStop: TBusStop);
begin
  if not FManager.IsAttached(BusStop) then
    BusStop := FManager.Find<TBusStop>(BusStop.Id);
  FManager.Remove(BusStop);
end;

destructor TBusStopController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TBusStopController.GetAll: TList<TBusStop>;
begin
  FManager.Clear;
  Result := FManager.FindAll<TBusStop>;
end;

end.
