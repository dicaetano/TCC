unit Configs;

interface

uses
  Aurelius.Mapping.Attributes;

type
  [Entity]
  [Automapping]
  TConfigs = class
  private
    FID: Integer;
    FDeathTime: Integer;
    FSPC: Double;
    FScanningSleep: Integer;
    FScanningTime: Integer;
    FTimerScan: Integer;
    FURLServer: string;
  public
    property ID: Integer read FID write FID;
    property DeathTime: Integer read FDeathTime write FDeathTime;
    property SPC: Double read FSPC write FSPC;
    property ScanningSleep: Integer read FScanningSleep write FScanningSleep;
    property ScanningTime: Integer read FScanningTime write FScanningTime;
    property TimerScan: Integer read FTimerScan write FTimerScan;
    property URLServer: string read FURLServer write FURLServer;
  end;


implementation

end.
