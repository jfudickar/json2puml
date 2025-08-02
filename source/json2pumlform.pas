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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList,
  Vcl.ImgList, Vcl.StdActns, System.Actions, Vcl.ActnList, json2pumlframe, json2pumldefinition, Vcl.ActnMenus,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ExtDlgs, Vcl.Grids, json2pumlinputhandler, Vcl.PlatformDefaultStyleActnCtrls, Data.DB,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, json2pumlconfigframe,
  json2pumlbasedefinition, json2pumlvcltools, System.Win.TaskbarCore, Vcl.Taskbar, Quick.Logger.Provider.StringList,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Buttons;

type
  tOutputFileFrame = class(tObject)
  private
    FFrame: tJson2PumlOutputFileFrame;
    FTabSheet: TTabSheet;
  public
    destructor Destroy; override;
    property Frame: tJson2PumlOutputFileFrame read FFrame write FFrame;
    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
  end;

  Tjson2pumlMainForm = class(TForm)
    Action1: TAction;
    ActionMainMenuBar: TActionMainMenuBar;
    ActionToolBar5: TActionToolBar;
    CommandLineEditPanel: TPanel;
    ConvertAllOpenFilesAction: TAction;
    ConvertCurrentFileAction: TAction;
    CopyCurrentPUMLAction: TAction;
    CurlAuthenticationParameterDataset: TFDMemTable;
    CurlAuthenticationParameterDataSource: TDataSource;
    CurlAuthenticationTabSheet: TTabSheet;
    CurlParameterDataSet: TFDMemTable;
    CurlParameterDataSetName: TStringField;
    CurlParameterDataSetValue: TStringField;
    CurlParameterDataSource: TDataSource;
    CurlParameterFileTabSheet: TTabSheet;
    DefinitionFileTabSheet: TTabSheet;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    ExecutionLogPanel: TPanel;
    ExecutionLogTabSheet: TTabSheet;
    ExitAction: TAction;
    FileListPanel: TPanel;
    ResultFileListTabSheet: TTabSheet;
    FilePageControl: TPageControl;
    GlobalConfigurationFileTabSheet: TTabSheet;
    MainImageList: TImageList;
    InitialTimer: TTimer;
    InputListTabSheet: TTabSheet;
    JsonActionList: TActionList;
    Label10: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    LoadFileAction: TAction;
    LogTabSheet: TTabSheet;
    MainActionList: TActionList;
    MainActionManager: TActionManager;
    MainActionToolBar: TActionToolBar;
    MainPageControl: TPageControl;
    OpenCurrentPNGAction: TAction;
    OpenCurrentSVGAction: TAction;
    OptionFileTabSheet: TTabSheet;
    OutputTabsheet: TTabSheet;
    ParameterFileTabSheet: TTabSheet;
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
    StatusBar: TStatusBar;
    StringField3: TStringField;
    StringField4: TStringField;
    TabSheet2: TTabSheet;
    OpenCurrentJSONAction: TAction;
    OpenConfigurationFileExternal: TAction;
    Taskbar: TTaskbar;
    Label21: TLabel;
    LeftInputPanel: TPanel;
    CurlParameterPageControl: TPageControl;
    CurlParameterTabSheet: TTabSheet;
    CurlParameterDBGrid: TDBGrid;
    CurlAuthenticationParameterTabSheet: TTabSheet;
    CurlAuthenticationParameterDBGrid: TDBGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label24: TLabel;
    definitionfileEdit: TButtonedEdit;
    optionfileEdit: TButtonedEdit;
    optionComboBox: TComboBox;
    formatDefinitionFilesCheckBox: TCheckBox;
    CurlAuthenticationFileEdit: TButtonedEdit;
    CurlParameterFileEdit: TButtonedEdit;
    parameterFileEdit: TButtonedEdit;
    MiddleInputPanel: TPanel;
    RightInputPanel: TPanel;
    GroupBox5: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    titlefilterEdit: TButtonedEdit;
    identfilterEdit: TButtonedEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label23: TLabel;
    openoutputEdit: TEdit;
    outputformatEdit: TEdit;
    outputpathEdit: TEdit;
    detailEdit: TEdit;
    groupEdit: TEdit;
    generatesummaryCheckBox: TCheckBox;
    generatedetailsCheckBox: TCheckBox;
    OpenOutputAllCheckBox: TCheckBox;
    outputsuffixEdit: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    PlantUmlJarFileLabel: TLabel;
    javaruntimeparameterLabel: TLabel;
    Label25: TLabel;
    PlantUmlJarFileEdit: TButtonedEdit;
    javaruntimeparameterEdit: TButtonedEdit;
    PlantUmlRuntimeParameterEdit: TButtonedEdit;
    GroupBox6: TGroupBox;
    generateoutputdefinitionCheckBox: TCheckBox;
    debugCheckBox: TCheckBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label17: TLabel;
    inputfileEdit: TButtonedEdit;
    inputlistfileEdit: TButtonedEdit;
    leadingObjectEdit: TEdit;
    splitInputFileCheckBox: TCheckBox;
    splitIdentifierEdit: TEdit;
    ProgressbarPanel: TPanel;
    ExpandProgressBar: TProgressBar;
    ConvertProgressBar: TProgressBar;
    ExpandProgressLabel: TLabel;
    ConvertProgressLabel: TLabel;
    CurlFileTabSheet: TTabSheet;
    CurlFileListDBGrid: TDBGrid;
    CurlFileListMemTable: TFDMemTable;
    CurlFileListDataSource: TDataSource;
    CurlFileListMemTableInputFile: TStringField;
    CurlFileListMemTableOutputFile: TStringField;
    CurlFileListMemTableUrl: TStringField;
    CurlFileListMemTableCommand: TStringField;
    CurlFileListMemTableGenerated: TBooleanField;
    CurlFileListMemTableDuration: TStringField;
    CurlFileListMemTableLine: TIntegerField;
    CurlFileListMemTableErrorMessage: TStringField;
    Panel1: TPanel;
    Label28: TLabel;
    CurlCommandDBEdit: TDBMemo;
    Button2: TButton;
    GenerateServiceListResultsAction: TAction;
    InputLabel: TLabel;
    ExecutionLogFileNameEdit: TButtonedEdit;
    CurlFileListMemTableNoOfRecords: TIntegerField;
    CurlFileListMemTableFileSizeKB: TFloatField;
    FileEditActionList: TActionList;
    FileEditCopyFilenameAction: TAction;
    FileEditOpenFileAction: TAction;
    CurlCommandCopyBitBtn: TBitBtn;
    ServiceInformationResultTabSheet: TTabSheet;
    TabSheet1: TTabSheet;
    ServiceInformationResultPanel: TPanel;
    ServiceErrorMessageResultPanel: TPanel;
    LogFileDetailPageControl: TPageControl;
    curlIgnoreCacheCheckBox: TCheckBox;
    GenerateProgressBar: TProgressBar;
    GenerateProgressLabel: TLabel;
    procedure CommandLineEditPanelResize (Sender: tObject);
    procedure ConvertAllOpenFilesActionExecute (Sender: tObject);
    procedure ConvertCurrentFileActionExecute (Sender: tObject);
    procedure CopyCurrentPUMLActionExecute (Sender: tObject);
    procedure CurlCommandCopyBitBtnClick (Sender: tObject);
    procedure ExitActionExecute (Sender: tObject);
    procedure FileEditCopyFilenameActionExecute (Sender: tObject);
    procedure FileEditOpenFileActionExecute (Sender: tObject);
    procedure FormClose (Sender: tObject; var Action: TCloseAction);
    procedure FormCloseQuery (Sender: tObject; var CanClose: boolean);
    procedure FormShow (Sender: tObject);
    procedure GenerateServiceListResultsActionExecute (Sender: tObject);
    procedure InitialTimerTimer (Sender: tObject);
    procedure LoadFileActionExecute (Sender: tObject);
    procedure OpenConfigurationFileExternalExecute (Sender: tObject);
    procedure OpenCurrentJSONActionExecute (Sender: tObject);
    procedure OpenJsonDetailTabSheetExecute (Sender: tObject);
    procedure OpenCurrentPNGActionExecute (Sender: tObject);
    procedure OpenCurrentSVGActionExecute (Sender: tObject);
    procedure ReloadAndConvertActionExecute (Sender: tObject);
    procedure ReloadFileActionExecute (Sender: tObject);
    procedure SaveFileActionExecute (Sender: tObject);
    procedure SaveFileActionUpdate (Sender: tObject);
    procedure ShowCurlAuthenticationActionExecute (Sender: tObject);
    procedure ShowCurlParameterActionExecute (Sender: tObject);
    procedure ShowDefinitionFileActionExecute (Sender: tObject);
    procedure ShowExecuteActionExecute (Sender: tObject);
    procedure ShowInputListActionExecute (Sender: tObject);
    procedure ShowOptionFileActionExecute (Sender: tObject);
    procedure ShowOutputFilesActionExecute (Sender: tObject);
    procedure ShowParameterFileActionExecute (Sender: tObject);
  private
    FConvertCnt: integer;
    FCurlAuthenticationFileLines: tStrings;
    FCurlParameterFileLines: tStrings;
    FDefinitionLines: tStrings;
    FFileListLines: tStrings;
    FGlobalConfigurationFileLines: tStrings;
    FInputHandler: tJson2PumlInputHandler;
    FInputListLines: tStrings;
    FLogLines: tStrings;
    fLogMemo: TWinControl;
    FLogStringListProvider: TLogStringListProvider;
    FOptionFileLines: tStrings;
    FParameterFileLines: tStrings;
    FServicedefinitionfileResultLines: tStrings;
    FServiceinputlistfileResultLines: tStrings;
    FServiceInformationResultLines: tStrings;
    FServiceErrorMessagesResultLines: tStrings;
    FServiceResultLines: tStrings;
{$IFDEF SYNEDIT}
    fSynJSONSyn: TSynJSONSyn;
{$ENDIF}
    IntConfigFrame: array [tJson2PumlPage] of tJson2PumlConfigurationFrame;
    procedure AfterCreateAllInputHandlerRecords (Sender: tObject);
    procedure AfterCreateInputHandlerRecord (InputHandlerRecord: tJson2PumlInputHandlerRecord);
    procedure AfterHandleAllInputHandlerRecords (Sender: tObject);
    procedure AfterUpdateInputHandlerRecord (InputHandlerRecord: tJson2PumlInputHandlerRecord);
    procedure BeforeCreateAllInputHandlerRecords (Sender: tObject);
    procedure BeforeDeleteAllInputHandlerRecords (Sender: tObject);
    function CalcTabsheetCaption (iInputHandlerRecord: tJson2PumlInputHandlerRecord): string;
    procedure CreateOutputFileFrame (iInputHandlerRecord: tJson2PumlInputHandlerRecord);
    function GetConfigFrame (Page: tJson2PumlPage): tJson2PumlConfigurationFrame;
    function GetCurrentInputHandlerRecord: tJson2PumlInputHandlerRecord;
    function GetCurrentPage: tJson2PumlPage;
    procedure InitFormDefaultLogger;
    procedure InitializeInputHandler;
    procedure HandleNotifyChange (Sender: tObject; ChangeType: tJson2PumlNotifyChangeType;
      ProgressValue, ProgressMaxValue: integer; ProgressInfo: string = '');
    procedure SetCurrentPage (const Value: tJson2PumlPage);
    property CurlAuthenticationFileLines: tStrings read FCurlAuthenticationFileLines write FCurlAuthenticationFileLines;
    property CurlParameterFileLines: tStrings read FCurlParameterFileLines write FCurlParameterFileLines;
    property DefinitionLines: tStrings read FDefinitionLines write FDefinitionLines;
    property FileListLines: tStrings read FFileListLines write FFileListLines;
    property GlobalConfigurationFileLines: tStrings read FGlobalConfigurationFileLines
      write FGlobalConfigurationFileLines;
    property InputListLines: tStrings read FInputListLines write FInputListLines;
    property LogLines: tStrings read FLogLines write FLogLines;
    property OptionFileLines: tStrings read FOptionFileLines write FOptionFileLines;
    property ParameterFileLines: tStrings read FParameterFileLines write FParameterFileLines;
    property ServicedefinitionfileResultLines: tStrings read FServicedefinitionfileResultLines
      write FServicedefinitionfileResultLines;
    property ServiceinputlistfileResultLines: tStrings read FServiceinputlistfileResultLines
      write FServiceinputlistfileResultLines;
    property ServiceInformationResultLines: tStrings read FServiceInformationResultLines
      write FServiceInformationResultLines;
    property ServiceErrorMessagesResultLines: tStrings read FServiceErrorMessagesResultLines
      write FServiceErrorMessagesResultLines;
    property ServiceResultLines: tStrings read FServiceResultLines write FServiceResultLines;
  protected
    procedure BeginConvert;
    procedure CommandLineToForm;
    procedure ConvertAllFrames;
    procedure ConvertCurrentFrame;
    procedure CreateConfigFrames (iPage: tJson2PumlPage; var oLines: tStrings; iShowAction: TAction;
      iConfigObjectClass: tJson2PumlBaseObjectClass);
    procedure CreateMemoControls;
    function CreateSingleMemoControl (iParentControl: TWinControl; iName: string; iLabel: TLabel;
      var oMemoLines: tStrings; iUseHighlighter, iReadOnly: boolean): TWinControl;
    procedure EndConvert;
    procedure FillCurlFileListDataset (ConverterInputList: tJson2PumlInputList);
    procedure FormToCommandline;
    function GetConfigFileName (iPage: tJson2PumlPage): string;
    procedure HandleInputParameter;
    procedure InitializeAllTButtonedEdit (iParentControl: TWinControl);
    procedure InitializeTButtonedEdit (iButtonedEdit: TButtonedEdit);
    function IsConverting: boolean;
    procedure LoadConfigFileName (iPage: tJson2PumlPage; iFileName: string);
    procedure ReloadFiles;
    procedure SetConfigFileName (iPage: tJson2PumlPage; iFileName: string);
    procedure SetConverting (Converting: boolean);
    procedure ShowDefinitionTabsheet;
    procedure ShowInputListTabSheet;
    procedure ShowJsonTabSheet;
    procedure ShowLogTabsheet;
    function TabSheetByPage (iPage: tJson2PumlPage): TTabSheet;
    procedure UpdateAllInfos;
    property ConfigFileName[Page: tJson2PumlPage]: string read GetConfigFileName write SetConfigFileName;
    property ConfigFrame[Page: tJson2PumlPage]: tJson2PumlConfigurationFrame read GetConfigFrame;
    property CurrentPage: tJson2PumlPage read GetCurrentPage write SetCurrentPage;
    property LogStringListProvider: TLogStringListProvider read FLogStringListProvider;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    function CalcShortCutStr (iIndex: integer): string;
    procedure CopyCurrentPUMLToClipboard;
    procedure GenerateServiceResults (iInputHandler: tJson2PumlInputHandler);
    procedure OpenCurrentPNGFile;
    procedure OpenCurrentSVGFile;
    procedure OpenCurrentJSONFile;
    property CurrentInputHandlerRecord: tJson2PumlInputHandlerRecord read GetCurrentInputHandlerRecord;
    property InputHandler: tJson2PumlInputHandler read FInputHandler;
  end;

