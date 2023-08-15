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
  Quick.Logger, MVCFramework.Commons;

type
  tJson2PumlOutputFormat = (jofUnknown, jofPNG, jofSVG, jofPDF, jofPUML, jofJSON, jofLog, jofZip, jofFileList,
    jofExecuteLog);
  tJson2PumlApplicationType = (jatConsole, jatService, jatUI, jatWinService);
  tJson2PumlOutputFormats = set of tJson2PumlOutputFormat;
  tJson2PumlCharacteristicType = (jctUndefined, jctRecord, jctList);
  tJson2PumlListOperation = (jloReplace, jloMerge);

  tJson2PumlFileNameReplace = (jfnrGroup, jfnrDetail, jfnrOption, jfnrJob, jfnrFile);

  tUmlRelationDirection = (urdTo, urdFrom);

  tJson2PumlErrorType = (jetUndefined, jetWarning, jetUnknown, jetException, jetUnknownServerError,
    jetDefinitionFileNotFound, jetNoDefinitionFileDefined, jetNoInputFile, jetInputListFileNotFound,
    jetUnableToParseInputFileStructure, jetNoConfiguredPlantUmlFileFound, jetPlantUmlFileNotFound,
    jetNoMatchingOptionFound, jetGenerateDetailsSummaryNotDefined, jetMandatoryFileNotFound, jetOptionalFileNotFound,
    jetFailedParsingFile, jetPlantUmlResultGenerationFailed, jetCurlFileSkippedValidationException,
    jetCurlFileSkippedUrlMissing, jetCurlFileSkippedInvalidCurlCommand, jetCurlExecutionFailed,
    jetDirectoryCouldNotBeCreated, jetDirectoryCreationFailed, jetFileDeletionFailed, jetDirectoryDeletionFailed,
    jetCmdLineParameterFileDoesNotExits, jetInputFileNotFound, jetMandatoryInputFileNotFound, jetPayLoadIsEmpty,
    jetInputListCurlFileMissing);

  tJson2PumlErrorInformation = record
    EventType: TEventType;
    Errorcode: string;
    HttpStatusCode: integer;
    ErrorMessage: string;
    ErrorDescription: string;
  end;

