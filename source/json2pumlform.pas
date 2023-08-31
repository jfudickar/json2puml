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

{$I json2puml.inc}

uses
{$IFDEF SYNEDIT}
  SynHighlighterJSON, SynEdit,
{$ENDIF}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, Vcl.StdActns, System.Actions, Vcl.ActnList,
  json2pumlframe, json2pumldefinition, Vcl.ActnMenus, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ExtDlgs, Vcl.Grids, json2pumlinputhandler, Vcl.PlatformDefaultStyleActnCtrls, Data.DB,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, json2pumlconfigframe,
  json2pumlbasedefinition, json2pumlvcltools, System.Win.TaskbarCore, Vcl.Taskbar, Quick.Logger.Provider.StringList;

type
  tOutputFileFrame = class(TObject)
  private
    FFrame: TJson2PumlOutputFileFrame;
    FTabSheet: TTabSheet;
  public
    destructor Destroy; override;
    property Frame: TJson2PumlOutputFileFrame read FFrame write FFrame;
    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
  end;

  Tjson2pumlMainForm = class(TForm)
    Action1: TAction;
    ActionMainMenuBar: TActionMainMenuBar;
    ActionToolBar5: TActionToolBar;
    Button1: TButton;
    CommandLineEditPanel: TPanel;
    ConvertAllOpenFilesAction: TAction;
    ConvertCurrentFileAction: TAction;
    CopyCurrentPUMLAction: TAction;
    CurlAuthenticationFileEdit: TEdit;
    CurlAuthenticationParameterDataset: TFDMemTable;
    CurlAuthenticationParameterDataSource: TDataSource;
    CurlAuthenticationParameterDBGrid: TDBGrid;
    CurlAuthenticationParameterTabSheet: TTabSheet;
    CurlAuthenticationTabSheet: TTabSheet;
    CurlParameterDataSet: TFDMemTable;
    CurlParameterDataSetName: TStringField;
    CurlParameterDataSetValue: TStringField;
    CurlParameterDataSource: TDataSource;
    CurlParameterDBGrid: TDBGrid;
    CurlParameterFileEdit: TEdit;
    CurlParameterFileTabSheet: TTabSheet;
    CurlParameterPageControl: TPageControl;
    CurlParameterTabSheet: TTabSheet;
    debugCheckBox: TCheckBox;
    definitionfileEdit: TEdit;
    DefinitionFileTabSheet: TTabSheet;
    detailEdit: TEdit;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    ExecutionLogPanel: TPanel;
    ExecutionLogTabSheet: TTabSheet;
    ExitAction: TAction;
    FileListPanel: TPanel;
    FileListTabSheet: TTabSheet;
    FilePageControl: TPageControl;
    formatDefinitionFilesCheckBox: TCheckBox;
    generatedetailsCheckBox: TCheckBox;
    generateoutputdefinitionCheckBox: TCheckBox;
    generatesummaryCheckBox: TCheckBox;
    GlobalConfigurationFileTabSheet: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    groupEdit: TEdit;
    identfilterEdit: TEdit;
    ImageList1: TImageList;
    InitialTimer: TTimer;
    inputfileEdit: TEdit;
    inputlistfileEdit: TEdit;
    InputListTabSheet: TTabSheet;
    javaruntimeparameterEdit: TEdit;
    javaruntimeparameterLabel: TLabel;
    JsonActionList: TActionList;
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
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    leadingObjectEdit: TEdit;
    LoadFileAction: TAction;
    LogFileDetailPageControl: TPageControl;
    LogTabSheet: TTabSheet;
    MainActionList: TActionList;
    MainActionManager: TActionManager;
    MainActionToolBar: TActionToolBar;
    MainPageControl: TPageControl;
    OpenOutputAllCheckBox: TCheckBox;
    openoutputEdit: TEdit;
    OpenCurrentPNGAction: TAction;
    OpenCurrentSVGAction: TAction;
    optionComboBox: TComboBox;
    optionfileEdit: TEdit;
    OptionFileTabSheet: TTabSheet;
    outputformatEdit: TEdit;
    outputpathEdit: TEdit;
    outputsuffixEdit: TEdit;
    OutputTabsheet: TTabSheet;
    parameterFileEdit: TEdit;
    ParameterFileTabSheet: TTabSheet;
    PlantUmlJarFileEdit: TEdit;
    PlantUmlJarFileLabel: TLabel;
    ReloadAndConvertAction: TAction;
    ReloadFileAction: TAction;
    SaveAsFileAction: TAction;
    SaveFileAction: TAction;
    ServiceDefinitionFileResultPanel: TPanel;
    ServiceInputListFileResult: TTabSheet;
    ServiceInputListFileResultPanel: TPanel;
    ServiceResultPage: TTabSheet;
    ServiceResultPanel: TPanel;
    ShowCurlAuthenticationAction: TAction;
    ShowCurlParameterAction: TAction;
    ShowDefinitionFileAction: TAction;
    ShowExecuteAction: TAction;
    ShowGlobalConfigFile: TAction;
    ShowInputListAction: TAction;
    ShowOptionFileAction: TAction;
    ShowOutputFilesAction: TAction;
    ShowParameterFileAction: TAction;
    splitIdentifierEdit: TEdit;
    splitInputFileCheckBox: TCheckBox;
    StatusBar: TStatusBar;
    StringField3: TStringField;
    StringField4: TStringField;
    TabSheet2: TTabSheet;
    titlefilterEdit: TEdit;
    OpenCurrentJSONAction: TAction;
    OpenConfigurationFileExternal: TAction;
    Taskbar: TTaskbar;
    Label21: TLabel;
    PlantUmlRuntimeParameterEdit: TEdit;
    Label25: TLabel;
    procedure ConvertAllOpenFilesActionExecute (Sender: TObject);
    procedure ConvertCurrentFileActionExecute (Sender: TObject);
    procedure CopyCurrentPUMLActionExecute (Sender: TObject);
    procedure ExitActionExecute (Sender: TObject);
    procedure FormClose (Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery (Sender: TObject; var CanClose: Boolean);
    procedure FormShow (Sender: TObject);
    procedure InitialTimerTimer (Sender: TObject);
    procedure LoadFileActionExecute (Sender: TObject);
    procedure OpenConfigurationFileExternalExecute (Sender: TObject);
    procedure OpenCurrentJSONActionExecute (Sender: TObject);
    procedure OpenJsonDetailTabSheetExecute (Sender: TObject);
    procedure OpenCurrentPNGActionExecute (Sender: TObject);
    procedure OpenCurrentSVGActionExecute (Sender: TObject);
    procedure ReloadAndConvertActionExecute (Sender: TObject);
    procedure ReloadFileActionExecute (Sender: TObject);
    procedure SaveFileActionExecute (Sender: TObject);
    procedure SaveFileActionUpdate (Sender: TObject);
    procedure ShowCurlAuthenticationActionExecute (Sender: TObject);
    procedure ShowCurlParameterActionExecute (Sender: TObject);
    procedure ShowDefinitionFileActionExecute (Sender: TObject);
    procedure ShowExecuteActionExecute (Sender: TObject);
    procedure ShowInputListActionExecute (Sender: TObject);
    procedure ShowOptionFileActionExecute (Sender: TObject);
    procedure ShowOutputFilesActionExecute (Sender: TObject);
    procedure ShowParameterFileActionExecute (Sender: TObject);
  private
    FConvertCnt: Integer;
    FCurlAuthenticationFileLines: TStrings;
    FCurlParameterFileLines: TStrings;
    FDefinitionLines: TStrings;
    FFileListLines: TStrings;
    FGlobalConfigurationFileLines: TStrings;
    FInputHandler: TJson2PumlInputHandler;
    FInputListLines: TStrings;
    FLogLines: TStrings;
    fLogMemo: TWinControl;
    FLogStringListProvider: TLogStringListProvider;
    FOptionFileLines: TStrings;
    FParameterFileLines: TStrings;
    FServicedefinitionfileResultLines: TStrings;
    FServiceinputlistfileResultLines: TStrings;
    FServiceResultLines: TStrings;
    fSynJSONSyn: TSynJSONSyn;
    IntConfigFrame: array [tJson2PumlPage] of TJson2PumlConfigurationFrame;
    procedure AfterCreateAllInputHandlerRecords (Sender: TObject);
    procedure AfterCreateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
    procedure AfterHandleAllInputHandlerRecords (Sender: TObject);
    procedure AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
    procedure BeforeCreateAllInputHandlerRecords (Sender: TObject);
    procedure BeforeDeleteAllInputHandlerRecords (Sender: TObject);
    function CalcTabsheetCaption (iInputHandlerRecord: TJson2PumlInputHandlerRecord): string;
    procedure CreateOutputFileFrame (iInputHandlerRecord: TJson2PumlInputHandlerRecord);
    function GetConfigFrame (Page: tJson2PumlPage): TJson2PumlConfigurationFrame;
    function GetCurrentInputHandlerRecord: TJson2PumlInputHandlerRecord;
    function GetCurrentPage: tJson2PumlPage;
    procedure InitFormDefaultLogger;
    procedure InitializeInputHandler;
    procedure HandleNotifyChange (Sender: TObject; ProgressValue, ProgressMaxValue: Integer);
    procedure SetCurrentPage (const Value: tJson2PumlPage);
    property CurlAuthenticationFileLines: TStrings read FCurlAuthenticationFileLines write FCurlAuthenticationFileLines;
    property CurlParameterFileLines: TStrings read FCurlParameterFileLines write FCurlParameterFileLines;
    property DefinitionLines: TStrings read FDefinitionLines write FDefinitionLines;
    property FileListLines: TStrings read FFileListLines write FFileListLines;
    property GlobalConfigurationFileLines: TStrings read FGlobalConfigurationFileLines
      write FGlobalConfigurationFileLines;
    property InputListLines: TStrings read FInputListLines write FInputListLines;
    property LogLines: TStrings read FLogLines write FLogLines;
    property OptionFileLines: TStrings read FOptionFileLines write FOptionFileLines;
    property ParameterFileLines: TStrings read FParameterFileLines write FParameterFileLines;
    property ServicedefinitionfileResultLines: TStrings read FServicedefinitionfileResultLines
      write FServicedefinitionfileResultLines;
    property ServiceinputlistfileResultLines: TStrings read FServiceinputlistfileResultLines
      write FServiceinputlistfileResultLines;
    property ServiceResultLines: TStrings read FServiceResultLines write FServiceResultLines;
  protected
    procedure BeginConvert;
    procedure CommandLineToForm;
    procedure ConvertAllFrames;
    procedure ConvertCurrentFrame;
    procedure CreateConfigFrames (iPage: tJson2PumlPage; var oLines: TStrings; iShowAction: TAction;
      iConfigObjectClass: tJson2PumlBaseObjectClass);
    procedure CreateMemoControls;
    function CreateSingleMemoControl (iParentControl: TWinControl; iName: string; iLabel: TLabel;
      var oMemoLines: TStrings; iUseHighlighter, iReadOnly: Boolean): TWinControl;
    procedure EndConvert;
    procedure FormToCommandline;
    function GetConfigFileName (iPage: tJson2PumlPage): string;
    procedure HandleInputParameter;
    function IsConverting: Boolean;
    procedure LoadConfigFileName (iPage: tJson2PumlPage; iFileName: string);
    procedure ReloadFiles;
    procedure SetConfigFileName (iPage: tJson2PumlPage; iFileName: string);
    procedure SetConverting (Converting: Boolean);
    procedure ShowDefinitionTabsheet;
    procedure ShowInputListTabSheet;
    procedure ShowJsonTabSheet;
    procedure ShowLogTabsheet;
    function TabSheetByPage (iPage: tJson2PumlPage): TTabSheet;
    procedure UpdateAllInfos;
    property ConfigFileName[Page: tJson2PumlPage]: string read GetConfigFileName write SetConfigFileName;
    property ConfigFrame[Page: tJson2PumlPage]: TJson2PumlConfigurationFrame read GetConfigFrame;
    property CurrentPage: tJson2PumlPage read GetCurrentPage write SetCurrentPage;
    property LogStringListProvider: TLogStringListProvider read FLogStringListProvider;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    function CalcShortCutStr (iIndex: Integer): string;
    procedure CopyCurrentPUMLToClipboard;
    procedure GenerateServiceListResults;
    procedure OpenCurrentPNGFile;
    procedure OpenCurrentSVGFile;
    procedure OpenCurrentJSONFile;
    property CurrentInputHandlerRecord: TJson2PumlInputHandlerRecord read GetCurrentInputHandlerRecord;
    property InputHandler: TJson2PumlInputHandler read FInputHandler;
  end;

var
  json2pumlMainForm: Tjson2pumlMainForm;

implementation

uses
  json2pumltools, Vcl.Clipbrd, Winapi.ShellAPI, System.IOUtils, json2pumlconst, System.UITypes,
  json2pumlloghandler, Quick.Logger,
  json2pumlconverterdefinition;

{$R *.dfm}

constructor Tjson2pumlMainForm.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);