var
  json2pumlMainForm: Tjson2pumlMainForm;

implementation

uses
  json2pumltools, Vcl.Clipbrd, Winapi.ShellAPI, System.IOUtils, json2pumlconst, System.UITypes, json2pumlloghandler,
  Quick.Logger, json2pumlconverterdefinition, System.Math;

{$R *.dfm}

constructor Tjson2pumlMainForm.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FLogStringListProvider := TLogStringListProvider.Create;
  Logger.Providers.add (LogStringListProvider);
end;

destructor Tjson2pumlMainForm.Destroy;
begin
  if Assigned (LogStringListProvider) then
  begin
    if Logger.Providers.IndexOf (LogStringListProvider) >= 0 then
      Logger.Providers.delete (Logger.Providers.IndexOf(LogStringListProvider));
  end;
  FInputHandler.Free;
  GlobalLogStringListProvider.LogList := nil;
  inherited Destroy;
end;

procedure Tjson2pumlMainForm.AfterCreateAllInputHandlerRecords (Sender: tObject);
begin
end;

procedure Tjson2pumlMainForm.AfterCreateInputHandlerRecord (InputHandlerRecord: tJson2PumlInputHandlerRecord);
begin
  CreateOutputFileFrame (InputHandlerRecord);
end;

procedure Tjson2pumlMainForm.AfterHandleAllInputHandlerRecords (Sender: tObject);
begin
  if FileExists (InputHandler.ConverterInputList.FileListFileName) then
    FileListLines.LoadFromFile (InputHandler.ConverterInputList.FileListFileName);
  FillCurlFileListDataset (InputHandler.ConverterInputList);
  if GlobalLogHandler.Failed then
  begin
    Taskbar.ProgressState := TTaskBarProgressState.Error;
    if ExpandProgressBar.Position < ExpandProgressBar.Max then
      ExpandProgressBar.State := pbsError;
    if ConvertProgressBar.Position < ConvertProgressBar.Max then
      ConvertProgressBar.State := pbsError;
  end
  else
    Taskbar.ProgressState := TTaskBarProgressState.None;
