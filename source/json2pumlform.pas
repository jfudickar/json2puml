{ -------------------------------------------------------------------------------

  This file is part of the json2puml project.

  Copyright (C) 2023 Jens Fudickar

  This program is free software; you can redistribute it and/or modify it under the
  terms of the GNU General Public License as published by the Free Software Foundation;
  either version 3 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along with this program;
  if not, see http://www.gnu.org/licenses/gpl-3.0

  I am available for any questions/requests: jens.fudickar@oratool.de

  You may retrieve the latest version of this file at the json2puml home page,
  located at https://github.com/jfudickar/json2puml

  ------------------------------------------------------------------------------- }

unit json2pumlform;

interface

{$DEFINE SYNEDIT}

uses
{$IFDEF SYNEDIT}
  SynHighlighterJSON, SynEdit,
{$ENDIF}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, Vcl.StdActns, System.Actions, Vcl.ActnList,
  json2pumlframe, json2pumldefinition, Vcl.ActnMenus, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ExtDlgs, Vcl.Grids, json2pumlinputhandler, Vcl.PlatformDefaultStyleActnCtrls, Data.DB, Datasnap.DBClient,
  Vcl.DBGrids;

type
  tSingleFileFrame = class(TObject)
  private
    FFrame: TJson2PumlSingleFileFrame;
    FTabSheet: TTabSheet;
  public
    destructor Destroy; override;
    property Frame: TJson2PumlSingleFileFrame read FFrame write FFrame;
    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
  end;

  tFrameList = class(tStringList)
  private
    function GetFileFrame (Index: Integer): tSingleFileFrame;
  public
    property FileFrame[index: Integer]: tSingleFileFrame read GetFileFrame; default;
  end;

  Tjson2pumlMainForm = class(TForm)
    ActionMainMenuBar: TActionMainMenuBar;
    ActionToolBar1: TActionToolBar;
    ActionToolBar2: TActionToolBar;
    CurlAuthenticationFileEdit: TEdit;
    CurlAuthenticationFileLabel: TLabel;
    CurlAuthenticationFilePanel: TPanel;
    CurlAuthenticationTabSheet: TTabSheet;
    Button1: TButton;
    CommandLineEditPanel: TPanel;
    ConvertAllOpenFilesAction: TAction;
    ConvertCurrentFileAction: TAction;
    CopyCurrentPUMLAction: TAction;
    debugCheckBox: TCheckBox;
    DefinitionActionToolBar: TActionToolBar;
    definitionfileEdit: TEdit;
    DefinitionFileTabSheet: TTabSheet;
    DefinitionLabel: TLabel;
    DefinitionPanel: TPanel;
    detailEdit: TEdit;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    ExitAction: TAction;
    FilePageControl: TPageControl;
    formatDefinitionFilesCheckBox: TCheckBox;
    generatedetailsCheckBox: TCheckBox;
    generateoutputdefinitionCheckBox: TCheckBox;
    generatesummaryCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    groupEdit: TEdit;
    HelpAbout1: TAction;
    identfilterEdit: TEdit;
    ImageList1: TImageList;
    InitialTimer: TTimer;
    inputfileEdit: TEdit;
    InputlistActionToolBar: TActionToolBar;
    inputlistfileEdit: TEdit;
    InputlistLabel: TLabel;
    InputListPanel: TPanel;
    InputListTabSheet: TTabSheet;
    javaruntimeparameterEdit: TEdit;
    javaruntimeparameterLabel: TLabel;
    JsonActionList: TActionList;
    OutputTabsheet: TTabSheet;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    leadingObjectEdit: TEdit;
    LogTabSheet: TTabSheet;
    MainActionList: TActionList;
    MainActionManager: TActionManager;
    MainActionToolBar: TActionToolBar;
    MainPageControl: TPageControl;
    OpenCurlAuthenticationAction: TAction;
    OpenDefinitionAction: TAction;
    OpenDialog: TOpenTextFileDialog;
    OpenInputListAction: TAction;
    OpenOptionFileAction: TAction;
    OpenOutputAllCheckBox: TCheckBox;
    openoutputEdit: TEdit;
    OpenPNGAction: TAction;
    OpenSVGAction: TAction;
    optionComboBox: TComboBox;
    optionfileEdit: TEdit;
    OptionFileLabel: TLabel;
    OptionFilePanel: TPanel;
    OptionFileTabSheet: TTabSheet;
    outputformatEdit: TEdit;
    outputpathEdit: TEdit;
    PlantUmlJarFileEdit: TEdit;
    PlantUmlJarFileLabel: TLabel;
    RelaoadAndConvertFilesCurlAuthenticationAction: TAction;
    ReloadAndConvertAction: TAction;
    ReloadDefinitionAction: TAction;
    ReloadInputListAction: TAction;
    ReloadOptionFileAction: TAction;
    SaveCurlAuthenticationAction: TAction;
    SaveDefinitionAction: TAction;
    SaveDialog: TSaveTextFileDialog;
    SaveInputlistAction: TAction;
    SaveOptionFileAction: TAction;
    ShowCurlAuthenticationAction: TAction;
    ShowDefinitionFileAction: TAction;
    ShowInputListAction: TAction;
    ShowOutputFilesAction: TAction;
    ShowLog: TAction;
    ShowOptionFileAction: TAction;
    splitIdentifierEdit: TEdit;
    splitInputFileCheckBox: TCheckBox;
    StatusBar: TStatusBar;
    titlefilterEdit: TEdit;
    Label19: TLabel;
    CurlParameterFileEdit: TEdit;
    Label20: TLabel;
    CurlParameterFileTabSheet: TTabSheet;
    RelaoadAndConvertFilesCurlParameterAction: TAction;
    OpenCurlParameterAction: TAction;
    SaveCurlParameterAction: TAction;
    ShowCurlParameterAction: TAction;
    CurlParameterFilePanel: TPanel;
    CurlParameterFileLabel: TLabel;
    ActionToolBar3: TActionToolBar;
    Label22: TLabel;
    outputsuffixEdit: TEdit;
    Label23: TLabel;
    LogFileDetailPageControl: TPageControl;
    ExecutionLogTabSheet: TTabSheet;
    FileListTabSheet: TTabSheet;
    ExecutionLogPanel: TPanel;
    FileListPanel: TPanel;
    ParameterFileTabSheet: TTabSheet;
    OpenParameterFileAction: TAction;
    SaveParameterFileAction: TAction;
    ShowParameterFileAction: TAction;
    ReloadParameterFileAction: TAction;
    ParameterFilePanel: TPanel;
    ParameterFileLabel: TLabel;
    ActionToolBar4: TActionToolBar;
    parameterFileEdit: TEdit;
    Label24: TLabel;
    ServiceResultPage: TTabSheet;
    ServiceResultPanel: TPanel;
    ServiceInputListFileResult: TTabSheet;
    TabSheet2: TTabSheet;
    ServiceInputListFileResultPanel: TPanel;
    ServiceDefinitionFileResultPanel: TPanel;
    CurlParameterPageControl: TPageControl;
    CurlParameterTabSheet1: TTabSheet;
    CurlAuthenticationParameterTabSheet: TTabSheet;
    CurlParameterDBGrid: TDBGrid;
    CurlParameterDataSource: TDataSource;
    CurlParameterDataSet: TClientDataSet;
    CurlParameterDataSetName: TStringField;
    CurlParameterDataSetValue: TStringField;
    CurlAuthenticationParameterDataSource: TDataSource;
    CurlAuthenticationParameterDataset: TClientDataSet;
    StringField1: TStringField;
    StringField2: TStringField;
    CurlAuthenticationParameterDBGrid: TDBGrid;
    procedure ShowParameterFileActionExecute (Sender: TObject);
    procedure ConvertAllOpenFilesActionExecute (Sender: TObject);
    procedure ConvertCurrentFileActionExecute (Sender: TObject);
    procedure CopyCurrentPUMLActionExecute (Sender: TObject);
    procedure ExitActionExecute (Sender: TObject);
    procedure FormClose (Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery (Sender: TObject; var CanClose: Boolean);
    procedure FormShow (Sender: TObject);
    procedure InitialTimerTimer (Sender: TObject);
    procedure OpenCurlAuthenticationActionExecute (Sender: TObject);
    procedure OpenCurlParameterActionExecute (Sender: TObject);
    procedure OpenDefinitionActionExecute (Sender: TObject);
    procedure OpenInputListActionExecute (Sender: TObject);
    procedure OpenJsonDetailTabSheetExecute (Sender: TObject);
    procedure OpenOptionFileActionExecute (Sender: TObject);
    procedure OpenParameterFileActionExecute (Sender: TObject);
    procedure OpenPNGActionExecute (Sender: TObject);
    procedure OpenSVGActionExecute (Sender: TObject);
    procedure ReloadAndConvertActionExecute (Sender: TObject);
    procedure ReloadDefinitionActionExecute (Sender: TObject);
    procedure ReloadInputListActionExecute (Sender: TObject);
    procedure ReloadOptionFileActionExecute (Sender: TObject);
    procedure ReloadParameterFileActionExecute (Sender: TObject);
    procedure SaveCurlAuthenticationActionExecute (Sender: TObject);
    procedure SaveCurlParameterActionExecute (Sender: TObject);
    procedure SaveDefinitionActionExecute (Sender: TObject);
    procedure SaveInputlistActionExecute (Sender: TObject);
    procedure SaveOptionFileActionExecute (Sender: TObject);
    procedure SaveParameterFileActionExecute (Sender: TObject);
    procedure ShowCurlAuthenticationActionExecute (Sender: TObject);
    procedure ShowCurlParameterActionExecute (Sender: TObject);
    procedure ShowDefinitionFileActionExecute (Sender: TObject);
    procedure ShowInputListActionExecute (Sender: TObject);
    procedure ShowOutputFilesActionExecute (Sender: TObject);
    procedure ShowLogExecute (Sender: TObject);
    procedure ShowOptionFileActionExecute (Sender: TObject);
  private
    FCurlAuthenticationFileLines: TStrings;
    FConvertCnt: Integer;
    FCurlParameterFileLines: TStrings;
    FDefinitionLines: TStrings;
    FInputHandler: TJson2PumlInputHandler;
    FInputListLines: TStrings;
    FLogLines: TStrings;
    FFileListLines: TStrings;
    FOptionFileLines: TStrings;
    FParameterFileLines: TStrings;
    FServiceResultLines: TStrings;
    fSynJSONSyn: TSynJSONSyn;
    fLogMemo: TWinControl;
    FServiceinputlistfileResultLines: TStrings;
    FServicedefinitionfileResultLines: TStrings;
    procedure AfterCreateAllInputHandlerRecords (Sender: TObject);
    procedure AfterHandleAllInputHandlerRecords (Sender: TObject);
    procedure AfterCreateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
    procedure AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
    procedure BeforeCreateAllInputHandlerRecords (Sender: TObject);
    procedure BeforeDeleteAllInputHandlerRecords (Sender: TObject);
    function CalcTabsheetCaption (iInputHandlerRecord: TJson2PumlInputHandlerRecord): string;
    procedure CreateSingleFileFrame (iInputHandlerRecord: TJson2PumlInputHandlerRecord);
    function GetCurrentInputHandlerRecord: TJson2PumlInputHandlerRecord;
    procedure InitializeInputHandler;
    property CurlAuthenticationFileLines: TStrings read FCurlAuthenticationFileLines write FCurlAuthenticationFileLines;
    property CurlParameterFileLines: TStrings read FCurlParameterFileLines write FCurlParameterFileLines;
    property DefinitionLines: TStrings read FDefinitionLines write FDefinitionLines;
    property InputListLines: TStrings read FInputListLines write FInputListLines;
    property LogLines: TStrings read FLogLines write FLogLines;
    property FileListLines: TStrings read FFileListLines write FFileListLines;
    property OptionFileLines: TStrings read FOptionFileLines write FOptionFileLines;
    property ParameterFileLines: TStrings read FParameterFileLines write FParameterFileLines;
    property ServiceResultLines: TStrings read FServiceResultLines write FServiceResultLines;
    property ServiceinputlistfileResultLines: TStrings read FServiceinputlistfileResultLines
      write FServiceinputlistfileResultLines;
    property ServicedefinitionfileResultLines: TStrings read FServicedefinitionfileResultLines
      write FServicedefinitionfileResultLines;
    procedure InitFormDefaultLogger;
  protected
    procedure BeginConvert;
    procedure CommandLineToForm;
    procedure ConvertAllFrames;
    procedure ConvertCurrentFrame;
    procedure CreateMemoControls;
    function CreateSingleMemoControl (iParentControl: TWinControl; iName: string; iLabel: TLabel;
      var oMemoLines: TStrings; iUseHighlighter: Boolean): TWinControl;
    procedure EndConvert;
    procedure FormToCommandline;
    function GetNewFileName (iFileName: string; var oNewFileName: string): Boolean;
    procedure HandleInputParameter;
    function IsConverting: Boolean;
    procedure OpenDefinitionFile;
    procedure OpenInputListFile;
    procedure OpenOptionFile;
    procedure OpenAuthenticationFile;
    procedure OpenParameterFile;
    procedure ReloadDefinitionFIle;
    procedure ReloadFiles;
    procedure ReloadInputListFile;
    procedure ReloadOptionFile;
    procedure ReloadParameterFile;
    procedure SaveDefinitionFile;
    procedure SaveInputListFile;
    procedure SaveOptionFile;
    procedure SaveAuthenticationFile;
    procedure SaveParameterFile;
    procedure SetConverting (Converting: Boolean);
    procedure ShowDefinitionTabsheet;
    procedure ShowInputListTabSheet;
    procedure ShowJsonTabSheet;
    procedure ShowLogTabsheet;
    procedure UpdateAllInfos;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    function CalcShortCutStr (iIndex: Integer): string;
    procedure CopyCurrentPUMLToClipboard;
    procedure GenerateServiceListResults;
    procedure OpenCurrentPNGFile;
    procedure OpenCurrentSVGFile;
    property CurrentInputHandlerRecord: TJson2PumlInputHandlerRecord read GetCurrentInputHandlerRecord;
    property InputHandler: TJson2PumlInputHandler read FInputHandler;
  end;

var
  json2pumlMainForm: Tjson2pumlMainForm;

implementation

uses
  json2pumltools, Vcl.Clipbrd, Winapi.ShellAPI, System.IOUtils, json2pumlconst, System.UITypes,
  json2pumlloghandler, Quick.Logger.Provider.StringList, Quick.Logger, json2pumlbasedefinition,
  json2pumlconverterdefinition;

{$R *.dfm}

constructor Tjson2pumlMainForm.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);

