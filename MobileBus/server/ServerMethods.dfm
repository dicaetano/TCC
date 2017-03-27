object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 335
  Width = 514
  object FDQueryDepartmentEmployees: TFDQuery
    Connection = FDConnectionEMPLOYEE
    SQL.Strings = (
      'select * from employee where dept_no = :DEPT'
      '')
    Left = 200
    Top = 128
    ParamData = <
      item
        Name = 'DEPT'
        DataType = ftString
        ParamType = ptInput
        Size = 3
      end>
  end
  object FDQueryDepartment: TFDQuery
    Connection = FDConnectionEMPLOYEE
    SQL.Strings = (
      'select * from department where DEPT_NO = :DEPT')
    Left = 200
    Top = 72
    ParamData = <
      item
        Name = 'DEPT'
        DataType = ftString
        ParamType = ptInput
        Size = 3
      end>
  end
  object FDQueryDepartmentNames: TFDQuery
    Connection = FDConnectionEMPLOYEE
    SQL.Strings = (
      'select dept_no, department  from department')
    Left = 200
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 56
    Top = 128
  end
  object FDConnectionEMPLOYEE: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'ConnectionDef=EMPLOYEEFB')
    LoginPrompt = False
    Left = 55
    Top = 16
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 56
    Top = 184
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll'
    Left = 56
    Top = 80
  end
end
