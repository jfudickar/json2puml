{-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------}

unit json2pumlinputhandler;

interface

uses
  json2pumldefinition, System.Classes, json2pumlloghandler, json2pumlconst, json2pumlbasedefinition,
  json2pumlconverterdefinition;

type

  TJson2PumlInputHandlerParseFileEvent = procedure of object;

  TJson2PumlInputHandlerRecord = class(tJson2PumlBaseObject)
  private
    FConverterLog: TStrings;
    FIndex: Integer;
    FInputDetail: string;
    FInputFile: tJson2PumlInputFileDefinition;
    FInputGroup: string;
    FIntConverterLog: TStrings;
    FIntJsonInput: TStrings;
    FIntPUmlOutput: TStrings;
    FJsonInput: TStrings;
    FPUmlOutput: TStrings;
    FRelatedObject: TObject;
    function GetConverterLog: TStrings;
    function GetJsonInput: TStrings;
    function GetPUmlOutput: TStrings;
    procedure SetConverterLog (const Value: TStrings);
    procedure SetJsonInput (const Value: TStrings);
    procedure SetPUmlOutput (const Value: TStrings);
  protected
    function GetIdent: string; override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property index: Integer read FIndex write FIndex;
    property InputDetail: string read FInputDetail write FInputDetail;
    property InputFile: tJson2PumlInputFileDefinition read FInputFile write FInputFile;
    property InputGroup: string read FInputGroup write FInputGroup;
    property JsonInput: TStrings read GetJsonInput write SetJsonInput;
    property PUmlOutput: TStrings read GetPUmlOutput write SetPUmlOutput;
    property RelatedObject: TObject read FRelatedObject write FRelatedObject;
  published
    property ConverterLog: TStrings read GetConverterLog write SetConverterLog;
  end;

  TJson2PumlInputHandlerList = class(tJson2PumlBaseList)
  private
    FExecuteLogFile: string;
    function GetHandlerRecord (index: Integer): TJson2PumlInputHandlerRecord;
  public
    property ExecuteLogFile: string read FExecuteLogFile write FExecuteLogFile;
    property HandlerRecord[index: Integer]: TJson2PumlInputHandlerRecord read GetHandlerRecord;
  end;

  TJson2PumlInputHandlerRecordEvent = procedure(InputHandlerRecord: TJson2PumlInputHandlerRecord) of object;

  TJson2PumlInputHandler = class(tPersistent)
  private
    FAfterCreateAllRecords: TNotifyEvent;
    FAfterCreateRecord: TJson2PumlInputHandlerRecordEvent;
    FAfterHandleAllRecords: TNotifyEvent;
    FAfterUpdateRecord: TJson2PumlInputHandlerRecordEvent;
    FApplicationType: tJson2PumlApplicationType;
    FBeforeCreateAllRecords: TNotifyEvent;
    FBeforeDeleteAllRecords: TNotifyEvent;
    FConvertCnt: Integer;
    FCurlAuthenticationFileLines: TStrings;
    FCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
    FCurlParameterFileLines: TStrings;
    FCurlParameterList: tJson2PumlCurlParameterList;
    FCurrentConverterDefinition: tJson2PumlConverterDefinition;
    FDefinitionLines: TStrings;
    FGlobalConfiguration: tJson2PumlGlobalDefinition;
    FHandlerRecordList: TJson2PumlInputHandlerList;
    FInputListLines: TStrings;
    FIntConfigurationFileLines: TStrings;
    FIntCurlAuthenticationFileLines: TStrings;
    FIntCurlParameterFileLines: TStrings;
    FIntDefinitionLines: TStrings;
    FIntInputListLines: TStrings;
    FIntOptionFileLines: TStrings;
    FIntParameterFileLines: TStrings;
    FIntServerResultLines: TStrings;
    FOptionFileDefinition: tJson2PumlConverterDefinition;
    FOptionFileLines: TStrings;
    FParameterDefinition: tJson2PumlParameterFileDefinition;
    FParameterFileLines: TStrings;
    FServerResultLines: TStrings;
    procedure CalculateCurrentConverterDefinition;
    function CurrentGenerateDetails: Boolean;
    function CurrentGenerateSummary: Boolean;
    function GetBaseOutputPath: string;
    function GetCount: Integer;
    function GetCurlParameterFileLines: TStrings;
    function GetCurrentConfigurationFileName: string;
    function GetCurrentCurlAuthenticationFileName: string;
    function GetCurrentDefinitionFileName: string;
    function GetCurrentDetail: string;
    function GetCurrentFullOutputPath: string;
    function GetCurrentGroup: string;
    function GetCurrentInputListFileName: string;
    function GetCurrentJavaRuntimeParameter: string;
    function GetCurrentJobName: string;
    function GetCurrentOption: string;
    function GetCurrentOutputFormats (ConverterDefinition: tJson2PumlConverterDefinition): tJson2PumlOutputFormats;
    function GetCurrentOutputPath: string;
    function GetCurrentOutputSuffix: string;
    function GetCurrentPlantUmlJarFileName: string;
    function GetDefinedDetail: string;
    function GetDefinedGroup: string;
    function GetDefinedOption: string;
    function GetDefinitionLines: TStrings;
    function GetGenerateDetails: Boolean;
    function GetGenerateDetailsStr: string;
    function GetGenerateSummary: Boolean;
    function GetGenerateSummaryStr: string;
    function GetHandlerRecord (index: Integer): TJson2PumlInputHandlerRecord;
    function GetInputListLines: TStrings;
    function GetOptionFileLines: TStrings;
    function GetParameterFileLines: TStrings;
    function GetServerResultLines: TStrings;
  protected
    procedure BuildSummaryFile (iSingleRecord: TJson2PumlInputHandlerRecord);
    function CalculateOutputDirectory (iFileName, iOutputPath, iOption: string): string;
    function CalculateOutputFileName (iSourceFileName: string; iOutputFormat: tJson2PumlOutputFormat): string;
    function CalculateOutputFileNamePath (iSourceFileName: string; iOutputFormat: tJson2PumlOutputFormat): string;
    function CalculateSummaryFileName (iOutputFormat: tJson2PumlOutputFormat): string;
    function CalculateZipFileName: string;
    procedure ClearAllRecords;
    procedure ConvertAllRecordsInt (iIndex: Integer = - 1);
    procedure CreateAllRecords;
    function CreateSingleRecord (iInputFile: tJson2PumlInputFileDefinition; iInputGroup, iInputDetail: string)
      : TJson2PumlInputHandlerRecord;
    function IsConverting: Boolean;
    function LoadFileToStringList (iFileList: TStrings; iFileName, iFileDescription: string;
      iClass: tJson2PumlBaseObjectClass; iParseProcedure: TJson2PumlInputHandlerParseFileEvent;
      iMandatory: Boolean): Boolean;
    procedure ParseConfigurationFile;
    procedure ParseDefintions;
    procedure ParseInputListFile;
    procedure ParseParameterFile;
    procedure ReformatFile (iFileName: string; iClass: tJson2PumlBaseListClass); overload;
    procedure ReformatFile (iFileName: string; iClass: tJson2PumlBaseObjectClass); overload;
    function ReplaceFileNameVariables (iReplace, iFileName, iOption: string): string;
    procedure SetConverting (Converting: Boolean);
    property CurrentDetail: string read GetCurrentDetail;
    property GenerateDetails: Boolean read GetGenerateDetails;
    property GenerateDetailsStr: string read GetGenerateDetailsStr;
    property GenerateSummary: Boolean read GetGenerateSummary;
    property GenerateSummaryStr: string read GetGenerateSummaryStr;
    property HandlerRecordList: TJson2PumlInputHandlerList read FHandlerRecordList;
  public
    FCmdLineParameter: tJson2PumlCommandLineParameter;
    FConfigurationFileLines: TStrings;
    FConverterDefinitionGroup: tJson2PumlConverterGroupDefinition;
    FConverterInputList: tJson2PumlInputList;
    constructor Create (iApplicationType: tJson2PumlApplicationType);
    destructor Destroy; override;
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    procedure BeginConvert;
    function CalculateRuntimeJarFile: string;
    procedure Clear;
    procedure ConvertAllRecords (iIndex: Integer = - 1);
    procedure DeleteGeneratedFiles;
    procedure EndConvert;
    procedure GenerateSummaryZipFile;
    function GetConfigurationFileLines: TStrings;
    function GetCurlAuthenticationFileLines: TStrings;
    function LoadConfigurationFile (iFileName: string = ''): Boolean;
    function LoadCurlAuthenticationFile (iFileName: string = ''): Boolean;
    function LoadCurlParameterFile (iFileName: string = ''): Boolean;
    function LoadDefinitionFile (iFileName: string = ''): Boolean;
    procedure LoadDefinitionFiles;
    function LoadInputFile (iFileName: string = ''): Boolean;
    function LoadInputListFile (iFileName: string = ''): Boolean;
    function LoadOptionFile (iFileName: string = ''): Boolean;
    function LoadParameterFile (iFileName: string = ''): Boolean;
    procedure RecreateAllRecords;
    function ValidateCurrentOptions: Boolean;
    property ApplicationType: tJson2PumlApplicationType read FApplicationType;
    property BaseOutputPath: string read GetBaseOutputPath;
    property CmdLineParameter: tJson2PumlCommandLineParameter read FCmdLineParameter;
    property ConfigurationFileLines: TStrings read GetConfigurationFileLines write FConfigurationFileLines;
    property ConverterDefinitionGroup: tJson2PumlConverterGroupDefinition read FConverterDefinitionGroup;
    property ConverterInputList: tJson2PumlInputList read FConverterInputList;
    property Count: Integer read GetCount;
    property CurlAuthenticationFileLines: TStrings read GetCurlAuthenticationFileLines
      write FCurlAuthenticationFileLines;
    property CurlAuthenticationList: tJson2PumlCurlAuthenticationList read FCurlAuthenticationList;
    property CurlParameterFileLines: TStrings read GetCurlParameterFileLines write FCurlParameterFileLines;
    property CurlParameterList: tJson2PumlCurlParameterList read FCurlParameterList;
    property CurrentConfigurationFileName: string read GetCurrentConfigurationFileName;
    property CurrentConverterDefinition: tJson2PumlConverterDefinition read FCurrentConverterDefinition;
    property CurrentCurlAuthenticationFileName: string read GetCurrentCurlAuthenticationFileName;
    property CurrentDefinitionFileName: string read GetCurrentDefinitionFileName;
    property CurrentFullOutputPath: string read GetCurrentFullOutputPath;
    property CurrentGroup: string read GetCurrentGroup;
    property CurrentInputListFileName: string read GetCurrentInputListFileName;
    property CurrentJavaRuntimeParameter: string read GetCurrentJavaRuntimeParameter;
    property CurrentJobName: string read GetCurrentJobName;
    property CurrentOption: string read GetCurrentOption;
    property CurrentOutputPath: string read GetCurrentOutputPath;
    property CurrentOutputSuffix: string read GetCurrentOutputSuffix;
    property CurrentPlantUmlJarFileName: string read GetCurrentPlantUmlJarFileName;
    property DefinedDetail: string read GetDefinedDetail;
    property DefinedGroup: string read GetDefinedGroup;
    property DefinedOption: string read GetDefinedOption;
    property HandlerRecord[index: Integer]: TJson2PumlInputHandlerRecord read GetHandlerRecord; default;
    property AfterCreateAllRecords: TNotifyEvent read FAfterCreateAllRecords write FAfterCreateAllRecords;
    property AfterCreateRecord: TJson2PumlInputHandlerRecordEvent read FAfterCreateRecord write FAfterCreateRecord;
    property AfterHandleAllRecords: TNotifyEvent read FAfterHandleAllRecords write FAfterHandleAllRecords;
    property AfterUpdateRecord: TJson2PumlInputHandlerRecordEvent read FAfterUpdateRecord write FAfterUpdateRecord;
    property BeforeCreateAllRecords: TNotifyEvent read FBeforeCreateAllRecords write FBeforeCreateAllRecords;
    property BeforeDeleteAllRecords: TNotifyEvent read FBeforeDeleteAllRecords write FBeforeDeleteAllRecords;
  published
    property DefinitionLines: TStrings read GetDefinitionLines write FDefinitionLines;
    property GlobalConfiguration: tJson2PumlGlobalDefinition read FGlobalConfiguration;
    property InputListLines: TStrings read GetInputListLines write FInputListLines;
    property OptionFileDefinition: tJson2PumlConverterDefinition read FOptionFileDefinition;
    property OptionFileLines: TStrings read GetOptionFileLines write FOptionFileLines;
    property ParameterDefinition: tJson2PumlParameterFileDefinition read FParameterDefinition;
    property ParameterFileLines: TStrings read GetParameterFileLines write FParameterFileLines;
    property ServerResultLines: TStrings read GetServerResultLines write FServerResultLines;
  end;

