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

unit json2pumlloghandler;

interface

uses
  System.Classes, Quick.Logger, json2pumlconst, System.SysUtils, System.SyncObjs;

type
  tJson2PumlErrorRecord = class(tPersistent)
  private
    FErrorMessage: string;
    FErrorType: tJson2PumlErrorType;
    FThreadId: tThreadID;
  public
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property ErrorType: tJson2PumlErrorType read FErrorType write FErrorType;
    property ThreadId: tThreadID read FThreadId write FThreadId;
  end;

  tJson2PumlErrorList = class(tStringList)
  private
    FLock: tCriticalSection;
    function GetFailed: boolean;
  protected
    property Lock: tCriticalSection read FLock;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddErrorWarning (const aErrorType: tJson2PumlErrorType; const aMessage: string);
    procedure Clear; override;
    procedure RenderErrorReponseFromErrorList (var oResponseText: string; var oHttpCode: integer);
    property Failed: boolean read GetFailed;
  end;

  tJson2PumlLogHandler = class(tPersistent)
  private
    FErrorList: tJson2PumlErrorList;
    function GetFailed: boolean;
  protected
    procedure LogMsg (const aMsg: string; aValues: array of TVarRec; aEventType: tEventType); overload;
    procedure LogMsg (const aMsg: string; aEventType: tEventType); overload;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure Debug (const aMessage: string; const aTag: string = ''); overload;
    procedure Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure DebugParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
      const aTag: string = ''); overload;
    procedure Error (const aMessage: string; const aTag: string = ''); overload;
    procedure Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Error (const aErrorType: tJson2PumlErrorType; const aTag: string = ''); overload;
    procedure Error (const aErrorType: tJson2PumlErrorType; const aParams: array of TVarRec;
      const aTag: string = ''); overload;
    procedure Header (const aMessage: string; const aTag: string = ''); overload;
    procedure Header (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Info (const aMessage: string; const aTag: string = ''); overload;
    procedure Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure InfoParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
      const aTag: string = ''); overload;
    procedure Trace (const aMessage: string; const aTag: string = ''); overload;
    procedure Trace (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure UnhandledException (aException: Exception); virtual;
    procedure Warn (const aMessage: string; const aTag: string = ''); overload;
    procedure Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    property ErrorList: tJson2PumlErrorList read FErrorList;
    property Failed: boolean read GetFailed;
  end;

function GlobalLogHandler: tJson2PumlLogHandler;

procedure InitDefaultLogger (iLogFilePath: string; iApplicationType: tJson2PumlApplicationType;
  iAllowsConsole, iAllowsLogFile: boolean);

procedure SetLogProviderDefaults (iProvider: tLogProviderBase; iApplicationType: tJson2PumlApplicationType);

implementation

uses
  Quick.Logger.Provider.Files, Quick.Logger.Provider.Console, System.IOUtils, Quick.Logger.Provider.StringList,
{$IFDEF DEBUG} Quick.Logger.ExceptionHook, {$ENDIF}Quick.Logger.UnhandledExceptionHook, Quick.Logger.RuntimeErrorHook,
  json2pumldefinition, json2pumlbasedefinition, jsontools, json2pumltools;

var
  IntGlobalLogHandler: tJson2PumlLogHandler;

function GlobalLogHandler: tJson2PumlLogHandler;
begin
  Result := IntGlobalLogHandler;
end;

procedure InitializationGlobalLogHandler;
begin
  IntGlobalLogHandler := tJson2PumlLogHandler.Create;
end;

procedure FinalizationGlobalLogHandler;
begin
  IntGlobalLogHandler.Free;
end;

procedure SetLogProviderEventTypeNames (iProvider: tLogProviderBase);
var
  et: tEventType;
begin
  for et := low(tEventType) to high(tEventType) do
    iProvider.EventTypeName[et] := JSON2PUML_EVENTTYPENAMES[integer(et)];
end;

procedure SetLogProviderDefaults (iProvider: tLogProviderBase; iApplicationType: tJson2PumlApplicationType);
  procedure SetCustomFormat (iLogProvider: tLogProviderBase);
  begin
    iLogProvider.CustomMsgOutput := true;
    if iApplicationType in [jatService, jatWinService] then
    begin
      iLogProvider.IncludedInfo := iLogProvider.IncludedInfo + [iiThreadId];
      iLogProvider.CustomFormatOutput := '%{DATETIME} - (%{THREADID}) - [%{LEVEL}] : %{MESSAGE}'
    end
    else
      iLogProvider.CustomFormatOutput := '%{DATETIME} - [%{LEVEL}] : %{MESSAGE}'
  end;

begin
  if GlobalCommandLineParameter.Debug then
    iProvider.LogLevel := LOG_DEBUG
  else
    iProvider.LogLevel := LOG_TRACE;
  iProvider.TimePrecission := true;
  iProvider.IncludedInfo := [iiAppName, iiHost, iiUserName, iiEnvironment, iiPlatform, iiOSVersion, iiExceptionInfo,
    iiExceptionStackTrace];
  SetLogProviderEventTypeNames (iProvider);
  SetCustomFormat (iProvider);
end;

procedure InitDefaultLogger (iLogFilePath: string; iApplicationType: tJson2PumlApplicationType;
  iAllowsConsole, iAllowsLogFile: boolean);

var
  LogFileName: string;

begin

  GlobalLogFileProvider.Enabled := false;
  GlobalLogConsoleProvider.Enabled := not (iApplicationType in [jatUI, jatWinService]);
  if GlobalLogConsoleProvider.Enabled then
  begin
    if Logger.Providers.IndexOf (GlobalLogConsoleProvider) < 0 then
      Logger.Providers.Add (GlobalLogConsoleProvider);
    SetLogProviderDefaults (GlobalLogConsoleProvider, iApplicationType);
    // GlobalLogConsoleProvider.ShowEventColors := False;
  end;

  if iAllowsLogFile then
  begin
    if Logger.Providers.IndexOf (GlobalLogFileProvider) < 0 then
      Logger.Providers.Add (GlobalLogFileProvider);
    LogFileName := iLogFilePath;
    if not TDirectory.Exists (iLogFilePath) and not (iLogFilePath.IsEmpty) then
    begin
      try
        TDirectory.CreateDirectory (iLogFilePath);
        Log ('Log directory %s created', [iLogFilePath], etInfo);
      except
        on e: Exception do
        begin
          LogFileName := '';
          Log ('Log directory %s not created: %s', [iLogFilePath, e.Message], etError);
        end;
      end;
    end;

    LogFileName := ExpandFileName (tPath.Combine(LogFileName, ChangeFileExt(ExtractFileName(ParamStr(0)), '.log')));
    GlobalLogFileProvider.FileName := LogFileName;
    GlobalLogFileProvider.DailyRotate := true;
    GlobalLogFileProvider.DailyRotateFileDateFormat := 'yyyymmdd';
    GlobalLogFileProvider.MaxFileSizeInMB := 50;
    GlobalLogFileProvider.MaxRotateFiles := 20;
    GlobalLogFileProvider.AutoFlush := true;
    SetLogProviderDefaults (GlobalLogFileProvider, iApplicationType);
  end;
  GlobalLogFileProvider.Enabled := iAllowsLogFile;
  // Log loggger status
  if GlobalLogFileProvider.Enabled then
    Log ('File Log Provider activated (%s)', [GlobalLogFileProvider.FileName], etInfo)
  else
    Log ('File Log Provider not activated (%s)', [GlobalLogFileProvider.FileName], etInfo);
  if GlobalLogConsoleProvider.Enabled then
    Log ('Console Log Provider activate', etInfo);
end;

constructor tJson2PumlLogHandler.Create;
begin
  FErrorList := tJson2PumlErrorList.Create ();
  Clear;
end;

destructor tJson2PumlLogHandler.Destroy;
begin
  FErrorList.Free;
  inherited Destroy;
end;

procedure tJson2PumlLogHandler.Clear;
begin
  ErrorList.Clear;
  GlobalLogStringListProvider.Clear;
end;

procedure tJson2PumlLogHandler.Debug (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etDebug);
end;

procedure tJson2PumlLogHandler.Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etDebug);
end;

