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
    function GetBusStop(ID: Integer): TBusStop;
    procedure Save(BusStop: TBusStop);
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

function TBusStopController.GetBusStop(ID: Integer): TBusStop;
begin
  Result := FManager.Find<TBusStop>(ID);
end;

procedure TBusStopController.Save(BusStop: TBusStop);
begin
  FManager.Save(BusStop);
end;

end.
