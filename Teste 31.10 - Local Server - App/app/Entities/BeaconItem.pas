unit BeaconItem;

interface

type
  [Entity]
  [Automapping]
  TBeaconItem = class     //Verificar se tem como implementar IBeacon
  private
    FUUID: string;
    FID: Integer;
  public
    property ID: Integer read FID;
    property UUID: string read FUUID;

  end;

implementation

end.
