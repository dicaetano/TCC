unit BeaconController;

interface

uses
  Beacon, Generics.Collections, Aurelius.Engine.ObjectManager;

type
  TBeaconController = class
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure DeleteBeacon(Beacon: TBeacon);
    function GetAllBeacons: TList<TBeacon>;
  end;

implementation

uses
  DBConnection;

{ TBeaconController }

constructor TBeaconController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBeaconController.DeleteBeacon(Beacon: TBeacon);
begin
  if not FManager.IsAttached(Beacon) then
    Beacon := FManager.Find<TBeacon>(Beacon.Id);
  FManager.Remove(Beacon);
end;

destructor TBeaconController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TBeaconController.GetAllBeacons: TList<TBeacon>;
begin
  FManager.Clear;
  Result := FManager.FindAll<TBeacon>;
end;

end.