end;

destructor Tjson2pumlMainForm.Destroy;
begin
  if Assigned (LogStringListProvider) then
  begin
    if Logger.Providers.IndexOf (LogStringListProvider) >= 0 then
      Logger.Providers.delete (Logger.Providers.IndexOf(LogStringListProvider));
    //FLogStringListProvider.Free;
  end;
  FInputHandler.Free;
  GlobalLogStringListProvider.LogList := nil;
  inherited Destroy;
end;

procedure Tjson2pumlMainForm.AfterCreateAllInputHandlerRecords (Sender: TObject);
begin
  LockWindowUpdate (0);
end;

procedure Tjson2pumlMainForm.AfterCreateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
begin
  CreateOutputFileFrame (InputHandlerRecord);
end;

procedure Tjson2pumlMainForm.AfterHandleAllInputHandlerRecords (Sender: TObject);
begin
  FileListLines.LoadFromFile (InputHandler.ConverterInputList.FileListFileName);
  Taskbar.ProgressState := TTaskBarProgressState.None;
end;

procedure Tjson2pumlMainForm.AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
var
  OutputFileFrame: tOutputFileFrame;
begin
  if Assigned (InputHandlerRecord.RelatedObject) then
    OutputFileFrame := tOutputFileFrame (InputHandlerRecord.RelatedObject)
  else
    Exit;
  OutputFileFrame.TabSheet.Caption := CalcTabsheetCaption (InputHandlerRecord);
  OutputFileFrame.Frame.InputFileName := InputHandlerRecord.InputFile.OutputFileName;
  OutputFileFrame.Frame.PNGFileName := InputHandlerRecord.InputFile.Output.PNGFileName;
  OutputFileFrame.Frame.SVGFileName := InputHandlerRecord.InputFile.Output.SVGFileName;
  OutputFileFrame.Frame.PUmlFileName := InputHandlerRecord.InputFile.Output.PUmlFileName;
  OutputFileFrame.Frame.ConverterLogFileName := InputHandlerRecord.InputFile.Output.ConverterLogFileName;