end;

destructor Tjson2pumlMainForm.Destroy;
begin
  FInputHandler.Free;
  inherited Destroy;
end;

procedure Tjson2pumlMainForm.ShowParameterFileActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := ParameterFileTabSheet;
end;

procedure Tjson2pumlMainForm.AfterCreateAllInputHandlerRecords (Sender: TObject);
begin
  LockWindowUpdate (0);
end;

procedure Tjson2pumlMainForm.AfterHandleAllInputHandlerRecords (Sender: TObject);
begin
  FileListLines.LoadFromFile (InputHandler.ConverterInputList.FileListFileName);
end;

procedure Tjson2pumlMainForm.AfterCreateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
begin
  CreateSingleFileFrame (InputHandlerRecord);
end;

procedure Tjson2pumlMainForm.AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
var
  SingleFileFrame: tSingleFileFrame;
begin
  if Assigned (InputHandlerRecord.RelatedObject) then
    SingleFileFrame := tSingleFileFrame (InputHandlerRecord.RelatedObject)
  else
    Exit;
  SingleFileFrame.TabSheet.Caption := CalcTabsheetCaption (InputHandlerRecord);
  SingleFileFrame.Frame.InputFileName := InputHandlerRecord.InputFile.OutputFileName;
  SingleFileFrame.Frame.PNGFileName := InputHandlerRecord.InputFile.Output.PNGFileName;
  SingleFileFrame.Frame.SVGFileName := InputHandlerRecord.InputFile.Output.SVGFileName;
  SingleFileFrame.Frame.PUmlFileName := InputHandlerRecord.InputFile.Output.PUmlFileName;
  SingleFileFrame.Frame.ConverterLogFileName := InputHandlerRecord.InputFile.Output.ConverterLogFileName;
