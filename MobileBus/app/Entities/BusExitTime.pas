unit BusExitTime;

interface

uses
  BusLine, Aurelius.Mapping.Attributes;

type
  [Automapping]
  TWeekDay = (wdSunday, wdMonday, wdTuesday, wdWednesday,
    wdThursday, wdFriday, wdSaturday);

  [Entity]
  [Automapping]
  TBusExitTime = class
  private
    FWeekDay: TWeekDay;
    FID: Integer;
    FExitTime: string;
    FBusLine: TBusLine;
  public
    property ID: Integer read FID;
    property BusLine: TBusLine read FBusLine;
    property ExitTime: string read FExitTime;
    property WeekDay: TWeekDay read FWeekDay;
  end;

implementation

end.