procedure tJson2PumlLogHandler.DebugParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
const aTag: string = '');
begin
  LogMsg ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etDebug);
end;

procedure tJson2PumlLogHandler.Error (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etError);
  ErrorList.AddErrorWarning (jetUnknown, aMessage);
end;

procedure tJson2PumlLogHandler.Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etError);
  ErrorList.AddErrorWarning (jetUnknown, Format(aMessage, aParams));
end;

procedure tJson2PumlLogHandler.Error (const aErrorType: tJson2PumlErrorType; const aTag: string = '');
begin
  LogMsg (aErrorType.ErrorMessage, aErrorType.EventType);
  ErrorList.AddErrorWarning (aErrorType, aErrorType.ErrorMessage);
end;

procedure tJson2PumlLogHandler.Error (const aErrorType: tJson2PumlErrorType; const aParams: array of TVarRec;
const aTag: string = '');
begin
  LogMsg (aErrorType.ErrorMessage, aParams, aErrorType.EventType);
  ErrorList.AddErrorWarning (aErrorType, Format(aErrorType.ErrorMessage, aParams));
end;

function tJson2PumlLogHandler.GetFailed: boolean;
begin
  Result := ErrorList.Failed;
end;

procedure tJson2PumlLogHandler.Header (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etHeader);
end;

procedure tJson2PumlLogHandler.Header (const aMessage: string; const aParams: array of TVarRec;
const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etHeader);
end;

procedure tJson2PumlLogHandler.Info (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etInfo);
end;

procedure tJson2PumlLogHandler.Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etInfo);
end;

procedure tJson2PumlLogHandler.InfoParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
const aTag: string = '');
begin
  LogMsg ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etInfo);