end;

procedure Tjson2pumlMainForm.BeforeCreateAllInputHandlerRecords (Sender: TObject);
begin
  LockWindowUpdate (Handle);
  LogFileDetailPageControl.ActivePage := ExecutionLogTabSheet;
end;

procedure Tjson2pumlMainForm.BeforeDeleteAllInputHandlerRecords (Sender: TObject);
begin
  try
    LockWindowUpdate (Handle);
    while FilePageControl.PageCount > 0 do
      FilePageControl.Pages[0].Free;
  finally
    LockWindowUpdate (0);
  end;
end;

procedure Tjson2pumlMainForm.BeginConvert;
begin
  Inc (FConvertCnt);
  if FConvertCnt = 1 then
    SetConverting (True);
end;

function Tjson2pumlMainForm.CalcShortCutStr (iIndex: Integer): string;
begin
  Result := '';
  if iIndex >= 0 then
    if iIndex < 9 then
      Result := Format ('Ctrl+%d', [iIndex + 1])
    else if iIndex = 9 then
      Result := Format ('Ctrl+%d', [0])
    else if iIndex < 19 then
      Result := Format ('Shift+Ctrl+%d', [iIndex - 10 + 1])
    else if iIndex = 19 then
      Result := Format ('Shift+Ctrl+%d', [iIndex - 0]);
end;

