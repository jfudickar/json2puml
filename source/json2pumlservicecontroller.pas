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
  json2pumlinputhandler, System.Diagnostics;

type

  [MVCPath('/api')]
  TJson2PumlController = class(TMVCController)
  private
  protected
    function GetCurlTracePassThroughHeader (iContext: TWebContext): string;
    procedure OnBeforeAction (Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction (Context: TWebContext; const AActionName: string); override;
    procedure GetFileListResponse (iFileList: TStringList; iInputList: Boolean);
    function IsRequestBodyInvalid: Boolean;
    procedure LogRequestStart (iContext: TWebContext; var ioStopWatch: tStopwatch);
    procedure LogRequestEnd (iContext: TWebContext; iStopWatch: tStopwatch);
    procedure RenderErrorReponseFromErrorList;
    function ServerInformation: string;
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
    [MVCPath('/serviceinformation')]
    [MVCHTTPMethod([httpGET])]
    procedure GetServiceInformation;
    [MVCPath('/heartbeat')]
    [MVCHTTPMethod([httpGET])]
    procedure GetHeartbeat;
    [MVCPath('/errormessages')]
    [MVCHTTPMethod([httpGET])]
    procedure GetErrorMessages;

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
  System.SysUtils, MVCFramework.Logger, System.StrUtils, json2pumlconverter, json2pumldefinition, json2pumlconst,
  jsontools, json2pumlbasedefinition, json2pumlconverterdefinition, json2pumltools, json2pumlloghandler, System.IOUtils,
  IdHTTPWebBrokerBridge, IdHTTPHeaderInfo;

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
  List: TStringList;

  procedure AddHeader (iName, iValue: string);
  begin
    if not iName.IsEmpty and not iValue.IsEmpty then
      if List.IndexOf (iName.Trim.ToLower) < 0 then
      begin
        Result := TCurlUtils.CombineParameter ([Result, TCurlUtils.CalculateHeaderParameter(iName, iValue)]);
        List.Add (iName.Trim.ToLower);
      end;
  end;

begin
  Result := '';
  List := TStringList.Create;
  try
    for s in GlobalConfigurationDefinition.CurlPassThroughHeader do
    begin
      v := iContext.Request.Headers[s];
      AddHeader (s, v);
    end;
    if not GlobalConfigurationDefinition.CurlTraceIdHeader.IsEmpty then
    begin
      v := iContext.Request.Headers[GlobalConfigurationDefinition.CurlTraceIdHeader];
      AddHeader (GlobalConfigurationDefinition.CurlTraceIdHeader, v);
    end;
  finally
    List.Free;
  end;
end;

procedure TJson2PumlController.GetDefinitionFiles;
begin
  GetFileListResponse (GlobalConfigurationDefinition.DefinitionFileSearchFolder, false);
end;

procedure TJson2PumlController.GetErrorMessages;
var
  jsonOutput: TStringList;
  ErrorType: tJson2PumlErrorType;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  jsonOutput := TStringList.Create;
  try
    try
      Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
      WriteArrayStartToJson (jsonOutput, 0, '');
      for ErrorType := low(tJson2PumlErrorType) to high(tJson2PumlErrorType) do
        ErrorType.RenderErrorResponse (jsonOutput, 1);
      WriteArrayEndToJson (jsonOutput, 0);
      Render (jsonOutput.Text);
      Context.Response.StatusCode := HTTP_STATUS.OK;
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    jsonOutput.Free;
  end;
  LogRequestEnd (Context, Stopwatch);
end;

procedure TJson2PumlController.GetFileListResponse (iFileList: TStringList; iInputList: Boolean);
var
  jsonOutput: TStringList;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  jsonOutput := TStringList.Create;
  try
    try
      Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
      GetServiceFileListResponse (jsonOutput, iFileList, iInputList);
      Render (jsonOutput.Text);
      Context.Response.StatusCode := HTTP_STATUS.OK;
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    jsonOutput.Free;
  end;
  LogRequestEnd (Context, Stopwatch)
end;

procedure TJson2PumlController.GetHeartbeat;
begin
  Render (ServerInformation);
end;

procedure TJson2PumlController.GetInputListFile;
begin
  GetFileListResponse (GlobalConfigurationDefinition.InputListFileSearchFolder, true);
end;

procedure TJson2PumlController.GetServiceInformation;
var
  jsonOutput: TStringList;
  InputHandler: TJson2PumlInputHandler;
  InfoList: TStringList;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  InputHandler := TJson2PumlInputHandler.Create (jatService);

  InfoList := TStringList.Create;

  jsonOutput := TStringList.Create;
  try
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.BeginLoadFile;
      try
        InputHandler.LoadConfigurationFile;
      finally
        InputHandler.EndLoadFile (false);
      end;
      Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
      WriteObjectStartToJson (jsonOutput, 0, '');
      WriteToJsonValue (jsonOutput, 'service', ServerInformation, 1, true);
      InfoList.Text := ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration
        (InputHandler.GlobalConfiguration.AdditionalServiceInformation.Replace('\n', #13#10));
      WriteToJsonValue (jsonOutput, 'additionalServiceInformation', InfoList, 1, false, false);
      WriteToJsonValue (jsonOutput, 'commandLine', InputHandler.CmdLineParameter.CommandLineParameterStr(true),
        1, false);
      InputHandler.CmdLineParameter.GenerateLogParameters (InfoList);
      WriteToJsonValue (jsonOutput, 'commandLineParameter', InfoList, 1, false, false);
      InfoList.Text := GetJavaVersion;
      WriteToJsonValue (jsonOutput, 'javaInformation', InfoList, 1, false, false);
      InfoList.Text := GetPlantUmlVersion (InputHandler.CalculateRuntimeJarFile,
        InputHandler.CurrentJavaRuntimeParameter);
      WriteToJsonValue (jsonOutput, 'plantUmlInformation', InfoList, 1, false, false);
      InfoList.Text := TCurlUtils.GetCurlVersion (GlobalConfigurationDefinition.CurlCommand);
      WriteToJsonValue (jsonOutput, 'curlInformation', InfoList, 1, false, false);
      InputHandler.GlobalConfiguration.GenerateLogConfiguration (InfoList);
      WriteToJsonValue (jsonOutput, 'globalConfiguration', InfoList, 1, false, false);

      InputHandler.GlobalConfiguration.FindFilesInFolderList (InfoList,
        InputHandler.GlobalConfiguration.DefinitionFileSearchFolder);
      WriteToJsonValue (jsonOutput, 'definitionFiles', InfoList, 1, false, false);
      InputHandler.GlobalConfiguration.FindFilesInFolderList (InfoList,
        InputHandler.GlobalConfiguration.InputListFileSearchFolder);
      WriteToJsonValue (jsonOutput, 'inputlistFiles', InfoList, 1, false, false);
      WriteObjectEndToJson (jsonOutput, 0);
      Render (jsonOutput.Text);
      Context.Response.StatusCode := HTTP_STATUS.OK;
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderStatusMessage (HTTP_STATUS.InternalServerError, e.Message);
      end;
    end;
  finally
    jsonOutput.Free;
    InputHandler.Free;
    InfoList.Free;
  end;
  LogRequestEnd (Context, Stopwatch)
end;

procedure TJson2PumlController.Index;
begin
  Render (ServerInformation);
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
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    if IsRequestBodyInvalid then
      Exit;
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
        RenderErrorReponseFromErrorList;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderErrorReponseFromErrorList;
        InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      end;
    end;
  finally
    InputHandler.Free;
    LogRequestEnd (Context, Stopwatch)
  end;
end;

procedure TJson2PumlController.HandleJson2PumlRequestPng;
var
  InputHandler: TJson2PumlInputHandler;
  f: tJson2PumlInputFileDefinition;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    if IsRequestBodyInvalid then
      Exit;
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
        if Assigned (f) and f.Exists and FileExistsMinSize (f.Output.PNGFileName) then
        begin
          if Context.Request.Params['includeFileName'] = 'true' then
          begin
            Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
            Render (GenerateFileNameContentBinary(f.Output.PNGFileName));
          end
          else
          begin
            Context.Response.ContentType := TMVCMediaType.IMAGE_PNG;
            SendFile (f.Output.PNGFileName);
          end;
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderErrorReponseFromErrorList;
      end
      else
        RenderErrorReponseFromErrorList;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderErrorReponseFromErrorList;
        InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      end;
    end;
  finally
    InputHandler.Free;
    LogRequestEnd (Context, Stopwatch)
  end;
end;

procedure TJson2PumlController.HandleJson2PumlRequestSvg;
var
  InputHandler: TJson2PumlInputHandler;
  f: tJson2PumlInputFileDefinition;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    if IsRequestBodyInvalid then
      Exit;
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
        if Assigned (f) and f.Exists and FileExistsMinSize (f.Output.SVGFileName) then
        begin
          if Context.Request.Params['includeFileName'] = 'true' then
          begin
            Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
            Render (GenerateFileNameContentBinary(f.Output.SVGFileName));
          end
          else
          begin
            Context.Response.ContentType := TMVCMediaType.APPLICATION_SVG_XML;
            SendFile (f.Output.SVGFileName);
          end;
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderErrorReponseFromErrorList;
      end
      else
        RenderErrorReponseFromErrorList;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderErrorReponseFromErrorList;
        InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      end;
    end;
  finally
    InputHandler.Free;
    LogRequestEnd (Context, Stopwatch)
  end;
end;

procedure TJson2PumlController.HandleJson2PumlRequestZip;
var
  InputHandler: TJson2PumlInputHandler;
  Stopwatch: tStopwatch;
begin
  LogRequestStart (Context, Stopwatch);
  InputHandler := TJson2PumlInputHandler.Create (jatService);
  try
    if IsRequestBodyInvalid then
      Exit;
    try
      InputHandler.CmdLineParameter.ReadInputParameter;
      InputHandler.CmdLineParameter.ParameterFileContent := Context.Request.Body;
      InputHandler.CmdLineParameter.CurlPassThroughHeader := GetCurlTracePassThroughHeader (Context);
      InputHandler.LoadDefinitionFiles;
      if not GlobalLoghandler.Failed then
      begin
        if not FileExistsMinSize (InputHandler.ConverterInputList.SummaryZipFileName) then
          InputHandler.GenerateSummaryZipFile (InputHandler.CurrentOutputFormats);
        if FileExistsMinSize (InputHandler.ConverterInputList.SummaryZipFileName) then
        begin
          if Context.Request.Params['includeFileName'] = 'true' then
          begin
            Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
            Render (GenerateFileNameContentBinary(InputHandler.ConverterInputList.SummaryZipFileName));
          end
          else
          begin
            Context.Response.ContentType := 'application/zip';
            SendFile (InputHandler.ConverterInputList.SummaryZipFileName);
          end;
          Context.Response.StatusCode := HTTP_STATUS.OK;
        end
        else
          RenderErrorReponseFromErrorList;
      end
      else
      begin
        RenderErrorReponseFromErrorList;
      end;
      InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
    except
      on e: exception do
      begin
        GlobalLoghandler.UnhandledException (e);
        RenderErrorReponseFromErrorList;
        InputHandler.AddGeneratedFilesToDeleteHandler (GlobalFileDeleteHandler);
      end;
    end;
  finally
    InputHandler.Free;
    LogRequestEnd (Context, Stopwatch)
  end;
end;

function TJson2PumlController.IsRequestBodyInvalid: Boolean;
begin
  Result := Context.Request.Body.IsEmpty;
  if Result then
  begin
    GlobalLoghandler.Error (jetPayLoadIsEmpty);
    RenderErrorReponseFromErrorList;
  end;
end;

procedure TJson2PumlController.LogRequestEnd (iContext: TWebContext; iStopWatch: tStopwatch);
begin
  iStopWatch.Stop;
  GlobalLoghandler.Trace ('%s stopped - Result : %d - Time : %d (ms)',
    [Context.Request.PathInfo, Context.Response.StatusCode, iStopWatch.ElapsedMilliseconds]);
  GlobalLoghandler.Trace (''.PadLeft(60, '-'));
end;

procedure TJson2PumlController.LogRequestStart (iContext: TWebContext; var ioStopWatch: tStopwatch);
// var
// Name: string;
// I: Integer;
begin
  GlobalLoghandler.Trace ('%s started', [Context.Request.PathInfo]);
  ioStopWatch := tStopwatch.StartNew;
  if Context.Request.RawWebRequest is TIdHTTPAppRequest then
  begin
    // Deactivated because of critical data which can be in header or body (e.g. Curl Authentication Parameter)
    // Should only be activated if realy needed for testing
    // for I := 0 to TIdHTTPAppRequest(Context.Request.RawWebRequest).GetRequestInfo.RawHeaders.Count - 1 do
    // begin
    // name := TIdHTTPAppRequest (Context.Request.RawWebRequest).GetRequestInfo.RawHeaders.Names[I];
    // GlobalLoghandler.Debug  ('Header %s : %s', [name, Context.Request.Headers[name]]);
    // end;
    if not Context.Request.Body.IsEmpty then
      GlobalLoghandler.Debug ('Request Body : %s ', [Context.Request.Body]);
  end;
end;

procedure TJson2PumlController.RenderErrorReponseFromErrorList;
var
  HttpCode: Integer;
  ErrorResponse: string;
begin
  GlobalLoghandler.ErrorList.RenderErrorReponseFromErrorList (ErrorResponse, HttpCode);
  Context.Response.StatusCode := HttpCode;
  Context.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
  Render (ErrorResponse);
end;

function TJson2PumlController.ServerInformation: string;
begin
  Result := Format ('json2puml server %s (%s)', [FileVersion, ApplicationCompileVersion]);
end;

end.
