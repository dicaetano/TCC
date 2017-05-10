unit Utils;

interface
uses
  System.Beacon, FMX.ListView, FMX.ListView.Appearances, System.SysUtils;

function ProximityToString(Proximity: TBeaconProximity): string;
function GetLVItem(DeviceId: string; LV: TListView): TListViewItem;


implementation

function ProximityToString(Proximity: TBeaconProximity): string;
begin
  case Proximity of
    Immediate: Result := 'Immediate';
    Near: Result := 'Near';
    Far: Result := 'Far';
    Away: Result := 'Away';
  end;
end;

function GetLVItem(DeviceId: string; LV: TListView): TListViewItem;
var
  Item: TListViewItem;
begin
  Result := nil;
  for Item in LV.Items do
    if Item.Text.Equals(DeviceId) then
      Result := Item;
end;


end.
