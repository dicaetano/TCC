unit BusStop;

interface

uses
  BeaconItem, Aurelius.Mapping.Attributes;

type
  [Entity]
  [Automapping]
  TBusStop = class
  private
    FLatitude: Double;
    FBeacon: TBeaconItem;
    FID: Integer;
    FLongitude: Double;
    FDescription: string;
  public
    property ID: Integer read FID;
    property Beacon: TBeaconItem read FBeacon write FBeacon;
    property Latitude: Double read FLatitude write FLatitude;
    property Longitude: Double read FLongitude write FLongitude;
    property Description: string read FDescription write FDescription;
    function getBeacon:TBeaconItem;
  end;

implementation

{ TBusStop }

function TBusStop.getBeacon: TBeaconItem;
begin
  Result := Beacon;
end;

end.
