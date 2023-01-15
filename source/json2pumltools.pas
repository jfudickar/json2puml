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

unit json2pumltools;

interface

uses System.Classes, System.SysUtils, json2pumldefinition,
{$IFDEF LINUX}
  Posix.Base,
  Posix.Fcntl,
{$ENDIF}
  json2pumlloghandler, json2pumlconst;

function CalculateCurlCommand (const iBaseUrl, iUrl, iOptions, iOutputFile: string;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList): string;

procedure ClearLastLineComma (oJsonOutPut: TStrings);

function ClearPropertyValue (iValue: string): string;

function ExecuteCurl(const iBaseUrl, iUrl, iOptions, iOutputFile: string; iCurlAuthenticationList:
    tJson2PumlCurlAuthenticationList; iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
    iCurlCache: Integer): Boolean;

function FileCount (iFileFilter: string): Integer;

function FileDescription: string;

function FileVersion: string;

function GenerateOutputFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter: string;
  iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;

function GenerateOutputsFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter: string;
  iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;

function LegalCopyright: string;

procedure OpenFile (iFileName: string);

function ProductVersion: string;

function ReplaceInvalidFileNameChars (const iFileName: string; const iReplaceWith: Char = '_'): string;

function ReplaceInvalidPathChars (const iPathName: string; const iReplaceWith: Char = '_'): string;

function ConvertFileToBase64 (iFileName: string): string;

function FileContent (iFileName: string): string;

function ValidateOutputSuffix (iOutputSuffix: string): string;

function PathCombine (const Path1, Path2: string): string;

function ExecuteCommandWithOutput (const Command: WideString; const CommandInfo: string): Boolean;

procedure GenerateDirectory (const iDirectory: string);

procedure GenerateFileDirectory (iFileName: string);

function IsLinuxHomeBasedPath (iPath: string): Boolean;
function IsRelativePath (iPath: string): Boolean;
function PathCombineIfRelative (iBasePath, iPath: string): string;

function GetServiceFileListResponse (oJsonOutPut: TStrings; iFolderList: tStringList; iInputList: Boolean): Integer;

{$IFDEF LINUX}

type
  TStreamHandle = pointer;

  TLinuxUtils = class
  public
    class function RunCommandLine (ACommand: string; var ResultList: tStringList): Boolean; overload;
    class function RunCommandLine (ACommand: string; Return: TProc<string>): Boolean; overload;
    class function findParameter (AParameter: string): Boolean;
  end;

