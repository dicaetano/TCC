unit Utils;

interface
uses
  System.Beacon;

function ProximityToString(Proximity: TBeaconProximity): string;


implementation

function ProximityToString(Proximity: TBeaconProximity): string;
begin
  case Proximity of
    Immediate: Result := 'Immediate';
    Near: Result := 'Near';
    Far: Result := 'Far';
    Away: Result := 'Away';
  end;
end;

end.
