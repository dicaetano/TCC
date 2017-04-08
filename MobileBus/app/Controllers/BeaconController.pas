unit BeaconController;

interface

uses
  BeaconItem, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces;

type
  TBeaconController = class(TInterfacedObject, IController<TBeaconItem>)
  private
    FManager: TObjectManager;
  public
    constructor Create;
    destructor Destroy;
    procedure Delete(Beacon: TBeaconItem);
    function GetAll: TList<TBeaconItem>;
    function GetBeacon(ID: Integer): TBeaconItem;
  end;

implementation

uses
  DBConnection;

{ TBeaconController }

constructor TBeaconController.Create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBeaconController.Delete(Beacon: TBeaconItem);
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

function TBeaconController.GetAll: TList<TBeaconItem>;
begin
//  FManager.Clear;
  Result := FManager.FindAll<TBeaconItem>;
end;

function TBeaconController.GetBeacon(ID: integer): TBeaconItem;
begin
//  FManager.Create;
  Result := FManager.Find<TBeaconItem>(ID);
end;

end.
