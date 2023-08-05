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
unit json2pumlwinservice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  IdHTTPWebBrokerBridge;

type
  TJ2PWinService = class(TService)
    procedure ServiceCreate (Sender: TObject);
    procedure ServiceExecute (Sender: TService);
    procedure ServiceStart (Sender: TService; var Started: Boolean);
    procedure ServiceStop (Sender: TService; var Stopped: Boolean);
  private
    { Private-Deklarationen }
    fServer: TIdHTTPWebBrokerBridge;
  public
    function GetServiceController: TServiceController; override;
    { Public-Deklarationen }
  end;

var
  J2PWinService: TJ2PWinService;

implementation

uses
  json2pumlloghandler, json2pumldefinition, json2pumlservicewebmodule, Web.WebReq, json2pumlconst, MVCFramework.Commons;

{$R *.dfm}

procedure ServiceController (CtrlCode: DWord); stdcall;
begin
  J2PWinService.Controller (CtrlCode);
end;

procedure TJ2PWinService.ServiceCreate (Sender: TObject);
begin
  InitDefaultLogger (GlobalConfigurationDefinition.LogFileOutputPath, jatWinService, false, true);
  GlobalLogHandler.Info ('Service Created');
  GlobalConfigurationDefinition.LogConfiguration;
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := Json2PumlWebModuleClass;
  WebRequestHandlerProc.MaxConnections := 1024;
end;

function TJ2PWinService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TJ2PWinService.ServiceExecute (Sender: TService);
begin
  while not Terminated do
  begin
    ServiceThread.ProcessRequests (true);
    Sleep (500);
  end;
end;

procedure TJ2PWinService.ServiceStart (Sender: TService; var Started: Boolean);
begin
  fServer := TIdHTTPWebBrokerBridge.Create (nil);
  fServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
  fServer.DefaultPort := GlobalConfigurationDefinition.ServicePort;
  GlobalLogHandler.Info ('Service Started');
  GlobalLogHandler.Info ('Listening to port %d', [GlobalConfigurationDefinition.ServicePort]);
  fServer.KeepAlive := true;

  { more info about MaxConnections
    http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
  fServer.MaxConnections := 0;

  { more info about ListenQueue
    http://ww2.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=index.html }
  fServer.ListenQueue := 200;

  fServer.Active := true;
end;

procedure TJ2PWinService.ServiceStop (Sender: TService; var Stopped: Boolean);
begin
  GlobalFileDeleteHandler.DeleteFiles;
  GlobalLogHandler.Info ('Service Stopped');
  fServer.Free;
end;

end.
