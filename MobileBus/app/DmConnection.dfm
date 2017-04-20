object DMConn: TDMConn
  OldCreateOrder = False
  Height = 242
  Width = 314
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 152
    Top = 33
  end
  object Connection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=C:\teste.sqlite')
    LoginPrompt = False
    Left = 16
    Top = 8
  end
end