end;

procedure Tjson2pumlMainForm.AfterUpdateInputHandlerRecord (InputHandlerRecord: tJson2PumlInputHandlerRecord);
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

procedure Tjson2pumlMainForm.BeforeCreateAllInputHandlerRecords (Sender: tObject);
begin
  LogFileDetailPageControl.ActivePage := ExecutionLogTabSheet;
  if jofLog in InputHandler.CurrentOutputFormats then
    ExecutionLogFileNameEdit.Text := jofExecuteLog.Filename (InputHandler.CalculateSummaryFileName(jofPUML))
  else
    ExecutionLogFileNameEdit.Text := '';
  FillCurlFileListDataset (nil);
  HandleNotifyChange (self, nctConvert, 0, 0);
  HandleNotifyChange (self, nctExpand, 0, 0);
  HandleNotifyChange (self, nctGenerate, 0, 0);

  ConvertProgressBar.State := pbsNormal;
  ExpandProgressBar.State := pbsNormal;
  Taskbar.ProgressState := TTaskBarProgressState.Normal;
  UpdateAllInfos;
end;

procedure Tjson2pumlMainForm.BeforeDeleteAllInputHandlerRecords (Sender: tObject);
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
    SetConverting (true);
end;

function Tjson2pumlMainForm.CalcShortCutStr (iIndex: integer): string;
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

