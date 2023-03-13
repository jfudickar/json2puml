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

unit json2pumlconst;

interface

uses
  Quick.Logger;

type
  tJson2PumlOutputFormat = (jofUnknown, jofPNG, jofSVG, jofPDF, jofPUML, jofJSON, jofLog, jofZip, jofFileList);
  tJson2PumlApplicationType = (jatConsole, jatService, jatUI);
  tJson2PumlOutputFormats = set of tJson2PumlOutputFormat;
  tJson2PumlCharacteristicType = (jctUndefined, jctRecord, jctList);
  tJson2PumlListOperation = (jloReplace, jloMerge);

  tJson2PumlFileNameReplace = (jfnrGroup, jfnrDetail, jfnrOption, jfnrJob, jfnrFile);

  tUmlRelationDirection = (urdTo, urdFrom);

const
  cJson2PumlOutputFormat: array [tJson2PumlOutputFormat] of string = ('', 'png', 'svg', 'pdf', 'puml', 'json', 'log',
    'zip', 'filelist');
  cJson2PumlOutputFormatFlag: array [tJson2PumlOutputFormat] of string = ('', '-png', '-svg', '-pdf', '', '',
    '', '', '');
  cJson2PumlServiceResultName: array [tJson2PumlOutputFormat] of string = ('', 'pngFile', 'svgFile', 'pdfFile',
    'pumlFile', 'jsonFile', 'logFile', '', '');
  cJson2PumlCharacteristicType: array [tJson2PumlCharacteristicType] of string = ('', 'record', 'list');
  cJson2PumlListHandlingMode: array [tJson2PumlListOperation] of string = ('replace', 'merge');
  cJson2PumlFileNameReplace: array [tJson2PumlFileNameReplace] of string = ('<group>', '<detail>', '<option>', '<job>',
    '<file>');
  cUmlRelationDirection: array [tUmlRelationDirection] of string = ('To', 'From');

  cDefaultDefinitionFile = 'json2pumldefinition.json';
  cDefinitionFileRegistry = 'Json2PumlDefinitionFile';
  cConfigurationFileRegistry = 'Json2PumlConfigurationFile';
  cDefaultConfigurationFile = 'json2pumlconfiguration.json';
  cDefaultCurlAuthenticationFile = 'json2pumlcurlauthentication.json';
  cDefaultCurlParameterFile = 'json2pumlcurlauthentication.json';
  cCurlAuthenticationFileRegistry = 'Json2PumlCurlAuthenticationFile';
  cPlantUmlJarFileRegistry = 'PlantUmlJarFile';

  cTrue = 'true';
  cFalse = 'false';
  cNullValue = '<null>';

  cOpenOutputAll = '<all>';

  cDefaultPlantumljarFile = 'plantuml.jar';

  cDefaultJsonFileFilter = '*.json';

  cLinuxHome = '~';

  cNewLinePuml = '\n';

  cCurrentVersion = '2.1.1.76';

  JSON2PUML_EVENTTYPENAMES: TEventTypeNames = ['', 'INFO    ', 'SUCCESS ', 'WARNING ', 'ERROR   ', 'CRITICAL',
    'EXCEPT  ', 'DEBUG   ', 'TRACE   ', 'DONE    ', 'CUSTOM1 ', 'CUSTOM2 '];

implementation

end.