function Tjson2pumlMainForm.CalcTabsheetCaption (iInputHandlerRecord: TJson2PumlInputHandlerRecord): string;
var
  Sc: string;
begin
  Sc := CalcShortCutStr (iInputHandlerRecord.Index);
  if not Sc.IsEmpty then
    Sc := Format ('(%s)', [Sc]);
  Result := Format ('%s %s', [ExtractFileName(iInputHandlerRecord.InputFile.OutputFileName), Sc]).Trim;
end;

procedure Tjson2pumlMainForm.CommandLineToForm;

  procedure setCheckBox (iCheckBox: TCheckBox; iValue: string);
  begin
    if iValue.IsEmpty then
      iCheckBox.State := cbGrayed
    else
      iCheckBox.Checked := iValue.ToBoolean;
  end;

  procedure FillDataset (iDataset: tDataset; iCurlParameter: tJson2PumlCurlParameterList);
  var
    Parameter: tJson2PumlCurlParameterDefinition;
  begin
    while iDataset.RecordCount > 0 do
      iDataset.Delete;
    for Parameter in iCurlParameter do
      iDataset.InsertRecord ([Parameter.Name, Parameter.Value]);
  end;

begin
  PlantUmlJarFileEdit.Text := InputHandler.CmdLineParameter.PlantUmlJarFileName;
  javaruntimeparameterEdit.Text := InputHandler.CmdLineParameter.JavaRuntimeParameter;
  CurlAuthenticationFileEdit.Text := InputHandler.CmdLineParameter.CurlAuthenticationFileName;
  CurlParameterFileEdit.Text := InputHandler.CmdLineParameter.CurlParameterFileName;
  definitionfileEdit.Text := InputHandler.CmdLineParameter.DefinitionFileName;
  parameterFileEdit.Text := InputHandler.CmdLineParameter.ParameterFileName;
  optionfileEdit.Text := InputHandler.CmdLineParameter.OptionFileName;
  optionComboBox.Text := InputHandler.CmdLineParameter.Option;
  optionComboBox.Items.Text := InputHandler.ConverterDefinitionGroup.OptionList.Text;
  formatDefinitionFilesCheckBox.Checked := InputHandler.CmdLineParameter.FormatDefinitionFiles;
  inputfileEdit.Text := InputHandler.CmdLineParameter.InputFileName;
  inputlistfileEdit.Text := InputHandler.CmdLineParameter.InputListFileName;
  leadingObjectEdit.Text := InputHandler.CmdLineParameter.LeadingObject;
  splitIdentifierEdit.Text := InputHandler.CmdLineParameter.SplitIdentifier;
  setCheckBox (splitInputFileCheckBox, InputHandler.CmdLineParameter.SplitInputFileStr);
  outputpathEdit.Text := InputHandler.CmdLineParameter.OutputPath;
  outputsuffixEdit.Text := InputHandler.CmdLineParameter.Outputsuffix;
  outputformatEdit.Text := InputHandler.CmdLineParameter.OutputFormatStr;
  OpenOutputAllCheckBox.Checked := InputHandler.CmdLineParameter.OpenOutputsStr.ToLower.Trim = cOpenOutputAll;
  if OpenOutputAllCheckBox.Checked then
    openoutputEdit.Text := ''
  else
    openoutputEdit.Text := InputHandler.CmdLineParameter.OpenOutputsStr;
  groupEdit.Text := InputHandler.CmdLineParameter.Group;
  detailEdit.Text := InputHandler.CmdLineParameter.Detail;
  setCheckBox (generatesummaryCheckBox, InputHandler.CmdLineParameter.GenerateSummaryStr);
  setCheckBox (generatedetailsCheckBox, InputHandler.CmdLineParameter.GenerateDetailsStr);
  identfilterEdit.Text := InputHandler.CmdLineParameter.IdentFilter;
  titlefilterEdit.Text := InputHandler.CmdLineParameter.TitleFilter;
  generateoutputdefinitionCheckBox.Checked := InputHandler.CmdLineParameter.GenerateOutputDefinition;
  debugCheckBox.Checked := InputHandler.CmdLineParameter.Debug;
  FillDataset (CurlParameterDataSet,  InputHandler.CmdLineParameter.CurlParameter);
  FillDataset (CurlAuthenticationParameterDataset,  InputHandler.CmdLineParameter.CurlAuthenticationParameter);
end;

procedure Tjson2pumlMainForm.ConvertAllFrames;
begin
  BeginConvert;
  try
    InputHandler.ConvertAllRecords;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ConvertAllOpenFilesActionExecute (Sender: TObject);
begin
  ConvertAllFrames;
end;

procedure Tjson2pumlMainForm.ConvertCurrentFileActionExecute (Sender: TObject);
begin
  ConvertCurrentFrame;
end;

procedure Tjson2pumlMainForm.ConvertCurrentFrame;
begin
  if not Assigned (CurrentInputHandlerRecord) then
    Exit;
  BeginConvert;
  try
    InputHandler.ConvertAllRecords (CurrentInputHandlerRecord.Index);
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.CopyCurrentPUMLActionExecute (Sender: TObject);
begin
  CopyCurrentPUMLToClipboard;
end;

procedure Tjson2pumlMainForm.CopyCurrentPUMLToClipboard;
begin
  if Assigned (CurrentInputHandlerRecord) then
    Clipboard.AsText := CurrentInputHandlerRecord.PUmlOutput.Text;
end;

