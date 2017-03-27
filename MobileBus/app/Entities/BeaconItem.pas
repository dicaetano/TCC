unit BeaconItem;

interface

uses
  Aurelius.Mapping.Attributes, Aurelius.Types.Nullable;

type
  [Entity]
  [Automapping]
  TBeaconItem = class     //Verificar se tem como implementar IBeacon
  private
    FUUID: string;
    FID: Integer;
  public
    property ID: Integer read FID;
    property UUID: string read FUUID write FUUID;
  end;

implementation

end.
