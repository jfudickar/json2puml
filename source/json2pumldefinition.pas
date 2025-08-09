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

unit json2pumldefinition;

interface

uses
  System.JSON, System.Classes, json2pumlloghandler, json2pumlconst, json2pumlbasedefinition, System.SyncObjs,
  System.Zip;

type
  tJson2PumlCurlParameterList = class;
  tJson2PumlCurlMappingParameterList = class;
  tJson2PumlCurlAuthenticationList = class;
  tJson2PumlCurlResult = class;

  tJson2PumlFileDeleteHandler = class(tPersistent)
  private
    FDirectoryList: tStringList;
    FFileList: tStringList;
    FLock: tCriticalSection;
  protected
    property DirectoryList: tStringList read FDirectoryList;
    property FileList: tStringList read FFileList;
    property Lock: tCriticalSection read FLock;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddDirectory (iDirectoryName: string);
    procedure AddFile (iFileName: string);
    procedure DeleteFiles;
  end;

  tJson2PumlParameterInputFileDefinition = class(tJson2PumlBaseObject)
  private
    FContent: string;
    FFileName: string;
    FJsonContent: tJSONValue;
    FLeadingObject: string;
    procedure SetContent (const Value: string);
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
  published
    property Content: string read FContent write SetContent;
    property FileName: string read FFileName write FFileName;
    property JsonContent: tJSONValue read FJsonContent write FJsonContent;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
  end;

  tJson2PumlParameterInputFileDefinitionList = class;

  tJson2PumlParameterInputFileDefinitionListEnumerator = class
  private
    FIndex: integer;
    fObjectList: tJson2PumlParameterInputFileDefinitionList;
  protected
    function GetCurrent: tJson2PumlParameterInputFileDefinition;
  public
    constructor Create (AObjectList: tJson2PumlParameterInputFileDefinitionList);
    function MoveNext: boolean;
    property Current: tJson2PumlParameterInputFileDefinition read GetCurrent;
  end;

  tJson2PumlParameterInputFileDefinitionList = class(tJson2PumlBasePropertyList)
  private
    function GetInputFile (Index: integer): tJson2PumlParameterInputFileDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    function AddInputFile (const iFileName: string; iLeadingObject: string; iContent: string = ''): boolean;
    function GetEnumerator: tJson2PumlParameterInputFileDefinitionListEnumerator;
    property InputFile[index: integer]: tJson2PumlParameterInputFileDefinition read GetInputFile; default;
  end;

  tJson2PumlParameterFileDefinition = class(tJson2PumlBaseObject)
  private
    FCurlParameter: tJson2PumlCurlParameterList;
    FCurlAuthenticationParameter: tJson2PumlCurlParameterList;
    FDefinitionFileName: string;
    FJobDescription: string;
    FDetail: string;
    FGenerateDetailsStr: string;
    FGenerateSummaryStr: string;
    FGroup: string;
    FInputFiles: tJson2PumlParameterInputFileDefinitionList;
    FInputListFileName: string;
    FJobname: string;
    FOption: string;
    FOutputFormats: tJson2PumlOutputFormats;
    FOutputFormatStr: string;
    FOutputSuffix: string;
    function GetDefinitionFileNameExpanded: string;
    function GetGenerateDetails: boolean;
    function GetGenerateSummary: boolean;
    function GetInputListFileNameExpanded: string;
    procedure SetOutputFormatStr (const Value: string);
    procedure SetOutputSuffix (const Value: string);
  protected
    function GetIdent: string; override;
    procedure SetSourceFileName (const Value: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property DefinitionFileNameExpanded: string read GetDefinitionFileNameExpanded;
    property GenerateDetails: boolean read GetGenerateDetails;
    property GenerateSummary: boolean read GetGenerateSummary;
    property InputFiles: tJson2PumlParameterInputFileDefinitionList read FInputFiles write FInputFiles;
    property InputListFileNameExpanded: string read GetInputListFileNameExpanded;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
  published
    property CurlParameter: tJson2PumlCurlParameterList read FCurlParameter;
    property CurlAuthenticationParameter: tJson2PumlCurlParameterList read FCurlAuthenticationParameter;
    property DefinitionFileName: string read FDefinitionFileName write FDefinitionFileName;
    property JobDescription: string read FJobDescription write FJobDescription;
    property Detail: string read FDetail write FDetail;
    property GenerateDetailsStr: string read FGenerateDetailsStr write FGenerateDetailsStr;
    property GenerateSummaryStr: string read FGenerateSummaryStr write FGenerateSummaryStr;
    property Group: string read FGroup write FGroup;
    property InputListFileName: string read FInputListFileName write FInputListFileName;
    property Jobname: string read FJobname write FJobname;
    property Option: string read FOption write FOption;
    property OutputFormatStr: string read FOutputFormatStr write SetOutputFormatStr;
    property OutputSuffix: string read FOutputSuffix write SetOutputSuffix;
  end;

  tJson2PumlGlobalDefinition = class(tJson2PumlBaseObject)
  private
    FAdditionalServiceInformation: string;
    FBaseOutputPath: string;
    FintBaseOutputPath: string;
    FCurlAuthenticationFileName: string;
    FintCurlAuthenticationFileName: string;
    FCurlCommand: string;
    FCurlParameter: tJson2PumlCurlParameterList;
    FCurlPassThroughHeader: tStringList;
    FCurlSpanIdHeader: string;
    FCurlTraceIdHeader: string;
    FCurlUserAgentInformation: string;
    FDefaultDefinitionFileName: string;
    FintDefaultDefinitionFileName: string;
    FDefinitionFileSearchFolder: tStringList;
    FInputListFileSearchFolder: tStringList;
    FJavaRuntimeParameter: string;
    FLogFileOutputPath: string;
    FOutputPath: string;
    FPlantUmlJarFileName: string;
    FPlantUmlRuntimeParameter: string;
    FServicePort: integer;
    FintServicePort: string;
    FintPlantUmlJarFileName: string;
    FintPlantUmlRuntimeParameter: string;
    FintLogFileOutputPath: string;
    FintJavaRuntimeParameter: string;
    FintPlantUmlServerCurlParameter: string;
    FintPlantUmlServerUrl: string;
    FPlantUmlServerCurlParameter: string;
    FPlantUmlServerUrl: string;
    procedure SetCurlCommand (const Value: string);
    procedure SetCurlSpanIdHeader (const Value: string);
    procedure SetCurlTraceIdHeader (const Value: string);
    procedure SetintBaseOutputPath (const Value: string);
    procedure SetintCurlAuthenticationFileName (const Value: string);
    procedure SetintDefaultDefinitionFileName (const Value: string);
    procedure SetintJavaRuntimeParameter (const Value: string);
    procedure SetintLogFileOutputPath (const Value: string);
    procedure SetintPlantUmlJarFileName (const Value: string);
    procedure SetintPlantUmlServerCurlParameter (const Value: string);
    procedure SetintPlantUmlServerUrl (const Value: string);
    procedure SetintPlantUmlRuntimeParameter (const Value: string);
    procedure SetintServicePort (const Value: string);
    property intBaseOutputPath: string read FintBaseOutputPath write SetintBaseOutputPath;
    property intCurlAuthenticationFileName: string read FintCurlAuthenticationFileName
      write SetintCurlAuthenticationFileName;
    property intDefaultDefinitionFileName: string read FintDefaultDefinitionFileName
      write SetintDefaultDefinitionFileName;
    property intJavaRuntimeParameter: string read FintJavaRuntimeParameter write SetintJavaRuntimeParameter;
    property intLogFileOutputPath: string read FintLogFileOutputPath write SetintLogFileOutputPath;
    property intPlantUmlJarFileName: string read FintPlantUmlJarFileName write SetintPlantUmlJarFileName;
    property intPlantUmlServerCurlParameter: string read FintPlantUmlServerCurlParameter
      write SetintPlantUmlServerCurlParameter;
    property intPlantUmlServerUrl: string read FintPlantUmlServerUrl write SetintPlantUmlServerUrl;
    property intPlantUmlRuntimeParameter: string read FintPlantUmlRuntimeParameter write SetintPlantUmlRuntimeParameter;
    property intServicePort: string read FintServicePort write SetintServicePort;
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function FindDefinitionFile (iFileName: string): string;
    function FindFileInFolderList (iFileName: string; iFolderList: tStringList): string;
    procedure FindFilesInFolderList (ioFileList, iFolderList: tStringList; iFilter: string = '');
    function FindInputListFile (iFileName: string): string;
    procedure LogConfiguration;
    procedure GenerateLogConfiguration (iLogList: tStringList);
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
  published
    property AdditionalServiceInformation: string read FAdditionalServiceInformation
      write FAdditionalServiceInformation;
    property BaseOutputPath: string read FBaseOutputPath;
    property CurlAuthenticationFileName: string read FCurlAuthenticationFileName;
    property CurlCommand: string read FCurlCommand write SetCurlCommand;
    property CurlParameter: tJson2PumlCurlParameterList read FCurlParameter;
    property CurlPassThroughHeader: tStringList read FCurlPassThroughHeader;
    property CurlSpanIdHeader: string read FCurlSpanIdHeader write SetCurlSpanIdHeader;
    property CurlTraceIdHeader: string read FCurlTraceIdHeader write SetCurlTraceIdHeader;
    property CurlUserAgentInformation: string read FCurlUserAgentInformation write FCurlUserAgentInformation;
    property DefaultDefinitionFileName: string read FDefaultDefinitionFileName;
    property DefinitionFileSearchFolder: tStringList read FDefinitionFileSearchFolder;
    property InputListFileSearchFolder: tStringList read FInputListFileSearchFolder;
    property JavaRuntimeParameter: string read FJavaRuntimeParameter;
    property LogFileOutputPath: string read FLogFileOutputPath;
    property OutputPath: string read FOutputPath write FOutputPath;
    property PlantUmlJarFileName: string read FPlantUmlJarFileName;
    property PlantUmlRuntimeParameter: string read FPlantUmlRuntimeParameter;
    property PlantUmlServerCurlParameter: string read FPlantUmlServerCurlParameter;
    property PlantUmlServerUrl: string read FPlantUmlServerUrl;
    property ServicePort: integer read FServicePort;
  end;

  tJson2PumlFileDetailRecord = class(tPersistent)
  private
    FFileDate: tDateTime;
    FFileName: string;
    FFileSize: integer;
    FNoOfLines: integer;
    FNoOfRecords: integer;
  public
    property FileDate: tDateTime read FFileDate write FFileDate;
    property FileName: string read FFileName write FFileName;
    property FileSize: integer read FFileSize write FFileSize;
    property NoOfLines: integer read FNoOfLines write FNoOfLines;
    property NoOfRecords: integer read FNoOfRecords write FNoOfRecords;
  end;

  tJson2PumlFileOutputDefinition = class(tJson2PumlBaseObject)
  private
    FConverterLogFileName: string;
    FIsSplitFile: boolean;
    FIsSummaryFile: boolean;
    FOption: string;
    FPDFFilename: string;
    FPNGFileName: string;
    FPUmlFileName: string;
    FSourceFiles: tStringList;
    FSVGFileName: string;
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddFilesToZipFile (iZipFile: tZipFile; iRemoveDirectory: string; iOutputFormats: tJson2PumlOutputFormats);
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    procedure AddSourceFile (iFileName: string);
    procedure DeleteGeneratedFiles;
    function OutputFileName (iOutputFormat: tJson2PumlOutputFormat): string;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property ConverterLogFileName: string read FConverterLogFileName write FConverterLogFileName;
    property IsSplitFile: boolean read FIsSplitFile write FIsSplitFile;
    property IsSummaryFile: boolean read FIsSummaryFile write FIsSummaryFile;
    property Option: string read FOption write FOption;
    property PDFFilename: string read FPDFFilename write FPDFFilename;
    property PNGFileName: string read FPNGFileName write FPNGFileName;
    property PUmlFileName: string read FPUmlFileName write FPUmlFileName;
    property SourceFiles: tStringList read FSourceFiles;
    property SVGFileName: string read FSVGFileName write FSVGFileName;
  end;

  tJson2PumlInputFileDefinition = class(tJson2PumlBaseObject)
  private
    FCurlBaseUrl: string;
    FCurlCache: integer;
    FCurlExecuteEvaluation: string;
    FCurlFileNameSuffix: string;
    FCurlFormatOutput: boolean;
    FCurlOptions: string;
    FCurlOutputParameter: tJson2PumlCurlParameterList;
    FCurlResult: tJson2PumlCurlResult;
    FCurlUrl: string;
    FGenerateOutput: boolean;
    FInputFileName: string;
    FIsConverted: boolean;
    FIsInputFileUsable: boolean;
    FIsInternalOnly: boolean;
    FIsOriginal: boolean;
    FLeadingObject: string;
    FMandatory: boolean;
    FOutput: tJson2PumlFileOutputDefinition;
    FOutputFileName: string;
    FSplitIdentifier: string;
    FSplitInputFile: boolean;
    function GetCurlBaseUrlDecoded: string;
    function GetExists: boolean;
    function GetExtractedOutputFileName: string;
    function GetIncludeIntoOutput: boolean;
    function GetInputFileNameExpanded: string;
    function GetIsSplitFile: boolean;
    function GetIsSummaryFile: boolean;
    procedure SetCurlFileNameSuffix (const Value: string);
    procedure SetInputFileName (const Value: string);
    procedure SetIsSplitFile (const Value: boolean);
    procedure SetIsSummaryFile (const Value: boolean);
    procedure SetOutputFileName (const Value: string);
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddFilesToZipFile (iZipFile: tZipFile; iRemoveDirectory: string; iOutputFormats: tJson2PumlOutputFormats);
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    procedure Clear; override;
    procedure DeleteGeneratedFiles;
    procedure ExpandFileNameWithCurlParameter (iCurlParameterList, iCurlDetailParameterList
      : tJson2PumlCurlParameterList; iCurlMappingParameterList: tJson2PumlCurlMappingParameterList);
    procedure GetCurlParameterFromFile (iCurlOutputParameter, iCurlParameterList: tJson2PumlCurlParameterList);
    function HandleCurl (const iBaseUrl: string; iUrlAddon: string; const iOptions: array of string;
      iExecuteCurlParameterList, ioResultCurlParameterList: tJson2PumlCurlParameterList;
      iCurlMappingParameterList: tJson2PumlCurlMappingParameterList;
      iCurlAuthenticationList: tJson2PumlCurlAuthenticationList; iIgnoreCurlCache: boolean): boolean;
    function HasValidCurl: boolean;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonOutputFile (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false);
    procedure WriteToJsonServiceResult (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iOutputFormats: tJson2PumlOutputFormats; iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false);
    property CurlBaseUrlDecoded: string read GetCurlBaseUrlDecoded;
    property CurlResult: tJson2PumlCurlResult read FCurlResult;
    property Exists: boolean read GetExists;
    property ExtractedOutputFileName: string read GetExtractedOutputFileName;
    // 1 Defines over all flags if the Output should be rendered for this file
    property IncludeIntoOutput: boolean read GetIncludeIntoOutput;
    property InputFileNameExpanded: string read GetInputFileNameExpanded;
    property IsConverted: boolean read FIsConverted write FIsConverted;
    property IsInputFileUsable: boolean read FIsInputFileUsable write FIsInputFileUsable;
    property IsInternalOnly: boolean read FIsInternalOnly write FIsInternalOnly;
    property IsOriginal: boolean read FIsOriginal write FIsOriginal;
    property IsSplitFile: boolean read GetIsSplitFile write SetIsSplitFile;
    property IsSummaryFile: boolean read GetIsSummaryFile write SetIsSummaryFile;
    property Output: tJson2PumlFileOutputDefinition read FOutput write FOutput;
    property OutputFileName: string read FOutputFileName write SetOutputFileName;
  published
    property CurlBaseUrl: string read FCurlBaseUrl write FCurlBaseUrl;
    property CurlCache: integer read FCurlCache write FCurlCache;
    property CurlExecuteEvaluation: string read FCurlExecuteEvaluation write FCurlExecuteEvaluation;
    property CurlFileNameSuffix: string read FCurlFileNameSuffix write SetCurlFileNameSuffix;
    property CurlFormatOutput: boolean read FCurlFormatOutput write FCurlFormatOutput;
    property CurlOptions: string read FCurlOptions write FCurlOptions;
    property CurlOutputParameter: tJson2PumlCurlParameterList read FCurlOutputParameter;
    property CurlUrl: string read FCurlUrl write FCurlUrl;
    property GenerateOutput: boolean read FGenerateOutput write FGenerateOutput;
    property InputFileName: string read FInputFileName write SetInputFileName;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
    property Mandatory: boolean read FMandatory write FMandatory;
    property SplitIdentifier: string read FSplitIdentifier write FSplitIdentifier;
    property SplitInputFile: boolean read FSplitInputFile write FSplitInputFile;
  end;

  tJson2PumlFilterList = class(tPersistent)
  private
    FIdentFilter: tStrings;
    FTitleFilter: tStrings;
  protected
    function ListMatches (iList: tStrings; iSearch: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function IdentMatches (iIdent: string): boolean;
    function Matches (iIdent, iTitle: string; iMatchAll: boolean = true): boolean;
    function TitleMatches (iTitle: string): boolean;
    property IdentFilter: tStrings read FIdentFilter;
    property TitleFilter: tStrings read FTitleFilter;
  end;

  tJson2PumlFileDescriptionParameterDefinition = class(tJson2PumlBaseObject)
  private
    FDefaultValue: string;
    FDescription: string;
    FDisplayName: string;
    FMandatory: boolean;
    FMandatoryGroup: string;
    FName: string;
    FRegularExpression: string;
    function GetVisibleName: string;
    procedure SetName (const Value: string);
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    function ValidateValue (iValue: string; var oValidationMessage: string): boolean;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property VisibleName: string read GetVisibleName;
  published
    property DefaultValue: string read FDefaultValue write FDefaultValue;
    property Description: string read FDescription write FDescription;
    property DisplayName: string read FDisplayName write FDisplayName;
    property Mandatory: boolean read FMandatory write FMandatory;
    property MandatoryGroup: string read FMandatoryGroup write FMandatoryGroup;
    property name: string read FName write SetName;
    property RegularExpression: string read FRegularExpression write FRegularExpression;
  end;

  tJson2PumlFileDescriptionParameterList = class;

  tJson2PumlFileDescriptionParameterListEnumerator = class
  private
    FIndex: integer;
    fParameterList: tJson2PumlFileDescriptionParameterList;
  public
    constructor Create (AParameterList: tJson2PumlFileDescriptionParameterList);
    function GetCurrent: tJson2PumlFileDescriptionParameterDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlFileDescriptionParameterDefinition read GetCurrent;
  end;

  tJson2PumlFileDescriptionParameterList = class(tJson2PumlBasePropertyList)
  private
    function GetInputParameter (Index: integer): tJson2PumlFileDescriptionParameterDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    function GetEnumerator: tJson2PumlFileDescriptionParameterListEnumerator;
    property InputParameter[index: integer]: tJson2PumlFileDescriptionParameterDefinition
      read GetInputParameter; default;
    function ValidatedInputParameter (iInputCurlParameterList: tJson2PumlCurlParameterList;
      oErrormessages: tStringList): boolean;
  end;

  tJson2PumlInputListDescriptionDefinition = class(tJson2PumlBaseObject)
  private
    FDescription: string;
    FDisplayName: string;
    FCurlParameterList: tJson2PumlFileDescriptionParameterList;
    function GetCurlParameter (Index: integer): tJson2PumlFileDescriptionParameterDefinition;
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property CurlParameter[index: integer]: tJson2PumlFileDescriptionParameterDefinition read GetCurlParameter;
    property CurlParameterList: tJson2PumlFileDescriptionParameterList read FCurlParameterList;
  published
    property Description: string read FDescription write FDescription;
    property DisplayName: string read FDisplayName write FDisplayName;
  end;

  tJson2PumlInputList = class;

  tJson2PumlInputListEnumerator = class
  private
    FIndex: integer;
    fInputList: tJson2PumlInputList;
  public
    constructor Create (AInputList: tJson2PumlInputList);
    function GetCurrent: tJson2PumlInputFileDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlInputFileDefinition read GetCurrent;
  end;

  tJson2PumlInputList = class(tJson2PumlBasePropertyList)
  private
    FcurlAdditionalRuntimeOptions: string;
    FCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
    FCurlBaseUrl: string;
    FCurlMappingParameterList: tJson2PumlCurlMappingParameterList;
    FCurlOptions: string;
    FCurlParameterList: tJson2PumlCurlParameterList;
    FCurlSpanIdHeader: string;
    FCurlTraceIdHeader: string;
    FCurlUrlAddon: string;
    FCurlUserAgentInformation: string;
    FDefinitionFileName: string;
    FDescription: tJson2PumlInputListDescriptionDefinition;
    FDetail: string;
    FExecuteLogFileName: string;
    FExpandInputListCount: integer;
    FExpandInputListPosition: integer;
    FFileListFileName: string;
    FGenerateDetailsStr: string;
    FGenerateSummaryStr: string;
    FGroup: string;
    FJobDescription: string;
    FJobname: string;
    FOnCalculateOutputFileName: tJson2PumlCalculateOutputFilenameEvent;
    FOnNotifyChange: tJson2PumlNotifyChangeEvent;
    FOption: string;
    FOutputFormats: tJson2PumlOutputFormats;
    FOutputFormatStr: string;
    FOutputPath: string;
    FOutputSuffix: string;
    FSummaryFileName: string;
    FSummaryZipFileName: string;
    function GetCurlBaseUrlDecoded: string;
    function GetDefinitionFileNameExpanded: string;
    function GetExecuteCount: integer;
    function GetExistsCount: integer;
    function GetGenerateDetails: boolean;
    function GetGenerateSummary: boolean;
    function GetInputFile (Index: integer): tJson2PumlInputFileDefinition;
    function GetOutputPathExpanded: string;
    function GetSummaryInputFile: tJson2PumlInputFileDefinition;
    procedure SetCurlParameterList (const Value: tJson2PumlCurlParameterList);
    procedure SetCurlSpanIdHeader (const Value: string);
    procedure SetCurlTraceIdHeader (const Value: string);
    procedure SetExpandInputListCount (const Value: integer);
    procedure SetExpandInputListPosition (const Value: integer);
    procedure SetOutputFormatStr (const Value: string);
    procedure SetOutputPath (const Value: string);
    procedure SetOutputSuffix (const Value: string);
    procedure SetSummaryFileName (const Value: string);
  protected
    function AddInputFileAfterCurl (iSourceFile: tJson2PumlInputFileDefinition): tJson2PumlInputFileDefinition;
      overload;
    function AddInputFileFileSearch (const iInputFileName, iOutputFileName, iLeadingObject: string;
      const iSplitInputFile: boolean; const iSplitIdentifier: string; iGenerateOutput: boolean)
      : tJson2PumlInputFileDefinition; overload;
    function AddInputFileSplit (const iInputFileName, iOutputFileName, iLeadingObject: string;
      iCurlResult: tJson2PumlCurlResult; iGenerateOutput: boolean): tJson2PumlInputFileDefinition; overload;
    function AddInputFileSummary (const iInputFileName: string): tJson2PumlInputFileDefinition;
    function CalculateOutputFileName (iFileName, iSourceFileName: string): string;
    function CreateListValueObject: tJson2PumlBaseObject; override;
    function ExpandInputListCurlFile (iCurrentInputFile: tJson2PumlInputFileDefinition;
      iIgnoreCurlCache: boolean): boolean;
    function ExpandInputListSplitFile (iInputFile: tJson2PumlInputFileDefinition): boolean;
    function GetIsValid: boolean; override;
    procedure ValidateCurlParameter;
    property ExpandInputListCount: integer read FExpandInputListCount write SetExpandInputListCount;
    property ExpandInputListPosition: integer read FExpandInputListPosition write SetExpandInputListPosition;
    property OnCalculateOutputFileName: tJson2PumlCalculateOutputFilenameEvent read FOnCalculateOutputFileName;
  public
    constructor Create; override;
    constructor CreateOnCalculate (iOnCalculateOutputFileName: tJson2PumlCalculateOutputFilenameEvent);
    destructor Destroy; override;
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    function AddInputFileCommandLine (const iInputFileName, iOutputFileName, iLeadingObject, iSplitInputFileStr,
      iSplitIdentifier: string): tJson2PumlInputFileDefinition; overload;
    procedure AddSummaryFile (const iFileName: string);
    procedure Clear; override;
    procedure DeleteGeneratedFiles (const iOutputDir: string);
    procedure ExpandInputList (iIgnoreCurlCache: boolean);
    procedure GenerateSummaryZipfile (iZipfileName: string; iOutputFormats: tJson2PumlOutputFormats);
    function GetEnumerator: tJson2PumlInputListEnumerator;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonOutputFiles (iFileName: string; iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonOutputFiles (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceListResult (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceResult (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iOutputFormats: tJson2PumlOutputFormats; iApiVersion: tJson2PumlApiVersion;
      iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceResult (oJsonOutPut: tStrings; iOutputFormats: tJson2PumlOutputFormats;
      iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false); overload;
    property curlAdditionalRuntimeOptions: string read FcurlAdditionalRuntimeOptions
      write FcurlAdditionalRuntimeOptions;
    property CurlAuthenticationList: tJson2PumlCurlAuthenticationList read FCurlAuthenticationList
      write FCurlAuthenticationList;
    property CurlBaseUrlDecoded: string read GetCurlBaseUrlDecoded;
    property CurlParameterList: tJson2PumlCurlParameterList read FCurlParameterList write SetCurlParameterList;
    property DefinitionFileNameExpanded: string read GetDefinitionFileNameExpanded;
    property ExecuteCount: integer read GetExecuteCount;
    property ExecuteLogFileName: string read FExecuteLogFileName write FExecuteLogFileName;
    property ExistsCount: integer read GetExistsCount;
    property FileListFileName: string read FFileListFileName write FFileListFileName;
    property InputFile[index: integer]: tJson2PumlInputFileDefinition read GetInputFile; default;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
    property OutputPathExpanded: string read GetOutputPathExpanded;
    property SummaryInputFile: tJson2PumlInputFileDefinition read GetSummaryInputFile;
    property SummaryZipFileName: string read FSummaryZipFileName write FSummaryZipFileName;
    property OnNotifyChange: tJson2PumlNotifyChangeEvent read FOnNotifyChange write FOnNotifyChange;
  published
    property CurlBaseUrl: string read FCurlBaseUrl write FCurlBaseUrl;
    property CurlMappingParameterList: tJson2PumlCurlMappingParameterList read FCurlMappingParameterList;
    property CurlOptions: string read FCurlOptions write FCurlOptions;
    property CurlSpanIdHeader: string read FCurlSpanIdHeader write SetCurlSpanIdHeader;
    property CurlTraceIdHeader: string read FCurlTraceIdHeader write SetCurlTraceIdHeader;
    property CurlUrlAddon: string read FCurlUrlAddon write FCurlUrlAddon;
    property CurlUserAgentInformation: string read FCurlUserAgentInformation write FCurlUserAgentInformation;
    property DefinitionFileName: string read FDefinitionFileName write FDefinitionFileName;
    property Description: tJson2PumlInputListDescriptionDefinition read FDescription;
    property Detail: string read FDetail write FDetail;
    property GenerateDetails: boolean read GetGenerateDetails;
    property GenerateDetailsStr: string read FGenerateDetailsStr write FGenerateDetailsStr;
    property GenerateSummary: boolean read GetGenerateSummary;
    property GenerateSummaryStr: string read FGenerateSummaryStr write FGenerateSummaryStr;
    property Group: string read FGroup write FGroup;
    property JobDescription: string read FJobDescription write FJobDescription;
    property Jobname: string read FJobname write FJobname;
    property Option: string read FOption write FOption;
    property OutputFormatStr: string read FOutputFormatStr write SetOutputFormatStr;
    property OutputPath: string read FOutputPath write SetOutputPath;
    property OutputSuffix: string read FOutputSuffix write SetOutputSuffix;
    property SummaryFileName: string read FSummaryFileName write SetSummaryFileName;
  end;

  tJson2PumlCommandLineParameter = class(tPersistent)
  private
    FBaseOutputPath: string;
    FConfigurationFileName: string;
    FConfigurationFileNameEnvironment: string;
    FCurlAuthenticationFileName: string;
    FCurlAuthenticationFileNameEnvironment: string;
    FCurlAuthenticationParameter: tJson2PumlCurlParameterList;
    FCurlIgnoreCache: boolean;
    FCurlParameter: tJson2PumlCurlParameterList;
    FCurlParameterFileName: string;
    FCurlPassThroughHeader: string;
    FDebug: boolean;
    FDefinitionFileName: string;
    FDefinitionFileNameEnvironment: string;
    FDetail: string;
    FFailed: boolean;
    FFormatDefinitionFiles: boolean;
    FGenerateDefaultConfiguration: boolean;
    FGenerateDetailsStr: string;
    FGenerateOutputDefinition: boolean;
    FGenerateSummaryStr: string;
    FGroup: string;
    FIdentFilter: string;
    FInputFileName: string;
    FInputFilterList: tJson2PumlFilterList;
    FInputListFileName: string;
    FJavaRuntimeParameter: string;
    FJobDescription: string;
    FJobname: string;
    FLeadingObject: string;
    FNoLogFiles: boolean;
    FOpenOutputs: tJson2PumlOutputFormats;
    FOpenOutputsStr: string;
    FOption: string;
    FOptionFileName: string;
    FOutputFormats: tJson2PumlOutputFormats;
    FOutputFormatStr: string;
    FOutputPath: string;
    FOutputSuffix: string;
    FParameterFileContent: string;
    FParameterFileName: string;
    FPlantUmlJarFileName: string;
    FPlantUmlJarFileNameEnvironment: string;
    FPlantUmlRuntimeParameter: string;
    FServicePort: integer;
    FServicePortStr: string;
    FSplitIdentifier: string;
    FSplitInputFileStr: string;
    FSummaryFileName: string;
    FTitleFilter: string;
    function GetGenerateDetails: boolean;
    function GetGenerateSummary: boolean;
    function GetSplitInputFile: boolean;
    procedure SetIdentFilter (const Value: string);
    procedure SetOpenOutputsStr (const Value: string);
    procedure SetOutputFormatStr (const Value: string);
    procedure SetOutputSuffix (const Value: string);
    procedure SetServicePortStr (const Value: string);
    procedure SetTitleFilter (const Value: string);
  protected
    function ExistsSingleInputParameter (iParameterName: string): boolean;
    procedure HandleGenerateDefaultConfiguration;
    procedure LogParameterValue (iParameterName: string; iParameterValue: boolean; iAllways: boolean = false); overload;
    procedure LogParameterValue (iParameterName: string; iParameterValue: string = ''; iParameterDetail: string = '';
      iAllways: boolean = false); overload;
    procedure ReadCurlParameter;
    function ReadSingleInputParameter (iParameterName: string): string;
    function ReadSingleInputParameterEnvironment (iParameterName: string): string;
    function ReadSingleInputParameterFile (iParameterName: string): string;
    procedure ValidateFileInputParameter (iParameterName: string; var ioParameterValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    function CommandLineParameterStr (iIncludeProgram: boolean): string;
    procedure GenerateEnvironmentParameters (iLogList: tStringList);
    procedure GenerateLogParameters (iLogList: tStringList);
    procedure LogLineWrapped (iParameter, iDescription: string; iParameterLength: integer = 50;
      iLineLength: integer = 110);
    procedure ReadInputParameter;
    procedure WriteHelpLine (iParameter: string = ''; iDescription: string = ''; iParameterLength: integer = 31;
      iLineLength: integer = 111);
    procedure WriteHelpScreen;
    property CurlAuthenticationParameter: tJson2PumlCurlParameterList read FCurlAuthenticationParameter;
    property CurlParameter: tJson2PumlCurlParameterList read FCurlParameter;
    property CurlPassThroughHeader: string read FCurlPassThroughHeader write FCurlPassThroughHeader;
    property GenerateDefaultConfiguration: boolean read FGenerateDefaultConfiguration
      write FGenerateDefaultConfiguration;
    property GenerateSummary: boolean read GetGenerateSummary;
    property InputFilterList: tJson2PumlFilterList read FInputFilterList;
    property OpenOutputs: tJson2PumlOutputFormats read FOpenOutputs;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
    property ServicePort: integer read FServicePort;
    property SplitInputFile: boolean read GetSplitInputFile;
  published
    property BaseOutputPath: string read FBaseOutputPath write FBaseOutputPath;
    property ConfigurationFileName: string read FConfigurationFileName write FConfigurationFileName;
    property ConfigurationFileNameEnvironment: string read FConfigurationFileNameEnvironment
      write FConfigurationFileNameEnvironment;
    property CurlAuthenticationFileName: string read FCurlAuthenticationFileName write FCurlAuthenticationFileName;
    property CurlAuthenticationFileNameEnvironment: string read FCurlAuthenticationFileNameEnvironment
      write FCurlAuthenticationFileNameEnvironment;
    property CurlIgnoreCache: boolean read FCurlIgnoreCache write FCurlIgnoreCache;
    property CurlParameterFileName: string read FCurlParameterFileName write FCurlParameterFileName;
    property Debug: boolean read FDebug write FDebug;
    property DefinitionFileName: string read FDefinitionFileName write FDefinitionFileName;
    property DefinitionFileNameEnvironment: string read FDefinitionFileNameEnvironment
      write FDefinitionFileNameEnvironment;
    property Detail: string read FDetail write FDetail;
    property Failed: boolean read FFailed write FFailed;
    property FormatDefinitionFiles: boolean read FFormatDefinitionFiles write FFormatDefinitionFiles;
    property GenerateDetails: boolean read GetGenerateDetails;
    property GenerateDetailsStr: string read FGenerateDetailsStr write FGenerateDetailsStr;
    property GenerateOutputDefinition: boolean read FGenerateOutputDefinition write FGenerateOutputDefinition;
    property GenerateSummaryStr: string read FGenerateSummaryStr write FGenerateSummaryStr;
    property Group: string read FGroup write FGroup;
    property IdentFilter: string read FIdentFilter write SetIdentFilter;
    property InputFileName: string read FInputFileName write FInputFileName;
    property InputListFileName: string read FInputListFileName write FInputListFileName;
    property JavaRuntimeParameter: string read FJavaRuntimeParameter write FJavaRuntimeParameter;
    property JobDescription: string read FJobDescription write FJobDescription;
    property Jobname: string read FJobname write FJobname;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
    property NoLogFiles: boolean read FNoLogFiles write FNoLogFiles;
    property OpenOutputsStr: string read FOpenOutputsStr write SetOpenOutputsStr;
    property Option: string read FOption write FOption;
    property OptionFileName: string read FOptionFileName write FOptionFileName;
    property OutputFormatStr: string read FOutputFormatStr write SetOutputFormatStr;
    property OutputPath: string read FOutputPath write FOutputPath;
    property OutputSuffix: string read FOutputSuffix write SetOutputSuffix;
    property ParameterFileContent: string read FParameterFileContent write FParameterFileContent;
    property ParameterFileName: string read FParameterFileName write FParameterFileName;
    property PlantUmlJarFileName: string read FPlantUmlJarFileName write FPlantUmlJarFileName;
    property PlantUmlJarFileNameEnvironment: string read FPlantUmlJarFileNameEnvironment
      write FPlantUmlJarFileNameEnvironment;
    property PlantUmlRuntimeParameter: string read FPlantUmlRuntimeParameter write FPlantUmlRuntimeParameter;
    property ServicePortStr: string read FServicePortStr write SetServicePortStr;
    property SplitIdentifier: string read FSplitIdentifier write FSplitIdentifier;
    property SplitInputFileStr: string read FSplitInputFileStr write FSplitInputFileStr;
    property SummaryFileName: string read FSummaryFileName write FSummaryFileName;
    property TitleFilter: string read FTitleFilter write SetTitleFilter;
  end;

  tJson2PumlCurlBaseParameterDefinition = class(tJson2PumlBaseObject)
  private
    FName: string;
    procedure SetName (const Value: string);
  protected
    function GetIdent: string; override;
  public
    procedure Assign (Source: tPersistent); override;
  published
    property name: string read FName write SetName;
  end;

  tJson2PumlCurlMappingParameterDefinition = class(tJson2PumlCurlBaseParameterDefinition)
  private
    FPrefix: string;
    FSuffix: string;
    FUrlEncodeValue: boolean;
    FValueIfEmpty: string;
    FValue: string;
    function GetCalculatedValue: string;
  protected
    function GetIsFilled: boolean; override;
    function GetIsValid: boolean; override;
  public
    constructor Create; override;
    procedure Assign (Source: tPersistent); override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property CalculatedValue: string read GetCalculatedValue;
  published
    property Prefix: string read FPrefix write FPrefix;
    property Suffix: string read FSuffix write FSuffix;
    property UrlEncodeValue: boolean read FUrlEncodeValue write FUrlEncodeValue default false;
    property Value: string read FValue write FValue;
    property ValueIfEmpty: string read FValueIfEmpty write FValueIfEmpty;
  end;

  tJson2PumlCurlMappingParameterEnumerator = class
  private
    FIndex: integer;
    fInputList: tJson2PumlCurlMappingParameterList;
  public
    constructor Create (AInputList: tJson2PumlCurlMappingParameterList);
    function GetCurrent: tJson2PumlCurlMappingParameterDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlCurlMappingParameterDefinition read GetCurrent;
  end;

  tJson2PumlCurlMappingParameterList = class(tJson2PumlBasePropertyList)
  private
    function GetParameter (Index: integer): tJson2PumlCurlMappingParameterDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: tJSONValue); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddParameter (iName, iPrefix, iValue, iSuffix, iValueIfEmpty: string; iUrlEncodeValue: boolean)
      : boolean; overload;
    function GetEnumerator: tJson2PumlCurlMappingParameterEnumerator;
    function ReplaceParameterValues (iValueString: string): string;
    property Parameter[index: integer]: tJson2PumlCurlMappingParameterDefinition read GetParameter; default;
  published
  end;

  tJson2PumlCurlParameterDefinition = class(tJson2PumlCurlBaseParameterDefinition)
  private
    FMaxValues: integer;
    FMulitpleValues: boolean;
    FValue: string;
    function GetValueDecoded: string;
  protected
    function GetIdent: string; override;
    property MulitpleValues: boolean read FMulitpleValues write FMulitpleValues default false;
  public
    procedure Assign (Source: tPersistent); override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property ValueDecoded: string read GetValueDecoded;
  published
    property MaxValues: integer read FMaxValues write FMaxValues;
    property Value: string read FValue write FValue;
  end;

  tJson2PumlCurlParameterEnumerator = class
  private
    FIndex: integer;
    fInputList: tJson2PumlCurlParameterList;
  public
    constructor Create (AInputList: tJson2PumlCurlParameterList);
    function GetCurrent: tJson2PumlCurlParameterDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlCurlParameterDefinition read GetCurrent;
  end;

  tJson2PumlCurlParameterList = class(tJson2PumlBasePropertyList)
  private
    FMulitpleValues: boolean;
    function GetParameter (Index: integer): tJson2PumlCurlParameterDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: tJSONValue); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddParameter (iName, iValue: string; iMaxValues: integer = 0): boolean; overload;
    function AddParameter (iParameter: tJson2PumlCurlParameterDefinition): boolean; overload;
    procedure AddParameter (iParameterList: tJson2PumlCurlParameterList; iNameFilter: string = ''); overload;
    function GetEnumerator: tJson2PumlCurlParameterEnumerator;
    procedure GetParameterNameList (ioNameList: tStringList; const iValueString: string);
    function ParameterNameCount (iParameterName: string): integer;
    function ReplaceParameterValues (iValueString: string): string;
    function ReplaceParameterValuesFileName (iFileName: string): string;
    property Parameter[index: integer]: tJson2PumlCurlParameterDefinition read GetParameter; default;
  published
    property MulitpleValues: boolean read FMulitpleValues write FMulitpleValues default false;
  end;

  tJson2PumlCurlAuthenticationParameterList = class(tJson2PumlCurlParameterList)
  protected
    function ObfuscateValue (iValueString: string): string;
  public
    function ReplaceParameterValuesObfuscated (iValueString: string): string;
  end;

  tJson2PumlCurlFileParameterListMatrix = class(tPersistent)
  private
    FNameList: tStringList;
    FRowList: tStringList;
    function GetRowParameterList (Index: integer): tJson2PumlCurlParameterList;
  protected
    procedure AddRow (iParameterList: tJson2PumlCurlParameterList);
    procedure FillRows (iCurrentRow: tJson2PumlCurlParameterList; iDepth: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure FillMatrix (iParameterList: tJson2PumlCurlParameterList; iFileName: string);
    property NameList: tStringList read FNameList;
    property RowList: tStringList read FRowList;
    property RowParameterList[index: integer]: tJson2PumlCurlParameterList read GetRowParameterList;
  end;

  tJson2PumlCurlAuthenticationDefinition = class(tJson2PumlBaseObject)
  private
    FBaseUrl: string;
    FParameter: tJson2PumlCurlAuthenticationParameterList;
    function GetBaseUrlDecoded: string;
    procedure SetBaseUrl (const Value: string);
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    property BaseUrlDecoded: string read GetBaseUrlDecoded;
  published
    property BaseUrl: string read FBaseUrl write SetBaseUrl;
    property Parameter: tJson2PumlCurlAuthenticationParameterList read FParameter;
  end;

  tJson2PumlCurlAuthenticationEnumerator = class
  private
    FIndex: integer;
    fInputList: tJson2PumlCurlAuthenticationList;
  public
    constructor Create (AInputList: tJson2PumlCurlAuthenticationList);
    function GetCurrent: tJson2PumlCurlAuthenticationDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlCurlAuthenticationDefinition read GetCurrent;
  end;

  tJson2PumlCurlAuthenticationList = class(tJson2PumlBasePropertyList)
  private
    FAdditionalCurlParameter: tJson2PumlCurlParameterList;
    function GetAuthentication (Index: integer): tJson2PumlCurlAuthenticationDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddAuthentication (iBaseUrl: string): tJson2PumlCurlAuthenticationDefinition;
    function FindAuthentication (const iBaseUrl: string): tJson2PumlCurlAuthenticationDefinition;
    function GetEnumerator: tJson2PumlCurlAuthenticationEnumerator;
    function ReplaceParameterValues (const iBaseUrl, iCommand: string): string;
    function ReplaceParameterValuesObfuscated (const iBaseUrl, iCommand: string): string;
    property Authentication[index: integer]: tJson2PumlCurlAuthenticationDefinition read GetAuthentication; default;
    property AdditionalCurlParameter: tJson2PumlCurlParameterList read FAdditionalCurlParameter;
  end;

  tJson2PumlCurlResult = class(tPersistent)
  private
    FCommand: string;
    FDuration: integer;
    FErrorMessage: string;
    FExitCode: string;
    FFileSize: integer;
    FGenerated: boolean;
    FHttpCode: string;
    FOutPutFile: string;
    FNoOfRecords: integer;
    FUrl: string;
  public
    procedure Assign (Source: tPersistent); override;
    procedure Clear;
    property Command: string read FCommand write FCommand;
    property Duration: integer read FDuration write FDuration;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property ExitCode: string read FExitCode write FExitCode;
    property FileSize: integer read FFileSize write FFileSize;
    property Generated: boolean read FGenerated write FGenerated;
    property HttpCode: string read FHttpCode write FHttpCode;
    property OutPutFile: string read FOutPutFile write FOutPutFile;
    property NoOfRecords: integer read FNoOfRecords write FNoOfRecords;
    property Url: string read FUrl write FUrl;
  end;

function GlobalConfigurationDefinition: tJson2PumlGlobalDefinition;
function GlobalFileDeleteHandler: tJson2PumlFileDeleteHandler;
function GlobalCommandLineParameter: tJson2PumlCommandLineParameter;

implementation

uses
  System.SysUtils, System.Generics.Collections, System.Types, System.IOUtils, json2pumltools, System.Masks, jsontools,
  json2pumlconverterdefinition, System.RegularExpressions, System.NetEncoding;

var
  IntGlobalConfiguration: tJson2PumlGlobalDefinition;
  IntGlobalFileDeleteHandler: tJson2PumlFileDeleteHandler;
  IntGlobalCommandLineParameter: tJson2PumlCommandLineParameter;

function GlobalConfigurationDefinition: tJson2PumlGlobalDefinition;
begin
  Result := IntGlobalConfiguration;
end;

function GlobalCommandLineParameter: tJson2PumlCommandLineParameter;
begin
  Result := IntGlobalCommandLineParameter;
end;

procedure InitializationGlobalVariables;
var
  s: string;
begin
  IntGlobalCommandLineParameter := tJson2PumlCommandLineParameter.Create;
  GlobalCommandLineParameter.ReadInputParameter;

  s := GlobalCommandLineParameter.ConfigurationFileName;
  if (not s.IsEmpty) and FileExists (s) then
  else
    s := GlobalCommandLineParameter.ConfigurationFileNameEnvironment;

  IntGlobalConfiguration := tJson2PumlGlobalDefinition.Create;
  if (not s.IsEmpty) and FileExists (s) then
    IntGlobalConfiguration.ReadFromJsonFile (GetEnvironmentVariable(cConfigurationFileRegistry));
  IntGlobalFileDeleteHandler := tJson2PumlFileDeleteHandler.Create;
end;

procedure FinalizationGlobalVariables;
begin
  IntGlobalCommandLineParameter.Free;
  IntGlobalConfiguration.Free;
  IntGlobalFileDeleteHandler.Free;
end;

function GlobalFileDeleteHandler: tJson2PumlFileDeleteHandler;
begin
  Result := IntGlobalFileDeleteHandler;
end;

constructor tJson2PumlInputFileDefinition.Create;
begin
  inherited Create;
  FCurlOutputParameter := tJson2PumlCurlParameterList.Create ();
  FOutput := tJson2PumlFileOutputDefinition.Create ();
  FCurlResult := tJson2PumlCurlResult.Create ();
  Clear;
end;

destructor tJson2PumlInputFileDefinition.Destroy;
begin
  FCurlResult.Free;
  FOutput.Free;
  FCurlOutputParameter.Free;
  inherited Destroy;
end;

procedure tJson2PumlInputFileDefinition.AddFilesToZipFile (iZipFile: tZipFile; iRemoveDirectory: string;
  iOutputFormats: tJson2PumlOutputFormats);
begin
  if IncludeIntoOutput then
  begin
    if jofJSON in iOutputFormats then
      AddFileToZipFile (iZipFile, OutputFileName, iRemoveDirectory);
    Output.AddFilesToZipFile (iZipFile, iRemoveDirectory, iOutputFormats);
  end;
end;

procedure tJson2PumlInputFileDefinition.AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
begin
  if not IsOriginal and not OutputFileName.IsEmpty then
    ioDeleteHandler.AddFile (OutputFileName);
  Output.AddGeneratedFilesToDeleteHandler (ioDeleteHandler);
end;

procedure tJson2PumlInputFileDefinition.Clear;
begin
  inherited Clear;
  CurlOutputParameter.Clear;
  CurlResult.Clear;
  Output.Clear;
  IsConverted := false;
  IsInternalOnly := false;
  IsInputFileUsable := false;
  IsSplitFile := false;
  LeadingObject := '';
  SplitInputFile := false;
  SplitIdentifier := '';
  CurlBaseUrl := '';
  CurlUrl := '';
  CurlFileNameSuffix := '';
  CurlFormatOutput := true;
  CurlOptions := '';
  CurlCache := 0;
  IsOriginal := false;
  GenerateOutput := true;
  Mandatory := false;
end;

procedure tJson2PumlInputFileDefinition.DeleteGeneratedFiles;

  procedure DeleteSingleFile (iFileName: string);
  begin
    if not iFileName.IsEmpty then
      try
        TFile.Delete (iFileName);
        // GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Error (jetFileDeletionFailed, [iFileName, e.Message]);
      end;
  end;

begin
  if not IsOriginal then
    DeleteSingleFile (OutputFileName);
  Output.DeleteGeneratedFiles;
end;

procedure tJson2PumlInputFileDefinition.ExpandFileNameWithCurlParameter (iCurlParameterList, iCurlDetailParameterList
  : tJson2PumlCurlParameterList; iCurlMappingParameterList: tJson2PumlCurlMappingParameterList);
var
  FileName, FilePath: string;
begin
  FileName := ExtractFileName (OutputFileName);
  FilePath := ExtractFilePath (OutputFileName);
  FileName := TCurlUtils.ReplaceCurlParameterValues (FileName, iCurlParameterList, iCurlDetailParameterList,
    iCurlMappingParameterList, false);
  FilePath := TCurlUtils.ReplaceCurlParameterValues (FilePath, iCurlParameterList, iCurlDetailParameterList,
    iCurlMappingParameterList, false);
  FilePath := ReplaceInvalidPathFileNameChars (FilePath, true);
  FileName := ReplaceInvalidFileNameChars (FileName, true);
  OutputFileName := TPath.Combine (FilePath, FileName);
end;

function tJson2PumlInputFileDefinition.GetCurlBaseUrlDecoded: string;
begin
  Result := ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (CurlBaseUrl);
end;

procedure tJson2PumlInputFileDefinition.GetCurlParameterFromFile (iCurlOutputParameter,
  iCurlParameterList: tJson2PumlCurlParameterList);
var
  FileContent: tStringList;
  JsonValue: tJSONValue;
  CurlParameter: tJson2PumlCurlParameterDefinition;
  ValueList: tStringList;
  i: integer;
begin
  if not Exists then
    exit;
  if not Assigned (iCurlOutputParameter) then
    exit;
  if iCurlOutputParameter.Count < 0 then
    exit;
  GlobalLoghandler.Info ('  Fetch Curl Parameter from "%s" ', [OutputFileName]);
  FileContent := tStringList.Create;
  ValueList := tStringList.Create;
  try
    FileContent.LoadFromFile (OutputFileName);
    JsonValue := tJSONObject.ParseJSONValue (FileContent.Text);
    if Assigned (JsonValue) then
      try
        for CurlParameter in iCurlOutputParameter do
        begin
          if CurlParameter.Value.Trim.IsEmpty then
            Continue;
          GetJsonStringValueList (ValueList, JsonValue, CurlParameter.Value);
          GlobalLoghandler.Info ('    Fetch parameter "%s" from value "%s" (Records found : %d)',
            [CurlParameter.name, CurlParameter.Value, ValueList.Count]);
          for i := 0 to ValueList.Count - 1 do
          begin
            if (CurlParameter.MaxValues > 0) and (iCurlParameterList.ParameterNameCount(CurlParameter.name) >=
              CurlParameter.MaxValues) then
              GlobalLoghandler.Info ('      Parameter "%s"(%d) : Value "%s" skipped',
                [CurlParameter.name, i, ValueList[i]])
            else if iCurlParameterList.AddParameter (CurlParameter.name, ValueList[i]) then
              GlobalLoghandler.Info ('      Parameter "%s"(%d) : Value "%s" found',
                [CurlParameter.name, i, ValueList[i]]);
          end;
        end;
      finally
        JsonValue.Free;
      end;
  finally
    ValueList.Free;
    FileContent.Free;
  end;
end;

function tJson2PumlInputFileDefinition.GetExists: boolean;
begin
  Result := FileExistsMinSize (OutputFileName);
end;

function tJson2PumlInputFileDefinition.GetExtractedOutputFileName: string;
begin
  Result := ExtractFileName (OutputFileName);
end;

function tJson2PumlInputFileDefinition.GetIdent: string;
begin
  Result := Format ('%s-%s', [LeadingObject.ToLower, InputFileName]);
end;

function tJson2PumlInputFileDefinition.GetIncludeIntoOutput: boolean;
begin
  Result := not IsInternalOnly and GenerateOutput and IsInputFileUsable;
end;

function tJson2PumlInputFileDefinition.GetInputFileNameExpanded: string;
begin
  Result := GetFileNameExpanded (InputFileName);
end;

function tJson2PumlInputFileDefinition.GetIsSplitFile: boolean;
begin
  Result := Output.IsSplitFile;
end;

function tJson2PumlInputFileDefinition.GetIsSummaryFile: boolean;
begin
  Result := Output.IsSummaryFile;
end;

function tJson2PumlInputFileDefinition.HandleCurl (const iBaseUrl: string; iUrlAddon: string;
  const iOptions: array of string; iExecuteCurlParameterList, ioResultCurlParameterList: tJson2PumlCurlParameterList;
  iCurlMappingParameterList: tJson2PumlCurlMappingParameterList;
  iCurlAuthenticationList: tJson2PumlCurlAuthenticationList; iIgnoreCurlCache: boolean): boolean;
var
  BaseUrl: string;
  Options: array of string;
  Cache: integer;
begin
  Result := false;
  if not HasValidCurl then
    exit;
  if iIgnoreCurlCache then
    Cache := 0
  else
    Cache := CurlCache;
  if CurlBaseUrl.Trim.IsEmpty then
    BaseUrl := iBaseUrl
  else
    BaseUrl := CurlBaseUrlDecoded;
  Options := [string.Join(' ', [CurlOptions, string.Join(' ', iOptions)]).Trim];
  ExpandFileNameWithCurlParameter (ioResultCurlParameterList, iExecuteCurlParameterList, iCurlMappingParameterList);
  if TCurlUtils.CheckExecuteEvaluation (OutputFileName, CurlExecuteEvaluation, iExecuteCurlParameterList,
    ioResultCurlParameterList, iCurlMappingParameterList) then
  begin
    Result := TCurlUtils.Execute (GlobalConfigurationDefinition.CurlCommand, BaseUrl, [CurlUrl.Trim, iUrlAddon.Trim],
      Options, OutputFileName, iCurlAuthenticationList, iExecuteCurlParameterList, ioResultCurlParameterList,
      iCurlMappingParameterList, Cache, CurlResult);
    if Result then
    begin
      Result := true;
      if CurlFormatOutput then
        FormatJsonFile (OutputFileName);
      if Mandatory and (CurlResult.NoOfRecords <= 0) then
        GlobalLoghandler.Error (jetInputLIstCurlFileMandatoryEmpty, [TPath.GetFileName(OutputFileName)])
      else
      begin
        GetCurlParameterFromFile (CurlOutputParameter, ioResultCurlParameterList);
      end;
    end
    else if Mandatory then
      GlobalLoghandler.Error (jetInputListCurlFileMissing, [TPath.GetFileName(OutputFileName)]);
  end;
end;

function tJson2PumlInputFileDefinition.HasValidCurl: boolean;
begin
  Result := not (CurlBaseUrl + CurlUrl).Trim.IsEmpty;
end;

function tJson2PumlInputFileDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  Definition: tJSONObject;
begin
  Result := false;
  Clear;
  if not (iJsonValue is tJSONObject) then
    exit;
  Definition := GetJsonObject (tJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  InputFileName := GetJsonStringValue (tJSONObject(Definition), 'inputFile').Trim;
  if TPath.GetExtension (InputFileName).TrimLeft ([TPath.ExtensionSeparatorChar]).IsEmpty then
    InputFileName := TPath.ChangeExtension (InputFileName, jofJSON.FileExtension(true));

  CurlFileNameSuffix := GetJsonStringValue (tJSONObject(Definition), 'curlFileSuffix');

  if InputFileName.IsEmpty then
    exit;
  LeadingObject := GetJsonStringValue (tJSONObject(Definition), 'leadingObject');
  SplitInputFile := GetJsonStringValueBoolean (tJSONObject(Definition), 'splitInputFile', false);
  SplitIdentifier := GetJsonStringValue (tJSONObject(Definition), 'splitIdentifier');
  CurlBaseUrl := GetJsonStringValue (tJSONObject(Definition), 'curlBaseUrl');
  CurlUrl := GetJsonStringValue (tJSONObject(Definition), 'curlUrl');
  CurlOptions := GetJsonStringValue (tJSONObject(Definition), 'curlOptions');
  CurlFormatOutput := GetJsonStringValueBoolean (tJSONObject(Definition), 'curlFormatOutput', true);
  CurlCache := GetJsonStringValueInteger (tJSONObject(Definition), 'curlCache', 0);
  CurlExecuteEvaluation := GetJsonStringValue (tJSONObject(Definition), 'curlExecuteEvaluation');
  GenerateOutput := GetJsonStringValueBoolean (tJSONObject(Definition), 'generateOutput', true);
  Mandatory := GetJsonStringValueBoolean (tJSONObject(Definition), 'mandatory', false);
  CurlOutputParameter.ReadFromJson (tJSONObject(Definition), 'curlOutputParameter');
  IsOriginal := true;
  IsInputFileUsable := true;
  IsSplitFile := false;
  IsSummaryFile := false;
  Result := true;
end;

procedure tJson2PumlInputFileDefinition.SetCurlFileNameSuffix (const Value: string);
begin
  FCurlFileNameSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlInputFileDefinition.SetInputFileName (const Value: string);
begin
  FInputFileName := Value;
end;

procedure tJson2PumlInputFileDefinition.SetIsSplitFile (const Value: boolean);
begin
  Output.IsSplitFile := Value;
end;

procedure tJson2PumlInputFileDefinition.SetIsSummaryFile (const Value: boolean);
begin
  Output.IsSummaryFile := Value;
end;

procedure tJson2PumlInputFileDefinition.SetOutputFileName (const Value: string);
begin
  FOutputFileName := Value;
end;

procedure tJson2PumlInputFileDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  if not IsOriginal then
    exit;
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'inputFile', InputFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'leadingObject', LeadingObject, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateOutput', GenerateOutput, iLevel + 1);
  WriteToJsonValue (oJsonOutPut, 'mandatory', Mandatory, iLevel + 1);
  WriteToJsonValue (oJsonOutPut, 'curlBaseUrl', CurlBaseUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlCache', CurlCache.ToString, iLevel + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'curlExecuteEvaluation', CurlExecuteEvaluation, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlFileSuffix', CurlFileNameSuffix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlFormatOutput', CurlFormatOutput, iLevel + 1);
  WriteToJsonValue (oJsonOutPut, 'curlOptions', CurlOptions, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUrl', CurlUrl, iLevel + 1, iWriteEmpty);
  CurlOutputParameter.WriteToJson (oJsonOutPut, 'curlOutputParameter', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'splitIdentifier', SplitIdentifier, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'splitInputFile', SplitInputFile, iLevel + 1);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputFileDefinition.WriteToJsonOutputFile (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'file', InputFileName, iLevel + 1, iWriteEmpty);
  if not CurlResult.Command.IsEmpty then
    WriteToJsonValue (oJsonOutPut, 'curlCommand', CurlResult.Command, iLevel + 1, iWriteEmpty);
  Output.WriteToJson (oJsonOutPut, 'outputFiles', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputFileDefinition.WriteToJsonServiceResult (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iOutputFormats: tJson2PumlOutputFormats; iApiVersion: tJson2PumlApiVersion;
  iWriteEmpty: boolean = false);

  procedure WriteFile (iOutputFormat: tJson2PumlOutputFormat; iFileName: string);
  begin
    if not (iOutputFormat in iOutputFormats) then
      exit;
    if iFileName.IsEmpty then
      exit;
    if not FileExists (iFileName) then
      exit;
    WriteToJsonFileNameContent (oJsonOutPut, iOutputFormat.ServiceResultName, iLevel + 1, iFileName, true,
      iOutputFormat.IsBinaryOutput, iWriteEmpty);
  end;

  procedure WriteFilev2 (iOutputFormat: tJson2PumlOutputFormat; iFileName: string);
  begin
    if not (iOutputFormat in iOutputFormats) then
      exit;
    if iFileName.IsEmpty then
      exit;
    if not FileExists (iFileName) then
      exit;
    WriteObjectStartToJson (oJsonOutPut, iLevel, '');
    WriteToJsonValue (oJsonOutPut, 'inputFileName', ExtractFileName(InputFileName), iLevel + 1, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'outputFileName', ExtractFileName(iFileName), iLevel + 1, iWriteEmpty);
    if IsSummaryFile then
      WriteToJsonValue (oJsonOutPut, 'outputDirectory', '', iLevel + 1, iWriteEmpty)
    else
      WriteToJsonValue (oJsonOutPut, 'outputDirectory', tPath.GetFileNameWithoutExtension(inputFilename), iLevel + 1, iWriteEmpty);
    if not CurlResult.Command.IsEmpty then
      WriteToJsonValue (oJsonOutPut, 'curlCommand', CurlResult.Command, iLevel + 1, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'outputFormat', iOutputFormat.ToString, iLevel + 1, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'isSplitFile', IsSplitFile, iLevel + 1);
    WriteToJsonValue (oJsonOutPut, 'isSummaryFile', IsSummaryFile, iLevel + 1);
    WriteToJsonValue (oJsonOutPut, 'content', ConvertFileToBase64(iFileName), iLevel + 1, iWriteEmpty);
    WriteObjectEndToJson (oJsonOutPut, iLevel);
  end;

begin
  if iApiVersion = jav1 then
  begin
    WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
    WriteToJsonValue (oJsonOutPut, 'source', ExtractFileName(InputFileName), iLevel + 1, iWriteEmpty);
    if not CurlResult.Command.IsEmpty then
      WriteToJsonValue (oJsonOutPut, 'curlCommand', CurlResult.Command, iLevel + 1, iWriteEmpty);
    WriteFile (jofJSON, InputFileName);
    WriteFile (jofSVG, Output.SVGFileName);
    WriteFile (jofPNG, Output.PNGFileName);
    WriteFile (jofPDF, Output.PDFFilename);
    WriteFile (jofPUML, Output.PUmlFileName);
    WriteFile (jofLog, Output.ConverterLogFileName);
    WriteObjectEndToJson (oJsonOutPut, iLevel);
  end
  else
  begin
    WriteFilev2 (jofJSON, InputFileName);
    WriteFilev2 (jofSVG, Output.SVGFileName);
    WriteFilev2 (jofPNG, Output.PNGFileName);
    WriteFilev2 (jofPDF, Output.PDFFilename);
    WriteFilev2 (jofPUML, Output.PUmlFileName);
    WriteFilev2 (jofLog, Output.ConverterLogFileName);
  end;
end;

constructor tJson2PumlInputList.Create;
begin
  inherited Create;
  FDescription := tJson2PumlInputListDescriptionDefinition.Create ();
  FCurlMappingParameterList := tJson2PumlCurlMappingParameterList.Create ();
  FExpandInputListCount := 0;
  FExpandInputListPosition := 0;
end;

constructor tJson2PumlInputList.CreateOnCalculate (iOnCalculateOutputFileName: tJson2PumlCalculateOutputFilenameEvent);
begin
  Create;
  FOnCalculateOutputFileName := iOnCalculateOutputFileName;
end;

destructor tJson2PumlInputList.Destroy;
begin
  FCurlMappingParameterList.Free;
  FDescription.Free;
  inherited Destroy;
end;

procedure tJson2PumlInputList.AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
var
  InputFile: tJson2PumlInputFileDefinition;
begin
  for InputFile in self do
    InputFile.AddGeneratedFilesToDeleteHandler (ioDeleteHandler);
  ioDeleteHandler.AddFile (FileListFileName);
  ioDeleteHandler.AddFile (SummaryZipFileName);
  ioDeleteHandler.AddFile (ExecuteLogFileName);
end;

function tJson2PumlInputList.AddInputFileCommandLine (const iInputFileName, iOutputFileName, iLeadingObject,
  iSplitInputFileStr, iSplitIdentifier: string): tJson2PumlInputFileDefinition;
var
  NewInputFile: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  if iInputFileName.IsEmpty then
    exit;
  NewInputFile := tJson2PumlInputFileDefinition.Create;
  NewInputFile.InputFileName := iInputFileName;
  NewInputFile.OutputFileName := iOutputFileName;
  NewInputFile.LeadingObject := iLeadingObject;
  NewInputFile.SplitInputFile := StringToBoolean (ValidateBooleanInput(iSplitInputFileStr), false);
  NewInputFile.SplitIdentifier := iSplitIdentifier;
  NewInputFile.IsOriginal := true;
  NewInputFile.GenerateOutput := true;
  NewInputFile.IsInputFileUsable := true;
  NewInputFile.IsSplitFile := false;
  NewInputFile.IsSummaryFile := false;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

function tJson2PumlInputList.AddInputFileAfterCurl (iSourceFile: tJson2PumlInputFileDefinition)
  : tJson2PumlInputFileDefinition;
var
  NewInputFile: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  if iSourceFile.InputFileName.IsEmpty then
    exit;
  NewInputFile := tJson2PumlInputFileDefinition.Create;
  NewInputFile.InputFileName := iSourceFile.InputFileName;
  NewInputFile.OutputFileName := iSourceFile.OutputFileName;
  NewInputFile.LeadingObject := iSourceFile.LeadingObject;
  NewInputFile.SplitInputFile := iSourceFile.SplitInputFile;
  NewInputFile.SplitIdentifier := iSourceFile.SplitIdentifier;
  NewInputFile.CurlFormatOutput := true;
  NewInputFile.IsOriginal := false;
  NewInputFile.GenerateOutput := iSourceFile.GenerateOutput;
  NewInputFile.CurlResult.Assign (iSourceFile.CurlResult);
  NewInputFile.IsInputFileUsable := iSourceFile.CurlResult.Generated;
  NewInputFile.IsSplitFile := false;
  NewInputFile.IsSummaryFile := false;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

function tJson2PumlInputList.AddInputFileFileSearch (const iInputFileName, iOutputFileName, iLeadingObject: string;
  const iSplitInputFile: boolean; const iSplitIdentifier: string; iGenerateOutput: boolean)
  : tJson2PumlInputFileDefinition;
var
  NewInputFile: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  if iInputFileName.IsEmpty then
    exit;
  NewInputFile := tJson2PumlInputFileDefinition.Create;
  NewInputFile.InputFileName := iInputFileName;
  NewInputFile.OutputFileName := iOutputFileName;
  NewInputFile.LeadingObject := iLeadingObject;
  NewInputFile.SplitInputFile := iSplitInputFile;
  NewInputFile.SplitIdentifier := iSplitIdentifier;
  NewInputFile.IsOriginal := false;
  NewInputFile.GenerateOutput := iGenerateOutput;
  NewInputFile.IsInputFileUsable := true;
  NewInputFile.IsSplitFile := false;
  NewInputFile.IsSummaryFile := false;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

function tJson2PumlInputList.AddInputFileSplit (const iInputFileName, iOutputFileName, iLeadingObject: string;
  iCurlResult: tJson2PumlCurlResult; iGenerateOutput: boolean): tJson2PumlInputFileDefinition;
var
  NewInputFile: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  if iInputFileName.IsEmpty then
    exit;
  NewInputFile := tJson2PumlInputFileDefinition.Create;
  NewInputFile.InputFileName := iInputFileName;
  NewInputFile.OutputFileName := iOutputFileName;
  NewInputFile.LeadingObject := iLeadingObject;
  NewInputFile.IsOriginal := false;
  NewInputFile.GenerateOutput := iGenerateOutput;
  NewInputFile.CurlResult.Assign (iCurlResult);
  NewInputFile.IsInputFileUsable := true;
  NewInputFile.IsSplitFile := true;
  NewInputFile.IsSummaryFile := false;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

function tJson2PumlInputList.AddInputFileSummary (const iInputFileName: string): tJson2PumlInputFileDefinition;
var
  NewInputFile: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  if iInputFileName.IsEmpty then
    exit;
  NewInputFile := tJson2PumlInputFileDefinition.Create;
  NewInputFile.InputFileName := iInputFileName;
  NewInputFile.OutputFileName := iInputFileName;
  NewInputFile.IsOriginal := false;
  NewInputFile.GenerateOutput := true;
  NewInputFile.IsInputFileUsable := true;
  NewInputFile.IsSplitFile := false;
  NewInputFile.IsSummaryFile := true;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

procedure tJson2PumlInputList.AddSummaryFile (const iFileName: string);
var
  InputFile: tJson2PumlInputFileDefinition;
  FileDefinition: tJson2PumlInputFileDefinition;
begin
  FileDefinition := AddInputFileSummary (iFileName);
  for InputFile in self do
  begin
    if not InputFile.IncludeIntoOutput then
      Continue;
    if InputFile = FileDefinition then
      Continue;
    FileDefinition.Output.AddSourceFile (InputFile.OutputFileName);
  end;
end;

function tJson2PumlInputList.CalculateOutputFileName (iFileName, iSourceFileName: string): string;
var
  FilePath: string;
  InputPath: string;
begin
  Result := '';
  if iFileName.Trim.IsEmpty then
    exit;
  if Assigned (FOnCalculateOutputFileName) then
    Result := FOnCalculateOutputFileName (iFileName, iSourceFileName)
  else
  begin
    FilePath := ExtractFilePath (iFileName);
    InputPath := ExtractFilePath (SourceFileName);

    if FilePath.IsEmpty then
      Result := PathCombine (InputPath, iFileName)
    else
    begin
      iFileName := PathCombine (PathCombineIfRelative(InputPath, FilePath), TPath.GetFileName(iFileName));
      Result := iFileName;
    end;
  end;
end;

procedure tJson2PumlInputList.Clear;
begin
  inherited Clear;
  CurlMappingParameterList.Clear;
  Description.Clear;
  GenerateDetailsStr := '';
  GenerateSummaryStr := '';
  SummaryZipFileName := '';
end;

function tJson2PumlInputList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := tJson2PumlInputFileDefinition.Create;
end;

procedure tJson2PumlInputList.DeleteGeneratedFiles (const iOutputDir: string);
var
  InputFile: tJson2PumlInputFileDefinition;
begin
  for InputFile in self do
    InputFile.DeleteGeneratedFiles;
  if not iOutputDir.IsEmpty then
    if TDirectory.Exists (iOutputDir) then
      try
        TDirectory.Delete (iOutputDir, true);
        // GlobalLoghandler.Debug ('Directory "%s" deleted."', [iOutputDir]);
      except
        on e: exception do
          GlobalLoghandler.Error ('Deleting of directory "%s" failed. (%s)', [iOutputDir, e.Message]);
      end;
end;

procedure tJson2PumlInputList.ExpandInputList (iIgnoreCurlCache: boolean);
var
  InputFile: tJson2PumlInputFileDefinition;
  searchResult: tSearchRec;
  FileName: string;
  NewPath: string;
  i: integer;
  NotFound: string;
  First: boolean;

begin
  ValidateCurlParameter;
  ExpandInputListCount := Count;

  for InputFile in self do
  begin
    if GlobalLoghandler.Failed then
      exit;
    ExpandInputListPosition := ExpandInputListPosition + 1;
    if not InputFile.IsOriginal then
      Continue;
    if ExpandInputListCurlFile (InputFile, iIgnoreCurlCache) then
      Continue;
    if InputFile.Exists then
    begin
      if InputFile.IsOriginal then
        GlobalLoghandler.Debug ('File "%s" (%s) found.',
          [InputFile.InputFileName, ExpandFileName(InputFile.OutputFileName)]);
      Continue;
    end;
    InputFile.IsInputFileUsable := false;
    NotFound := '';
    for i := 1 to 2 do
    begin
      if i = 1 then
        FileName := InputFile.InputFileNameExpanded
      else
        FileName := GetFileNameExpanded (InputFile.InputFileNameExpanded);
      FileName := TCurlUtils.ReplaceCurlParameterValues (FileName, CurlParameterList, CurlMappingParameterList, false);
      NewPath := ExtractFilePath (FileName);
      if findfirst (FileName, faAnyFile, searchResult) = 0 then
      begin
        First := true;
        repeat
          if not First then
          begin
            ExpandInputListPosition := ExpandInputListPosition + 1;
            ExpandInputListCount := ExpandInputListCount + 1;
          end;
          First := false;
          if NewPath.IsEmpty then
            FileName := searchResult.name
          else
            FileName := ChangeFilePath (searchResult.name, NewPath);
          AddInputFileFileSearch (FileName, FileName, InputFile.LeadingObject, InputFile.SplitInputFile,
            InputFile.SplitIdentifier, InputFile.GenerateOutput);
          GlobalLoghandler.Debug ('File "%s" found (%s).', [FileName, ExpandFileName(FileName)]);
        until FindNext (searchResult) <> 0;
        InputFile.GenerateOutput := false;
        System.SysUtils.FindClose (searchResult);
        NotFound := '';
        break;
      end;
      NotFound := Format ('%s%s%s', [NotFound, ExpandFileName(FileName), TPath.PathSeparator]);
    end;
    NotFound := NotFound.Trim ([TPath.PathSeparator]);
    if not NotFound.IsEmpty then
      if InputFile.Mandatory then
        GlobalLoghandler.Error (jetMandatoryInputFileNotFound, [FileName, NotFound])
      else
        GlobalLoghandler.Error (jetInputFileNotFound, [FileName, NotFound]);
  end;
  if Assigned (OnNotifyChange) then
    OnNotifyChange (self, nctExpand, ExpandInputListCount, ExpandInputListCount);
  if GlobalLoghandler.Failed then
    exit;
  for InputFile in self do
  begin
    if not InputFile.IncludeIntoOutput then
      Continue;
    if not InputFile.Exists then
      Continue;
    if not InputFile.SplitInputFile then
      Continue;
    ExpandInputListSplitFile (InputFile);
  end;
end;

function tJson2PumlInputList.ExpandInputListCurlFile (iCurrentInputFile: tJson2PumlInputFileDefinition;
  iIgnoreCurlCache: boolean): boolean;
var
  CurlParameterMatrix: tJson2PumlCurlFileParameterListMatrix;
  SaveFileName: string;
  i: integer;
begin
  Result := false;
  if not iCurrentInputFile.HasValidCurl then
    exit;
  Result := true;
  CurlParameterMatrix := tJson2PumlCurlFileParameterListMatrix.Create;
  try
    CurlParameterMatrix.FillMatrix (CurlParameterList, iCurrentInputFile.OutputFileName);
    if CurlParameterMatrix.RowList.Count > 0 then
    begin
      iCurrentInputFile.IsInternalOnly := true;
      ExpandInputListCount := ExpandInputListCount + CurlParameterMatrix.RowList.Count - 1;
      for i := 0 to CurlParameterMatrix.RowList.Count - 1 do
      begin
        if i > 0 then
          ExpandInputListPosition := ExpandInputListPosition + 1;
        SaveFileName := iCurrentInputFile.OutputFileName;
        iCurrentInputFile.HandleCurl (CurlBaseUrlDecoded, CurlUrlAddon, [CurlOptions, curlAdditionalRuntimeOptions],
          CurlParameterMatrix.RowParameterList[i], CurlParameterList, CurlMappingParameterList, CurlAuthenticationList,
          iIgnoreCurlCache);
        AddInputFileAfterCurl (iCurrentInputFile);
        iCurrentInputFile.OutputFileName := SaveFileName;
        iCurrentInputFile.CurlResult.Clear;
        if GlobalLoghandler.Failed then
          exit;
      end;
      iCurrentInputFile.GenerateOutput := false;
    end
    else
    begin
      iCurrentInputFile.IsInputFileUsable := iCurrentInputFile.HandleCurl (CurlBaseUrlDecoded, '', CurlOptions,
        CurlParameterList, CurlParameterList, CurlMappingParameterList, CurlAuthenticationList, iIgnoreCurlCache);
    end;
    if GlobalLoghandler.Failed then
      exit;
  finally
    CurlParameterMatrix.Free;
  end;
end;

function tJson2PumlInputList.ExpandInputListSplitFile (iInputFile: tJson2PumlInputFileDefinition): boolean;
var
  FileDetailNames, InputFile, OutPutFile: tStringList;
  ConverterDefinition: tJson2PumlConverterDefinition;
  JsonValue: tJSONValue;
  NewFileName: string;
  JsonArray: tJSONArray;
  // FileExtension: string;
  OutputFileName: string;
  Ident: string;
  LastOption: string;
  idx, i: integer;

  function FindSuffix (iSuffix: string): string;
  var
    i: integer;
    s: string;
  begin
    Result := '';
    i := 0;
    repeat
      if i = 0 then
        s := iSuffix
      else
        s := Format ('%s_%d', [iSuffix, i]);
      if FileDetailNames.IndexOf (s) < 0 then
      begin
        FileDetailNames.Add (s);
        Result := s;
        break;
      end
      else
        Inc (i);
    until 1 = 0;
  end;

begin
  Result := false;
  if not iInputFile.Exists then
    exit;
  if not iInputFile.SplitInputFile then
    exit;
  if not iInputFile.IsInputFileUsable then
    exit;
  FileDetailNames := tStringList.Create;
  InputFile := tStringList.Create;
  OutPutFile := tStringList.Create;
  LastOption := '';
  ConverterDefinition := tJson2PumlConverterDefinition.Create;
  try
    InputFile.LoadFromFile (iInputFile.OutputFileName);
    JsonValue := tJSONObject.ParseJSONValue (InputFile.Text);
    if not Assigned (JsonValue) then
      exit;
    try
      if not (JsonValue is tJSONArray) then
        exit;
      JsonArray := tJSONArray (JsonValue);
      if JsonArray.Count <= 1 then
        exit;
      GlobalLoghandler.Info ('Split file %s', [iInputFile.InputFileName]);
      idx := 0;
      if JsonArray.Count > 0 then
      begin
        NewFileName := CalculateOutputFileName (iInputFile.InputFileName, iInputFile.InputFileName);
        GenerateFileDirectory (NewFileName);
      end;
      for i := 0 to JsonArray.Count - 1 do
      begin
        // FileExtension := TPath.GetExtension (iInputFile.InputFileName);
        Ident := '';
        if JsonArray.Items[i] is tJSONObject then
          Ident := GetJsonStringValue (tJSONObject(JsonArray.Items[i]), iInputFile.SplitIdentifier, '', '.');
        if Ident.IsEmpty then
        begin
          Inc (idx);
          Ident := Format ('split_%d', [idx]);
        end;

        OutputFileName := TPath.ChangeExtension (NewFileName, FindSuffix(Ident).Substring(0, 80) + '.' +
          jofJSON.ToString);
        OutPutFile.Text := JsonArray.Items[i].ToJSON;
        OutPutFile.SaveToFile (OutputFileName);
        if iInputFile.CurlFormatOutput then
          FormatJsonFile (OutputFileName);
        AddInputFileSplit (iInputFile.InputFileName, OutputFileName, iInputFile.LeadingObject, iInputFile.CurlResult,
          iInputFile.GenerateOutput);
        GlobalLoghandler.Info ('  Detail file %s created', [OutputFileName]);
      end;
      iInputFile.GenerateOutput := false;
    finally
      JsonValue.Free;
    end;
  finally
    ConverterDefinition.Free;
    FileDetailNames.Free;
    InputFile.Free;
    OutPutFile.Free;
  end;
  Result := true;

end;

procedure tJson2PumlInputList.GenerateSummaryZipfile (iZipfileName: string; iOutputFormats: tJson2PumlOutputFormats);
var
  InputFile: tJson2PumlInputFileDefinition;
  ZipFile: tZipFile;
begin
  SummaryZipFileName := iZipfileName;
  ZipFile := tZipFile.Create;
  try
    ZipFile.Open (iZipfileName, zmWrite);
    if jofExecuteLog in iOutputFormats then
      AddFileToZipFile (ZipFile, ExecuteLogFileName, ExtractFilePath(iZipfileName));
    if jofFileList in iOutputFormats then
      AddFileToZipFile (ZipFile, FileListFileName, ExtractFilePath(iZipfileName));
    for InputFile in self do
      InputFile.AddFilesToZipFile (ZipFile, ExtractFilePath(iZipfileName), iOutputFormats);
    ZipFile.Close;
    GlobalLoghandler.Info ('Summary Zip File %s generated.', [iZipfileName]);
  finally
    ZipFile.Free;
  end;
end;

function tJson2PumlInputList.GetCurlBaseUrlDecoded: string;
begin
  Result := ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (CurlBaseUrl);
end;

function tJson2PumlInputList.GetDefinitionFileNameExpanded: string;
begin
  Result := GetFileNameExpanded (DefinitionFileName);
end;

function tJson2PumlInputList.GetEnumerator: tJson2PumlInputListEnumerator;
begin
  Result := tJson2PumlInputListEnumerator.Create (self);
end;

function tJson2PumlInputList.GetExecuteCount: integer;
var
  f: tJson2PumlInputFileDefinition;
begin
  Result := 0;
  for f in self do
    if f.Exists and f.GenerateOutput then
      Result := Result + 1;
end;

function tJson2PumlInputList.GetExistsCount: integer;
var
  f: tJson2PumlInputFileDefinition;
begin
  Result := 0;
  for f in self do
    if f.Exists then
      Result := Result + 1;
end;

function tJson2PumlInputList.GetGenerateDetails: boolean;
begin
  Result := StringToBoolean (GenerateDetailsStr, false);
end;

function tJson2PumlInputList.GetGenerateSummary: boolean;
begin
  Result := StringToBoolean (GenerateSummaryStr, false);
end;

function tJson2PumlInputList.GetInputFile (Index: integer): tJson2PumlInputFileDefinition;
begin
  Result := tJson2PumlInputFileDefinition (Objects[index]);
end;

function tJson2PumlInputList.GetIsValid: boolean;
var
  InputFile: tJson2PumlInputFileDefinition;
begin
  Result := false;
  for InputFile in self do
    if InputFile.IsValid then
    begin
      Result := true;
      break;
    end;
  Result := Result and Description.IsValid;
end;

function tJson2PumlInputList.GetOutputPathExpanded: string;
begin
  Result := PathCombineIfRelative (SourceFileNamePath, OutputPath);
end;

function tJson2PumlInputList.GetSummaryInputFile: tJson2PumlInputFileDefinition;
var
  f: tJson2PumlInputFileDefinition;
begin
  Result := nil;
  for f in self do
    if f.IsSummaryFile then
    begin
      Result := f;
      exit;
    end;
end;

function tJson2PumlInputList.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  Definition: tJSONObject;
  InputFile: tJson2PumlInputFileDefinition;
begin
  Result := false;
  Clear;
  if not (iJsonValue is tJSONObject) then
    exit;
  Definition := GetJsonObject (tJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  // put this first because of the inherited clear
  inherited ReadFromJson (Definition, 'input');
  for InputFile in self do
    InputFile.OutputFileName := CalculateOutputFileName (FileNameWithSuffix(InputFile.InputFileName,
      InputFile.CurlFileNameSuffix), InputFile.InputFileName);
  DefinitionFileName := GetJsonStringValue (Definition, 'definitionFile');
  Description.ReadFromJson (Definition, 'description');
  Detail := GetJsonStringValue (Definition, 'detail');
  Group := GetJsonStringValue (Definition, 'group');
  Option := GetJsonStringValue (Definition, 'option');
  Jobname := GetJsonStringValue (Definition, 'job');
  JobDescription := GetJsonStringValue (Definition, 'jobDescription');
  OutputFormatStr := GetJsonStringValue (Definition, 'outputFormats');
  OutputPath := GetJsonStringValue (Definition, 'outputPath');
  OutputSuffix := GetJsonStringValue (Definition, 'outputSuffix');
  CurlBaseUrl := GetJsonStringValue (Definition, 'curlBaseUrl');
  CurlUrlAddon := GetJsonStringValue (Definition, 'curlUrlAddon');
  CurlOptions := GetJsonStringValue (Definition, 'curlOptions');
  CurlUserAgentInformation := GetJsonStringValue (Definition, 'curlUserAgentInformation', CurlUserAgentInformation);
  CurlTraceIdHeader := GetJsonStringValue (Definition, 'curlTraceIdHeader', CurlTraceIdHeader);
  CurlSpanIdHeader := GetJsonStringValue (Definition, 'curlSpanIdHeader', CurlSpanIdHeader);
  CurlMappingParameterList.ReadFromJson (Definition, 'curlMappingParameter');

  GenerateDetailsStr := GetJsonStringValueBoolean (Definition, 'generateDetails', '');
  GenerateSummaryStr := GetJsonStringValueBoolean (Definition, 'generateSummary', '');
  SummaryFileName := GetJsonStringValue (Definition, 'summaryFile');
  Result := Count > 0;
end;

procedure tJson2PumlInputList.SetCurlParameterList (const Value: tJson2PumlCurlParameterList);
begin
  FCurlParameterList := Value;
end;

procedure tJson2PumlInputList.SetCurlSpanIdHeader (const Value: string);
begin
  FCurlSpanIdHeader := Value.ToLower.Trim;
end;

procedure tJson2PumlInputList.SetCurlTraceIdHeader (const Value: string);
begin
  FCurlTraceIdHeader := Value.ToLower.Trim;
end;

procedure tJson2PumlInputList.SetExpandInputListCount (const Value: integer);
begin
  FExpandInputListCount := Value;
  if Assigned (OnNotifyChange) then
    OnNotifyChange (self, nctExpand, FExpandInputListPosition, FExpandInputListCount);
end;

procedure tJson2PumlInputList.SetExpandInputListPosition (const Value: integer);
begin
  FExpandInputListPosition := Value;
  if Assigned (OnNotifyChange) then
    OnNotifyChange (self, nctExpand, FExpandInputListPosition, FExpandInputListCount);
end;

procedure tJson2PumlInputList.SetOutputFormatStr (const Value: string);
begin
  FOutputFormats.FromString (Value, false, true);
  FOutputFormatStr := FOutputFormats.ToString (false);
end;

procedure tJson2PumlInputList.SetOutputPath (const Value: string);
begin
  FOutputPath := ReplaceInvalidPathChars (Value.Trim, false);
end;

procedure tJson2PumlInputList.SetOutputSuffix (const Value: string);
begin
  FOutputSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlInputList.SetSummaryFileName (const Value: string);
var
  Extension: string;
  Format: tJson2PumlOutputFormat;
begin
  FSummaryFileName := ReplaceInvalidFileNameChars (Value, false);
  Extension := TPath.GetExtension (FSummaryFileName).ToLower.TrimLeft ([TPath.ExtensionSeparatorChar]);
  for Format := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
    if Format.FileExtension.ToLower = Extension then
    begin
      FSummaryFileName := TPath.ChangeExtension (FSummaryFileName, '').TrimRight ([TPath.ExtensionSeparatorChar]);
      exit;
    end;
end;

procedure tJson2PumlInputList.ValidateCurlParameter;
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
  ErrorMessages: tStringList;
  s: string;
begin
  GlobalLoghandler.Debug ('Input curl parameter :');
  for CurlParameter in CurlParameterList do
  begin
    GlobalLoghandler.Debug ('  %-50s: %s', [CurlParameter.name, CurlParameter.Value]);
  end;
  ErrorMessages := tStringList.Create;
  try
    if not Description.CurlParameterList.ValidatedInputParameter (CurlParameterList, ErrorMessages) then
      for s in ErrorMessages do
        GlobalLoghandler.Error (s);

  finally
    ErrorMessages.Free;
  end;
end;

procedure tJson2PumlInputList.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  Description.WriteToJson (oJsonOutPut, 'description', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'definitionFile', DefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateDetails', GenerateDetailsStr, iLevel + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'generateSummary', GenerateSummaryStr, iLevel + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'group', Group, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'detail', Detail, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'option', Option, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'job', Jobname, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'jobDescription', JobDescription, iLevel + 1, iWriteEmpty);
  OutputFormatStr := OutputFormats.ToString (false);
  WriteToJsonValue (oJsonOutPut, 'outputFormats', OutputFormatStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputPath', OutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputSuffix', OutputSuffix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlBaseUrl', CurlBaseUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUrlAddon', CurlUrlAddon, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlOptions', CurlOptions, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUserAgentInformation', CurlUserAgentInformation, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlSpanIdHeader', CurlSpanIdHeader, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlTraceIdHeader', CurlTraceIdHeader, iLevel + 1, iWriteEmpty);
  CurlMappingParameterList.WriteToJson (oJsonOutPut, 'curlMappingParameter', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'summaryFile', SummaryFileName, iLevel + 1, iWriteEmpty);
  inherited WriteToJson (oJsonOutPut, 'input', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputList.WriteToJsonOutputFiles (iFileName: string; iWriteEmpty: boolean = false);
var
  TempList: tStringList;
begin
  FileListFileName := iFileName;
  TempList := tStringList.Create;
  try
    WriteToJsonOutputFiles (TempList, '', 0, iWriteEmpty);
    TempList.SaveToFile (iFileName);
  finally
    TempList.Free;
  end;
end;

procedure tJson2PumlInputList.WriteToJsonOutputFiles (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
var
  InputFile: tJson2PumlInputFileDefinition;
  found: boolean;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'fileList', FileListFileName, iLevel + 1, iWriteEmpty);
  for InputFile in self do
  begin
    if not InputFile.IncludeIntoOutput then
      Continue;
    if not InputFile.Exists then
      Continue;
    if not InputFile.IsSummaryFile then
      Continue;
    InputFile.WriteToJsonOutputFile (oJsonOutPut, 'summaryFile', iLevel + 1, iWriteEmpty);
  end;
  found := false;
  for InputFile in self do
  begin
    if not InputFile.IncludeIntoOutput then
      Continue;
    if not InputFile.Exists then
      Continue;
    if InputFile.IsSummaryFile then
      Continue;
    if not found then
    begin
      WriteArrayStartToJson (oJsonOutPut, iLevel + 1, 'detailFiles');
      found := true;
    end;
    InputFile.WriteToJsonOutputFile (oJsonOutPut, '', iLevel + 2, iWriteEmpty);
  end;
  if found then
    WriteArrayEndToJson (oJsonOutPut, iLevel);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputList.WriteToJsonServiceListResult (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false);
var
  FileName: string;
  DefinitionFile: tJson2PumlConverterGroupDefinition;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', ExtractFileName(SourceFileName), iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'displayName', ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration
    (Description.DisplayName), iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration
    (Description.Description), iLevel + 1, iWriteEmpty);
  if not DefinitionFileName.IsEmpty then
  begin
    FileName := GlobalConfigurationDefinition.FindFileInFolderList (DefinitionFileName,
      GlobalConfigurationDefinition.DefinitionFileSearchFolder);
    if FileExists (FileName) then
    begin
      DefinitionFile := tJson2PumlConverterGroupDefinition.Create;
      try
        DefinitionFile.ReadFromJsonFile (FileName);
        DefinitionFile.WriteToJsonServiceListResult (oJsonOutPut, 'definitionFile', iLevel + 1, false, iApiVersion,
          iWriteEmpty);
        if iApiVersion = jav2 then
          DefinitionFile.WriteOptionsToJsonServiceListResult (oJsonOutPut, iPropertyName, iLevel, iApiVersion,
            iWriteEmpty);
      finally
        DefinitionFile.Free;
      end;
    end;
  end;

  Description.CurlParameterList.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputList.WriteToJsonServiceResult (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iOutputFormats: tJson2PumlOutputFormats; iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false);
var
  InputFile: tJson2PumlInputFileDefinition;
  found: boolean;
begin
  if iApiVersion = jav1 then
  begin
    WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
    for InputFile in self do
    begin
      if not InputFile.IsConverted then
        Continue;
      if not InputFile.IsSummaryFile then
        Continue;
      if not InputFile.Exists then
        Continue;
      InputFile.WriteToJsonServiceResult (oJsonOutPut, 'summaryFile', iLevel + 1, iOutputFormats, iApiVersion,
        iWriteEmpty);
    end;
    found := false;
    for InputFile in self do
    begin
      if not InputFile.IsConverted then
        Continue;
      if not InputFile.Exists then
        Continue;
      if InputFile.IsSummaryFile then
        Continue;
      if not found then
      begin
        WriteArrayStartToJson (oJsonOutPut, iLevel + 1, 'detailFiles');
        found := true;
      end;
      InputFile.WriteToJsonServiceResult (oJsonOutPut, '', iLevel + 2, iOutputFormats, iApiVersion, iWriteEmpty);
    end;
    if found then
      WriteArrayEndToJson (oJsonOutPut, iLevel);
    WriteObjectEndToJson (oJsonOutPut, iLevel);
  end
  else
  begin
    WriteArrayStartToJson (oJsonOutPut, iLevel, iPropertyName);
    for InputFile in self do
    begin
      if not InputFile.IsConverted then
        Continue;
      if not InputFile.Exists then
        Continue;
      InputFile.WriteToJsonServiceResult (oJsonOutPut, '', iLevel + 1, iOutputFormats, iApiVersion, iWriteEmpty);
    end;
    WriteArrayEndToJson (oJsonOutPut, iLevel);
  end;
end;

procedure tJson2PumlInputList.WriteToJsonServiceResult (oJsonOutPut: tStrings; iOutputFormats: tJson2PumlOutputFormats;
  iApiVersion: tJson2PumlApiVersion; iWriteEmpty: boolean = false);
begin
  oJsonOutPut.Clear;
  WriteToJsonServiceResult (oJsonOutPut, '', 0, iOutputFormats, iApiVersion, iWriteEmpty);
end;

constructor tJson2PumlInputListEnumerator.Create (AInputList: tJson2PumlInputList);
begin
  inherited Create;
  FIndex := - 1;
  fInputList := AInputList;
end;

function tJson2PumlInputListEnumerator.GetCurrent: tJson2PumlInputFileDefinition;
begin
  Result := fInputList[FIndex];
end;

function tJson2PumlInputListEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fInputList.Count - 1;
  if Result then
    Inc (FIndex);
end;

function tJson2PumlCommandLineParameter.GetGenerateDetails: boolean;
begin
  Result := StringToBoolean (GenerateDetailsStr, false);
end;

function tJson2PumlCommandLineParameter.GetGenerateSummary: boolean;
begin
  Result := StringToBoolean (GenerateSummaryStr, false);
end;

function tJson2PumlCommandLineParameter.GetSplitInputFile: boolean;
begin
  Result := StringToBoolean (SplitInputFileStr, false);
end;

procedure tJson2PumlCommandLineParameter.SetIdentFilter (const Value: string);
begin
  FIdentFilter := Value;
  InputFilterList.IdentFilter.Text := Value;
end;

procedure tJson2PumlCommandLineParameter.SetOpenOutputsStr (const Value: string);
var
  TempList: tStringList;
  s: string;
  f: tJson2PumlOutputFormat;
begin
  FOpenOutputsStr := Value;
  FOpenOutputs := [];
  TempList := tStringList.Create;
  try
    TempList.LineBreak := ',';
    TempList.Text := Value.ToLower;
    for s in TempList do
      for f := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
        if (s.Trim = f.ToString) or (s.Trim = cOpenOutputAll) then
          FOpenOutputs := FOpenOutputs + [f];
  finally
    TempList.Free;
  end;

end;

procedure tJson2PumlCommandLineParameter.SetOutputFormatStr (const Value: string);
begin
  FOutputFormatStr := Value;
  FOutputFormats.FromString (Value, false, true);
end;

procedure tJson2PumlCommandLineParameter.SetOutputSuffix (const Value: string);
begin
  FOutputSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlCommandLineParameter.SetServicePortStr (const Value: string);
begin
  FServicePortStr := Value;
  FServicePort := StringToInteger (TCurlUtils.ReplaceCurlVariablesFromEnvironment(Value), - 1);
end;

procedure tJson2PumlCommandLineParameter.SetTitleFilter (const Value: string);
begin
  FTitleFilter := Value;
  InputFilterList.TitleFilter.Text := Value;
end;

function tJson2PumlCommandLineParameter.ExistsSingleInputParameter (iParameterName: string): boolean;
begin
  Result := FindCmdLineSwitch (iParameterName);
  if Result then
    LogParameterValue (iParameterName, Result);
end;

procedure tJson2PumlCommandLineParameter.HandleGenerateDefaultConfiguration;
type
  tAccessJson2PumlGlobalDefinition = tJson2PumlGlobalDefinition;
var
  DefaultConfigurationFile: string;
  BasePath: string;
  DefaultConfiguration: tAccessJson2PumlGlobalDefinition;
  DefaultCurlAuthentication: tJson2PumlCurlAuthenticationDefinition;

  procedure CheckSamples (iBasePath, iDetailPath: string);
  begin
    if DirectoryExists (TPath.Combine(iBasePath, iDetailPath)) then
    begin
      DefaultConfiguration.DefinitionFileSearchFolder.Add (TPath.Combine(TPath.Combine(iBasePath, iDetailPath),
        '*definition*.json'));
      DefaultConfiguration.InputListFileSearchFolder.Add (TPath.Combine(TPath.Combine(iBasePath, iDetailPath),
        '*inputlist*.json'));
    end;
  end;

begin
  DefaultConfigurationFile := TPath.Combine (ExtractFilePath(ParamStr(0)), cDefaultConfigurationFile);
  if not FileExists (DefaultConfigurationFile) then
  begin
    DefaultConfiguration := tAccessJson2PumlGlobalDefinition.Create;
    try
      DefaultConfiguration.intCurlAuthenticationFileName := TPath.Combine (ExtractFilePath(ParamStr(0)),
        cDefaultCurlAuthenticationFile);
      BasePath := ExtractFilePath (ParamStr(0)).TrimRight ([TPath.DirectorySeparatorChar]);
      if ExtractFileName (BasePath) = 'bin' then
        BasePath := ExtractFilePath (BasePath);
      DefaultConfiguration.intBaseOutputPath := TPath.Combine (BasePath, 'output');
      DefaultConfiguration.intLogFileOutputPath := TPath.Combine (BasePath, 'log');
      DefaultConfiguration.CurlSpanIdHeader := 'X-B3-SpanId';
      DefaultConfiguration.CurlTraceIdHeader := 'X-B3-TraceId';
      DefaultConfiguration.intJavaRuntimeParameter := '-DPLANTUML_LIMIT_SIZE=8192';
      DefaultConfiguration.OutputPath := '<job>\\<group>\\<file>';
      if DirectoryExists (TPath.Combine(BasePath, 'definition')) then
        DefaultConfiguration.DefinitionFileSearchFolder.Add (TPath.Combine(BasePath, 'definition'));
      if DirectoryExists (TPath.Combine(BasePath, 'samples')) then
      begin
        CheckSamples (TPath.Combine(BasePath, 'samples'), 'jsonplaceholder');
        CheckSamples (TPath.Combine(BasePath, 'samples'), 'spacex');
        CheckSamples (TPath.Combine(BasePath, 'samples'), 'swapi');
        CheckSamples (TPath.Combine(BasePath, 'samples'), 'tmf');
        CheckSamples (TPath.Combine(BasePath, 'samples'), 'tvmaze');
      end;
      DefaultConfiguration.WriteToJsonFile (DefaultConfigurationFile, true);
      GlobalLoghandler.Info ('Default configuration file %s generated', [DefaultConfigurationFile]);
    finally
      DefaultConfiguration.Free;
    end;
  end
  else
    GlobalLoghandler.Debug ('Default configuration file %s exists, generation skipped', [DefaultConfigurationFile]);
  DefaultConfigurationFile := TPath.Combine (ExtractFilePath(ParamStr(0)), cDefaultCurlAuthenticationFile);
  if not FileExists (DefaultConfigurationFile) then
  begin
    DefaultCurlAuthentication := tJson2PumlCurlAuthenticationDefinition.Create;
    try
      DefaultCurlAuthentication.WriteToJsonFile (DefaultConfigurationFile, true);
      GlobalLoghandler.Info ('Default curl authentication file %s generated', [DefaultConfigurationFile]);
    finally
      DefaultCurlAuthentication.Free;
    end;
  end
  else
    GlobalLoghandler.Debug ('Default curl authentication file %s exists, generation skipped',
      [DefaultConfigurationFile]);
end;

procedure tJson2PumlCommandLineParameter.LogParameterValue (iParameterName: string; iParameterValue: boolean;
  iAllways: boolean = false);
begin
  if not iParameterValue and not iAllways then
    exit;
  if not iAllways and iParameterValue then
    LogParameterValue (iParameterName, '', '', true)
  else
    LogParameterValue (iParameterName, iParameterValue.ToString);
end;

procedure tJson2PumlCommandLineParameter.LogParameterValue (iParameterName: string; iParameterValue: string = '';
  iParameterDetail: string = ''; iAllways: boolean = false);
begin
  if iParameterValue.IsEmpty and iParameterDetail.IsEmpty and not iAllways then
    exit;
  GlobalLoghandler.InfoParameter (cCmdLinePrefix, iParameterName.ToLower,
    (iParameterValue.Trim + ' ' + iParameterDetail).Trim);
end;

procedure tJson2PumlCommandLineParameter.ReadCurlParameter;
var
  l, i: integer;
  s: string;

  pName: string;
  pValue: string;
  p, p1, p2: integer;
const
  ccurlparam: array [0 .. 1] of string = ('curlparameter', 'curlauthenticationparameter');
begin
  CurlParameter.Clear;
  for i := 0 to ParamCount do
  begin
    s := ParamStr (i).Trim;
    for l := 0 to 1 do
    begin
      if s.StartsWith ('/' + ccurlparam[l] + ':', true) or s.StartsWith ('/' + ccurlparam[l] + '=', true) or
        s.StartsWith ('-' + ccurlparam[l] + ':', true) or s.StartsWith ('-' + ccurlparam[l] + '=', true) then
      begin
        s := s.Substring (length(ccurlparam[l]) + 2).DeQuotedString;
        p1 := s.IndexOf ('=');
        p2 := s.IndexOf (':');
        if p1 < 0 then
          p1 := p2;
        if p2 < 0 then
          p2 := p1;
        if p1 < p2 then
          p := p1
        else
          p := p2;
        if p >= 0 then
        begin
          pName := s.Substring (0, p).Trim;
          pValue := s.Substring (p + 1);
        end
        else
        begin
          pName := s.Trim;
          pValue := '';
        end;
        if not pName.IsEmpty then
        begin
          if l = 0 then
          begin
            CurlParameter.AddParameter (pName, pValue);
            LogParameterValue ('CurlParameter', Format('%s:%s', [pName, pValue]));
          end
          else
          begin
            CurlAuthenticationParameter.AddParameter (pName, pValue);
            LogParameterValue ('CurlAuthenticationParameter', Format('%s:%s', [pName, '******']));
          end;
        end;
      end;
    end;
  end;
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameter (iParameterName: string): string;
var
  s: string;
begin
  FindCmdLineSwitch (iParameterName, s, true, [clstValueAppended]);
  s := s.TrimLeft (['=', ':']);
  Result := s;
  LogParameterValue (iParameterName, s);
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameterEnvironment (iParameterName: string): string;
var
  s: string;
begin
  s := GetEnvironmentVariable (iParameterName);
  ValidateFileInputParameter ('Env ' + iParameterName, s);
  Result := s;
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameterFile (iParameterName: string): string;
var
  s: string;
begin
  FindCmdLineSwitch (iParameterName, s);
  s := s.TrimLeft (['=', ':']);
  ValidateFileInputParameter (iParameterName, s);
  Result := s;
end;

procedure tJson2PumlCommandLineParameter.ValidateFileInputParameter (iParameterName: string;
  var ioParameterValue: string);
var
  Fc: integer;
begin
  if ioParameterValue.IsEmpty then
    exit;
  iParameterName := iParameterName.ToLower.Trim;
  Fc := FileCount (ExpandFileName(ioParameterValue));
  if Fc > 1 then
    LogParameterValue (iParameterName, ioParameterValue, Format('(%d files found)', [Fc]))
  else
    LogParameterValue (iParameterName, ioParameterValue);
  if (Fc <= 0) then
  begin
    GlobalLoghandler.Error (jetCmdLineParameterFileDoesNotExits,
      [cCmdLinePrefix, iParameterName.ToLower.Trim.PadRight(29), ioParameterValue.Trim]);
    ioParameterValue := '';
    Failed := true;
  end;
end;

constructor tJson2PumlCommandLineParameter.Create;
begin
  inherited Create;
  Failed := false;
  FInputFilterList := tJson2PumlFilterList.Create ();
  FCurlParameter := tJson2PumlCurlParameterList.Create ();
  FCurlParameter.MulitpleValues := true;
  FCurlAuthenticationParameter := tJson2PumlCurlParameterList.Create ();
  FCurlAuthenticationParameter.MulitpleValues := true;
end;

destructor tJson2PumlCommandLineParameter.Destroy;
begin
  FCurlAuthenticationParameter.Free;
  FCurlParameter.Free;
  FInputFilterList.Free;
  inherited Destroy;
end;

function tJson2PumlCommandLineParameter.CommandLineParameterStr (iIncludeProgram: boolean): string;
var
  i: integer;
begin
  if iIncludeProgram then
    Result := ParamStr (0) + ' '
  else
    Result := '';
  for i := 1 to ParamCount do
    Result := Result + ParamStr (i) + ' ';
  Result := Result.Trim;
end;

procedure tJson2PumlCommandLineParameter.GenerateEnvironmentParameters (iLogList: tStringList);

  procedure AddLine (iName, iValue: string);
  var
    envValue: string;
  begin
    if not iValue.IsEmpty then
    begin
      envValue := TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue);
      if iValue <> envValue then
        iLogList.Add (Format('  $%-35s: %s (%s)', [iName.ToUpper, iValue, envValue]))
      else
        iLogList.Add (Format('  $%-35s: %s', [iName.ToUpper, iValue]));
    end;
  end;
  procedure AddLineBool (iName: string; iValue: boolean);
  begin
    if iValue then
      iLogList.Add (Format('  $%-35s: %s', [iName.ToUpper, cTrue]));
  end;

begin
  iLogList.Clear;
  // iLogList.Add ('Environment Parameter ');
  AddLine (cConfigurationFileRegistry, ConfigurationFileNameEnvironment);
  AddLine (cCurlAuthenticationFileRegistry, CurlAuthenticationFileNameEnvironment);
  AddLine (cDefinitionFileRegistry, DefinitionFileNameEnvironment);
  AddLine (cPlantUmlJarFileRegistry, PlantUmlJarFileNameEnvironment);
end;

procedure tJson2PumlCommandLineParameter.GenerateLogParameters (iLogList: tStringList);

  procedure AddLine (iName, iValue: string);
  var
    envValue: string;
  begin
    if not iValue.IsEmpty then
    begin
      envValue := TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue);
      if iValue <> envValue then
        iLogList.Add (Format('  %s%-35s: %s (%s)', [cCmdLinePrefix, iName.ToLower, iValue, envValue]))
      else
        iLogList.Add (Format('  %s%-35s: %s', [cCmdLinePrefix, iName.ToLower, iValue]));
    end;
  end;
  procedure AddLineBool (iName: string; iValue: boolean);
  begin
    if iValue then
      iLogList.Add (Format('  %s%-35s: %s', [cCmdLinePrefix, iName.ToLower, cTrue]));
  end;

begin
  iLogList.Clear;
  // iLogList.Add ('Command Line Parameter ');
  AddLine ('BaseOutputPath', BaseOutputPath);
  AddLine ('ConfigurationFileName', ConfigurationFileName);
  AddLine ('CurlAuthenticationFileName', CurlAuthenticationFileName);
  AddLineBool ('CurlIgnoreCache', CurlIgnoreCache);
  AddLine ('CurlParameterFileName', CurlParameterFileName);
  AddLineBool ('Debug', Debug);
  AddLine ('DefinitionFileName', DefinitionFileName);
  AddLine ('JobDescription', JobDescription);
  AddLine ('Detail', Detail);
  AddLineBool ('FormatDefinitionFiles', FormatDefinitionFiles);
  AddLineBool ('GenerateDetails', GenerateDetails);
  AddLineBool ('GenerateOutputDefinition', GenerateOutputDefinition);
  AddLineBool ('GenerateSummary', GenerateSummary);
  AddLine ('Group', Group);
  AddLine ('IdentFilter', IdentFilter);
  AddLine ('InputFileName', InputFileName);
  AddLine ('InputListFileName', InputListFileName);
  AddLine ('JavaRuntimeParameter', JavaRuntimeParameter);
  AddLine ('Jobname', Jobname);
  AddLine ('LeadingObject', LeadingObject);
  AddLineBool ('NoLogFiles', NoLogFiles);
  AddLine ('OpenOutputs', OpenOutputsStr);
  AddLine ('Option', Option);
  AddLine ('OptionFileName', OptionFileName);
  AddLine ('OutputFormat', OutputFormatStr);
  AddLine ('OutputPath', OutputPath);
  AddLine ('OutputSuffix', OutputSuffix);
  AddLine ('ParameterFileName', ParameterFileName);
  AddLine ('PlantUmlJarFileName', PlantUmlJarFileName);
  AddLine ('PlantUmlRuntimeParameter', PlantUmlRuntimeParameter);
  AddLine ('ServicePort', ServicePortStr);
  AddLine ('SplitIdentifier', SplitIdentifier);
  AddLine ('SplitInputFile', SplitInputFileStr);
  AddLine ('SummaryFileName', SummaryFileName);
  AddLine ('TitleFilter', TitleFilter);

end;

procedure tJson2PumlCommandLineParameter.LogLineWrapped (iParameter, iDescription: string;
  iParameterLength: integer = 50; iLineLength: integer = 110);
var
  LogLines: tStringList;
  s: string;
  l: string;
  Next: string;
  i, p: integer;
begin
  LogLines := tStringList.Create;
  try
    LogLines.Text := iDescription;
    s := iParameter;
    for i := 0 to LogLines.Count - 1 do
    begin
      s := s.PadRight (iParameterLength);
      l := LogLines[i];
      while not l.IsEmpty do
      begin
        p := l.IndexOf (' ');
        if p >= 0 then
        begin
          Next := l.Substring (0, p);
          l := l.Substring (p + 1);
        end
        else
        begin
          Next := l;
          l := '';
        end;
        if s.length + Next.length >= iLineLength then
        begin
          GlobalLoghandler.Info (s);
          s := ' ';
          s := s.PadRight (iParameterLength);
        end;
        s := s + ' ' + Next;
      end;
      GlobalLoghandler.Info (s);
      s := '';
    end;
    if not s.IsEmpty then
      GlobalLoghandler.Info (s);
  finally
    LogLines.Free;
  end;

end;

procedure tJson2PumlCommandLineParameter.ReadInputParameter;
begin
  GlobalLoghandler.Info ('Current command line parameters: (%s)', [CommandLineParameterStr(false)]);
  ConfigurationFileName := ReadSingleInputParameterFile ('configurationfile');
  ConfigurationFileNameEnvironment := ReadSingleInputParameterEnvironment (cConfigurationFileRegistry);
  ParameterFileName := ReadSingleInputParameterFile ('parameterfile');
  // Do not use ReadSingleInputParameter so that later the globalconfiguration.DefinitionFileSearchFolder can be used
  DefinitionFileName := ReadSingleInputParameter ('definitionfile');
  JobDescription := ReadSingleInputParameter ('jobdescription');
  DefinitionFileNameEnvironment := ReadSingleInputParameterEnvironment (cDefinitionFileRegistry);
  CurlAuthenticationFileName := ReadSingleInputParameterFile ('CurlAuthenticationfile');
  CurlAuthenticationFileNameEnvironment := ReadSingleInputParameterEnvironment (cCurlAuthenticationFileRegistry);
  CurlIgnoreCache := ExistsSingleInputParameter ('curlIgnoreCache');
  CurlParameterFileName := ReadSingleInputParameterFile ('CurlParameterfile');
  // Do not use ReadSingleInputParameter so that later the globalconfiguration.InputlistFileSearchFolder can be used
  InputListFileName := ReadSingleInputParameter ('InputListfile');
  InputFileName := ReadSingleInputParameterFile ('Inputfile');
  PlantUmlJarFileName := ReadSingleInputParameterFile ('PlantUmlJarfile');
  PlantUmlJarFileNameEnvironment := ReadSingleInputParameterEnvironment (cPlantUmlJarFileRegistry);
  PlantUmlRuntimeParameter := ReadSingleInputParameterFile ('PlantUmlRuntimeParameter');
  JavaRuntimeParameter := ReadSingleInputParameter ('JavaRuntimeParameter');
  ServicePortStr := ReadSingleInputParameter ('serviceport');
  LeadingObject := ReadSingleInputParameter ('LeadingObject');
  SplitInputFileStr := ReadSingleInputParameter ('splitinputfile');
  SplitIdentifier := ReadSingleInputParameter ('splitidentifier');
  Group := ReadSingleInputParameter ('group');
  Detail := ReadSingleInputParameter ('detail');
  Jobname := ReadSingleInputParameter ('job');
  OptionFileName := ReadSingleInputParameterFile ('Optionfile');
  Option := ReadSingleInputParameter ('option');
  GenerateDetailsStr := ReadSingleInputParameter ('GenerateDetails');
  GenerateSummaryStr := ReadSingleInputParameter ('GenerateSummary');
  BaseOutputPath := ReadSingleInputParameter ('baseoutputpath');
  OutputPath := ReadSingleInputParameter ('outputpath');
  OutputSuffix := ReadSingleInputParameter ('outputsuffix');
  OutputFormatStr := ReadSingleInputParameter ('OutputFormat');
  OpenOutputsStr := ReadSingleInputParameter ('openOutput');
  if OpenOutputsStr.IsEmpty and ExistsSingleInputParameter ('openOutput') then
    OpenOutputsStr := cOpenOutputAll;
  Debug := ExistsSingleInputParameter ('debug');
  NoLogFiles := ExistsSingleInputParameter (cNoLogFiles);
  GenerateDefaultConfiguration := ExistsSingleInputParameter ('generatedefaultconfiguration');
  GenerateOutputDefinition := ExistsSingleInputParameter ('generateoutputdefinition');
  IdentFilter := ReadSingleInputParameter ('identfilter');
  TitleFilter := ReadSingleInputParameter ('titlefilter');
  FormatDefinitionFiles := ExistsSingleInputParameter ('formatdefinitionfiles');
  SummaryFileName := ReadSingleInputParameter ('summaryfile');
  ReadCurlParameter;
  if GenerateDefaultConfiguration then
    HandleGenerateDefaultConfiguration;
end;

procedure tJson2PumlCommandLineParameter.WriteHelpLine (iParameter: string = ''; iDescription: string = '';
  iParameterLength: integer = 31; iLineLength: integer = 111);
begin
  if iParameter.Trim.IsEmpty then
    GlobalLoghandler.Info ('')
  else
    LogLineWrapped (cCmdLinePrefix + iParameter.ToLower.Trim, iDescription.Trim, iParameterLength, iLineLength);
end;

procedure tJson2PumlCommandLineParameter.WriteHelpScreen;
var
  s: string;
  f: tJson2PumlOutputFormat;
begin
  WriteHelpLine;
  WriteHelpLine ('?', 'Showing this Help screen');
  WriteHelpLine ('currentconfiguration', 'Showing the current json2puml configuration ');
  WriteHelpLine ('plantumljarfile:<file>      ',
    'Plantuml Jar file which should be used to generate the sample images. ' +
    'If defined this parameter overwrites the corresponding parameter in the definition file');
  WriteHelpLine ('plantumlruntimeparater:<param>',
    'Additional PlantUml runtime parameters which will be added to the PlantUml call when generating the image files.');
  WriteHelpLine ('javaruntimeparameter:<param>',
    'Additional parameter which will be added to the java call when calling the PlantUML jar file ' +
    'to generate the output formats.');
  WriteHelpLine;
  WriteHelpLine ('configurationfile:<file>', 'Global base configuration of json2puml. Overwrites the "' +
    cConfigurationFileRegistry + '" environment parameter.');
  WriteHelpLine ('serviceport:<portnumber>',
    'Port the service application is listening. Overwrites the global configuration parameter.');
  WriteHelpLine ('parameterfile:<file>',
    'ParameterFileName which contains a set of command line parameters in one file');
  WriteHelpLine ('definitionfile:<file>', 'DefinitionFileName which contains the configuration of the mapper');
  WriteHelpLine ('optionfile:<file> ',
    'OptionFileName which contains only the configuration of one option which then will be used for generation');
  WriteHelpLine ('option:<name>',
    'Name of the option group of the DefinitionFileName which should be used to generate the files');
  WriteHelpLine ('formatdefinitionfiles', 'Flag to reformat the used definition files.');
  WriteHelpLine;
  WriteHelpLine ('inputfile:<file>', 'Filter to find the JSON files to be migrated (Wildcard supported)');
  WriteHelpLine ('inputlistfile:<file>', 'Listfile which contains the coniguration to handle list of ' +
    'different files to be migrated as one big file');
  WriteHelpLine ('leadingobject:<name>',
    'Name of the property which should be used as highest level of the json objects ' +
    'This parameter is only needed for the single file conversion');
  WriteHelpLine ('splitinputfile', 'Flag to define if the InputFileName should be split up in single files. '#13#10 +
    'This option is splitting the input file in separate files when the leading structure ' +
    'of the input is an array. Then every record of the array will be generated as a single file. '#13#10 +
    'This option is only valid when generatedetails is activated');
  WriteHelpLine ('splitidentifier:<identifier>',
    'Name of the property which defines the name/filename of the splitted json element');
  WriteHelpLine;
  WriteHelpLine ('curlauthenticationfile:<file>',
    'CurlAuthenticationFileName which contains the central authentication configuration ' +
    'when using the curl automations');
  WriteHelpLine ('curlignorecache',
    'Flag to ignore the curl cache. Every file will allways be refetched, independent if there is a cache definition.');
  WriteHelpLine ('curlparameterfile:<file>',
    'CurlParameterFileName which contains additional variables to enable a dynamic configuration ' +
    'when using the curl automations');
  WriteHelpLine ('curlparameter:<name>=<value>', 'Single curl command line parameter, defined as name and value.'#13#10
    + 'The parameter can be used multiple times to define more than one curl parameter.'#13#10 +
    'The command line parameter will overwrite parameter from the parameter file having the same name.');
  WriteHelpLine;
  WriteHelpLine ('summaryfile:<file>', 'Filename of the generated summary file');
  WriteHelpLine ('baseoutputpath:<path>',
    'Base path which will be combinded with the outputpath, to define where the generated files will be stored. ' +
    'This parameter overwrites the path configured in the definition file');
  WriteHelpLine ('outputpath:<path>', 'Output path for the generation of files. ' +
    'This parameter overwrites the path configured in the definition file');
  WriteHelpLine ('outputsuffix:<suffix>', 'Additional suffix added to the name of the generated files. ' +
    'This parameter overwrites the value configured in the definition file');
  s := '';
  for f := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
    if f.IsPumlOutput then
      s := string.Join (',', [s, f.ToString]);
  s := s.TrimLeft ([',']);
  WriteHelpLine ('outputformat:<format>', Format('Format of the generated Puml converters (Allowed values: %s) ', [s]));
  s := string.Join (',', [s, jofPUML.ToString]);
  s := string.Join (',', [s, jofZip.ToString]);
  WriteHelpLine ('openoutput:[<format>]',
    Format('Flag to define if the generated files should be opened after the generation.' + #13#10 +
    'The files will be opened using the default program to handle the file format. ' + #13#10 +
    'Optional the files to be opened can be restricted by the format types (Allowed values: %s) ', [s]));
  WriteHelpLine;
  WriteHelpLine ('generatedetails:<boolean>',
    'This allows to overwrite the generateDetails property of the InputListFile');
  WriteHelpLine ('generatesummary:<boolean>',
    'This allows to overwrite the generateSummary property of the InputListFile');
  WriteHelpLine;
  WriteHelpLine ('identfilter:<filter>',
    'Value to filter/allow only objects where the ident matches to this filter value.');
  WriteHelpLine ('titlefilter:<filter>',
    'Value to filter/allow only objects where the title matches to this filter value.');
  WriteHelpLine;
  WriteHelpLine ('group:<group>', 'Group name which can be used in the output path and output suffix, it''s ' +
    'overwriting the value from the InputListFile');
  WriteHelpLine ('detail:<detail>', 'Additional detail name which can be used in the output path and output suffix');
  WriteHelpLine ('job:<job>', 'Additional job name which can be used in the output path and output suffix');
  WriteHelpLine;
  WriteHelpLine ('generateoutputdefinition',
    'Flag to define if the merged generator definition should be stored in the output folder.');
  WriteHelpLine ('generatedefaultconfiguration',
    'Flag to define that a default configuration file should be generated.');
  WriteHelpLine ('debug', 'Flag to define that a converter log file should be generated parallel to the puml file');
  WriteHelpLine (cNoLogFiles, 'Flag to define that no log files should be generated');
  WriteHelpLine;
  WriteHelpLine ('jobdescription',
    'Job description of the generated result. This information will be put into the legend of the image.');
  WriteHelpLine;
end;

constructor tJson2PumlGlobalDefinition.Create;
begin
  inherited Create;
  FCurlParameter := tJson2PumlCurlParameterList.Create ();
  FCurlPassThroughHeader := tStringList.Create ();
  FDefinitionFileSearchFolder := tStringList.Create ();
  FDefinitionFileSearchFolder.Delimiter := ';';
  FDefinitionFileSearchFolder.StrictDelimiter := true;
  FInputListFileSearchFolder := tStringList.Create ();
  FInputListFileSearchFolder.Delimiter := ';';
  FInputListFileSearchFolder.StrictDelimiter := true;
  intServicePort := cDefaultServicePort.ToString;
end;

destructor tJson2PumlGlobalDefinition.Destroy;
begin
  FCurlParameter.Free;
  FCurlPassThroughHeader.Free;
  FDefinitionFileSearchFolder.Free;
  FInputListFileSearchFolder.Free;
  inherited Destroy;
end;

procedure tJson2PumlGlobalDefinition.Clear;
begin
  intCurlAuthenticationFileName := '';
  CurlCommand := '';
  CurlPassThroughHeader.Clear;
  CurlSpanIdHeader := '';
  CurlTraceIdHeader := '';
  CurlUserAgentInformation := '';
  intDefaultDefinitionFileName := '';
  DefinitionFileSearchFolder.Clear;
  InputListFileSearchFolder.Clear;
  CurlParameter.Clear;
  intJavaRuntimeParameter := '';
  intPlantUmlJarFileName := '';
  intPlantUmlRuntimeParameter := '';
  intBaseOutputPath := '';
  intLogFileOutputPath := '';
end;

function tJson2PumlGlobalDefinition.FindDefinitionFile (iFileName: string): string;
begin
  Result := FindFileInFolderList (iFileName, DefinitionFileSearchFolder);
end;

function tJson2PumlGlobalDefinition.FindFileInFolderList (iFileName: string; iFolderList: tStringList): string;
var
  FileList: tStringList;
begin
  Result := '';
  if iFileName.IsEmpty then
    exit;
  if FileExists (ExpandFileName(iFileName)) then
  begin
    Result := iFileName;
    exit;
  end;
  FileList := tStringList.Create;
  try
    FindFilesInFolderList (FileList, iFolderList, iFileName);
    if FileList.Count > 0 then
      Result := FileList[0];
  finally
    FileList.Free;
  end;
end;

procedure tJson2PumlGlobalDefinition.FindFilesInFolderList (ioFileList, iFolderList: tStringList; iFilter: string = '');
var
  s: string;
  Filter: string;
  searchResult: tSearchRec;
  FilePath: string;
  FileName: string;
begin
  ioFileList.Clear;
  for s in iFolderList do
  begin
    FileName := TCurlUtils.ReplaceCurlVariablesFromEnvironment (s);
    if DirectoryExists (FileName) then
      FilePath := FileName
    else
      FilePath := ExtractFilePath (FileName);
    if not iFilter.IsEmpty then
      Filter := ExtractFileName (iFilter)
    else if not DirectoryExists (FileName) then
      Filter := ExtractFileName (FileName);
    if Filter.IsEmpty then
      Filter := cDefaultJsonFileFilter;
    Filter := TPath.Combine (FilePath, Filter);
    if findfirst (Filter, faAnyFile, searchResult) = 0 then
    begin
      repeat
        ioFileList.Add (TPath.Combine(FilePath, searchResult.name));
      until FindNext (searchResult) <> 0;
      System.SysUtils.FindClose (searchResult);
    end
  end;
end;

function tJson2PumlGlobalDefinition.FindInputListFile (iFileName: string): string;
begin
  Result := FindFileInFolderList (iFileName, InputListFileSearchFolder);
end;

function tJson2PumlGlobalDefinition.GetIdent: string;
begin
  Result := '';
end;

procedure tJson2PumlGlobalDefinition.LogConfiguration;
var
  s: string;
  LogList: tStringList;
begin
  LogList := tStringList.Create;
  try
    GenerateLogConfiguration (LogList);
    for s in LogList do
      GlobalLoghandler.Info (s);
  finally
    LogList.Free;
  end;
end;

procedure tJson2PumlGlobalDefinition.GenerateLogConfiguration (iLogList: tStringList);

  procedure AddLine (iName, iValue: string);
  var
    envValue: string;
  begin
    if iValue.IsEmpty then
      iLogList.Add (Format('  %-30s: %s', [iName, 'null']))
    else
    begin
      envValue := TCurlUtils.ReplaceCurlVariablesFromEnvironment (iValue);
      if iValue <> envValue then
        iLogList.Add (Format('  %-30s: %s (%s)', [iName, iValue, envValue]))
      else
        iLogList.Add (Format('  %-30s: %s', [iName, iValue]));
    end;
  end;
  procedure AddLineInt (iName: string; iCount: integer);
  begin
    if iCount <= 0 then
      iLogList.Add (Format('  %-30s: %s', [iName, 'null']))
    else
      iLogList.Add (Format('  %-30s: %d', [iName, iCount]));
  end;

  procedure AddList (iName: string; iList: tStringList);
  var
    i: integer;
  begin
    AddLineInt (iName, iList.Count);
    for i := 0 to iList.Count - 1 do
      AddLine (Format('  [%d]', [i + 1]), iList[i]);
  end;

begin
  iLogList.Clear;
  iLogList.Add (Format('Global Configuration (%s)', [SourceFileName]));
  AddLine ('additionalServiceInformation', AdditionalServiceInformation);
  AddLine ('baseOutputPath', BaseOutputPath);
  AddLine ('curlCommand', CurlCommand);
  AddLine ('curlAuthenticationFileName', CurlAuthenticationFileName);
  AddLine ('curlUserAgentInformation', CurlUserAgentInformation);
  AddLine ('curlSpanIdHeader', CurlSpanIdHeader);
  AddLine ('curlTraceIdHeader', CurlTraceIdHeader);
  AddList ('curlPassThroughHeader', CurlPassThroughHeader);
  AddLine ('defaultDefinitionFileName', DefaultDefinitionFileName);
  AddList ('definitionFileSearchFolder', DefinitionFileSearchFolder);
  AddList ('inputListFileSearchFolder', InputListFileSearchFolder);
  AddLine ('javaRuntimeParameter', JavaRuntimeParameter);
  AddLine ('logFileOutputPath', LogFileOutputPath);
  AddLine ('outputPath', OutputPath);
  AddLine ('plantUmlJarFileName', PlantUmlJarFileName);
  AddLine ('plantUmlRuntimeParameter', PlantUmlRuntimeParameter);
  iLogList.Add (Format('  %-30s: %s / %d', ['intServicePort', intServicePort, ServicePort]));
end;

function tJson2PumlGlobalDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: tJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Result := true;
  intCurlAuthenticationFileName := GetJsonStringValue (DefinitionRecord, 'curlAuthenticationFileName',
    intCurlAuthenticationFileName);
  CurlCommand := GetJsonStringValue (DefinitionRecord, 'curlCommand', CurlCommand);
  intDefaultDefinitionFileName := GetJsonStringValue (DefinitionRecord, 'defaultDefinitionFileName',
    intDefaultDefinitionFileName);
  CurlUserAgentInformation := GetJsonStringValue (DefinitionRecord, 'curlUserAgentInformation',
    CurlUserAgentInformation);
  CurlSpanIdHeader := GetJsonStringValue (DefinitionRecord, 'curlSpanIdHeader', CurlSpanIdHeader);
  CurlTraceIdHeader := GetJsonStringValue (DefinitionRecord, 'curlTraceIdHeader', CurlTraceIdHeader);
  GetJsonStringValueList (DefinitionFileSearchFolder, DefinitionRecord, 'definitionFileSearchFolder');
  GetJsonStringValueList (InputListFileSearchFolder, DefinitionRecord, 'inputListFileSearchFolder');
  intJavaRuntimeParameter := GetJsonStringValue (DefinitionRecord, 'javaRuntimeParameter', intJavaRuntimeParameter);
  intLogFileOutputPath := GetJsonStringValue (DefinitionRecord, 'logFileOutputPath', intLogFileOutputPath);
  intPlantUmlJarFileName := GetJsonStringValue (DefinitionRecord, 'plantUmlJarFileName', intPlantUmlJarFileName);
  intPlantUmlRuntimeParameter := GetJsonStringValue (DefinitionRecord, 'plantUmlRuntimeParameter',
    intPlantUmlRuntimeParameter);
  intPlantUmlServerUrl := GetJsonStringValue (DefinitionRecord, 'plantUmlServerUrl', intPlantUmlServerUrl);
  intPlantUmlServerCurlParameter := GetJsonStringValue (DefinitionRecord, 'plantUmlServerCurlParameter',
    intPlantUmlServerCurlParameter);
  intBaseOutputPath := GetJsonStringValue (DefinitionRecord, 'baseOutputPath', intBaseOutputPath);
  AdditionalServiceInformation := GetJsonStringValue (DefinitionRecord, 'additionalServiceInformation',
    AdditionalServiceInformation);
  OutputPath := GetJsonStringValue (DefinitionRecord, 'outputPath', OutputPath);
  GetJsonStringValueList (CurlPassThroughHeader, DefinitionRecord, 'curlPassThroughHeader');
  CurlPassThroughHeader.Text := CurlPassThroughHeader.Text.ToLower;
  intServicePort := GetJsonStringValue (DefinitionRecord, 'servicePort', intServicePort);
  CurlParameter.ReadFromJson (DefinitionRecord, 'curlParameter');
end;

procedure tJson2PumlGlobalDefinition.SetCurlCommand (const Value: string);
begin
  FCurlCommand := Value.Trim;
end;

procedure tJson2PumlGlobalDefinition.SetCurlSpanIdHeader (const Value: string);
begin
  FCurlSpanIdHeader := Value.ToLower.Trim;
end;

procedure tJson2PumlGlobalDefinition.SetCurlTraceIdHeader (const Value: string);
begin
  FCurlTraceIdHeader := Value.ToLower.Trim;
end;

procedure tJson2PumlGlobalDefinition.SetintBaseOutputPath (const Value: string);
begin
  FintBaseOutputPath := Value;
  FBaseOutputPath := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintCurlAuthenticationFileName (const Value: string);
begin
  FintCurlAuthenticationFileName := Value;
  FCurlAuthenticationFileName := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintDefaultDefinitionFileName (const Value: string);
begin
  FintDefaultDefinitionFileName := Value;
  FDefaultDefinitionFileName := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintJavaRuntimeParameter (const Value: string);
begin
  FintJavaRuntimeParameter := Value;
  FJavaRuntimeParameter := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintLogFileOutputPath (const Value: string);
begin
  FintLogFileOutputPath := Value;
  FLogFileOutputPath := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintPlantUmlJarFileName (const Value: string);
begin
  FintPlantUmlJarFileName := Value;
  FPlantUmlJarFileName := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintPlantUmlServerCurlParameter (const Value: string);
begin
  FintPlantUmlServerCurlParameter := Value;
  FPlantUmlServerCurlParameter := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintPlantUmlServerUrl (const Value: string);
begin
  FintPlantUmlServerUrl := Value;
  FPlantUmlServerUrl := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintPlantUmlRuntimeParameter (const Value: string);
begin
  FintPlantUmlRuntimeParameter := Value;
  FPlantUmlRuntimeParameter := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

procedure tJson2PumlGlobalDefinition.SetintServicePort (const Value: string);
begin
  FintServicePort := Value;
  FServicePort := StringToInteger (TCurlUtils.ReplaceCurlVariablesFromEnvironment(Value), cDefaultServicePort)
end;

procedure tJson2PumlGlobalDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'additionalServiceInformation', AdditionalServiceInformation, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'baseOutputPath', intBaseOutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputPath', OutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlAuthenticationFileName', intCurlAuthenticationFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlCommand', CurlCommand, iLevel + 1, iWriteEmpty);
  CurlParameter.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlPassThroughHeader', CurlPassThroughHeader, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUserAgentInformation', CurlUserAgentInformation, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlSpanIdHeader', CurlSpanIdHeader, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlTraceIdHeader', CurlTraceIdHeader, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaultDefinitionFileName', intDefaultDefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'definitionFileSearchFolder', DefinitionFileSearchFolder, iLevel + 1, false,
    iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'inputListFileSearchFolder', InputListFileSearchFolder, iLevel + 1, false,
    iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'javaRuntimeParameter', intJavaRuntimeParameter, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'logFileOutputPath', intLogFileOutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'plantUmlJarFileName', intPlantUmlJarFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'plantUmlRuntimeParameter', intPlantUmlRuntimeParameter, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'plantUmlServerCurlParameter', intPlantUmlServerCurlParameter, iLevel + 1,
    iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'plantUmlServerUrl', intPlantUmlServerUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'servicePort', intServicePort, iLevel + 1);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlFilterList.Create;
begin
  inherited Create;
  FTitleFilter := tStringList.Create;
  FTitleFilter.LineBreak := ',';

  FIdentFilter := tStringList.Create;
  FIdentFilter.LineBreak := ',';

end;

destructor tJson2PumlFilterList.Destroy;
begin
  FIdentFilter.Free;
  FTitleFilter.Free;
  inherited Destroy;
end;

function tJson2PumlFilterList.IdentMatches (iIdent: string): boolean;
begin
  Result := ListMatches (IdentFilter, iIdent);
end;

function tJson2PumlFilterList.ListMatches (iList: tStrings; iSearch: string): boolean;
var
  s: string;
begin
  if iList.Count <= 0 then
  begin
    Result := true;
    exit;
  end;
  Result := false;
  for s in iList do
    if MatchesMask (iSearch, s) then
    begin
      Result := true;
      exit;
    end;
end;

function tJson2PumlFilterList.Matches (iIdent, iTitle: string; iMatchAll: boolean = true): boolean;
begin
  if iMatchAll then
    Result := IdentMatches (iIdent) and TitleMatches (iTitle)
  else
    Result := IdentMatches (iIdent) or TitleMatches (iTitle);
end;

function tJson2PumlFilterList.TitleMatches (iTitle: string): boolean;
begin
  Result := ListMatches (TitleFilter, iTitle);
end;

constructor tJson2PumlCurlAuthenticationEnumerator.Create (AInputList: tJson2PumlCurlAuthenticationList);
begin
  inherited Create;
  FIndex := - 1;
  fInputList := AInputList;
end;

function tJson2PumlCurlAuthenticationEnumerator.GetCurrent: tJson2PumlCurlAuthenticationDefinition;
begin
  Result := fInputList[FIndex];
end;

function tJson2PumlCurlAuthenticationEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fInputList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlCurlAuthenticationDefinition.Create;
begin
  inherited Create;
  FParameter := tJson2PumlCurlAuthenticationParameterList.Create ();
end;

destructor tJson2PumlCurlAuthenticationDefinition.Destroy;
begin
  FParameter.Free;
  inherited Destroy;
end;

function tJson2PumlCurlAuthenticationDefinition.GetBaseUrlDecoded: string;
begin
  Result := ReplaceCurlVariablesFromEnvironmentAndGlobalConfiguration (BaseUrl);
end;

function tJson2PumlCurlAuthenticationDefinition.GetIdent: string;
begin
  Result := Format ('%s', [BaseUrl]);
end;

function tJson2PumlCurlAuthenticationDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: tJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  BaseUrl := GetJsonStringValue (DefinitionRecord, 'baseUrl');
  Parameter.ReadFromJson (DefinitionRecord, 'parameter');
  Result := true;
end;

procedure tJson2PumlCurlAuthenticationDefinition.SetBaseUrl (const Value: string);
begin
  FBaseUrl := Value.Trim;
end;

procedure tJson2PumlCurlAuthenticationDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'baseUrl', BaseUrl, iLevel + 1, iWriteEmpty);
  Parameter.WriteToJson (oJsonOutPut, 'parameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlCurlAuthenticationList.Create;
begin
  inherited Create;
  Sorted := true;
  Duplicates := dupIgnore;
  FAdditionalCurlParameter := tJson2PumlCurlParameterList.Create ();
end;

destructor tJson2PumlCurlAuthenticationList.Destroy;
begin
  FAdditionalCurlParameter.Free;
  inherited Destroy;
end;

function tJson2PumlCurlAuthenticationList.AddAuthentication (iBaseUrl: string): tJson2PumlCurlAuthenticationDefinition;
var
  nAuthentication: tJson2PumlCurlAuthenticationDefinition;
begin
  Result := nil;
  if iBaseUrl.IsEmpty then
    exit;
  nAuthentication := FindAuthentication (iBaseUrl);
  if not Assigned (nAuthentication) then
  begin
    nAuthentication := tJson2PumlCurlAuthenticationDefinition.Create;
    nAuthentication.BaseUrl := iBaseUrl;
    AddBaseObject (nAuthentication);
  end;
  Result := nAuthentication;
end;

function tJson2PumlCurlAuthenticationList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := tJson2PumlCurlAuthenticationDefinition.Create;
end;

function tJson2PumlCurlAuthenticationList.FindAuthentication (const iBaseUrl: string)
  : tJson2PumlCurlAuthenticationDefinition;
var
  def: tJson2PumlCurlAuthenticationDefinition;
begin
  Result := nil;
  for def in self do
    if (def.BaseUrlDecoded = iBaseUrl.Trim) or (def.BaseUrl = iBaseUrl.Trim) then
    begin
      Result := def;
      exit;
    end;
end;

function tJson2PumlCurlAuthenticationList.GetAuthentication (Index: integer): tJson2PumlCurlAuthenticationDefinition;
begin
  Result := tJson2PumlCurlAuthenticationDefinition (Objects[index]);
end;

function tJson2PumlCurlAuthenticationList.GetEnumerator: tJson2PumlCurlAuthenticationEnumerator;
begin
  Result := tJson2PumlCurlAuthenticationEnumerator.Create (self);
end;

function tJson2PumlCurlAuthenticationList.ReplaceParameterValues (const iBaseUrl, iCommand: string): string;
var
  Authentication: tJson2PumlCurlAuthenticationDefinition;
begin
  Result := iCommand;
  Authentication := FindAuthentication (iBaseUrl);
  if Assigned (Authentication) then
    Result := Authentication.Parameter.ReplaceParameterValues (Result);
  Result := AdditionalCurlParameter.ReplaceParameterValues (Result);
end;

function tJson2PumlCurlAuthenticationList.ReplaceParameterValuesObfuscated (const iBaseUrl, iCommand: string): string;
var
  Authentication: tJson2PumlCurlAuthenticationDefinition;
begin
  Result := iCommand;
  Authentication := FindAuthentication (iBaseUrl);
  if Assigned (Authentication) then
    Result := Authentication.Parameter.ReplaceParameterValuesObfuscated (Result);
  Result := AdditionalCurlParameter.ReplaceParameterValues (Result);
end;

procedure tJson2PumlCurlParameterDefinition.Assign (Source: tPersistent);
begin
  inherited Assign (Source);
  if Source is tJson2PumlCurlParameterDefinition then
  begin
    Value := tJson2PumlCurlParameterDefinition (Source).Value;
    MaxValues := tJson2PumlCurlParameterDefinition (Source).MaxValues;
  end;
end;

function tJson2PumlCurlParameterDefinition.GetValueDecoded: string;
begin
  Result := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
end;

function tJson2PumlCurlParameterDefinition.GetIdent: string;
begin
  if MulitpleValues then
    Result := Format ('%s=%s', [name, Value])
  else
    Result := Format ('%s', [name]);
end;

procedure tJson2PumlCurlParameterDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  if MaxValues <= 0 then
    WriteToJsonValue (oJsonOutPut, name, Value, iLevel + 1, iWriteEmpty)
  else
  begin
    WriteToJsonValue (oJsonOutPut, 'name', name, iLevel + 1, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'value', Value, iLevel + 1, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'maxValues', MaxValues, iLevel + 1);
  end;
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlCurlParameterEnumerator.Create (AInputList: tJson2PumlCurlParameterList);
begin
  inherited Create;
  FIndex := - 1;
  fInputList := AInputList;
end;

function tJson2PumlCurlParameterEnumerator.GetCurrent: tJson2PumlCurlParameterDefinition;
begin
  Result := fInputList[FIndex];
end;

function tJson2PumlCurlParameterEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fInputList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlCurlParameterList.Create;
begin
  inherited Create;
  Sorted := true;
  Duplicates := dupIgnore;
  FMulitpleValues := true;
end;

destructor tJson2PumlCurlParameterList.Destroy;
begin
  inherited Destroy;
end;

function tJson2PumlCurlParameterList.AddParameter (iName, iValue: string; iMaxValues: integer = 0): boolean;
var
  nParameter: tJson2PumlCurlParameterDefinition;
  i: integer;
begin
  Result := false;
  if iName.Trim.IsEmpty then
    exit;
  nParameter := tJson2PumlCurlParameterDefinition.Create;
  nParameter.MulitpleValues := MulitpleValues;
  nParameter.name := iName;
  nParameter.Value := iValue;
  nParameter.MaxValues := iMaxValues;
  i := IndexOf (nParameter.Ident);
  Result := i < 0;
  if Result then
    AddBaseObject (nParameter)
  else
  begin
    nParameter.Free;
    Parameter[i].Value := iValue;
    Parameter[i].MaxValues := iMaxValues;
  end;
end;

function tJson2PumlCurlParameterList.AddParameter (iParameter: tJson2PumlCurlParameterDefinition): boolean;
begin
  Result := AddParameter (iParameter.name, iParameter.Value, iParameter.MaxValues);
end;

procedure tJson2PumlCurlParameterList.AddParameter (iParameterList: tJson2PumlCurlParameterList;
  iNameFilter: string = '');
var
  Parameter: tJson2PumlCurlParameterDefinition;
begin
  for Parameter in iParameterList do
    if iNameFilter.IsEmpty then
      AddParameter (Parameter.name, Parameter.Value, Parameter.MaxValues)
    else if Parameter.name = iNameFilter then
      AddParameter (Parameter.name, Parameter.Value, Parameter.MaxValues);
end;

function tJson2PumlCurlParameterList.GetEnumerator: tJson2PumlCurlParameterEnumerator;
begin
  Result := tJson2PumlCurlParameterEnumerator.Create (self);
end;

function tJson2PumlCurlParameterList.GetParameter (Index: integer): tJson2PumlCurlParameterDefinition;
begin
  Result := tJson2PumlCurlParameterDefinition (Objects[index]);
end;

procedure tJson2PumlCurlParameterList.GetParameterNameList (ioNameList: tStringList; const iValueString: string);
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
  Search: string;
begin
  if not Assigned (ioNameList) then
    exit;
  ioNameList.Clear;
  Search := iValueString.ToLower;
  for CurlParameter in self do
  begin
    if Search.IndexOf (CurlParameter.name.ToLower) >= 0 then
      ioNameList.Add (CurlParameter.name);
  end;
end;

function tJson2PumlCurlParameterList.ParameterNameCount (iParameterName: string): integer;
var
  Parameter: tJson2PumlCurlParameterDefinition;
begin
  Result := 0;
  for Parameter in self do
    if Parameter.name = iParameterName then
      Result := Result + 1;
end;

procedure tJson2PumlCurlParameterList.ReadListValueFromJson (iJsonValue: tJSONValue);
var
  ParameterName, ParameterValue: string;
  ParameterMaxValues: integer;
  DefinitionRecord: tJSONObject;
  Splitted: tArray<string>;
begin
  if iJsonValue is tJSONObject then
  begin
    DefinitionRecord := tJSONObject (iJsonValue);
    if DefinitionRecord.Count = 1 then
    begin
      ParameterName := DefinitionRecord.Pairs[0].JsonString.Value;
      if DefinitionRecord.Pairs[0].JsonValue is tJSONString then
      begin
        ParameterValue := DefinitionRecord.Pairs[0].JsonValue.Value;
        AddParameter (ParameterName, ParameterValue);
      end;
    end
    else
    begin
      ParameterName := GetJsonStringValue (DefinitionRecord, 'name');
      ParameterValue := GetJsonStringValue (DefinitionRecord, 'value');
      ParameterMaxValues := GetJsonStringValueInteger (DefinitionRecord, 'maxValues', 0);
      AddParameter (ParameterName, ParameterValue, ParameterMaxValues);
    end;
  end
  else if iJsonValue is tJSONString then
  begin
    Splitted := iJsonValue.Value.Split (['='], 2);
    ParameterName := Splitted[0];
    ParameterValue := Splitted[1];
    AddParameter (ParameterName, ParameterValue);
  end;
end;

function tJson2PumlCurlParameterList.ReplaceParameterValues (iValueString: string): string;
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
begin
  Result := iValueString;
  for CurlParameter in self do
    Result := StringReplace (Result, CurlParameter.name, CurlParameter.ValueDecoded, [rfReplaceAll, rfIgnoreCase]);
end;

function tJson2PumlCurlParameterList.ReplaceParameterValuesFileName (iFileName: string): string;
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
begin
  Result := iFileName;
  for CurlParameter in self do
    Result := StringReplace (Result, CurlParameter.name, ReplaceInvalidFileNameChars(CurlParameter.ValueDecoded),
      [rfReplaceAll, rfIgnoreCase]);
end;

constructor tJson2PumlCurlFileParameterListMatrix.Create;
begin
  inherited Create;
  FNameList := tStringList.Create ();
  FNameList.OwnsObjects := true;
  FNameList.Sorted := true;
  FNameList.Duplicates := dupIgnore;
  FRowList := tStringList.Create ();
  FRowList.OwnsObjects := true;
end;

destructor tJson2PumlCurlFileParameterListMatrix.Destroy;
begin
  FRowList.Free;
  FNameList.Free;
  inherited;
end;

procedure tJson2PumlCurlFileParameterListMatrix.AddRow (iParameterList: tJson2PumlCurlParameterList);
var
  TempList: tJson2PumlCurlParameterList;
begin
  TempList := tJson2PumlCurlParameterList.Create;
  TempList.AddParameter (iParameterList);
  RowList.AddObject (RowList.Count.ToString, TempList);
end;

procedure tJson2PumlCurlFileParameterListMatrix.FillMatrix (iParameterList: tJson2PumlCurlParameterList;
  iFileName: string);
var
  InnerParameterList: tJson2PumlCurlParameterList;
  CurrentRow: tJson2PumlCurlParameterList;
  i: integer;
begin
  NameList.Clear;
  RowList.Clear;
  if not Assigned (iParameterList) then
    exit;
  if iFileName.IsEmpty then
    exit;
  iParameterList.GetParameterNameList (NameList, iFileName);
  if NameList.Count <= 0 then
    exit;
  for i := 0 to NameList.Count - 1 do
  begin
    InnerParameterList := tJson2PumlCurlParameterList.Create;
    InnerParameterList.MulitpleValues := true;
    InnerParameterList.AddParameter (iParameterList, NameList[i]);
    NameList.Objects[i] := InnerParameterList;
  end;
  CurrentRow := tJson2PumlCurlParameterList.Create;
  try
    FillRows (CurrentRow, 0);
  finally
    CurrentRow.Free;
  end;
end;

procedure tJson2PumlCurlFileParameterListMatrix.FillRows (iCurrentRow: tJson2PumlCurlParameterList; iDepth: integer);
var
  TempList: tJson2PumlCurlParameterList;
  i: integer;
begin
  if iDepth < NameList.Count then
  begin
    TempList := tJson2PumlCurlParameterList (NameList.Objects[iDepth]);
    for i := 0 to TempList.Count - 1 do
    begin
      iCurrentRow.AddParameter (TempList.Parameter[i]);
      FillRows (iCurrentRow, iDepth + 1);
      iCurrentRow.Delete (iCurrentRow.Count - 1);
    end;
  end
  else
    AddRow (iCurrentRow);
end;

function tJson2PumlCurlFileParameterListMatrix.GetRowParameterList (Index: integer): tJson2PumlCurlParameterList;
begin
  Result := tJson2PumlCurlParameterList (RowList.Objects[index]);
end;

constructor tJson2PumlFileOutputDefinition.Create;
begin
  inherited Create;
  FSourceFiles := tStringList.Create ();
  FSourceFiles.Sorted := true;
  FSourceFiles.Duplicates := dupIgnore;
  FSourceFiles.OwnsObjects := true;
end;

destructor tJson2PumlFileOutputDefinition.Destroy;
begin
  FSourceFiles.Free;
  inherited Destroy;
end;

procedure tJson2PumlFileOutputDefinition.AddFilesToZipFile (iZipFile: tZipFile; iRemoveDirectory: string;
  iOutputFormats: tJson2PumlOutputFormats);

  procedure AddFile (iFileName: string; iOutputFormat: tJson2PumlOutputFormat);
  begin
    if iOutputFormat in iOutputFormats then
      AddFileToZipFile (iZipFile, iFileName, iRemoveDirectory);
  end;

begin
  AddFile (PDFFilename, jofPDF);
  AddFile (PNGFileName, jofPNG);
  AddFile (PUmlFileName, jofPUML);
  AddFile (SVGFileName, jofSVG);
  AddFile (ConverterLogFileName, jofLog);
end;

procedure tJson2PumlFileOutputDefinition.AddGeneratedFilesToDeleteHandler
  (ioDeleteHandler: tJson2PumlFileDeleteHandler);
begin
  ioDeleteHandler.AddFile (PDFFilename);
  ioDeleteHandler.AddFile (PNGFileName);
  ioDeleteHandler.AddFile (PUmlFileName);
  ioDeleteHandler.AddFile (SVGFileName);
  ioDeleteHandler.AddFile (ConverterLogFileName);
end;

procedure tJson2PumlFileOutputDefinition.AddSourceFile (iFileName: string);
var
  FileDetailRecord: tJson2PumlFileDetailRecord;

  function IntFileSize: integer;
  var
    f: file of Byte;
  begin
    AssignFile (f, iFileName);
    Reset (f);
    try
      Result := FileSize (f);
    finally
      CloseFile (f);
    end;
  end;

  function NoOfLine: integer;
  var
    Lines: tStringList;
  begin
    Lines := tStringList.Create;
    try
      Lines.LoadFromFile (iFileName);
      Result := Lines.Count;
    finally
      Lines.Free;
    end;
  end;

begin
  if not FileExists (iFileName) then
    exit;
  FileDetailRecord := tJson2PumlFileDetailRecord.Create;
  FileDetailRecord.FileName := iFileName;
  FileDetailRecord.FileDate := TFile.GetLastWriteTime (iFileName);
  FileDetailRecord.FileSize := IntFileSize;
  FileDetailRecord.NoOfLines := NoOfLine;
  FileDetailRecord.NoOfRecords := GetJsonFileRecordCount (iFileName);

  SourceFiles.AddObject (iFileName, FileDetailRecord);

end;

procedure tJson2PumlFileOutputDefinition.DeleteGeneratedFiles;

  procedure DeleteSingleFile (iFileName: string);
  begin
    if not iFileName.IsEmpty then
      try
        TFile.Delete (iFileName);
        // GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Error (jetFileDeletionFailed, [iFileName, e.Message]);
      end;
  end;

begin
  DeleteSingleFile (PDFFilename);
  DeleteSingleFile (PNGFileName);
  DeleteSingleFile (PUmlFileName);
  DeleteSingleFile (SVGFileName);
  DeleteSingleFile (ConverterLogFileName);
end;

function tJson2PumlFileOutputDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlFileOutputDefinition.OutputFileName (iOutputFormat: tJson2PumlOutputFormat): string;
begin
  case iOutputFormat of
    jofPNG:
      Result := PNGFileName;
    jofSVG:
      Result := SVGFileName;
    jofPDF:
      Result := PDFFilename;
    jofPUML:
      Result := PUmlFileName;
    jofLog:
      Result := ConverterLogFileName;
    else
      Result := '';
  end;
end;

procedure tJson2PumlFileOutputDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
var
  Output: tStringList;
begin
  Output := tStringList.Create;
  try
    if IsSplitFile then
      WriteToJsonValue (Output, 'isSplitFile', IsSplitFile, iLevel + 1);
    if not Option.IsEmpty then
      WriteToJsonValue (Output, 'option', option, iLevel + 1, iWriteEmpty);
    if not PUmlFileName.IsEmpty then
      WriteToJsonValue (Output, 'pumlFile', PUmlFileName, iLevel + 1, iWriteEmpty);
    if not PDFFilename.IsEmpty then
      WriteToJsonValue (Output, 'pdfFile', PDFFilename, iLevel + 1, iWriteEmpty);
    if not PNGFileName.IsEmpty then
      WriteToJsonValue (Output, 'pngFile', PNGFileName, iLevel + 1, iWriteEmpty);
    if not SVGFileName.IsEmpty then
      WriteToJsonValue (Output, 'svgFile', SVGFileName, iLevel + 1, iWriteEmpty);
    if not ConverterLogFileName.IsEmpty then
      WriteToJsonValue (Output, 'converterLogFile', ConverterLogFileName, iLevel + 1, iWriteEmpty);
    if Output.Count > 0 then
    begin
      WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
      oJsonOutPut.AddStrings (Output);
      WriteObjectEndToJson (oJsonOutPut, iLevel);
    end;
  finally
    Output.Free;
  end;
end;

constructor tJson2PumlParameterFileDefinition.Create;
begin
  inherited Create;
  FCurlParameter := tJson2PumlCurlParameterList.Create ();
  FInputFiles := tJson2PumlParameterInputFileDefinitionList.Create ();
  FCurlAuthenticationParameter := tJson2PumlCurlParameterList.Create ();
end;

destructor tJson2PumlParameterFileDefinition.Destroy;
begin
  FCurlAuthenticationParameter.Free;
  FInputFiles.Free;
  FCurlParameter.Free;
  inherited Destroy;
end;

procedure tJson2PumlParameterFileDefinition.Clear;
begin
  inherited Clear;
  CurlParameter.Clear;
  CurlAuthenticationParameter.Clear;
  InputFiles.Clear;
end;

function tJson2PumlParameterFileDefinition.GetDefinitionFileNameExpanded: string;
begin
  Result := GetFileNameExpanded (DefinitionFileName);
end;

function tJson2PumlParameterFileDefinition.GetGenerateDetails: boolean;
begin
  Result := StringToBoolean (GenerateDetailsStr, false);
end;

function tJson2PumlParameterFileDefinition.GetGenerateSummary: boolean;
begin
  Result := StringToBoolean (GenerateSummaryStr, false);
end;

function tJson2PumlParameterFileDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlParameterFileDefinition.GetInputListFileNameExpanded: string;
begin
  Result := GetFileNameExpanded (InputListFileName);
end;

function tJson2PumlParameterFileDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: tJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  JobDescription := GetJsonStringValue (DefinitionRecord, 'jobDescription');
  Jobname := GetJsonStringValue (DefinitionRecord, 'job');
  Group := GetJsonStringValue (DefinitionRecord, 'group');
  Detail := GetJsonStringValue (DefinitionRecord, 'detail');
  InputListFileName := GetJsonStringValue (DefinitionRecord, 'inputListFile');
  DefinitionFileName := GetJsonStringValue (DefinitionRecord, 'definitionFile');
  GenerateSummaryStr := GetJsonStringValue (DefinitionRecord, 'generateSummary');
  GenerateDetailsStr := GetJsonStringValue (DefinitionRecord, 'generateDetails');
  OutputFormatStr := GetJsonStringValue (DefinitionRecord, 'outputFormats');
  Option := GetJsonStringValue (DefinitionRecord, 'option');
  OutputSuffix := GetJsonStringValue (DefinitionRecord, 'outputSuffix');
  CurlParameter.ReadFromJson (DefinitionRecord, 'curlParameter');
  CurlAuthenticationParameter.ReadFromJson (DefinitionRecord, 'curlAuthenticationParameter');
  InputFiles.ReadFromJson (DefinitionRecord, 'inputFiles');
  Result := true;
end;

procedure tJson2PumlParameterFileDefinition.SetOutputFormatStr (const Value: string);
begin
  FOutputFormats.FromString (Value, false, true);
  FOutputFormatStr := FOutputFormats.ToString (false);
end;

procedure tJson2PumlParameterFileDefinition.SetOutputSuffix (const Value: string);
begin
  FOutputSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlParameterFileDefinition.SetSourceFileName (const Value: string);
begin
  inherited SetSourceFileName (Value);
  InputFiles.SourceFileName := Value;
  CurlParameter.SourceFileName := Value;
  CurlAuthenticationParameter.SourceFileName := Value;
end;

procedure tJson2PumlParameterFileDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'definitionFile', DefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'detail', Detail, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'group', Group, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'job', Jobname, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'jobDescription', JobDescription, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'inputListFile', InputListFileName, iLevel + 1, iWriteEmpty);
  InputFiles.WriteToJson (oJsonOutPut, 'inputFiles', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateSummary', GenerateSummaryStr, iLevel + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'generateDetails', GenerateDetailsStr, iLevel + 1, iWriteEmpty, false);
  OutputFormatStr := OutputFormats.ToString (false);
  WriteToJsonValue (oJsonOutPut, 'outputFormats', OutputFormatStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'option', Option, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputSuffix', OutputSuffix, iLevel + 1, iWriteEmpty);
  CurlParameter.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
  CurlAuthenticationParameter.WriteToJson (oJsonOutPut, 'curlAuthenticationParameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlParameterInputFileDefinitionListEnumerator.Create
  (AObjectList: tJson2PumlParameterInputFileDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := AObjectList;
end;

function tJson2PumlParameterInputFileDefinitionListEnumerator.GetCurrent: tJson2PumlParameterInputFileDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlParameterInputFileDefinitionListEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

function tJson2PumlParameterInputFileDefinitionList.AddInputFile (const iFileName: string; iLeadingObject: string;
  iContent: string = ''): boolean;
var
  nInputFile: tJson2PumlParameterInputFileDefinition;
  i: integer;
begin
  Result := false;
  if iFileName.Trim.IsEmpty then
    exit;
  nInputFile := tJson2PumlParameterInputFileDefinition.Create;
  nInputFile.FileName := iFileName;
  nInputFile.LeadingObject := iLeadingObject;
  nInputFile.Content := iContent;
  i := IndexOf (nInputFile.Ident);
  Result := i < 0;
  if Result then
    AddBaseObject (nInputFile)
  else
    nInputFile.Free;
end;

function tJson2PumlParameterInputFileDefinitionList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := tJson2PumlParameterInputFileDefinition.Create;
end;

function tJson2PumlParameterInputFileDefinitionList.GetEnumerator: tJson2PumlParameterInputFileDefinitionListEnumerator;
begin
  Result := tJson2PumlParameterInputFileDefinitionListEnumerator.Create (self);
end;

function tJson2PumlParameterInputFileDefinitionList.GetInputFile (Index: integer)
  : tJson2PumlParameterInputFileDefinition;
begin
  Result := tJson2PumlParameterInputFileDefinition (Objects[index]);
end;

constructor tJson2PumlParameterInputFileDefinition.Create;
begin
  inherited Create;
  FJsonContent := nil;
end;

destructor tJson2PumlParameterInputFileDefinition.Destroy;
begin
  if Assigned (FJsonContent) then
    FJsonContent.Free;
  inherited Destroy;
end;

function tJson2PumlParameterInputFileDefinition.GetIdent: string;
begin
  Result := FileName.Trim.ToLower;
end;

function tJson2PumlParameterInputFileDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: tJSONObject;
  Value: tJSONValue;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  FileName := GetJsonStringValue (DefinitionRecord, 'fileName');
  LeadingObject := GetJsonStringValue (DefinitionRecord, 'leadingObject');
  Value := GetJsonValue (DefinitionRecord, 'content');
  if Assigned (Value) and not (Value is tJSONNull) then
    Content := Value.ToString
  else
    Content := '';
  Result := true;
end;

procedure tJson2PumlParameterInputFileDefinition.SetContent (const Value: string);
begin
  FContent := Value;
  if Assigned (FJsonContent) then
    FJsonContent.Free;
  FJsonContent := tJSONObject.ParseJSONValue (Content) as tJSONValue;
end;

procedure tJson2PumlParameterInputFileDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'fileName', FileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'leadingObject', LeadingObject, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'content', JsonContent, iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlInputListDescriptionDefinition.Create;
begin
  inherited Create;
  FCurlParameterList := tJson2PumlFileDescriptionParameterList.Create ();
end;

destructor tJson2PumlInputListDescriptionDefinition.Destroy;
begin
  FCurlParameterList.Free;
  inherited Destroy;
end;

procedure tJson2PumlInputListDescriptionDefinition.Clear;
begin
  inherited Clear;
  CurlParameterList.Clear;
end;

function tJson2PumlInputListDescriptionDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlInputListDescriptionDefinition.GetCurlParameter (Index: integer)
  : tJson2PumlFileDescriptionParameterDefinition;
begin
  Result := CurlParameterList[index];
end;

function tJson2PumlInputListDescriptionDefinition.GetIsValid: boolean;
begin
  Result := not Description.IsEmpty;
end;

function tJson2PumlInputListDescriptionDefinition.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  Definition: tJSONObject;
begin
  Result := false;
  Clear;
  if not (iJsonValue is tJSONObject) then
    exit;
  Definition := GetJsonObject (tJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  Description := GetJsonStringValue (Definition, 'description');
  DisplayName := GetJsonStringValue (Definition, 'displayName');
  CurlParameterList.ReadFromJson (Definition, 'curlParameter');
  Result := IsValid;
end;

procedure tJson2PumlInputListDescriptionDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'displayName', DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description, iLevel + 1, iWriteEmpty);
  CurlParameterList.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

function tJson2PumlFileDescriptionParameterList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := tJson2PumlFileDescriptionParameterDefinition.Create;
end;

function tJson2PumlFileDescriptionParameterList.GetEnumerator: tJson2PumlFileDescriptionParameterListEnumerator;
begin
  Result := tJson2PumlFileDescriptionParameterListEnumerator.Create (self);
end;

function tJson2PumlFileDescriptionParameterList.GetInputParameter (Index: integer)
  : tJson2PumlFileDescriptionParameterDefinition;
begin
  Result := tJson2PumlFileDescriptionParameterDefinition (Objects[index]);
end;

type
  tMandatoryGroupListEntry = class(tObject)
  public
    NameList: string;
    Empty: boolean;
  end;

function tJson2PumlFileDescriptionParameterList.ValidatedInputParameter (iInputCurlParameterList
  : tJson2PumlCurlParameterList; oErrormessages: tStringList): boolean;
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
  DescriptionParameter: tJson2PumlFileDescriptionParameterDefinition;
  i: integer;
  MandatoryGroupList: tStringList;
  ListEntry: tMandatoryGroupListEntry;
  found: boolean;

  procedure AddToMandatoryGroups (iIsEmpty: boolean);
  var
    Groups: tArray<string>;
    j: integer;
    Group: string;
  begin
    if DescriptionParameter.MandatoryGroup.IsEmpty then
      exit;
    Groups := DescriptionParameter.MandatoryGroup.Split ([',', ';']);
    for Group in Groups do
    begin
      j := MandatoryGroupList.IndexOf (Group);
      if j < 0 then
      begin
        ListEntry := tMandatoryGroupListEntry.Create;
        ListEntry.Empty := iIsEmpty;
        ListEntry.NameList := DescriptionParameter.VisibleName;
        MandatoryGroupList.AddObject (Group, ListEntry);
      end
      else
      begin
        ListEntry := tMandatoryGroupListEntry (MandatoryGroupList.Objects[j]);
        ListEntry.Empty := ListEntry.Empty and iIsEmpty;
        ListEntry.NameList := string.Join (',', [ListEntry.NameList, DescriptionParameter.VisibleName]);
      end;
    end;
  end;

  procedure ValidateValue (iValue: string);
  var
    ValidateMessage: string;
  begin
    if not DescriptionParameter.ValidateValue (iValue, ValidateMessage) then
      oErrormessages.Add (ValidateMessage);
    AddToMandatoryGroups (iValue.IsEmpty);
  end;

begin
  MandatoryGroupList := tStringList.Create;
  try
    MandatoryGroupList.Sorted := true;
    MandatoryGroupList.Duplicates := dupIgnore;
    MandatoryGroupList.OwnsObjects := true;
    for DescriptionParameter in self do
    begin
      found := false;
      for CurlParameter in iInputCurlParameterList do
        if CurlParameter.name = DescriptionParameter.name then
        begin
          ValidateValue (CurlParameter.Value);
          found := true;
        end;
      if not found then
        ValidateValue ('');
    end;
    for i := 0 to MandatoryGroupList.Count - 1 do
    begin
      ListEntry := tMandatoryGroupListEntry (MandatoryGroupList.Objects[i]);
      if ListEntry.Empty then
        oErrormessages.Add (Format('Minimum one of the following parameters "%s" must be filled.',
          [ListEntry.NameList]));
    end;
  finally
    MandatoryGroupList.Free;
  end;
  Result := oErrormessages.Count <= 0;
end;

constructor tJson2PumlFileDescriptionParameterListEnumerator.Create
  (AParameterList: tJson2PumlFileDescriptionParameterList);
begin
  inherited Create;
  FIndex := - 1;
  fParameterList := AParameterList;
end;

function tJson2PumlFileDescriptionParameterListEnumerator.GetCurrent: tJson2PumlFileDescriptionParameterDefinition;
begin
  Result := fParameterList[FIndex];
end;

function tJson2PumlFileDescriptionParameterListEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fParameterList.Count - 1;
  if Result then
    Inc (FIndex);
end;

function tJson2PumlFileDescriptionParameterDefinition.GetIdent: string;
begin
  Result := name.Trim.ToLower;
end;

function tJson2PumlFileDescriptionParameterDefinition.GetIsValid: boolean;
begin
  Result := not name.IsEmpty;
end;

function tJson2PumlFileDescriptionParameterDefinition.GetVisibleName: string;
begin
  if DisplayName.IsEmpty then
    Result := name
  else
    Result := Format ('%s (%s)', [DisplayName, name]);
end;

function tJson2PumlFileDescriptionParameterDefinition.ReadFromJson (iJsonValue: tJSONValue;
  iPropertyName: string): boolean;
var
  Definition: tJSONObject;
begin
  Result := false;
  Clear;
  if not (iJsonValue is tJSONObject) then
    exit;
  Definition := GetJsonObject (tJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  name := GetJsonStringValue (Definition, 'name');
  Description := GetJsonStringValue (Definition, 'description');
  DisplayName := GetJsonStringValue (Definition, 'displayName');
  Mandatory := GetJsonStringValueBoolean (Definition, 'mandatory', false);
  MandatoryGroup := GetJsonStringValue (Definition, 'mandatoryGroup');
  RegularExpression := GetJsonStringValue (Definition, 'regularExpression');
  DefaultValue := GetJsonStringValue (Definition, 'defaultValue');
  Result := IsValid;
end;

procedure tJson2PumlFileDescriptionParameterDefinition.SetName (const Value: string);
begin
  FName := Value.Trim.ToLower;
  if not FName.IsEmpty and (FName.Substring(0, 2) <> '${') then
    FName := Format ('${%s}', [FName]);
end;

function tJson2PumlFileDescriptionParameterDefinition.ValidateValue (iValue: string;
  var oValidationMessage: string): boolean;
begin
  Result := true;
  if iValue.IsEmpty and Mandatory and MandatoryGroup.IsEmpty then
  begin
    Result := false;
    oValidationMessage := Format ('Mandatory parameter "%s" not filled.', [VisibleName]);
    exit;
  end;
  if (not iValue.IsEmpty) and (not RegularExpression.IsEmpty) then
    if not TRegEx.isMatch (iValue, RegularExpression) then
    begin
      Result := false;
      oValidationMessage := Format ('parameter "%s" : value "%s" does not match regular expression "%s".',
        [VisibleName, iValue, RegularExpression]);
      exit;
    end;
end;

procedure tJson2PumlFileDescriptionParameterDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', name, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'displayName', DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'mandatory', Mandatory, iLevel + 1);
  WriteToJsonValue (oJsonOutPut, 'mandatoryGroup', MandatoryGroup, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'regularExpression', RegularExpression, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaultValue', DefaultValue, iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlFileDeleteHandler.Create;
begin
  inherited Create;
  FFileList := tStringList.Create ();
  FDirectoryList := tStringList.Create ();
  FLock := tCriticalSection.Create ();
end;

destructor tJson2PumlFileDeleteHandler.Destroy;
begin
  FLock.Free;
  FDirectoryList.Free;
  FFileList.Free;
  inherited Destroy;
end;

procedure tJson2PumlFileDeleteHandler.AddDirectory (iDirectoryName: string);
begin
  Lock.Acquire;
  try
    if not iDirectoryName.IsEmpty then
      DirectoryList.Add (iDirectoryName);
  finally
    Lock.Release;
  end;
end;

procedure tJson2PumlFileDeleteHandler.AddFile (iFileName: string);
begin
  Lock.Acquire;
  try
    if not iFileName.IsEmpty then
      FileList.Add (iFileName);
  finally
    Lock.Release;
  end;
end;

procedure tJson2PumlFileDeleteHandler.DeleteFiles;
var
  i: integer;

  function DeleteSingleFile (iFileName: string): boolean;
  begin
    if FileExists (iFileName) then
      try
        TFile.Delete (iFileName);
        // GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Error (jetFileDeletionFailed, [iFileName, e.Message]);
      end;
    Result := not FileExists (iFileName);
  end;

  function DeleteSingleDirectory (iDirectoryName: string): boolean;
  begin
    if TDirectory.Exists (iDirectoryName) then
      try
        TDirectory.Delete (iDirectoryName, true);
        // GlobalLoghandler.Debug ('Directory "%s" deleted."', [iDirectoryName]);
      except
        on e: exception do
          GlobalLoghandler.Error (jetDirectoryDeletionFailed, [iDirectoryName, e.Message]);
      end;
    Result := not TDirectory.Exists (iDirectoryName);
  end;

begin
  Lock.Acquire;
  try
    i := 0;
    while i < FileList.Count do
    begin
      if DeleteSingleFile (FileList[i]) then
        FileList.Delete (i)
      else
        Inc (i);
    end;
    i := 0;
    while i < DirectoryList.Count do
    begin
      if DeleteSingleDirectory (DirectoryList[i]) then
        DirectoryList.Delete (i)
      else
        Inc (i);
    end;
  finally
    Lock.Release;
  end;
end;

constructor tJson2PumlCurlMappingParameterDefinition.Create;
begin
  inherited Create;
  FUrlEncodeValue := true;
end;

procedure tJson2PumlCurlMappingParameterDefinition.Assign (Source: tPersistent);
begin
  inherited Assign (Source);
  if Source is tJson2PumlCurlMappingParameterDefinition then
  begin
    Prefix := tJson2PumlCurlMappingParameterDefinition (Source).Prefix;
    Suffix := tJson2PumlCurlMappingParameterDefinition (Source).Suffix;
    UrlEncodeValue := tJson2PumlCurlMappingParameterDefinition (Source).UrlEncodeValue;
    Value := tJson2PumlCurlMappingParameterDefinition (Source).Value;
    ValueIfEmpty := tJson2PumlCurlMappingParameterDefinition (Source).ValueIfEmpty;
  end;
end;

function tJson2PumlCurlMappingParameterDefinition.GetCalculatedValue: string;
begin
  Result := TCurlUtils.ReplaceCurlVariablesFromEnvironment (Value);
  Result := TCurlUtils.CleanUnusedCurlVariables (Result);
  if Result.IsEmpty then
    Result := ValueIfEmpty
  else if UrlEncodeValue then
    Result := string.Join ('', [Prefix, tNetEncoding.Url.Encode(Result), Suffix])
  else
    Result := string.Join ('', [Prefix, Result, Suffix]);
end;

function tJson2PumlCurlMappingParameterDefinition.GetIsFilled: boolean;
begin
  Result := not name.IsEmpty;
end;

function tJson2PumlCurlMappingParameterDefinition.GetIsValid: boolean;
begin
  Result := not name.IsEmpty and (not Value.IsEmpty or not ValueIfEmpty.IsEmpty);
end;

procedure tJson2PumlCurlMappingParameterDefinition.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string;
  iLevel: integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', name, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'prefix', Prefix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'value', Value, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'suffix', Suffix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'valueIfEmpty', ValueIfEmpty, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'urlEncodeValue', UrlEncodeValue, iLevel + 1);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlCurlMappingParameterEnumerator.Create (AInputList: tJson2PumlCurlMappingParameterList);
begin
  inherited Create;
  FIndex := - 1;
  fInputList := AInputList;
end;

function tJson2PumlCurlMappingParameterEnumerator.GetCurrent: tJson2PumlCurlMappingParameterDefinition;
begin
  Result := fInputList[FIndex];
end;

function tJson2PumlCurlMappingParameterEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fInputList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlCurlMappingParameterList.Create;
begin
  inherited;
end;

destructor tJson2PumlCurlMappingParameterList.Destroy;
begin
  inherited;
end;

function tJson2PumlCurlMappingParameterList.AddParameter (iName, iPrefix, iValue, iSuffix, iValueIfEmpty: string;
  iUrlEncodeValue: boolean): boolean;
var
  nParameter: tJson2PumlCurlMappingParameterDefinition;
  i: integer;
begin
  Result := false;
  if iName.Trim.IsEmpty then
    exit;
  nParameter := tJson2PumlCurlMappingParameterDefinition.Create;
  nParameter.name := iName;
  nParameter.ValueIfEmpty := iValueIfEmpty;
  nParameter.Value := iValue;
  nParameter.Prefix := iPrefix;
  nParameter.Suffix := iSuffix;
  nParameter.UrlEncodeValue := iUrlEncodeValue;
  i := IndexOf (nParameter.Ident);
  Result := i < 0;
  if Result then
    AddBaseObject (nParameter)
  else
    nParameter.Free;
end;

function tJson2PumlCurlMappingParameterList.GetEnumerator: tJson2PumlCurlMappingParameterEnumerator;
begin
  Result := tJson2PumlCurlMappingParameterEnumerator.Create (self);
end;

function tJson2PumlCurlMappingParameterList.GetParameter (Index: integer): tJson2PumlCurlMappingParameterDefinition;
begin
  Result := tJson2PumlCurlMappingParameterDefinition (Objects[index]);
end;

procedure tJson2PumlCurlMappingParameterList.ReadListValueFromJson (iJsonValue: tJSONValue);
var
  ParameterName, Prefix, Suffix, Value, ValueIfEmpty: string;
  UrlEncodeValue: boolean;
  DefinitionRecord: tJSONObject;
begin
  if iJsonValue is tJSONObject then
  begin
    DefinitionRecord := tJSONObject (iJsonValue);
    ParameterName := GetJsonStringValue (DefinitionRecord, 'name');
    Prefix := GetJsonStringValue (DefinitionRecord, 'prefix');
    Suffix := GetJsonStringValue (DefinitionRecord, 'suffix');
    Value := GetJsonStringValue (DefinitionRecord, 'value');
    ValueIfEmpty := GetJsonStringValue (DefinitionRecord, 'valueIfEmpty');
    UrlEncodeValue := GetJsonStringValueBoolean (DefinitionRecord, 'urlEncodeValue', false);
    AddParameter (ParameterName, Prefix, Value, Suffix, ValueIfEmpty, UrlEncodeValue);
  end;
end;

function tJson2PumlCurlMappingParameterList.ReplaceParameterValues (iValueString: string): string;
var
  CurlParameter: tJson2PumlCurlMappingParameterDefinition;
begin
  Result := iValueString;
  for CurlParameter in self do
    Result := StringReplace (Result, CurlParameter.name, CurlParameter.CalculatedValue, [rfReplaceAll, rfIgnoreCase]);
end;

procedure tJson2PumlCurlBaseParameterDefinition.Assign (Source: tPersistent);
begin
  inherited Assign (Source);
  if Source is tJson2PumlCurlBaseParameterDefinition then
    name := tJson2PumlCurlBaseParameterDefinition (Source).name;
end;

function tJson2PumlCurlBaseParameterDefinition.GetIdent: string;
begin
  Result := Format ('%s', [name]);
end;

procedure tJson2PumlCurlBaseParameterDefinition.SetName (const Value: string);
begin
  FName := Value.Trim.ToLower;
  if not FName.IsEmpty and (FName.Substring(0, 2) <> '${') then
    FName := Format ('${%s}', [FName]);
end;

procedure tJson2PumlCurlResult.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlCurlResult then
  begin
    Command := tJson2PumlCurlResult (Source).Command;
    ErrorMessage := tJson2PumlCurlResult (Source).ErrorMessage;
    ExitCode := tJson2PumlCurlResult (Source).ExitCode;
    HttpCode := tJson2PumlCurlResult (Source).HttpCode;
    OutPutFile := tJson2PumlCurlResult (Source).OutPutFile;
    Url := tJson2PumlCurlResult (Source).Url;
    Generated := tJson2PumlCurlResult (Source).Generated;
    Duration := tJson2PumlCurlResult (Source).Duration;
    NoOfRecords := tJson2PumlCurlResult (Source).NoOfRecords;
    FileSize := tJson2PumlCurlResult (Source).FileSize;
  end;
end;

procedure tJson2PumlCurlResult.Clear;
begin
  inherited;
  Command := '';
  ErrorMessage := '';
  ExitCode := '';
  HttpCode := '';
  OutPutFile := '';
  Url := '';
  Generated := false;
  Duration := 0;
  NoOfRecords := 0;
  FileSize := 0;
end;

function tJson2PumlCurlAuthenticationParameterList.ObfuscateValue (iValueString: string): string;
const
  MASK_CHAR = '*';
  MIN_LENGTH_FOR_PARTIAL_DISPLAY = 16;
  MAX_VISIBLE_CHARS = 4;
var
  StrLength: integer;
  FirstCharsLength: integer;
  LastCharsLength: integer;
begin
  Result := StringOfChar (MASK_CHAR, 6);
  StrLength := length (iValueString);

  if StrLength > MIN_LENGTH_FOR_PARTIAL_DISPLAY then
  begin
    // Calculate the length of the first and last visible characters
    FirstCharsLength := (StrLength - MIN_LENGTH_FOR_PARTIAL_DISPLAY) div 2;

    // Ensure FirstCharsLength does not exceed MAX_VISIBLE_CHARS
    if FirstCharsLength > MAX_VISIBLE_CHARS then
      FirstCharsLength := MAX_VISIBLE_CHARS;

    LastCharsLength := FirstCharsLength; // In this case, last will be same as first

    // Construct the obfuscated string
    Result := Copy (iValueString, 1, FirstCharsLength) + Result + Copy (iValueString, StrLength - LastCharsLength + 1,
      LastCharsLength);
  end;
end;

function tJson2PumlCurlAuthenticationParameterList.ReplaceParameterValuesObfuscated (iValueString: string): string;
var
  CurlParameter: tJson2PumlCurlParameterDefinition;
begin
  Result := iValueString;
  for CurlParameter in self do
    Result := StringReplace (Result, CurlParameter.name, ObfuscateValue(CurlParameter.ValueDecoded),
      [rfReplaceAll, rfIgnoreCase]);
end;

initialization

InitializationGlobalVariables;

finalization

FinalizationGlobalVariables;

end.
