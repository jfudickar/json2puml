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

unit json2pumltools;

interface

uses
  System.Classes, System.SysUtils, json2pumldefinition, json2pumlloghandler, json2pumlconst, System.Zip,
  json2pumlinputhandler, json2pumlbasedefinition;

procedure AddFileToZipFile (iZipFile: tZipFile; iFileName, iRemoveDirectory: string);

function ApplicationCompileVersion: string;

function ConvertFileToBase64 (iFileName: string): string;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string): boolean; overload;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string;
  oCommandOutPut, oCommandErrors: tStringList): boolean; overload;

function FileContent (iFileName: string): string;

function FileCount (iFileFilter: string): integer;

function FileDescription: string;

function FileExistsMinSize (iFileName: string): boolean;

function FileNameWithSuffix (iFileName, iFileNameSuffix: string): string;

function FileVersion: string;

procedure GenerateDirectory (const iDirectory: string);

procedure GenerateFileDirectory (iFileName: string);

function GenerateOutputFromPumlFiles (iPlantUmlFiles: tStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iFormat: tJson2PumlOutputFormat; iOpenAfter: boolean): boolean;
function GenerateOutputsFromPumlFiles (iPlantUmlFiles: tStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats;
  iOnNotifyChange: tJson2PumlNotifyChangeEvent): boolean;
function GenerateOutputFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter, iPlantUmlRuntimeParameter
  : string; iFormat: tJson2PumlOutputFormat; iOpenAfter: boolean): boolean;
function GenerateOutputsFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): boolean;

function GetPlantUmlVersion (iPlantUmlJarFile, iJavaRuntimeParameter: string): string;

function GetJavaVersion: string;

function GetServiceFileListResponse (oJsonOutPut: tStrings; iFolderList: tStringList; iInputList: boolean): integer;
procedure GetServiceInformationResponse (oJsonOutPut: tStrings; iInputHandler: TJson2PumlInputHandler;
  iServerInformation: string = '');
procedure GetServiceErrorMessageResponse (oJsonOutPut: tStrings);

function GetVersionInfo (AIdent: string): string;

function IsLinuxHomeBasedPath (iPath: string): boolean;

function IsRelativePath (iPath: string): boolean;

function LegalCopyright: string;

procedure OpenFile (iFileName: string);

function PathCombine (const Path1, Path2: string): string;

function PathCombineIfRelative (iBasePath, iPath: string): string;

function ProductVersion: string;

