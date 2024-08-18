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

unit commandlinetools;

interface

uses
  System.SysUtils, System.Classes;

function RunCommandLine (const iCommand: WideString; oCommandOutPut, oCommandErrors: tStringList): Boolean;

implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ELSE}
    Posix.Base, Posix.Fcntl,
{$ENDIF}
  System.Types;

{$IFDEF MSWINDOWS}

type
  TWindowsUtils = class
  public
    class function RunCommandLine (const iCommand: WideString; oCommandOutPut, oCommandErrors: tStringList): Boolean;
  end;
{$ELSE}

type
  tStreamHandle = pointer;

  tLinuxUtils = class
  public
    class function RunCommandLine (ACommand: string; var ResultList: tStringList): Boolean; overload;
    class function RunCommandLine (ACommand: string; Return: tProc<string>): Boolean; overload;
  end;

function popen (const Command: MarshaledAString; const _type: MarshaledAString): tStreamHandle; cdecl;
  external libc name _PU + 'popen';
function pclose (filehandle: tStreamHandle): int32; cdecl; external libc name _PU + 'pclose';
function fgets (buffer: pointer; size: int32; Stream: tStreamHandle): pointer; cdecl; external libc name _PU + 'fgets';
{$ENDIF}
{$IFDEF MSWINDOWS}

class function TWindowsUtils.RunCommandLine (const iCommand: WideString;
  oCommandOutPut, oCommandErrors: tStringList): Boolean;
var
  buffer: array [0 .. 2400] of AnsiChar;
  BufferStrOutput: string;
  BufferStrErrors: string;
  CreationFlags: DWORD;
  NumberOfBytesRead: DWORD;
  PipeErrorsRead: tHandle;
  PipeErrorsWrite: tHandle;
  PipeOutputRead: tHandle;
  PipeOutputWrite: tHandle;
  ProcessInfo: tProcessInformation;
  SecurityAttr: tSecurityAttributes;
  StartupInfo: tStartupInfo;
  tmpWaitR: DWORD;

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
  // Initialisierung ProcessInfo
  FillChar (ProcessInfo, SizeOf(tProcessInformation), 0);

  // Initialisierung SecurityAttr
  FillChar (SecurityAttr, SizeOf(tSecurityAttributes), 0);
  SecurityAttr.nLength := SizeOf (tSecurityAttributes);
  SecurityAttr.bInheritHandle := true;
  SecurityAttr.lpSecurityDescriptor := nil;

  // Pipes erzeugen
  CreatePipe (PipeOutputRead, PipeOutputWrite, @SecurityAttr, 0);
  CreatePipe (PipeErrorsRead, PipeErrorsWrite, @SecurityAttr, 0);

  // Initialisierung StartupInfo
  FillChar (StartupInfo, SizeOf(tStartupInfo), 0);
  StartupInfo.cb := SizeOf (tStartupInfo);
  StartupInfo.hStdInput := 0;
  StartupInfo.hStdOutput := PipeOutputWrite;
  StartupInfo.hStdError := PipeErrorsWrite;
  StartupInfo.wShowWindow := SW_HIDE;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

  CreationFlags := CREATE_DEFAULT_ERROR_MODE or CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS;

  Result := CreateProcessW (nil, (PWideChar(iCommand)), nil, nil, true, CreationFlags, nil, nil, StartupInfo,
    ProcessInfo);
  if Result then
  begin
    // Write-Pipes schlieﬂen
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
          AddLine (BufferStrOutput, oCommandOutPut);
          // Application.ProcessMessages ();
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
          AddLine (BufferStrErrors, oCommandErrors);
          // Application.ProcessMessages ();
        end;
      end;

      // Application.ProcessMessages ();
    until (tmpWaitR <> WAIT_TIMEOUT);

    if BufferStrOutput <> '' then
      oCommandOutPut.Add (BufferStrOutput);
    if BufferStrErrors <> '' then
      oCommandErrors.Add (BufferStrErrors);

    CloseHandle (ProcessInfo.hProcess);
    CloseHandle (ProcessInfo.hThread);

    CloseHandle (PipeOutputRead);
    CloseHandle (PipeErrorsRead);
  end
  else
  begin
    // Pipes schlieﬂen
    CloseHandle (PipeOutputRead);
    CloseHandle (PipeOutputWrite);
    CloseHandle (PipeErrorsRead);
    CloseHandle (PipeErrorsWrite);
  end;
end;

function RunCommandLine (const iCommand: WideString; oCommandOutPut, oCommandErrors: tStringList): Boolean;
begin
  Result := TWindowsUtils.RunCommandLine (iCommand, oCommandOutPut, oCommandErrors);
end;

{$ELSE}

class function tLinuxUtils.RunCommandLine (ACommand: string; var ResultList: tStringList): Boolean;

var
  Handle: tStreamHandle;
  Data: array [0 .. 511] of uint8;
  M: tMarshaller;

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

class function tLinuxUtils.RunCommandLine (ACommand: string; Return: tProc<string>): Boolean;
var
  Handle: tStreamHandle;
  Data: array [0 .. 511] of uint8;
  M: tMarshaller;

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

function RunCommandLine (const iCommand: WideString; oCommandOutPut, oCommandErrors: tStringList): Boolean;
begin
  Result := tLinuxUtils.RunCommandLine (iCommand, oCommandOutPut);
end;

{$ENDIF}

end.