end;

procedure Tjson2pumlMainForm.BeforeCreateAllInputHandlerRecords (Sender: TObject);
begin
  LockWindowUpdate (Handle);
  LogFileDetailPageControl.ActivePage := ExecutionLogTabSheet;
  Taskbar.ProgressState := TTaskBarProgressState.Normal;
  UpdateAllInfos;
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
    iDataset.Active := True;
    while iDataset.RecordCount > 0 do
      iDataset.delete;
    for Parameter in iCurlParameter do
      iDataset.InsertRecord ([Parameter.Name, Parameter.Value]);
  end;

begin
  PlantUmlJarFileEdit.Text := InputHandler.CmdLineParameter.PlantUmlJarFileName;
  PlantUmlRuntimeParameterEdit.Text := InputHandler.CmdLineParameter.PlantUmlRuntimeParameter;
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
  FillDataset (CurlParameterDataSet, InputHandler.CmdLineParameter.CurlParameter);
  FillDataset (CurlAuthenticationParameterDataset, InputHandler.CmdLineParameter.CurlAuthenticationParameter);
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

procedure Tjson2pumlMainForm.CreateConfigFrames (iPage: tJson2PumlPage; var oLines: TStrings; iShowAction: TAction;
  iConfigObjectClass: tJson2PumlBaseObjectClass);