const
  cJson2PumlErrorInformation: array [tJson2PumlErrorType] of tJson2PumlErrorInformation =
    ( { jetUndefined } (EventType: etError; Errorcode: ''; HttpStatusCode: 0; ErrorMessage: ''; ErrorDescription: ''),
    { jetUnkownWarning } (EventType: etWarning; Errorcode: ''; HttpStatusCode: 0; ErrorMessage: '';
    ErrorDescription: ''),
    { jetUnknownError } (EventType: etError; Errorcode: 'J2P-400-001'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Unknown error'; ErrorDescription: ''),
    { jetException } (EventType: etCritical; Errorcode: 'J2P-500-001'; HttpStatusCode: HTTP_STATUS.InternalServerError;
    ErrorMessage: 'Unhandled exception %s: %s'#13#10'%s';
    ErrorDescription: 'Unhandled exception, please contact the system administrator.'),
    { jetUnknownServerError } (EventType: etCritical; Errorcode: 'J2P-500-002';
    HttpStatusCode: HTTP_STATUS.InternalServerError; ErrorMessage: 'Unknown server error';
    ErrorDescription: 'Please contact the system administrator.'),
    { jetDefinitionFileNotFound } (EventType: etError; Errorcode: 'J2P-400-002'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Definition file "%s" not found'; ErrorDescription: ''),
    { jetNoDefinitionFileDefined } (EventType: etError; Errorcode: 'J2P-400-003';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'No definition file defined';
    ErrorDescription: 'A definition file must be defined to convert json data.'),
    { jetNoInputFile } (EventType: etError; Errorcode: 'J2P-400-004'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'No input files found, conversion aborted';
    ErrorDescription
    : 'No input files have been defined which can be converted. A input file can be based on single file definitions or inputlist files.'),
    { jetInputListFileNotFound } (EventType: etError; Errorcode: 'J2P-400-005'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'InputListFile : "%s" not found'; ErrorDescription: 'The defined inputlist file couldn''t be found'),
    { jetUnableToParseInputFileStructure } (EventType: etError; Errorcode: 'J2P-400-006';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Unable to parse JSON structure of input file "%s"';
    ErrorDescription
    : 'The structure of the input file is not a valid json structure and can not be parsed. The file will be ignored'),
    { jetNoConfiguredPlantUmlFileFound } (EventType: etError; Errorcode: 'J2P-400-007';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'No configured PlantUML jar files found.';
    ErrorDescription
    : 'Error in the system configuration. Get in contact with a system administrator. No configured PlantUML could be found.'),
    { jetPlantUmlFileNotFound } (EventType: etError; Errorcode: 'J2P-400-008'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'PlantUML Jar file ("%s") not found.';
    ErrorDescription
    : 'Error in the system configuration. Get in contact with a system administrator. The configured PlantUML could not be found.'),
    { jetNoMatchingOptionFound } (EventType: etError; Errorcode: 'J2P-400-009'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'No matching option found/defined, conversion aborted';
    ErrorDescription: 'The defined converter option is not defined in the definition file.'),
    { jetGenerateDetailsSummaryNotDefined } (EventType: etError; Errorcode: 'J2P-400-010';
    HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'GenerateDetails or GenerateSummary must be activated, conversion aborted';
    ErrorDescription: 'In the minimum one of both options must enabled.'),
    { jetMandatoryFileNotFound } (EventType: etError; Errorcode: 'J2P-400-011'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Failed loading %s from %s, file does not exist.';
    ErrorDescription: 'The defined file could not be found.'),
    { jetOptionalFileNotFound } (EventType: etWarning; Errorcode: 'J2P-400-012'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Skipped loading %s from %s, file does not exist.';
    ErrorDescription: 'The defined file could not be found.'),
    { jetFailedParsingFile } (EventType: etWarning; Errorcode: 'J2P-400-013'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Error parsing %s file "%s".';
    ErrorDescription: 'The json structure of the defined file is invalid or does not match the required structure.'),
    { jetPlantUmlResultGenerationFailed } (EventType: etWarning; Errorcode: 'J2P-400-014';
    HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Failed generation of target format %s for PlantUml file "%s".';
    ErrorDescription
    : 'The generation of the target file failed. Activate the PlantUml debug informations to get further details.'),
    { jetCurlFileSkippedValidationException } (EventType: etWarning; Errorcode: 'J2P-400-015';
    HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'curl file %s skipped - Exception "%s" raised when validating [%s]';
    ErrorDescription
    : 'The validateion condition in the inputlist file to check if the curl command should be executed has errors.'),
    { jetCurlFileSkippedUrlMissing } (EventType: etWarning; Errorcode: 'J2P-400-016';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'curl file %s skipped - url not defined.';
    ErrorDescription: 'The curl command can not be exeucted, the url definition is missing.'),
    { jetCurlFileSkippedInvalidCurlCommand } (EventType: etWarning; Errorcode: 'J2P-400-017';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'curl file %s skipped - unable to generate curl command .';
    ErrorDescription: 'The curl command can not be generated.'),
    { jetCurlExecutionFailed } (EventType: etWarning; Errorcode: 'J2P-400-018'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Fetching from "%s" for "%s" FAILED (%d ms) : [%s], file skipped'),
    { jetDirectoryCouldNotBeCreated } (EventType: etError; Errorcode: 'J2P-400-019';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Directory could not be created : %s'),
    { jetDirectoryCreationFailed } (EventType: etError; Errorcode: 'J2P-400-020';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Error creating directory : %s - %s'),
    { jetFileDeletionFailed } (EventType: etWarning; Errorcode: 'J2P-400-021'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Deleting of file "%s" failed. (%s)'),
    { jetDirectoryDeletionFailed } (EventType: etWarning; Errorcode: 'J2P-400-022';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Deleting of directory "%s" failed. (%s)'),
    { jetCmdLineParameterFileDoesNotExits } (EventType: etWarning; Errorcode: 'J2P-400-023';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: '%s%s File "%s" does not exist';
    ErrorDescription: 'The file handed over as command line parameter does not exists'),
    { jetInputFileNotFound } (EventType: etWarning; Errorcode: 'J2P-400-024'; HttpStatusCode: HTTP_STATUS.BadRequest;
    ErrorMessage: 'Input file "%s" not found (%s).'),
    { jetMandatoryInputFileNotFound } (EventType: etError; Errorcode: 'J2P-400-025';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Mandarory input file "%s" not found (%s).'),
    { jetCmdLineParameterFileDoesNotExits } (EventType: etError; Errorcode: 'J2P-400-026';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Payload is empty';
    ErrorDescription: 'The service request payload is empty. The request can not be handled.'),
    { jetInputListCurlFileMissing } (EventType: etError; Errorcode: 'J2P-400-027';
    HttpStatusCode: HTTP_STATUS.BadRequest; ErrorMessage: 'Mandatory input list file "%s" could not be fetched';
    ErrorDescription: 'The file defined in the inputlist could not be fetched via curl.'));

  cJson2PumlOutputFormat: array [tJson2PumlOutputFormat] of string = ('', 'png', 'svg', 'pdf', 'puml', 'json', 'log',
    'zip', 'filelist', 'execute.log');
  cJson2PumlOutputFormatFlag: array [tJson2PumlOutputFormat] of string = ('', '-png', '-svg', '-pdf', '', '', '',
    '', '', '');
  cJson2PumlServiceResultName: array [tJson2PumlOutputFormat] of string = ('', 'pngFile', 'svgFile', 'pdfFile',
    'pumlFile', 'jsonFile', 'convertLogFile', '', '', 'executeLogFile');
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
  cDefaultCurlParameterFile = 'json2pumlcurlparameter.json';
  cCurlAuthenticationFileRegistry = 'Json2PumlCurlAuthenticationFile';
  cPlantUmlJarFileRegistry = 'PlantUmlJarFile';

  cTrue = 'true';
  cFalse = 'false';
  cNullValue = '<null>';

  cOpenOutputAll = '<all>';

  cDefaultPlantumljarFile = 'plantuml.jar';

  cDefaultJsonFileFilter = '*.json';

  cNoLogFiles = 'nologfiles';

  cLinuxHome = '~';

  cNewLinePuml = '\n';

{$IFDEF MSWINDOWS}
  cCmdLinePrefix = '/';
{$ELSE}
  cCmdLinePrefix = '-';
{$ENDIF}
  cCurrentVersion = '2.2.5.100';

  cApplicationName = 'json2puml';

  cDefaultServicePort = 8080;

  // Minimum Size a file must have to be excepted / determined as existing
  cMinFileSize = 5;

  cJson2PumlApplicationTypeName: array [tJson2PumlApplicationType] of string = (cApplicationName + ' command line',
    cApplicationName + ' service', cApplicationName + ' ui', cApplicationName + ' windows service');

  JSON2PUML_EVENTTYPENAMES: TEventTypeNames = ['', 'INFO    ', 'SUCCESS ', 'WARNING ', 'ERROR   ', 'CRITICAL',
    'EXCEPT  ', 'DEBUG   ', 'TRACE   ', 'DONE    ', 'CUSTOM1 ', 'CUSTOM2 '];

implementation

end.
