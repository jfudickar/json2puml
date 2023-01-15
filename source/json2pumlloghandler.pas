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

unit json2pumlloghandler;

interface

uses
  System.Classes, Quick.Logger, json2pumlconst;

type
  TJson2PumlLogHandler = class(tPersistent)
  private
    FErrorWarningList: tStringList;
    FFailed: boolean;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Debug (const aMessage: string; const aTag: string = ''); overload;
    procedure Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Info (const aMessage: string; const aTag: string = ''); overload;
    procedure Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Warn (const aMessage: string; const aTag: string = ''); overload;
    procedure Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Error (const aMessage: string; const aTag: string = ''); overload;
    procedure Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure AddErrorWarning (const aType, aMessage: string); overload;
    procedure AddErrorWarning (const aType, aMessage: string; const aParams: array of TVarRec); overload;
    procedure Clear;
    procedure Header (const aMessage: string; const aTag: string = ''); overload;
    procedure Header (const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure Trace(const aMessage: string; const aTag: string = ''); overload;
    procedure Trace(const aMessage: string; const aParams: array of TVarRec; const aTag: string = ''); overload;
    procedure InfoParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
      const aTag: string = ''); overload;
    procedure InfoParameter1(const aParameterPrefix, aParameterName, aParameterValue: string; const aTag: string = '');
        overload;
    property ErrorWarningList: tStringList read FErrorWarningList;
    property Failed: boolean read FFailed;
  end;

procedure InitDefaultLogger (iLogFilePath: string; iIsService, iAllowsConsole: boolean);

procedure SetLogProviderEventTypeNames (iProvider: TLogProviderBase);

function GlobalLogHandler: TJson2PumlLogHandler;

implementation

uses
  System.SysUtils, Quick.Logger.Provider.Files, Quick.Logger.Provider.Console, System.IOUtils;

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

procedure InitDefaultLogger (iLogFilePath: string; iIsService, iAllowsConsole: boolean);
begin
  // _DefaultLogger := BuildLogWriter ([TLoggerProFileAppender.Create(5, 1000, iLogFilePath)]);
  Logger.Providers.Add (GlobalLogFileProvider);
  Logger.Providers.Add (GlobalLogConsoleProvider);

  // Configure console provider options
  if iIsService and iAllowsConsole then
    GlobalLogConsoleProvider.LogLevel := LOG_TRACE - [etInfo] + [etError]
  else
    GlobalLogConsoleProvider.LogLevel := LOG_DEBUG;

  GlobalLogConsoleProvider.ShowEventColors := True;
  SetLogProviderEventTypeNames (GlobalLogConsoleProvider);
  GlobalLogConsoleProvider.Enabled := iAllowsConsole;


  if not TDirectory.Exists(iLogFilePath) then
    TDirectory.CreateDirectory(iLogFilePath);

  // Configure file provider options
  GlobalLogFileProvider.FileName :=
    ExpandFileName (tPath.Combine(iLogFilePath, ChangeFileExt(ExtractFileName(ParamStr(0)), '.log')));
  GlobalLogFileProvider.DailyRotate := True;
  GlobalLogFileProvider.MaxFileSizeInMB := 20;
  GlobalLogFileProvider.LogLevel := LOG_DEBUG;
  GlobalLogFileProvider.TimePrecission := True;
  if iIsService then
  begin
    GlobalLogFileProvider.CustomMsgOutput := True;
    GlobalLogFileProvider.CustomFormatOutput := '%{DATETIME} - (%{THREADID}) - [%{LEVEL}] : %{MESSAGE}';
    GlobalLogFileProvider.IncludedInfo := GlobalLogFileProvider.IncludedInfo + [iiThreadId, iiProcessId];
  end;
  SetLogProviderEventTypeNames (GlobalLogFileProvider);
  GlobalLogFileProvider.Enabled := True;

  // Log loggger status
  if GlobalLogFileProvider.Enabled then
    log ('File Log Provider activated (%s)', [GlobalLogFileProvider.FileName], etInfo)
  else
    log ('File Log Provider not activated (%s)', [GlobalLogFileProvider.FileName], etError);
  if GlobalLogConsoleProvider.Enabled then
    log ('Console Log Provider activate', etInfo);
end;

constructor TJson2PumlLogHandler.Create;
begin
  FFailed := false;
  FErrorWarningList := tStringList.Create ();
end;

destructor TJson2PumlLogHandler.Destroy;
begin
  FErrorWarningList.Free;
  inherited Destroy;
end;

procedure TJson2PumlLogHandler.Debug (const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etDebug);
end;

procedure TJson2PumlLogHandler.Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  log (aMessage, aParams, etDebug);
end;

procedure TJson2PumlLogHandler.Error (const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etError);
  AddErrorWarning ('Error', aMessage);
  FFailed := True;
end;

procedure TJson2PumlLogHandler.Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  log (aMessage, aParams, etError);
  AddErrorWarning ('Error', aMessage, aParams);
  FFailed := True;
end;

procedure TJson2PumlLogHandler.AddErrorWarning (const aType, aMessage: string);
begin
  ErrorWarningList.Add (Format('%s: %s', [aType, aMessage]));
end;

procedure TJson2PumlLogHandler.AddErrorWarning (const aType, aMessage: string; const aParams: array of TVarRec);
begin
  ErrorWarningList.Add (Format('%s: %s', [aType, Format(aMessage, aParams)]));
end;

procedure TJson2PumlLogHandler.Clear;
begin
  ErrorWarningList.Clear;
  FFailed := false;
end;

procedure TJson2PumlLogHandler.Header (const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etHeader);
end;

procedure TJson2PumlLogHandler.Header (const aMessage: string; const aParams: array of TVarRec;
  const aTag: string = '');
begin
  log (aMessage, aParams, etHeader);
end;

procedure TJson2PumlLogHandler.Info (const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etInfo);
end;

procedure TJson2PumlLogHandler.Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  log (aMessage, aParams, etInfo);
end;

procedure TJson2PumlLogHandler.Trace(const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etTrace);
end;

procedure TJson2PumlLogHandler.Trace(const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  log (aMessage, aParams, etTrace);
end;

procedure TJson2PumlLogHandler.InfoParameter (const aParameterPrefix, aParameterName, aParameterValue: string;
  const aTag: string = '');
begin
  log ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etInfo);
end;

procedure TJson2PumlLogHandler.InfoParameter1(const aParameterPrefix, aParameterName, aParameterValue: string; const
    aTag: string = '');
begin
  log ('  %-45s %s', [Format('%s%s', [aParameterPrefix, aParameterName]).Trim, aParameterValue], etInfo);
end;

procedure TJson2PumlLogHandler.Warn (const aMessage: string; const aTag: string = '');
begin
  log (aMessage, etWarning);
  AddErrorWarning ('Warning', aMessage);
end;

procedure TJson2PumlLogHandler.Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string = '');
begin
  log (aMessage, aParams, etWarning);
  AddErrorWarning ('Warning', aMessage, aParams);
end;

initialization

InitializationGlobalLogHandler;

finalization

FinalizationGlobalLogHandler;

end.
