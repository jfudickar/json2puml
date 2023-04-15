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

unit json2pumlservicecontroller;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons, System.Classes, System.SyncObjs,
  json2pumlinputhandler;

type

  [MVCPath('/api')]
  TJson2PumlController = class(TMVCController)
  private
  protected
    function GetCurlTracePassThroughHeader (iContext: TWebContext): string;
    procedure OnBeforeAction (Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction (Context: TWebContext; const AActionName: string); override;
    procedure GetFileListResponse (iFileList: tstringlist; iInputList: Boolean);
    procedure LogRequestStart (iContext: TWebContext);
    procedure LogRequestEnd (iContext: TWebContext);
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/inputlistfile')]
    [MVCHTTPMethod([httpGET])]
    procedure GetInputListFile;
    [MVCPath('/definitionfile')]
    [MVCHTTPMethod([httpGET])]
    procedure GetDefinitionFiles;

    [MVCPath('/json2pumlRequestSvg')]
    [MVCHTTPMethod([httpPOST])]
    procedure HandleJson2PumlRequestSvg;

    [MVCPath('/json2pumlRequestPng')]
    [MVCHTTPMethod([httpPOST])]
    procedure HandleJson2PumlRequestPng;

    [MVCPath('/json2pumlRequestZip')]
    [MVCHTTPMethod([httpPOST])]
    procedure HandleJson2PumlRequestZip;

    [MVCPath('/json2pumlRequest')]
    [MVCHTTPMethod([httpPOST])]
    procedure HandleJson2PumlRequest;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, json2pumlconverter, json2pumldefinition,
  json2pumlconst, jsontools, json2pumlbasedefinition,
  json2pumlconverterdefinition, json2pumltools, json2pumlloghandler, System.IOUtils, IdHTTPWebBrokerBridge,
  IdHTTPHeaderInfo;

type
  TIdHTTPAppRequestHelper = class helper for TIdHTTPAppRequest
  public
    function GetRequestInfo: TIdEntityHeaderInfo;
  end;

function TIdHTTPAppRequestHelper.GetRequestInfo: TIdEntityHeaderInfo;
begin
  Result := FRequestInfo;
end;

function TJson2PumlController.GetCurlTracePassThroughHeader (iContext: TWebContext): string;
var
  s, v: string;

  procedure AddHeader (iName, iValue: string);
  begin
    if not iName.IsEmpty and not iValue.IsEmpty then
      Result := TCurlUtils.CombineParameter([Result, TCurlUtils.CalculateHeaderParameter(iName, iValue)]);
  end;

begin
  Result := '';
  for s in GlobalConfigurationDefinition.CurlPassThroughHeader do
  begin
    v := iContext.Request.Headers[s];
    AddHeader (s, v);
  end;
end;

procedure TJson2PumlController.GetDefinitionFiles;
begin
  GetFileListResponse (GlobalConfigurationDefinition.DefinitionFileSearchFolder, false);
end;

procedure TJson2PumlController.GetFileListResponse (iFileList: tstringlist; iInputList: Boolean);
var
  jsonOutput: tstringlist;
begin
  LogRequestStart (Context);
  jsonOutput := tstringlist.Create;
  try
    try
      Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
      GetServiceFileListResponse (jsonOutput, iFileList, iInputList);
      Render (jsonOutput.Text);
      Context.Response.StatusCode := HTTP_STATUS.OK;
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    jsonOutput.Free;
  end;
  LogRequestEnd (Context);
end;

procedure TJson2PumlController.GetInputListFile;
begin
  GetFileListResponse (GlobalConfigurationDefinition.InputListFileSearchFolder, true);
end;

procedure TJson2PumlController.Index;
begin
  // use Context property to access to the HTTP request and response
  Render ('** JSON2PUML Server ** ' + FileVersion);
end;

procedure TJson2PumlController.OnAfterAction (Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
  GlobalFileDeleteHandler.DeleteFiles;
end;

procedure TJson2PumlController.OnBeforeAction (Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

procedure TJson2PumlController.HandleJson2PumlRequest;
var
  InputHandler: TJson2PumlInputHandler;
begin
  LogRequestStart (Context);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      InputHandler.CmdLineParameter.CurlPassThroughHeader := GetCurlTracePassThroughHeader (Context);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
        Render (InputHandler.ServerResultLines.Text);
        Context.Response.StatusCode := HTTP_STATUS.OK;
      end
      else
      begin
        RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, ClearJsonPropertyValue(e.Message));
      end;
    end;
  finally
    InputHandler.Free;
  end;
  LogRequestEnd (Context);
end;

procedure TJson2PumlController.HandleJson2PumlRequestPng;
var
  InputHandler: TJson2PumlInputHandler;
  f: tJson2PumlInputFileDefinition;
begin
  LogRequestStart (Context);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.GenerateDetailsStr := 'false';
      InputHandler.CmdLineParameter.GenerateSummaryStr := 'true';
      InputHandler.CmdLineParameter.OutputFormatStr := jofPng.ToString;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      InputHandler.CmdLineParameter.CurlPassThroughHeader := GetCurlTracePassThroughHeader (Context);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        f := InputHandler.ConverterInputList.SummaryInputFile;
        if Assigned (f) and f.Exists then
        begin
          Context.Response.ContentType := TMVCMediaType.IMAGE_PNG;
          SendFile (f.Output.PNGFileName);
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, ClearJsonPropertyValue(e.Message));
      end;
    end;
  finally
    InputHandler.Free;
  end;
  LogRequestEnd (Context);
end;

procedure TJson2PumlController.HandleJson2PumlRequestSvg;
var
  InputHandler: TJson2PumlInputHandler;
  f: tJson2PumlInputFileDefinition;
begin
  LogRequestStart (Context);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.GenerateDetailsStr := 'false';
      InputHandler.CmdLineParameter.GenerateSummaryStr := 'true';
      InputHandler.CmdLineParameter.OutputFormatStr := jofSvg.ToString;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      InputHandler.CmdLineParameter.CurlPassThroughHeader := GetCurlTracePassThroughHeader (Context);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        f := InputHandler.ConverterInputList.SummaryInputFile;
        if Assigned (f) and f.Exists then
        begin
          Context.Response.ContentType := TMVCMediaType.APPLICATION_SVG_XML;
          SendFile (f.Output.SVGFileName);
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, ClearJsonPropertyValue(e.Message));
      end;
    end;
  finally
    InputHandler.Free;
  end;
  LogRequestEnd (Context);