function Tjson2pumlMainForm.CalcTabsheetCaption (iInputHandlerRecord: tJson2PumlInputHandlerRecord): string;
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
    iDataset.Active := true;
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
  curlIgnoreCacheCheckBox.Checked := InputHandler.CmdLineParameter.CurlIgnoreCache;
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

procedure Tjson2pumlMainForm.ConvertAllOpenFilesActionExecute (Sender: tObject);
begin
  ConvertAllFrames;
end;

procedure Tjson2pumlMainForm.ConvertCurrentFileActionExecute (Sender: tObject);
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

procedure Tjson2pumlMainForm.CopyCurrentPUMLActionExecute (Sender: tObject);
begin
  CopyCurrentPUMLToClipboard;
end;

procedure Tjson2pumlMainForm.CopyCurrentPUMLToClipboard;
begin
  if Assigned (CurrentInputHandlerRecord) then
    Clipboard.AsText := CurrentInputHandlerRecord.PUmlOutput.Text;
end;

procedure Tjson2pumlMainForm.CreateConfigFrames (iPage: tJson2PumlPage; var oLines: tStrings; iShowAction: TAction;
  iConfigObjectClass: tJson2PumlBaseObjectClass);
var
  Frame: tJson2PumlConfigurationFrame;
  TabSheet: TTabSheet;