var
  Frame: TJson2PumlConfigurationFrame;
  TabSheet: TTabSheet;
begin
  IntConfigFrame[iPage] := nil;
  TabSheet := TabSheetByPage (iPage);
  iPage.SetToShowAction (iShowAction);
  TabSheet.Caption := iPage.TabSheetCaption;
  if not iPage.IsConfig then
    Exit;
  Frame := TJson2PumlConfigurationFrame.Create (TabSheet);
  Frame.Parent := TabSheet;
  Frame.Align := alClient;
  Frame.Page := iPage;
  Frame.CreateMemos (CreateSingleMemoControl);
  Frame.ConfigObjectClass := iConfigObjectClass;
  Frame.OnSetConfigFileName := SetConfigFileName;
  Frame.OnGetConfigFileName := GetConfigFileName;
  Frame.OnLoadConfigFileName := LoadConfigFileName;
  oLines := Frame.Lines;
  IntConfigFrame[iPage] := Frame;
end;

procedure Tjson2pumlMainForm.CreateMemoControls;
var
  DummyLines: TStrings;
  Page: tJson2PumlPage;
  i: Integer;
begin
{$IFDEF SYNEDIT}
  fSynJSONSyn := TSynJSONSyn.Create (self);
{$ENDIF}
  CreateConfigFrames (jpExeute, DummyLines, ShowExecuteAction, nil);
  CreateConfigFrames (jpOutput, DummyLines, ShowOutputFilesAction, nil);
  CreateConfigFrames (jpInputList, FInputListLines, ShowInputListAction, tJson2PumlInputList);
  CreateConfigFrames (jpDefinitionFile, FDefinitionLines, ShowDefinitionFileAction, tJson2PumlConverterGroupDefinition);
  CreateConfigFrames (jpParameterFile, FParameterFileLines, ShowParameterFileAction, tJson2PumlParameterFileDefinition);
  CreateConfigFrames (jpOptionFile, FOptionFileLines, ShowOptionFileAction, tJson2PumlConverterDefinition);
  CreateConfigFrames (jpCurlAuthenticationFile, FCurlAuthenticationFileLines, ShowCurlAuthenticationAction,
    tJson2PumlCurlAuthenticationList);
  CreateConfigFrames (jpCurlParameterFile, FCurlParameterFileLines, ShowCurlParameterAction,
    tJson2PumlCurlParameterList);
  CreateConfigFrames (jpGlobalConfig, FGlobalConfigurationFileLines, ShowGlobalConfigFile, tJson2PumlGlobalDefinition);
  i := 0;
  for Page := low(Page) to high(Page) do
  begin
    TabSheetByPage (Page).PageIndex := i;
    Inc (i);
  end;

  fLogMemo := CreateSingleMemoControl (ExecutionLogPanel, 'ExecutionLogMemo', nil, FLogLines, false, True);
  CreateSingleMemoControl (FileListPanel, 'FileListMemo', nil, FFileListLines, True, True);
  CreateSingleMemoControl (ServiceResultPanel, 'ServiceResultMemo', nil, FServiceResultLines, True, True);
  CreateSingleMemoControl (ServiceInputListFileResultPanel, 'ServiceResultMemo', nil, FServiceinputlistfileResultLines,
    True, True);
  CreateSingleMemoControl (ServiceDefinitionFileResultPanel, 'ServiceResultMemo', nil,
    FServicedefinitionfileResultLines, True, True);
