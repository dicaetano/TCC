unit BusStopController;

interface

uses
  BusStop, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces, BeaconItem,
  System.SysUtils;

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
    function getBeacon(id: integer):TBeaconItem;
    function GetBusStopByPosition(Longitude,Latitude: Double): TBusStop;
    function GetBusStopByDescription(Description:string):TBusStop;
    function GetByUUID(UUID: string): TBusStop;
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

function TBusStopController.getBeacon(id: integer): TBeaconItem;
var
  BusStop: TBusStop;
begin
  BusStop := FManager.Find<TBusStop>(ID);
  Result := BusStop.Beacon;
end;

function TBusStopController.GetBusStop(ID: Integer): TBusStop;
begin
  Result := FManager.Find<TBusStop>(ID);
end;

function TBusStopController.GetBusStopByDescription(
  Description: string): TBusStop;
var
  ListBusStops: TList<TBusStop>;
  BusStop: TBusStop;
begin
  FManager.Clear;
  ListBusStops := FManager.FindAll<TBusStop>;
  for BusStop in ListBusStops do
  begin
    if (BusStop.Description = Description) then
      Result := BusStop;
  end;
end;

function TBusStopController.GetBusStopByPosition(Longitude,
  Latitude: Double): TBusStop;
var
  ListBusStops: TList<TBusStop>;
  BusStop: TBusStop;
begin
  FManager.Clear;
  ListBusStops := FManager.FindAll<TBusStop>;
  for BusStop in ListBusStops do
  begin
    if (BusStop.Latitude = Latitude) and (BusStop.Longitude = Longitude) then
      Result := BusStop;
  end;
end;

function TBusStopController.GetByUUID(UUID: string): TBusStop;
var
  ListBusStops: TList<TBusStop>;
  BusStop: TBusStop;
begin
  Result := nil;
  ListBusStops := FManager.FindAll<TBusStop>;
  for BusStop in ListBusStops do
  begin
    if BusStop.Beacon.UUID.ToUpper.Equals(UUID.ToUpper) then
      Result := BusStop;
  end;
end;

procedure TBusStopController.Save(BusStop: TBusStop);
begin
  FManager.Save(BusStop);
end;

end.
