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
    FThreadId: TThreadID;
  public
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property ErrorType: tJson2PumlErrorType read FErrorType write FErrorType;
    property ThreadId: TThreadID read FThreadId write FThreadId;
  end;

  TJson2PumlErrorList = class(tStringList)
  private
    FLock: TCriticalSection;
    function GetFailed: Boolean;
  protected
    property Lock: TCriticalSection read FLock;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddErrorWarning (const aErrorType: tJson2PumlErrorType; const aMessage: string);
    procedure Clear; override;
    procedure RenderErrorReponseFromErrorList (var oResponseText: string; var oHttpCode: Integer);
    property Failed: Boolean read GetFailed;
  end;

  TJson2PumlLogHandler = class(tPersistent)
  private
    FErrorList: TJson2PumlErrorList;
    function GetFailed: Boolean;
  protected
    procedure LogMsg (const aMsg: string; aValues: array of TVarRec; aEventType: TEventType); overload;
    procedure LogMsg (const aMsg: string; aEventType: TEventType); overload;
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
    property ErrorList: TJson2PumlErrorList read FErrorList;
    property Failed: Boolean read GetFailed;
  end;

function GlobalLogHandler: TJson2PumlLogHandler;

procedure InitDefaultLogger (iLogFilePath: string; iApplicationType: tJson2PumlApplicationType;
  iAllowsConsole, iAllowsLogFile: Boolean);

procedure SetLogProviderDefaults (iProvider: TLogProviderBase; iApplicationType: tJson2PumlApplicationType);

implementation

uses
  Quick.Logger.Provider.Files, Quick.Logger.Provider.Console, System.IOUtils,
  Quick.Logger.Provider.StringList,
  {.$IFDEF DEBUG} Quick.Logger.UnhandledExceptionHook, Quick.Logger.ExceptionHook, Quick.Logger.RuntimeErrorHook,
  {.$ENDIF}
  json2pumldefinition, json2pumlbasedefinition, jsontools,
  MVCFramework.Commons, json2pumltools;

var
  IntGlobalLogHandler: TJson2PumlLogHandler;

function GlobalLogHandler: TJson2PumlLogHandler;
begin
  Result := IntGlobalLogHandler;
end;

procedure InitializationGlobalLogHandler;
begin
  IntGlobalLogHandler := TJson2PumlLogHandler.Create;
end;

procedure FinalizationGlobalLogHandler;
begin
  IntGlobalLogHandler.Free;
end;

procedure SetLogProviderEventTypeNames (iProvider: TLogProviderBase);
var
  et: TEventType;
begin
  for et := low(TEventType) to high(TEventType) do
    iProvider.EventTypeName[et] := JSON2PUML_EVENTTYPENAMES[Integer(et)];
end;

procedure SetLogProviderDefaults (iProvider: TLogProviderBase; iApplicationType: tJson2PumlApplicationType);
  procedure SetCustomFormat (iLogProvider: TLogProviderBase);
  begin
    iLogProvider.CustomMsgOutput := True;
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
  iProvider.TimePrecission := True;
  iProvider.IncludedInfo := [iiAppName, iiHost, iiUserName, iiEnvironment, iiPlatform, iiOSVersion, iiExceptionInfo,
    iiExceptionStackTrace];
  SetLogProviderEventTypeNames (iProvider);
  SetCustomFormat (iProvider);
end;

procedure InitDefaultLogger (iLogFilePath: string; iApplicationType: tJson2PumlApplicationType;
  iAllowsConsole, iAllowsLogFile: Boolean);

var
  LogFileName: string;

begin
  GlobalLogFileProvider.Enabled := False;
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
    GlobalLogFileProvider.DailyRotate := True;
    GlobalLogFileProvider.DailyRotateFileDateFormat := 'yyyymmdd';
    GlobalLogFileProvider.MaxFileSizeInMB := 50;
    GlobalLogFileProvider.MaxRotateFiles := 20;
    GlobalLogFileProvider.AutoFlush := True;
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

constructor TJson2PumlLogHandler.Create;
begin
  FErrorList := TJson2PumlErrorList.Create ();
  Clear;
end;

destructor TJson2PumlLogHandler.Destroy;
begin
  FErrorList.Free;
  inherited Destroy;
