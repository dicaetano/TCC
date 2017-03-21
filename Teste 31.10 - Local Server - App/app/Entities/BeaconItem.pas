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
    fteste: Nullable<String>;
  public
    property ID: Integer read FID;
    property UUID: string read FUUID;
    property teste: Nullable<String> read fteste;
  end;

implementation

end.
