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

unit json2pumlcommandline;

interface

uses
  System.Classes, json2pumlconverter, json2pumldefinition, json2pumlinputhandler;

type
  tJson2PumlCommandlineHandler = class(tObject)
  private
    FInputHandler: TJson2PumlInputHandler;
    procedure AfterCreateAllInputHandlerRecords (Sender: tObject);
    procedure AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
  protected
    procedure WriteAppTitle;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    property InputHandler: TJson2PumlInputHandler read FInputHandler;
  end;

procedure handle_json2puml_commandline;

implementation

uses
  System.SysUtils, json2pumltools, System.IOUtils, json2pumlloghandler,
  json2pumlconst;

procedure handle_json2puml_commandline;
var
  handler: tJson2PumlCommandlineHandler;
begin
  handler := tJson2PumlCommandlineHandler.Create;
  try
    handler.Execute;
  finally
    handler.Free;
  end;
end;

constructor tJson2PumlCommandlineHandler.Create;
begin
  inherited Create;
  InitDefaultLogger(GlobalConfigurationDefinition.LogFileOutputPath, jatConsole, true, not FindCmdLineSwitch(cNoLogFiles));
  FInputHandler := TJson2PumlInputHandler.Create (jatConsole);
  FInputHandler.AfterUpdateRecord := AfterUpdateInputHandlerRecord;
  FInputHandler.AfterCreateAllRecords := AfterCreateAllInputHandlerRecords;
end;

destructor tJson2PumlCommandlineHandler.Destroy;
begin
  FInputHandler.Free;
  inherited Destroy;
end;

procedure tJson2PumlCommandlineHandler.AfterCreateAllInputHandlerRecords (Sender: tObject);
begin
end;

procedure tJson2PumlCommandlineHandler.AfterUpdateInputHandlerRecord (InputHandlerRecord: TJson2PumlInputHandlerRecord);
begin
end;

procedure tJson2PumlCommandlineHandler.Execute;
begin
  WriteAppTitle;
  try

    if FindCmdLineSwitch ('?') or (ParamCount <= 0) then
      InputHandler.CmdLineParameter.WriteHelpScreen;
    InputHandler.CmdLineParameter.ReadInputParameter;
    InputHandler.LoadDefinitionFiles;

  finally
    if FindCmdLineSwitch ('wait') then
    begin
      GlobalLogHandler.Info ('Press <RETURN> to continue');
      readln;
    end;
  end;
end;

procedure tJson2PumlCommandlineHandler.WriteAppTitle;
var
  s: string;
begin
  s := '*';
  GlobalLogHandler.Info (s.PadRight(120, '*'));
  GlobalLogHandler.Info ('json2puml %s - Command line converter JSON to PUML', [FileVersion]);
  GlobalLogHandler.Info (s.PadRight(120, '*'));
  GlobalConfigurationDefinition.LogConfiguration;
end;

end.
