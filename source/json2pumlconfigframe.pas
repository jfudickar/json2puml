unit json2pumlconfigframe;

interface

{$I json2puml.inc}

uses
{$IFDEF SYNEDIT}
  SynEdit,
{$ENDIF}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, json2pumlconst, json2pumlframe, json2pumlbasedefinition, Vcl.ExtDlgs, json2pumlvcltools;

type
  TJson2PumlConfigurationFrame = class(TFrame)
    EditPanel: TPanel;
    TopPanel: TPanel;
    FileLabel: TLabel;
    FileNameEdit: TEdit;
    SaveDialog: TSaveTextFileDialog;
    OpenDialog: TOpenTextFileDialog;
  private
    FConfigObjectClass: tJson2PumlBaseObjectClass;
    FLines: TStrings;
    FMainEditor: TWinControl;
    FPage: tJson2PumlPage;
    FOnGetConfigFileName: TJson2PumlGetConfigFileName;
    FOnLoadConfigFileName: TJson2PumlLoadConfigFileName;
    FOnSetConfigFileName: TJson2PumlSetConfigFileName;

    function GetConfigFileName: string;
{$IFDEF SYNEDIT}
    function GetSynEdit: TSynEdit;
{$ELSE}
    function GetMemo: TMemo;
{$ENDIF}
    procedure SetConfigFileName (const Value: string);
    procedure SetOnGetConfigFileName (const Value: TJson2PumlGetConfigFileName);
    procedure SetLines (const Value: TStrings);
    procedure SetPage (const Value: tJson2PumlPage);
    { Private declarations }
  protected
    function GetNewFileName (iFileName: string; var oNewFileName: string): Boolean;
    property MainEditor: TWinControl read FMainEditor;
{$IFDEF SYNEDIT}
    property SynEdit: TSynEdit read GetSynEdit;
{$ELSE}
    property Memo: TMemo read GetMemo;
{$ENDIF}
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateMemos (iCreateMemoProc: TJson2PumlCreateMemoEvent);
    procedure LoadFile (iFileName: string = '');
    procedure OpenFile;
    procedure ReloadFile;
    procedure SaveFile (iNewFileName: string = '');
    procedure SaveFileAs;
    procedure UpdateInfos;
    property ConfigFileName: string read GetConfigFileName write SetConfigFileName;
    property ConfigObjectClass: tJson2PumlBaseObjectClass read FConfigObjectClass write FConfigObjectClass;
    property OnGetConfigFileName: TJson2PumlGetConfigFileName read FOnGetConfigFileName write SetOnGetConfigFileName;
    property Lines: TStrings read FLines write SetLines;
    property OnLoadConfigFileName: TJson2PumlLoadConfigFileName read FOnLoadConfigFileName write FOnLoadConfigFileName;
    property Page: tJson2PumlPage read FPage write SetPage;
    property OnSetConfigFileName: TJson2PumlSetConfigFileName read FOnSetConfigFileName write FOnSetConfigFileName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TJson2PumlConfigurationFrame.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
end;

destructor TJson2PumlConfigurationFrame.Destroy;
begin
  inherited Destroy;
end;

procedure TJson2PumlConfigurationFrame.CreateMemos (iCreateMemoProc: TJson2PumlCreateMemoEvent);
begin
  if Assigned (iCreateMemoProc) then
  begin
    FMainEditor := iCreateMemoProc (EditPanel, 'EditMemo', nil, FLines, true, false);
  end;
end;

function TJson2PumlConfigurationFrame.GetConfigFileName: string;
begin
  if Assigned (FOnGetConfigFileName) then
    Result := OnGetConfigFileName (Page)
  else
    Result := '';
end;

function TJson2PumlConfigurationFrame.GetNewFileName (iFileName: string; var oNewFileName: string): Boolean;
begin
  OpenDialog.InitialDir := ExtractFilePath (iFileName);
  Result := OpenDialog.Execute;
  if Result then
    oNewFileName := OpenDialog.FileName;
end;

procedure TJson2PumlConfigurationFrame.LoadFile (iFileName: string = '');
var
  xpos: Integer;
  yPos: Integer;
begin
{$IFDEF SYNEDIT}
  xpos := SynEdit.CaretX;
  yPos := SynEdit.CaretY;
{$ENDIF}
  try
    if Assigned (OnLoadConfigFileName) then
      OnLoadConfigFileName (Page, iFileName);
  finally
{$IFDEF SYNEDIT}
    SynEdit.CaretX := xpos;
    SynEdit.CaretY := yPos;
{$ENDIF}
  end;
end;

procedure TJson2PumlConfigurationFrame.OpenFile;
var
  NewName: string;
begin
  if GetNewFileName (ConfigFileName, NewName) then
    LoadFile (NewName);
end;

procedure TJson2PumlConfigurationFrame.ReloadFile;
begin
  LoadFile;
end;

procedure TJson2PumlConfigurationFrame.SaveFile (iNewFileName: string = '');
var
  ConfigObject: tJson2PumlBaseObject;
  FileName: string;
var
  xpos: Integer;
  yPos: Integer;
begin
{$IFDEF SYNEDIT}
  xpos := SynEdit.CaretX;
  yPos := SynEdit.CaretY;
{$ENDIF}
  try
    if iNewFileName.IsEmpty then
      FileName := ConfigFileName
    else
      FileName := iNewFileName;
    ConfigObject := ConfigObjectClass.Create;
    try
      if not ConfigObject.SaveToFile (Lines, FileName, true) then
        MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
    finally
      ConfigObject.Free;
    end;
  finally
{$IFDEF SYNEDIT}
    SynEdit.CaretX := xpos;
    SynEdit.CaretY := yPos;
{$ENDIF}
  end;
end;

procedure TJson2PumlConfigurationFrame.SaveFileAs;
begin
  // TODO -cMM: TJson2PumlConfigurationFrame.SaveFileAs default body inserted
end;

procedure TJson2PumlConfigurationFrame.SetConfigFileName (const Value: string);
begin
  if Assigned (FOnSetConfigFileName) then
    OnSetConfigFileName (Page, Value);
end;

procedure TJson2PumlConfigurationFrame.SetOnGetConfigFileName (const Value: TJson2PumlGetConfigFileName);
begin
  FOnGetConfigFileName := Value;
  UpdateInfos;
end;

procedure TJson2PumlConfigurationFrame.SetLines (const Value: TStrings);
begin
  FLines.Assign (Value);
end;

procedure TJson2PumlConfigurationFrame.SetPage (const Value: tJson2PumlPage);
begin
  FPage := Value;
  UpdateInfos;
end;

procedure TJson2PumlConfigurationFrame.UpdateInfos;
begin
  FileNameEdit.Text := ConfigFileName;
end;

{$IFDEF SYNEDIT}

function TJson2PumlConfigurationFrame.GetSynEdit: TSynEdit;
begin
  Result := TSynEdit (MainEditor);
end;

{$ELSE}

function TJson2PumlConfigurationFrame.GetMemo: TMemo;
begin
  // TODO -cMM: TJson2PumlConfigurationFrame.GetMemo default body inserted
  Result := TMemo (MainEditor);
end;

{$ENDIF}

end.
