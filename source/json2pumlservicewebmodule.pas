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

unit json2pumlservicewebmodule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, MVCFramework, LoggerPro;

type
  TJson2PumlLoggerProLogWriter = class(TLogWriter, ILogWriter)
  strict private
  protected
  public
    procedure Debug (const aMessage: string; const aTag: string); overload;
    procedure Debug (const aMessage: string; const aParams: array of TVarRec; const aTag: string); overload;
    procedure DebugFmt (const aMessage: string; const aParams: array of TVarRec; const aTag: string); deprecated;
    procedure Error (const aMessage: string; const aTag: string); overload;
    procedure Error (const aMessage: string; const aParams: array of TVarRec; const aTag: string); overload;
    procedure ErrorFmt (const aMessage: string; const aParams: array of TVarRec; const aTag: string); deprecated;
    procedure Info (const aMessage: string; const aTag: string); overload;
    procedure Info (const aMessage: string; const aParams: array of TVarRec; const aTag: string); overload;
    procedure InfoFmt (const aMessage: string; const aParams: array of TVarRec; const aTag: string); deprecated;
    procedure Log (const aType: TLogType; const aMessage: string; const aTag: string); overload;
    procedure Log (const aType: TLogType; const aMessage: string; const aParams: array of const;
      const aTag: string); overload;
    procedure LogFmt (const aType: TLogType; const aMessage: string; const aParams: array of const; const aTag: string);
      deprecated;
    procedure Warn (const aMessage: string; const aTag: string); overload;
    procedure Warn (const aMessage: string; const aParams: array of TVarRec; const aTag: string); overload;
    procedure WarnFmt (const aMessage: string; const aParams: array of TVarRec; const aTag: string); deprecated;
  end;

  TJson2PumlWebModule = class(TWebModule)
    procedure WebModuleCreate (Sender: TObject);
    procedure WebModuleDestroy (Sender: TObject);
  private
    FMVC: TMVCEngine;
    FLogWriter: TJson2PumlLoggerProLogWriter;
  public
    { Public declarations }
  end;

var
  Json2PumlWebModuleClass: TComponentClass = TJson2PumlWebModule;

implementation

{$R *.dfm}

uses
  json2pumlservicecontroller, System.IOUtils, LoggerPro.Proxy, MVCFramework.Commons, json2pumlloghandler,
  MVCFramework.Logger;

procedure TJson2PumlWebModule.WebModuleCreate (Sender: TObject);
begin
  SetDefaultLogger (TLogWriterDecorator.Build(CreateLoggerWithDefaultConfiguration,
    function(const aType: TLogType; const aMessage, aTag: string): Boolean
    begin
      Result := false;
    end));

  FMVC := TMVCEngine.Create (Self,
    procedure(Config: TMVCConfig)
    begin
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      // default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      // default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      // unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      // enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := 'true';
      // default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      // view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      // Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      // Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := 'true';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
      // Server Name
      Config[TMVCConfigKey.ServerName] := 'JSON2PUML Server';
    end);
  FMVC.AddController (TJson2PumlController);



  // Analytics middleware generates a csv log, useful to do trafic analysis
  // FMVC.AddMiddleware(TMVCAnalyticsMiddleware.Create(GetAnalyticsDefaultLogger));

  // The folder mapped as documentroot for TMVCStaticFilesMiddleware must exists!
  // FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create('/static', TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www')));

  // Trace middlewares produces a much detailed log for debug purposes
  // FMVC.AddMiddleware(TMVCTraceMiddleware.Create);

  // CORS middleware handles... well, CORS
  // FMVC.AddMiddleware(TMVCCORSMiddleware.Create);

  // Simplifies TMVCActiveRecord connection definition
  // FMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create('MyConnDef','FDConnectionDefs.ini'));

  // Compression middleware must be the last in the chain, just before the ETag, if present.
  // FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);

  // ETag middleware must be the latest in the chain
  // FMVC.AddMiddleware(TMVCETagMiddleware.Create);

end;

procedure TJson2PumlWebModule.WebModuleDestroy (Sender: TObject);
begin
  FMVC.Free;
  FLogWriter.Free;
end;

procedure TJson2PumlLoggerProLogWriter.Debug (const aMessage: string; const aTag: string);
begin
  GlobalLogHandler.Debug (aMessage, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Debug (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Debug (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.DebugFmt (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Debug (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Error (const aMessage: string; const aTag: string);
begin
  GlobalLogHandler.Error (aMessage, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Error (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Error (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.ErrorFmt (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Error (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Info (const aMessage: string; const aTag: string);
begin
  GlobalLogHandler.Info (aMessage, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Info (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Info (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.InfoFmt (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Info (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Log (const aType: TLogType; const aMessage: string; const aTag: string);
begin
  Log (aType, aMessage, [], aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Log (const aType: TLogType; const aMessage: string;
const aParams: array of const; const aTag: string);
begin
  case aType of
    TLogType.Debug:
      GlobalLogHandler.Debug (aMessage, aParams, aTag);
    TLogType.Info:
      GlobalLogHandler.Info (aMessage, aParams, aTag);
    TLogType.Warning:
      GlobalLogHandler.Warn (aMessage, aParams, aTag);
    TLogType.Error:
      GlobalLogHandler.Error (aMessage, aParams, aTag);
    else
      GlobalLogHandler.Info (aMessage, aParams, aTag);
  end;
end;

procedure TJson2PumlLoggerProLogWriter.LogFmt (const aType: TLogType; const aMessage: string;
const aParams: array of const; const aTag: string);
begin
  Log (aType, aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Warn (const aMessage: string; const aTag: string);
begin
  GlobalLogHandler.Warn (aMessage, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.Warn (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Warn (aMessage, aParams, aTag);
end;

procedure TJson2PumlLoggerProLogWriter.WarnFmt (const aMessage: string; const aParams: array of TVarRec;
const aTag: string);
begin
  GlobalLogHandler.Warn (aMessage, aParams, aTag);
end;

end.