implementation

uses
  System.SysUtils, System.IOUtils, json2pumltools, json2pumlconverter, jsontools;

constructor TJson2PumlInputHandlerRecord.Create;
begin
  inherited Create;
  FIntPUmlOutput := TStringList.Create;
  FIntJsonInput := TStringList.Create;
  FRelatedObject := nil;
  FIntConverterLog := TStringList.Create ();
end;

destructor TJson2PumlInputHandlerRecord.Destroy;
begin
  FIntConverterLog.Free;
  FIntJsonInput.Free;
  FIntPUmlOutput.Free;
  inherited Destroy;
end;

function TJson2PumlInputHandlerRecord.GetConverterLog: TStrings;
begin
  if Assigned (FConverterLog) then
    Result := FConverterLog
  else
    Result := FIntConverterLog;
end;

function TJson2PumlInputHandlerRecord.GetIdent: string;
begin
  Result := InputFile.InputFileName;
end;

function TJson2PumlInputHandlerRecord.GetJsonInput: TStrings;
begin
  if Assigned (FJsonInput) then
    Result := FJsonInput
  else
    Result := FIntJsonInput;
end;

function TJson2PumlInputHandlerRecord.GetPUmlOutput: TStrings;
begin
  if Assigned (FPUmlOutput) then
    Result := FPUmlOutput
  else
    Result := FIntPUmlOutput;
end;

procedure TJson2PumlInputHandlerRecord.SetConverterLog (const Value: TStrings);
begin
  FConverterLog := Value;
end;

procedure TJson2PumlInputHandlerRecord.SetJsonInput (const Value: TStrings);
begin
  FJsonInput := Value;
end;

procedure TJson2PumlInputHandlerRecord.SetPUmlOutput (const Value: TStrings);
begin
  FPUmlOutput := Value;
end;

function TJson2PumlInputHandlerList.GetHandlerRecord (index: Integer): TJson2PumlInputHandlerRecord;
begin
  Result := TJson2PumlInputHandlerRecord (Objects[index]);
end;

