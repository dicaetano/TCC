object DM: TDM
  OldCreateOrder = False
  OnCreate = AndroidServiceCreate
  OnStartCommand = AndroidServiceStartCommand
  Height = 238
  Width = 324
  object Beacon: TBeacon
    ModeExtended = [iBeacons]
    MonitorizedRegions = <>
    BeaconDeathTime = 40
    SPC = 0.500000000000000000
    ScanningSleepingTime = 0
    OnBeaconEnter = BeaconBeaconEnter
    OnBeaconProximity = BeaconBeaconProximity
    Left = 112
    Top = 88
  end
  object Notification: TNotificationCenter
    Left = 208
    Top = 96
  end
end
