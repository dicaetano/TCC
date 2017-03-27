unit Routs;

interface
uses
  BusLine, BusStop, Aurelius.Mapping.Attributes;

type
  [Entity]
  [Automapping]
  TRout = class
  private
    FID: Integer;
    FBusLine: TBusLine;
    FNextStop: TBusStop;
    FPriorStop: TBusStop;
  public
    property ID: Integer read FID;
    property BusLine: TBusLine read FBusLine;
    property PriorStop: TBusStop read FPriorStop;
    property NextStop: TBusStop read FNextStop;
  end;

implementation

end.