begin
  IntConfigFrame[iPage] := nil;
  TabSheet := TabSheetByPage (iPage);
  iPage.SetToShowAction (iShowAction);
  TabSheet.Caption := iPage.TabSheetCaption;
  if not iPage.IsConfig then
    Exit;
  Frame := tJson2PumlConfigurationFrame.Create (TabSheet);
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
  InitializeAllTButtonedEdit (Frame);
end;

procedure Tjson2pumlMainForm.CreateMemoControls;
var
  DummyLines: tStrings;
  Page: tJson2PumlPage;
  i: integer;
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

  fLogMemo := CreateSingleMemoControl (ExecutionLogPanel, 'ExecutionLogMemo', nil, FLogLines, false, true);
  CreateSingleMemoControl (FileListPanel, 'FileListMemo', nil, FFileListLines, true, true);
  CreateSingleMemoControl (ServiceResultPanel, 'ServiceResultMemo', nil, FServiceResultLines, true, true);
  CreateSingleMemoControl (ServiceInputListFileResultPanel, 'ServiceResultMemo', nil, FServiceinputlistfileResultLines,
    true, true);
  CreateSingleMemoControl (ServiceDefinitionFileResultPanel, 'ServiceResultMemo', nil,
    FServicedefinitionfileResultLines, true, true);
  CreateSingleMemoControl (ServiceInformationResultPanel, 'ServiceResultMemo', nil, FServiceInformationResultLines,
    true, true);
  CreateSingleMemoControl (ServiceErrorMessageResultPanel, 'ServiceResultMemo', nil, FServiceErrorMessagesResultLines,
    true, true);
end;

procedure Tjson2pumlMainForm.CreateOutputFileFrame (iInputHandlerRecord: tJson2PumlInputHandlerRecord);
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
  OutputFileFrame.Frame := tJson2PumlOutputFileFrame.Create (OutputFileFrame.TabSheet);
  OutputFileFrame.Frame.Parent := OutputFileFrame.TabSheet;
  OutputFileFrame.Frame.InputFileName := iInputHandlerRecord.InputFile.InputFileName;
  OutputFileFrame.Frame.InputGroup := iInputHandlerRecord.InputGroup;
  OutputFileFrame.Frame.PNGFileName := '';
  OutputFileFrame.Frame.SVGFileName := '';
  OutputFileFrame.Frame.PUmlFileName := iInputHandlerRecord.InputFile.Output.PUmlFileName;
  OutputFileFrame.Frame.LeadingObject := iInputHandlerRecord.InputFile.LeadingObject;
  OutputFileFrame.Frame.Align := alClient;
  OutputFileFrame.Frame.CreateMemos (CreateSingleMemoControl);
  InitializeAllTButtonedEdit (OutputFileFrame.Frame);
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
  var oMemoLines: tStrings; iUseHighlighter, iReadOnly: boolean): TWinControl;
{$IFDEF SYNEDIT}
var
  NewEdit: TSynEdit;