constructor TJson2PumlInputHandler.Create (iApplicationType: tJson2PumlApplicationType);
begin
  inherited Create;
  FCmdLineParameter := tJson2PumlCommandLineParameter.Create;
  FConverterDefinitionGroup := tJson2PumlConverterGroupDefinition.Create ();
  FCurlAuthenticationList := tJson2PumlCurlAuthenticationList.Create ();
  FCurlParameterList := tJson2PumlCurlParameterList.Create ();
  FCurlParameterList.MulitpleValues := true;
  FConverterInputList := tJson2PumlInputList.Create (CalculateOutputFileNamePath);
  FConverterInputList.CurlAuthenticationList := CurlAuthenticationList;
  FConverterInputList.CurlParameterList := CurlParameterList;
  FOptionFileDefinition := tJson2PumlConverterDefinition.Create ();
  FInputListLines := nil;
  FDefinitionLines := nil;

  FHandlerRecordList := TJson2PumlInputHandlerList.Create;
  FHandlerRecordList.OwnsObjects := true;

  FIntInputListLines := TStringList.Create;
  FIntDefinitionLines := TStringList.Create;
  FIntOptionFileLines := TStringList.Create;
  FIntParameterFileLines := TStringList.Create;
  FIntCurlAuthenticationFileLines := TStringList.Create;
  FIntCurlParameterFileLines := TStringList.Create;
  FCurrentConverterDefinition := tJson2PumlConverterDefinition.Create ();
  FParameterDefinition := tJson2PumlParameterFileDefinition.Create ();
  FIntServerResultLines := TStringList.Create;
  FGlobalConfiguration := tJson2PumlGlobalDefinition.Create ();
  FIntConfigurationFileLines := TStringList.Create;
  FApplicationType := iApplicationType;
end;

destructor TJson2PumlInputHandler.Destroy;
begin
  FIntConfigurationFileLines.Free;
  FGlobalConfiguration.Free;
  FIntServerResultLines.Free;
  FParameterDefinition.Free;
  FCurrentConverterDefinition.Free;
  FConverterInputList.CurlAuthenticationList := nil;
  FConverterInputList.CurlParameterList := nil;
  FIntCurlAuthenticationFileLines.Free;
  FIntCurlParameterFileLines.Free;
  FIntOptionFileLines.Free;
  FIntDefinitionLines.Free;
  FIntInputListLines.Free;
  FIntParameterFileLines.Free;

  FHandlerRecordList.Free;

  FOptionFileDefinition.Free;
  FCurlParameterList.Free;
  FCurlAuthenticationList.Free;
  FConverterDefinitionGroup.Free;
  FConverterInputList.Free;
  FCmdLineParameter.Free;
  inherited Destroy;
end;

procedure TJson2PumlInputHandler.AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
begin
  ioDeleteHandler.AddDirectory (BaseOutputPath);
  ConverterInputList.AddGeneratedFilesToDeleteHandler (ioDeleteHandler);
end;

procedure TJson2PumlInputHandler.BeginConvert;
begin
  Inc (FConvertCnt);
  if FConvertCnt = 1 then
  begin
    SetConverting (true);
    GlobalLoghandler.Clear;
  end;
end;

procedure TJson2PumlInputHandler.BuildSummaryFile (iSingleRecord: TJson2PumlInputHandlerRecord);
var
  LastProperty: string;
  SingleJson: TStringList;
  InputFile: tJson2PumlInputFileDefinition;
  First: Boolean;
