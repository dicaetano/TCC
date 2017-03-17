unit BusStop;

interface

uses
  Beacon;

type
  [Entity]
  [Automapping]
  TBusStop = class
  private
    FLatitude: Double;
    FBeacon: TBeacon;
    FID: Integer;
    FLongitude: Double;
    FDescription: string;
  public
    property ID: Integer read FID;
    property Beacon: TBeacon read FBeacon;
    property Latitude: Double read FLatitude;
    property Longitude: Double read FLongitude;
    property Description: string read FDescription;
  end;

implementation

end.
