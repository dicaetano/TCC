object DMConn: TDMConn
  OldCreateOrder = False
  Height = 242
  Width = 314
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=C:\Users\Rodrigo\Documents\aurelius.sqlite')
    LoginPrompt = False
    Left = 56
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 152
    Top = 33
  end
end