begin
  NewEdit := TSynEdit.Create (iParentControl);

  NewEdit.Name := iName;
  NewEdit.Parent := iParentControl;
  NewEdit.Align := alClient;
  NewEdit.TabOrder := 1;
  NewEdit.Gutter.ShowLineNumbers := true;
  NewEdit.UseCodeFolding := true;
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
  NewMemo.WantTabs := true;
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

procedure Tjson2pumlMainForm.ExitActionExecute (Sender: tObject);
begin
  Close;
end;

procedure Tjson2pumlMainForm.FormClose (Sender: tObject; var Action: TCloseAction);
begin
  InputHandler.Clear;
end;

procedure Tjson2pumlMainForm.FormCloseQuery (Sender: tObject; var CanClose: boolean);
begin
  CanClose := not IsConverting;
  if CanClose then
    InputHandler.Clear;
end;

procedure Tjson2pumlMainForm.FormShow (Sender: tObject);
begin
  InitialTimer.Enabled := true;
  CreateMemoControls;
  InitializeAllTButtonedEdit (MainPageControl);
  InitFormDefaultLogger;
  LogFileDetailPageControl.ActivePage := ExecutionLogTabSheet;
  FInputHandler := tJson2PumlInputHandler.Create (jatUI);
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
  InputHandler.CmdLineParameter.CurlIgnoreCache := curlIgnoreCacheCheckBox.Checked;
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
  GlobalCommandLineParameter.Debug := debugCheckBox.Checked; // Doing it twice to support also the log initialisation
  FillParameterList (InputHandler.CmdLineParameter.CurlParameter, CurlParameterDataSet);
  FillParameterList (InputHandler.CmdLineParameter.CurlAuthenticationParameter, CurlAuthenticationParameterDataset);
end;

procedure Tjson2pumlMainForm.GenerateServiceResults (iInputHandler: tJson2PumlInputHandler);
begin
  GetServiceFileListResponse (ServiceinputlistfileResultLines,
    InputHandler.GlobalConfiguration.InputListFileSearchFolder, true, jav2);
  GetServiceFileListResponse (ServicedefinitionfileResultLines,
    InputHandler.GlobalConfiguration.DefinitionFileSearchFolder, false, jav2);
  GetServiceInformationResponse (ServiceInformationResultLines, iInputHandler);
  GetServiceErrorMessageResponse (ServiceErrorMessagesResultLines);
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

function Tjson2pumlMainForm.GetConfigFrame (Page: tJson2PumlPage): tJson2PumlConfigurationFrame;
begin
  Result := IntConfigFrame[Page];
end;

function Tjson2pumlMainForm.GetCurrentInputHandlerRecord: tJson2PumlInputHandlerRecord;
var
  CurrentRecord: tJson2PumlInputHandlerRecord;
  i: integer;
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
  InitFormDefaultLogger;
  LogLines.Clear;
  if InputHandler.CmdLineParameter.Failed then
  begin
    ShowLogTabsheet;
    Exit;
  end;
  ReloadFiles;
  UpdateAllInfos;
  // GenerateServiceResults;
end;

procedure Tjson2pumlMainForm.InitFormDefaultLogger;
begin
  InitDefaultLogger (GlobalConfigurationDefinition.LogFileOutputPath, jatUI, false,
    not FindCmdLineSwitch(cNoLogFiles, true));
  LogStringListProvider.ShowTimeStamp := true;
  LogStringListProvider.ShowEventTypes := true;
  LogStringListProvider.LogList := LogLines;
  SetLogProviderDefaults (LogStringListProvider, jatUI);
  LogStringListProvider.Enabled := true;
end;

procedure Tjson2pumlMainForm.InitializeInputHandler;
begin
  InitialTimer.Enabled := false;
  InputHandler.CmdLineParameter.ReadInputParameter;
  CommandLineToForm;
end;

procedure Tjson2pumlMainForm.InitialTimerTimer (Sender: tObject);
begin
  InitializeInputHandler;
  if InputHandler.CmdLineParameter.Failed then // To prevent the double log output
  begin
    ShowLogTabsheet;
    Exit;
  end;
  HandleInputParameter;
end;

function Tjson2pumlMainForm.IsConverting: boolean;
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