procedure Tjson2pumlMainForm.CreateMemoControls;
begin
{$IFDEF SYNEDIT}
  fSynJSONSyn := TSynJSONSyn.Create (self);
{$ENDIF}
  CreateSingleMemoControl (InputListPanel, 'InputListMemo', InputlistLabel, FInputListLines, True);
  CreateSingleMemoControl (DefinitionPanel, 'DefinitionMemo', DefinitionLabel, FDefinitionLines, True);
  CreateSingleMemoControl (OptionFilePanel, 'OptionFileMemo', OptionFileLabel, FOptionFileLines, True);
  CreateSingleMemoControl (ParameterFilePanel, 'ParameterFileMemo', ParameterFileLabel, FParameterFileLines, True);
  CreateSingleMemoControl (CurlAuthenticationFilePanel, 'CurlAuthenticationFileMemo', CurlAuthenticationFileLabel,
    FCurlAuthenticationFileLines, True);
  CreateSingleMemoControl (CurlParameterFilePanel, 'CurlParameterFileMemo', CurlParameterFileLabel,
    FCurlParameterFileLines, True);
  fLogMemo := CreateSingleMemoControl (ExecutionLogPanel, 'ExecutionLogMemo', nil, FLogLines, false);
  CreateSingleMemoControl (FileListPanel, 'FileListMemo', nil, FFileListLines, True);
  CreateSingleMemoControl (ServiceResultPanel, 'ServiceResultMemo', nil, FServiceResultLines, True);
  CreateSingleMemoControl (ServiceInputListFileResultPanel, 'ServiceResultMemo', nil,
    FServiceinputlistfileResultLines, True);
  CreateSingleMemoControl (ServiceDefinitionFileResultPanel, 'ServiceResultMemo', nil,
    FServicedefinitionfileResultLines, True);
end;

procedure Tjson2pumlMainForm.CreateSingleFileFrame (iInputHandlerRecord: TJson2PumlInputHandlerRecord);
var
  SingleFileFrame: tSingleFileFrame;
  Action: TAction;
  iItem: TActionClientItem;
begin
  SingleFileFrame := tSingleFileFrame.Create;
  SingleFileFrame.TabSheet := TTabSheet.Create (FilePageControl);
  SingleFileFrame.TabSheet.PageControl := FilePageControl;
  SingleFileFrame.TabSheet.BorderWidth := 5;
  FilePageControl.ActivePage := SingleFileFrame.TabSheet;
  SingleFileFrame.TabSheet.Caption := CalcTabsheetCaption (iInputHandlerRecord);
  SingleFileFrame.Frame := TJson2PumlSingleFileFrame.Create (SingleFileFrame.TabSheet);
  SingleFileFrame.Frame.Parent := SingleFileFrame.TabSheet;
  SingleFileFrame.Frame.InputFileName := iInputHandlerRecord.InputFile.InputFileName;
  SingleFileFrame.Frame.InputGroup := iInputHandlerRecord.InputGroup;
  SingleFileFrame.Frame.PNGFileName := '';
  SingleFileFrame.Frame.SVGFileName := '';
  SingleFileFrame.Frame.PUmlFileName := iInputHandlerRecord.InputFile.Output.PUmlFileName;
  SingleFileFrame.Frame.LeadingObject := iInputHandlerRecord.InputFile.LeadingObject;
  SingleFileFrame.Frame.Align := alClient;
  SingleFileFrame.Frame.CreateMemos (CreateSingleMemoControl);
  Action := TAction.Create (SingleFileFrame.TabSheet);
  Action.ActionList := JsonActionList;
  Action.Tag := iInputHandlerRecord.Index;
  Action.Caption := ExtractFileName (iInputHandlerRecord.InputFile.InputFileName);
  Action.ShortCut := TextToShortCut (CalcShortCutStr(iInputHandlerRecord.Index));
  Action.OnExecute := OpenJsonDetailTabSheetExecute;
  iItem := MainActionManager.ActionBars[0].Items[5].Items.add;
  iItem.Action := Action;
  iInputHandlerRecord.RelatedObject := SingleFileFrame;
  iInputHandlerRecord.ConverterLog := SingleFileFrame.Frame.LogList;
  iInputHandlerRecord.JsonInput := SingleFileFrame.Frame.JsonInput;
  iInputHandlerRecord.PUmlOutput := SingleFileFrame.Frame.PUmlOutput;
end;

function Tjson2pumlMainForm.CreateSingleMemoControl (iParentControl: TWinControl; iName: string; iLabel: TLabel;
  var oMemoLines: TStrings; iUseHighlighter: Boolean): TWinControl;
{$IFDEF SYNEDIT}
var
  NewEdit: TSynEdit;
begin
  NewEdit := TSynEdit.Create (iParentControl);

  NewEdit.Name := iName;
  NewEdit.Parent := iParentControl;
  NewEdit.Align := alClient;
  NewEdit.TabOrder := 1;
  NewEdit.Gutter.ShowLineNumbers := True;
  NewEdit.UseCodeFolding := True;
  if iUseHighlighter then
    NewEdit.Highlighter := fSynJSONSyn;
  NewEdit.Lines.Clear;
  NewEdit.ReadOnly := not iUseHighlighter;
  NewEdit.Options := [eoAltSetsColumnMode, eoAutoIndent, eoDragDropEditing, eoEnhanceHomeKey, eoEnhanceEndKey,
    eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabIndent, eoTabsToSpaces,
    eoTrimTrailingSpaces];
  NewEdit.TabWidth := 2;
  oMemoLines := NewEdit.Lines;
  if Assigned (iLabel) then
    iLabel.FocusControl := NewEdit;
  Result := NewEdit;
{$ELSE}
var
  NewMemo: TMemo;
begin

  NewMemo := TMemo.Create (iParentControl);

  NewMemo.Name := iName;
  NewMemo.Parent := iParentControl;
  NewMemo.Align := alClient;
  NewMemo.ParentFont := false;
  NewMemo.ScrollBars := ssBoth;
  NewMemo.TabOrder := 0;
  NewMemo.WantTabs := True;
  NewMemo.WordWrap := false;
  NewMemo.Font.Name := 'Courier New';
  NewMemo.Text := '';
  oMemoLines := NewMemo.Lines;
  if Assigned (iLabel) then
    iLabel.FocusControl := NewMemo;
  Result := NewMemo;
{$ENDIF}
end;

procedure Tjson2pumlMainForm.EndConvert;
begin
  Dec (FConvertCnt);
  if FConvertCnt = 0 then
    SetConverting (false);
end;