end;

procedure Tjson2pumlMainForm.CreateOutputFileFrame (iInputHandlerRecord: TJson2PumlInputHandlerRecord);
var
  OutputFileFrame: tOutputFileFrame;
  Action: TAction;
  // iItem: TActionClientItem;
begin
  OutputFileFrame := tOutputFileFrame.Create;
  OutputFileFrame.TabSheet := TTabSheet.Create (FilePageControl);
  OutputFileFrame.TabSheet.PageControl := FilePageControl;
  OutputFileFrame.TabSheet.BorderWidth := 5;
  FilePageControl.ActivePage := OutputFileFrame.TabSheet;
  OutputFileFrame.TabSheet.Caption := CalcTabsheetCaption (iInputHandlerRecord);
  OutputFileFrame.Frame := TJson2PumlOutputFileFrame.Create (OutputFileFrame.TabSheet);
  OutputFileFrame.Frame.Parent := OutputFileFrame.TabSheet;
  OutputFileFrame.Frame.InputFileName := iInputHandlerRecord.InputFile.InputFileName;
  OutputFileFrame.Frame.InputGroup := iInputHandlerRecord.InputGroup;
  OutputFileFrame.Frame.PNGFileName := '';
  OutputFileFrame.Frame.SVGFileName := '';
  OutputFileFrame.Frame.PUmlFileName := iInputHandlerRecord.InputFile.Output.PUmlFileName;
  OutputFileFrame.Frame.LeadingObject := iInputHandlerRecord.InputFile.LeadingObject;
  OutputFileFrame.Frame.Align := alClient;
  OutputFileFrame.Frame.CreateMemos (CreateSingleMemoControl);
  Action := TAction.Create (OutputFileFrame.TabSheet);
  Action.ActionList := JsonActionList;
  Action.Tag := iInputHandlerRecord.Index;
  Action.Caption := ExtractFileName (iInputHandlerRecord.InputFile.InputFileName);
  Action.ShortCut := TextToShortCut (CalcShortCutStr(iInputHandlerRecord.Index));
  Action.OnExecute := OpenJsonDetailTabSheetExecute;
  // iItem := MainActionManager.ActionBars[0].Items[5].Items.add;
  // iItem.Action := Action;
  iInputHandlerRecord.RelatedObject := OutputFileFrame;
  iInputHandlerRecord.ConverterLog := OutputFileFrame.Frame.LogList;
  iInputHandlerRecord.JsonInput := OutputFileFrame.Frame.JsonInput;
  iInputHandlerRecord.PUmlOutput := OutputFileFrame.Frame.PUmlOutput;
