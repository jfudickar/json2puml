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

uses System.Classes, System.SysUtils, json2pumldefinition,
  json2pumlloghandler, json2pumlconst, System.Zip;

procedure AddFileToZipFile (iZipFile: TZipFile; iFileName, iRemoveDirectory: string);

function ApplicationCompileVersion: string;

function ConvertFileToBase64 (iFileName: string): string;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string): Boolean; overload;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string;
  oCommandOutPut, oCommandErrors: TStringList): Boolean; overload;

function FileContent (iFileName: string): string;

function FileCount (iFileFilter: string): Integer;

function FileDescription: string;

function FileExistsMinSize (iFileName: string): Boolean;

function FileNameWithSuffix (iFileName, iFileNameSuffix: string): string;

function FileVersion: string;

procedure GenerateDirectory (const iDirectory: string);

procedure GenerateFileDirectory (iFileName: string);

function GenerateOutputFromPumlFiles (iPlantUmlFiles: TStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;
function GenerateOutputsFromPumlFiles (iPlantUmlFiles: TStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;
function GenerateOutputFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter, iPlantUmlRuntimeParameter
  : string; iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;
function GenerateOutputsFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;

function GetPlantUmlVersion (iPlantUmlJarFile, iJavaRuntimeParameter: string): string;

function GetServiceFileListResponse (oJsonOutPut: TStrings; iFolderList: TStringList; iInputList: Boolean): Integer;

function GetVersionInfo (AIdent: string): string;

function IsLinuxHomeBasedPath (iPath: string): Boolean;

function IsRelativePath (iPath: string): Boolean;

function LegalCopyright: string;

procedure OpenFile (iFileName: string);

function PathCombine (const Path1, Path2: string): string;

function PathCombineIfRelative (iBasePath, iPath: string): string;

function ProductVersion: string;

function ReplaceInvalidFileNameChars (const iFileName: string; iFinal: Boolean = false;
  const iReplaceWith: Char = '_'): string;

function ReplaceInvalidPathChars (const iPathName: string; iFinal: Boolean = false;
  const iReplaceWith: Char = '_'): string;

function ReplaceInvalidPathFileNameChars (const iFileName: string; iFinal: Boolean = false;
  const iReplaceWith: Char = '_'): string;

function ValidateOutputSuffix (iOutputSuffix: string): string;

function CurrentThreadId: TThreadId;

function LogIndent (iIndent: Integer): string;

function ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (iValue: string): string;

type
  TCurlUtils = class
  private
    class function CalculateCommandExecute (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
      const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: Boolean): string;
    class function CalculateOutputParameter (const iOutput: string): string;
    class function CalculateParameter (const iParameterName, iParameterValue: string; iQuoteValue: Boolean): string;
    class function CalculateUrlParameter (const iUrl: string): string;
    class function CalculateWriteOutParameter (const iWriteout: string): string;
  public
    class function CalculateCommand (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
      const iOutputFile: string; iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: Boolean): string;
    class function CalculateHeaderParameter (const iHeaderName: string; iHeaderValue: string): string;
    class function CalculateUrl (const iBaseUrl: string; const iUrlParts: array of string;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): string;
    class function ReplaceCurlParameterValues (const iValue: string;
      iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: Boolean): string; overload;
    class function CalculateUserAgentParameter (const iUserAgent: string): string;
    class function CheckEvaluation (iExecuteEvaluation: string): Boolean;
    class function CheckExecuteEvaluation (const iOutputFile: string; iExecuteEvaluation: string;
      iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): Boolean;
    class function CleanUnusedCurlVariables (iValue: string): string;
    class function CombineParameter (iParameter: array of string): string;
    class function Execute (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
      const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
      iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCurlCache: Integer;
      iCurlResult: tJson2PumlCurlResult): Boolean;
    class function GetResultFromOutput (iOutputFileName: string; iCommandOutput: TStringList;
      var oErrorMessage: string): Boolean;
    class function ReplaceCurlParameterValues (const iValue: string; iCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: Boolean): string; overload;
    class function ReplaceCurlVariablesFromEnvironment (iValue: string): string;
  end;

function GenerateFileNameContentBinary(iFileName: string): string;

procedure WriteToJsonFileNameContent(oJsonOutPut: TStrings; const iPropertyName: string; iLevel: Integer; iFileName:
    string; iIncludeFullFilename, iBinaryContent: boolean; iWriteEmpty: boolean = false);

implementation

uses
{$IFDEF MSWINDOWS} Winapi.Windows, Winapi.ShellAPI, VCL.Forms, {$ENDIF}
  System.Generics.Collections, System.IOUtils,
  System.Math, System.DateUtils, System.NetEncoding, json2pumlbasedefinition,
  json2pumlconverterdefinition, System.Bindings.ExpressionDefaults, System.Bindings.Expression, jsontools,
  commandlinetools;

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

procedure AddFileToZipFile (iZipFile: TZipFile; iFileName, iRemoveDirectory: string);
begin
  if FileExists (iFileName) then
    iZipFile.Add (iFileName, iFileName.replace(iRemoveDirectory, '').TrimLeft(tPath.DirectorySeparatorChar));
end;

function ConvertFileToBase64 (iFileName: string): string;
var
  MemStream: TMemoryStream;
  Base64: TBase64Encoding;
begin
  MemStream := TMemoryStream.Create;
  Base64 := TBase64Encoding.Create (0);
  try
    MemStream.LoadFromFile (iFileName);
    Result := Base64.EncodeBytesToString (MemStream.Memory, MemStream.size);
  finally
    MemStream.Free;
    Base64.Free;
  end;
end;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string): Boolean;
var
  vCommandOutPut, vCommandErrors: TStringList;
begin
  vCommandOutPut := TStringList.Create;
  vCommandErrors := TStringList.Create;
  try
    Result := ExecuteCommand (iCommand, iCommandType, iCommandInfo, vCommandOutPut, vCommandErrors);
  finally
    vCommandOutPut.Free;
    vCommandErrors.Free;
  end;
end;

function ExecuteCommand (const iCommand: WideString; const iCommandType, iCommandInfo: string;
  oCommandOutPut, oCommandErrors: TStringList): Boolean;

  procedure LogOutputLines (iInfo: string; iOutputLines: TStringList);
  var
    lines: TStringList;
    line: string;
    OutPut: string;
  begin
    if iOutputLines.Count <= 0 then
      Exit;
    GlobalLogHandler.Info ('  %s', [iInfo]);
    lines := TStringList.Create;
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

function FileAttributesStr (iFileAttributes: TFileAttributes): string;
var
  a: TFileAttribute;
begin
  Result := '';
  for a := low(TFileAttribute) to high(TFileAttribute) do
  begin
    case a of
{$IFDEF MSWINDOWS}
      TFileAttribute.faReadOnly:
        Result := Result + ', ' + 'faReadOnly';
      TFileAttribute.faHidden:
        Result := Result + ', ' + 'faHidden';
      TFileAttribute.faSystem:
        Result := Result + ', ' + 'faSystem';
      TFileAttribute.faDirectory:
        Result := Result + ', ' + 'faDirectory';
      TFileAttribute.faArchive:
        Result := Result + ', ' + 'faArchive';
      TFileAttribute.faDevice:
        Result := Result + ', ' + 'faDevice';
      TFileAttribute.faNormal:
        Result := Result + ', ' + 'faNormal';
      TFileAttribute.faTemporary:
        Result := Result + ', ' + 'faTemporary';
      TFileAttribute.faSparseFile:
        Result := Result + ', ' + 'faSparseFile';
      TFileAttribute.faReparsePoint:
        Result := Result + ', ' + 'faReparsePoint';
      TFileAttribute.faCompressed:
        Result := Result + ', ' + 'faCompressed';
      TFileAttribute.faOffline:
        Result := Result + ', ' + 'faOffline';
      TFileAttribute.faNotContentIndexed:
        Result := Result + ', ' + 'faNotContentIndexed';
      TFileAttribute.faEncrypted:
        Result := Result + ', ' + 'faEncrypted';
      TFileAttribute.faSymLink:
        Result := Result + ', ' + 'faSymLink';
{$ELSE}
      TFileAttribute.faNamedPipe:
        Result := Result + ', ' + 'faNamedPipe';
      TFileAttribute.faCharacterDevice:
        Result := Result + ', ' + 'faCharacterDevice';
      TFileAttribute.faDirectory:
        Result := Result + ', ' + 'faDirectory';
      TFileAttribute.faBlockDevice:
        Result := Result + ', ' + 'faBlockDevice';
      TFileAttribute.faNormal:
        Result := Result + ', ' + 'faNormal';
      TFileAttribute.faSymLink:
        Result := Result + ', ' + 'faSymLink';
      TFileAttribute.faSocket:
        Result := Result + ', ' + 'faSocket';
      TFileAttribute.faWhiteout:
        Result := Result + ', ' + 'faWhiteout';
      TFileAttribute.faOwnerRead:
        Result := Result + ', ' + 'faOwnerRead';
      TFileAttribute.faOwnerWrite:
        Result := Result + ', ' + 'faOwnerWrite';
      TFileAttribute.faOwnerExecute:
        Result := Result + ', ' + 'faOwnerExecute';
      TFileAttribute.faGroupRead:
        Result := Result + ', ' + 'faGroupRead';
      TFileAttribute.faGroupWrite:
        Result := Result + ', ' + 'faGroupWrite';
      TFileAttribute.faGroupExecute:
        Result := Result + ', ' + 'faGroupExecute';
      TFileAttribute.faOthersRead:
        Result := Result + ', ' + 'faOthersRead';
      TFileAttribute.faOthersWrite:
        Result := Result + ', ' + 'faOthersWrite';
      TFileAttribute.faOthersExecute:
        Result := Result + ', ' + 'faOthersExecute';
      TFileAttribute.faUserIDExecution:
        Result := Result + ', ' + 'faUserIDExecution';
      TFileAttribute.faGroupIDExecution:
        Result := Result + ', ' + 'faGroupIDExecution';
      TFileAttribute.faStickyBit:
        Result := Result + ', ' + 'faStickyBit';

{$ENDIF}
    end;
  end;
  Result := Result.TrimLeft ([',', ' ']);
end;
{$WARN SYMBOL_PLATFORM ON}

function FileContent (iFileName: string): string;
var
  lines: TStringList;
begin
  Result := '';
  if not FileExists (iFileName) then
    Exit;
  lines := TStringList.Create;
  try
    lines.LoadFromFile (iFileName);
    Result := lines.Text;
  finally
    lines.Free;
  end;
end;

function FileCount (iFileFilter: string): Integer;
var
  c: Integer;
  searchResult: TSearchRec;
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

function GenerateOutputFromPumlFiles (iPlantUmlFiles: TStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;
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

function GenerateOutputsFromPumlFiles (iPlantUmlFiles: TStringList; const iPlantUmlJarFile, iJavaRuntimeParameter,
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;
var
  f: tJson2PumlOutputFormat;
begin
  Result := true;
  for f in iOutputFormats do
    if f.IsPumlOutput then
      Result := Result and GenerateOutputFromPumlFiles (iPlantUmlFiles, iPlantUmlJarFile, iJavaRuntimeParameter,
        iPlantUmlRuntimeParameter, f, f in iOpenOutputs);
end;

function GenerateOutputFromPuml (const iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter, iPlantUmlRuntimeParameter
  : string; iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;
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
  iPlantUmlRuntimeParameter: string; iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;
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
  vCommandOutPut, vCommandErrors: TStringList;
begin
  if iPlantUmlJarFile.IsEmpty then
    Result := 'PlantUml jar file not defined'
  else if not FileExists (iPlantUmlJarFile) then
    Result := Format ('defined PlantUml jar file (%s) not existing', [iPlantUmlJarFile])
  else
  begin
    vCommandOutPut := TStringList.Create;
    vCommandErrors := TStringList.Create;
    try
      Command := Format ('java %s -jar "%s" -version', [iJavaRuntimeParameter.Trim, iPlantUmlJarFile.Trim]);
      ExecuteCommand (Command, 'get plantuml version', Command, vCommandOutPut, vCommandErrors);
      Result := vCommandOutPut.Text;
    finally
      vCommandOutPut.Free;
      vCommandErrors.Free;
    end;
  end;

end;

function GetServiceFileListResponse (oJsonOutPut: TStrings; iFolderList: TStringList; iInputList: Boolean): Integer;
var
  s: string;
  FileList: TStringList;
  ConfigFile: tJson2PumlBaseObject;
begin
  Result := 0;
  oJsonOutPut.Clear;
  FileList := TStringList.Create;
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
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: string;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID (HInstance, 1, RT_VERSION);
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
    if not VerQueryValue (RM.Memory, PChar(BId), pointer(BP), BL) then
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

function IsLinuxHomeBasedPath (iPath: string): Boolean;
begin
{$IFDEF LINUX}
  Result := iPath.StartsWith (cLinuxHome);
{$ELSE}
  Result := false;
{$ENDIF}
end;

function IsRelativePath (iPath: string): Boolean;
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
    ShellExecute (0, nil, PChar(iFileName), nil, nil, SW_RESTORE);
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

function ReplaceInvalidFileNameChars (const iFileName: string; iFinal: Boolean = false;
  const iReplaceWith: Char = '_'): string;
var
  i: Integer;
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

function ReplaceInvalidPathFileNameChars (const iFileName: string; iFinal: Boolean = false;
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

function ReplaceInvalidPathChars (const iPathName: string; iFinal: Boolean = false;
  const iReplaceWith: Char = '_'): string;
var
  i: Integer;
begin
  Result := iPathName.Trim;
  for i := low(Result) to high(Result) do
    if not tPath.IsValidPathChar (Result[i]) or (iFinal and (CharInSet(Result[i], ['$']))) then
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

function CurrentThreadId: TThreadId;
begin
{$IFDEF MSWINDOWS}
  Result := GetCurrentThreadId;
{$ELSE}
  Result := TThread.CurrentThread.ThreadID;
{$ENDIF}
end;

function FileExistsMinSize (iFileName: string): Boolean;
var
  Reader: TFileStream;
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

function LogIndent (iIndent: Integer): string;
begin
  Result := '';
  Result := Result.PadRight (iIndent * 2, ' ');
end;

function ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (iValue: string): string;
begin
  Result := TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue);
  Result := GlobalConfigurationDefinition.CurlParameter.ReplaceParameterValues (Result);
end;

function GenerateFileNameContentBinary(iFileName: string): string;
var sl : TStringList;
begin
  sl := TStringList.Create;
  try
    WriteToJsonFileNameContent(sl, '', 0, iFileName, false, true);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

procedure WriteToJsonFileNameContent(oJsonOutPut: TStrings; const iPropertyName: string; iLevel: Integer; iFileName:
    string; iIncludeFullFilename, iBinaryContent: boolean; iWriteEmpty: boolean = false);
begin
  if iFileName.IsEmpty then
    exit;
  if not FileExists (iFileName) then
    exit;
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

class function TCurlUtils.CalculateCommand (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
  const iOutputFile: string; iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: Boolean): string;
begin
  Result := CalculateCommandExecute (iBaseUrl, iUrlParts, iOptions, iOutputFile, nil, iCurlParameterList,
    iCurlDetailParameterList, iCurlMappingParameterList, iIncludeWriteOut);
end;

class function TCurlUtils.CalculateCommandExecute (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
  const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iIncludeWriteOut: Boolean): string;
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
  iQuoteValue: Boolean): string;
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
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCleanUnused: Boolean): string;
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

class function TCurlUtils.CheckEvaluation (iExecuteEvaluation: string): Boolean;
var
  BindExpr: TBindingExpressionDefault;
begin
  Result := true;
  if iExecuteEvaluation.Trim.IsEmpty then
    Exit;
  BindExpr := TBindingExpressionDefault.Create;
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
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList): Boolean;
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
  i: Integer;
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

class function TCurlUtils.Execute (const iBaseUrl: string; const iUrlParts, iOptions: array of string;
  const iOutputFile: string; iCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
  iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList; iCurlCache: Integer;
  iCurlResult: tJson2PumlCurlResult): Boolean;
var
  Url: string;
  Command: string;
  FilePath: string;
  FileLastWriteDate: tDateTime;
  StartTime: tDateTime;
  vErrorMessage: string;
  vCommandOutPut, vCommandErrors: TStringList;
  vOutputFile: TStringList;
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

    iCurlResult.Command := CalculateCommand (iBaseUrl, iUrlParts, iOptions, iOutputFile, iCurlParameterList,
      iCurlDetailParameterList, iCurlMappingParameterList, true);
    if iCurlResult.Command.IsEmpty then
    begin
      iCurlResult.ErrorMessage := Format (jetCurlFileSkippedInvalidCurlCommand.ErrorMessage, [iOutputFile]);
      GlobalLogHandler.Error (iCurlResult.ErrorMessage);
      Exit;
    end;
    iCurlResult.Command := Format ('%s %s', ['curl', iCurlResult.Command]);

    Command := CalculateCommandExecute (iBaseUrl, iUrlParts, iOptions, iOutputFile, iCurlAuthenticationList,
      iCurlParameterList, iCurlDetailParameterList, iCurlMappingParameterList, true);

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
        GlobalLogHandler.Info ('  curl skipped - %s is not older then %d seconds.', [iOutputFile, iCurlCache]);
        Result := true;
        Exit;
      end;
    end;

    if FileExists (iOutputFile) then
      tFile.Delete (iOutputFile);
    StartTime := Now;
    vCommandOutPut := TStringList.Create;
    vCommandErrors := TStringList.Create;
    try
      ExecuteCommand ('curl ' + Command, Format('curl fetch "%s"', [ExtractFileName(iOutputFile)]), iCurlResult.Command,
        vCommandOutPut, vCommandErrors);
      Result := GetResultFromOutput (iOutputFile, vCommandOutPut, vErrorMessage);
    finally
      vCommandOutPut.Free;
      vCommandErrors.Free;
    end;
    iCurlResult.Duration := MillisecondsBetween (Now, StartTime);

    if Result then
    begin
      iCurlResult.NoOfRecords := GetJsonFileRecordCount(iOutputFile);
      iCurlResult.FileSize := TFile.GetSize(iOutputFile);
      GlobalLogHandler.Info ('  curl "%s" fetched to "%s" (%d ms) [%d Record(s) found]', [Url, iOutputFile, iCurlResult.Duration, iCurlResult.NoOfRecords])
    end
    else
    begin
      GlobalLogHandler.Error (jetCurlExecutionFailed, [Url, iOutputFile, MillisecondsBetween(Now, StartTime),
        vErrorMessage]);
      iCurlResult.ErrorMessage := vErrorMessage;
      if FileExists (iOutputFile) then
      begin
        tFile.SetLastWriteTime (iOutputFile, Now - 10);
        vOutputFile := TStringList.Create;
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

class function TCurlUtils.GetResultFromOutput (iOutputFileName: string; iCommandOutput: TStringList;
  var oErrorMessage: string): Boolean;
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
  iCleanUnused: Boolean): string;
begin
  Result := ReplaceCurlParameterValues (iValue, iCurlParameterList, nil, iCurlMappingParameterList, iCleanUnused);
end;

class function TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue: string): string;
var
  Value: string;
  s, v: string;
  i: Integer;
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
