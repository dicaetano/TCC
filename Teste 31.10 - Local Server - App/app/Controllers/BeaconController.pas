unit BeaconController;

interface

uses
  BeaconItem, Generics.Collections, Aurelius.Engine.ObjectManager;

type
  TBeaconController = class
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure DeleteBeacon(Beacon: TBeaconItem);
    function GetAllBeacons: TList<TBeaconItem>;
  end;

implementation

uses
  DBConnection;

{ TBeaconController }

constructor TBeaconController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBeaconController.DeleteBeacon(Beacon: TBeaconItem);
begin
  if not FManager.IsAttached(Beacon) then
    Beacon := FManager.Find<TBeaconItem>(Beacon.Id);
  FManager.Remove(Beacon);
end;

destructor TBeaconController.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TBeaconController.GetAllBeacons: TList<TBeaconItem>;
begin
  FManager.Clear;
  Result := FManager.FindAll<TBeaconItem>;
end;

end.
