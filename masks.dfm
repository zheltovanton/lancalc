object MasksForm: TMasksForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Mask info'
  ClientHeight = 511
  ClientWidth = 679
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbApply: TSpeedButton
    Left = 589
    Top = 479
    Width = 82
    Height = 23
    Caption = 'Select'
    Flat = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Calibri'
    Font.Style = []
    ParentFont = False
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 679
    Height = 473
    Align = alTop
    DefaultColWidth = 130
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 24
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Calibri'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
    ParentFont = False
    TabOrder = 0
    OnDblClick = StringGrid1DblClick
  end
end
