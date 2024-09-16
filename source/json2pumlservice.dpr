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

program json2pumlservice;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.Signal,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IdHTTPWebBrokerBridge,
  json2pumldefinition in 'json2pumldefinition.pas',
  json2pumlconverter in 'json2pumlconverter.pas',
  json2pumltools in 'json2pumltools.pas',
  json2pumlpuml in 'json2pumlpuml.pas',
  json2pumlconst in 'json2pumlconst.pas',
  jsontools in 'jsontools.pas',
  json2pumlinputhandler in 'json2pumlinputhandler.pas',
  json2pumlservicecontroller in 'json2pumlservicecontroller.pas',
  json2pumlservicewebmodule in 'json2pumlservicewebmodule.pas' {Json2PumlWebModule: TWebModule} ,
  json2pumlbasedefinition in 'json2pumlbasedefinition.pas',
  json2pumlconverterdefinition in 'json2pumlconverterdefinition.pas',
  json2pumlloghandler in 'json2pumlloghandler.pas';

{$R *.res}

procedure RunServer (APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
begin
  InitDefaultLogger (GlobalConfigurationDefinition.LogFileOutputPath, jatService, true,
    not FindCmdLineSwitch(cNoLogFiles, true));
  GlobalLogHandler.Trace ('** JSON2PUML Server ** ' + FileVersion);
  GlobalCommandLineParameter.ReadInputParameter;
  GlobalConfigurationDefinition.LogConfiguration;
  LServer := TIdHTTPWebBrokerBridge.Create (nil);
  try
    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
    LServer.DefaultPort := APort;
    LServer.KeepAlive := true;

    { more info about MaxConnections
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
    LServer.ListenQueue := 200;

    LServer.Active := true;
    GlobalLogHandler.Trace ('Listening on port %d', [APort]);
    GlobalLogHandler.Trace ('CTRL+C to shutdown the server');
    WaitForTerminationSignal;
    EnterInShutdownState;
    LServer.Active := false;
    GlobalFileDeleteHandler.DeleteFiles;
  finally
    LServer.Free;
  end;
end;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  IsMultiThread := true;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := Json2PumlWebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    if GlobalCommandLineParameter.ServicePort > 0 then
      RunServer (GlobalCommandLineParameter.ServicePort)
    else
      RunServer (GlobalConfigurationDefinition.ServicePort);
  except
    on E: Exception do
      GlobalLogHandler.UnhandledException (E);
  end;

end.
