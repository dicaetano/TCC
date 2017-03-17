object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 321
  Width = 535
  object Conexao: TFDConnection
    Params.Strings = (
      
        'Database=D:\'#193'rea de Trabalho\TCC Delphi\workspace\trunk\Tests\Te' +
        'st_Database\database\BusDB2.s3db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 33
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 128
    Top = 40
  end
end
