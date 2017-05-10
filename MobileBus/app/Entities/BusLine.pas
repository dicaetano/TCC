unit BusLine;

interface

uses
  Aurelius.Mapping.Attributes, BeaconItem;

type
  [Entity]
  [Automapping]
  TBusLine = class
  private
    FID: Integer;
    FDescription: string;
    FBeacon: TBeaconItem;
  public
    property ID: Integer read FID;
    property Description: string read FDescription write FDescription;
    property Beacon: TBeaconItem read FBeacon write FBeacon;
  end;

implementation

end.
