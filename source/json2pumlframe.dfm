object Json2PumlOutputFileFrame: TJson2PumlOutputFileFrame
  Left = 0
  Top = 0
  Width = 565
  Height = 727
  TabOrder = 0
  object NamePanel: TPanel
    Left = 0
    Top = 0
    Width = 565
    Height = 727
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 1
      Top = 289
      Width = 563
      Height = 5
      Cursor = crVSplit
      Align = alTop
    end
    object InputPanel: TPanel
      Left = 1
      Top = 1
      Width = 563
      Height = 288
      Align = alTop
      TabOrder = 0
      object InputLabel: TLabel
        Left = 1
        Top = 1
        Width = 561
        Height = 15
        Align = alTop
        Caption = 'Json &Input'
        ExplicitWidth = 54
      end
      object Panel1: TPanel
        Left = 1
        Top = 16
        Width = 561
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          561
          27)
        object Label1: TLabel
          Left = 0
          Top = 6
          Width = 83
          Height = 15
          Caption = 'Leading Object:'
          FocusControl = LeadingObjectEdit
        end
        object LeadingObjectEdit: TEdit
          Left = 82
          Top = 3
          Width = 475
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Text = 'LeadingObjectEdit'
        end
      end
    end
    object BottomPanel: TPanel
      Left = 1
      Top = 294
      Width = 563
      Height = 432
      Align = alClient
      TabOrder = 1
      object ResultPageControl: TPageControl
        Left = 1
        Top = 1
        Width = 561
        Height = 430
        ActivePage = PNGTabSheet
        Align = alClient
        TabOrder = 0
        object PumlTabSheet: TTabSheet
          Caption = 'PUML Output'
          object PUMLFileNameEdit: TEdit
            Left = 0
            Top = 0
            Width = 553
            Height = 23
            Align = alTop
            ReadOnly = True
            TabOrder = 0
          end
        end
        object LogFileTabSheet: TTabSheet
          Caption = 'Converter Log'
          ImageIndex = 2
          object LogFileNameEdit: TEdit
            Left = 0
            Top = 0
            Width = 553
            Height = 23
            Align = alTop
            ReadOnly = True
            TabOrder = 0
          end
        end
        object PNGTabSheet: TTabSheet
          Caption = 'PNG Image'
          ImageIndex = 1
          object PNGScrollBox: TScrollBox
            Left = 0
            Top = 23
            Width = 553
            Height = 377
            HorzScrollBar.Tracking = True
            VertScrollBar.Smooth = True
            Align = alClient
            TabOrder = 0
            object ResultImage: TImage
              Left = 0
              Top = 0
              Width = 549
              Height = 373
              Align = alClient
              AutoSize = True
              Proportional = True
              ExplicitLeft = -2
              ExplicitTop = -3
              ExplicitHeight = 328
            end
          end
          object PNGFileNameEdit: TEdit
            Left = 0
            Top = 0
            Width = 553
            Height = 23
            Align = alTop
            ReadOnly = True
            TabOrder = 1
          end
        end
        object SVGTabSheet: TTabSheet
          Caption = 'SVG Image'
          ImageIndex = 3
          object SVGScrollBox: TScrollBox
            Left = 0
            Top = 23
            Width = 553
            Height = 377
            Align = alClient
            TabOrder = 0
          end
          object SVGFileNameEdit: TEdit
            Left = 0
            Top = 0
            Width = 553
            Height = 23
            Align = alTop
            ReadOnly = True
            TabOrder = 1
          end
        end
      end
    end
  end
end
