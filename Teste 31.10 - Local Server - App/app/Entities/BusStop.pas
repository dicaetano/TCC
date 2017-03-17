unit BusStop;

interface

uses
  BeaconItem;

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
    property Beacon: TBeaconItem read FBeacon;
    property Latitude: Double read FLatitude;
    property Longitude: Double read FLongitude;
    property Description: string read FDescription;
  end;

implementation

end.