function ReplaceInvalidFileNameChars (const iFileName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;

function ReplaceInvalidPathChars (const iPathName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;

function ReplaceInvalidPathFileNameChars (const iFileName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;

function ValidateOutputSuffix (iOutputSuffix: string): string;

function CurrentThreadId: tThreadId;

function VarRecToString (const iVarRec: TVarRec): string;

function LogIndent (iIndent: integer): string;

function ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (iValue: string): string;

type
  TCurlUtils = class
  private
    class function CalculateCommandExecute (const iCurlCommand, iBaseUrl: string;
      const iUrlParts, iOptions: array of string; const iOutputFile: string;
      iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: boolean): string;
    class function CalculateOutputParameter (const iOutput: string): string;
    class function CalculateParameter (const iParameterName, iParameterValue: string; iQuoteValue: boolean): string;
    class function CalculateUrlParameter (const iUrl: string): string;
    class function CalculateWriteOutParameter (const iWriteout: string): string;
    class function CurlCommand (const iCurlCommand: string): string;
  public
    class function CalculateCommand (const iCurlCommand, iBaseUrl: string; const iUrlParts, iOptions: array of string;
      const iOutputFile: string; iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: boolean): string;
    class function CalculateHeaderParameter (const iHeaderName: string; iHeaderValue: string): string;
    class function CalculateUrl (const iBaseUrl: string; const iUrlParts: array of string;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): string;
    class function ReplaceCurlParameterValues (const iValue: string;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: boolean): string; overload;
    class function CalculateUserAgentParameter (const iUserAgent: string): string;
    class function CheckEvaluation (iExecuteEvaluation: string): boolean;
    class function CheckExecuteEvaluation (const iOutputFile: string; iExecuteEvaluation: string;
      iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): boolean;
    class function CleanUnusedCurlVariables (iValue: string): string;
    class function CombineParameter (iParameter: array of string): string;
    class function Execute (const iCurlCommand, iBaseUrl: string; const iUrlParts, iOptions: array of string;
      const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
      iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCurlCache: integer;
      iCurlResult: tJson2PumlCurlResult): boolean;
    class function GetCurlVersion (iCurlCommand: string): string;
    class function GetResultFromOutput (iOutputFileName: string; iCommandOutput: tStringList;
      var oErrorMessage: string): boolean;
    class function ReplaceCurlParameterValues (const iValue: string; iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: boolean): string; overload;
    class function ReplaceCurlVariablesFromEnvironment (iValue: string): string;
  end;

function GenerateFileNameContentBinary (iFileName: string): string;

procedure WriteToJsonFileNameContent (oJsonOutPut: tStrings; const iPropertyName: string; iLevel: integer;
  iFileName: string; iIncludeFullFilename, iBinaryContent: boolean; iWriteEmpty: boolean = false);

implementation

uses
{$IFDEF MSWINDOWS} Winapi.Windows, Winapi.ShellAPI, VCL.Forms, {$ENDIF}
  System.Generics.Collections, System.IOUtils, System.Math, System.DateUtils, System.NetEncoding,
  json2pumlconverterdefinition, System.Bindings.ExpressionDefaults, System.Bindings.Expression, jsontools,
  commandlinetools, System.Variants, System.Rtti;

function ApplicationCompileVersion: string;
begin
{$IFDEF WIN64}
  Result := 'Windows 64Bit';
{$ENDIF}
{$IFDEF WIN32}
  Result := 'Windows 32Bit';
{$ENDIF}
{$IFDEF LINUX64}
  Result := 'Linux 64Bit';
{$ENDIF}
{$IFDEF CPUX64}
  Result := Result + ' x86';
{$ELSEIF CPUARM}
  Result := Result + ' ARM';
{$ENDIF}
{$IFDEF DEBUG}
  Result := Result + ' Debug';
{$ENDIF}
end;

procedure AddFileToZipFile (iZipFile: tZipFile; iFileName, iRemoveDirectory: string);
begin
  if FileExists (iFileName) then
    iZipFile.Add (iFileName, iFileName.replace(iRemoveDirectory, '').TrimLeft(tPath.DirectorySeparatorChar));
end;

function ConvertFileToBase64 (iFileName: string): string;
var
  MemStream: tMemoryStream;
  Base64: tBase64Encoding;
begin
  MemStream := tMemoryStream.Create;
  Base64 := tBase64Encoding.Create (0);
  try
    MemStream.LoadFromFile (iFileName);
    Result := Base64.EncodeBytesToString (MemStream.Memory, MemStream.size);
  finally
    MemStream.Free;
    Base64.Free;
  end;
end;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string): boolean;
var
  vCommandOutPut, vCommandErrors: tStringList;
begin
  vCommandOutPut := tStringList.Create;
  vCommandErrors := tStringList.Create;
  try
    Result := ExecuteCommand (iCommand, iCommandType, iCommandInfo, vCommandOutPut, vCommandErrors);
  finally
    vCommandOutPut.Free;
    vCommandErrors.Free;
  end;
end;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string;
  oCommandOutPut, oCommandErrors: tStringList): boolean;

  procedure LogOutputLines (iInfo: string; iOutputLines: tStringList);
  var
    lines: tStringList;
    line: string;
    OutPut: string;
  begin
    if iOutputLines.Count <= 0 then
      Exit;
    GlobalLogHandler.Info ('  %s', [iInfo]);
    lines := tStringList.Create;
    try
      for OutPut in iOutputLines do
      begin
        lines.Text := OutPut;
        for line in lines do
          GlobalLogHandler.Info ('    %s', [line]);
      end;
    finally
      lines.Free;
    end;
  end;

begin
  oCommandOutPut.Clear;
  oCommandErrors.Clear;
  if not iCommandType.IsEmpty then
    GlobalLogHandler.Info ('%s : Execute %s', [iCommandType, iCommandInfo])
  else
    GlobalLogHandler.Info ('Execute %s', [iCommandInfo]);
  Result := RunCommandLine (iCommand, oCommandOutPut, oCommandErrors);
  LogOutputLines ('StdOut', oCommandOutPut);
  LogOutputLines ('ErrOut', oCommandErrors);

end;

{$WARN SYMBOL_PLATFORM OFF}

function FileAttributesStr (iFileAttributes: tFileAttributes): string;
var
  a: tFileAttribute;
begin
  Result := '';
  for a := low(tFileAttribute) to high(tFileAttribute) do
  begin
    case a of
{$IFDEF MSWINDOWS}
      tFileAttribute.faReadOnly:
        Result := Result + ', ' + 'faReadOnly';
      tFileAttribute.faHidden:
        Result := Result + ', ' + 'faHidden';
      tFileAttribute.faSystem:
        Result := Result + ', ' + 'faSystem';
      tFileAttribute.faDirectory:
        Result := Result + ', ' + 'faDirectory';
      tFileAttribute.faArchive:
        Result := Result + ', ' + 'faArchive';
      tFileAttribute.faDevice:
        Result := Result + ', ' + 'faDevice';
      tFileAttribute.faNormal:
        Result := Result + ', ' + 'faNormal';
      tFileAttribute.faTemporary:
        Result := Result + ', ' + 'faTemporary';
      tFileAttribute.faSparseFile:
        Result := Result + ', ' + 'faSparseFile';
      tFileAttribute.faReparsePoint:
        Result := Result + ', ' + 'faReparsePoint';
      tFileAttribute.faCompressed:
        Result := Result + ', ' + 'faCompressed';
      tFileAttribute.faOffline:
        Result := Result + ', ' + 'faOffline';
      tFileAttribute.faNotContentIndexed:
        Result := Result + ', ' + 'faNotContentIndexed';
      tFileAttribute.faEncrypted:
        Result := Result + ', ' + 'faEncrypted';
      tFileAttribute.faSymLink:
        Result := Result + ', ' + 'faSymLink';
{$ELSE}
      tFileAttribute.faNamedPipe:
        Result := Result + ', ' + 'faNamedPipe';
      tFileAttribute.faCharacterDevice:
        Result := Result + ', ' + 'faCharacterDevice';
      tFileAttribute.faDirectory:
        Result := Result + ', ' + 'faDirectory';
      tFileAttribute.faBlockDevice:
        Result := Result + ', ' + 'faBlockDevice';
      tFileAttribute.faNormal:
        Result := Result + ', ' + 'faNormal';
      tFileAttribute.faSymLink:
        Result := Result + ', ' + 'faSymLink';
      tFileAttribute.faSocket:
        Result := Result + ', ' + 'faSocket';
      tFileAttribute.faWhiteout:
        Result := Result + ', ' + 'faWhiteout';
      tFileAttribute.faOwnerRead:
        Result := Result + ', ' + 'faOwnerRead';
      tFileAttribute.faOwnerWrite:
        Result := Result + ', ' + 'faOwnerWrite';
      tFileAttribute.faOwnerExecute:
        Result := Result + ', ' + 'faOwnerExecute';
      tFileAttribute.faGroupRead:
        Result := Result + ', ' + 'faGroupRead';
      tFileAttribute.faGroupWrite:
        Result := Result + ', ' + 'faGroupWrite';
      tFileAttribute.faGroupExecute:
        Result := Result + ', ' + 'faGroupExecute';
      tFileAttribute.faOthersRead:
        Result := Result + ', ' + 'faOthersRead';
      tFileAttribute.faOthersWrite:
        Result := Result + ', ' + 'faOthersWrite';
      tFileAttribute.faOthersExecute:
        Result := Result + ', ' + 'faOthersExecute';
      tFileAttribute.faUserIDExecution:
        Result := Result + ', ' + 'faUserIDExecution';
      tFileAttribute.faGroupIDExecution:
        Result := Result + ', ' + 'faGroupIDExecution';
      tFileAttribute.faStickyBit:
        Result := Result + ', ' + 'faStickyBit';

{$ENDIF}
    end;
  end;
  Result := Result.TrimLeft ([',', ' ']);
end;
{$WARN SYMBOL_PLATFORM ON}

function FileContent (iFileName: string): string;
var
  lines: tStringList;
begin
  Result := '';
  if not FileExists (iFileName) then
    Exit;
  lines := tStringList.Create;
  try
    lines.LoadFromFile (iFileName);
    Result := lines.Text;
  finally
    lines.Free;
  end;
end;

function FileCount (iFileFilter: string): integer;
var
  c: integer;
  searchResult: tSearchRec;
begin
  if iFileFilter.IsEmpty then
    Result := 0
  else
  begin
    c := 0;
    if findfirst (iFileFilter, faAnyFile, searchResult) = 0 then
    begin
      repeat
        Inc (c);
      until FindNext (searchResult) <> 0;
      System.SysUtils.FindClose (searchResult);
    end;
    Result := c;
  end;
end;

function FileDescription: string;
begin
  Result := GetVersionInfo ('FileDescription');
end;

function FileVersion: string;
begin
{$IFDEF MSWINDOWS}
  Result := 'v' + GetVersionInfo ('FileVersion');
{$ELSE}
  Result := 'v' + cCurrentVersion;
{$ENDIF}
end;

procedure GenerateDirectory (const iDirectory: string);
begin
  if not TDirectory.Exists (iDirectory) then
    try
      if not ForceDirectories (iDirectory) then
        GlobalLogHandler.Error (jetDirectoryCouldNotBeCreated, [iDirectory]);
    except
      on e: exception do
        GlobalLogHandler.Error (jetDirectoryDeletionFailed, [iDirectory, e.Message]);
    end;
end;

procedure GenerateFileDirectory (iFileName: string);
begin
  GenerateDirectory (ExtractFilePath(iFileName));
end;

function GenerateOutputFromPumlFiles (iPlantUmlFiles: tStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iFormat: tJson2PumlOutputFormat; iOpenAfter: boolean): boolean;
var
  Command: string;
  DestinationFile: string;
  PumlFile: string;
  FileList: string;
begin
  Result := false;
  if not iFormat.IsPumlOutput then
    Exit;
  if iPlantUmlJarFile.IsEmpty then
    Exit;
  if not FileExists (iPlantUmlJarFile) then
  begin
    GlobalLogHandler.Error (jetPlantUmlFileNotFound, [iPlantUmlJarFile]);
    Exit;
  end;
  FileList := '';
  for PumlFile in iPlantUmlFiles do
  begin
    if not FileExists (PumlFile) then
      Continue;
    DestinationFile := iFormat.FileName (PumlFile);

    if FileExists (DestinationFile) then
      tFile.Delete (DestinationFile);

    FileList := FileList.Join (' ', [FileList, Format('"%s"', [PumlFile])]);
  end;
  if FileList.IsEmpty then
    Exit;

  Command := Format ('java %s -jar "%s" %s %s %s', [iJavaRuntimeParameter.Trim, iPlantUmlJarFile, FileList,
    iFormat.PumlGenerateFlag, iPlantUmlRuntimeParameter]).Trim;

  Result := ExecuteCommand (Command, 'Generate ' + iFormat.ToString, Command);
  if Result then
  begin
    Result := false;
    for PumlFile in iPlantUmlFiles do
    begin
      if not FileExists (PumlFile) then
        Continue;
      DestinationFile := iFormat.FileName (PumlFile);
      if FileExistsMinSize (DestinationFile) then
      begin
        Result := true;
        if iOpenAfter then
          OpenFile (DestinationFile);
      end
      else
        GlobalLogHandler.Error (jetPlantUmlResultGenerationFailed, [iFormat.ToString, PumlFile]);
    end;
  end;
  // if Result then
  // GlobalLoghandler.Info ('               %-4s generated', [iFormat.toString]);
end;

function GenerateOutputsFromPumlFiles (iPlantUmlFiles: tStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats;
  iOnNotifyChange: tJson2PumlNotifyChangeEvent): boolean;
var
  f: tJson2PumlOutputFormat;
  p, c: integer;

begin
  Result := true;
  c := 0;
  p := 0;
  for f in iOutputFormats do
    if f.IsPumlOutput then
      Inc (c);
  for f in iOutputFormats do
    if f.IsPumlOutput then
    begin
      Inc (p);
      if Assigned (iOnNotifyChange) then
        iOnNotifyChange (nil, nctGenerate, p, c);
      Result := Result and GenerateOutputFromPumlFiles (iPlantUmlFiles, iPlantUmlJarFile, iJavaRuntimeParameter,
        iPlantUmlRuntimeParameter, f, f in iOpenOutputs);
    end;
end;

function GenerateOutputFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter, iPlantUmlRuntimeParameter
  : string; iFormat: tJson2PumlOutputFormat; iOpenAfter: boolean): boolean;
