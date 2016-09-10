object BeaconServiceDM: TBeaconServiceDM
  OldCreateOrder = False
  OnCreate = AndroidServiceCreate
  OnRebind = AndroidServiceRebind
  OnStartCommand = AndroidServiceStartCommand
  Height = 238
  Width = 324
  object NotificationCenter1: TNotificationCenter
    Left = 168
    Top = 40
  end
  object Beacon1: TBeacon
    ModeExtended = [iBeacons, AltBeacons, Eddystones]
    MonitorizedRegions = <>
    BeaconDeathTime = 50
    SPC = 0.500000000000000000
    OnBeaconEnter = Beacon1BeaconEnter
    OnBeaconProximity = Beacon1BeaconProximity
    Left = 88
    Top = 40
  end
end