end;

procedure TJson2PumlController.HandleJson2PumlRequestZip;
var
  InputHandler: TJson2PumlInputHandler;
begin
  LogRequestStart (Context);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      InputHandler.CmdLineParameter.CurlPassThroughHeader := GetCurlTracePassThroughHeader (Context);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        if not FileExists (InputHandler.ConverterInputList.SummaryZipFileName) then
          InputHandler.GenerateSummaryZipFile;
        if FileExists (InputHandler.ConverterInputList.SummaryZipFileName) then
        begin
          Context.Response.ContentType := 'application/zip';
          SendFile (InputHandler.ConverterInputList.SummaryZipFileName);
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, ClearJsonPropertyValue(GlobalLoghandler.ErrorWarningList.Text));
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, ClearJsonPropertyValue(e.Message));
      end;
    end;
  finally
    InputHandler.Free;
  end;
  LogRequestEnd (Context);
end;

procedure TJson2PumlController.LogRequestEnd (iContext: TWebContext);
begin
  GlobalLoghandler.Trace ('%s stopped - Result : %d', [Context.Request.PathInfo, Context.Response.StatusCode]);
  GlobalLoghandler.Trace (''.PadLeft(60, '-'));
end;

procedure TJson2PumlController.LogRequestStart (iContext: TWebContext);
//var
//  Name: string;
//  I: Integer;

begin
  GlobalLoghandler.Trace ('%s started', [Context.Request.PathInfo]);
// Deactivated because of critical data which can be in header or body (e.g. Curl Authentication Parameter)
// Should only be activated if realy needed for testing
//  if Context.Request.RawWebRequest is TIdHTTPAppRequest then
//  begin
//    for I := 0 to TIdHTTPAppRequest(Context.Request.RawWebRequest).GetRequestInfo.RawHeaders.Count - 1 do
//    begin
//      name := TIdHTTPAppRequest (Context.Request.RawWebRequest).GetRequestInfo.RawHeaders.Names[I];
//      GlobalLoghandler.Debug  ('Header %s : %s', [name, Context.Request.Headers[name]]);
//    end;
//    if not Context.Request.Body.IsEmpty then
//      GlobalLoghandler.Debug ('Body : %s ', [Context.Request.Body]);
//  end;
end;

end.
