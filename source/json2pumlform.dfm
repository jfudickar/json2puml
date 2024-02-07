object json2pumlMainForm: Tjson2pumlMainForm
  Left = 0
  Top = 0
  Caption = 'json2puml'
  ClientHeight = 900
  ClientWidth = 1357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 13
  object Label10: TLabel
    Left = 28
    Top = 59
    Width = 55
    Height = 13
    Caption = '/inputlistfile'
  end
  object Label11: TLabel
    Left = 28
    Top = 86
    Width = 68
    Height = 13
    Caption = '/leadingobject'
  end
  object Label16: TLabel
    Left = 36
    Top = 94
    Width = 68
    Height = 13
    Caption = '/leadingobject'
  end
  object Label19: TLabel
    Left = 30
    Top = 208
    Width = 104
    Height = 13
    Caption = '/curlauthenticationfile'
  end
  object Label22: TLabel
    Left = 28
    Top = 27
    Width = 58
    Height = 13
    Caption = '/outputpath'
  end
  object Label21: TLabel
    Left = 28
    Top = 32
    Width = 71
    Height = 13
    Caption = '/plantumljarfile'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 881
    Width = 1357
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object MainActionToolBar: TActionToolBar
    Left = 0
    Top = 50
    Width = 1357
    Height = 23
    ActionManager = MainActionManager
    AllowHiding = False
    Caption = 'MainActionToolBar'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PersistentHotKeys = True
    Spacing = 5
  end
  object ActionMainMenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1357
    Height = 25
    UseSystemFont = False
    ActionManager = MainActionManager
    Caption = 'ActionMainMenuBar'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object MainPageControl: TPageControl
    Left = 0
    Top = 73
    Width = 1357
    Height = 808
    ActivePage = OutputTabsheet
    Align = alClient
    TabOrder = 3
    object LogTabSheet: TTabSheet
      BorderWidth = 5
      Caption = 'Execute'
      object CommandLineEditPanel: TPanel
        Left = 0
        Top = 0
        Width = 1339
        Height = 353
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = CommandLineEditPanelResize
        object TLabel
          Left = 648
          Top = 144
          Width = 3
          Height = 13
        end
        object LeftInputPanel: TPanel
          Left = 0
          Top = 0
          Width = 404
          Height = 353
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            404
            353)
          object CurlParameterPageControl: TPageControl
            Left = 4
            Top = 227
            Width = 400
            Height = 120
            ActivePage = CurlParameterTabSheet
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            object CurlParameterTabSheet: TTabSheet
              Caption = '/curlparameter'
              object CurlParameterDBGrid: TDBGrid
                Left = 0
                Top = 0
                Width = 392
                Height = 92
                Align = alClient
                DataSource = CurlParameterDataSource
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
            end
            object CurlAuthenticationParameterTabSheet: TTabSheet
              Caption = '/curlauthenticationparameter'
              ImageIndex = 1
              object CurlAuthenticationParameterDBGrid: TDBGrid
                Left = 0
                Top = 0
                Width = 392
                Height = 92
                Align = alClient
                DataSource = CurlAuthenticationParameterDataSource
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
            end
          end
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 400
            Height = 210
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Configuration'
            TabOrder = 1
            DesignSize = (
              400
              210)
            object Label1: TLabel
              Left = 12
              Top = 43
              Width = 62
              Height = 13
              Caption = '/definitionfile'
              FocusControl = definitionfileEdit
            end
            object Label2: TLabel
              Left = 12
              Top = 70
              Width = 48
              Height = 13
              Caption = '/optionfile'
              FocusControl = optionfileEdit
            end
            object Label3: TLabel
              Left = 12
              Top = 97
              Width = 34
              Height = 13
              Caption = '/option'
            end
            object Label18: TLabel
              Left = 11
              Top = 125
              Width = 104
              Height = 13
              Caption = '/curlauthenticationfile'
              FocusControl = CurlAuthenticationFileEdit
            end
            object Label20: TLabel
              Left = 11
              Top = 152
              Width = 85
              Height = 13
              Caption = '/curlparameterfile'
              FocusControl = CurlParameterFileEdit
            end
            object Label24: TLabel
              Left = 13
              Top = 16
              Width = 68
              Height = 13
              Caption = '/parameterfile'
              FocusControl = parameterFileEdit
            end
            object definitionfileEdit: TEdit
              Left = 129
              Top = 40
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
            object optionfileEdit: TEdit
              Left = 129
              Top = 67
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
            end
            object optionComboBox: TComboBox
              Left = 129
              Top = 94
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 3
            end
            object formatDefinitionFilesCheckBox: TCheckBox
              Left = 129
              Top = 176
              Width = 160
              Height = 17
              Caption = '/formatdefinitionfiles'
              TabOrder = 6
            end
            object CurlAuthenticationFileEdit: TEdit
              Left = 129
              Top = 122
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
            end
            object CurlParameterFileEdit: TEdit
              Left = 129
              Top = 149
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 5
            end
            object parameterFileEdit: TEdit
              Left = 129
              Top = 13
              Width = 255
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
          end
        end
        object MiddleInputPanel: TPanel
          Left = 404
          Top = 0
          Width = 427
          Height = 353
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            427
            353)
          object GroupBox5: TGroupBox
            Left = 0
            Top = 233
            Width = 417
            Height = 77
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Filter'
            TabOrder = 0
            DesignSize = (
              417
              77)
            object Label14: TLabel
              Left = 20
              Top = 51
              Width = 44
              Height = 13
              Caption = '/titlefilter'
              FocusControl = titlefilterEdit
            end
            object Label15: TLabel
              Left = 20
              Top = 24
              Width = 50
              Height = 13
              Caption = '/identfilter'
              FocusControl = identfilterEdit
            end
            object titlefilterEdit: TEdit
              Left = 137
              Top = 43
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
            object identfilterEdit: TEdit
              Left = 137
              Top = 16
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
          end
          object GroupBox4: TGroupBox
            Left = 0
            Top = 3
            Width = 417
            Height = 208
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Output'
            TabOrder = 1
            DesignSize = (
              417
              208)
            object Label7: TLabel
              Left = 17
              Top = 100
              Width = 60
              Height = 13
              Caption = '/openoutput'
              FocusControl = openoutputEdit
            end
            object Label8: TLabel
              Left = 17
              Top = 19
              Width = 58
              Height = 13
              Caption = '/outputpath'
              FocusControl = outputpathEdit
            end
            object Label9: TLabel
              Left = 17
              Top = 73
              Width = 68
              Height = 13
              Caption = '/outputformat'
              FocusControl = outputformatEdit
            end
            object Label12: TLabel
              Left = 17
              Top = 156
              Width = 30
              Height = 13
              Caption = '/detail'
              FocusControl = detailEdit
            end
            object Label13: TLabel
              Left = 17
              Top = 129
              Width = 32
              Height = 13
              Caption = '/group'
              FocusControl = groupEdit
            end
            object Label23: TLabel
              Left = 17
              Top = 46
              Width = 63
              Height = 13
              Caption = '/outputsuffix'
              FocusControl = outputsuffixEdit
            end
            object openoutputEdit: TEdit
              Left = 134
              Top = 97
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
            end
            object outputformatEdit: TEdit
              Left = 134
              Top = 70
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
            end
            object outputpathEdit: TEdit
              Left = 134
              Top = 13
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
            object detailEdit: TEdit
              Left = 134
              Top = 153
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 6
            end
            object groupEdit: TEdit
              Left = 134
              Top = 126
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 5
            end
            object generatesummaryCheckBox: TCheckBox
              Left = 134
              Top = 180
              Width = 120
              Height = 17
              AllowGrayed = True
              Caption = '/generatesummary'
              TabOrder = 8
            end
            object generatedetailsCheckBox: TCheckBox
              Left = 14
              Top = 180
              Width = 97
              Height = 17
              AllowGrayed = True
              Caption = '/generatedetails'
              TabOrder = 7
            end
            object OpenOutputAllCheckBox: TCheckBox
              Left = 83
              Top = 100
              Width = 51
              Height = 17
              Caption = 'All'
              TabOrder = 3
            end
            object outputsuffixEdit: TEdit
              Left = 134
              Top = 43
              Width = 272
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
          end
        end
        object RightInputPanel: TPanel
          Left = 831
          Top = 0
          Width = 508
          Height = 353
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          DesignSize = (
            508
            353)
          object Button1: TButton
            Left = 344
            Top = 319
            Width = 161
            Height = 25
            Action = ReloadAndConvertAction
            Anchors = [akTop, akRight]
            Default = True
            TabOrder = 0
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 216
            Width = 506
            Height = 97
            Anchors = [akLeft, akTop, akRight]
            Caption = 'PlantUML Jar'
            TabOrder = 1
            DesignSize = (
              506
              97)
            object PlantUmlJarFileLabel: TLabel
              Left = 20
              Top = 19
              Width = 71
              Height = 13
              Caption = '/plantumljarfile'
              FocusControl = PlantUmlJarFileEdit
            end
            object javaruntimeparameterLabel: TLabel
              Left = 20
              Top = 71
              Width = 111
              Height = 13
              Caption = '/javaruntimeparameter'
              FocusControl = javaruntimeparameterEdit
            end
            object Label25: TLabel
              Left = 20
              Top = 43
              Width = 110
              Height = 13
              Caption = '/plantumlruntimeparam'
              FocusControl = PlantUmlRuntimeParameterEdit
            end
            object PlantUmlJarFileEdit: TEdit
              Left = 137
              Top = 16
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
            object javaruntimeparameterEdit: TEdit
              Left = 137
              Top = 67
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
            end
            object PlantUmlRuntimeParameterEdit: TEdit
              Left = 137
              Top = 42
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
          end
          object GroupBox6: TGroupBox
            Left = 0
            Top = 157
            Width = 506
            Height = 53
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Other'
            TabOrder = 2
            object generateoutputdefinitionCheckBox: TCheckBox
              Left = 137
              Top = 17
              Width = 152
              Height = 14
              Caption = '/generateoutputdefinition'
              TabOrder = 1
            end
            object debugCheckBox: TCheckBox
              Left = 17
              Top = 17
              Width = 97
              Height = 14
              Caption = '/debug'
              TabOrder = 0
            end
          end
          object GroupBox3: TGroupBox
            Left = 0
            Top = 1
            Width = 506
            Height = 150
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Input'
            TabOrder = 3
            DesignSize = (
              506
              150)
            object Label4: TLabel
              Left = 20
              Top = 78
              Width = 68
              Height = 13
              Caption = '/leadingobject'
              FocusControl = leadingObjectEdit
            end
            object Label5: TLabel
              Left = 20
              Top = 51
              Width = 55
              Height = 13
              Caption = '/inputlistfile'
              FocusControl = inputlistfileEdit
            end
            object Label6: TLabel
              Left = 20
              Top = 24
              Width = 42
              Height = 13
              Caption = '/inputfile'
              FocusControl = inputfileEdit
            end
            object Label17: TLabel
              Left = 19
              Top = 128
              Width = 65
              Height = 13
              Caption = '/splitidentifier'
              FocusControl = splitIdentifierEdit
            end
            object inputfileEdit: TEdit
              Left = 137
              Top = 16
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
            object inputlistfileEdit: TEdit
              Left = 137
              Top = 43
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
            end
            object leadingObjectEdit: TEdit
              Left = 137
              Top = 70
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
            end
            object splitInputFileCheckBox: TCheckBox
              Left = 137
              Top = 97
              Width = 97
              Height = 17
              AllowGrayed = True
              Caption = '/splitinputfile'
              TabOrder = 3
            end
            object splitIdentifierEdit: TEdit
              Left = 137
              Top = 120
              Width = 361
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
            end
          end
          object Button2: TButton
            Left = 177
            Top = 319
            Width = 161
            Height = 25
            Action = GenerateServiceListResultsAction
            Anchors = [akTop, akRight]
            Default = True
            TabOrder = 4
          end
        end
      end
      object LogFileDetailPageControl: TPageControl
        Left = 0
        Top = 353
        Width = 1339
        Height = 417
        ActivePage = ServiceInputListFileResult
        Align = alClient
        TabOrder = 1
        object ExecutionLogTabSheet: TTabSheet
          Caption = 'Execution Log'
          object ExecutionLogPanel: TPanel
            Left = 0
            Top = 0
            Width = 1331
            Height = 389
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object ProgressbarPanel: TPanel
              Left = 0
              Top = 0
              Width = 1331
              Height = 47
              Align = alTop
              TabOrder = 0
              DesignSize = (
                1331
                47)
              object Label26: TLabel
                Left = 6
                Top = 10
                Width = 36
                Height = 13
                Caption = 'Expand'
              end
              object Label27: TLabel
                Left = 6
                Top = 26
                Width = 39
                Height = 13
                Caption = 'Convert'
              end
              object ExpandProgressBar: TProgressBar
                Left = 51
                Top = 7
                Width = 1275
                Height = 17
                Anchors = [akLeft, akTop, akRight]
                Smooth = True
                TabOrder = 0
              end
              object ConvertProgressBar: TProgressBar
                Left = 51
                Top = 24
                Width = 1275
                Height = 17
                Anchors = [akLeft, akTop, akRight]
                Smooth = True
                TabOrder = 1
              end
            end
          end
        end
        object CurlFileTabSheet: TTabSheet
          Caption = 'Curl Files'
          ImageIndex = 5
          object CurlFileListDBGrid: TDBGrid
            Left = 0
            Top = 0
            Width = 1331
            Height = 359
            Align = alClient
            DataSource = CurlFileListDataSource
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
          end
          object Panel1: TPanel
            Left = 0
            Top = 359
            Width = 1331
            Height = 30
            Align = alBottom
            TabOrder = 1
            DesignSize = (
              1331
              30)
            object Label28: TLabel
              Left = 4
              Top = 9
              Width = 76
              Height = 13
              Caption = 'Curl Command :'
            end
            object DBEdit1: TDBEdit
              Left = 82
              Top = 4
              Width = 1247
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              DataField = 'Command'
              DataSource = CurlFileListDataSource
              TabOrder = 0
            end
          end
        end
        object ResultFileListTabSheet: TTabSheet
          Caption = 'Filelist'
          ImageIndex = 1
          object FileListPanel: TPanel
            Left = 0
            Top = 0
            Width = 1331
            Height = 389
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
          end
        end
        object ServiceResultPage: TTabSheet
          Caption = 'post /json2pumlRequest'
          ImageIndex = 2
          object ServiceResultPanel: TPanel
            Left = 0
            Top = 0
            Width = 1331
            Height = 389
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
          end
        end
        object ServiceInputListFileResult: TTabSheet
          Caption = 'get /inputlistfile'
          ImageIndex = 3
          object ServiceInputListFileResultPanel: TPanel
            Left = 0
            Top = 0
            Width = 1331
            Height = 389
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'get /definitionfile'
          ImageIndex = 4
          object ServiceDefinitionFileResultPanel: TPanel
            Left = 0
            Top = 0
            Width = 1331
            Height = 389
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
          end
        end
      end
    end
    object OutputTabsheet: TTabSheet
      BorderWidth = 5
      Caption = 'Output Files '
      ImageIndex = 3
      object FilePageControl: TPageControl
        Left = 0
        Top = 0
        Width = 1339
        Height = 770
        Align = alClient
        MultiLine = True
        TabOrder = 0
      end
    end
    object InputListTabSheet: TTabSheet
      BorderWidth = 5
      Caption = 'Input List'
      ImageIndex = 1
    end
    object CurlAuthenticationTabSheet: TTabSheet
      Caption = 'Curl Authentication File'
      ImageIndex = 5
    end
    object CurlParameterFileTabSheet: TTabSheet
      Caption = 'Curl Parameter File'
      ImageIndex = 6
    end
    object DefinitionFileTabSheet: TTabSheet
      BorderWidth = 5
      Caption = 'Definition File'
      ImageIndex = 2
    end
    object OptionFileTabSheet: TTabSheet
      BorderWidth = 5
      Caption = 'Option File'
      ImageIndex = 4
    end
    object ParameterFileTabSheet: TTabSheet
      Caption = 'Parameter File'
      ImageIndex = 7
    end
    object GlobalConfigurationFileTabSheet: TTabSheet
      Caption = 'Global Configuration File'
      ImageIndex = 8
    end
  end
  object ActionToolBar5: TActionToolBar
    Left = 0
    Top = 25
    Width = 1357
    Height = 25
    ActionManager = MainActionManager
    Caption = 'EditToolbar'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Spacing = 0
  end
  object MainActionList: TActionList
    Images = ImageList1
    Left = 904
    Top = 600
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object ShowCurlParameterAction: TAction
      Category = 'Show'
      Caption = 'Show &Curl Parameter File'
      OnExecute = ShowCurlParameterActionExecute
    end
    object LoadFileAction: TAction
      Category = 'Edit'
      Caption = 'Open configuration file'
      OnExecute = LoadFileActionExecute
      OnUpdate = SaveFileActionUpdate
    end
    object ConvertAllOpenFilesAction: TAction
      Category = 'Execute'
      Caption = 'Convert all open files'
      ImageIndex = 15
      ShortCut = 116
      OnExecute = ConvertAllOpenFilesActionExecute
    end
    object ReloadAndConvertAction: TAction
      Category = 'Execute'
      Caption = 'Reload and convert files'
      ShortCut = 16466
      OnExecute = ReloadAndConvertActionExecute
    end
    object CopyCurrentPUMLAction: TAction
      Category = 'Output Files'
      Caption = 'Copy current PUML to clipboard'
      ShortCut = 118
      OnExecute = CopyCurrentPUMLActionExecute
    end
    object ExitAction: TAction
      Category = 'File'
      Caption = 'Exit'
      ShortCut = 32883
      OnExecute = ExitActionExecute
    end
    object OpenCurrentPNGAction: TAction
      Category = 'Output Files'
      Caption = 'Open Current PNG File'
      ShortCut = 119
      OnExecute = OpenCurrentPNGActionExecute
    end
    object OpenCurrentSVGAction: TAction
      Category = 'Output Files'
      Caption = 'Open Current SVG File'
      ShortCut = 120
      OnExecute = OpenCurrentSVGActionExecute
    end
    object ShowExecuteAction: TAction
      Category = 'Show'
      Caption = 'Show &Execute'
      OnExecute = ShowExecuteActionExecute
    end
    object ConvertCurrentFileAction: TAction
      Category = 'Output Files'
      Caption = 'Convert Current File'
      ShortCut = 117
      OnExecute = ConvertCurrentFileActionExecute
    end
    object ShowInputListAction: TAction
      Category = 'Show'
      Caption = 'Show &Input List'
      OnExecute = ShowInputListActionExecute
    end
    object ShowDefinitionFileAction: TAction
      Category = 'Show'
      Caption = 'Show &Definition File'
      OnExecute = ShowDefinitionFileActionExecute
    end
    object ShowOutputFilesAction: TAction
      Category = 'Show'
      Caption = 'Show &Result Files'
      OnExecute = ShowOutputFilesActionExecute
    end
    object ShowOptionFileAction: TAction
      Category = 'Show'
      Caption = 'Show O&ption File'
      OnExecute = ShowOptionFileActionExecute
    end
    object ShowCurlAuthenticationAction: TAction
      Category = 'Show'
      Caption = 'Show Curl &Authentication File'
      OnExecute = ShowCurlAuthenticationActionExecute
    end
    object ShowParameterFileAction: TAction
      Category = 'Show'
      Caption = 'Show P&arameter File'
      OnExecute = ShowParameterFileActionExecute
    end
    object SaveFileAction: TAction
      Category = 'Edit'
      Caption = 'Save configuration file'
      ShortCut = 16467
      OnExecute = SaveFileActionExecute
      OnUpdate = SaveFileActionUpdate
    end
    object SaveAsFileAction: TAction
      Category = 'Edit'
      Caption = 'Save configuration file as'
      Visible = False
      OnUpdate = SaveFileActionUpdate
    end
    object ReloadFileAction: TAction
      Category = 'Edit'
      Caption = 'Reload configuration file'
      OnExecute = ReloadFileActionExecute
      OnUpdate = SaveFileActionUpdate
    end
    object ShowGlobalConfigFile: TAction
      Category = 'Show'
      Caption = 'Show &Global Configuration File'
    end
    object OpenCurrentJSONAction: TAction
      Category = 'Output Files'
      Caption = 'Open Current JSON File'
      ShortCut = 118
      OnExecute = OpenCurrentJSONActionExecute
    end
    object OpenConfigurationFileExternal: TAction
      Category = 'Edit'
      Caption = 'Open configuration file external'
      OnExecute = OpenConfigurationFileExternalExecute
      OnUpdate = SaveFileActionUpdate
    end
    object GenerateServiceListResultsAction: TAction
      Category = 'Execute'
      Caption = 'Generate ServiceList Results'
      OnExecute = GenerateServiceListResultsActionExecute
    end
  end
  object ImageList1: TImageList
    Left = 640
    Top = 624
    Bitmap = {
      494C010110001500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000C0C0C0008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000C0C0
      C000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000000000000000000002121
      21006A6A6A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000C0C0C0008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      000000000000111111008F8F8F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000C0C0C000800000008000
      000080000000000000000000000000000000000000000000000080808000C0C0
      C000FFFFFF008080800000000000800000000000000000000000000000000000
      00000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031313100C5C5C50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000FFFFFF008080800080000000800000008000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000FFFFFF0080808000000000000000000000000000000000000000
      80000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0080808000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FFFFFF00000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F0F0F008F8F
      8F00000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      80000000800000000000000000000000800000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003E3E3E0000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000080000000000000000000000080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003D3D3D0000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F0F0F008F8F
      8F000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031313100C5C5C50000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFF0000FFFF0000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000111111008F8F8F00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000002121
      21006B6B6B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C000FFFF00008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      80000080800000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000080800000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000FFFF0000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000C0C0C0008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF0000000000C0C0
      C00000000000FFFFFF0000000000C0C0C00000000000C0C0C000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000008000000080000000800000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000C0C0C000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      80000080800000000000000000000000000000000000000000007F5B00000000
      0000000000000000000000000000000000000000000064490400644904006449
      0400644904006449040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      80000080800000808000000000000000000000000000000000007F5B00000000
      0000000000000000000000000000000000000000000000000000916B0A007F5B
      00007F5B0000916B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F5B00000000
      0000000000000000000000000000000000000000000000000000D9A77D00916B
      0A007F5B0000916B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      00000000000000000000000000000000000000000000000000007F5B0000D9A7
      7D000000000000000000000000000000000000000000D9A77D007F5B0000D9A7
      7D00916B0A00916B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000D9A77D007F5B
      0000D9A77D000000000000000000D9A77D007F5B00007F5B0000D9A77D000000
      000000000000916B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D9A7
      7D007F5B00007F5B00007F5B00007F5B0000D9A77D0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000080000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00000000000000000000000000FFFF
      FF00800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000080000000800000008000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000000000000644904006449
      0400644904006449040064490400000000000000000000000000000000000000
      0000000000007F5B000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000080000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000000000916B0A007F5B
      00007F5B0000916B0A0000000000000000000000000000000000000000000000
      0000000000007F5B000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF000000000000000000FFFF
      FF00800000008000000080000000800000000000000000808000808080000080
      8000808080000080800080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000916B0A007F5B
      0000916B0A00D9A77D0000000000000000000000000000000000000000000000
      0000000000007F5B000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000080808000008080008080
      8000008080008080800000808000808080000080800080808000008080008080
      8000008080000000000000000000000000000000000000000000916B0A00916B
      0A00D9A77D007F5B0000D9A77D00000000000000000000000000000000000000
      0000D9A77D007F5B000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000808000808080000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000916B0A000000
      000000000000D9A77D007F5B00007F5B0000D9A77D000000000000000000D9A7
      7D007F5B0000D9A77D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080808000808080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000000008080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D9A77D007F5B00007F5B00007F5B00007F5B
      0000D9A77D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000808080000080
      80000000000000FFFF00000000000000000000FFFF0000000000808080000080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFF3FFFFFFFFFFFFFFE1FF3FC007FFFF
      FFC1FE3F8003E7FFFF83C07F0001E1FFF00780F70001E07FC00F00E70001E03F
      801F00C10000E00F801F00E60000E007000F00F68000E007000F81FEC000E00F
      000FC3BFE001E03F000FFFB7E007E07F801FFFB3F007E1FF801FFFC1F003E7FF
      C03FFFF3F803FFFFF0FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFC001000C000FF9FF
      80010008000FF9FF80010001000FF3C780010003000F73C780010003000F27FF
      80010003000F07C780010003000F00C780010003000F01E380010007000403F1
      8001000F000006388001000F00000E388001000FF8001E388001001FFC003F01
      8001003FFE047F83FFFF007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEFFDC007001FFFFFC7FFC007000FFFFFC3FBC0070007FFFFE3F7C0070003
      DF83F1E7C0070001DFC3F8CFC0070000DFC3FC1FC007001FCF83FE3FC007001F
      C61BFC1FC007001FE07FF8CFC0078FF1FFFFE1E7C00FFFF9FFFFC3F3C01FFF75
      FFFFC7FDC03FFF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFC00FFFF
      F6CFFE008000FFFFF6B7FE000000FFFFF6B7FE000000FFFFF8B780000000FFFF
      FE8F80000001C1FBFE3F80000003C3FBFF7F80000003C3FBFE3F80010003C1F3
      FEBF80030003D863FC9F80070003FE07FDDF807F0003FFFFFDDF80FF8007FFFF
      FDDF81FFF87FFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object InitialTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = InitialTimerTimer
    Left = 640
    Top = 568
  end
  object MainActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ExitAction
                Caption = '&Exit'
                ShortCut = 32883
              end>
            Caption = '&File'
          end
          item
            Items = <
              item
                Action = ShowExecuteAction
              end
              item
                Action = ShowOutputFilesAction
              end
              item
                Action = ShowDefinitionFileAction
              end
              item
                Action = ShowParameterFileAction
              end
              item
                Action = ShowInputListAction
              end
              item
                Action = ShowCurlAuthenticationAction
              end
              item
                Action = ShowCurlParameterAction
              end
              item
                Action = ShowOptionFileAction
              end
              item
                Action = ShowGlobalConfigFile
              end>
            Caption = '&Show'
          end
          item
            Items = <
              item
                Action = EditCut1
                ImageIndex = 0
                ShortCut = 16472
              end
              item
                Action = EditCopy1
                ImageIndex = 1
                ShortCut = 16451
              end
              item
                Action = EditPaste1
                ImageIndex = 2
                ShortCut = 16470
              end
              item
                Caption = '-'
              end
              item
                Action = LoadFileAction
                Caption = '&Open configuration file'
              end
              item
                Action = ReloadFileAction
                Caption = '&Reload configuration file'
              end
              item
                Action = SaveFileAction
                Caption = '&Save configuration file'
                ShortCut = 16467
              end
              item
                Visible = False
                Action = SaveAsFileAction
                Caption = 'S&ave configuration file as'
              end
              item
                Caption = '-'
              end
              item
                Action = OpenConfigurationFileExternal
                Caption = 'Op&en configuration file external'
              end>
            Caption = '&Edit'
          end
          item
            Items = <
              item
                Caption = '-'
              end
              item
                Action = ConvertCurrentFileAction
                Caption = 'C&onvert Current File'
                ShortCut = 117
              end
              item
                Caption = '-'
              end
              item
                Action = CopyCurrentPUMLAction
                Caption = '&Copy current PUML to clipboard'
                ShortCut = 118
              end
              item
                Caption = '-'
              end
              item
                Action = OpenCurrentJSONAction
                Caption = 'Ope&n Current JSON File'
                ShortCut = 118
              end
              item
                Action = OpenCurrentPNGAction
                Caption = 'O&pen Current PNG File'
                ShortCut = 119
              end
              item
                Action = OpenCurrentSVGAction
                Caption = 'Op&en Current SVG File'
                ShortCut = 120
              end>
            Caption = 'Ou&tput Files'
          end
          item
            Items = <
              item
                Action = ConvertAllOpenFilesAction
                Caption = '&Convert all open files'
                ImageIndex = 15
                ShortCut = 116
              end
              item
                Action = ReloadAndConvertAction
                Caption = '&Reload and convert files'
                ShortCut = 16466
              end
              item
                Action = GenerateServiceListResultsAction
                Caption = '&Generate ServiceList Results'
              end>
            Caption = 'E&xecute'
          end>
        ActionBar = ActionMainMenuBar
      end
      item
        Items = <
          item
            Action = ReloadAndConvertAction
            Caption = '&Reload and convert files'
            ShortCut = 16466
          end
          item
            Action = ConvertAllOpenFilesAction
            Caption = '&Convert all open files'
            ImageIndex = 15
            ShortCut = 116
          end
          item
            Action = ConvertCurrentFileAction
            Caption = 'Co&nvert Current File'
            NewCol = True
            NewRow = True
            ShortCut = 117
          end
          item
            Caption = '-'
          end
          item
            Action = CopyCurrentPUMLAction
            Caption = 'C&opy current PUML to clipboard'
            ShortCut = 118
          end
          item
            Caption = '-'
          end
          item
            Action = OpenCurrentJSONAction
            Caption = 'Open C&urrent JSON File'
            ShortCut = 118
          end
          item
            Action = OpenCurrentPNGAction
            Caption = 'O&pen Current PNG File'
            ShortCut = 119
          end
          item
            Action = OpenCurrentSVGAction
            Caption = 'Op&en Current SVG File'
            ShortCut = 120
          end>
        ActionBar = MainActionToolBar
      end
      item
        Items = <
          item
            Caption = '-'
          end>
      end
      item
        Items = <
          item
            Caption = '-'
          end
          item
            Action = ReloadAndConvertAction
            Caption = '&Reload and convert files'
            ShortCut = 16466
          end>
      end
      item
        Items = <
          item
            Caption = '-'
          end
          item
            Action = ConvertAllOpenFilesAction
            Caption = '&Convert all open files'
            ImageIndex = 15
            ShortCut = 116
          end>
      end
      item
      end
      item
      end
      item
        Items = <
          item
            Caption = '-'
          end
          item
            Action = ConvertAllOpenFilesAction
            Caption = '&Convert all open files'
            ImageIndex = 15
            ShortCut = 116
          end>
      end
      item
        Items = <
          item
            Action = EditCut1
            ImageIndex = 0
            ShortCut = 16472
          end
          item
            Action = EditCopy1
            ImageIndex = 1
            ShortCut = 16451
          end
          item
            Action = EditPaste1
            ImageIndex = 2
            ShortCut = 16470
          end
          item
            Caption = '-'
          end
          item
            Action = LoadFileAction
            Caption = '&Open configuration file'
          end
          item
            Action = SaveFileAction
            Caption = '&Save configuration file'
            ShortCut = 16467
          end
          item
            Visible = False
            Action = SaveAsFileAction
            Caption = 'S&ave configuration file as'
          end
          item
            Action = ReloadFileAction
            Caption = '&Reload configuration file'
          end
          item
            Action = OpenConfigurationFileExternal
            Caption = 'Op&en configuration file external'
          end>
        ActionBar = ActionToolBar5
      end>
    LinkedActionLists = <
      item
        ActionList = MainActionList
        Caption = 'MainActionList'
      end>
    Left = 904
    Top = 544
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'File'
      Caption = 'Save Current File'
      ShortCut = 16467
    end
  end
  object CurlParameterDataSource: TDataSource
    DataSet = CurlParameterDataSet
    Left = 96
    Top = 528
  end
  object CurlAuthenticationParameterDataSource: TDataSource
    DataSet = CurlAuthenticationParameterDataset
    Left = 232
    Top = 536
  end
  object CurlParameterDataSet: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 88
    Top = 609
    object CurlParameterDataSetName: TStringField
      DisplayWidth = 20
      FieldName = 'Name'
      Size = 200
    end
    object CurlParameterDataSetValue: TStringField
      DisplayWidth = 50
      FieldName = 'Value'
      Size = 1000
    end
  end
  object CurlAuthenticationParameterDataset: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 248
    Top = 617
    object StringField3: TStringField
      DisplayWidth = 20
      FieldName = 'Name'
      Size = 200
    end
    object StringField4: TStringField
      DisplayWidth = 50
      FieldName = 'Value'
      Size = 1000
    end
  end
  object JsonActionList: TActionList
    Left = 904
    Top = 664
  end
  object Taskbar: TTaskbar
    TaskBarButtons = <>
    TabProperties = []
    Left = 864
    Top = 448
  end
  object CurlFileListMemTable: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 376
    Top = 649
    object CurlFileListMemTableLine: TIntegerField
      FieldName = 'Line'
    end
    object CurlFileListMemTableInputFile: TStringField
      FieldName = 'InputFile'
      Size = 1000
    end
    object CurlFileListMemTableOutputFile: TStringField
      FieldName = 'OutputFile'
      Size = 1000
    end
    object CurlFileListMemTableUrl: TStringField
      FieldName = 'Url'
      Size = 1000
    end
    object CurlFileListMemTableGenerated: TBooleanField
      Alignment = taCenter
      FieldName = 'Generated'
    end
    object CurlFileListMemTableDuration: TStringField
      Alignment = taRightJustify
      FieldName = 'Duration'
    end
    object CurlFileListMemTableErrorMessage: TStringField
      FieldName = 'ErrorMessage'
      Size = 1000
    end
    object CurlFileListMemTableCommand: TStringField
      FieldName = 'Command'
      Size = 1000
    end
  end
  object CurlFileListDataSource: TDataSource
    DataSet = CurlFileListMemTable
    Left = 384
    Top = 560
  end
end
