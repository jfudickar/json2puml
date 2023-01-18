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

uses System.JSON, System.Classes, json2pumlloghandler, json2pumlconst, json2pumlbasedefinition, System.SyncObjs,
  System.Zip;

type
  tJson2PumlCurlParameterList = class;
  tJson2PumlCurlAuthenticationList = class;

  tJson2PumlFileDeleteHandler = class(tPersistent)
  private
    FDirectoryList: tStringList;
    FFileList: tStringList;
    FLock: TCriticalSection;
  protected
    property DirectoryList: tStringList read FDirectoryList;
    property FileList: tStringList read FFileList;
    property Lock: TCriticalSection read FLock;
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
    FJsonContent: TJSONValue;
    FLeadingObject: string;
    procedure SetContent (const Value: string);
  protected
    function GetIdent: string; override;
  public
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property Content: string read FContent write SetContent;
    property FileName: string read FFileName write FFileName;
    property JsonContent: TJSONValue read FJsonContent write FJsonContent;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
  end;

  tJson2PumlParameterInputFileDefinitionList = class;

  tJson2PumlParameterInputFileDefinitionListEnumerator = class
  private
    FIndex: Integer;
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
    function GetInputFile (Index: Integer): tJson2PumlParameterInputFileDefinition;
  public
    function AddInputFile (const iFileName: string; iLeadingObject: string; iContent: string = ''): boolean;
    function GetEnumerator: tJson2PumlParameterInputFileDefinitionListEnumerator;
    property InputFile[index: Integer]: tJson2PumlParameterInputFileDefinition read GetInputFile; default;
  end;

  tJson2PumlParameterFileDefinition = class(tJson2PumlBaseObject)
  private
    FCurlParameter: tJson2PumlCurlParameterList;
    FDefinitionFileName: string;
    FGenerateDetailsStr: string;
    FGenerateSummaryStr: string;
    FInputFiles: tJson2PumlParameterInputFileDefinitionList;
    FInputListFileName: string;
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
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property CurlParameter: tJson2PumlCurlParameterList read FCurlParameter;
    property DefinitionFileNameExpanded: string read GetDefinitionFileNameExpanded;
    property GenerateSummary: boolean read GetGenerateSummary;
    property InputFiles: tJson2PumlParameterInputFileDefinitionList read FInputFiles write FInputFiles;
    property InputListFileNameExpanded: string read GetInputListFileNameExpanded;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
  published
    property DefinitionFileName: string read FDefinitionFileName write FDefinitionFileName;
    property GenerateDetails: boolean read GetGenerateDetails;
    property GenerateDetailsStr: string read FGenerateDetailsStr write FGenerateDetailsStr;
    property GenerateSummaryStr: string read FGenerateSummaryStr write FGenerateSummaryStr;
    property InputListFileName: string read FInputListFileName write FInputListFileName;
    property Option: string read FOption write FOption;
    property OutputFormatStr: string read FOutputFormatStr write SetOutputFormatStr;
    property OutputSuffix: string read FOutputSuffix write SetOutputSuffix;
  end;

  tJson2PumlGlobalDefinition = class(tJson2PumlBaseObject)
  private
    FBaseOutputPath: string;
    FCurlAuthenticationFileName: string;
    FDefaultDefinitionFileFolder: tStringList;
    FDefaultDefinitionFileName: string;
    FDefaultInputListFileFolder: tStringList;
    FJavaRuntimeParameter: string;
    FLogFileOutputPath: string;
    FOutputPath: string;
    FPlantUmlJarFileName: string;
    FServicePort: Integer;
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
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property BaseOutputPath: string read FBaseOutputPath write FBaseOutputPath;
    property CurlAuthenticationFileName: string read FCurlAuthenticationFileName write FCurlAuthenticationFileName;
    property DefaultDefinitionFileFolder: tStringList read FDefaultDefinitionFileFolder;
    property DefaultDefinitionFileName: string read FDefaultDefinitionFileName write FDefaultDefinitionFileName;
    property DefaultInputListFileFolder: tStringList read FDefaultInputListFileFolder;
    property JavaRuntimeParameter: string read FJavaRuntimeParameter write FJavaRuntimeParameter;
    property LogFileOutputPath: string read FLogFileOutputPath write FLogFileOutputPath;
    property OutputPath: string read FOutputPath write FOutputPath;
    property PlantUmlJarFileName: string read FPlantUmlJarFileName write FPlantUmlJarFileName;
    property ServicePort: Integer read FServicePort write FServicePort;
  end;

  TJson2PumlFileDetailRecord = class(tPersistent)
  private
    FFileDate: tDateTime;
    FFileName: string;
    FFileSize: Integer;
    FNoOfLines: Integer;
  public
    property FileDate: tDateTime read FFileDate write FFileDate;
    property FileName: string read FFileName write FFileName;
    property FileSize: Integer read FFileSize write FFileSize;
    property NoOfLines: Integer read FNoOfLines write FNoOfLines;
  end;

  tJson2PumlFileOutputDefinition = class(tJson2PumlBaseObject)
  private
    FConverterLogFileName: string;
    FIsSplitFile: boolean;
    FIsSummaryFile: boolean;
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
    procedure AddFilesToZipFile (iZipFile: TZipFile; iRemoveDirectory: string);
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    procedure AddSourceFile (iFileName: string);
    procedure DeleteGeneratedFiles;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property ConverterLogFileName: string read FConverterLogFileName write FConverterLogFileName;
    property IsSplitFile: boolean read FIsSplitFile write FIsSplitFile;
    property IsSummaryFile: boolean read FIsSummaryFile write FIsSummaryFile;
    property PDFFilename: string read FPDFFilename write FPDFFilename;
    property PNGFileName: string read FPNGFileName write FPNGFileName;
    property PUmlFileName: string read FPUmlFileName write FPUmlFileName;
    property SourceFiles: tStringList read FSourceFiles;
    property SVGFileName: string read FSVGFileName write FSVGFileName;
  end;

  tJson2PumlInputFileDefinition = class(tJson2PumlBaseObject)
  private
    FCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
    FCurlBaseUrl: string;
    FCurlCache: Integer;
    FCurlCommand: string;
    FCurlFileNameSuffix: string;
    FCurlFormatOutputStr: string;
    FCurlOptions: string;
    FCurlOutputParameter: tJson2PumlCurlParameterList;
    FCurlUrl: string;
    FGenerateOutput: boolean;
    FInputFileName: string;
    FIsConverted: boolean;
    FIsGenerated: boolean;
    FLeadingObject: string;
    FOriginal: boolean;
    FOutput: tJson2PumlFileOutputDefinition;
    FOutputFileName: string;
    FSplitIdentifier: string;
    FSplitInputFileStr: string;
    function GetCurlBaseUrlDecoded: string;
    function GetCurlFormatOutput: boolean;
    function GetExists: boolean;
    function GetExtractedOutputFileName: string;
    function GetInputFileNameExpanded: string;
    function GetIsSplitFile: boolean;
    function GetIsSummaryFile: boolean;
    function GetSplitInputFile: boolean;
    procedure SetCurlFormatOutputStr (const Value: string);
    procedure SetInputFileName (const Value: string);
    procedure SetIsSplitFile (const Value: boolean);
    procedure SetIsSummaryFile (const Value: boolean);
    procedure SetOutputFileName (const Value: string);
    procedure SetSplitInputFileStr (const Value: string);
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddFilesToZipFile (iZipFile: TZipFile; iRemoveDirectory: string);
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    procedure DeleteGeneratedFiles;
    procedure ExpandFileNameWithCurlParameter (iCurlParameterList: tJson2PumlCurlParameterList);
    procedure GetCurlParameterFromFile (iCurlOutputParameter, iCurlParameterList: tJson2PumlCurlParameterList);
    function HandleCurl (const iBaseUrl: string; iUrlAddon: string; const iOptions: string;
      iExecuteCurlParameterList, ioResultCurlParameterList: tJson2PumlCurlParameterList): boolean;
    function HasValidCurl: boolean;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonOutputFile (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false);
    procedure WriteToJsonServiceResult (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iOutputFormats: tJson2PumlOutputFormats; iWriteEmpty: boolean = false);
    property CurlAuthenticationList: tJson2PumlCurlAuthenticationList read FCurlAuthenticationList
      write FCurlAuthenticationList;
    property CurlBaseUrlDecoded: string read GetCurlBaseUrlDecoded;
    property CurlCommand: string read FCurlCommand write FCurlCommand;
    property CurlFormatOutputStr: string read FCurlFormatOutputStr write SetCurlFormatOutputStr;
    property Exists: boolean read GetExists;
    property ExtractedOutputFileName: string read GetExtractedOutputFileName;
    property InputFileNameExpanded: string read GetInputFileNameExpanded;
    property IsConverted: boolean read FIsConverted write FIsConverted;
    property IsGenerated: boolean read FIsGenerated write FIsGenerated;
    property IsSplitFile: boolean read GetIsSplitFile write SetIsSplitFile;
    property IsSummaryFile: boolean read GetIsSummaryFile write SetIsSummaryFile;
    property Original: boolean read FOriginal write FOriginal;
    property Output: tJson2PumlFileOutputDefinition read FOutput write FOutput;
    property OutputFileName: string read FOutputFileName write SetOutputFileName;
    property SplitInputFileStr: string read FSplitInputFileStr write SetSplitInputFileStr;
  published
    property CurlBaseUrl: string read FCurlBaseUrl write FCurlBaseUrl;
    property CurlCache: Integer read FCurlCache write FCurlCache;
    property CurlFileNameSuffix: string read FCurlFileNameSuffix write FCurlFileNameSuffix;
    property CurlFormatOutput: boolean read GetCurlFormatOutput;
    property CurlOptions: string read FCurlOptions write FCurlOptions;
    property CurlOutputParameter: tJson2PumlCurlParameterList read FCurlOutputParameter;
    property CurlUrl: string read FCurlUrl write FCurlUrl;
    property GenerateOutput: boolean read FGenerateOutput write FGenerateOutput;
    property InputFileName: string read FInputFileName write SetInputFileName;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
    property SplitIdentifier: string read FSplitIdentifier write FSplitIdentifier;
    property SplitInputFile: boolean read GetSplitInputFile;
  end;

  tJson2PumlFilterList = class(tPersistent)
  private
    FIdentFilter: TStrings;
    FTitleFilter: TStrings;
  protected
    function ListMatches (iList: TStrings; iSearch: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function IdentMatches (iIdent: string): boolean;
    function Matches (iIdent, iTitle: string; iMatchAll: boolean = true): boolean;
    function TitleMatches (iTitle: string): boolean;
    property IdentFilter: TStrings read FIdentFilter;
    property TitleFilter: TStrings read FTitleFilter;
  end;

  tJson2PumlFileDescriptionParameterDefinition = class(tJson2PumlBaseObject)
  private
    FDescription: string;
    FDisplayName: string;
    FMandatory: boolean;
    FName: string;
    FRegularExpression: string;
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property Description: string read FDescription write FDescription;
    property DisplayName: string read FDisplayName write FDisplayName;
    property Mandatory: boolean read FMandatory write FMandatory;
    property name: string read FName write FName;
    property RegularExpression: string read FRegularExpression write FRegularExpression;
  end;

  tJson2PumlFileDescriptionParameterList = class;

  tJson2PumlFileDescriptionParameterListEnumerator = class
  private
    FIndex: Integer;
    fParameterList: tJson2PumlFileDescriptionParameterList;
  public
    constructor Create (AParameterList: tJson2PumlFileDescriptionParameterList);
    function GetCurrent: tJson2PumlFileDescriptionParameterDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlFileDescriptionParameterDefinition read GetCurrent;
  end;

  tJson2PumlFileDescriptionParameterList = class(tJson2PumlBasePropertyList)
  private
    function GetInputParameter (Index: Integer): tJson2PumlFileDescriptionParameterDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    function GetEnumerator: tJson2PumlFileDescriptionParameterListEnumerator;
    property InputParameter[index: Integer]: tJson2PumlFileDescriptionParameterDefinition
      read GetInputParameter; default;
  end;

  tJson2PumlInputListDescriptionDefinition = class(tJson2PumlBaseObject)
  private
    FDescription: string;
    FDisplayName: string;
    FCurlParameterList: tJson2PumlFileDescriptionParameterList;
    function GetCurlParameter (Index: Integer): tJson2PumlFileDescriptionParameterDefinition;
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property CurlParameter[index: Integer]: tJson2PumlFileDescriptionParameterDefinition read GetCurlParameter;
    property CurlParameterList: tJson2PumlFileDescriptionParameterList read FCurlParameterList;
  published
    property Description: string read FDescription write FDescription;
    property DisplayName: string read FDisplayName write FDisplayName;
  end;

  tJson2PumlInputList = class;

  tJson2PumlInputListEnumerator = class
  private
    FIndex: Integer;
    fInputList: tJson2PumlInputList;
  public
    constructor Create (AInputList: tJson2PumlInputList);
    function GetCurrent: tJson2PumlInputFileDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlInputFileDefinition read GetCurrent;
  end;

  tJson2PumlInputList = class(tJson2PumlBasePropertyList)
  private
    FCurlAuthenticationList: tJson2PumlCurlAuthenticationList;
    FCurlBaseUrl: string;
    FCurlOptions: string;
    FCurlParameterList: tJson2PumlCurlParameterList;
    FCurlUrlAddon: string;
    FDefinitionFileName: string;
    FDetail: string;
    FDescription: tJson2PumlInputListDescriptionDefinition;
    FFileListFileName: string;
    FGenerateDetailsStr: string;
    FGenerateSummaryStr: string;
    FGroup: string;
    FJobName: string;
    FOnCalculateOutputFileName: TJson2PumlCalculateOutputFilenameEvent;
    FOption: string;
    FOutputFormats: tJson2PumlOutputFormats;
    FOutputFormatStr: string;
    FOutputPath: string;
    FOutputSuffix: string;
    FSummaryFileName: string;
    FSummaryZipFileName: string;
    function GetCurlBaseUrlDecoded: string;
    function GetExecuteCount: Integer;
    function GetExistsCount: Integer;
    function GetGenerateDetails: boolean;
    function GetGenerateSummary: boolean;
    function GetInputFile (Index: Integer): tJson2PumlInputFileDefinition;
    function GetOutputPathExpanded: string;
    function GetSummaryInputFile: tJson2PumlInputFileDefinition;
    procedure SetCurlAuthenticationList (const Value: tJson2PumlCurlAuthenticationList);
    procedure SetCurlParameterList (const Value: tJson2PumlCurlParameterList);
    procedure SetOutputFormatStr (const Value: string);
    procedure SetOutputPath (const Value: string);
    procedure SetOutputSuffix (const Value: string);
  protected
    function CalculateOutputFileName (iFileName, iSourceFileName: string): string;
    function ExpandInputListCurlFile (iCurrentInputFile: tJson2PumlInputFileDefinition): boolean;
    function ExpandInputListSplitFile (iInputFile: tJson2PumlInputFileDefinition): boolean;
    function GetIsValid: boolean; override;
    property OnCalculateOutputFileName: TJson2PumlCalculateOutputFilenameEvent read FOnCalculateOutputFileName;
  public
    constructor Create (iOnCalculateOutputFileName: TJson2PumlCalculateOutputFilenameEvent); reintroduce;
    destructor Destroy; override;
    procedure AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
    function AddInputFile (const iInputFileName, iOutputFileName, iLeadingObject, iSplitInputFileStr, iSplitIdentifier,
      iCurlCommand: string; iIsSplitFile, iIsSummaryFile, iIsGenerated, iGenerateOutput: boolean)
      : tJson2PumlInputFileDefinition; overload;
    function AddInputFile (const iInputFileName, iOutputFileName, iLeadingObject, iSplitInputFileStr, iSplitIdentifier,
      iCurlBaseUrl, iCurlUrl, iCurlOptions, iCurlFileNameSuffix: string; iCurlCache: Integer;
      iCurlFormatOutputStr: string; iGenerateOutput: boolean): tJson2PumlInputFileDefinition; overload;
    procedure AddSummaryFile (const iFileName: string);
    procedure Clear; override;
    procedure DeleteGeneratedFiles (const iOutputDir: string);
    procedure ExpandInputList;
    procedure GenerateSummaryZipfile (iZipfileName: string);
    function GetEnumerator: tJson2PumlInputListEnumerator;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonOutputFiles (iFileName: string; iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonOutputFiles (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceResult (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iOutputFormats: tJson2PumlOutputFormats; iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceResult (oJsonOutPut: TStrings; iOutputFormats: tJson2PumlOutputFormats;
      iWriteEmpty: boolean = false); overload;
    procedure WriteToJsonServiceListResult (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); overload;
    property CurlBaseUrlDecoded: string read GetCurlBaseUrlDecoded;
    property CurlAuthenticationList: tJson2PumlCurlAuthenticationList read FCurlAuthenticationList
      write SetCurlAuthenticationList;
    property CurlParameterList: tJson2PumlCurlParameterList read FCurlParameterList write SetCurlParameterList;
    property ExecuteCount: Integer read GetExecuteCount;
    property ExistsCount: Integer read GetExistsCount;
    property FileListFileName: string read FFileListFileName write FFileListFileName;
    property InputFile[index: Integer]: tJson2PumlInputFileDefinition read GetInputFile; default;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
    property OutputPathExpanded: string read GetOutputPathExpanded;
    property SummaryInputFile: tJson2PumlInputFileDefinition read GetSummaryInputFile;
    property SummaryZipFileName: string read FSummaryZipFileName write FSummaryZipFileName;
  published
    property CurlBaseUrl: string read FCurlBaseUrl write FCurlBaseUrl;
    property CurlOptions: string read FCurlOptions write FCurlOptions;
    property CurlUrlAddon: string read FCurlUrlAddon write FCurlUrlAddon;
    property DefinitionFileName: string read FDefinitionFileName write FDefinitionFileName;
    property Description: tJson2PumlInputListDescriptionDefinition read FDescription;
    property Detail: string read FDetail write FDetail;
    property GenerateDetails: boolean read GetGenerateDetails;
    property GenerateDetailsStr: string read FGenerateDetailsStr write FGenerateDetailsStr;
    property GenerateSummary: boolean read GetGenerateSummary;
    property GenerateSummaryStr: string read FGenerateSummaryStr write FGenerateSummaryStr;
    property Group: string read FGroup write FGroup;
    property JobName: string read FJobName write FJobName;
    property Option: string read FOption write FOption;
    property OutputFormatStr: string read FOutputFormatStr write SetOutputFormatStr;
    property OutputPath: string read FOutputPath write SetOutputPath;
    property OutputSuffix: string read FOutputSuffix write SetOutputSuffix;
    property SummaryFileName: string read FSummaryFileName write FSummaryFileName;
  end;

  tJson2PumlCommandLineParameter = class(tPersistent)
  private
    FBaseOutputPath: string;
    FConfigurationFileName: string;
    FConfigurationFileNameEnvironment: string;
    FCurlAuthenticationFileName: string;
    FCurlAuthenticationFileNameEnvironment: string;
    FCurlParameter: tJson2PumlCurlParameterList;
    FCurlParameterFileName: string;
    FDebug: boolean;
    FDefinitionFileName: string;
    FDefinitionFileNameEnvironment: string;
    FDetail: string;
    FFailed: boolean;
    FFormatDefinitionFiles: boolean;
    FGenerateDetailsStr: string;
    FGenerateOutputDefinition: boolean;
    FGenerateSummaryStr: string;
    FGroup: string;
    FIdentFilter: string;
    FInputFileName: string;
    FInputFilterList: tJson2PumlFilterList;
    FInputListFileName: string;
    FJavaRuntimeParameter: string;
    FJobName: string;
    FLeadingObject: string;
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
    procedure SetTitleFilter (const Value: string);
  strict protected
  protected
    function ExistsSingleInputParameter (iParameterName: string): boolean;
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
    procedure LogLineWrapped (iParameter, iDescription: string; iParameterLength: Integer = 50;
      iLineLength: Integer = 110);
    procedure ReadInputParameter;
    procedure WriteHelpLine (iParameter: string = ''; iDescription: string = ''; iParameterLength: Integer = 30;
      iLineLength: Integer = 110);
    procedure WriteHelpScreen;
    property CurlParameter: tJson2PumlCurlParameterList read FCurlParameter;
    property GenerateSummary: boolean read GetGenerateSummary;
    property InputFilterList: tJson2PumlFilterList read FInputFilterList;
    property OpenOutputs: tJson2PumlOutputFormats read FOpenOutputs;
    property OutputFormats: tJson2PumlOutputFormats read FOutputFormats;
    property SplitInputFile: boolean read GetSplitInputFile;
  published
    property BaseOutputPath: string read FBaseOutputPath write FBaseOutputPath;
    property ConfigurationFileName: string read FConfigurationFileName write FConfigurationFileName;
    property ConfigurationFileNameEnvironment: string read FConfigurationFileNameEnvironment
      write FConfigurationFileNameEnvironment;
    property CurlAuthenticationFileName: string read FCurlAuthenticationFileName write FCurlAuthenticationFileName;
    property CurlAuthenticationFileNameEnvironment: string read FCurlAuthenticationFileNameEnvironment
      write FCurlAuthenticationFileNameEnvironment;
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
    property JobName: string read FJobName write FJobName;
    property LeadingObject: string read FLeadingObject write FLeadingObject;
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
    property SplitIdentifier: string read FSplitIdentifier write FSplitIdentifier;
    property SplitInputFileStr: string read FSplitInputFileStr write FSplitInputFileStr;
    property SummaryFileName: string read FSummaryFileName write FSummaryFileName;
    property TitleFilter: string read FTitleFilter write SetTitleFilter;
  end;

  tJson2PumlCurlParameterDefinition = class(tJson2PumlBaseObject)
  private
    FMaxValues: Integer;
    FMulitpleValues: boolean;
    FName: string;
    FValue: string;
    function GetValueDecoded: string;
    procedure SetName (const Value: string);
  protected
    function GetIdent: string; override;
    property MulitpleValues: boolean read FMulitpleValues write FMulitpleValues default false;
  public
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property ValueDecoded: string read GetValueDecoded;
  published
    property MaxValues: Integer read FMaxValues write FMaxValues;
    property name: string read FName write SetName;
    property Value: string read FValue write FValue;
  end;

  tJson2PumlCurlParameterEnumerator = class
  private
    FIndex: Integer;
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
    function GetParameter (Index: Integer): tJson2PumlCurlParameterDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: TJSONValue); override;
  public
    constructor Create; override;
    function AddParameter (iName, iValue: string; iMaxValues: Integer = 0): boolean; overload;
    function AddParameter (iParameter: tJson2PumlCurlParameterDefinition): boolean; overload;
    procedure AddParameter (iParameterList: tJson2PumlCurlParameterList; iNameFilter: string = ''); overload;
    procedure Clear; override;
    function GetEnumerator: tJson2PumlCurlParameterEnumerator;
    procedure GetParameterNameList (ioNameList: tStringList; const iValueString: string);
    function ParameterValueCount (iParameterName: string): Integer;
    function ReplaceParameterValues (iValueString: string): string;
    function ReplaceParameterValuesFileName (iFileName: string): string;
    property Parameter[index: Integer]: tJson2PumlCurlParameterDefinition read GetParameter; default;
  published
    property MulitpleValues: boolean read FMulitpleValues write FMulitpleValues default false;
  end;

  tJson2PumlCurlFileParameterListMatrix = class(tPersistent)
  private
    FNameList: tStringList;
    FRowList: tStringList;
    function GetRowParameterList (Index: Integer): tJson2PumlCurlParameterList;
  protected
    procedure AddRow (iParameterList: tJson2PumlCurlParameterList);
    procedure FillRows (iCurrentRow: tJson2PumlCurlParameterList; iDepth: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure FillMatrix (iParameterList: tJson2PumlCurlParameterList; iFileName: string);
    property NameList: tStringList read FNameList;
    property RowList: tStringList read FRowList;
    property RowParameterList[index: Integer]: tJson2PumlCurlParameterList read GetRowParameterList;
  end;

  tJson2PumlCurlAuthenticationDefinition = class(tJson2PumlBaseObject)
  private
    FBaseUrl: string;
    FParameter: tJson2PumlCurlParameterList;
    function GetBaseUrlDecoded: string;
    procedure SetBaseUrl (const Value: string);
  protected
    function GetIdent: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property BaseUrlDecoded: string read GetBaseUrlDecoded;
  published
    property BaseUrl: string read FBaseUrl write SetBaseUrl;
    property Parameter: tJson2PumlCurlParameterList read FParameter;
  end;

  tJson2PumlCurlAuthenticationEnumerator = class
  private
    FIndex: Integer;
    fInputList: tJson2PumlCurlAuthenticationList;
  public
    constructor Create (AInputList: tJson2PumlCurlAuthenticationList);
    function GetCurrent: tJson2PumlCurlAuthenticationDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlCurlAuthenticationDefinition read GetCurrent;
  end;

  tJson2PumlCurlAuthenticationList = class(tJson2PumlBasePropertyList)
  private
    function GetAuthentication (Index: Integer): tJson2PumlCurlAuthenticationDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    constructor Create; override;
    function AddAuthentication (iBaseUrl: string): tJson2PumlCurlAuthenticationDefinition;
    procedure Clear; override;
    function FindAuthentication (const iBaseUrl: string): tJson2PumlCurlAuthenticationDefinition;
    function GetEnumerator: tJson2PumlCurlAuthenticationEnumerator;
    property Authentication[index: Integer]: tJson2PumlCurlAuthenticationDefinition read GetAuthentication; default;
  end;

function GlobalConfigurationDefinition: tJson2PumlGlobalDefinition;
function GlobalFileDeleteHandler: tJson2PumlFileDeleteHandler;

implementation

uses
  System.SysUtils,
  System.Generics.Collections, System.Types, System.IOUtils, json2pumltools,
  System.Masks, jsontools, json2pumlconverterdefinition;

var
  IntGlobalConfiguration: tJson2PumlGlobalDefinition;
  IntGlobalFileDeleteHandler: tJson2PumlFileDeleteHandler;

function GlobalConfigurationDefinition: tJson2PumlGlobalDefinition;
begin
  Result := IntGlobalConfiguration;
end;

procedure InitializationGlobalVariables;
var
  S: string;
begin
  FindCmdLineSwitch ('configurationfile', S);
  S := S.TrimLeft (['=', ':']);
  if (not S.IsEmpty) and FileExists (S) then
  else
    S := GetEnvironmentVariable (cConfigurationFileRegistry);

  IntGlobalConfiguration := tJson2PumlGlobalDefinition.Create;
  if (not S.IsEmpty) and FileExists (S) then
    IntGlobalConfiguration.ReadFromJsonFile (GetEnvironmentVariable(cConfigurationFileRegistry));
  IntGlobalFileDeleteHandler := tJson2PumlFileDeleteHandler.Create;
end;

procedure FinalizationGlobalVariables;
begin
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
  FIsGenerated := false;
  FIsConverted := false;
end;

destructor tJson2PumlInputFileDefinition.Destroy;
begin
  FOutput.Free;
  FCurlOutputParameter.Free;
  inherited Destroy;
end;

procedure tJson2PumlInputFileDefinition.AddFilesToZipFile (iZipFile: TZipFile; iRemoveDirectory: string);
begin
  if IsGenerated then
  begin
    iZipFile.Add (OutputFileName, OutputFileName.Replace(iRemoveDirectory, '').TrimLeft(TPath.DirectorySeparatorChar));
    Output.AddFilesToZipFile (iZipFile, iRemoveDirectory);
  end;
end;

procedure tJson2PumlInputFileDefinition.AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
begin
  if IsGenerated and not OutputFileName.IsEmpty then
    ioDeleteHandler.AddFile (OutputFileName);
  Output.AddGeneratedFilesToDeleteHandler (ioDeleteHandler);
end;

procedure tJson2PumlInputFileDefinition.DeleteGeneratedFiles;

  procedure DeleteSingleFile (iFileName: string);
  begin
    if not iFileName.IsEmpty then
      try
        TFile.Delete (iFileName);
        GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Warn ('Deleting of file "%s" failed. (%s)', [iFileName, e.Message]);
      end;
  end;

begin
  if IsGenerated then
    DeleteSingleFile (OutputFileName);
  Output.DeleteGeneratedFiles;
end;

procedure tJson2PumlInputFileDefinition.ExpandFileNameWithCurlParameter (iCurlParameterList
  : tJson2PumlCurlParameterList);
begin
  if Assigned (iCurlParameterList) then
    OutputFileName := iCurlParameterList.ReplaceParameterValuesFileName (OutputFileName);
end;

function tJson2PumlInputFileDefinition.GetCurlBaseUrlDecoded: string;
begin
  Result := ReplaceValueFromEnvironment (CurlBaseUrl);
end;

function tJson2PumlInputFileDefinition.GetCurlFormatOutput: boolean;
begin
  Result := StringToBoolean (CurlFormatOutputStr, false);
end;

procedure tJson2PumlInputFileDefinition.GetCurlParameterFromFile (iCurlOutputParameter,
  iCurlParameterList: tJson2PumlCurlParameterList);
var
  FileContent: tStringList;
  jValue: TJSONValue;
  CurlParameter: tJson2PumlCurlParameterDefinition;
  ValueList: tStringList;
  i: Integer;
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
    jValue := TJSONObject.ParseJSONValue (FileContent.Text);
    if not Assigned (jValue) then
      exit;
    for CurlParameter in iCurlOutputParameter do
    begin
      if CurlParameter.Value.Trim.IsEmpty then
        Continue;
      GetJsonStringValueList (ValueList, jValue, CurlParameter.Value);
      GlobalLoghandler.Info ('    Fetched Parameter "%s" : Value "%s" (%d)', [CurlParameter.name, CurlParameter.Value,
        ValueList.Count]);
      for i := 0 to ValueList.Count - 1 do
      begin
        if (CurlParameter.MaxValues > 0) and (iCurlParameterList.ParameterValueCount(CurlParameter.name) >=
          CurlParameter.MaxValues) then
          GlobalLoghandler.Info ('      Parameter "%s"(%d) : Value "%s" skipped', [CurlParameter.name, i, ValueList[i]])
        else if iCurlParameterList.AddParameter (CurlParameter.name, ValueList[i]) then
          GlobalLoghandler.Info ('      Parameter "%s"(%d) : Value "%s" found', [CurlParameter.name, i, ValueList[i]]);
      end;
    end;
  finally
    ValueList.Free;
    FileContent.Free;
  end;
end;

function tJson2PumlInputFileDefinition.GetExists: boolean;
begin
  Result := FileExists (OutputFileName);
end;

function tJson2PumlInputFileDefinition.GetExtractedOutputFileName: string;
begin
  Result := ExtractFileName (OutputFileName);
end;

function tJson2PumlInputFileDefinition.GetIdent: string;
begin
  Result := Format ('%s-%s', [LeadingObject.ToLower, InputFileName]);
end;

function tJson2PumlInputFileDefinition.GetInputFileNameExpanded: string;
begin
  Result := GetFileNameExpanded (InputFileName);
end;

function tJson2PumlInputFileDefinition.GetIsSplitFile: boolean;
begin
  Result := Output.IsSummaryFile;
end;

function tJson2PumlInputFileDefinition.GetIsSummaryFile: boolean;
begin
  Result := Output.IsSummaryFile;
end;

function tJson2PumlInputFileDefinition.GetSplitInputFile: boolean;
begin
  Result := StringToBoolean (SplitInputFileStr, false);
end;

function tJson2PumlInputFileDefinition.HandleCurl (const iBaseUrl: string; iUrlAddon: string; const iOptions: string;
  iExecuteCurlParameterList, ioResultCurlParameterList: tJson2PumlCurlParameterList): boolean;
var
  BaseUrl: string;
  FullUrl: string;
begin
  Result := false;
  if not HasValidCurl then
    exit;
  if CurlBaseUrl.Trim.IsEmpty then
    BaseUrl := iBaseUrl
  else
    BaseUrl := CurlBaseUrlDecoded;
  FullUrl := tCurlUtils.FullUrl (BaseUrl, CurlUrl.Trim + iUrlAddon.Trim, iExecuteCurlParameterList,
    ioResultCurlParameterList);
  ExpandFileNameWithCurlParameter (iExecuteCurlParameterList);
  ExpandFileNameWithCurlParameter (ioResultCurlParameterList);
  CurlCommand := tCurlUtils.CalculateCommand (FullUrl, iOptions.Trim + ' ' + CurlOptions.Trim, OutputFileName,
    iExecuteCurlParameterList, ioResultCurlParameterList);
  if tCurlUtils.Execute (BaseUrl, CurlUrl.Trim + iUrlAddon.Trim, iOptions.Trim + ' ' + CurlOptions.Trim, OutputFileName,
    CurlAuthenticationList, iExecuteCurlParameterList, ioResultCurlParameterList, CurlCache) then
  begin
    Result := true;
    if CurlFormatOutput then
      FormatJsonFile (OutputFileName);
    GetCurlParameterFromFile (CurlOutputParameter, ioResultCurlParameterList);
  end;
end;

function tJson2PumlInputFileDefinition.HasValidCurl: boolean;
begin
  Result := not (CurlBaseUrl + CurlUrl).Trim.IsEmpty;
end;

procedure tJson2PumlInputFileDefinition.SetCurlFormatOutputStr (const Value: string);
begin
  FCurlFormatOutputStr := ValidateBooleanInput (Value);
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

procedure tJson2PumlInputFileDefinition.SetSplitInputFileStr (const Value: string);
begin
  FSplitInputFileStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlInputFileDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  if not Original then
    exit;
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'inputFile', InputFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlFileSuffix', CurlFileNameSuffix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlBaseUrl', CurlBaseUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlFormatOutput', CurlFormatOutputStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUrl', CurlUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlOptions', CurlOptions, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlCache', CurlCache.ToString, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'splitIdentifier', SplitIdentifier, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'splitInputFile', SplitInputFileStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'leadingObject', LeadingObject, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateOutput', GenerateOutput, iLevel + 1);
  CurlOutputParameter.WriteToJson (oJsonOutPut, 'curlOutputParameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputFileDefinition.WriteToJsonOutputFile (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'file', InputFileName, iLevel + 1, iWriteEmpty);
  if not CurlCommand.IsEmpty then
    WriteToJsonValue (oJsonOutPut, 'curlCommand', Format('%s %s', ['curl', CurlCommand]), iLevel + 1, iWriteEmpty);
  Output.WriteToJson (oJsonOutPut, 'outputFiles', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputFileDefinition.WriteToJsonServiceResult (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iOutputFormats: tJson2PumlOutputFormats; iWriteEmpty: boolean = false);
  procedure WriteFile (iOutputFormat: tJson2PumlOutputFormat; iFileName: string);
  begin
    if not (iOutputFormat in iOutputFormats) then
      exit;
    if iFileName.IsEmpty then
      exit;
    if not FileExists (iFileName) then
      exit;
    WriteObjectStartToJson (oJsonOutPut, iLevel + 1, iOutputFormat.ServiceResultName);
    WriteToJsonValue (oJsonOutPut, 'outputFileName', ExtractFileName(iFileName), iLevel + 2, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'fullFileName', iFileName, iLevel + 2, iWriteEmpty);
    WriteToJsonValue (oJsonOutPut, 'content', ConvertFileToBase64(iFileName), iLevel + 2, iWriteEmpty);
    WriteObjectEndToJson (oJsonOutPut, iLevel + 1);
  end;

begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'source', ExtractFileName(InputFileName), iLevel + 1, iWriteEmpty);
  if not CurlCommand.IsEmpty then
    WriteToJsonValue (oJsonOutPut, 'curlCommand', Format('%s %s', ['curl', CurlCommand]), iLevel + 1, iWriteEmpty);
  WriteFile (jofJSON, InputFileName);
  WriteFile (jofSVG, Output.SVGFileName);
  WriteFile (jofPNG, Output.PNGFileName);
  WriteFile (jofPDF, Output.PDFFilename);
  WriteFile (jofPUML, Output.PUmlFileName);
  WriteFile (jofLog, Output.ConverterLogFileName);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlInputList.Create (iOnCalculateOutputFileName: TJson2PumlCalculateOutputFilenameEvent);
begin
  inherited Create;
  FOnCalculateOutputFileName := iOnCalculateOutputFileName;
  FDescription := tJson2PumlInputListDescriptionDefinition.Create ();
end;

destructor tJson2PumlInputList.Destroy;
begin
  FDescription.Free;
  inherited Destroy;
end;

procedure tJson2PumlInputList.AddGeneratedFilesToDeleteHandler (ioDeleteHandler: tJson2PumlFileDeleteHandler);
var
  InputFile: tJson2PumlInputFileDefinition;
begin
  for InputFile in self do
    InputFile.AddGeneratedFilesToDeleteHandler (ioDeleteHandler);
  ioDeleteHandler.AddFile (SummaryZipFileName);
end;

function tJson2PumlInputList.AddInputFile (const iInputFileName, iOutputFileName, iLeadingObject, iSplitInputFileStr,
  iSplitIdentifier, iCurlCommand: string; iIsSplitFile, iIsSummaryFile, iIsGenerated, iGenerateOutput: boolean)
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
  NewInputFile.SplitInputFileStr := iSplitInputFileStr;
  NewInputFile.SplitIdentifier := iSplitIdentifier;
  NewInputFile.CurlBaseUrl := '';
  NewInputFile.CurlUrl := '';
  NewInputFile.CurlFileNameSuffix := '';
  NewInputFile.CurlFormatOutputStr := '';
  NewInputFile.CurlOptions := '';
  NewInputFile.CurlCache := 0;
  NewInputFile.Original := false;
  NewInputFile.CurlAuthenticationList := CurlAuthenticationList;
  NewInputFile.GenerateOutput := iGenerateOutput;
  NewInputFile.CurlCommand := iCurlCommand;
  NewInputFile.IsGenerated := iIsGenerated;
  NewInputFile.IsSplitFile := iIsSplitFile;
  NewInputFile.IsSummaryFile := iIsSummaryFile;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

function tJson2PumlInputList.AddInputFile (const iInputFileName, iOutputFileName, iLeadingObject, iSplitInputFileStr,
  iSplitIdentifier, iCurlBaseUrl, iCurlUrl, iCurlOptions, iCurlFileNameSuffix: string; iCurlCache: Integer;
  iCurlFormatOutputStr: string; iGenerateOutput: boolean): tJson2PumlInputFileDefinition;
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
  NewInputFile.SplitInputFileStr := iSplitInputFileStr;
  NewInputFile.SplitIdentifier := iSplitIdentifier;
  NewInputFile.CurlBaseUrl := iCurlBaseUrl;
  NewInputFile.CurlUrl := iCurlUrl;
  NewInputFile.CurlFileNameSuffix := iCurlFileNameSuffix;
  NewInputFile.CurlFormatOutputStr := iCurlFormatOutputStr;
  NewInputFile.CurlOptions := iCurlOptions;
  NewInputFile.CurlCache := iCurlCache;
  NewInputFile.Original := true;
  NewInputFile.CurlAuthenticationList := CurlAuthenticationList;
  NewInputFile.GenerateOutput := iGenerateOutput;
  NewInputFile.IsGenerated := false;
  NewInputFile.IsSplitFile := false;
  NewInputFile.IsSummaryFile := false;
  AddBaseObject (NewInputFile);
  Result := NewInputFile;
end;

procedure tJson2PumlInputList.AddSummaryFile (const iFileName: string);
var
  InputFile: tJson2PumlInputFileDefinition;
  FileDefinition: tJson2PumlInputFileDefinition;
begin
  FileDefinition := AddInputFile (iFileName, iFileName, '', '', '', '', false, true, true, true);
  for InputFile in self do
  begin
    if not InputFile.GenerateOutput then
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
  GenerateDetailsStr := '';
  GenerateSummaryStr := '';
  SummaryZipFileName := '';
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
        GlobalLoghandler.Debug ('Directory "%s" deleted."', [iOutputDir]);
      except
        on e: exception do
          GlobalLoghandler.Warn ('Deleting of directory "%s" failed. (%s)', [iOutputDir, e.Message]);
      end;
end;

procedure tJson2PumlInputList.ExpandInputList;
var
  InputFile: tJson2PumlInputFileDefinition;
  searchResult: TSearchRec;
  FileName: string;
  NewPath: string;
begin
  for InputFile in self do
  begin
    if not InputFile.Original then
      Continue;
    if ExpandInputListCurlFile (InputFile) then
      Continue;
    if InputFile.Exists then
    begin
      if InputFile.Original then
        GlobalLoghandler.Debug ('File "%s" (%s) found.',
          [InputFile.OutputFileName, ExpandFileName(InputFile.OutputFileName)]);
      Continue;
    end;
    FileName := CurlParameterList.ReplaceParameterValuesFileName (InputFile.InputFileNameExpanded);
    NewPath := ExtractFilePath (FileName);
    if findfirst (FileName, faAnyFile, searchResult) = 0 then
    begin
      InputFile.GenerateOutput := false;
      repeat
        if NewPath.IsEmpty then
          FileName := searchResult.name
        else
          FileName := ChangeFilePath (searchResult.name, NewPath);
        AddInputFile (FileName, FileName, InputFile.LeadingObject, InputFile.SplitInputFileStr,
          InputFile.SplitIdentifier, '', false, false, false, true);
        GlobalLoghandler.Debug ('File "%s" (%s) found.', [FileName, ExpandFileName(FileName)]);
      until FindNext (searchResult) <> 0;
      System.SysUtils.FindClose (searchResult);
    end
    else
      GlobalLoghandler.Warn ('File "%s" (%s) not found.', [FileName, ExpandFileName(FileName)]);
  end;
  for InputFile in self do
  begin
    if not InputFile.GenerateOutput then
      Continue;
    if not InputFile.Exists then
      Continue;
    if not InputFile.SplitInputFile then
      Continue;
    ExpandInputListSplitFile (InputFile);
  end;
end;

function tJson2PumlInputList.ExpandInputListCurlFile (iCurrentInputFile: tJson2PumlInputFileDefinition): boolean;
var
  CurlParameterMatrix: tJson2PumlCurlFileParameterListMatrix;
  SaveFileName: string;
  i: Integer;
  Generated: boolean;
begin
  Result := false;
  if not iCurrentInputFile.HasValidCurl then
    exit;
  Result := true;
  CurlParameterMatrix := tJson2PumlCurlFileParameterListMatrix.Create;
  try
    CurlParameterMatrix.FillMatrix (CurlParameterList, iCurrentInputFile.InputFileName +
      iCurrentInputFile.CurlFileNameSuffix);
    if CurlParameterMatrix.RowList.Count > 0 then
    begin
      iCurrentInputFile.GenerateOutput := false;
      for i := 0 to CurlParameterMatrix.RowList.Count - 1 do
      begin
        SaveFileName := iCurrentInputFile.OutputFileName;
        Generated := iCurrentInputFile.HandleCurl (CurlBaseUrlDecoded, CurlUrlAddon, CurlOptions,
          CurlParameterMatrix.RowParameterList[i], CurlParameterList);
        AddInputFile (iCurrentInputFile.InputFileName, iCurrentInputFile.OutputFileName,
          iCurrentInputFile.LeadingObject, iCurrentInputFile.SplitInputFileStr, iCurrentInputFile.SplitIdentifier,
          iCurrentInputFile.CurlCommand, false, false, true, Generated);
        iCurrentInputFile.OutputFileName := SaveFileName;
      end
    end
    else
    begin
      iCurrentInputFile.HandleCurl (CurlBaseUrlDecoded, CurlUrlAddon, CurlOptions, CurlParameterList,
        CurlParameterList);
      iCurrentInputFile.IsGenerated := true;
    end;
  finally
    CurlParameterMatrix.Free;
  end;
end;

function tJson2PumlInputList.ExpandInputListSplitFile (iInputFile: tJson2PumlInputFileDefinition): boolean;
var
  FileDetailNames, InputFile, OutputFile: tStringList;
  ConverterDefinition: tJson2PumlConverterDefinition;
  JsonValue: TJSONValue;
  NewFileName: string;
  JsonArray: TJSONArray;
  FileExtension: string;
  Ident: string;
  LastOption: string;
  idx, i: Integer;

  function FindSuffix (iSuffix: string): string;
  var
    i: Integer;
    S: string;
  begin
    Result := '';
    i := 0;
    repeat
      if i = 0 then
        S := iSuffix
      else
        S := Format ('%s_%d', [iSuffix, i]);
      if FileDetailNames.IndexOf (S) < 0 then
      begin
        FileDetailNames.Add (S);
        Result := S;
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
  FileDetailNames := tStringList.Create;
  InputFile := tStringList.Create;
  OutputFile := tStringList.Create;
  LastOption := '';
  ConverterDefinition := tJson2PumlConverterDefinition.Create;
  try
    InputFile.LoadFromFile (iInputFile.OutputFileName);
    JsonValue := TJSONObject.ParseJSONValue (InputFile.Text);
    if not Assigned (JsonValue) then
      exit;
    if not (JsonValue is TJSONArray) then
      exit;
    JsonArray := TJSONArray (JsonValue);
    if JsonArray.Count <= 1 then
      exit;
    GlobalLoghandler.Info ('Split file %s', [iInputFile.InputFileName]);
    iInputFile.GenerateOutput := false;
    idx := 0;
    if JsonArray.Count > 0 then
    begin
      NewFileName := CalculateOutputFileName (iInputFile.InputFileName, iInputFile.InputFileName);
      GenerateFileDirectory (NewFileName);
    end;
    for i := 0 to JsonArray.Count - 1 do
    begin
      FileExtension := TPath.GetExtension (iInputFile.InputFileName);
      Ident := '';
      if JsonArray.Items[i] is TJSONObject then
        Ident := GetJsonStringValue (TJSONObject(JsonArray.Items[i]), iInputFile.SplitIdentifier, '', '.');
      if Ident.IsEmpty then
      begin
        Inc (idx);
        Ident := Format ('split_%d', [idx]);
      end;

      NewFileName := TPath.ChangeExtension (NewFileName, FindSuffix(Ident).Substring(0, 80) + '.' + jofJSON.ToString);
      OutputFile.Text := JsonArray.Items[i].ToJSON;
      OutputFile.SaveToFile (NewFileName);
      AddInputFile (iInputFile.InputFileName, NewFileName, iInputFile.LeadingObject, '', '', '', true, false,
        true, true);
      GlobalLoghandler.Info ('  Detail file %s created', [NewFileName]);
    end;
  finally
    ConverterDefinition.Free;
    FileDetailNames.Free;
    InputFile.Free;
    OutputFile.Free;
  end;
  Result := true;

end;

procedure tJson2PumlInputList.GenerateSummaryZipfile (iZipfileName: string);
var
  InputFile: tJson2PumlInputFileDefinition;
  ZipFile: TZipFile;
begin
  SummaryZipFileName := iZipfileName;
  ZipFile := TZipFile.Create;
  try
    ZipFile.Open (iZipfileName, zmWrite);
    for InputFile in self do
    begin
      if not InputFile.Exists then
        Continue;
      InputFile.AddFilesToZipFile (ZipFile, ExtractFilePath(iZipfileName));
    end;
    ZipFile.Close;
    GlobalLoghandler.Info ('Summary Zip File %s generated.', [iZipfileName]);
  finally
    ZipFile.Free;
  end;
end;

function tJson2PumlInputList.GetCurlBaseUrlDecoded: string;
begin
  Result := ReplaceValueFromEnvironment (CurlBaseUrl);
end;

function tJson2PumlInputList.GetEnumerator: tJson2PumlInputListEnumerator;
begin
  Result := tJson2PumlInputListEnumerator.Create (self);
end;

function tJson2PumlInputList.GetExecuteCount: Integer;
var
  f: tJson2PumlInputFileDefinition;
begin
  Result := 0;
  for f in self do
    if f.Exists and f.GenerateOutput then
      Result := Result + 1;
end;

function tJson2PumlInputList.GetExistsCount: Integer;
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

function tJson2PumlInputList.GetInputFile (Index: Integer): tJson2PumlInputFileDefinition;
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

function tJson2PumlInputList.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  Definition: TJSONObject;
  InputFileRec: TJSONArray;
  Value: TJSONValue;
  i: Integer;
  SplitInputFile, SourceFileName, SplitIdentifier, FileName, LeadingObject: string;
  FileCurlBaseUrl, FileCurlUrl, FileCurlOptions, FileCurlFormatOutput, FileCurlFilenameSuffix: string;
  FileCurlCache: Integer;
  GenerateOutput: boolean;
  InputFile: tJson2PumlInputFileDefinition;
begin
  Result := false;
  Clear;
  if not (iJsonValue is TJSONObject) then
    exit;
  Definition := GetJsonObject (TJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  DefinitionFileName := GetJsonStringValue (Definition, 'definitionFile');
  Description.ReadFromJson (Definition, 'description');
  Detail := GetJsonStringValue (Definition, 'detail');
  Group := GetJsonStringValue (Definition, 'group');
  Option := GetJsonStringValue (Definition, 'option');
  JobName := GetJsonStringValue (Definition, 'job');
  FOutputFormats := OutputFormatsFromString (GetJsonStringArray(Definition, 'outputFormats'));
  OutputPath := GetJsonStringValue (Definition, 'outputPath');
  OutputSuffix := GetJsonStringValue (Definition, 'outputSuffix');
  CurlBaseUrl := GetJsonStringValue (Definition, 'curlBaseUrl');
  CurlUrlAddon := GetJsonStringValue (Definition, 'curlUrlAddon');
  CurlOptions := GetJsonStringValue (Definition, 'curlOptions');
  GenerateDetailsStr := GetJsonStringValueBoolean (Definition, 'generateDetails', '');
  GenerateSummaryStr := GetJsonStringValueBoolean (Definition, 'generateSummary', '');
  SummaryFileName := GetJsonStringValue (Definition, 'summaryFile');
  Value := Definition.Values['input'];
  if Value is TJSONArray then
  begin
    InputFileRec := TJSONArray (Value);
    for i := 0 to InputFileRec.Count - 1 do
    begin
      Value := InputFileRec.Items[i];
      if Value is TJSONObject then
      begin
        SourceFileName := GetJsonStringValue (TJSONObject(Value), 'inputFile').Trim;
        if TPath.GetExtension (SourceFileName).TrimLeft([TPath.ExtensionSeparatorChar]).IsEmpty then
          SourceFileName := TPath.ChangeExtension (SourceFileName, jofJSON.FileExtension(true));

        FileCurlFilenameSuffix := TPath.GetFileNameWithoutExtension (GetJsonStringValue(TJSONObject(Value),
          'curlFileSuffix'));
        FileName := CalculateOutputFileName (TPath.GetFileNameWithoutExtension(SourceFileName) +
          FileCurlFilenameSuffix.Trim, SourceFileName);
        if FileName.IsEmpty then
          Continue;
        LeadingObject := GetJsonStringValue (TJSONObject(Value), 'leadingObject');
        SplitInputFile := GetJsonStringValue (TJSONObject(Value), 'splitInputFile');
        SplitIdentifier := GetJsonStringValue (TJSONObject(Value), 'splitIdentifier');
        FileCurlBaseUrl := GetJsonStringValue (TJSONObject(Value), 'curlBaseUrl');
        FileCurlUrl := GetJsonStringValue (TJSONObject(Value), 'curlUrl');
        FileCurlOptions := GetJsonStringValue (TJSONObject(Value), 'curlOptions');
        FileCurlFormatOutput := GetJsonStringValue (TJSONObject(Value), 'curlFormatOutput');
        FileCurlCache := GetJsonStringValueInteger (TJSONObject(Value), 'curlCache', 0);
        GenerateOutput := GetJsonStringValueBoolean (TJSONObject(Value), 'generateOutput', true);
        InputFile := AddInputFile (SourceFileName, FileName, LeadingObject, SplitInputFile, SplitIdentifier,
          FileCurlBaseUrl, FileCurlUrl, FileCurlOptions, FileCurlFilenameSuffix, FileCurlCache, FileCurlFormatOutput,
          GenerateOutput);
        if Assigned (InputFile) then
          InputFile.CurlOutputParameter.ReadFromJson (TJSONObject(Value), 'curlOutputParameter');
      end;
    end;
  end;
  Result := Count > 0;
end;

procedure tJson2PumlInputList.SetCurlAuthenticationList (const Value: tJson2PumlCurlAuthenticationList);
var
  FileRec: tJson2PumlInputFileDefinition;
begin
  FCurlAuthenticationList := Value;
  for FileRec in self do
    FileRec.CurlAuthenticationList := Value;
end;

procedure tJson2PumlInputList.SetCurlParameterList (const Value: tJson2PumlCurlParameterList);
begin
  FCurlParameterList := Value;
end;

procedure tJson2PumlInputList.SetOutputFormatStr (const Value: string);
begin
  FOutputFormatStr := Value;
  FOutputFormats.FromString (Value, true, true);
end;

procedure tJson2PumlInputList.SetOutputPath (const Value: string);
begin
  FOutputPath := Value.Trim;
end;

procedure tJson2PumlInputList.SetOutputSuffix (const Value: string);
begin
  FOutputSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlInputList.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  S: string;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  Description.WriteToJson (oJsonOutPut, 'description', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'definitionFile', DefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateDetails', GenerateDetailsStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateSummary', GenerateSummaryStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'group', Group, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'detail', Detail, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'option', Option, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'job', JobName, iLevel + 1, iWriteEmpty);
  S := OutputFormatsToString (OutputFormats);
  if not S.IsEmpty or iWriteEmpty then
    oJsonOutPut.Add (Format('%s"%s":[%s],', [JsonLinePrefix(iLevel + 1), 'outputFormats', S.TrimRight([','])]));
  WriteToJsonValue (oJsonOutPut, 'outputPath', OutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputSuffix', OutputSuffix, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlBaseUrl', CurlBaseUrl, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlUrlAddon', CurlUrlAddon, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlOptions', CurlOptions, iLevel + 1, iWriteEmpty);
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

procedure tJson2PumlInputList.WriteToJsonOutputFiles (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  InputFile: tJson2PumlInputFileDefinition;
  Found: boolean;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'fileList', FileListFileName, iLevel + 1, iWriteEmpty);
  for InputFile in self do
  begin
    if not InputFile.IsGenerated then
      Continue;
    if not InputFile.Exists then
      Continue;
    if not InputFile.IsSummaryFile then
      Continue;
    InputFile.WriteToJsonOutputFile (oJsonOutPut, 'summaryFile', iLevel + 1, iWriteEmpty);
  end;
  Found := false;
  for InputFile in self do
  begin
    if not InputFile.IsGenerated then
      Continue;
    if not InputFile.Exists then
      Continue;
    if InputFile.IsSummaryFile then
      Continue;
    if not Found then
    begin
      WriteArrayStartToJson (oJsonOutPut, iLevel + 1, 'detailFiles');
      Found := true;
    end;
    InputFile.WriteToJsonOutputFile (oJsonOutPut, '', iLevel + 2, iWriteEmpty);
  end;
  if Found then
    WriteArrayEndToJson (oJsonOutPut, iLevel);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputList.WriteToJsonServiceResult (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iOutputFormats: tJson2PumlOutputFormats; iWriteEmpty: boolean = false);
var
  InputFile: tJson2PumlInputFileDefinition;
  Found: boolean;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  for InputFile in self do
  begin
    if not InputFile.IsGenerated then
      Continue;
    if not InputFile.IsSummaryFile then
      Continue;
    if not InputFile.Exists then
      Continue;
    InputFile.WriteToJsonServiceResult (oJsonOutPut, 'summaryFile', iLevel + 1, iOutputFormats, iWriteEmpty);
  end;
  Found := false;
  for InputFile in self do
  begin
    if not InputFile.IsGenerated then
      Continue;
    if not InputFile.Exists then
      Continue;
    if InputFile.IsSummaryFile then
      Continue;
    if not Found then
    begin
      WriteArrayStartToJson (oJsonOutPut, iLevel + 1, 'detailFiles');
      Found := true;
    end;
    InputFile.WriteToJsonServiceResult (oJsonOutPut, '', iLevel + 2, iOutputFormats, iWriteEmpty);
  end;
  if Found then
    WriteArrayEndToJson (oJsonOutPut, iLevel);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlInputList.WriteToJsonServiceResult (oJsonOutPut: TStrings; iOutputFormats: tJson2PumlOutputFormats;
  iWriteEmpty: boolean = false);
begin
  oJsonOutPut.Clear;
  WriteToJsonServiceResult (oJsonOutPut, '', 0, iOutputFormats, iWriteEmpty);
end;

procedure tJson2PumlInputList.WriteToJsonServiceListResult (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
var
  FileName: string;
  DefinitionFile: tJson2PumlConverterGroupDefinition;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', ExtractFileName(SourceFileName), iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'displayName', Description.DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description.Description, iLevel + 1, iWriteEmpty);
  if not DefinitionFileName.IsEmpty then
  begin
    FileName := GlobalConfigurationDefinition.FindFileInFolderList (DefinitionFileName,
      GlobalConfigurationDefinition.FDefaultDefinitionFileFolder);
    if FileExists (FileName) then
    begin
      DefinitionFile := tJson2PumlConverterGroupDefinition.Create;
      try
        DefinitionFile.ReadFromJsonFile (FileName);
        DefinitionFile.WriteToJsonServiceListResult (oJsonOutPut, 'definitionFile', iLevel + 1, iWriteEmpty);
      finally
        DefinitionFile.Free;
      end;
    end;
  end;
  Description.CurlParameterList.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
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

constructor tJson2PumlCommandLineParameter.Create;
begin
  inherited Create;
  Failed := false;
  FInputFilterList := tJson2PumlFilterList.Create ();
  FCurlParameter := tJson2PumlCurlParameterList.Create ();
  FCurlParameter.MulitpleValues := true;
end;

destructor tJson2PumlCommandLineParameter.Destroy;
begin
  FCurlParameter.Free;
  FInputFilterList.Free;
  inherited Destroy;
end;

function tJson2PumlCommandLineParameter.ExistsSingleInputParameter (iParameterName: string): boolean;
begin
  Result := FindCmdLineSwitch (iParameterName);
  if Result then
    LogParameterValue (iParameterName);
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

procedure tJson2PumlCommandLineParameter.LogLineWrapped (iParameter, iDescription: string;
  iParameterLength: Integer = 50; iLineLength: Integer = 110);
var
  LogLines: tStringList;
  S: string;
  l: string;
  Next: string;
  i, p: Integer;
begin
  LogLines := tStringList.Create;
  try
    LogLines.Text := iDescription;
    S := iParameter;
    for i := 0 to LogLines.Count - 1 do
    begin
      S := S.PadRight (iParameterLength);
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
        if S.length + Next.length >= iLineLength then
        begin
          GlobalLoghandler.Info (S);
          S := ' ';
          S := S.PadRight (iParameterLength);
        end;
        S := S + ' ' + Next;
      end;
      GlobalLoghandler.Info (S);
      S := '';
    end;
    if not S.IsEmpty then
      GlobalLoghandler.Info (S);
  finally
    LogLines.Free;
  end;

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
{$IFDEF MSWINDOWS}
  GlobalLoghandler.InfoParameter ('/', iParameterName.ToLower, (iParameterValue.Trim + ' ' + iParameterDetail).Trim);
{$ELSE}
  GlobalLoghandler.InfoParameter ('-', iParameterName.ToLower, (iParameterValue.Trim + ' ' + iParameterDetail).Trim);
{$ENDIF}
end;

procedure tJson2PumlCommandLineParameter.ReadCurlParameter;
var
  i: Integer;
  S: string;

  pName: string;
  pValue: string;
  p, p1, p2: Integer;
const
  ccurlparam: string = 'curlparameter';
begin
  CurlParameter.Clear;
  for i := 0 to ParamCount do
  begin
    S := ParamStr (i).Trim;
    if S.StartsWith ('/' + ccurlparam + ':', true) or S.StartsWith ('/' + ccurlparam + '=', true) or
      S.StartsWith ('-' + ccurlparam + ':', true) or S.StartsWith ('-' + ccurlparam + '=', true) then
    begin
      S := S.Substring (length(ccurlparam) + 2).DeQuotedString;
      p1 := S.IndexOf ('=');
      p2 := S.IndexOf (':');
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
        pName := S.Substring (0, p).Trim;
        pValue := S.Substring (p + 1);
      end
      else
      begin
        pName := S.Trim;
        pValue := '';
      end;
      if not pName.IsEmpty then
      begin
        CurlParameter.AddParameter (pName, pValue);
        LogParameterValue ('CurlParameter', Format('%s:%s', [pName, pValue]));
      end;
    end;
  end;
end;

procedure tJson2PumlCommandLineParameter.ReadInputParameter;
var
  S: string;
  i: Integer;
begin
  for i := 1 to ParamCount do
    S := S + ParamStr (i) + ' ';
  GlobalLoghandler.Info ('Current command line parameters: (%s)', [S]);
  // for i := 1 to ParamCount do
  // GlobalLoghandler.Debug ('  [%d]: %s', [i, ParamStr(i)]);
  ConfigurationFileName := ReadSingleInputParameterFile ('configurationfile');
  ConfigurationFileNameEnvironment := ReadSingleInputParameterEnvironment (cConfigurationFileRegistry);
  ParameterFileName := ReadSingleInputParameterFile ('parameterfile');
  DefinitionFileName := ReadSingleInputParameterFile ('definitionfile');
  DefinitionFileNameEnvironment := ReadSingleInputParameterEnvironment (cDefinitionFileRegistry);
  CurlAuthenticationFileName := ReadSingleInputParameterFile ('CurlAuthenticationfile');
  CurlAuthenticationFileNameEnvironment := ReadSingleInputParameterEnvironment (cCurlAuthenticationFileRegistry);
  CurlParameterFileName := ReadSingleInputParameterFile ('CurlParameterfile');
  InputListFileName := ReadSingleInputParameterFile ('InputListfile');
  InputFileName := ReadSingleInputParameterFile ('Inputfile');
  PlantUmlJarFileName := ReadSingleInputParameterFile ('PlantUmlJarfile');
  PlantUmlJarFileNameEnvironment := ReadSingleInputParameterEnvironment (cPlantUmlJarFileRegistry);
  JavaRuntimeParameter := ReadSingleInputParameter ('JavaRuntimeParameter');
  LeadingObject := ReadSingleInputParameter ('LeadingObject');
  SplitInputFileStr := ReadSingleInputParameter ('splitinputfile');
  SplitIdentifier := ReadSingleInputParameter ('splitidentifier');
  Group := ReadSingleInputParameter ('group');
  Detail := ReadSingleInputParameter ('detail');
  JobName := ReadSingleInputParameter ('job');
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
  GenerateOutputDefinition := ExistsSingleInputParameter ('generateoutputdefinition');
  IdentFilter := ReadSingleInputParameter ('identfilter');
  TitleFilter := ReadSingleInputParameter ('titlefilter');
  FormatDefinitionFiles := ExistsSingleInputParameter ('formatdefinitionfiles');
  SummaryFileName := ReadSingleInputParameter ('summaryfile');
  ReadCurlParameter;
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameter (iParameterName: string): string;
var
  S: string;
begin
  FindCmdLineSwitch (iParameterName, S);
  S := S.TrimLeft (['=', ':']);
  Result := S;
  LogParameterValue (iParameterName, S);
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameterEnvironment (iParameterName: string): string;
var
  S: string;
begin
  S := GetEnvironmentVariable (iParameterName);
  ValidateFileInputParameter ('Env ' + iParameterName, S);
  Result := S;
end;

function tJson2PumlCommandLineParameter.ReadSingleInputParameterFile (iParameterName: string): string;
var
  S: string;
begin
  FindCmdLineSwitch (iParameterName, S);
  S := S.TrimLeft (['=', ':']);
  ValidateFileInputParameter (iParameterName, S);
  Result := S;
end;

procedure tJson2PumlCommandLineParameter.SetIdentFilter (const Value: string);
begin
  FIdentFilter := Value;
  InputFilterList.IdentFilter.Text := Value;
end;

procedure tJson2PumlCommandLineParameter.SetOpenOutputsStr (const Value: string);
var
  TempList: tStringList;
  S: string;
  f: tJson2PumlOutputFormat;
begin
  FOpenOutputsStr := Value;
  FOpenOutputs := [];
  TempList := tStringList.Create;
  try
    TempList.LineBreak := ',';
    TempList.Text := Value.ToLower;
    for S in TempList do
      for f := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
        if (S.Trim = f.ToString) or (S.Trim = cOpenOutputAll) then
          FOpenOutputs := FOpenOutputs + [f];
  finally
    TempList.Free;
  end;

end;

procedure tJson2PumlCommandLineParameter.SetOutputFormatStr (const Value: string);
begin
  FOutputFormatStr := Value;
  FOutputFormats.FromString (Value, true, true);
end;

procedure tJson2PumlCommandLineParameter.SetOutputSuffix (const Value: string);
begin
  FOutputSuffix := ValidateOutputSuffix (Value);
end;

procedure tJson2PumlCommandLineParameter.SetTitleFilter (const Value: string);
begin
  FTitleFilter := Value;
  InputFilterList.TitleFilter.Text := Value;
end;

procedure tJson2PumlCommandLineParameter.ValidateFileInputParameter (iParameterName: string;
  var ioParameterValue: string);
var
  Fc: Integer;
begin
  iParameterName := iParameterName.ToLower.Trim;
  Fc := FileCount (ExpandFileName(ioParameterValue));
  if Fc > 1 then
    LogParameterValue (iParameterName, ioParameterValue, Format('(%d files found)', [Fc]))
  else
    LogParameterValue (iParameterName, ioParameterValue);
  if (not ioParameterValue.IsEmpty) and (Fc <= 0) then
  begin
    GlobalLoghandler.Warn ('/%s File "%s" does not exist', [iParameterName.ToLower.Trim.PadRight(29),
      ioParameterValue.Trim]);
    ioParameterValue := '';
  end;
end;

procedure tJson2PumlCommandLineParameter.WriteHelpLine (iParameter: string = ''; iDescription: string = '';
  iParameterLength: Integer = 30; iLineLength: Integer = 110);
begin
  if iParameter.IsEmpty then
    GlobalLoghandler.Info ('')
  else
{$IFDEF MSWINDOWS}
    LogLineWrapped ('/' + iParameter.ToLower, iDescription, iParameterLength, iLineLength)
{$ELSE}
      LogLineWrapped('-' + iParameter.ToLower, iDescription, iParameterLength, iLineLength)
{$ENDIF}
end;

procedure tJson2PumlCommandLineParameter.WriteHelpScreen;
var
  S: string;
  f: tJson2PumlOutputFormat;
begin
  WriteHelpLine;
  WriteHelpLine ('?', 'Showing this Help screen');
  WriteHelpLine ('plantumljarfile:<file>      ',
    'Plantuml Jar file which should be used to generate the sample images. ' +
    'If defined this parameter overwrites the corresponding parameter in the definition file');
  WriteHelpLine ('javaruntimeparameter:<param>',
    'Additional parameter which will be added to the java call when calling the PlantUML jar file ' +
    'to generate the output formats.');
  WriteHelpLine;
  WriteHelpLine ('configurationfile:<file>', 'Global base configuration of json2puml. Overwrites the "' +
    cConfigurationFileRegistry + '" environment parameter.');
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
  S := '';
  for f := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
    if f.IsPumlOutput then
      S := string.Join (',', [S, f.ToString]);
  WriteHelpLine ('outputformat:<format>', Format('Format of the generated Puml converters (Allowed values: %s) ', [S]));
  S := string.Join (',', [S, jofPUML.ToString]);
  S := string.Join (',', [S, jofZip.ToString]);
  WriteHelpLine ('openoutput:[<format>]',
    Format('Flag to define if the generated files should be opened after the generation.' + #13#10 +
    'The files will be opened using the default program to handle the file format. ' + #13#10 +
    'Optional the files to be opened can be restricted by the format types (Allowed values: %s) ', [S]));
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
  WriteHelpLine ('debug', 'Flag to define that a converter log file should be generated parallel to the puml file');
  WriteHelpLine;
end;

constructor tJson2PumlGlobalDefinition.Create;
begin
  inherited Create;
  FDefaultInputListFileFolder := tStringList.Create ();
  FDefaultInputListFileFolder.Delimiter := ';';
  FDefaultInputListFileFolder.StrictDelimiter := true;
  FDefaultDefinitionFileFolder := tStringList.Create ();
  FDefaultDefinitionFileFolder.Delimiter := ';';
  FDefaultDefinitionFileFolder.StrictDelimiter := true;
  FServicePort := 8080;
end;

destructor tJson2PumlGlobalDefinition.Destroy;
begin
  FDefaultDefinitionFileFolder.Free;
  FDefaultInputListFileFolder.Free;
  inherited Destroy;
end;

procedure tJson2PumlGlobalDefinition.Clear;
begin
  PlantUmlJarFileName := '';
  FDefaultDefinitionFileFolder.Clear;
  FDefaultInputListFileFolder.Clear;
  DefaultDefinitionFileName := '';
  CurlAuthenticationFileName := '';
end;

function tJson2PumlGlobalDefinition.FindDefinitionFile (iFileName: string): string;
begin
  Result := FindFileInFolderList (iFileName, DefaultDefinitionFileFolder);
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
  S: string;
  Filter: string;
  searchResult: TSearchRec;
  FilePath: string;
begin
  ioFileList.Clear;
  for S in iFolderList do
  begin
    if iFilter.IsEmpty then
      Filter := ExtractFileName (S)
    else
      Filter := ExtractFileName (iFilter);
    if Filter.IsEmpty then
      Filter := cDefaultJsonFileFilter;
    FilePath := ExtractFilePath (S);
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
  Result := FindFileInFolderList (iFileName, DefaultInputListFileFolder);
  // TODO -cMM: tJson2PumlGlobalDefinition.FindInputListFile default body inserted
end;

function tJson2PumlGlobalDefinition.GetIdent: string;
begin
  Result := '';
end;

procedure tJson2PumlGlobalDefinition.LogConfiguration;
var
  i: Integer;
begin
  GlobalLoghandler.Trace ('Global Configuration (%s)', [SourceFileName]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['BaseOutputPath', BaseOutputPath]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['CurlAuthenticationFileName', CurlAuthenticationFileName]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['DefaultDefinitionFileName', DefaultDefinitionFileName]);
  GlobalLoghandler.Trace ('  %-30s: ', ['DefaultDefinitionFileFolder']);
  for i := 0 to DefaultDefinitionFileFolder.Count - 1 do
    GlobalLoghandler.Trace ('  %-30s: %s', [Format('  [%d]', [i + 1]), DefaultDefinitionFileFolder[i]]);
  GlobalLoghandler.Trace ('  %-30s: ', ['DefaultInputListFileFolder']);
  for i := 0 to DefaultInputListFileFolder.Count - 1 do
    GlobalLoghandler.Trace ('  %-30s: %s', [Format('  [%d]', [i + 1]), DefaultInputListFileFolder[i]]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['JavaRuntimeParameter', JavaRuntimeParameter]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['LogFileOutputPath', LogFileOutputPath]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['OutputPath', OutputPath]);
  GlobalLoghandler.Trace ('  %-30s: %s', ['PlantUmlJarFileName', PlantUmlJarFileName]);
  GlobalLoghandler.Trace ('  %-30s: %d', ['ServicePort', ServicePort]);
end;

function tJson2PumlGlobalDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Result := true;
  CurlAuthenticationFileName := GetJsonStringValue (DefinitionRecord, 'curlAuthenticationFileName',
    CurlAuthenticationFileName);
  DefaultDefinitionFileName := GetJsonStringValue (DefinitionRecord, 'defaultDefinitionFileName',
    DefaultDefinitionFileName);
  GetJsonStringValueList (DefaultDefinitionFileFolder, DefinitionRecord, 'defaultDefinitionFileFolder');
  GetJsonStringValueList (DefaultInputListFileFolder, DefinitionRecord, 'defaultInputListFileFolder');
  JavaRuntimeParameter := GetJsonStringValue (DefinitionRecord, 'javaRuntimeParameter', PlantUmlJarFileName);
  LogFileOutputPath := GetJsonStringValue (DefinitionRecord, 'logFileOutputPath', PlantUmlJarFileName);
  PlantUmlJarFileName := GetJsonStringValue (DefinitionRecord, 'plantUmlJarFileName', PlantUmlJarFileName);
  BaseOutputPath := GetJsonStringValue (DefinitionRecord, 'baseOutputPath', BaseOutputPath);
  OutputPath := GetJsonStringValue (DefinitionRecord, 'outputPath', BaseOutputPath);
  ServicePort := GetJsonStringValueInteger (DefinitionRecord, 'servicePort', ServicePort);
end;

procedure tJson2PumlGlobalDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'baseOutputPath', BaseOutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputPath', OutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'curlAuthenticationFileName', CurlAuthenticationFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaultDefinitionFileName', DefaultDefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaulDefinitionFileFolder', DefaultDefinitionFileFolder, iLevel + 1, false,
    iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaultInputListFileFolder', DefaultInputListFileFolder, iLevel + 1, false,
    iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'javaRuntimeParameter', JavaRuntimeParameter, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'logFileOutputPath', LogFileOutputPath, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'plantUmlJarFileName', PlantUmlJarFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'servicePort', ServicePort, iLevel + 1);
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

function tJson2PumlFilterList.ListMatches (iList: TStrings; iSearch: string): boolean;
var
  S: string;
begin
  if iList.Count <= 0 then
  begin
    Result := true;
    exit;
  end;
  Result := false;
  for S in iList do
    if MatchesMask (iSearch, S) then
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
  FParameter := tJson2PumlCurlParameterList.Create ();
end;

destructor tJson2PumlCurlAuthenticationDefinition.Destroy;
begin
  FParameter.Free;
  inherited Destroy;
end;

function tJson2PumlCurlAuthenticationDefinition.GetBaseUrlDecoded: string;
begin
  Result := ReplaceValueFromEnvironment (BaseUrl);
end;

function tJson2PumlCurlAuthenticationDefinition.GetIdent: string;
begin
  Result := Format ('%s', [BaseUrl]);
end;

function tJson2PumlCurlAuthenticationDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
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

procedure tJson2PumlCurlAuthenticationDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
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

procedure tJson2PumlCurlAuthenticationList.Clear;
begin
  inherited Clear;
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

function tJson2PumlCurlAuthenticationList.GetAuthentication (Index: Integer): tJson2PumlCurlAuthenticationDefinition;
begin
  Result := tJson2PumlCurlAuthenticationDefinition (Objects[index]);
end;

function tJson2PumlCurlAuthenticationList.GetEnumerator: tJson2PumlCurlAuthenticationEnumerator;
begin
  Result := tJson2PumlCurlAuthenticationEnumerator.Create (self);
end;

function tJson2PumlCurlParameterDefinition.GetValueDecoded: string;
begin
  Result := ReplaceValueFromEnvironment (Value);
end;

function tJson2PumlCurlParameterDefinition.GetIdent: string;
begin
  if MulitpleValues then
    Result := Format ('%s#%s', [name, Value])
  else
    Result := Format ('%s', [name]);
end;

procedure tJson2PumlCurlParameterDefinition.SetName (const Value: string);
begin
  FName := Value.Trim.ToLower;
  if FName.Substring (0, 2) <> '${' then
    FName := Format ('${%s}', [FName]);
end;

procedure tJson2PumlCurlParameterDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
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

function tJson2PumlCurlParameterList.AddParameter (iName, iValue: string; iMaxValues: Integer = 0): boolean;
var
  nParameter: tJson2PumlCurlParameterDefinition;
  i: Integer;
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

procedure tJson2PumlCurlParameterList.Clear;
begin
  inherited Clear;
end;

function tJson2PumlCurlParameterList.GetEnumerator: tJson2PumlCurlParameterEnumerator;
begin
  Result := tJson2PumlCurlParameterEnumerator.Create (self);
end;

function tJson2PumlCurlParameterList.GetParameter (Index: Integer): tJson2PumlCurlParameterDefinition;
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

function tJson2PumlCurlParameterList.ParameterValueCount (iParameterName: string): Integer;
var
  Parameter: tJson2PumlCurlParameterDefinition;
begin
  Result := 0;
  for Parameter in self do
    if Parameter.name = iParameterName then
      Result := Result + 1;
end;

procedure tJson2PumlCurlParameterList.ReadListValueFromJson (iJsonValue: TJSONValue);
var
  ParameterName, ParameterValue: string;
  ParameterMaxValues: Integer;
  DefinitionRecord: TJSONObject;
  Splitted: TArray<string>;
begin
  if iJsonValue is TJSONObject then
  begin
    DefinitionRecord := TJSONObject (iJsonValue);
    if DefinitionRecord.Count = 1 then
    begin
      ParameterName := DefinitionRecord.Pairs[0].JsonString.Value;
      if DefinitionRecord.Pairs[0].JsonValue is TJSONString then
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
  else if iJsonValue is TJSONString then
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
  i: Integer;
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

procedure tJson2PumlCurlFileParameterListMatrix.FillRows (iCurrentRow: tJson2PumlCurlParameterList; iDepth: Integer);
var
  TempList: tJson2PumlCurlParameterList;
  i: Integer;
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

function tJson2PumlCurlFileParameterListMatrix.GetRowParameterList (Index: Integer): tJson2PumlCurlParameterList;
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

procedure tJson2PumlFileOutputDefinition.AddFilesToZipFile (iZipFile: TZipFile; iRemoveDirectory: string);

  procedure AddFile (iFileName: string);
  begin
    if FileExists (iFileName) then
      iZipFile.Add (iFileName, iFileName.Replace(iRemoveDirectory, '').TrimLeft(TPath.DirectorySeparatorChar));
  end;

begin
  AddFile (PDFFilename);
  AddFile (PNGFileName);
  AddFile (PUmlFileName);
  AddFile (SVGFileName);
  AddFile (ConverterLogFileName);
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
  FileDetailRecord: TJson2PumlFileDetailRecord;

  function IntFileSize: Integer;
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

  function NoOfLine: Integer;
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
  FileDetailRecord := TJson2PumlFileDetailRecord.Create;
  FileDetailRecord.FileName := iFileName;
  FileDetailRecord.FileDate := TFile.GetLastWriteTime (iFileName);
  FileDetailRecord.FileSize := IntFileSize;
  FileDetailRecord.NoOfLines := NoOfLine;

  SourceFiles.AddObject (iFileName, FileDetailRecord);

end;

procedure tJson2PumlFileOutputDefinition.DeleteGeneratedFiles;

  procedure DeleteSingleFile (iFileName: string);
  begin
    if not iFileName.IsEmpty then
      try
        TFile.Delete (iFileName);
        GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Warn ('Deleting of file "%s" failed. (%s)', [iFileName, e.Message]);
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

procedure tJson2PumlFileOutputDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  Output: tStringList;
begin
  Output := tStringList.Create;
  try
    if IsSummaryFile then
      WriteToJsonValue (Output, 'isSummaryFile', IsSummaryFile, iLevel + 1);
    if IsSplitFile then
      WriteToJsonValue (Output, 'isSplitFile', IsSplitFile, iLevel + 1);
    if not PUmlFileName.IsEmpty then
      WriteToJsonValue (Output, 'pumlFile', PUmlFileName, iLevel + 1, iWriteEmpty);
    if not PDFFilename.IsEmpty then
      WriteToJsonValue (Output, 'pdfFile', PDFFilename, iLevel + 1, iWriteEmpty);
    if not PNGFileName.IsEmpty then
    begin
      WriteToJsonValue (Output, 'pngFile', PNGFileName, iLevel + 1, iWriteEmpty);
      // WriteToJsonValue (Output, 'pngFileContent', ConvertFileToBase64(PNGFileName), iLevel + 1, iWriteEmpty);
    end;
    if not SVGFileName.IsEmpty then
    begin
      WriteToJsonValue (Output, 'svgFile', SVGFileName, iLevel + 1, iWriteEmpty);
    end;
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
end;

destructor tJson2PumlParameterFileDefinition.Destroy;
begin
  FInputFiles.Free;
  FCurlParameter.Free;
  inherited Destroy;
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

function tJson2PumlParameterFileDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  InputListFileName := GetJsonStringValue (DefinitionRecord, 'inputListFile');
  DefinitionFileName := GetJsonStringValue (DefinitionRecord, 'definitionFile');
  GenerateSummaryStr := GetJsonStringValue (DefinitionRecord, 'generateSummary');
  GenerateDetailsStr := GetJsonStringValue (DefinitionRecord, 'generateDetails');
  OutputFormatStr := GetJsonStringValue (DefinitionRecord, 'outputFormats');
  Option := GetJsonStringValue (DefinitionRecord, 'option');
  OutputSuffix := GetJsonStringValue (DefinitionRecord, 'outputSuffix');
  CurlParameter.ReadFromJson (DefinitionRecord, 'curlParameter');
  InputFiles.ReadFromJson (DefinitionRecord, 'inputFiles');
  Result := true;
end;

procedure tJson2PumlParameterFileDefinition.SetOutputFormatStr (const Value: string);
begin
  FOutputFormatStr := Value;
  FOutputFormats.FromString (Value, false, true);
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
end;

procedure tJson2PumlParameterFileDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'inputListFile', InputListFileName, iLevel + 1, iWriteEmpty);
  InputFiles.WriteToJson (oJsonOutPut, 'inputFiles', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'definitionFile', DefinitionFileName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateSummary', GenerateSummaryStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'generateDetails', GenerateDetailsStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputFormats', OutputFormatStr, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'option', Option, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'outputSuffix', OutputSuffix, iLevel + 1, iWriteEmpty);
  CurlParameter.WriteToJson (oJsonOutPut, 'curlParameter', iLevel + 1, iWriteEmpty);
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
  i: Integer;
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

function tJson2PumlParameterInputFileDefinitionList.GetEnumerator: tJson2PumlParameterInputFileDefinitionListEnumerator;
begin
  Result := tJson2PumlParameterInputFileDefinitionListEnumerator.Create (self);
end;

function tJson2PumlParameterInputFileDefinitionList.GetInputFile (Index: Integer)
  : tJson2PumlParameterInputFileDefinition;
begin
  Result := tJson2PumlParameterInputFileDefinition (Objects[index]);
end;

function tJson2PumlParameterInputFileDefinition.GetIdent: string;
begin
  Result := FileName.Trim.ToLower;
end;

function tJson2PumlParameterInputFileDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
  Value: TJSONValue;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  FileName := GetJsonStringValue (DefinitionRecord, 'fileName');
  LeadingObject := GetJsonStringValue (DefinitionRecord, 'leadingObject');
  Value := GetJsonValue (DefinitionRecord, 'content');
  if Assigned (Value) then
    Content := Value.ToString
  else
    Content := '';
end;

procedure tJson2PumlParameterInputFileDefinition.SetContent (const Value: string);
begin
  FContent := Value;
  if Assigned (FJsonContent) then
    FJsonContent.Free;
  FJsonContent := TJSONObject.ParseJSONValue (Content) as TJSONValue;
end;

procedure tJson2PumlParameterInputFileDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
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

function tJson2PumlInputListDescriptionDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlInputListDescriptionDefinition.GetCurlParameter (Index: Integer)
  : tJson2PumlFileDescriptionParameterDefinition;
begin
  Result := CurlParameterList[index];
end;

function tJson2PumlInputListDescriptionDefinition.GetIsValid: boolean;
begin
  Result := not Description.IsEmpty;
end;

function tJson2PumlInputListDescriptionDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  Definition: TJSONObject;
begin
  Result := false;
  Clear;
  if not (iJsonValue is TJSONObject) then
    exit;
  Definition := GetJsonObject (TJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  Description := GetJsonStringValue (Definition, 'description');
  DisplayName := GetJsonStringValue (Definition, 'displayName');
  CurlParameterList.ReadFromJson (Definition, 'curlParameter');
  Result := IsValid;
end;

procedure tJson2PumlInputListDescriptionDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
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

function tJson2PumlFileDescriptionParameterList.GetInputParameter (Index: Integer)
  : tJson2PumlFileDescriptionParameterDefinition;
begin
  Result := tJson2PumlFileDescriptionParameterDefinition (Objects[index]);
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

function tJson2PumlFileDescriptionParameterDefinition.ReadFromJson (iJsonValue: TJSONValue;
  iPropertyName: string): boolean;
var
  Definition: TJSONObject;
begin
  Result := false;
  Clear;
  if not (iJsonValue is TJSONObject) then
    exit;
  Definition := GetJsonObject (TJSONObject(iJsonValue), iPropertyName);
  if not Assigned (Definition) then
    exit;
  name := GetJsonStringValue (Definition, 'name');
  Description := GetJsonStringValue (Definition, 'description');
  DisplayName := GetJsonStringValue (Definition, 'displayName');
  Mandatory := GetJsonStringValueBoolean (Definition, 'mandatory', false);
  RegularExpression := GetJsonStringValue (Definition, 'regularExpression');
  Result := IsValid;
end;

procedure tJson2PumlFileDescriptionParameterDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', name, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'displayName', DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'mandatory', Mandatory, iLevel + 1);
  WriteToJsonValue (oJsonOutPut, 'regularExpression', RegularExpression, iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlFileDeleteHandler.Create;
begin
  inherited Create;
  FFileList := tStringList.Create ();
  FDirectoryList := tStringList.Create ();
  FLock := TCriticalSection.Create ();
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
  i: Integer;

  function DeleteSingleFile (iFileName: string): boolean;
  begin
    if FileExists (iFileName) then
      try
        TFile.Delete (iFileName);
        GlobalLoghandler.Debug ('"File %s" deleted."', [iFileName]);
      except
        on e: exception do
          GlobalLoghandler.Warn ('Deleting of file "%s" failed. (%s)', [iFileName, e.Message]);
      end;
    Result := not FileExists (iFileName);
  end;

  function DeleteSingleDirectory (iDirectoryName: string): boolean;
  begin
    if TDirectory.Exists (iDirectoryName) then
      try
        TDirectory.Delete (iDirectoryName, true);
        GlobalLoghandler.Debug ('Directory "%s" deleted."', [iDirectoryName]);
      except
        on e: exception do
          GlobalLoghandler.Warn ('Deleting of directory "%s" failed. (%s)', [iDirectoryName, e.Message]);
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

initialization

InitializationGlobalVariables;

finalization

FinalizationGlobalVariables;

end.