var
  Command: string;
  DestinationFile: string;
begin
  Result := false;
  if not FileExists (iPlantUmlFile) then
    Exit;
  if not iFormat.IsPumlOutput then
    Exit;
  if iPlantUmlJarFile.IsEmpty then
    Exit;
  if not FileExists (iPlantUmlJarFile) then
  begin
    GlobalLogHandler.Error (jetPlantUmlFileNotFound, [iPlantUmlJarFile]);
    Exit;
  end;
  DestinationFile := iFormat.FileName (iPlantUmlFile);

  if FileExists (DestinationFile) then
    tFile.Delete (DestinationFile);

  Command := Format ('java %s -jar "%s" "%s" %s %s', [iJavaRuntimeParameter.Trim, iPlantUmlJarFile, iPlantUmlFile,
    iFormat.PumlGenerateFlag, iPlantUmlRuntimeParameter]).Trim;

  Result := ExecuteCommand (Command, 'Generate ' + iFormat.ToString, Command);
  if Result then
  begin
    Result := FileExistsMinSize (DestinationFile);
    if Result then
    begin
      // GlobalLoghandler.Info ('               %-4s generated', [iFormat.toString]);
      if iOpenAfter then
        OpenFile (DestinationFile);
    end;
  end;
  if not Result then
    GlobalLogHandler.Error (jetPlantUmlResultGenerationFailed, [iFormat.ToString, iPlantUmlFile]);
end;

function GenerateOutputsFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): boolean;
var
  f: tJson2PumlOutputFormat;
begin
  Result := true;
  for f in iOutputFormats do
    if f.IsPumlOutput then
      Result := Result and GenerateOutputFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter,
        iPlantUmlRuntimeParameter, f, f in iOpenOutputs);
end;

