unit Routes;

interface
uses
  BusLine, BusStop, Aurelius.Mapping.Attributes;

type
  [Entity]
  [Automapping]
  TRoute = class
  private
    FID: Integer;
    FBusLine: TBusLine;
    FNextStop: TBusStop;
    FPriorStop: TBusStop;
  public
    property ID: Integer read FID;
    property BusLine: TBusLine read FBusLine write FBusLine;
    property PriorStop: TBusStop read FPriorStop write FPriorStop;
    property NextStop: TBusStop read FNextStop write FNextStop;
  end;

implementation

end.