end;

function Tjson2pumlMainForm.CreateSingleMemoControl (iParentControl: TWinControl; iName: string; iLabel: TLabel;
  var oMemoLines: TStrings; iUseHighlighter, iReadOnly: Boolean): TWinControl;
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
  NewEdit.ReadOnly := iReadOnly;
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
  InputHandler.OnNotifyChange := HandleNotifyChange;
  InputHandler.DefinitionLines := DefinitionLines;
  InputHandler.ConfigurationFileLines := GlobalConfigurationFileLines;
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

  procedure FillParameterList (iCurlParameter: tJson2PumlCurlParameterList; iDataset: tDataset);
  begin
    iCurlParameter.Clear;
    iDataset.First;
    while not iDataset.Eof do
    begin
      iCurlParameter.AddParameter (iDataset.fieldValues['Name'], iDataset.fieldValues['Value']);
      iDataset.Next;
    end;
  end;

begin
  InputHandler.CmdLineParameter.PlantUmlJarFileName := PlantUmlJarFileEdit.Text;
  InputHandler.CmdLineParameter.PlantUmlRuntimeParameter := PlantUmlRuntimeParameterEdit.Text;
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

function Tjson2pumlMainForm.GetConfigFileName (iPage: tJson2PumlPage): string;
begin
  Result := '';
  if not Assigned (InputHandler) or not Assigned (InputHandler.CmdLineParameter) then
    Exit;
  case iPage of
    // jpExeute: ;
    jpInputList:
      Result := InputHandler.CurrentInputListFileName;
    jpCurlAuthenticationFile:
      Result := InputHandler.CurrentCurlAuthenticationFileName;
    jpCurlParameterFile:
      Result := InputHandler.CmdLineParameter.CurlParameterFileName;
    jpDefinitionFile:
      Result := InputHandler.CurrentDefinitionFileName;
    jpOptionFile:
      Result := InputHandler.CmdLineParameter.OptionFileName;
    jpParameterFile:
      Result := InputHandler.CmdLineParameter.ParameterFileName;
    jpGlobalConfig:
      Result := InputHandler.CurrentConfigurationFileName;
    // jpOutput: ;
  end;
end;

function Tjson2pumlMainForm.GetConfigFrame (Page: tJson2PumlPage): TJson2PumlConfigurationFrame;
begin
  Result := IntConfigFrame[Page];
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
      if Assigned (CurrentRecord.RelatedObject) and (CurrentRecord.RelatedObject is tOutputFileFrame) then
        if tOutputFileFrame (CurrentRecord.RelatedObject).TabSheet = FilePageControl.ActivePage then
        begin
          Result := CurrentRecord;
          Exit;
        end;
    end;
  end;
end;

function Tjson2pumlMainForm.GetCurrentPage: tJson2PumlPage;
var
  p: tJson2PumlPage;