procedure Tjson2pumlMainForm.ExitActionExecute (Sender: TObject);
begin
  Close;
end;

procedure Tjson2pumlMainForm.FormClose (Sender: TObject; var Action: TCloseAction);
begin
  InputHandler.Clear;
end;

procedure Tjson2pumlMainForm.FormCloseQuery (Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not IsConverting;
  if CanClose then
    InputHandler.Clear;
end;

procedure Tjson2pumlMainForm.FormShow (Sender: TObject);
begin
  InitialTimer.Enabled := True;
  CreateMemoControls;
  InitFormDefaultLogger;
  FInputHandler := TJson2PumlInputHandler.Create (jatUI);
  InputHandler.AfterCreateRecord := AfterCreateInputHandlerRecord;
  InputHandler.AfterUpdateRecord := AfterUpdateInputHandlerRecord;
  InputHandler.AfterCreateAllRecords := AfterCreateAllInputHandlerRecords;
  InputHandler.AfterHandleAllRecords := AfterHandleAllInputHandlerRecords;
  InputHandler.BeforeCreateAllRecords := BeforeCreateAllInputHandlerRecords;
  InputHandler.BeforeDeleteAllRecords := BeforeDeleteAllInputHandlerRecords;
  InputHandler.DefinitionLines := DefinitionLines;
  InputHandler.OptionFileLines := OptionFileLines;
  InputHandler.ParameterFileLines := ParameterFileLines;
  InputHandler.CurlAuthenticationFileLines := CurlAuthenticationFileLines;
  InputHandler.CurlParameterFileLines := CurlParameterFileLines;
  InputHandler.InputListLines := InputListLines;
  InputHandler.ServerResultLines := ServiceResultLines;
  Caption := Format ('json2puml %s', [FileVersion]);
end;

procedure Tjson2pumlMainForm.FormToCommandline;
  function getCheckBox (iCheckBox: TCheckBox): string;
  begin
    if iCheckBox.State = cbGrayed then
      Result := ''
    else if iCheckBox.Checked then
      Result := ctrue
    else
      Result := cfalse;
  end;

  procedure FillParameterList (iCurlParameter :  tJson2PumlCurlParameterList; iDataset : TDataSet);
  begin
  iCurlParameter.Clear;
  iDataset.First;
  while not iDataset.Eof do
  begin
    iCurlParameter.AddParameter (iDataset.fieldValues['Name'],
      iDataset.fieldValues['Value']);
    iDataset.Next;
  end;
  end;


begin
  InputHandler.CmdLineParameter.PlantUmlJarFileName := PlantUmlJarFileEdit.Text;
  InputHandler.CmdLineParameter.JavaRuntimeParameter := javaruntimeparameterEdit.Text;
  InputHandler.CmdLineParameter.CurlAuthenticationFileName := CurlAuthenticationFileEdit.Text;
  InputHandler.CmdLineParameter.CurlParameterFileName := CurlParameterFileEdit.Text;
  InputHandler.CmdLineParameter.DefinitionFileName := definitionfileEdit.Text;
  InputHandler.CmdLineParameter.ParameterFileName := parameterFileEdit.Text;
  InputHandler.CmdLineParameter.OptionFileName := optionfileEdit.Text;
  InputHandler.CmdLineParameter.Option := optionComboBox.Text;
  InputHandler.CmdLineParameter.FormatDefinitionFiles := formatDefinitionFilesCheckBox.Checked;
  InputHandler.CmdLineParameter.InputFileName := inputfileEdit.Text;
  InputHandler.CmdLineParameter.InputListFileName := inputlistfileEdit.Text;
  InputHandler.CmdLineParameter.LeadingObject := leadingObjectEdit.Text;
  InputHandler.CmdLineParameter.SplitIdentifier := splitIdentifierEdit.Text;
  InputHandler.CmdLineParameter.SplitInputFileStr := getCheckBox (splitInputFileCheckBox);
  InputHandler.CmdLineParameter.OutputPath := outputpathEdit.Text;
  InputHandler.CmdLineParameter.Outputsuffix := outputsuffixEdit.Text;
  if OpenOutputAllCheckBox.Checked then
    InputHandler.CmdLineParameter.OpenOutputsStr := cOpenOutputAll
  else
    InputHandler.CmdLineParameter.OpenOutputsStr := openoutputEdit.Text;
  InputHandler.CmdLineParameter.Group := groupEdit.Text;
  InputHandler.CmdLineParameter.Detail := detailEdit.Text;
  InputHandler.CmdLineParameter.GenerateSummaryStr := getCheckBox (generatesummaryCheckBox);
  InputHandler.CmdLineParameter.GenerateDetailsStr := getCheckBox (generatedetailsCheckBox);
  InputHandler.CmdLineParameter.IdentFilter := identfilterEdit.Text;
  InputHandler.CmdLineParameter.TitleFilter := titlefilterEdit.Text;
  InputHandler.CmdLineParameter.GenerateOutputDefinition := generateoutputdefinitionCheckBox.Checked;
  InputHandler.CmdLineParameter.Debug := debugCheckBox.Checked;
  FillParameterList (InputHandler.CmdLineParameter.CurlParameter, CurlParameterDataSet);
  FillParameterList (InputHandler.CmdLineParameter.CurlAuthenticationParameter, CurlAuthenticationParameterDataset);
end;

procedure Tjson2pumlMainForm.GenerateServiceListResults;
begin
  GetServiceFileListResponse (ServiceinputlistfileResultLines,
    InputHandler.GlobalConfiguration.InputListFileSearchFolder, True);
  GetServiceFileListResponse (ServicedefinitionfileResultLines,
    InputHandler.GlobalConfiguration.DefinitionFileSearchFolder, false);
end;

function Tjson2pumlMainForm.GetCurrentInputHandlerRecord: TJson2PumlInputHandlerRecord;
var
  CurrentRecord: TJson2PumlInputHandlerRecord;
  i: Integer;
begin
  Result := nil;
  if FilePageControl.ActivePageIndex >= 0 then
  begin
    for i := 0 to InputHandler.Count - 1 do
    begin
      CurrentRecord := InputHandler[i];
      if Assigned (CurrentRecord.RelatedObject) and (CurrentRecord.RelatedObject is tSingleFileFrame) then
        if tSingleFileFrame (CurrentRecord.RelatedObject).TabSheet = FilePageControl.ActivePage then
        begin
          Result := CurrentRecord;
          Exit;
        end;
    end;
  end;
end;

function Tjson2pumlMainForm.GetNewFileName (iFileName: string; var oNewFileName: string): Boolean;
begin
  OpenDialog.InitialDir := ExtractFilePath (iFileName);
  Result := OpenDialog.Execute;
  if Result then
    oNewFileName := OpenDialog.FileName;
end;

procedure Tjson2pumlMainForm.HandleInputParameter;
begin
  FormToCommandline;
  LogLines.Clear;
  if InputHandler.CmdLineParameter.Failed then
  begin
    ShowLogTabsheet;
    Exit;
  end;
  ReloadFiles;
  UpdateAllInfos;
  GenerateServiceListResults;
end;

procedure Tjson2pumlMainForm.InitializeInputHandler;
begin
  InitialTimer.Enabled := false;
  InputHandler.CmdLineParameter.ReadInputParameter;
  CommandLineToForm;
end;

procedure Tjson2pumlMainForm.InitialTimerTimer (Sender: TObject);
begin
  InitializeInputHandler;
  if InputHandler.CmdLineParameter.Failed then // To prevent the double log output
  begin
    ShowLogTabsheet;
    Exit;
  end;
  HandleInputParameter;
end;

function Tjson2pumlMainForm.IsConverting: Boolean;
begin
  Result := FConvertCnt > 0;
end;

procedure Tjson2pumlMainForm.OpenCurlAuthenticationActionExecute (Sender: TObject);
begin
  OpenAuthenticationFile;
end;

procedure Tjson2pumlMainForm.OpenCurrentPNGFile;
begin
  if Assigned (CurrentInputHandlerRecord) then
    OpenFile (CurrentInputHandlerRecord.InputFile.Output.PNGFileName);
end;

procedure Tjson2pumlMainForm.OpenCurrentSVGFile;
begin
  if Assigned (CurrentInputHandlerRecord) then
    OpenFile (CurrentInputHandlerRecord.InputFile.Output.SVGFileName);
end;

procedure Tjson2pumlMainForm.InitFormDefaultLogger;
begin
  InitDefaultLogger (GlobalConfigurationDefinition.LogFileOutputPath, false, false);
  Logger.Providers.add (GlobalLogStringListProvider);
  GlobalLogStringListProvider.ShowTimeStamp := True;
  GlobalLogStringListProvider.ShowEventTypes := True;
  GlobalLogStringListProvider.LogList := LogLines;
  GlobalLogStringListProvider.LogLevel := LOG_DEBUG;
  SetLogProviderEventTypeNames (GlobalLogStringListProvider);
  GlobalLogStringListProvider.Enabled := True;

end;

procedure Tjson2pumlMainForm.OpenDefinitionActionExecute (Sender: TObject);
begin
  OpenDefinitionFile;
end;

procedure Tjson2pumlMainForm.OpenDefinitionFile;
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CurrentDefinitionFileName, newName) then
    InputHandler.LoadDefinitionFile (newName);
