unit BusRouteTime;

interface

uses
  Aurelius.Mapping.Attributes, BusStop;

type
  [Entity]
  [Automapping]
  TBusRouteTime = class
  private
    FID: Integer;
    FPriorStop: TBusStop;
    FNextStop: TBusStop;
    FRouteTime: Integer;
  public
    property ID: Integer read FID write FID;
    property PriorStop: TBusStop read FPriorStop write FPriorStop;
    property NextStop: TBusStop read FNextStop write FNextStop;
    property RouteTime: Integer read FRouteTime write FRouteTime;
  end;

implementation

end.