begin
  Result := low(p);
  for p := low(p) to high(p) do
    if TabSheetByPage (p) = MainPageControl.ActivePage then
    begin
      Result := p;
      Exit;
    end;
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
  //GenerateServiceListResults;
end;

procedure Tjson2pumlMainForm.InitFormDefaultLogger;
begin
  InitDefaultLogger (GlobalConfigurationDefinition.LogFileOutputPath, jatUI, false,
    not FindCmdLineSwitch(cNoLogFiles, True));
  FLogStringListProvider := TLogStringListProvider.Create;
  Logger.Providers.add (LogStringListProvider);
  LogStringListProvider.ShowTimeStamp := True;
  LogStringListProvider.ShowEventTypes := True;
  LogStringListProvider.LogList := LogLines;
  LogStringListProvider.LogLevel := LOG_DEBUG;
  SetLogProviderDefaults (LogStringListProvider, jatUI);
  LogStringListProvider.Enabled := True;
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

procedure Tjson2pumlMainForm.LoadConfigFileName (iPage: tJson2PumlPage; iFileName: string);
begin
  if not Assigned (InputHandler) or not Assigned (InputHandler.CmdLineParameter) then
    Exit;
  case iPage of
    // jpExeute: ;
    jpInputList:
      InputHandler.LoadInputListFile (iFileName);
    jpCurlAuthenticationFile:
      InputHandler.LoadCurlAuthenticationFile (iFileName);
    jpCurlParameterFile:
      InputHandler.LoadCurlParameterFile (iFileName);
    jpDefinitionFile:
      InputHandler.LoadDefinitionFile (iFileName);
    jpOptionFile:
      InputHandler.LoadOptionFile (iFileName);
    jpParameterFile:
      InputHandler.LoadParameterFile (iFileName);
    jpGlobalConfig:
      InputHandler.LoadConfigurationFile (iFileName);
    // jpOutput: ;
  end;

end;