function popen (const Command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl;
  external libc name _PU + 'popen';
function pclose (filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';
function fgets (buffer: pointer; size: int32; Stream: TStreamHandle): pointer; cdecl; external libc name _PU + 'fgets';
{$ENDIF}

implementation

uses
{$IFDEF MSWINDOWS} Winapi.Windows, Winapi.ShellAPI, VCL.Forms, {$ENDIF}
  System.Generics.Collections, System.IOUtils,
  System.Math, System.DateUtils, System.NetEncoding, json2pumlbasedefinition,
  json2pumlconverterdefinition;

{$IFDEF MSWINDOWS}
// function ExecuteCommand (iExecutable, iParameter: string; iProtocolInfo: string = ''): Boolean;
// var
// SEInfo: TShellExecuteInfo;
// ExitCode: DWORD;
// ExecuteFile: string;
// begin
// ExecuteFile := iExecutable;
//
// FillChar (SEInfo, SizeOf(SEInfo), 0);
// SEInfo.cbSize := SizeOf (TShellExecuteInfo);
// SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
// SEInfo.Wnd := Application.Handle;
// SEInfo.lpFile := PChar (ExecuteFile);
// {
// ParamString can contain the
// application parameters.
// }
// SEInfo.lpParameters := PChar (iParameter);
// {
// StartInString specifies the
// name of the working directory.
// If ommited, the current directory is used.
// }
// // SEInfo.lpDirectory := PChar(StartInString) ;
// SEInfo.nShow := SW_HIDE;
// if iProtocolInfo.isEmpty then
// GlobalLoghandler.Info ('Execute %s %s', [iExecutable, iParameter])
// else
// GlobalLoghandler.Info (iProtocolInfo);
// Application.ProcessMessages;
// if ShellExecuteEx (@SEInfo) then
// begin
// repeat
// Application.ProcessMessages;
// GetExitCodeProcess (SEInfo.hProcess, ExitCode);
// until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
// Result := true;
// end
// else
// begin
// Result := false;
// end;
// end;

function ExecuteCommandWithOutput (const Command: WideString; const CommandInfo: string): Boolean;
var
  buffer: array [0 .. 2400] of AnsiChar;
  BufferStrOutput: string;
  BufferStrErrors: string;
  CreationFlags: DWORD;
  NumberOfBytesRead: DWORD;
  PipeErrorsRead: THandle;
  PipeErrorsWrite: THandle;
  PipeOutputRead: THandle;
  PipeOutputWrite: THandle;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  tmpWaitR: DWORD;
  Output, Errors: tStringList;
  s: string;

  procedure AddLine (var AString: string; ALines: tStringList);
  var
    i: Integer;
    j: Integer;
    p, l: Integer;

    function findnewline: Boolean;
    begin
      i := pos (#13#10, AString);
      j := pos (#10, AString);
      if j = 0 then
        j := pos (#13, AString);
      if (i > 0) and (i <= j) then
      begin
        p := i;
        l := 1;
      end
      else
      begin
        p := j;
        l := 0;
      end;
      Result := p > 0;
    end;

  begin
    while findnewline do
    begin
      if p > 1 then
        ALines.Add (copy(AString, 1, p - 1));
      Delete (AString, 1, p + l);
    end;
  end;

begin
  Output := tStringList.Create;
  Errors := tStringList.Create;

  GlobalLoghandler.Info ('Execute %s', [CommandInfo]);

  try
    // Initialisierung ProcessInfo
    FillChar (ProcessInfo, SizeOf(TProcessInformation), 0);

    // Initialisierung SecurityAttr
    FillChar (SecurityAttr, SizeOf(TSecurityAttributes), 0);
    SecurityAttr.nLength := SizeOf (TSecurityAttributes);
    SecurityAttr.bInheritHandle := true;
    SecurityAttr.lpSecurityDescriptor := nil;

    // Pipes erzeugen
    CreatePipe (PipeOutputRead, PipeOutputWrite, @SecurityAttr, 0);
    CreatePipe (PipeErrorsRead, PipeErrorsWrite, @SecurityAttr, 0);

    // Initialisierung StartupInfo
    FillChar (StartupInfo, SizeOf(TStartupInfo), 0);
    StartupInfo.cb := SizeOf (TStartupInfo);
    StartupInfo.hStdInput := 0;
    StartupInfo.hStdOutput := PipeOutputWrite;
    StartupInfo.hStdError := PipeErrorsWrite;
    StartupInfo.wShowWindow := SW_HIDE;
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

    CreationFlags := CREATE_DEFAULT_ERROR_MODE or CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS;

    Result := CreateProcessW (nil, (PWideChar(Command)), nil, nil, true, CreationFlags, nil, nil, StartupInfo,
      ProcessInfo);
    if Result then
    begin
      // Write-Pipes schließen
      CloseHandle (PipeOutputWrite);
      CloseHandle (PipeErrorsWrite);

      BufferStrOutput := '';
      BufferStrErrors := '';

      repeat
        tmpWaitR := WaitForSingleObject (ProcessInfo.hProcess, 100);

        NumberOfBytesRead := 0;
        // Ausgabe Read-Pipe auslesen
        if PeekNamedPipe (PipeOutputRead, nil, 0, nil, @NumberOfBytesRead, nil) and (NumberOfBytesRead > 0) then
        begin
          while ReadFile (PipeOutputRead, buffer, Length(buffer) - 1, NumberOfBytesRead, nil) do
          begin
            buffer[NumberOfBytesRead] := #0;
            OemToAnsi (buffer, buffer);
            BufferStrOutput := BufferStrOutput + string(buffer);
            AddLine (BufferStrOutput, Output);
            Application.ProcessMessages ();
          end;
        end;

        NumberOfBytesRead := 0;
        if PeekNamedPipe (PipeErrorsRead, nil, 0, nil, @NumberOfBytesRead, nil) and (NumberOfBytesRead > 0) then
        begin
          while ReadFile (PipeErrorsRead, buffer, Length(buffer) - 1, NumberOfBytesRead, nil) do
          begin
            buffer[NumberOfBytesRead] := #0;
            OemToAnsi (buffer, buffer);
            BufferStrErrors := BufferStrErrors + string(buffer);
            AddLine (BufferStrErrors, Errors);
            Application.ProcessMessages ();
          end;
        end;

        Application.ProcessMessages ();
      until (tmpWaitR <> WAIT_TIMEOUT);

      if BufferStrOutput <> '' then
        Output.Add (BufferStrOutput);
      if BufferStrErrors <> '' then
        Errors.Add (BufferStrErrors);

      CloseHandle (ProcessInfo.hProcess);
      CloseHandle (ProcessInfo.hThread);

      CloseHandle (PipeOutputRead);
      CloseHandle (PipeErrorsRead);
    end
    else
    begin
      // Pipes schließen
      CloseHandle (PipeOutputRead);
      CloseHandle (PipeOutputWrite);
      CloseHandle (PipeErrorsRead);
      CloseHandle (PipeErrorsWrite);
    end;
  finally
    if Output.Count > 0 then
    begin
      GlobalLoghandler.Info ('  OutPut');
      for s in Output do
        GlobalLoghandler.Info ('    %s', [s]);
    end;
    if Errors.Count > 0 then
    begin
      GlobalLoghandler.Info ('  Errors');
      for s in Errors do
        GlobalLoghandler.Info ('    %s', [s]);
    end;
    Output.Free;
    Errors.Free;
  end;
end;

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

procedure OpenFile (iFileName: string);
begin
  if FileExists (iFileName) then
    ShellExecute (0, nil, PChar(iFileName), nil, nil, SW_RESTORE);
end;

{$ELSE}

// function ExecuteCommand (iExecutable, iParameter: string; iProtocolInfo: string = ''): Boolean;
// begin
// end;
//
function ExecuteCommandWithOutput (const Command: WideString; const CommandInfo: string): Boolean;
var
  ResultList: tStringList;
  s: string;
begin
  ResultList := tStringList.Create;
  try
    GlobalLoghandler.Info ('Execute %s', [CommandInfo]);
    Result := TLinuxUtils.RunCommandLine (Command, ResultList);
    if ResultList.Count > 0 then
    begin
      GlobalLoghandler.Info ('  OutPut');
      for s in ResultList do
        GlobalLoghandler.Info ('    %s', [s]);
    end;
  finally
    ResultList.Free;
  end;
end;

function GetVersionInfo (AIdent: string): string;
begin

end;

procedure OpenFile (iFileName: string);
begin
end;

{$ENDIF}

function CalculateCurlCommand (const iBaseUrl, iUrl, iOptions, iOutputFile: string;
  iCurlParameterList, iCurlDetailParameterList: tJson2PumlCurlParameterList): string;
var
  url: string;
  Command: string;
begin

  Result := '';
  if iUrl.Trim.isEmpty then
    Exit;

  if iBaseUrl.Trim.isEmpty then
    url := iUrl.Trim.TrimLeft (['/'])
  else
    url := Format ('%s/%s', [iBaseUrl.Trim.TrimRight(['/']), iUrl.Trim.TrimLeft(['/'])]);

  Command := Format ('%s --url "%s" --output "%s" ', [iOptions.Trim, url, iOutputFile]);

  if Assigned (iCurlDetailParameterList) then
    Command := iCurlDetailParameterList.ReplaceParameterValues (Command);
  if Assigned (iCurlParameterList) then
    Command := iCurlParameterList.ReplaceParameterValues (Command);

  Result := Command;
end;

procedure ClearLastLineComma (oJsonOutPut: TStrings);
var
  s: string;
begin
  if oJsonOutPut.Count < 0 then
    Exit;
  s := oJsonOutPut[oJsonOutPut.Count - 1].TrimRight;
  if s.Substring (s.Length - 1) = ',' then
    oJsonOutPut[oJsonOutPut.Count - 1] := s.Substring (0, s.Length - 1);
end;

function ClearPropertyValue (iValue: string): string;
begin
  Result := iValue.TrimRight ([' ', #10, #13, #9]).replace ('\', '\\').replace ('"', '\"').replace (#13#10, #10)
    .replace (#13, #10).replace (#10, '\n');
end;

function FileCount (iFileFilter: string): Integer;
var
  c: Integer;
  searchResult: TSearchRec;
begin
  if iFileFilter.isEmpty then
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

function GenerateOutputFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter: string;
  iFormat: tJson2PumlOutputFormat; iOpenAfter: Boolean): Boolean;
var
  Command: string;
  DestinationFile: string;
begin
  Result := false;
  if not FileExists (iPlantUmlFile) then
    Exit;
  if not iFormat.IsPumlOutput then
    Exit;
  if iPlantUmlJarFile.isEmpty then
    Exit;
  if not FileExists (iPlantUmlJarFile) then
  begin
    GlobalLoghandler.Error ('PlantUML Jar File "%s" not found!', [iPlantUmlJarFile]);
    Exit;
  end;
  DestinationFile := tPath.ChangeExtension (iPlantUmlFile, iFormat.FileExtension);
  GenerateFileDirectory (DestinationFile);

  if FileExists (DestinationFile) then
    tFile.Delete (DestinationFile);

  Command := Format ('java %s -jar "%s" "%s" %s', [iJavaRuntimeParameter.Trim, iPlantUmlJarFile, iPlantUmlFile,
    iFormat.PumlGenerateFlag]);

  Result := ExecuteCommandWithOutput (Command, Command);
  // Result := ExecuteCommand ('java.exe', Command, nil);
  if Result then
  begin
    GlobalLoghandler.Info ('               %-4s generated', [iFormat.toString]);

    Result := FileExists (DestinationFile);
    if Result and iOpenAfter then
      OpenFile (DestinationFile);
  end
  else
    GlobalLoghandler.Error ('Generation of %s for %s FAILED.', [iFormat.toString, iPlantUmlFile]);
end;

function GenerateOutputsFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter: string;
  iOutputFormats, iOpenOutputs: tJson2PumlOutputFormats): Boolean;
var
  f: tJson2PumlOutputFormat;
begin
  Result := true;
  for f in iOutputFormats do
    if f.IsPumlOutput then
      Result := Result and GenerateOutputFromPuml (iPlantUmlFile, iPlantUmlJarFile, iJavaRuntimeParameter, f,
        f in iOpenOutputs);
end;

function LegalCopyright: string;
begin
  Result := GetVersionInfo ('LegalCopyright');
end;

function ProductVersion: string;
begin
  Result := 'v' + GetVersionInfo ('ProductVersion');
end;

function ReplaceInvalidFileNameChars (const iFileName: string; const iReplaceWith: Char = '_'): string;
var
  i: Integer;
begin
  Result := iFileName.Trim;
  while Result.IndexOf (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar) >= 0 do
    Result := Result.replace (tPath.ExtensionSeparatorChar + tPath.ExtensionSeparatorChar,
      tPath.ExtensionSeparatorChar);
  for i := low(Result) to high(Result) do
    if not tPath.IsValidFileNameChar (Result[i]) then
      Result[i] := iReplaceWith;
end;

function ReplaceInvalidPathChars (const iPathName: string; const iReplaceWith: Char = '_'): string;
var
  i: Integer;
begin
  Result := iPathName.Trim;
  for i := low(Result) to high(Result) do
    if not tPath.IsValidPathChar (Result[i]) then
      Result[i] := iReplaceWith;
end;

function ExecuteCurl(const iBaseUrl, iUrl, iOptions, iOutputFile: string; iCurlAuthenticationList:
    tJson2PumlCurlAuthenticationList; iCurlDetailParameterList, iCurlParameterList: tJson2PumlCurlParameterList;
    iCurlCache: Integer): Boolean;
var
  url: string;
  ProtocolCommand: string;
  Command: string;
  FilePath: string;
  Authentication: tJson2PumlCurlAuthenticationDefinition;
  FileLastWriteDate: tDateTime;
  StartTime: tDateTime;
begin

  Result := false;
  if iUrl.Trim.isEmpty then
    Exit;
  if iOutputFile.Trim.isEmpty then
    Exit;

  ProtocolCommand := CalculateCurlCommand (iBaseUrl, iUrl, iOptions, iOutputFile, iCurlParameterList,
    iCurlDetailParameterList);
  if ProtocolCommand.isEmpty then
    Exit;
  url := iUrl;
  if Assigned (iCurlDetailParameterList) then
    url := iCurlDetailParameterList.ReplaceParameterValues (url);
  if Assigned (iCurlParameterList) then
    url := iCurlParameterList.ReplaceParameterValues (url);

  Command := ProtocolCommand;
  ProtocolCommand := Format ('%s %s', ['curl', ProtocolCommand]);
  FilePath := tPath.GetDirectoryName (iOutputFile);
  if tPath.IsRelativePath (FilePath) or IsLinuxHomeBasedPath (FilePath) then
    FilePath := ExpandFileName (FilePath);
  GenerateDirectory (FilePath);

  if Assigned (iCurlAuthenticationList) then
  begin
    Authentication := iCurlAuthenticationList.FindAuthentication (iBaseUrl);
    if Assigned (Authentication) then
      Command := Authentication.Parameter.ReplaceParameterValues (Command);
  end;

  if (iCurlCache > 0) and FileExists (iOutputFile) then
  begin
    FileLastWriteDate := tFile.GetLastWriteTime (iOutputFile);
    if Now - FileLastWriteDate < iCurlCache / (24 * 60 * 60) then
    begin
      GlobalLoghandler.Info (ProtocolCommand);
      GlobalLoghandler.Info ('  curl skipped - %s is not older then %d seconds.', [iOutputFile, iCurlCache]);
      Exit;
    end;
  end;


  StartTime := Now;
  Result := ExecuteCommandWithOutput ('curl ' + Command, ProtocolCommand);
  // Result := ExecuteCommand ('curl', Command);
  if Result then
  begin
    Result := FileExists (iOutputFile);
    if Result then
      GlobalLoghandler.Info ('  curl "%s/%s" fetched to "%s" (%d ms)',
        [iBaseUrl.Trim.TrimRight(['/']), url.Trim.TrimLeft(['/']), iOutputFile, MillisecondsBetween(Now, StartTime)])
    else
      GlobalLoghandler.Warn ('WARNING: Fetching from %s/%s for "%s" FAILED - File not generated (%d ms)',
        [iBaseUrl.Trim.TrimRight(['/']), url.Trim.TrimLeft(['/']), iOutputFile, MillisecondsBetween(Now, StartTime)]);
  end
  else
  begin
    GlobalLoghandler.Warn ('WARNING: Fetching from %s/%s for "%s" FAILED (%d ms)',
      [iBaseUrl.Trim.TrimRight(['/']), url.Trim.TrimLeft(['/']), iOutputFile, MillisecondsBetween(Now, StartTime)]);
  end;
end;

// function CalculateOutputFilename (iFileName, iOutputPath, iOutputSuffix, iOption, iGroup, iDetail,
// iNewExtension: string): string;
// var
// FilePath: string;
// begin
// FilePath := CalculateOutputDirectory (iFileName, iOutputPath, iOption, iGroup, iDetail);
// if iNewExtension.isEmpty then
// iNewExtension := tPath.GetExtension (iFileName).TrimLeft (['.']);
// iFileName := tPath.GetFileNameWithoutExtension (iFileName);
// if not iOutputSuffix.isEmpty then
// iFileName := iFileName + ReplaceFileNameVariables (iOutputSuffix, iFileName, iOption, iGroup, iDetail);
// if iNewExtension.isEmpty then
// iFileName := iFileName
// else
// iFileName := iFileName + '.' + iNewExtension;
// iFileName := ReplaceInvalidFileNameChars (iFileName);
// Result := PathCombine (FilePath, iFileName);
// end;

procedure GenerateDirectory (const iDirectory: string);
begin
  try
    ForceDirectories (iDirectory);
  except
    on e: exception do
      GlobalLoghandler.Error ('Error creating directory : %s', [iDirectory]);
  end;
end;

procedure GenerateFileDirectory (iFileName: string);
begin
  GenerateDirectory (ExtractFilePath(iFileName));
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

function FileContent (iFileName: string): string;
var
  Lines: tStringList;
begin
  Result := '';
  if not FileExists (iFileName) then
    Exit;
  Lines := tStringList.Create;
  try
    Lines.LoadFromFile (iFileName);
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

function ValidateOutputSuffix (iOutputSuffix: string): string;
begin
  Result := iOutputSuffix.Trim;
  if not Result.isEmpty then
    if CharInSet (Result[1], ['_', '-', '.']) then
      if Result.Substring (1).Trim.isEmpty then
        Result := ''
      else
    else
      Result := '.' + Result;
end;

function PathCombine (const Path1, Path2: string): string;
begin
  if not Path1.isEmpty then
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

function IsRelativePath (iPath: string): Boolean;
begin
  if IsLinuxHomeBasedPath (iPath) then
    Result := false
  else
    Result := tPath.IsRelativePath (iPath);
end;

function IsLinuxHomeBasedPath (iPath: string): Boolean;
begin
{$IFDEF LINUX}
  Result := iPath.StartsWith (cLinuxHome);
{$ELSE}
  Result := false;
{$ENDIF}
end;

{$IFDEF LINUX}

class function TLinuxUtils.RunCommandLine (ACommand: string; var ResultList: tStringList): Boolean;

var
  Handle: TStreamHandle;
  Data: array [0 .. 511] of uint8;
  M: TMarshaller;

begin
  Result := false;
  if not Assigned (ResultList) then
    ResultList := tStringList.Create;
  try
    Handle := popen (M.AsAnsi(PWideChar(ACommand)).ToPointer, 'r');
    try
      while fgets (@Data[0], SizeOf(Data), Handle) <> nil do
      begin
        ResultList.Add (copy(UTF8ToString(@Data[0]), 1, UTF8ToString(@Data[0]).Length - 1)); // ,sizeof(Data)));
      end;
    finally
      pclose (Handle);
    end;
    Result := true;
  except
    on e: exception do
      ResultList.Add (e.ClassName + ': ' + e.Message);
  end;
end;

class function TLinuxUtils.RunCommandLine (ACommand: string; Return: TProc<string>): Boolean;
var
  Handle: TStreamHandle;
  Data: array [0 .. 511] of uint8;
  M: TMarshaller;

begin
  Result := false;
  try
    Handle := popen (M.AsAnsi(PWideChar(ACommand)).ToPointer, 'r');
    try
      while fgets (@Data[0], SizeOf(Data), Handle) <> nil do
      begin
        Return (copy(UTF8ToString(@Data[0]), 1, UTF8ToString(@Data[0]).Length - 1)); // ,sizeof(Data)));
      end;
    finally
      pclose (Handle);
    end;
  except
    on e: exception do
      Return (e.ClassName + ': ' + e.Message);
  end;
end;

class function TLinuxUtils.findParameter (AParameter: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to Pred(ParamCount) do
  begin
    Result := AParameter.ToUpper = ParamStr (i).ToUpper;
    if Result then
      Break;
  end;
end;
{$ENDIF}

type
  tAccessJson2PumlGlobalDefinition = class(tJson2PumlGlobalDefinition);

function GetServiceFileListResponse (oJsonOutPut: TStrings; iFolderList: tStringList; iInputList: Boolean): Integer;
var
  s: string;
  FileList: tStringList;
  ConfigFile: tJson2PumlBaseObject;
begin
  Result := 0;
  oJsonOutPut.Clear;
  FileList := tStringList.Create;
  GlobalConfigurationDefinition.FindFilesInFolderList (FileList, iFolderList);
  tAccessJson2PumlGlobalDefinition (GlobalConfigurationDefinition).WriteArrayStartToJson (oJsonOutPut, 0, '');
  try
    for s in FileList do
    begin
      if iInputList then
        ConfigFile := tJson2PumlInputList.Create (nil)
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
    tAccessJson2PumlGlobalDefinition (GlobalConfigurationDefinition).WriteArrayEndToJson (oJsonOutPut, 0);
  finally
    FileList.Free;
  end;
end;

end.