end;

procedure tJson2PumlLogHandler.LogMsg (const aMsg: string; aValues: array of TVarRec; aEventType: tEventType);
begin
  LogMsg (Format(aMsg, aValues), aEventType);
end;

procedure tJson2PumlLogHandler.LogMsg (const aMsg: string; aEventType: tEventType);
begin
  if aMsg.IndexOf ('GET:/api/heartbeat') < 0 then
    Log (aMsg, aEventType);
end;

procedure tJson2PumlLogHandler.Trace (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etTrace);
end;

procedure tJson2PumlLogHandler.Trace (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etTrace);
end;

procedure tJson2PumlLogHandler.UnhandledException (aException: Exception);
begin
  Error (jetException, [aException.ClassName, aException.Message, aException.StackTrace]);
end;

procedure tJson2PumlLogHandler.Warn (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etWarning);
  ErrorList.AddErrorWarning (jetWarning, aMessage);
end;

procedure tJson2PumlLogHandler.Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etWarning);
  ErrorList.AddErrorWarning (jetWarning, Format(aMessage, aParams));
end;

constructor tJson2PumlErrorList.Create;
begin
  inherited Create;
  FLock := tCriticalSection.Create ();
  OwnsObjects := true;
end;

destructor tJson2PumlErrorList.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure tJson2PumlErrorList.AddErrorWarning (const aErrorType: tJson2PumlErrorType; const aMessage: string);
var
  ErrorRecord: tJson2PumlErrorRecord;
begin
  Lock.Acquire;
  try
    ErrorRecord := tJson2PumlErrorRecord.Create;
    ErrorRecord.ErrorType := aErrorType;
    ErrorRecord.ErrorMessage := aMessage;
    ErrorRecord.ThreadId := CurrentThreadId;
    AddObject (ErrorRecord.ErrorMessage, ErrorRecord);
  finally
    Lock.Release;
  end;
end;

procedure tJson2PumlErrorList.Clear;
var
  i: integer;
  ErrorRecord: tJson2PumlErrorRecord;
  ThreadId: tThreadID;
begin
  Lock.Acquire;
  try
    ThreadId := CurrentThreadId;
    i := 0;
    while i < Count do
    begin
      ErrorRecord := tJson2PumlErrorRecord (Objects[i]);
      if Assigned (ErrorRecord) and (ErrorRecord.ThreadId = ThreadId) then
        Delete (i)
      else
        Inc (i);
    end;
  finally
    Lock.Release;
  end;
end;

function tJson2PumlErrorList.GetFailed: boolean;
var
  i: integer;
  ErrorRecord: tJson2PumlErrorRecord;
  ThreadId: tThreadID;
begin
  Lock.Acquire;
  try
    ThreadId := CurrentThreadId;
    Result := false;
    for i := 0 to Count - 1 do
    begin
      ErrorRecord := tJson2PumlErrorRecord (Objects[i]);
      if Assigned (ErrorRecord) and (ErrorRecord.ThreadId = ThreadId) then
        Result := Result or ErrorRecord.ErrorType.Failed;
    end;
  finally
    Lock.Release;
  end;
end;

procedure tJson2PumlErrorList.RenderErrorReponseFromErrorList (var oResponseText: string; var oHttpCode: integer);
var
  MaxHttpCode: integer;
  i: integer;
  ErrorRecord: tJson2PumlErrorRecord;
  JsonResult: tStringList;
  ThreadId: tThreadID;

begin
  Lock.Acquire;
  try
    ThreadId := CurrentThreadId;
    JsonResult := tStringList.Create;
    try
      MaxHttpCode := 0;
      WriteArrayStartToJson (JsonResult, 0, '');
      i := 0;
      while i < Count do
      begin
        ErrorRecord := tJson2PumlErrorRecord (Objects[i]);
        if not Assigned (ErrorRecord) then
        begin
          Delete (i);
          Continue;
        end;
        if ErrorRecord.ThreadId <> ThreadId then
        begin
          Inc (i);
          Continue;
        end;
        if ErrorRecord.ErrorType.HttpStatusCode > MaxHttpCode then
          MaxHttpCode := ErrorRecord.ErrorType.HttpStatusCode;
        ErrorRecord.ErrorType.RenderErrorResponse (JsonResult, 1, GlobalLogHandler.ErrorList[i]);
        Delete (i);
      end;
      if MaxHttpCode = 0 then
      begin
        MaxHttpCode := HTTP_STATUS.InternalServerError;
        jetUnknownServerError.RenderErrorResponse (JsonResult, 1);
      end;
      WriteArrayEndToJson (JsonResult, 0);
      oResponseText := JsonResult.Text;
      oHttpCode := MaxHttpCode;
    finally
      JsonResult.Free;
    end;
  finally
    Lock.Release;
  end;
end;

initialization

InitializationGlobalLogHandler;

finalization

FinalizationGlobalLogHandler;

end.