function GetPlantUmlVersion (iPlantUmlJarFile, iJavaRuntimeParameter: string): string;
var
  Command: string;
  vCommandOutPut, vCommandErrors: tStringList;
begin
  if iPlantUmlJarFile.IsEmpty then
    Result := 'PlantUml jar file not defined'
  else if not FileExists (iPlantUmlJarFile) then
    Result := Format ('defined PlantUml jar file (%s) not existing', [iPlantUmlJarFile])
  else
  begin
    vCommandOutPut := tStringList.Create;
    vCommandErrors := tStringList.Create;
    try
      Command := Format ('java %s -jar "%s" -version', [iJavaRuntimeParameter.Trim, iPlantUmlJarFile.Trim]);
      ExecuteCommand (Command, 'get plantuml version', Command, vCommandOutPut, vCommandErrors);
      Result := vCommandOutPut.Text;
      if Result.IsEmpty then
        Result := vCommandErrors.Text;
      if Result.IsEmpty then
        Result := 'Fetching PlantUml informations failed';
    finally
      vCommandOutPut.Free;
      vCommandErrors.Free;
    end;
  end;

end;

function GetServiceFileListResponse (oJsonOutPut: tStrings; iFolderList: tStringList; iInputList: boolean): integer;
var
  s: string;
  FileList: tStringList;
  ConfigFile: tJson2PumlBaseObject;
begin
  Result := 0;
  oJsonOutPut.Clear;
  FileList := tStringList.Create;
  try
    GlobalConfigurationDefinition.FindFilesInFolderList (FileList, iFolderList);
    WriteArrayStartToJson (oJsonOutPut, 0, '');
    for s in FileList do
    begin
      if iInputList then
        ConfigFile := tJson2PumlInputList.Create
      else
        ConfigFile := tJson2PumlConverterGroupDefinition.Create;
      try
        ConfigFile.ReadFromJsonFile (s);
        if ConfigFile.IsValid then
        begin
          if iInputList then
            tJson2PumlInputList (ConfigFile).WriteToJsonServiceListResult (oJsonOutPut, '', 1, false)
          else
            tJson2PumlConverterGroupDefinition (ConfigFile).WriteToJsonServiceListResult (oJsonOutPut, '', 1, false);
          Inc (Result);
        end;
      finally
        ConfigFile.Free;
      end;
    end;
    WriteArrayEndToJson (oJsonOutPut, 0);
  finally
    FileList.Free;
  end;
end;

{$IFDEF MSWINDOWS}

function GetVersionInfo (AIdent: string): string;

type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;

  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: string;
  RM: tMemoryStream;
  RS: tResourceStream;
  BP: pChar;
  BL: Cardinal;
  BId: string;

