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
    procedure OnBeforeAction (Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction (Context: TWebContext; const AActionName: string); override;
    procedure GetFileListResponse (iFileList: tstringlist; iInputList: Boolean);
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
  json2pumlconverterdefinition, json2pumltools, json2pumlloghandler, System.IOUtils;

procedure TJson2PumlController.GetDefinitionFiles;
begin
  GetFileListResponse (GlobalConfigurationDefinition.DefaultDefinitionFileFolder, false);
end;

procedure TJson2PumlController.GetFileListResponse (iFileList: tstringlist; iInputList: Boolean);
var
  jsonOutput: tstringlist;
  h: string;
  cnt: Integer;
begin
  jsonOutput := tstringlist.Create;
  try
    try
      Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
      GlobalLoghandler.Trace ('%s started from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      cnt := GetServiceFileListResponse (jsonOutput, iFileList, iInputList);
      GlobalLoghandler.Trace ('%d files found', [cnt]);
      Render (jsonOutput.Text);
      Context.Response.StatusCode := HTTP_STATUS.OK;
      GlobalLoghandler.Trace ('%s stopped from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      GlobalLoghandler.Trace (h.PadLeft(60, '-'));
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
end;

procedure TJson2PumlController.GetInputListFile;
begin
  GetFileListResponse (GlobalConfigurationDefinition.DefaultInputListFileFolder, true);
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
  h: string;
begin
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      GlobalLoghandler.Trace ('%s started from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      GlobalLoghandler.Trace (Context.Request.Body);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
        Render (InputHandler.ServerResultLines.Text);
        Context.Response.StatusCode := HTTP_STATUS.OK;
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, GlobalLoghandler.ErrorWarningList.Text);
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      GlobalLoghandler.Trace ('%s stopped from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      GlobalLoghandler.Trace (h.PadLeft(60, '-'));
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    InputHandler.Free;
  end;
end;

procedure TJson2PumlController.HandleJson2PumlRequestSvg;
var
  InputHandler: TJson2PumlInputHandler;
  f: tJson2PumlInputFileDefinition;
  h: string;
begin
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      GlobalLoghandler.Trace ('%s started from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.GenerateDetailsStr := 'false';
      InputHandler.CmdLineParameter.GenerateSummaryStr := 'true';
      InputHandler.CmdLineParameter.OutputFormatStr := jofSvg.ToString;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      GlobalLoghandler.Trace (Context.Request.Body);
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
          RenderStatusMessage (HTTP_STATUS.BadRequest, GlobalLoghandler.ErrorWarningList.Text);
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, GlobalLoghandler.ErrorWarningList.Text);
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      GlobalLoghandler.Trace ('%s stopped from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      GlobalLoghandler.Trace (h.PadLeft(60, '-'));
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    InputHandler.Free;
  end;
end;

procedure TJson2PumlController.HandleJson2PumlRequestZip;
var
  InputHandler: TJson2PumlInputHandler;
  h: string;
begin
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    try
      GlobalLoghandler.Trace ('%s started from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      GlobalLoghandler.Trace (Context.Request.Body);
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
          RenderStatusMessage (HTTP_STATUS.BadRequest, GlobalLoghandler.ErrorWarningList.Text);
      end
      else
      begin
        Context.Response.StatusCode := HTTP_STATUS.BadRequest;
        RenderStatusMessage (HTTP_STATUS.BadRequest, GlobalLoghandler.ErrorWarningList.Text);
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      GlobalLoghandler.Trace ('%s stopped from %s', [Context.Request.PathInfo, Context.Request.ClientIp]);
      GlobalLoghandler.Trace (h.PadLeft(60, '-'));
    except
      on e: exception do
      begin
        GlobalLoghandler.Error (e.Message);
        GlobalLoghandler.Error (e.StackTrace);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    InputHandler.Free;
  end;
end;

end.
