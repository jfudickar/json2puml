object Json2PumlConfigurationFrame: TJson2PumlConfigurationFrame
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object EditPanel: TPanel
    Left = 0
    Top = 41
    Width = 640
    Height = 439
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      640
      41)
    object FileLabel: TLabel
      Left = 2
      Top = 8
      Width = 21
      Height = 15
      Caption = 'File:'
      FocusControl = FileNameEdit
    end
    object FileNameEdit: TButtonedEdit
      Left = 29
      Top = 6
      Width = 611
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
      Text = 'FileNameEdit'
    end
  end
  object SaveDialog: TSaveTextFileDialog
    Filter = 'JSON Files (*.json)|*.json|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 324
    Top = 252
  end
  object OpenDialog: TOpenTextFileDialog
    Filter = 'JSON Files (*.json)|*.json|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 148
    Top = 252
  end
end