begin
  // Assume error
  Result := '';

  RM := tMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := tResourceStream.CreateFromID (HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom (RS, RS.size);
    finally
      FreeAndNil (RS);
    end;

    // Extract the translations list
    if not VerQueryValue (RM.Memory, '\\VarFileInfo\\Translation', pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div SizeOf (TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex (Lng, 4) + IntToHex (Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + AIdent;
    if not VerQueryValue (RM.Memory, pChar(BId), pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil (RM);
  end;
end;
{$ELSE}

function GetVersionInfo (AIdent: string): string;
begin
  Result := '';
end;
{$ENDIF}

function IsLinuxHomeBasedPath (iPath: string): boolean;
begin
{$IFDEF LINUX}
  Result := iPath.StartsWith (cLinuxHome);
{$ELSE}
  Result := false;
{$ENDIF}
end;

function IsRelativePath (iPath: string): boolean;
begin
  if IsLinuxHomeBasedPath (iPath) then
    Result := false
  else
    Result := tPath.IsRelativePath (iPath);
end;

function LegalCopyright: string;
begin
  Result := GetVersionInfo ('LegalCopyright');
end;

{$IFDEF MSWINDOWS}

procedure OpenFile (iFileName: string);
begin
  if FileExists (iFileName) then
    ShellExecute (0, nil, pChar(iFileName), nil, nil, SW_RESTORE);
end;
{$ELSE}

procedure OpenFile (iFileName: string);
begin
end;
{$ENDIF}

function PathCombine (const Path1, Path2: string): string;
begin
  if not Path1.IsEmpty then
    Result := Path1.TrimRight (tPath.DirectorySeparatorChar) + tPath.DirectorySeparatorChar
  else
    Result := '';
  Result := Result + Path2.TrimLeft (tPath.DirectorySeparatorChar);
  Result := Result.TrimRight (tPath.DirectorySeparatorChar);
end;

function PathCombineIfRelative (iBasePath, iPath: string): string;
begin
  if IsLinuxHomeBasedPath (iPath) then
    Result := ExpandFileName (iPath)
  else if tPath.IsRelativePath (iPath) then
    Result := PathCombine (iBasePath, iPath)
  else
    Result := iPath;
end;

function ProductVersion: string;
begin
  Result := 'v' + GetVersionInfo ('ProductVersion');
end;

function ReplaceInvalidFileNameChars (const iFileName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;
var
  i: integer;
begin
  Result := iFileName.Trim;
  for i := low(Result) to high(Result) do
    if not tPath.IsValidFileNameChar (Result[i]) or (iFinal and (CharInSet(Result[i], ['$']))) then
      Result[i] := iReplaceWith;
  while Result.IndexOf (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar) >= 0 do
    Result := Result.replace (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar,
      tPath.ExtensionSeparatorChar);
  while Result.IndexOf (iReplaceWith + iReplaceWith) >= 0 do
    Result := Result.replace (iReplaceWith + iReplaceWith, tPath.ExtensionSeparatorChar);
end;

function ReplaceInvalidPathFileNameChars (const iFileName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;
var
  Path: string;
begin
  Path := ExtractFilePath (iFileName).Trim;
  Result := ExtractFileName (iFileName).Trim;
  Path := ReplaceInvalidPathChars (Path, iFinal, iReplaceWith);
  Result := ReplaceInvalidFileNameChars (Result, iFinal, iReplaceWith);
  Result := tPath.Combine (Path, Result);
end;

function ReplaceInvalidPathChars (const iPathName: string; iFinal: boolean = false;
  const iReplaceWith: Char = '_'): string;
var
  i: integer;
  LastVolumeSeparatorChar: integer;
begin
  Result := iPathName.Trim;
  LastVolumeSeparatorChar := low(Result);
  if tPath.IsDriveRooted (iPathName) then
    LastVolumeSeparatorChar := LastVolumeSeparatorChar + 2;
  for i := low(Result) to high(Result) do
    if not tPath.IsValidPathChar (Result[i]) or (iFinal and (CharInSet(Result[i], ['$']))) or
      ((i >= LastVolumeSeparatorChar) and (Result[i] = tPath.VolumeSeparatorChar)) then
      Result[i] := iReplaceWith;
  while Result.IndexOf (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar) >= 0 do
    Result := Result.replace (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar,
      tPath.ExtensionSeparatorChar);
end;

function ValidateOutputSuffix (iOutputSuffix: string): string;
begin
  Result := iOutputSuffix.Trim;
  if not Result.IsEmpty then
    if CharInSet (Result[1], ['_', '-', '.']) then
      if Result.Substring (1).Trim.IsEmpty then
        Result := ''
      else
    else
      Result := '.' + Result;
end;

function CurrentThreadId: tThreadId;
begin
{$IFDEF MSWINDOWS}
  Result := GetCurrentThreadId;
{$ELSE}
  Result := TThread.CurrentThread.ThreadID;
{$ENDIF}
end;

function FileExistsMinSize (iFileName: string): boolean;
var
  Reader: tFileStream;
begin
  Result := FileExists (iFileName);
  if Result then
    try
      Reader := tFile.OpenRead (iFileName);
      try
        Result := Reader.size >= cMinFileSize;
      finally
        Reader.Free;
      end;
    except
      on e: exception do
        Result := false;
    end;
end;

function FileNameWithSuffix (iFileName, iFileNameSuffix: string): string;
var
  Extension: string;
begin
  if iFileNameSuffix.IsEmpty then
  begin
    Result := iFileName;
    Exit;
  end;
  Extension := tPath.GetExtension (iFileName);
  Result := tPath.Combine (tPath.GetDirectoryName(iFileName), tPath.GetFileNameWithoutExtension(iFileName));
  Result := Result + iFileNameSuffix + Extension;
end;

function LogIndent (iIndent: integer): string;
begin
  Result := '';
  Result := Result.PadRight (iIndent * 2, ' ');
end;

function ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (iValue: string): string;
begin
  Result := TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue);
  Result := GlobalConfigurationDefinition.CurlParameter.ReplaceParameterValues (Result);
end;

function GenerateFileNameContentBinary (iFileName: string): string;
var
  sl: tStringList;
begin
  sl := tStringList.Create;
  try
    WriteToJsonFileNameContent (sl, '', 0, iFileName, false, true);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

procedure WriteToJsonFileNameContent (oJsonOutPut: tStrings; const iPropertyName: string; iLevel: integer;
  iFileName: string; iIncludeFullFilename, iBinaryContent: boolean; iWriteEmpty: boolean = false);
begin
  if iFileName.IsEmpty then
    Exit;
  if not FileExists (iFileName) then
    Exit;
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'outputFileName', ExtractFileName(iFileName), iLevel + 1, iWriteEmpty);
  if iIncludeFullFilename then
    WriteToJsonValue (oJsonOutPut, 'fullFileName', iFileName, iLevel + 1, iWriteEmpty);
  if iBinaryContent then
    WriteToJsonValue (oJsonOutPut, 'content', ConvertFileToBase64(iFileName), iLevel + 1, iWriteEmpty)
  else
    WriteToJsonValue (oJsonOutPut, 'content', FileContent(iFileName), iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

function GetJavaVersion: string;
var
  Command: string;
  vCommandOutPut, vCommandErrors: tStringList;
begin
  vCommandOutPut := tStringList.Create;
  vCommandErrors := tStringList.Create;
  try
    Command := 'java -version';
    ExecuteCommand (Command, 'get java version', Command, vCommandOutPut, vCommandErrors);
    Result := vCommandOutPut.Text;
    if Result.IsEmpty then
      Result := vCommandErrors.Text;
    if Result.IsEmpty then
      Result := 'Fetching Java informations failed';
  finally
    vCommandOutPut.Free;
    vCommandErrors.Free;
  end;

end;

procedure GetServiceInformationResponse (oJsonOutPut: tStrings; iInputHandler: TJson2PumlInputHandler;
  iServerInformation: string = '');
var
  InfoList: tStringList;
begin
  oJsonOutPut.Clear;
  InfoList := tStringList.Create;
  try
    WriteObjectStartToJson (oJsonOutPut, 0, '');
    if not iServerInformation.IsEmpty then
      WriteToJsonValue (oJsonOutPut, 'service', iServerInformation, 1, true);
    InfoList.Text := ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration
      (iInputHandler.GlobalConfiguration.AdditionalServiceInformation.replace('\n', #13#10));
    WriteToJsonValue (oJsonOutPut, 'additionalServiceInformation', InfoList, 1, false, false);
    WriteToJsonValue (oJsonOutPut, 'commandLine', iInputHandler.CmdLineParameter.CommandLineParameterStr(true),
      1, false);
    iInputHandler.CmdLineParameter.GenerateLogParameters (InfoList);
    WriteToJsonValue (oJsonOutPut, 'commandLineParameter', InfoList, 1, false, false);
    iInputHandler.CmdLineParameter.GenerateEnvironmentParameters (InfoList);
    WriteToJsonValue (oJsonOutPut, 'environmentParameter', InfoList, 1, false, false);
    InfoList.Text := GetJavaVersion;
    WriteToJsonValue (oJsonOutPut, 'javaInformation', InfoList, 1, false, false);
    InfoList.Text := GetPlantUmlVersion (iInputHandler.CalculateRuntimeJarFile,
      iInputHandler.CurrentJavaRuntimeParameter);
    WriteToJsonValue (oJsonOutPut, 'plantUmlInformation', InfoList, 1, false, false);
    InfoList.Text := TCurlUtils.GetCurlVersion (GlobalConfigurationDefinition.CurlCommand);
    WriteToJsonValue (oJsonOutPut, 'curlInformation', InfoList, 1, false, false);
    iInputHandler.GlobalConfiguration.GenerateLogConfiguration (InfoList);
    WriteToJsonValue (oJsonOutPut, 'globalConfiguration', InfoList, 1, false, false);

    iInputHandler.GlobalConfiguration.FindFilesInFolderList (InfoList,
      iInputHandler.GlobalConfiguration.DefinitionFileSearchFolder);
    WriteToJsonValue (oJsonOutPut, 'definitionFiles', InfoList, 1, false, false);
    iInputHandler.GlobalConfiguration.FindFilesInFolderList (InfoList,
      iInputHandler.GlobalConfiguration.InputListFileSearchFolder);
    WriteToJsonValue (oJsonOutPut, 'inputlistFiles', InfoList, 1, false, false);
    WriteObjectEndToJson (oJsonOutPut, 0);
  finally
    InfoList.Free;
  end;
end;

procedure GetServiceErrorMessageResponse (oJsonOutPut: tStrings);
var
  ErrorType: tJson2PumlErrorType;
begin
  oJsonOutPut.Clear;
  WriteArrayStartToJson (oJsonOutPut, 0, '');
  for ErrorType := low(tJson2PumlErrorType) to high(tJson2PumlErrorType) do
    ErrorType.RenderErrorResponse (oJsonOutPut, 1);
  WriteArrayEndToJson (oJsonOutPut, 0);
end;

function VarRecToString (const iVarRec: TVarRec): string;
begin
  // case iVarRec.VType of
  // vtInteger:
  // Result := IntToStr (iVarRec.VInteger);
  // vtBoolean:
  // Result := BoolToStr (iVarRec.VBoolean, true);
  // vtChar:
  // Result := iVarRec.VChar;
  // vtExtended:
  // Result := FloatToStr (iVarRec.VExtended^);
  // vtString:
  // Result := string(iVarRec.VString);
  // vtPChar:
  // Result := string(iVarRec.VPChar);
  // vtAnsiString:
  // Result := string(iVarRec.VAnsiString);
  // vtWideString:
  // Result := string(iVarRec.VWideString);
  // vtVariant:
  // Result := VarToStr (iVarRec.VVariant^);
  // else
  // Result := '';
  // end;
  Result := TValue.FromVarRec (iVarRec).ToString;
end;

class function TCurlUtils.CalculateCommand (const iCurlCommand, iBaseUrl: string;
  const iUrlParts, iOptions: array of string; const iOutputFile: string;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: boolean): string;
begin
  Result := CalculateCommandExecute (iCurlCommand, iBaseUrl, iUrlParts, iOptions, iOutputFile, nil, iCurlParameterList,
    iCurlDetailParameterList, iCurlMappingParameterList, iIncludeWriteOut);
end;

class function TCurlUtils.CalculateCommandExecute (const iCurlCommand, iBaseUrl: string;
  const iUrlParts, iOptions: array of string; const iOutputFile: string;
  iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: boolean): string;
var
  Command: string;
  Url: string;
begin

  Result := '';

  Url := CalculateUrl (iBaseUrl, iUrlParts, iCurlParameterList, iCurlDetailParameterList, iCurlMappingParameterList);
  if Url.IsEmpty then
    Exit;

  Command := CombineParameter ([CalculateUrlParameter(Url), CombineParameter(iOptions),
    CalculateOutputParameter(iOutputFile)]);
  if iIncludeWriteOut then
    Command := CombineParameter
      ([Command, CalculateWriteOutParameter
      ('\nHTTP Response:%{response_code}\nExit Code:%{exitcode}\nError Message:%{errormsg}')]);

  if Assigned (iCurlAuthenticationList) then
    Command := iCurlAuthenticationList.ReplaceParameterValues (iBaseUrl, Command);
  Command := ReplaceCurlParameterValues (Command, iCurlParameterList, iCurlDetailParameterList,
    iCurlMappingParameterList, true);

  if not Command.IsEmpty then
    Command := Format ('%s %s', [CurlCommand(iCurlCommand), Command]);

  Result := Command;
end;

class function TCurlUtils.CalculateHeaderParameter (const iHeaderName: string; iHeaderValue: string): string;
begin
  if iHeaderName.IsEmpty then
    Result := ''
  else
    Result := CalculateParameter ('header', Format('%s: %s', [iHeaderName, iHeaderValue]), true);
end;

class function TCurlUtils.CalculateOutputParameter (const iOutput: string): string;
begin
  if iOutput.IsEmpty then
    Result := ''
  else
    Result := CalculateParameter ('output', iOutput, true);
end;

class function TCurlUtils.CalculateParameter (const iParameterName, iParameterValue: string;
  iQuoteValue: boolean): string;
begin
  if iQuoteValue then
    Result := Format ('--%s "%s"', [iParameterName, iParameterValue])
  else
    Result := Format ('--%s %s', [iParameterName, iParameterValue]);
end;

class function TCurlUtils.CalculateUrl (const iBaseUrl: string; const iUrlParts: array of string;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): string;
var
  UrlParts: string;
begin
  UrlParts := string.Join ('', iUrlParts).Trim (['/']);
  if not UrlParts.IsEmpty then
    Result := string.Join ('/', [iBaseUrl.TrimRight(['/']), UrlParts])
  else
    Result := iBaseUrl;
  Result := ReplaceCurlParameterValues (Result, iCurlParameterList, iCurlDetailParameterList,
    iCurlMappingParameterList, true);
end;

class function TCurlUtils.ReplaceCurlParameterValues (const iValue: string;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: boolean): string;
var
  LocalCurlMappingParameterList: tJson2PumlCurlMappingParameterList;
  InputParameter: tJson2PumlCurlMappingParameterDefinition;

begin
  Result := iValue;
  if Assigned (iCurlMappingParameterList) and (iCurlMappingParameterList.Count > 0) then
  begin
    LocalCurlMappingParameterList := tJson2PumlCurlMappingParameterList.Create;
    try
      LocalCurlMappingParameterList.Assign (iCurlMappingParameterList);
      for InputParameter in LocalCurlMappingParameterList do
      begin
        if not InputParameter.IsValid then
          Continue;
        if Assigned (iCurlDetailParameterList) then
          InputParameter.Value := iCurlDetailParameterList.ReplaceParameterValues (InputParameter.Value);
        if Assigned (iCurlParameterList) then
          InputParameter.Value := iCurlParameterList.ReplaceParameterValues (InputParameter.Value);
      end;
      for InputParameter in LocalCurlMappingParameterList do
      begin
        if not InputParameter.IsValid then
          Continue;
        InputParameter.Value := LocalCurlMappingParameterList.ReplaceParameterValues (InputParameter.Value);
      end;
      Result := LocalCurlMappingParameterList.ReplaceParameterValues (Result);
    finally
      LocalCurlMappingParameterList.Free;
    end;
  end;
  if Assigned (iCurlDetailParameterList) then
    Result := iCurlDetailParameterList.ReplaceParameterValues (Result);
  if Assigned (iCurlParameterList) then
    Result := iCurlParameterList.ReplaceParameterValues (Result);
  Result := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Result);
  GlobalConfigurationDefinition.CurlParameter.ReplaceParameterValues (Result);
  if iCleanUnused then
    Result := TCurlUtils.CleanUnusedCurlVariables (Result);
end;

class function TCurlUtils.CalculateUrlParameter (const iUrl: string): string;
begin
  Result := CalculateParameter ('url', iUrl, true);
end;

class function TCurlUtils.CalculateUserAgentParameter (const iUserAgent: string): string;
begin
  if iUserAgent.IsEmpty then
    Result := ''
  else
    Result := CalculateParameter ('user-agent', iUserAgent, true);
end;

class function TCurlUtils.CalculateWriteOutParameter (const iWriteout: string): string;
begin
  if iWriteout.IsEmpty then
    Result := ''
  else
    Result := CalculateParameter ('write-out', iWriteout, true);
end;

class function TCurlUtils.CheckEvaluation (iExecuteEvaluation: string): boolean;
var
  BindExpr: tBindingExpressionDefault;
begin
  Result := true;
  if iExecuteEvaluation.Trim.IsEmpty then
    Exit;
  BindExpr := tBindingExpressionDefault.Create;
  try
    BindExpr.Source := iExecuteEvaluation;
    BindExpr.recompile;
    Result := BindExpr.Evaluate.GetValue.ToString.ToLower = 'true';
  finally
    BindExpr.Free;
  end;
end;

class function TCurlUtils.CheckExecuteEvaluation (const iOutputFile: string; iExecuteEvaluation: string;
  iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): boolean;
var
  ExecuteEvaluation: string;
begin
  Result := true;
  ExecuteEvaluation := ReplaceCurlParameterValues (iExecuteEvaluation, iCurlParameterList, iCurlDetailParameterList,
    iCurlMappingParameterList, true);
  try
    Result := CheckEvaluation (ExecuteEvaluation);
    if not Result then
      GlobalLogHandler.Info ('curl file %s skipped - validating curlExecuteEvaluation [%s]->[%s] not successful',
        [iOutputFile, iExecuteEvaluation, ExecuteEvaluation])
    else if not iExecuteEvaluation.Trim.IsEmpty then
      GlobalLogHandler.Debug ('curl file %s - validating curlExecuteEvaluation [%s]->[%s] successful',
        [iOutputFile, iExecuteEvaluation, ExecuteEvaluation]);
  except
    on e: exception do
      GlobalLogHandler.Error (jetCurlFileSkippedValidationException, [iOutputFile, e.Message, iExecuteEvaluation]);
  end;
end;

class function TCurlUtils.CleanUnusedCurlVariables (iValue: string): string;
var
  Value: string;
  s: string;
  i: integer;
begin
  s := iValue;
  Value := '';
  while not s.IsEmpty do
  begin
    i := s.IndexOf ('${');
    if i < 0 then
    begin
      Value := Value + s;
      Break;
    end;
    Value := Value + s.Substring (0, i);
    s := s.Substring (i);
    i := s.IndexOf ('}');
    if i < 0 then
    begin
      Value := Value + s;
      Break;
    end;
    s := s.Substring (i + 1);
  end;
  Result := Value;
end;

class function TCurlUtils.CombineParameter (iParameter: array of string): string;
begin
  Result := string.Join (' ', iParameter).Trim;
end;

class function TCurlUtils.CurlCommand (const iCurlCommand: string): string;
begin
  if iCurlCommand.Trim.IsEmpty then
    Result := 'curl'
  else
    Result := iCurlCommand.Trim;
end;

class function TCurlUtils.Execute (const iCurlCommand, iBaseUrl: string; const iUrlParts, iOptions: array of string;
  const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
  iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCurlCache: integer;
  iCurlResult: tJson2PumlCurlResult): boolean;
var
  Url: string;
  Command: string;
  FilePath: string;
  FileLastWriteDate: tDateTime;
  StartTime: tDateTime;
  vErrorMessage: string;
  vCommandOutPut, vCommandErrors: tStringList;
  vOutputFile: tStringList;
  s: string;

begin

  Result := false;
  iCurlResult.Clear;
  try
    if iOutputFile.Trim.IsEmpty then
      Exit;
    Url := CalculateUrl (iBaseUrl, iUrlParts, iCurlParameterList, iCurlDetailParameterList, iCurlMappingParameterList);
    if Url.Trim.IsEmpty then
    begin
      iCurlResult.ErrorMessage := Format (jetCurlFileSkippedUrlMissing.ErrorMessage, [iOutputFile]);
      GlobalLogHandler.Error (iCurlResult.ErrorMessage);
      Exit;
    end;
    iCurlResult.Url := Url;
    iCurlResult.OutPutFile := iOutputFile;

    iCurlResult.Command := CalculateCommand (iCurlCommand, iBaseUrl, iUrlParts, iOptions, iOutputFile,
      iCurlParameterList, iCurlDetailParameterList, iCurlMappingParameterList, true);
    if iCurlResult.Command.IsEmpty then
    begin
      iCurlResult.ErrorMessage := Format (jetCurlFileSkippedInvalidCurlCommand.ErrorMessage, [iOutputFile]);
      GlobalLogHandler.Error (iCurlResult.ErrorMessage);
      Exit;
    end;

    Command := CalculateCommandExecute (iCurlCommand, iBaseUrl, iUrlParts, iOptions, iOutputFile,
      iCurlAuthenticationList, iCurlParameterList, iCurlDetailParameterList, iCurlMappingParameterList, true);

    FilePath := tPath.GetDirectoryName (iOutputFile);
    if tPath.IsRelativePath (FilePath) or IsLinuxHomeBasedPath (FilePath) then
      FilePath := ExpandFileName (FilePath);
    GenerateDirectory (FilePath);

    if (iCurlCache > 0) and FileExists (iOutputFile) then
    begin
      FileLastWriteDate := tFile.GetLastWriteTime (iOutputFile);
      if Now - FileLastWriteDate < iCurlCache / (24 * 60 * 60) then
      begin
        GlobalLogHandler.Info (iCurlResult.Command);
        iCurlResult.NoOfRecords := GetJsonFileRecordCount (iOutputFile);
        iCurlResult.FileSize := tFile.GetSize (iOutputFile);
        iCurlResult.Duration := 0;
        GlobalLogHandler.Info ('  curl result %s reused - not older then %d seconds.  [%d Record(s) found]',
          [iOutputFile, iCurlCache, iCurlResult.NoOfRecords]);
        Result := true;
        Exit;
      end;
    end;

    if FileExists (iOutputFile) then
      tFile.Delete (iOutputFile);
    StartTime := Now;
    vCommandOutPut := tStringList.Create;
    vCommandErrors := tStringList.Create;
    try
      ExecuteCommand (Command, Format('curl fetch "%s"', [ExtractFileName(iOutputFile)]), iCurlResult.Command,
        vCommandOutPut, vCommandErrors);
      Result := GetResultFromOutput (iOutputFile, vCommandOutPut, vErrorMessage);
    finally
      vCommandOutPut.Free;
      vCommandErrors.Free;
    end;
    iCurlResult.Duration := MillisecondsBetween (Now, StartTime);

    if Result then
    begin
      iCurlResult.NoOfRecords := GetJsonFileRecordCount (iOutputFile);
      iCurlResult.FileSize := tFile.GetSize (iOutputFile);
      GlobalLogHandler.Info ('  curl "%s" fetched to "%s" (%d ms) [%d Record(s) found]',
        [Url, iOutputFile, iCurlResult.Duration, iCurlResult.NoOfRecords])
    end
    else
    begin
      GlobalLogHandler.Error (jetCurlExecutionFailed, [Url, tPath.GetFileName(iOutputFile),
        MillisecondsBetween(Now, StartTime), vErrorMessage]);
      iCurlResult.ErrorMessage := vErrorMessage;
      if FileExists (iOutputFile) then
      begin
        tFile.SetLastWriteTime (iOutputFile, Now - 10);
        vOutputFile := tStringList.Create;
        try
          vOutputFile.LoadFromFile (iOutputFile);
          if vOutputFile.Count > 0 then
            GlobalLogHandler.Debug ('curl result output (%s)', [iOutputFile]);
          for s in vOutputFile do
            GlobalLogHandler.Debug (s);
        finally
          vOutputFile.Free;
        end;
      end;
    end;
  finally
    iCurlResult.Generated := Result;
  end;
end;

class function TCurlUtils.GetCurlVersion (iCurlCommand: string): string;
var
  Command: string;
  vCommandOutPut, vCommandErrors: tStringList;
begin
  vCommandOutPut := tStringList.Create;
  vCommandErrors := tStringList.Create;
  try
    Command := Format ('%s --version', [CurlCommand(iCurlCommand)]);
    ExecuteCommand (Command, 'get curl version', Command, vCommandOutPut, vCommandErrors);
    Result := vCommandOutPut.Text;
  finally
    vCommandOutPut.Free;
    vCommandErrors.Free;
  end;
end;

class function TCurlUtils.GetResultFromOutput (iOutputFileName: string; iCommandOutput: tStringList;
  var oErrorMessage: string): boolean;
var
  vResponseCode, vExitCode, vErrorMessage: string;

  function CleanName (iValue: string): string;
  begin
    if iValue.IndexOf (':') >= 0 then
      Result := iValue.Substring (iValue.IndexOf(':') + 1).Trim
    else
      Result := iValue.Trim;
  end;

begin
  Result := false;
  vResponseCode := '';
  vExitCode := '';
  vErrorMessage := '';
  oErrorMessage := '';
  if iCommandOutput.Count > 0 then
  begin
    if iCommandOutput.Count >= 3 then
    begin
      vResponseCode := CleanName (iCommandOutput[iCommandOutput.Count - 3]);
      vExitCode := CleanName (iCommandOutput[iCommandOutput.Count - 2]);
      vErrorMessage := CleanName (iCommandOutput[iCommandOutput.Count - 1]);
    end
    else
    begin
      oErrorMessage := 'Invalid curl output (too less number of lines).';
      Exit;
    end;
    if vExitCode <> '0' then
      oErrorMessage := Format ('curl command failed : (%s) : %s', [vExitCode, vErrorMessage])
    else if vResponseCode <> '200' then
      if vErrorMessage.IsEmpty then
        oErrorMessage := Format ('Invalid HTTP Response : %s', [vResponseCode])
      else
        oErrorMessage := Format ('Invalid HTTP Response : %s - %s', [vResponseCode, vErrorMessage]);
  end;

  if not FileExists (iOutputFileName) and oErrorMessage.IsEmpty then
    oErrorMessage := Format ('Outputfile "%s" not generated.', [iOutputFileName]);

  Result := oErrorMessage.IsEmpty;
end;

class function TCurlUtils.ReplaceCurlParameterValues (const iValue: string;
  iCurlParameterList: tJson2PumlCurlParameterList; iCurlMappingParameterList: tJson2PumlCurlMappingParameterList;
  iCleanUnused: boolean): string;
begin
  Result := ReplaceCurlParameterValues (iValue, iCurlParameterList, nil, iCurlMappingParameterList, iCleanUnused);
end;

class function TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue: string): string;
var
  Value: string;
  s, v: string;
  i: integer;
begin
  s := iValue;
  Value := '';
  while not s.IsEmpty do
  begin
    i := s.IndexOf ('${');
    if i < 0 then
    begin
      Value := Value + s;
      Break;
    end;
    Value := Value + s.Substring (0, i);
    s := s.Substring (i);
    i := s.IndexOf ('}');
    if i < 0 then
    begin
      Value := Value + s;
      Break;
    end;
    v := s.Substring (2, i - 2);
    v := GetEnvironmentVariable (v.Trim);
    if v.IsEmpty then
      Value := Value + s.Substring (0, i + 1)
    else
      Value := Value + v;
    s := s.Substring (i + 1);
  end;
  Result := Value;
end;

type
  tAccessJson2PumlGlobalDefinition = class(tJson2PumlGlobalDefinition);

end.
