unit BeaconItem;

interface

type
  [Entity]
  [Automapping]
  TBeaconItem = class
  private
    FUUID: string;
    FID: Integer;
  public
    property ID: Integer read FID;
    property UUID: string read FUUID;

  end;

implementation

end.