begin
  iSingleRecord.JsonInput.Clear;
  if iSingleRecord.InputFile.OutputFileName.IsEmpty then
    Exit;
  if not iSingleRecord.InputFile.IsSummaryFile then
    Exit;
  ConverterInputList.Sort;
  First := true;
  SingleJson := TStringList.Create;
  iSingleRecord.ConverterLog.Add (Format('Start building summary file"%s"', [iSingleRecord.InputFile.OutputFileName]));
  try
    LastProperty := '';
    iSingleRecord.JsonInput.Add ('[');
    for InputFile in ConverterInputList do
    begin
      if not InputFile.GenerateOutput then
        Continue;
      if InputFile.IsSummaryFile then
        Continue;
      if not InputFile.Exists then
      begin
        if InputFile.OutputFileName.IndexOf ('*') < 0 then
          iSingleRecord.ConverterLog.Add (Format(#9'"%s" skipped, file does not exists', [InputFile.OutputFileName]));
        Continue;
      end;
      SingleJson.LoadFromFile (InputFile.OutputFileName);
      if SingleJson.Count = 0 then
      begin
        iSingleRecord.ConverterLog.Add (Format(#9'"%s" skipped, file is empty ', [InputFile.OutputFileName]));
        Continue;
      end;
      if not First then
        iSingleRecord.JsonInput.Add (',');
      First := false;
      if InputFile.LeadingObject.IsEmpty then
        iSingleRecord.JsonInput.AddStrings (SingleJson)
      else
      begin
        iSingleRecord.JsonInput.Add (Format('{"%s" : ', [InputFile.LeadingObject]));
        iSingleRecord.JsonInput.AddStrings (SingleJson);
        iSingleRecord.JsonInput.Add ('}');
      end;
      iSingleRecord.ConverterLog.Add (Format(#9'"%s" added, %d lines handled', [InputFile.OutputFileName,
        SingleJson.Count]));
    end;
    iSingleRecord.JsonInput.Add (']');
    if iSingleRecord.JsonInput.Count > 0 then
    begin
      GenerateFileDirectory (iSingleRecord.InputFile.OutputFileName);
      iSingleRecord.JsonInput.SaveToFile (iSingleRecord.InputFile.OutputFileName);
      if jofPUML in CmdLineParameter.OpenOutputs then
        OpenFile (iSingleRecord.InputFile.OutputFileName);
    end;
  finally
    SingleJson.Free;
    iSingleRecord.ConverterLog.Add (Format('Finished building summary file "%s"',
      [iSingleRecord.InputFile.OutputFileName]));
  end;
end;

procedure TJson2PumlInputHandler.CalculateCurrentConverterDefinition;
begin
  if OptionFileDefinition.IsFilled then
    ConverterDefinitionGroup.FillDefinitionFromOption (FCurrentConverterDefinition, OptionFileDefinition)
  else
    ConverterDefinitionGroup.FillDefinitionFromOption (FCurrentConverterDefinition, CurrentOption);
end;

function TJson2PumlInputHandler.CalculateOutputDirectory (iFileName, iOutputPath, iOption: string): string;
begin
  if iOutputPath.IsEmpty then
    Result := ExtractFilePath (iFileName)
  else
  begin
    Result := ReplaceFileNameVariables (iOutputPath, iFileName, iOption);
  end;
  Result := ReplaceInvalidPathChars (Result);
end;

function TJson2PumlInputHandler.CalculateOutputFileName (iSourceFileName: string;
  iOutputFormat: tJson2PumlOutputFormat): string;
var
  Filename: string;
  Option: string;
  Suffix: string;
begin
  if iOutputFormat = jofJSON then
    Option := ''
  else
    Option := CurrentOption;
  Filename := tpath.ChangeExtension (ExtractFileName(iSourceFileName), '').TrimRight (['.']);
  Suffix := ReplaceFileNameVariables (CurrentOutputSuffix, iSourceFileName, Option);
  if (not Suffix.IsEmpty) and (Suffix <> tpath.ExtensionSeparatorChar) then
    Filename := Filename + Suffix;
  Filename := CurlParameterList.ReplaceParameterValues (Filename);
  Filename := ReplaceFileNameVariables (Filename, iSourceFileName, Option);
  Filename := Filename + iOutputFormat.FileExtension (true);
  Filename := ReplaceInvalidFileNameChars (Filename);
  Result := Filename;
end;

function TJson2PumlInputHandler.CalculateOutputFileNamePath (iSourceFileName: string;
  iOutputFormat: tJson2PumlOutputFormat): string;
var
  Filename: string;
  Option: string;
begin
  if iOutputFormat = jofJSON then
    Option := ''
  else
    Option := CurrentOption;
  Filename := CalculateOutputFileName (iSourceFileName, iOutputFormat);

  Result := CurrentFullOutputPath;
  Result := CurlParameterList.ReplaceParameterValues (Result);
  Result := ReplaceFileNameVariables (Result, Filename, Option);
  Result := ReplaceInvalidPathChars (Result);
  Result := PathCombine (Result, Filename);

end;

function TJson2PumlInputHandler.CalculateRuntimeJarFile: string;
var
  JarFile: string;
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    case i of
      1:
        JarFile := CurrentPlantUmlJarFileName;
      2:
        JarFile := GetEnvironmentVariable (cPlantUmlJarFileRegistry);
      3:
        JarFile := cDefaultPlantumljarFile;
    end;
    if FileExists (JarFile) then
    begin
      Result := JarFile;
      Exit;
    end;
  end;
  Result := '';
  GlobalLoghandler.Error ('PlantUML Jar Files not found!');
end;

function TJson2PumlInputHandler.CalculateSummaryFileName (iOutputFormat: tJson2PumlOutputFormat): string;
var
  Filename: string;
begin
  if ConverterInputList.SummaryFileName.Trim.IsEmpty then
    Filename := 'summary'
  else
    Filename := ExtractFileName (ConverterInputList.SummaryFileName);
  Result := CalculateOutputFileNamePath (Filename, iOutputFormat);
end;

function TJson2PumlInputHandler.CalculateZipFileName: string;
var
  Filename: string;
  Option: string;
  i: Integer;
begin
  Option := CurrentOption;
  if ConverterInputList.SummaryFileName.Trim.IsEmpty then
    Filename := 'summary'
  else
    Filename := ExtractFileName (ConverterInputList.SummaryFileName);
  Filename := CalculateOutputFileName (Filename, jofZip);

  Result := CurrentFullOutputPath;
  i := Result.IndexOf (jfnrFile.ToString);
  if i >= 0 then
    Result := Result.SubString (0, i - 1);
  Result := CurlParameterList.ReplaceParameterValues (Result);
  Result := ReplaceFileNameVariables (Result, Filename, Option);
  Result := ReplaceInvalidPathChars (Result);
  Result := PathCombine (Result, Filename);
end;

procedure TJson2PumlInputHandler.Clear;
begin
  ClearAllRecords;
end;

procedure TJson2PumlInputHandler.ClearAllRecords;
begin
  if Assigned (BeforeDeleteAllRecords) then
    BeforeDeleteAllRecords (self);
  HandlerRecordList.Clear;
  CurlParameterList.Clear;
end;

procedure TJson2PumlInputHandler.ConvertAllRecords (iIndex: Integer = - 1);
begin
  ParseDefintions;
  ConvertAllRecordsInt (iIndex);
end;

procedure TJson2PumlInputHandler.ConvertAllRecordsInt (iIndex: Integer = - 1);
var
  i: Integer;
  SingleRecord: TJson2PumlInputHandlerRecord;
  OutputFile: string;
  OutputFormats: tJson2PumlOutputFormats;
  Converter: TJson2PumlConverter;
  JarFile: string;
begin
  ValidateCurrentOptions;
  if DefinitionLines.Text.IsEmpty then
    Exit;
  if HandlerRecordList.Count <= 0 then
    Exit;
  JarFile := CalculateRuntimeJarFile;
  Converter := TJson2PumlConverter.Create;
  try
    Converter.InputHandler := self;
    for i := 0 to HandlerRecordList.Count - 1 do
    begin
      if (iIndex >= 0) and (iIndex < HandlerRecordList.Count) then
        if i <> iIndex then
          Continue;
      SingleRecord := self[i];
      SingleRecord.ConverterLog.Clear;
      OutputFormats := GetCurrentOutputFormats (CurrentConverterDefinition);
      // if not SingleRecord.InputFile.Original then // to prevent double adding of output suffix
      // OutputFile := tpath.ChangeExtension (SingleRecord.InputFile.OutputFileName, jofPUML.FileExtension)
      // OutputFile := CalculateOutputFileNamePath (SingleRecord.InputFile.InputFileName, jofPUML)
      // else
      OutputFile := CalculateOutputFileNamePath (SingleRecord.InputFile.OutputFileName, jofPUML);
      GenerateFileDirectory (OutputFile);
      if SingleRecord.InputFile.IsSummaryFile then
        BuildSummaryFile (SingleRecord);
      GlobalLoghandler.Info ('[%3d/%3d] Convert %s', [i + 1, HandlerRecordList.Count,
        SingleRecord.InputFile.OutputFileName]);
      GlobalLoghandler.Info ('               to %s', [OutputFile]);
      if Assigned (AfterUpdateRecord) then
        AfterUpdateRecord (SingleRecord); // To Update the console
      Converter.LeadingObject := SingleRecord.InputFile.LeadingObject;
      Converter.InputHandlerRecord := SingleRecord;
      Converter.Definition := CurrentConverterDefinition;
      Converter.PumlFile := OutputFile;
      Converter.Convert;
      GlobalLoghandler.Info ('               %-4s generated', ['puml']);
      if CmdLineParameter.GenerateOutputDefinition then
        CurrentConverterDefinition.WriteToJsonFile (ChangeFileExt(OutputFile, '.definition.json'), true);
      if CmdLineParameter.Debug then
      begin
        SingleRecord.ConverterLog.SaveToFile (ChangeFileExt(OutputFile, '.log'));
        SingleRecord.InputFile.Output.ConverterLogFileName := ChangeFileExt (OutputFile, '.log');
      end;
      if SingleRecord.PUmlOutput.Text <> '' then
      begin
        SingleRecord.InputFile.Output.PUmlFileName := OutputFile;
        SingleRecord.PUmlOutput.SaveToFile (SingleRecord.InputFile.Output.PUmlFileName);
        if GenerateOutputsFromPuml (SingleRecord.InputFile.Output.PUmlFileName, JarFile, CurrentJavaRuntimeParameter,
          OutputFormats, CmdLineParameter.OpenOutputs) then
        begin
          if (jofPng in OutputFormats) and FileExists (ChangeFileExt(OutputFile, '.' + jofPng.FileExtension)) then
            SingleRecord.InputFile.Output.PNGFileName := ChangeFileExt (OutputFile, '.' + jofPng.FileExtension)
          else
            SingleRecord.InputFile.Output.PNGFileName := '';
          if (jofSvg in OutputFormats) and FileExists (ChangeFileExt(OutputFile, '.' + jofSvg.FileExtension)) then
            SingleRecord.InputFile.Output.SVGFileName := ChangeFileExt (OutputFile, '.' + jofSvg.FileExtension)
          else
            SingleRecord.InputFile.Output.SVGFileName := '';
          if (jofPdf in OutputFormats) and FileExists (ChangeFileExt(OutputFile, '.' + jofPdf.FileExtension)) then
            SingleRecord.InputFile.Output.PDFFilename := ChangeFileExt (OutputFile, '.' + jofPdf.FileExtension)
          else
            SingleRecord.InputFile.Output.PDFFilename := '';
        end;
      end;
      if Assigned (AfterUpdateRecord) then
        AfterUpdateRecord (SingleRecord);
    end;
    GenerateFileDirectory (CalculateSummaryFileName(jofPUML));
    ConverterInputList.WriteToJsonOutputFiles (tpath.ChangeExtension(CalculateSummaryFileName(jofPUML),
      'filelist.' + jofJSON.FileExtension)); // Use PUML to get the Filename with the option included
    ConverterInputList.WriteToJsonServiceResult (ServerResultLines,
      GetCurrentOutputFormats(CurrentConverterDefinition), false);
    if jofZip in OutputFormats then
      GenerateSummaryZipFile;
    if Assigned (AfterHandleAllRecords) then
      AfterHandleAllRecords (nil);
    GlobalLoghandler.Info ('Done');
  finally
    Converter.Free;
  end;

end;

procedure TJson2PumlInputHandler.CreateAllRecords;
var
  InputFile: tJson2PumlInputFileDefinition;
  OptionList: TStringList;
  GenDetails, GenSummary: Boolean;

begin
  OptionList := TStringList.Create;
  try
    if Assigned (BeforeCreateAllRecords) then
      BeforeCreateAllRecords (self);
    ConverterInputList.ExpandInputList;
    GenSummary := CurrentGenerateSummary;
    GenDetails := CurrentGenerateDetails;
    if ConverterInputList.ExecuteCount <= 0 then
    begin
      GlobalLoghandler.Error ('No input files found, conversion aborted');
      Exit;
    end;
    if OptionList.Count < 0 then
    begin
      GlobalLoghandler.Error ('No matching option found/defined, conversion aborted');
      Exit;
    end;
    if not GenDetails and not GenSummary then
    begin
      GlobalLoghandler.Error ('GenerateDetails or GenerateSummary must be activated, conversion aborted');
      Exit;
    end;
    ConverterInputList.AddSummaryFile (CalculateSummaryFileName(jofJSON));
    for InputFile in ConverterInputList do
    begin
      if not InputFile.GenerateOutput then
        Continue;
      if (InputFile.IsSummaryFile and GenSummary) or (not InputFile.IsSummaryFile and GenDetails) then
      begin
        CreateSingleRecord (InputFile, CurrentGroup, CurrentDetail);
        InputFile.IsGenerated := true;
      end;
    end;
  finally
    if Assigned (AfterCreateAllRecords) then
      AfterCreateAllRecords (self);
    OptionList.Free;
  end;
end;

function TJson2PumlInputHandler.CreateSingleRecord (iInputFile: tJson2PumlInputFileDefinition;
  iInputGroup, iInputDetail: string): TJson2PumlInputHandlerRecord;
var
  SingleRecord: TJson2PumlInputHandlerRecord;
begin
  SingleRecord := TJson2PumlInputHandlerRecord.Create;
  SingleRecord.index := HandlerRecordList.Count;
  SingleRecord.InputFile := iInputFile;
  SingleRecord.InputDetail := iInputDetail;
  SingleRecord.InputGroup := iInputGroup;
  HandlerRecordList.AddBaseObject (SingleRecord);
  if Assigned (AfterCreateRecord) then
    AfterCreateRecord (SingleRecord);
  if FileExists (SingleRecord.InputFile.OutputFileName) and not SingleRecord.InputFile.IsSummaryFile then
    SingleRecord.JsonInput.LoadFromFile (SingleRecord.InputFile.OutputFileName);
  Result := SingleRecord;
end;

function TJson2PumlInputHandler.CurrentGenerateDetails: Boolean;
begin
  if GenerateDetailsStr.IsEmpty or (not GenerateSummary and not GenerateDetails) then
    Result := ConverterInputList.ExecuteCount <= 1
  else
    Result := GenerateDetails;
end;

function TJson2PumlInputHandler.CurrentGenerateSummary: Boolean;
begin
  if GenerateSummaryStr.IsEmpty or (not GenerateSummary and not GenerateDetails) then
    Result := ConverterInputList.ExecuteCount > 1
  else
    Result := GenerateSummary;
end;

procedure TJson2PumlInputHandler.DeleteGeneratedFiles;
begin
  ConverterInputList.DeleteGeneratedFiles (BaseOutputPath);
end;

procedure TJson2PumlInputHandler.EndConvert;
begin
  Dec (FConvertCnt);
  if FConvertCnt = 0 then
    SetConverting (false);
end;

function TJson2PumlInputHandler.GetBaseOutputPath: string;
begin
  if not CmdLineParameter.BaseOutputPath.IsEmpty then
    Result := CmdLineParameter.BaseOutputPath
  else if not GlobalConfiguration.BaseOutputPath.IsEmpty then
    Result := GlobalConfiguration.BaseOutputPath
  else if not CurrentInputListFileName.IsEmpty then
    Result := ExtractFilePath (CurrentInputListFileName)
  else if not CmdLineParameter.InputFileName.IsEmpty then
    Result := ExtractFilePath (CmdLineParameter.InputFileName)
  else
    Result := GetCurrentDir;
  if ApplicationType = jatService then
    Result := PathCombine (Result, TThread.CurrentThread.ThreadID.ToString);
  Result := PathCombineIfRelative (GetCurrentDir, Result);
end;

function TJson2PumlInputHandler.GetConfigurationFileLines: TStrings;
begin
  if Assigned (FConfigurationFileLines) then
    Result := FConfigurationFileLines
  else
    Result := FIntConfigurationFileLines;
end;

function TJson2PumlInputHandler.GetCount: Integer;
begin
  Result := HandlerRecordList.Count;
end;

function TJson2PumlInputHandler.GetCurlAuthenticationFileLines: TStrings;
begin
  if Assigned (FCurlAuthenticationFileLines) then
    Result := FCurlAuthenticationFileLines
  else
    Result := FIntCurlAuthenticationFileLines;
end;

function TJson2PumlInputHandler.GetCurlParameterFileLines: TStrings;
begin
  if Assigned (FCurlParameterFileLines) then
    Result := FCurlParameterFileLines
  else
    Result := FIntCurlParameterFileLines;
end;

function TJson2PumlInputHandler.GetCurrentConfigurationFileName: string;
begin
  if not CmdLineParameter.ConfigurationFileName.IsEmpty then
    Result := CmdLineParameter.ConfigurationFileName
  else
    Result := CmdLineParameter.ConfigurationFileNameEnvironment;
end;

function TJson2PumlInputHandler.GetCurrentCurlAuthenticationFileName: string;
begin
  if not CmdLineParameter.CurlAuthenticationFileName.IsEmpty then
    Result := CmdLineParameter.CurlAuthenticationFileName
  else if not GlobalConfiguration.CurlAuthenticationFileName.IsEmpty then
    Result := GlobalConfiguration.CurlAuthenticationFileName
  else
    Result := CmdLineParameter.CurlAuthenticationFileNameEnvironment;
end;

function TJson2PumlInputHandler.GetCurrentDefinitionFileName: string;
begin
  if not CmdLineParameter.DefinitionFileName.IsEmpty then
    Result := CmdLineParameter.DefinitionFileName
  else if not ParameterDefinition.DefinitionFileNameExpanded.IsEmpty then
    Result := ParameterDefinition.DefinitionFileNameExpanded
  else if not ConverterInputList.DefinitionFileName.IsEmpty then
    Result := ConverterInputList.DefinitionFileName
  else if not GlobalConfiguration.DefaultDefinitionFileName.IsEmpty then
    Result := GlobalConfiguration.DefaultDefinitionFileName
  else
    Result := CmdLineParameter.DefinitionFileNameEnvironment;
end;

function TJson2PumlInputHandler.GetCurrentDetail: string;
begin
  if not CmdLineParameter.Detail.IsEmpty then
    Result := CmdLineParameter.Detail
  else
    Result := DefinedDetail;
end;

function TJson2PumlInputHandler.GetCurrentFullOutputPath: string;
begin
  Result := CurrentOutputPath;
  Result := PathCombineIfRelative (BaseOutputPath, Result);
end;

function TJson2PumlInputHandler.GetCurrentGroup: string;
begin
  if not CmdLineParameter.Group.IsEmpty then
    Result := CmdLineParameter.Group
  else
    Result := DefinedGroup;
end;

function TJson2PumlInputHandler.GetCurrentInputListFileName: string;
begin
  if not CmdLineParameter.InputListFileName.IsEmpty then
    Result := CmdLineParameter.InputListFileName
  else
    Result := ParameterDefinition.InputListFileNameExpanded;
end;

function TJson2PumlInputHandler.GetCurrentJavaRuntimeParameter: string;
begin
  if CmdLineParameter.JavaRuntimeParameter.IsEmpty then
    Result := GlobalConfiguration.JavaRuntimeParameter
  else
    Result := CmdLineParameter.JavaRuntimeParameter;
end;

function TJson2PumlInputHandler.GetCurrentJobName: string;
begin
  if not CmdLineParameter.JobName.IsEmpty then
    Result := CmdLineParameter.JobName
  else if not ConverterInputList.JobName.IsEmpty then
    Result := ConverterInputList.JobName
  else if not ConverterInputList.SourceFileName.IsEmpty then
    Result := tpath.GetFileNameWithoutExtension (ConverterInputList.SourceFileName)
  else
    Result := '';
end;

function TJson2PumlInputHandler.GetCurrentOption: string;
begin
  if OptionFileDefinition.IsFilled then
    if OptionFileDefinition.OptionName.IsEmpty then
      Result := 'single'
    else
      Result := OptionFileDefinition.OptionName
  else if ConverterDefinitionGroup.OptionList.IndexOf (DefinedOption) >= 0 then
    Result := DefinedOption
  else
    Result := ConverterDefinitionGroup.DefaultOption;
end;

function TJson2PumlInputHandler.GetCurrentOutputFormats (ConverterDefinition: tJson2PumlConverterDefinition)
  : tJson2PumlOutputFormats;
begin
  if not (CmdLineParameter.OutputFormats = []) then
    Result := CmdLineParameter.OutputFormats
  else if not (ParameterDefinition.OutputFormats = []) then
    Result := ParameterDefinition.OutputFormats
  else if not (ConverterInputList.OutputFormats = []) then
    Result := ConverterInputList.OutputFormats
  else
    Result := ConverterDefinition.OutputFormats;
end;

function TJson2PumlInputHandler.GetCurrentOutputPath: string;
var
  Dir: string;
begin
  if not (CmdLineParameter.OutputPath.IsEmpty) then
    Result := CmdLineParameter.OutputPath
  else if not (ConverterInputList.OutputPath.IsEmpty) then
  begin
    if ApplicationType = jatService then
      Result := ConverterInputList.OutputPath
    else
      Result := ConverterInputList.OutputPathExpanded;
  end
  else
    Result := GlobalConfiguration.OutputPath;
  if ApplicationType = jatService then
  begin
    Dir := ExtractFileDrive (Result);
    if not Dir.IsEmpty then
      Result := Result.SubString (Dir.Length);
    Result := Result.TrimLeft (tpath.DirectorySeparatorChar);
  end;
  Result := CurlParameterList.ReplaceParameterValues (Result);
end;

function TJson2PumlInputHandler.GetCurrentOutputSuffix: string;
begin
  if not (CmdLineParameter.OutputSuffix.IsEmpty) then
    Result := CmdLineParameter.OutputSuffix
  else if not (ParameterDefinition.OutputSuffix.IsEmpty) then
    Result := ParameterDefinition.OutputSuffix
  else if not (ConverterInputList.OutputSuffix.IsEmpty) then
    Result := ConverterInputList.OutputSuffix
  else
    Result := '';
end;

function TJson2PumlInputHandler.GetCurrentPlantUmlJarFileName: string;
begin
  if not CmdLineParameter.PlantUmlJarFileName.IsEmpty then
    Result := CmdLineParameter.PlantUmlJarFileName
  else
    Result := GlobalConfiguration.PlantUmlJarFileName;
end;

function TJson2PumlInputHandler.GetDefinedDetail: string;
begin
  Result := ConverterInputList.Detail;
end;

function TJson2PumlInputHandler.GetDefinedGroup: string;
begin
  Result := ConverterInputList.Group;
end;

function TJson2PumlInputHandler.GetDefinedOption: string;
begin
  if not CmdLineParameter.Option.IsEmpty then
    Result := CmdLineParameter.Option
  else if not (ParameterDefinition.Option.IsEmpty) then
    Result := ParameterDefinition.Option
  else if not ConverterInputList.Option.IsEmpty then
    Result := ConverterInputList.Option
  else
    Result := ConverterDefinitionGroup.DefaultOption;
end;

function TJson2PumlInputHandler.GetDefinitionLines: TStrings;
begin
  if Assigned (FDefinitionLines) then
    Result := FDefinitionLines
  else
    Result := FIntDefinitionLines;
end;

function TJson2PumlInputHandler.GetGenerateDetails: Boolean;
begin
  Result := StringToBoolean (GenerateDetailsStr, false);
end;

function TJson2PumlInputHandler.GetGenerateDetailsStr: string;
begin
  if not CmdLineParameter.GenerateDetailsStr.IsEmpty then
    Result := CmdLineParameter.GenerateDetailsStr
  else if not (ParameterDefinition.GenerateDetailsStr.IsEmpty) then
    Result := ParameterDefinition.GenerateDetailsStr
  else
    Result := ConverterInputList.GenerateDetailsStr;
end;

function TJson2PumlInputHandler.GetGenerateSummary: Boolean;
begin
  Result := StringToBoolean (GenerateSummaryStr, false);
end;

function TJson2PumlInputHandler.GetGenerateSummaryStr: string;
begin
  if not CmdLineParameter.GenerateSummaryStr.IsEmpty then
    Result := CmdLineParameter.GenerateSummaryStr
  else if not (ParameterDefinition.GenerateSummaryStr.IsEmpty) then
    Result := ParameterDefinition.GenerateSummaryStr
  else
    Result := ConverterInputList.GenerateSummaryStr;
end;

function TJson2PumlInputHandler.GetHandlerRecord (index: Integer): TJson2PumlInputHandlerRecord;
begin
  Result := TJson2PumlInputHandlerRecord (HandlerRecordList.Objects[index]);
end;

function TJson2PumlInputHandler.GetInputListLines: TStrings;
begin
  if Assigned (FInputListLines) then
    Result := FInputListLines
  else
    Result := FIntInputListLines;
end;

function TJson2PumlInputHandler.GetOptionFileLines: TStrings;
begin
  if Assigned (FOptionFileLines) then
    Result := FOptionFileLines
  else
    Result := FIntOptionFileLines;
end;

function TJson2PumlInputHandler.GetParameterFileLines: TStrings;
begin
  if Assigned (FParameterFileLines) then
    Result := FParameterFileLines
  else
    Result := FIntParameterFileLines;
end;

function TJson2PumlInputHandler.GetServerResultLines: TStrings;
begin
  if Assigned (FServerResultLines) then
    Result := FServerResultLines
  else
    Result := FIntServerResultLines;
end;

function TJson2PumlInputHandler.IsConverting: Boolean;
begin
  Result := FConvertCnt > 0;
end;

function TJson2PumlInputHandler.LoadConfigurationFile (iFileName: string = ''): Boolean;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.ConfigurationFileName := iFileName;
  Result := LoadFileToStringList (ConfigurationFileLines, CurrentConfigurationFileName, 'GlobalConfigurationFile',
    tJson2PumlGlobalDefinition, ParseConfigurationFile, false);
end;

function TJson2PumlInputHandler.LoadCurlAuthenticationFile (iFileName: string = ''): Boolean;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.CurlAuthenticationFileName := iFileName;
  Result := LoadFileToStringList (CurlAuthenticationFileLines, CurrentCurlAuthenticationFileName, 'CurlAuthentication',
    tJson2PumlCurlAuthenticationList, nil, false);
end;

function TJson2PumlInputHandler.LoadCurlParameterFile (iFileName: string = ''): Boolean;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.CurlParameterFileName := iFileName;
  Result := LoadFileToStringList (CurlParameterFileLines, CmdLineParameter.CurlParameterFileName, 'CurlParameter',
    tJson2PumlCurlParameterList, nil, false);
end;

function TJson2PumlInputHandler.LoadDefinitionFile (iFileName: string = ''): Boolean;
var
  Filename: string;
begin
  Result := false;
  if not iFileName.IsEmpty then
    CmdLineParameter.DefinitionFileName := iFileName;
  if CurrentDefinitionFileName.IsEmpty then
  begin
    GlobalLoghandler.Error ('Definition file not defined');
    Exit;
  end;
  Filename := GlobalConfiguration.FindDefinitionFile (CurrentDefinitionFileName);
  if Filename.IsEmpty then
  begin
    GlobalLoghandler.Error ('Definition file "%s" not found', [CurrentDefinitionFileName]);
  end
  else
    CmdLineParameter.DefinitionFileName := Filename;
  Result := LoadFileToStringList (DefinitionLines, Filename, 'ConverterDefinition', tJson2PumlConverterGroupDefinition,
    nil, true);
end;

procedure TJson2PumlInputHandler.LoadDefinitionFiles;
begin
  BeginConvert;
  try
    GlobalLoghandler.Info ('Load configuration files');
    LoadConfigurationFile ();
    LoadParameterFile ();
    LoadCurlAuthenticationFile ();
    LoadCurlParameterFile ();
    LoadInputFile ();
    LoadInputListFile ();
    LoadDefinitionFile ();
    LoadOptionFile ();
  finally
    EndConvert;
  end;
end;

function TJson2PumlInputHandler.LoadFileToStringList (iFileList: TStrings; iFileName, iFileDescription: string;
  iClass: tJson2PumlBaseObjectClass; iParseProcedure: TJson2PumlInputHandlerParseFileEvent;
  iMandatory: Boolean): Boolean;
var
  Filename: string;
begin
  Result := false;
  iFileList.Clear;
  if iFileName.IsEmpty then
    Exit;
  Filename := ExpandFileName (iFileName);
  BeginConvert;
  try
    if FileExists (Filename) then
    begin
      if CmdLineParameter.FormatDefinitionFiles then
        ReformatFile (iFileName, iClass);
      try
        iFileList.LoadFromFile (Filename);
      except
        on e: exception do
          GlobalLoghandler.Error (e.Message);
      end;
      GlobalLoghandler.InfoParameter ('Load "', iFileDescription + '" from',
        Format('%s (%d lines)', [Filename, iFileList.Count]));
      Result := true;
    end
    else if iMandatory then
      GlobalLoghandler.Error ('Skipped loading %s from %s, file does not exist.', [iFileDescription, Filename])
    else
      GlobalLoghandler.Warn ('Skipped loading %s from %s, file does not exist.', [iFileDescription, Filename]);
    if Assigned (iParseProcedure) then
      iParseProcedure;
  finally
    EndConvert; // Trigger the recalculation
  end;
end;

function TJson2PumlInputHandler.LoadInputFile (iFileName: string = ''): Boolean;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.InputFileName := iFileName;
  BeginConvert;
  try
    Result := true;
  finally
    EndConvert; // Trigger the recalculation
  end;
end;

function TJson2PumlInputHandler.LoadInputListFile (iFileName: string = ''): Boolean;
var
  Filename: string;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.InputListFileName := iFileName;
  Filename := GlobalConfiguration.FindInputListFile (CurrentInputListFileName);
  if not Filename.IsEmpty then
    CmdLineParameter.InputListFileName := Filename
  else
    GlobalLoghandler.Warn ('InputListFile : "%s" not found', [CurrentInputListFileName]);
  Result := LoadFileToStringList (InputListLines, Filename, 'InputListFile', tJson2PumlInputList,
    ParseInputListFile, false);
end;

function TJson2PumlInputHandler.LoadOptionFile (iFileName: string = ''): Boolean;
begin
  if not iFileName.IsEmpty then
    CmdLineParameter.OptionFileName := iFileName;
  Result := LoadFileToStringList (OptionFileLines, CmdLineParameter.OptionFileName, 'ConverterDefinitionOptionFile',
    tJson2PumlConverterDefinition, nil, false);
end;

function TJson2PumlInputHandler.LoadParameterFile (iFileName: string = ''): Boolean;
begin
  if not CmdLineParameter.ParameterFileContent.IsEmpty then
  begin
    ParameterFileLines.Text := CmdLineParameter.ParameterFileContent;
    Result := true;
    ParseParameterFile;
  end
  else
  begin
    if not iFileName.IsEmpty then
      CmdLineParameter.ParameterFileName := iFileName;
    Result := LoadFileToStringList (ParameterFileLines, CmdLineParameter.ParameterFileName, 'ParameterFile',
      tJson2PumlParameterFileDefinition, ParseParameterFile, false);
  end;
end;

procedure TJson2PumlInputHandler.ParseConfigurationFile;
begin
  if not GlobalConfiguration.ReadFromJson (ConfigurationFileLines.Text, CurrentConfigurationFileName) then
    if not ConfigurationFileLines.Text.IsEmpty then
      GlobalLoghandler.Error ('Error parsing configuration file "%s".', [CurrentConfigurationFileName]);
end;

procedure TJson2PumlInputHandler.ParseDefintions;
begin
  if DefinitionLines.Count > 0 then
    if not ConverterDefinitionGroup.ReadFromJson (DefinitionLines.Text, CmdLineParameter.DefinitionFileName) then
      GlobalLoghandler.Error ('Error parsing definition file "%s".', [CmdLineParameter.DefinitionFileName]);

  OptionFileDefinition.ReadFromJson (OptionFileLines.Text, CmdLineParameter.OptionFileName);

  if not CurlParameterList.ReadFromJson (CurlParameterFileLines.Text, CmdLineParameter.CurlParameterFileName) then
    if not CurlParameterFileLines.Text.IsEmpty then
      GlobalLoghandler.Error ('Error parsing curl parameter file "%s".', [CmdLineParameter.CurlParameterFileName]);

  CalculateCurrentConverterDefinition;

  ParseInputListFile; // Behind Option and Definition Group to get the Option filled (needed for calculate output path)

  if not CurlAuthenticationList.ReadFromJson (CurlAuthenticationFileLines.Text, CurrentCurlAuthenticationFileName) then
    if not CurlAuthenticationFileLines.Text.IsEmpty then
      GlobalLoghandler.Error ('Error parsing curl authentication file "%s".', [CurrentCurlAuthenticationFileName]);

  CurlParameterList.AddParameter (CmdLineParameter.CurlParameter);
  CurlParameterList.AddParameter (ParameterDefinition.CurlParameter);
end;

procedure TJson2PumlInputHandler.ParseInputListFile;
begin
  if not ConverterInputList.ReadFromJson (InputListLines.Text, CmdLineParameter.InputListFileName) then
    if not InputListLines.Text.IsEmpty then
      GlobalLoghandler.Error ('Error parsing input list file "%s".', [CmdLineParameter.InputListFileName]);
end;

procedure TJson2PumlInputHandler.ParseParameterFile;
begin
  if not ParameterDefinition.ReadFromJson (ParameterFileLines.Text, CmdLineParameter.ParameterFileName) then
    if not ParameterFileLines.Text.IsEmpty then
      GlobalLoghandler.Error ('Error parsing parameter file "%s".', [CmdLineParameter.ParameterFileName]);
end;

procedure TJson2PumlInputHandler.RecreateAllRecords;
var
  ParameterInputFile: tJson2PumlParameterInputFileDefinition;
  Filename: string;
  Lines: TStrings;
begin
  ClearAllRecords;
  ParseDefintions;
  ConverterInputList.AddInputFile (CmdLineParameter.InputFileName, CmdLineParameter.InputFileName,
    CmdLineParameter.LeadingObject, CmdLineParameter.SplitInputFileStr, CmdLineParameter.SplitIdentifier, '', '', '', 0,
    '', true);
  for ParameterInputFile in ParameterDefinition.InputFiles do
  begin
    if ParameterInputFile.Filename.IsEmpty then
      Continue;
    if ParameterInputFile.Content.IsEmpty then
    begin
      Filename := ParameterInputFile.Filename;
      if not FileExists (ParameterInputFile.Filename) then
        Filename := PathCombineIfRelative (ExtractFilePath(CmdLineParameter.ParameterFileName), Filename);
      ConverterInputList.AddInputFile (Filename, Filename, ParameterInputFile.LeadingObject, '', '', '', '', '', 0,
        '', true);
    end
    else
    begin
      Filename := ParameterInputFile.Filename;
      Lines := TStringList.Create;
      try
        Lines.Text := ParameterInputFile.Content;
        if not IsRelativePath (ExtractFilePath(Filename)) then
          Filename := ExtractFileName (Filename);
        // Filename := GenerateCalculateOutputFilename (Filename, CurrentFullOutputPath, CurrentOutputSuffix, CurrentGroup,
        // CurrentOption, CurrentDetail, 'json', nil);
        Filename := CalculateOutputFileNamePath (Filename, jofJSON);
        GenerateFileDirectory (Filename);
        Lines.SaveToFile (Filename);
        ConverterInputList.AddInputFile (Filename, Filename, ParameterInputFile.LeadingObject, '', '', '', '', '', 0,
          '', true);
      finally
        Lines.Free;
      end;
    end;

  end;
  if not GlobalLoghandler.Failed then
    CreateAllRecords;
  if not GlobalLoghandler.Failed then
    ConvertAllRecordsInt;
end;

procedure TJson2PumlInputHandler.ReformatFile (iFileName: string; iClass: tJson2PumlBaseListClass);
var
  FileList: TStringList;
  Definition: tJson2PumlBaseList;
begin
  if not FileExists (iFileName) then
    Exit;
  FileList := TStringList.Create;
  Definition := iClass.Create;
  try
    FileList.LoadFromFile (iFileName);
    tFile.copy (iFileName, iFileName + '.bak', true);
    Definition.ReadFromJson (FileList.Text, Definition.SourceFileName);
    Definition.WriteToJsonFile (iFileName, true);
  finally
    FileList.Free;
    Definition.Free;
  end;
end;

procedure TJson2PumlInputHandler.ReformatFile (iFileName: string; iClass: tJson2PumlBaseObjectClass);
var
  FileList: TStringList;
  Definition: tJson2PumlBaseObject;
begin
  if not FileExists (iFileName) then
    Exit;
  FileList := TStringList.Create;
  Definition := iClass.Create;
  try
    FileList.LoadFromFile (iFileName);
    tFile.copy (iFileName, iFileName + '.bak', true);
    Definition.ReadFromJson (FileList.Text, Definition.SourceFileName);
    Definition.WriteToJsonFile (iFileName, true);
  finally
    FileList.Free;
    Definition.Free;
  end;
end;

function TJson2PumlInputHandler.ReplaceFileNameVariables (iReplace, iFileName, iOption: string): string;
begin
  Result := iReplace.replace (jfnrGroup.ToString, CurrentGroup, [rfIgnoreCase, rfReplaceAll])
    .replace (jfnrOption.ToString, iOption, [rfIgnoreCase, rfReplaceAll]).replace (jfnrDetail.ToString, CurrentDetail,
    [rfIgnoreCase, rfReplaceAll]).replace (jfnrFile.ToString, tpath.GetFileNameWithoutExtension(iFileName),
    [rfIgnoreCase, rfReplaceAll]).replace (jfnrJob.ToString, CurrentJobName, [rfIgnoreCase, rfReplaceAll]);
  while Result.IndexOf (tpath.DirectorySeparatorChar + tpath.DirectorySeparatorChar) >= 0 do
    Result := Result.replace (tpath.DirectorySeparatorChar + tpath.DirectorySeparatorChar,
      tpath.DirectorySeparatorChar);
  while Result.IndexOf (tpath.ExtensionSeparatorChar + tpath.ExtensionSeparatorChar) >= 0 do
    Result := Result.replace (tpath.ExtensionSeparatorChar + tpath.ExtensionSeparatorChar,
      tpath.ExtensionSeparatorChar);
  Result := Result.TrimRight (tpath.DirectorySeparatorChar);
end;

procedure TJson2PumlInputHandler.SetConverting (Converting: Boolean);
begin
  if not Converting then
    RecreateAllRecords;
end;

function TJson2PumlInputHandler.ValidateCurrentOptions: Boolean;

  procedure log (iName, iValue: string);
  begin
    GlobalLoghandler.InfoParameter ('', iName, iValue);
  end;

var
  InputFile: tJson2PumlInputFileDefinition;
  CurlParameter: tJson2PumlCurlParameterDefinition;
begin
  Result := true;
  GlobalLoghandler.Info ('');
  GlobalLoghandler.Info ('Current Configuration');
  log ('Option', CurrentOption);
  log ('Group', CurrentGroup);
  log ('Detail', CurrentDetail);
  log ('OutputPath', CurrentOutputPath);
  log ('OutputSuffix', CurrentOutputSuffix);
  log ('OutputFormats', GetCurrentOutputFormats(CurrentConverterDefinition).ToString(false));
  log ('GenerateSummary', BooleanToString(CurrentGenerateSummary));
  log ('GenerateDetails', BooleanToString(CurrentGenerateDetails));
  log ('BaseOutputPath', BaseOutputPath);
  log ('FullOutputPath', CurrentFullOutputPath);
  GlobalLoghandler.Info ('Input Files');
  for InputFile in ConverterInputList do
    if InputFile.GenerateOutput and not InputFile.IsSummaryFile then
      GlobalLoghandler.Info ('  %s', [InputFile.OutputFileName]);
  GlobalLoghandler.Info ('Curl Parameter');
  for CurlParameter in CurlParameterList do
    log (CurlParameter.name, CurlParameter.Value);
  GlobalLoghandler.Info ('');
end;

procedure TJson2PumlInputHandler.GenerateSummaryZipFile;
begin
  ConverterInputList.GenerateSummaryZipFile (CalculateZipFileName);
end;

end.