end;

procedure TJson2PumlLogHandler.Clear;
begin
  ErrorList.Clear;
  if Assigned (GlobalLogStringListProvider) then
    GlobalLogStringListProvider.Clear;
end;

procedure TJson2PumlLogHandler.Debug (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etDebug);
end;

procedure TJson2PumlLogHandler.Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etDebug);
end;

procedure TJson2PumlLogHandler.DebugParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
  const aTag: string = '');
begin
  LogMsg ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etDebug);
end;

procedure TJson2PumlLogHandler.Error (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etError);
  ErrorList.AddErrorWarning (jetUnknown, aMessage);
end;

procedure TJson2PumlLogHandler.Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etError);
  ErrorList.AddErrorWarning (jetUnknown, Format(aMessage, aParams));
end;

procedure TJson2PumlLogHandler.Error (const aErrorType: tJson2PumlErrorType; const aTag: string = '');
begin
  LogMsg (aErrorType.ErrorMessage, aErrorType.EventType);
  ErrorList.AddErrorWarning (aErrorType, aErrorType.ErrorMessage);
end;

procedure TJson2PumlLogHandler.Error (const aErrorType: tJson2PumlErrorType; const aParams: array of TVarRec;
  const aTag: string = '');
begin
  LogMsg (aErrorType.ErrorMessage, aParams, aErrorType.EventType);
  ErrorList.AddErrorWarning (aErrorType, Format(aErrorType.ErrorMessage, aParams));
end;

function TJson2PumlLogHandler.GetFailed: Boolean;
begin
  Result := ErrorList.Failed;
end;

procedure TJson2PumlLogHandler.Header (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etHeader);
end;

procedure TJson2PumlLogHandler.Header (const aMessage: string; const aParams: array of TVarRec;
  const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etHeader);
end;

procedure TJson2PumlLogHandler.Info (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etInfo);
end;

procedure TJson2PumlLogHandler.Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etInfo);
end;

procedure TJson2PumlLogHandler.InfoParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
  const aTag: string = '');
begin
  LogMsg ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etInfo);
end;

procedure TJson2PumlLogHandler.LogMsg (const aMsg: string; aValues: array of TVarRec; aEventType: TEventType);
begin
  Log (aMsg, aValues, aEventType);
end;

procedure TJson2PumlLogHandler.LogMsg (const aMsg: string; aEventType: TEventType);
begin
  Log (aMsg, aEventType);
end;

procedure TJson2PumlLogHandler.Trace (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etTrace);
end;

procedure TJson2PumlLogHandler.Trace (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etTrace);
end;

procedure TJson2PumlLogHandler.UnhandledException (aException: Exception);
begin
  Error (jetException, [aException.ClassName, aException.Message, aException.StackTrace]);
end;

procedure TJson2PumlLogHandler.Warn (const aMessage: string; const aTag: string = '');
begin
  LogMsg (aMessage, etWarning);
  ErrorList.AddErrorWarning (jetWarning, aMessage);
end;

procedure TJson2PumlLogHandler.Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  LogMsg (aMessage, aParams, etWarning);
  ErrorList.AddErrorWarning (jetWarning, Format(aMessage, aParams));
end;

constructor TJson2PumlErrorList.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create ();
  OwnsObjects := True;
end;

destructor TJson2PumlErrorList.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

procedure TJson2PumlErrorList.AddErrorWarning (const aErrorType: tJson2PumlErrorType; const aMessage: string);
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

procedure TJson2PumlErrorList.Clear;
var
  i: Integer;
  ErrorRecord: tJson2PumlErrorRecord;
  ThreadId: TThreadID;
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

function TJson2PumlErrorList.GetFailed: Boolean;
var
  i: Integer;
  ErrorRecord: tJson2PumlErrorRecord;
  ThreadId: TThreadID;
begin
  Lock.Acquire;
  try
    ThreadId := CurrentThreadId;
    Result := False;
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

procedure TJson2PumlErrorList.RenderErrorReponseFromErrorList (var oResponseText: string; var oHttpCode: Integer);
var
  MaxHttpCode: Integer;
  i: Integer;
  ErrorRecord: tJson2PumlErrorRecord;
  JsonResult: tStringList;
  ThreadId: TThreadID;

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
