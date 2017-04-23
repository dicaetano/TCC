object fmServer: TfmServer
  Left = 0
  Top = 0
  Caption = 'Hello Server'
  ClientHeight = 121
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 67
    Width = 94
    Height = 13
    Caption = 'Server Not Running'
  end
  object Button1: TButton
    Left = 80
    Top = 28
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 28
    Width = 75
    Height = 25
    Caption = 'Parar'
    TabOrder = 1
    OnClick = Button2Click
  end
end