end;

procedure Tjson2pumlMainForm.OpenInputListActionExecute (Sender: TObject);
begin
  OpenInputListFile;
end;

procedure Tjson2pumlMainForm.OpenInputListFile;
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CurrentInputListFileName, newName) then
    InputHandler.LoadInputListFile (newName);
end;

procedure Tjson2pumlMainForm.OpenJsonDetailTabSheetExecute (Sender: TObject);
var
  CurrentRecord: TJson2PumlInputHandlerRecord;
begin
  if Sender is TAction then
    if (TAction(Sender).Tag >= 0) and (TAction(Sender).Tag < InputHandler.InputListLines.Count) then
    begin
      ShowJsonTabSheet;
      CurrentRecord := InputHandler[TAction(Sender).Tag];
      if Assigned (CurrentRecord.RelatedObject) and (CurrentRecord.RelatedObject is tSingleFileFrame) then
        FilePageControl.ActivePage := tSingleFileFrame (CurrentRecord.RelatedObject).TabSheet;
    end;
end;

procedure Tjson2pumlMainForm.OpenOptionFile;
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CmdLineParameter.OptionFileName, newName) then
    InputHandler.LoadOptionFile (newName);
end;

procedure Tjson2pumlMainForm.OpenAuthenticationFile;
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CmdLineParameter.CurlAuthenticationFileName, newName) then
    InputHandler.LoadCurlAuthenticationFile (newName);
end;

procedure Tjson2pumlMainForm.OpenCurlParameterActionExecute (Sender: TObject);
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CmdLineParameter.CurlParameterFileName, newName) then
    InputHandler.LoadCurlParameterFile (newName);
end;

procedure Tjson2pumlMainForm.OpenParameterFile;
var
  newName: string;
begin
  if GetNewFileName (InputHandler.CmdLineParameter.ParameterFileName, newName) then
    InputHandler.LoadParameterFile (newName);
end;

procedure Tjson2pumlMainForm.OpenOptionFileActionExecute (Sender: TObject);
begin
  OpenOptionFile;
end;

procedure Tjson2pumlMainForm.OpenParameterFileActionExecute (Sender: TObject);
begin
  OpenParameterFile;
end;

procedure Tjson2pumlMainForm.OpenPNGActionExecute (Sender: TObject);
begin
  OpenCurrentPNGFile;
end;

procedure Tjson2pumlMainForm.OpenSVGActionExecute (Sender: TObject);
begin
  OpenCurrentSVGFile;
end;

procedure Tjson2pumlMainForm.ReloadAndConvertActionExecute (Sender: TObject);
begin
  HandleInputParameter;
end;