procedure Tjson2pumlMainForm.LoadFileActionExecute (Sender: tObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    ConfigFrame[CurrentPage].OpenFile;
end;

procedure Tjson2pumlMainForm.OpenConfigurationFileExternalExecute (Sender: tObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    OpenFile (ConfigFrame[CurrentPage].ConfigFileName);
end;

procedure Tjson2pumlMainForm.OpenCurrentJSONActionExecute (Sender: tObject);
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

procedure Tjson2pumlMainForm.OpenJsonDetailTabSheetExecute (Sender: tObject);
var
  CurrentRecord: tJson2PumlInputHandlerRecord;
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

procedure Tjson2pumlMainForm.OpenCurrentPNGActionExecute (Sender: tObject);
begin
  OpenCurrentPNGFile;
end;

procedure Tjson2pumlMainForm.OpenCurrentSVGActionExecute (Sender: tObject);
begin
  OpenCurrentSVGFile;
end;

procedure Tjson2pumlMainForm.OpenCurrentJSONFile;
begin
  if Assigned (CurrentInputHandlerRecord) then
    OpenFile (CurrentInputHandlerRecord.InputFile.OutputFileName);
end;

procedure Tjson2pumlMainForm.ReloadAndConvertActionExecute (Sender: tObject);
begin
  HandleInputParameter;
end;

procedure Tjson2pumlMainForm.ReloadFileActionExecute (Sender: tObject);
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

procedure Tjson2pumlMainForm.SaveFileActionExecute (Sender: tObject);
begin
  if Assigned (ConfigFrame[CurrentPage]) then
    ConfigFrame[CurrentPage].SaveFile;
end;

procedure Tjson2pumlMainForm.SaveFileActionUpdate (Sender: tObject);
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

procedure Tjson2pumlMainForm.SetConverting (Converting: boolean);
var
  i: integer;
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

procedure Tjson2pumlMainForm.ShowCurlAuthenticationActionExecute (Sender: tObject);
begin
  MainPageControl.ActivePage := CurlAuthenticationTabSheet;
end;

procedure Tjson2pumlMainForm.ShowCurlParameterActionExecute (Sender: tObject);
begin
  MainPageControl.ActivePage := CurlParameterFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowDefinitionFileActionExecute (Sender: tObject);
begin
  ShowDefinitionTabsheet;
end;

procedure Tjson2pumlMainForm.ShowDefinitionTabsheet;
begin
  MainPageControl.ActivePage := DefinitionFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowExecuteActionExecute (Sender: tObject);
begin
  ShowLogTabsheet;
end;

procedure Tjson2pumlMainForm.ShowInputListActionExecute (Sender: tObject);
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

procedure Tjson2pumlMainForm.ShowOptionFileActionExecute (Sender: tObject);
begin
  MainPageControl.ActivePage := OptionFileTabSheet;
end;

procedure Tjson2pumlMainForm.ShowOutputFilesActionExecute (Sender: tObject);
begin
  ShowJsonTabSheet;
end;

procedure Tjson2pumlMainForm.ShowParameterFileActionExecute (Sender: tObject);
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

procedure Tjson2pumlMainForm.CommandLineEditPanelResize (Sender: tObject);
begin
  LeftInputPanel.Width := Round (CommandLineEditPanel.Width / 3) - 1;
  MiddleInputPanel.Width := LeftInputPanel.Width;
end;

procedure Tjson2pumlMainForm.CurlCommandCopyBitBtnClick (Sender: tObject);
begin
  FileEditCopyFilenameActionExecute (CurlCommandDBEdit);
end;

procedure Tjson2pumlMainForm.FileEditCopyFilenameActionExecute (Sender: tObject);
begin
  if Sender is TCustomEdit then
    if TCustomEdit (Sender).Text <> '' then
      Clipboard.AsText := TCustomEdit (Sender).Text;
end;

procedure Tjson2pumlMainForm.FileEditOpenFileActionExecute (Sender: tObject);
begin
  if Sender is TCustomEdit then
    if TCustomEdit (Sender).Text <> '' then
      OpenFile (TCustomEdit(Sender).Text);
end;

procedure Tjson2pumlMainForm.FillCurlFileListDataset (ConverterInputList: tJson2PumlInputList);
var
  InputFile: tJson2PumlInputFileDefinition;
  Field: TField;
  Line: integer;

  procedure SetField (iFieldName: string; iFieldValue: Variant);
  var
    Field: TField;
  begin
    Field := CurlFileListMemTable.FieldByName (iFieldName);
    Field.Value := iFieldValue;
    if Length (iFieldValue) > Field.DisplayWidth then
      Field.DisplayWidth := Length (iFieldValue);
  end;

begin
  CurlFileListMemTable.Active := true;
  while CurlFileListMemTable.RecordCount > 0 do
    CurlFileListMemTable.delete;
  for Field in CurlFileListMemTable.Fields do
    Field.DisplayWidth := 5;
  Line := 1;
  if Assigned (ConverterInputList) then
    for InputFile in ConverterInputList do
    begin
      if InputFile.IsSummaryFile then
        Continue;
      if InputFile.CurlResult.Command.IsEmpty then
        Continue;
      CurlFileListMemTable.Append;
      SetField ('Line', Line);
      SetField ('InputFile', InputFile.InputFileName);
      SetField ('OutputFile', InputFile.CurlResult.OutPutFile);
      SetField ('Url', InputFile.CurlResult.Url);
      SetField ('Command', InputFile.CurlResult.Command);
      SetField ('Generated', InputFile.CurlResult.Generated);
      SetField ('Duration', InputFile.CurlResult.Duration);
      SetField ('NoOfRecords', InputFile.CurlResult.NoOfRecords);
      SetField ('FileSizeKB', RoundTo(InputFile.CurlResult.FileSize / 1024, - 2));
      SetField ('ErrorMessage', InputFile.CurlResult.ErrorMessage);
      Inc (Line);
    end;
end;

procedure Tjson2pumlMainForm.GenerateServiceListResultsActionExecute (Sender: tObject);
begin
  GenerateServiceResults (InputHandler);
end;

procedure Tjson2pumlMainForm.HandleNotifyChange (Sender: tObject; ChangeType: tJson2PumlNotifyChangeType;
  ProgressValue, ProgressMaxValue: integer; ProgressInfo: string = '');

  procedure SetProgress (iLabel: TLabel; iLabelBaseText: string; iProgressBar: TProgressBar);
  begin
    iProgressBar.Position := ProgressValue;
    iProgressBar.Max := ProgressMaxValue;
    iProgressBar.Update;
    if ProgressMaxValue > 0 then
      iLabel.Caption := Format ('%s: %d / %d', [iLabelBaseText, ProgressValue, ProgressMaxValue])
    else
      iLabel.Caption := iLabelBaseText;
  end;

begin
{$IFDEF SYNEDIT}
  if Assigned (fLogMemo) then
    TSynEdit (fLogMemo).CaretY := TSynEdit (fLogMemo).Lines.Count + 1;
{$ENDIF}
  fLogMemo.Update;
  case ChangeType of
    nctExpand:
      SetProgress (ExpandProgressLabel, 'Expand', ExpandProgressBar);
    nctConvert:
      SetProgress (ConvertProgressLabel, 'Convert', ConvertProgressBar);
    nctGenerate:
      SetProgress (GenerateProgressLabel, 'Generate', GenerateProgressBar);
  end;
  if ProgressValue = ProgressMaxValue then
  begin
    Taskbar.ProgressValue := 0;
    Taskbar.ProgressMaxValue := 0;
  end
  else
  begin
    Taskbar.ProgressValue := ProgressValue;
    Taskbar.ProgressMaxValue := ProgressMaxValue;
  end;
  // Sleep (1);
  Application.ProcessMessages;
end;

procedure Tjson2pumlMainForm.InitializeAllTButtonedEdit (iParentControl: TWinControl);
var
  i: integer;
begin
  if not Assigned (iParentControl) then
    Exit;
  if iParentControl is TButtonedEdit then
    InitializeTButtonedEdit (TButtonedEdit(iParentControl))
  else
    for i := 0 to iParentControl.ControlCount - 1 do
      if iParentControl.Controls[i] is TWinControl then
        InitializeAllTButtonedEdit (TWinControl(iParentControl.Controls[i]));
end;

procedure Tjson2pumlMainForm.InitializeTButtonedEdit (iButtonedEdit: TButtonedEdit);
begin
  if not Assigned (iButtonedEdit) then
    Exit;
  iButtonedEdit.LeftButton.Visible := true;
  iButtonedEdit.LeftButton.ImageIndex := 2;
  iButtonedEdit.OnLeftButtonClick := FileEditCopyFilenameActionExecute;
  iButtonedEdit.RightButton.Visible := true;
  iButtonedEdit.RightButton.ImageIndex := 7;
  iButtonedEdit.OnRightButtonClick := FileEditOpenFileActionExecute;
  iButtonedEdit.OnDblClick := FileEditOpenFileActionExecute;
  iButtonedEdit.Images := MainImageList;
end;

end.
