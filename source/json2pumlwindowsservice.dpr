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

program json2pumlwindowsservice;

uses
  madExcept,
  Vcl.SvcMgr,
  json2pumlwinservice in 'json2pumlwinservice.pas' {J2PWinService: TService},
  json2pumldefinition in 'json2pumldefinition.pas',
  json2pumlconverter in 'json2pumlconverter.pas',
  json2pumltools in 'json2pumltools.pas',
  json2pumlpuml in 'json2pumlpuml.pas',
  json2pumlconst in 'json2pumlconst.pas',
  jsontools in 'jsontools.pas',
  json2pumlinputhandler in 'json2pumlinputhandler.pas',
  json2pumlservicecontroller in 'json2pumlservicecontroller.pas',
  json2pumlservicewebmodule in 'json2pumlservicewebmodule.pas' {Json2PumlWebModule: TWebModule},
  json2pumlbasedefinition in 'json2pumlbasedefinition.pas',
  json2pumlconverterdefinition in 'json2pumlconverterdefinition.pas',
  json2pumlloghandler in 'json2pumlloghandler.pas';

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TJ2PWinService, J2PWinService);
  Application.Run;
end.