procedure Tjson2pumlMainForm.ReloadDefinitionActionExecute (Sender: TObject);
begin
  ReloadDefinitionFIle;
end;

procedure Tjson2pumlMainForm.ReloadDefinitionFIle;
begin
  BeginConvert;
  try
    InputHandler.LoadDefinitionFiles;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ReloadFiles;
begin
  BeginConvert;
  try
    InputHandler.LoadDefinitionFiles;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ReloadInputListActionExecute (Sender: TObject);
begin
  ReloadInputListFile;
end;

procedure Tjson2pumlMainForm.ReloadInputListFile;
begin
  BeginConvert;
  try
    InputHandler.LoadInputListFile;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ReloadOptionFile;
begin
  BeginConvert;
  try
    InputHandler.LoadDefinitionFiles;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ReloadParameterFile;
begin
  BeginConvert;
  try
    InputHandler.LoadParameterFile;
  finally
    EndConvert;
  end;
end;

procedure Tjson2pumlMainForm.ReloadOptionFileActionExecute (Sender: TObject);
begin
  ReloadOptionFile;
end;

procedure Tjson2pumlMainForm.ReloadParameterFileActionExecute (Sender: TObject);
begin
  ReloadParameterFile;
end;

procedure Tjson2pumlMainForm.SaveCurlAuthenticationActionExecute (Sender: TObject);
begin
  SaveAuthenticationFile;
end;

procedure Tjson2pumlMainForm.SaveDefinitionActionExecute (Sender: TObject);
begin
  SaveDefinitionFile;
end;

procedure Tjson2pumlMainForm.SaveDefinitionFile;
begin
  if not InputHandler.ConverterDefinitionGroup.SaveToFile (DefinitionLines, InputHandler.CurrentDefinitionFileName, True)
  then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveInputlistActionExecute (Sender: TObject);
begin
  SaveInputListFile;
end;

procedure Tjson2pumlMainForm.SaveInputListFile;
begin
  if not InputHandler.ConverterInputList.SaveToFile (InputListLines, InputHandler.CurrentInputListFileName, True) then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveOptionFile;
begin
  if not InputHandler.OptionFileDefinition.SaveToFile (OptionFileLines, InputHandler.CmdLineParameter.OptionFileName,
    True) then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveAuthenticationFile;
begin
  if not InputHandler.CurlAuthenticationList.SaveToFile (CurlAuthenticationFileLines,
    InputHandler.CmdLineParameter.CurlAuthenticationFileName, True) then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveCurlParameterActionExecute (Sender: TObject);
begin
  if not InputHandler.CurlParameterList.SaveToFile (CurlParameterFileLines,
    InputHandler.CmdLineParameter.CurlParameterFileName, True) then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveParameterFile;
begin
  if not InputHandler.ParameterDefinition.SaveToFile (ParameterFileLines,
    InputHandler.CmdLineParameter.ParameterFileName, True) then
    MessageDlg ('Error parsing JSON structure', mtError, [mbOK], 0);
end;

procedure Tjson2pumlMainForm.SaveOptionFileActionExecute (Sender: TObject);
begin
  SaveOptionFile
end;

procedure Tjson2pumlMainForm.SaveParameterFileActionExecute (Sender: TObject);
begin
  SaveParameterFile;
end;

procedure Tjson2pumlMainForm.SetConverting (Converting: Boolean);
var
  i: Integer;
begin
  if not Converting and (InputHandler.Count > 0) then
    ShowJsonTabSheet
  else
    ShowLogTabsheet;
  for i := 0 to MainActionList.ActionCount - 1 do
    MainActionList.Actions[i].Enabled := not Converting;
  if not Converting then
    CommandLineToForm;
end;

procedure Tjson2pumlMainForm.ShowCurlAuthenticationActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := CurlAuthenticationTabSheet;
end;

procedure Tjson2pumlMainForm.ShowCurlParameterActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := CurlParameterFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowDefinitionFileActionExecute (Sender: TObject);
begin
  ShowDefinitionTabsheet;
end;

procedure Tjson2pumlMainForm.ShowDefinitionTabsheet;
begin
  MainPageControl.ActivePage := DefinitionFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowInputListActionExecute (Sender: TObject);
begin
  ShowInputListTabSheet;
end;

procedure Tjson2pumlMainForm.ShowInputListTabSheet;
begin
  MainPageControl.ActivePage := InputListTabSheet;
end;

procedure Tjson2pumlMainForm.ShowOutputFilesActionExecute (Sender: TObject);
begin
  ShowJsonTabSheet;
end;

procedure Tjson2pumlMainForm.ShowJsonTabSheet;
begin
  MainPageControl.ActivePage := OutputTabsheet;
end;

procedure Tjson2pumlMainForm.ShowLogExecute (Sender: TObject);
begin
  ShowLogTabsheet;
end;

procedure Tjson2pumlMainForm.ShowLogTabsheet;
begin
  MainPageControl.ActivePage := LogTabSheet;
end;

procedure Tjson2pumlMainForm.ShowOptionFileActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := OptionFileTabSheet;
end;

procedure Tjson2pumlMainForm.UpdateAllInfos;
begin
  ParameterFileLabel.Caption := InputHandler.CmdLineParameter.ParameterFileName;
  DefinitionLabel.Caption := InputHandler.CurrentDefinitionFileName;
  InputlistLabel.Caption := InputHandler.CurrentInputListFileName;
  OptionFileLabel.Caption := InputHandler.CmdLineParameter.OptionFileName;
  CurlAuthenticationFileLabel.Caption := InputHandler.CmdLineParameter.CurlAuthenticationFileName;
  CurlParameterFileLabel.Caption := InputHandler.CmdLineParameter.CurlParameterFileName;
end;

destructor tSingleFileFrame.Destroy;
begin
  FFrame.Free;
  FTabSheet.Free;
  inherited Destroy;
end;

function tFrameList.GetFileFrame (Index: Integer): tSingleFileFrame;
begin
  Result := tSingleFileFrame (Objects[index]);
end;

end.