procedure Tjson2pumlMainForm.LoadFileActionExecute (Sender: TObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    ConfigFrame[CurrentPage].OpenFile;
end;

procedure Tjson2pumlMainForm.OpenConfigurationFileExternalExecute (Sender: TObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    OpenFile (ConfigFrame[CurrentPage].ConfigFileName);
end;

procedure Tjson2pumlMainForm.OpenCurrentJSONActionExecute (Sender: TObject);
begin
  OpenCurrentJSONFile;
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

procedure Tjson2pumlMainForm.OpenJsonDetailTabSheetExecute (Sender: TObject);
var
  CurrentRecord: TJson2PumlInputHandlerRecord;
begin
  if Sender is TAction then
    if (TAction(Sender).Tag >= 0) and (TAction(Sender).Tag < InputHandler.InputListLines.Count) then
    begin
      ShowJsonTabSheet;
      CurrentRecord := InputHandler[TAction(Sender).Tag];
      if Assigned (CurrentRecord.RelatedObject) and (CurrentRecord.RelatedObject is tOutputFileFrame) then
        FilePageControl.ActivePage := tOutputFileFrame (CurrentRecord.RelatedObject).TabSheet;
    end;
end;

procedure Tjson2pumlMainForm.OpenCurrentPNGActionExecute (Sender: TObject);
begin
  OpenCurrentPNGFile;
end;

procedure Tjson2pumlMainForm.OpenCurrentSVGActionExecute (Sender: TObject);
begin
  OpenCurrentSVGFile;
end;

procedure Tjson2pumlMainForm.OpenCurrentJSONFile;
begin
  if Assigned (CurrentInputHandlerRecord) then
    OpenFile (CurrentInputHandlerRecord.InputFile.OutputFileName);
end;

procedure Tjson2pumlMainForm.ReloadAndConvertActionExecute (Sender: TObject);
begin
  HandleInputParameter;
end;

procedure Tjson2pumlMainForm.ReloadFileActionExecute (Sender: TObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    ConfigFrame[CurrentPage].ReloadFile;
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

procedure Tjson2pumlMainForm.SaveFileActionExecute (Sender: TObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    ConfigFrame[CurrentPage].SaveFile;
end;

procedure Tjson2pumlMainForm.SaveFileActionUpdate (Sender: TObject);
begin
  if Sender is TAction then
    TAction (Sender).Enabled := Assigned (ConfigFrame[CurrentPage]);
end;

procedure Tjson2pumlMainForm.SetConfigFileName (iPage: tJson2PumlPage; iFileName: string);
begin
  if not Assigned (InputHandler) or not Assigned (InputHandler.CmdLineParameter) then
    Exit;
  case iPage of
    // jpExeute: ;
    jpInputList:
      InputHandler.CmdLineParameter.InputListFileName := iFileName;
    jpCurlAuthenticationFile:
      InputHandler.CmdLineParameter.CurlAuthenticationFileName := iFileName;
    jpCurlParameterFile:
      InputHandler.CmdLineParameter.CurlParameterFileName := iFileName;
    jpDefinitionFile:
      InputHandler.CmdLineParameter.DefinitionFileName := iFileName;
    jpOptionFile:
      InputHandler.CmdLineParameter.OptionFileName := iFileName;
    jpParameterFile:
      InputHandler.CmdLineParameter.ParameterFileName := iFileName;
    jpGlobalConfig:
      InputHandler.CmdLineParameter.ConfigurationFileName := iFileName;
    // jpOutput: ;
  end;
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

procedure Tjson2pumlMainForm.SetCurrentPage (const Value: tJson2PumlPage);
begin
  MainPageControl.ActivePage := TabSheetByPage (Value);
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

procedure Tjson2pumlMainForm.ShowExecuteActionExecute (Sender: TObject);
begin
  ShowLogTabsheet;
end;

procedure Tjson2pumlMainForm.ShowInputListActionExecute (Sender: TObject);
begin
  ShowInputListTabSheet;
end;

procedure Tjson2pumlMainForm.ShowInputListTabSheet;
begin
  MainPageControl.ActivePage := InputListTabSheet;
end;

procedure Tjson2pumlMainForm.ShowJsonTabSheet;
begin
  MainPageControl.ActivePage := OutputTabsheet;
end;

procedure Tjson2pumlMainForm.ShowLogTabsheet;
begin
  MainPageControl.ActivePage := LogTabSheet;
end;

procedure Tjson2pumlMainForm.ShowOptionFileActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := OptionFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowOutputFilesActionExecute (Sender: TObject);
begin
  ShowJsonTabSheet;
end;

procedure Tjson2pumlMainForm.ShowParameterFileActionExecute (Sender: TObject);
begin
  MainPageControl.ActivePage := ParameterFileTabSheet;
end;

function Tjson2pumlMainForm.TabSheetByPage (iPage: tJson2PumlPage): TTabSheet;
begin
  case iPage of
    jpInputList:
      Result := InputListTabSheet;
    jpCurlAuthenticationFile:
      Result := CurlAuthenticationTabSheet;
    jpCurlParameterFile:
      Result := CurlParameterFileTabSheet;
    jpDefinitionFile:
      Result := DefinitionFileTabSheet;
    jpOptionFile:
      Result := OptionFileTabSheet;
    jpParameterFile:
      Result := ParameterFileTabSheet;
    jpOutput:
      Result := OutputTabsheet;
    jpGlobalConfig:
      Result := GlobalConfigurationFileTabSheet;
    else
      Result := LogTabSheet;
  end;
end;

procedure Tjson2pumlMainForm.UpdateAllInfos;
var
  Page: tJson2PumlPage;
begin
  for Page := low(Page) to high(Page) do
    if Page.IsConfig then
      if Assigned (ConfigFrame[Page]) then
        ConfigFrame[Page].UpdateInfos;
end;

destructor tOutputFileFrame.Destroy;
begin
  // Free will be handled automatically when clearing the parent contrls
  // FFrame.Free;
  // FTabSheet.Free;
  inherited Destroy;
end;

procedure Tjson2pumlMainForm.HandleNotifyChange (Sender: TObject; ProgressValue, ProgressMaxValue: Integer);
begin
{$IFDEF SYNEDIT}
  if Assigned (fLogMemo) then
    TSynEdit (fLogMemo).CaretY := TSynEdit (fLogMemo).Lines.Count + 1;
{$ENDIF}
  Application.ProcessMessages;
  Taskbar.ProgressValue := ProgressValue;
  Taskbar.ProgressMaxValue := ProgressMaxValue;
end;

end.
