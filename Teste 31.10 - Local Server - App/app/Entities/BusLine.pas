unit BusLine;

interface

type
  [Entity]
  [Automapping]
  TBusLine = class
  private
    FID: Integer;
    FDescription: string;
  public
    property ID: Integer read FID;
    property Description: string read FDescription;
  end;

implementation

end.
