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

unit json2pumlconverterdefinition;

interface

uses System.JSON, System.Classes, json2pumlconst,
  json2pumlbasedefinition, json2pumldefinition;

type
  tJson2PumlOperationPropertyList = class(tJson2PumlBasePropertyList)
  private
    FOperation: tJson2PumlListOperation;
  public
    constructor Create; override;
    procedure MergeWith (iMergeList: tJson2PumlOperationPropertyList); reintroduce; virtual;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property Operation: tJson2PumlListOperation read FOperation write FOperation;
  end;

  tJson2PumlPropertyValueDefinition = class(tJson2PumlBaseObject)
  private
    FChildPropertyName: string;
    FNextValueSeparator: string;
    FPropertyName: string;
  protected
    function GetIdent: string; override;
  public
    procedure Assign (Source: tPersistent); override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property ChildPropertyName: string read FChildPropertyName write FChildPropertyName;
    property NextValueSeparator: string read FNextValueSeparator write FNextValueSeparator;
    property PropertyName: string read FPropertyName write FPropertyName;
  end;

  tJson2PumlPropertyValueDefinitionList = class;

  tJson2PumlPropertyValueDefinitionEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tJson2PumlPropertyValueDefinitionList;
  public
    constructor Create (AObjectList: tJson2PumlPropertyValueDefinitionList);
    function GetCurrent: tJson2PumlPropertyValueDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlPropertyValueDefinition read GetCurrent;
  end;

  tJson2PumlPropertyValueDefinitionList = class(tJson2PumlOperationPropertyList)
  private
    function GetDefinition (Index: Integer): tJson2PumlPropertyValueDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: TJSONValue); override;
  public
    constructor Create; override;
    procedure AddDefinition (iPropertyName, iChildPropertyName, iNextValueSeparator: string);
    procedure Assign (Source: tPersistent); override;
    function GetDefinitionByName (iPropertyName, iParentPropertyName, iParentObjectType, iConfigurationPropertyName
      : string; var oFoundCondition: string; iUseMatch: boolean = false; iSearchEmpyAsDefault: boolean = false)
      : tJson2PumlPropertyValueDefinition;
    function GetEnumerator: tJson2PumlPropertyValueDefinitionEnumerator;
    property Definition[index: Integer]: tJson2PumlPropertyValueDefinition read GetDefinition; default;
  end;

  tJson2PumlObjectDefinition = class(tJson2PumlBaseObject)
  private
    FGenerateWithoutIdentifier: boolean;
    FObjectName: string;
  protected
    function GetIdent: string; override;
  public
    procedure Assign (Source: tPersistent); override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property GenerateWithoutIdentifier: boolean read FGenerateWithoutIdentifier write FGenerateWithoutIdentifier;
    property ObjectName: string read FObjectName write FObjectName;
  end;

  tJson2PumlObjectDefinitionList = class;

  tJson2PumlObjectDefinitionEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tJson2PumlObjectDefinitionList;
  public
    constructor Create (AObjectList: tJson2PumlObjectDefinitionList);
    function GetCurrent: tJson2PumlObjectDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlObjectDefinition read GetCurrent;
  end;

  tJson2PumlObjectDefinitionList = class(tJson2PumlOperationPropertyList)
  private
    function GetDefinition (Index: Integer): tJson2PumlObjectDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: TJSONValue); override;
  public
    constructor Create; override;
    procedure AddDefinition (iObjectName: string; iGenerateWithoutIdentifier: boolean);
    procedure Assign (Source: tPersistent); override;
    function GetDefinitionByName (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): tJson2PumlObjectDefinition;
    function GetEnumerator: tJson2PumlObjectDefinitionEnumerator;
    property Definition[index: Integer]: tJson2PumlObjectDefinition read GetDefinition; default;
  end;

  tJson2PumlSingleFormatDefinition = class(tJson2PumlBaseObject)
  private
    FCaptionShowIdentStr: string;
    FCaptionShowTitleStr: string;
    FCaptionShowTypeStr: string;
    FCaptionSplitCharacter: string;
    FCaptionSplitLengthStr: string;
    FValueSplitLengthStr: string;
    FFormatName: string;
    FIconColor: string;
    FObjectFilter: TStrings;
    FShowAttributesStr: string;
    FSortAttributesStr: string;
    FShowCharacteristicsStr: string;
    FShowFromRelationsStr: string;
    FShowIfEmptyStr: string;
    FShowNullValuesStr: string;
    FShowToRelationsStr: string;
    FSkinParams: tStringList;
    function GetCaptionShowIdent: boolean;
    function GetCaptionShowTitle: boolean;
    function GetCaptionShowType: boolean;
    function GetCaptionSplitLength: Integer;
    function GetValueSplitLength: Integer;
    function GetShowAttributes: boolean;
    function GetSortAttributes: boolean;
    function GetShowCharacteristics: boolean;
    function GetShowFromRelations: boolean;
    function GetShowIfEmpty: boolean;
    function GetShowNullValues: boolean;
    function GetShowToRelations: boolean;
    procedure SetCaptionShowIdentStr (const Value: string);
    procedure SetCaptionShowTitleStr (const Value: string);
    procedure SetCaptionShowTypeStr (const Value: string);
    procedure SetShowAttributesStr (const Value: string);
    procedure SetSortAttributesStr (const Value: string);
    procedure SetShowCharacteristicsStr (const Value: string);
    procedure SetShowFromRelationsStr (const Value: string);
    procedure SetShowIfEmptyStr (const Value: string);
    procedure SetShowNullValuesStr (const Value: string);
    procedure SetShowToRelationsStr (const Value: string);
    procedure SetSkinParams (const Value: tStringList);
  protected
    function GetIdent: string; override;
    function GetIsFilled: boolean; override;
    property CaptionShowIdentStr: string read FCaptionShowIdentStr write SetCaptionShowIdentStr;
    property CaptionShowTitleStr: string read FCaptionShowTitleStr write SetCaptionShowTitleStr;
    property CaptionShowTypeStr: string read FCaptionShowTypeStr write SetCaptionShowTypeStr;
    property CaptionSplitLengthStr: string read FCaptionSplitLengthStr write FCaptionSplitLengthStr;
    property ValueSplitLengthStr: string read FValueSplitLengthStr write FValueSplitLengthStr;
    property ShowAttributesStr: string read FShowAttributesStr write SetShowAttributesStr;
    property SortAttributesStr: string read FSortAttributesStr write SetSortAttributesStr;
    property ShowCharacteristicsStr: string read FShowCharacteristicsStr write SetShowCharacteristicsStr;
    property ShowFromRelationsStr: string read FShowFromRelationsStr write SetShowFromRelationsStr;
    property ShowIfEmptyStr: string read FShowIfEmptyStr write SetShowIfEmptyStr;
    property ShowNullValuesStr: string read FShowNullValuesStr write SetShowNullValuesStr;
    property ShowToRelationsStr: string read FShowToRelationsStr write SetShowToRelationsStr;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; override;
    procedure MergeWith (iMergeDefinition: tJson2PumlBaseObject); override;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property CaptionShowIdent: boolean read GetCaptionShowIdent;
    property CaptionShowTitle: boolean read GetCaptionShowTitle;
    property CaptionShowType: boolean read GetCaptionShowType;
    property CaptionSplitCharacter: string read FCaptionSplitCharacter write FCaptionSplitCharacter;
    property CaptionSplitLength: Integer read GetCaptionSplitLength;
    property ValueSplitLength: Integer read GetValueSplitLength;
    property FormatName: string read FFormatName write FFormatName;
    property IconColor: string read FIconColor write FIconColor;
    property ObjectFilter: TStrings read FObjectFilter write FObjectFilter;
    property ShowAttributes: boolean read GetShowAttributes;
    property SortAttributes: boolean read GetSortAttributes;
    property ShowCharacteristics: boolean read GetShowCharacteristics;
    property ShowFromRelations: boolean read GetShowFromRelations;
    property ShowIfEmpty: boolean read GetShowIfEmpty;
    property ShowNullValues: boolean read GetShowNullValues;
    property ShowToRelations: boolean read GetShowToRelations;
    property SkinParams: tStringList read FSkinParams write SetSkinParams;
  end;

  tJson2PumlFormatDefinitionList = class;

  tJson2PumlFormatDefinitionEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tJson2PumlFormatDefinitionList;
  public
    constructor Create (ACharacteristicList: tJson2PumlFormatDefinitionList);
    function GetCurrent: tJson2PumlSingleFormatDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlSingleFormatDefinition read GetCurrent;
  end;

  tJson2PumlFormatDefinitionList = class(tJson2PumlOperationPropertyList)
  private
    function GetDefinition (Index: Integer): tJson2PumlSingleFormatDefinition;
  protected
    function CreateListValueObject: tJson2PumlBaseObject; override;
  public
    constructor Create; override;
    procedure AddDefinition (iDefinition: tJson2PumlSingleFormatDefinition);
    procedure Assign (Source: tPersistent); override;
    procedure GeneratePuml (ipuml: TStrings);
    function GetDefinitionByName (iPropertyName, iParentPropertyName: string; var oPriority: Integer;
      var oFoundCondition: string): tJson2PumlSingleFormatDefinition;
    function GetEnumerator: tJson2PumlFormatDefinitionEnumerator;
    property Definition[index: Integer]: tJson2PumlSingleFormatDefinition read GetDefinition; default;
  end;

  tJson2PumlFormatDefinition = class(tJson2PumlBaseObject)
  private
    FBaseFormat: tJson2PumlSingleFormatDefinition;
    FFormats: tJson2PumlFormatDefinitionList;
    FIntFormats: tJson2PumlFormatDefinitionList;
  protected
    procedure BuildFormatList;
    function GetIdent: string; override;
    function GetIsFilled: boolean; override;
    property IntFormats: tJson2PumlFormatDefinitionList read FIntFormats;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; override;
    function GetFormatByName (iPropertyName, iParentPropertyName: string; var oPriority: Integer;
      var oFoundCondition: string): tJson2PumlSingleFormatDefinition;
    procedure MergeWith (iMergeDefinition: tJson2PumlBaseObject); override;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    property BaseFormat: tJson2PumlSingleFormatDefinition read FBaseFormat;
    property Formats: tJson2PumlFormatDefinitionList read FFormats;
  end;

  tJson2PumlCharacteristicDefinition = class(tJson2PumlBaseObject)
  private
    FCharacteristicType: tJson2PumlCharacteristicType;
    FIncludeIndexStr: string;
    FPropertyList: tStringList;
    FParentProperty: string;
    function GetIncludeIndex: boolean;
    procedure SetIncludeIndexStr (const Value: string);
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign (Source: tPersistent); override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
  published
    function IsPropertyAllowed (iPropertyName, iParentPropertyName: string; var oFoundCondition: string): boolean;
    procedure SortUsedColumnsByPropertyList (iUsedColumns: tStringList);
    property CharacteristicType: tJson2PumlCharacteristicType read FCharacteristicType write FCharacteristicType
      default jctList;
    property IncludeIndex: boolean read GetIncludeIndex;
    property IncludeIndexStr: string read FIncludeIndexStr write SetIncludeIndexStr;
    property PropertyList: tStringList read FPropertyList;
    property ParentProperty: string read FParentProperty write FParentProperty;
  end;

  tJson2PumlCharacteristicDefinitionList = class;

  tJson2PumlCharacteristicDefinitionEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tJson2PumlCharacteristicDefinitionList;
  public
    constructor Create (ACharacteristicList: tJson2PumlCharacteristicDefinitionList);
    function GetCurrent: tJson2PumlCharacteristicDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlCharacteristicDefinition read GetCurrent;
  end;

  tJson2PumlCharacteristicDefinitionList = class(tJson2PumlOperationPropertyList)
  private
    function GetDefinition (Index: Integer): tJson2PumlCharacteristicDefinition;
  protected
    procedure ReadListValueFromJson (iJsonValue: TJSONValue); override;
  public
    constructor Create; override;
    procedure AddDefinition (iParentProperty: string; iCharacteristicType: tJson2PumlCharacteristicType;
      iPropertyList: tStringList = nil; iIncludeIndex: string = '');
    procedure Assign (Source: tPersistent); override;
    function GetDefinitionByName (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): tJson2PumlCharacteristicDefinition;
    function GetEnumerator: tJson2PumlCharacteristicDefinitionEnumerator;
    property Definition[index: Integer]: tJson2PumlCharacteristicDefinition read GetDefinition; default;
  end;

  tJson2PumlRelationshipTypeArrowFormatList = class(tJson2PumlOperationPropertyList)

  public
    function GetFormat (iObjectType, iPropertyName, iRelationshipType: string; var oFoundCondition: string): string;
  end;

  tJson2PumlConverterDefinition = class(tJson2PumlBaseObject)
  private
    FAttributeProperties: tJson2PumlOperationPropertyList;
    FCharacteristicProperties: tJson2PumlCharacteristicDefinitionList;
    FContinueAfterUnhandledObjectsStr: string;
    FGroupDetailObjectsTogetherStr: string;
    FGroupProperties: tJson2PumlOperationPropertyList;
    FHiddenProperties: tJson2PumlOperationPropertyList;
    FHideDuplicateRelationsStr: string;
    FIdentifyObjectsByTypeAndIdentStr: string;
    FLegendShowFileInfosStr: string;
    FLegendShowInfoStr: string;
    FLegendShowObjectFormatsStr: string;
    FObjectDetailProperties: tJson2PumlOperationPropertyList;
    FObjectFormats: tJson2PumlFormatDefinition;
    FObjectIdentifierProperties: tJson2PumlPropertyValueDefinitionList;
    FObjectProperties: tJson2PumlObjectDefinitionList;
    FObjectTitleProperties: tJson2PumlPropertyValueDefinitionList;
    FObjectTypeProperties: tJson2PumlPropertyValueDefinitionList;
    FObjectTypeRenames: tJson2PumlOperationPropertyList;
    FOptionName: string;
    FPUMLHeaderLines: tJson2PumlOperationPropertyList;
    FRelationshipProperties: tJson2PumlOperationPropertyList;
    FRelationshipTypeArrowFormats: tJson2PumlRelationshipTypeArrowFormatList;
    FRelationshipTypeProperties: tJson2PumlPropertyValueDefinitionList;
    function GetContinueAfterUnhandledObjects: boolean;
    function GetGroupDetailObjectsTogether: boolean;
    function GetHideDuplicateRelations: boolean;
    function GetIdentifyObjectsByTypeAndIdent: boolean;
    function GetLegendShowFileInfos: boolean;
    function GetLegendShowInfo: boolean;
    function GetLegendShowObjectFormats: boolean;
    function GetShowLegend: boolean;
    procedure SetAttributeProperties (const Value: tJson2PumlOperationPropertyList);
    procedure SetCharacteristicProperties (const Value: tJson2PumlCharacteristicDefinitionList);
    procedure SetContinueAfterUnhandledObjectsStr (const Value: string);
    procedure SetGroupDetailObjectsTogetherStr (const Value: string);
    procedure SetGroupProperties (const Value: tJson2PumlOperationPropertyList);
    procedure SetHiddenProperties (const Value: tJson2PumlOperationPropertyList);
    procedure SetHideDuplicateRelationsStr (const Value: string);
    procedure SetIdentifyObjectsByTypeAndIdentStr (const Value: string);
    procedure SetLegendShowFileInfosStr (const Value: string);
    procedure SetLegendShowInfoStr (const Value: string);
    procedure SetLegendShowObjectFormatsStr (const Value: string);
    procedure SetObjectDetailProperties (const Value: tJson2PumlOperationPropertyList);
    procedure SetObjectFormats (const Value: tJson2PumlFormatDefinition);
    procedure SetObjectIdentifierProperties (const Value: tJson2PumlPropertyValueDefinitionList);
    procedure SetObjectProperties (const Value: tJson2PumlObjectDefinitionList);
    procedure SetObjectTitleProperties (const Value: tJson2PumlPropertyValueDefinitionList);
    procedure SetObjectTypeProperties (const Value: tJson2PumlPropertyValueDefinitionList);
    procedure SetObjectTypeRenames (const Value: tJson2PumlOperationPropertyList);
    procedure SetOptionName (const Value: string);
    procedure SetPUMLHeaderLines (const Value: tJson2PumlOperationPropertyList);
    procedure SetRelationshipProperties (const Value: tJson2PumlOperationPropertyList);
    procedure SetRelationshipTypeArrowFormats (const Value: tJson2PumlRelationshipTypeArrowFormatList);
    procedure SetRelationshipTypeProperties (const Value: tJson2PumlPropertyValueDefinitionList);
  protected
    function GetIdent: string; override;
    function GetIsFilled: boolean; override;
    property LegendShowFileInfosStr: string read FLegendShowFileInfosStr write SetLegendShowFileInfosStr;
    property LegendShowInfoStr: string read FLegendShowInfoStr write SetLegendShowInfoStr;
    property LegendShowObjectFormatsStr: string read FLegendShowObjectFormatsStr write SetLegendShowObjectFormatsStr;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; override;
    function IsCharacteristicProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsGroupProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition, oGroupName: string): boolean; overload;
    function IsGroupProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean; overload;
    function IsObjectDetailProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsObjectIdentifierProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsObjectProperty (iPropertyName: string; iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsPropertyAllowed (iPropertyName: string; iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsPropertyHidden (iPropertyName: string; iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function isRelationshipProperty (iPropertyName: string; iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    function IsRelationshipTypeProperty (iPropertyName: string; iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): boolean;
    procedure MergeWith (iMergeDefinition: tJson2PumlBaseObject); override;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    function RenameObjectType (iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): string;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    property OptionName: string read FOptionName write SetOptionName;
    property ShowLegend: boolean read GetShowLegend;
  published
    property AttributeProperties: tJson2PumlOperationPropertyList read FAttributeProperties
      write SetAttributeProperties;
    property CharacteristicProperties: tJson2PumlCharacteristicDefinitionList read FCharacteristicProperties
      write SetCharacteristicProperties;
    property ContinueAfterUnhandledObjects: boolean read GetContinueAfterUnhandledObjects;
    property ContinueAfterUnhandledObjectsStr: string read FContinueAfterUnhandledObjectsStr
      write SetContinueAfterUnhandledObjectsStr;
    property GroupDetailObjectsTogether: boolean read GetGroupDetailObjectsTogether;
    property GroupDetailObjectsTogetherStr: string read FGroupDetailObjectsTogetherStr
      write SetGroupDetailObjectsTogetherStr;
    property GroupProperties: tJson2PumlOperationPropertyList read FGroupProperties write SetGroupProperties;
    property HiddenProperties: tJson2PumlOperationPropertyList read FHiddenProperties write SetHiddenProperties;
    property HideDuplicateRelations: boolean read GetHideDuplicateRelations;
    property HideDuplicateRelationsStr: string read FHideDuplicateRelationsStr write SetHideDuplicateRelationsStr;
    property IdentifyObjectsByTypeAndIdent: boolean read GetIdentifyObjectsByTypeAndIdent;
    property IdentifyObjectsByTypeAndIdentStr: string read FIdentifyObjectsByTypeAndIdentStr
      write SetIdentifyObjectsByTypeAndIdentStr;
    property LegendShowFileInfos: boolean read GetLegendShowFileInfos;
    property LegendShowInfo: boolean read GetLegendShowInfo;
    property LegendShowObjectFormats: boolean read GetLegendShowObjectFormats;
    property ObjectDetailProperties: tJson2PumlOperationPropertyList read FObjectDetailProperties
      write SetObjectDetailProperties;
    property ObjectFormats: tJson2PumlFormatDefinition read FObjectFormats write SetObjectFormats;
    property ObjectIdentifierProperties: tJson2PumlPropertyValueDefinitionList read FObjectIdentifierProperties
      write SetObjectIdentifierProperties;
    property ObjectProperties: tJson2PumlObjectDefinitionList read FObjectProperties write SetObjectProperties;
    property ObjectTitleProperties: tJson2PumlPropertyValueDefinitionList read FObjectTitleProperties
      write SetObjectTitleProperties;
    property ObjectTypeProperties: tJson2PumlPropertyValueDefinitionList read FObjectTypeProperties
      write SetObjectTypeProperties;
    property ObjectTypeRenames: tJson2PumlOperationPropertyList read FObjectTypeRenames write SetObjectTypeRenames;
    property PUMLHeaderLines: tJson2PumlOperationPropertyList read FPUMLHeaderLines write SetPUMLHeaderLines;
    property RelationshipProperties: tJson2PumlOperationPropertyList read FRelationshipProperties
      write SetRelationshipProperties;
    property RelationshipTypeArrowFormats: tJson2PumlRelationshipTypeArrowFormatList read FRelationshipTypeArrowFormats
      write SetRelationshipTypeArrowFormats;
    property RelationshipTypeProperties: tJson2PumlPropertyValueDefinitionList read FRelationshipTypeProperties
      write SetRelationshipTypeProperties;
  end;

  tJson2PumlConverterDefinitionList = class;

  tJson2PumlConverterDefinitionEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tJson2PumlConverterDefinitionList;
  public
    constructor Create (ACharacteristicList: tJson2PumlConverterDefinitionList);
    function GetCurrent: tJson2PumlConverterDefinition;
    function MoveNext: boolean;
    property Current: tJson2PumlConverterDefinition read GetCurrent;
  end;

  tJson2PumlConverterDefinitionList = class(tJson2PumlBasePropertyList)
  private
    function GetDefinition (Index: Integer): tJson2PumlConverterDefinition;
  public
    constructor Create; override;
    procedure AddDefinition (iDefinition: tJson2PumlConverterDefinition);
    procedure Assign (Source: tPersistent); override;
    function GetDefinitionByName (iOptionName: string): tJson2PumlConverterDefinition;
    function GetEnumerator: tJson2PumlConverterDefinitionEnumerator;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    property Definition[index: Integer]: tJson2PumlConverterDefinition read GetDefinition; default;
  end;

  tJson2PumlConverterGroupDescriptionDefinition = class(tJson2PumlBaseObject)
  private
    FDescription: string;
    FDisplayName: string;
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
  end;

  tJson2PumlConverterGroupDefinition = class(tJson2PumlBaseObject)
  private
    FBaseOption: tJson2PumlConverterDefinition;
    FDefaultOption: string;
    FDescription: tJson2PumlConverterGroupDescriptionDefinition;
    FOptionList: tJson2PumlConverterDefinitionList;
    function GetOptionByName (name: string): tJson2PumlConverterDefinition;
    function GetOptionCount: Integer;
    function GetOptions (Index: Integer): tJson2PumlConverterDefinition;
    procedure SetDefaultOption (const Value: string);
  protected
    function GetIdent: string; override;
    function GetIsValid: boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure FillDefinitionFromOption (iDefinition: tJson2PumlConverterDefinition; iOption: string); overload;
    procedure FillDefinitionFromOption (iDefinition, iSourceDefinition: tJson2PumlConverterDefinition); overload;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; override;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonServiceListResult (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); overload;
    property BaseOption: tJson2PumlConverterDefinition read FBaseOption;
    property DefaultOption: string read FDefaultOption write SetDefaultOption;
    property Description: tJson2PumlConverterGroupDescriptionDefinition read FDescription;
    property OptionByName[name: string]: tJson2PumlConverterDefinition read GetOptionByName;
    property OptionCount: Integer read GetOptionCount;
    property OptionList: tJson2PumlConverterDefinitionList read FOptionList;
    property Options[index: Integer]: tJson2PumlConverterDefinition read GetOptions;
  end;

implementation

uses
  json2pumltools, jsontools, System.SysUtils, System.Masks, System.Generics.Collections;

constructor tJson2PumlConverterDefinition.Create;
begin
  inherited Create;
  FAttributeProperties := tJson2PumlOperationPropertyList.Create;
  FCharacteristicProperties := tJson2PumlCharacteristicDefinitionList.Create;
  FGroupProperties := tJson2PumlOperationPropertyList.Create ();
  FHiddenProperties := tJson2PumlOperationPropertyList.Create;
  FObjectDetailProperties := tJson2PumlOperationPropertyList.Create;
  FObjectFormats := tJson2PumlFormatDefinition.Create;
  FObjectIdentifierProperties := tJson2PumlPropertyValueDefinitionList.Create;
  FObjectProperties := tJson2PumlObjectDefinitionList.Create;
  FObjectTitleProperties := tJson2PumlPropertyValueDefinitionList.Create ();
  FObjectTypeProperties := tJson2PumlPropertyValueDefinitionList.Create;
  FObjectTypeRenames := tJson2PumlOperationPropertyList.Create;
  FPUMLHeaderLines := tJson2PumlOperationPropertyList.Create ();
  FRelationshipProperties := tJson2PumlOperationPropertyList.Create;
  FRelationshipTypeArrowFormats := tJson2PumlRelationshipTypeArrowFormatList.Create;
  FRelationshipTypeProperties := tJson2PumlPropertyValueDefinitionList.Create;
end;

destructor tJson2PumlConverterDefinition.Destroy;
begin
  FRelationshipTypeProperties.Free;
  FRelationshipTypeArrowFormats.Free;
  FRelationshipProperties.Free;
  FPUMLHeaderLines.Free;
  FObjectTypeRenames.Free;
  FObjectTypeProperties.Free;
  FObjectTitleProperties.Free;
  FObjectProperties.Free;
  FObjectIdentifierProperties.Free;
  FObjectFormats.Free;
  FObjectDetailProperties.Free;
  FHiddenProperties.Free;
  FGroupProperties.Free;
  FCharacteristicProperties.Free;
  FAttributeProperties.Free;
  inherited Destroy;
end;

procedure tJson2PumlConverterDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlConverterDefinition then
  begin
    AttributeProperties := tJson2PumlConverterDefinition (Source).AttributeProperties;
    CharacteristicProperties := tJson2PumlConverterDefinition (Source).CharacteristicProperties;
    ContinueAfterUnhandledObjectsStr := tJson2PumlConverterDefinition (Source).ContinueAfterUnhandledObjectsStr;
    LegendShowFileInfosStr := tJson2PumlConverterDefinition (Source).LegendShowFileInfosStr;
    LegendShowInfoStr := tJson2PumlConverterDefinition (Source).LegendShowInfoStr;
    LegendShowObjectFormatsStr := tJson2PumlConverterDefinition (Source).LegendShowObjectFormatsStr;
    GroupDetailObjectsTogetherStr := tJson2PumlConverterDefinition (Source).GroupDetailObjectsTogetherStr;
    GroupProperties := tJson2PumlConverterDefinition (Source).GroupProperties;
    HiddenProperties := tJson2PumlConverterDefinition (Source).HiddenProperties;
    HideDuplicateRelationsStr := tJson2PumlConverterDefinition (Source).HideDuplicateRelationsStr;
    IdentifyObjectsByTypeAndIdentStr := tJson2PumlConverterDefinition (Source).IdentifyObjectsByTypeAndIdentStr;
    ObjectDetailProperties := tJson2PumlConverterDefinition (Source).ObjectDetailProperties;
    ObjectFormats := tJson2PumlConverterDefinition (Source).ObjectFormats;
    ObjectIdentifierProperties := tJson2PumlConverterDefinition (Source).ObjectIdentifierProperties;
    ObjectProperties := tJson2PumlConverterDefinition (Source).ObjectProperties;
    ObjectTitleProperties := tJson2PumlConverterDefinition (Source).ObjectTitleProperties;
    ObjectTypeProperties := tJson2PumlConverterDefinition (Source).ObjectTypeProperties;
    ObjectTypeRenames := tJson2PumlConverterDefinition (Source).ObjectTypeRenames;
    OptionName := tJson2PumlConverterDefinition (Source).OptionName;
    PUMLHeaderLines := tJson2PumlConverterDefinition (Source).PUMLHeaderLines;
    RelationshipProperties := tJson2PumlConverterDefinition (Source).RelationshipProperties;
    RelationshipTypeArrowFormats := tJson2PumlConverterDefinition (Source).RelationshipTypeArrowFormats;
    RelationshipTypeProperties := tJson2PumlConverterDefinition (Source).RelationshipTypeProperties;
  end;
end;

procedure tJson2PumlConverterDefinition.Clear;
begin
  AttributeProperties.Clear;
  CharacteristicProperties.Clear;
  ContinueAfterUnhandledObjectsStr := '';
  GroupDetailObjectsTogetherStr := '';
  GroupProperties.Clear;
  HiddenProperties.Clear;
  HideDuplicateRelationsStr := '';
  IdentifyObjectsByTypeAndIdentStr := '';
  LegendShowFileInfosStr := '';
  LegendShowInfoStr := '';
  LegendShowObjectFormatsStr := '';
  ObjectDetailProperties.Clear;
  ObjectFormats.Clear;
  ObjectIdentifierProperties.Clear;
  ObjectProperties.Clear;
  ObjectTitleProperties.Clear;
  ObjectTypeProperties.Clear;
  ObjectTypeRenames.Clear;
  OptionName := '';
  PUMLHeaderLines.Clear;
  RelationshipProperties.Clear;
  RelationshipTypeArrowFormats.Clear;
  RelationshipTypeProperties.Clear;
end;

function tJson2PumlConverterDefinition.GetContinueAfterUnhandledObjects: boolean;
begin
  Result := StringToBoolean (ContinueAfterUnhandledObjectsStr, false);
end;

function tJson2PumlConverterDefinition.GetGroupDetailObjectsTogether: boolean;
begin
  Result := StringToBoolean (GroupDetailObjectsTogetherStr, false);
end;

function tJson2PumlConverterDefinition.GetHideDuplicateRelations: boolean;
begin
  Result := StringToBoolean (HideDuplicateRelationsStr, true);
end;

function tJson2PumlConverterDefinition.GetIdent: string;
begin
  Result := OptionName;
end;

function tJson2PumlConverterDefinition.GetIdentifyObjectsByTypeAndIdent: boolean;
begin
  Result := StringToBoolean (IdentifyObjectsByTypeAndIdentStr, true);
end;

function tJson2PumlConverterDefinition.GetLegendShowFileInfos: boolean;
begin
  Result := StringToBoolean (LegendShowFileInfosStr, true);
end;

function tJson2PumlConverterDefinition.GetLegendShowInfo: boolean;
begin
  Result := StringToBoolean (LegendShowInfoStr, true);
end;

function tJson2PumlConverterDefinition.GetLegendShowObjectFormats: boolean;
begin
  Result := StringToBoolean (LegendShowObjectFormatsStr, true);
end;

function tJson2PumlConverterDefinition.GetShowLegend: boolean;
begin
  Result := LegendShowInfo or LegendShowObjectFormats or LegendShowFileInfos;
end;

function tJson2PumlConverterDefinition.IsCharacteristicProperty (iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  Result := CharacteristicProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
    'characteristicProperties', oFoundCondition, true) >= 0;
end;

function tJson2PumlConverterDefinition.GetIsFilled: boolean;
begin
  Result := (AttributeProperties.Count > 0) or (AttributeProperties.Count > 0) or (CharacteristicProperties.Count > 0)
    or (HiddenProperties.Count > 0) or not LegendShowFileInfosStr.IsEmpty or not LegendShowInfoStr.IsEmpty or
    not LegendShowObjectFormatsStr.IsEmpty or (ObjectFormats.Formats.Count > 0) or (ObjectDetailProperties.Count > 0) or
    (ObjectIdentifierProperties.Count > 0) or (ObjectProperties.Count > 0) or (ObjectTypeRenames.Count > 0) or
    (PUMLHeaderLines.Count > 0) or (ObjectTypeProperties.Count > 0) or (ObjectTitleProperties.Count > 0) or
    (RelationshipProperties.Count > 0) or (RelationshipTypeArrowFormats.Count > 0) or
    (RelationshipTypeProperties.Count > 0) or not ContinueAfterUnhandledObjectsStr.IsEmpty;
end;

function tJson2PumlConverterDefinition.IsGroupProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
  var oFoundCondition, oGroupName: string): boolean;
var
  Index: Integer;
begin
  index := GroupProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, 'groupProperties',
    oFoundCondition, true);
  Result := index >= 0;
  if Result then
  begin
    oGroupName := GroupProperties.ValueFromIndex[index];
    if oGroupName.IsEmpty then
      oGroupName := iPropertyName;
  end;
end;

function tJson2PumlConverterDefinition.IsGroupProperty (iPropertyName, iParentPropertyName, iParentObjectType: string;
  var oFoundCondition: string): boolean;
var
  GroupName: string;
begin
  Result := IsGroupProperty (iPropertyName, iParentPropertyName, iParentObjectType, oFoundCondition, GroupName);
end;

function tJson2PumlConverterDefinition.IsObjectDetailProperty (iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  Result := ObjectDetailProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
    'objectDetailProperties', oFoundCondition, true) >= 0;
end;

function tJson2PumlConverterDefinition.IsObjectIdentifierProperty (iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  if ObjectIdentifierProperties.Count = 0 then
    Result := iPropertyName = 'id'
  else
    Result := ObjectIdentifierProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
      'objectIdentifierProperties', oFoundCondition) >= 0;
end;

function tJson2PumlConverterDefinition.IsObjectProperty (iPropertyName: string;
  iParentPropertyName, iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  if ObjectProperties.Count > 0 then
    Result := ObjectProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
      'objectProperties', oFoundCondition, true) >= 0
  else
    Result := true;
end;

function tJson2PumlConverterDefinition.IsPropertyAllowed (iPropertyName: string;
  iParentPropertyName, iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  if AttributeProperties.Count > 0 then
    Result := AttributeProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
      'attributeProperties', oFoundCondition, true) >= 0
  else
    Result := true;
end;

function tJson2PumlConverterDefinition.IsPropertyHidden (iPropertyName: string;
  iParentPropertyName, iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  Result := HiddenProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, 'hiddenProperties',
    oFoundCondition, true) >= 0;
end;

function tJson2PumlConverterDefinition.isRelationshipProperty (iPropertyName: string;
  iParentPropertyName, iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  Result := RelationshipProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
    'relationshipProperties', oFoundCondition, true) >= 0;
end;

function tJson2PumlConverterDefinition.IsRelationshipTypeProperty (iPropertyName: string;
  iParentPropertyName, iParentObjectType: string; var oFoundCondition: string): boolean;
begin
  Result := RelationshipTypeProperties.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
    'relationshipTypeProperties', oFoundCondition) >= 0;
end;

procedure tJson2PumlConverterDefinition.MergeWith (iMergeDefinition: tJson2PumlBaseObject);
var
  Definition: tJson2PumlConverterDefinition;
begin
  if (iMergeDefinition = self) or not (iMergeDefinition is tJson2PumlConverterDefinition) then
    exit;
  Definition := tJson2PumlConverterDefinition (iMergeDefinition);
  ContinueAfterUnhandledObjectsStr := MergeValue (ContinueAfterUnhandledObjectsStr,
    Definition.ContinueAfterUnhandledObjectsStr);
  GroupDetailObjectsTogetherStr := MergeValue (GroupDetailObjectsTogetherStr, Definition.GroupDetailObjectsTogetherStr);
  HideDuplicateRelationsStr := MergeValue (HideDuplicateRelationsStr, Definition.HideDuplicateRelationsStr);
  IdentifyObjectsByTypeAndIdentStr := MergeValue (IdentifyObjectsByTypeAndIdentStr,
    Definition.IdentifyObjectsByTypeAndIdentStr);
  LegendShowFileInfosStr := MergeValue (LegendShowFileInfosStr, Definition.LegendShowFileInfosStr);
  LegendShowInfoStr := MergeValue (LegendShowInfoStr, Definition.LegendShowInfoStr);
  LegendShowObjectFormatsStr := MergeValue (LegendShowObjectFormatsStr, Definition.LegendShowObjectFormatsStr);
  OptionName := MergeValue (OptionName, Definition.OptionName);

  AttributeProperties.MergeWith (Definition.AttributeProperties);
  CharacteristicProperties.MergeWith (Definition.CharacteristicProperties);
  GroupProperties.MergeWith (Definition.GroupProperties);
  HiddenProperties.MergeWith (Definition.HiddenProperties);
  ObjectFormats.MergeWith (Definition.ObjectFormats);
  ObjectDetailProperties.MergeWith (Definition.ObjectDetailProperties);
  ObjectIdentifierProperties.MergeWith (Definition.ObjectIdentifierProperties);
  ObjectProperties.MergeWith (Definition.ObjectProperties);
  PUMLHeaderLines.MergeWith (Definition.PUMLHeaderLines);
  ObjectTypeRenames.MergeWith (Definition.ObjectTypeRenames);
  ObjectTitleProperties.MergeWith (Definition.ObjectTitleProperties);
  ObjectTypeProperties.MergeWith (Definition.ObjectTypeProperties);
  RelationshipProperties.MergeWith (Definition.RelationshipProperties);
  ObjectTypeProperties.MergeWith (Definition.ObjectTypeProperties);
  RelationshipTypeArrowFormats.MergeWith (Definition.RelationshipTypeArrowFormats);
  RelationshipTypeProperties.MergeWith (Definition.RelationshipTypeProperties);

end;

function tJson2PumlConverterDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Result := true;
  if ExistsJsonProperty (DefinitionRecord, 'definition') and ExistsJsonProperty (DefinitionRecord, 'option') then
  begin
    OptionName := GetJsonStringValue (DefinitionRecord, 'option');
    DefinitionRecord := GetJsonObject (DefinitionRecord, 'definition');
  end;
  if not Assigned (DefinitionRecord) then
    exit;
  ContinueAfterUnhandledObjectsStr := GetJsonStringValueBoolean (DefinitionRecord, 'continueAfterUnhandledObjects', '');
  GroupDetailObjectsTogetherStr := GetJsonStringValueBoolean (DefinitionRecord, 'groupDetailObjectsTogether', '');
  HideDuplicateRelationsStr := GetJsonStringValueBoolean (DefinitionRecord, 'hideDuplicateRelations', '');
  IdentifyObjectsByTypeAndIdentStr := GetJsonStringValueBoolean (DefinitionRecord, 'identifyObjectsByTypeAndIdent', '');
  LegendShowInfoStr := GetJsonStringValueBoolean (DefinitionRecord, 'legendShowInfo', '');
  LegendShowFileInfosStr := GetJsonStringValueBoolean (DefinitionRecord, 'legendShowFileInfos', '');
  LegendShowObjectFormatsStr := GetJsonStringValueBoolean (DefinitionRecord, 'legendShowObjectFormats', '');
  AttributeProperties.ReadFromJson (DefinitionRecord, 'attributeProperties');
  CharacteristicProperties.ReadFromJson (DefinitionRecord, 'characteristicProperties');
  HiddenProperties.ReadFromJson (DefinitionRecord, 'hiddenProperties');
  ObjectFormats.ReadFromJson (DefinitionRecord, 'objectFormats');
  ObjectDetailProperties.ReadFromJson (DefinitionRecord, 'objectDetailProperties');
  GroupProperties.ReadFromJson (DefinitionRecord, 'groupProperties');
  ObjectIdentifierProperties.ReadFromJson (DefinitionRecord, 'objectIdentifierProperties');
  ObjectProperties.ReadFromJson (DefinitionRecord, 'objectProperties');
  ObjectTypeRenames.ReadFromJson (DefinitionRecord, 'objectTypeRenames');
  PUMLHeaderLines.ReadFromJson (DefinitionRecord, 'pumlHeaderLines');
  RelationshipProperties.ReadFromJson (DefinitionRecord, 'relationshipProperties');
  ObjectTypeProperties.ReadFromJson (DefinitionRecord, 'objectTypeProperties');
  ObjectTitleProperties.ReadFromJson (DefinitionRecord, 'objectTitleProperties');
  RelationshipTypeArrowFormats.ReadFromJson (DefinitionRecord, 'relationshipTypeArrowFormats');
  RelationshipTypeArrowFormats.Text := RelationshipTypeArrowFormats.Text.ToLower;
  RelationshipTypeProperties.ReadFromJson (DefinitionRecord, 'relationshipTypeProperties');
end;

function tJson2PumlConverterDefinition.RenameObjectType (iPropertyName, iParentPropertyName, iParentObjectType: string;
  var oFoundCondition: string): string;
var
  Index: Integer;
begin
  index := ObjectTypeRenames.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
    'objectTypeRenames', oFoundCondition, true);
  Result := ObjectTypeRenames.ValueFromIndex[index];
  if Result.IsEmpty then
    Result := iPropertyName;
end;

procedure tJson2PumlConverterDefinition.SetAttributeProperties (const Value: tJson2PumlOperationPropertyList);
begin
  FAttributeProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetCharacteristicProperties
  (const Value: tJson2PumlCharacteristicDefinitionList);
begin
  FCharacteristicProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetContinueAfterUnhandledObjectsStr (const Value: string);
begin
  FContinueAfterUnhandledObjectsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetGroupDetailObjectsTogetherStr (const Value: string);
begin
  FGroupDetailObjectsTogetherStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetGroupProperties (const Value: tJson2PumlOperationPropertyList);
begin
  FGroupProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetHiddenProperties (const Value: tJson2PumlOperationPropertyList);
begin
  FHiddenProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetHideDuplicateRelationsStr (const Value: string);
begin
  FHideDuplicateRelationsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetIdentifyObjectsByTypeAndIdentStr (const Value: string);
begin
  FIdentifyObjectsByTypeAndIdentStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetLegendShowFileInfosStr (const Value: string);
begin
  FLegendShowFileInfosStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetLegendShowInfoStr (const Value: string);
begin
  FLegendShowInfoStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetLegendShowObjectFormatsStr (const Value: string);
begin
  FLegendShowObjectFormatsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectDetailProperties (const Value: tJson2PumlOperationPropertyList);
begin
  FObjectDetailProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectFormats (const Value: tJson2PumlFormatDefinition);
begin
  FObjectFormats.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectIdentifierProperties
  (const Value: tJson2PumlPropertyValueDefinitionList);
begin
  FObjectIdentifierProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectProperties (const Value: tJson2PumlObjectDefinitionList);
begin
  FObjectProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectTitleProperties (const Value: tJson2PumlPropertyValueDefinitionList);
begin
  FObjectTitleProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectTypeProperties (const Value: tJson2PumlPropertyValueDefinitionList);
begin
  FObjectTypeProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetObjectTypeRenames (const Value: tJson2PumlOperationPropertyList);
begin
  FObjectTypeRenames.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetOptionName (const Value: string);
begin
  FOptionName := Value.ToLower.Trim;
end;

procedure tJson2PumlConverterDefinition.SetPUMLHeaderLines (const Value: tJson2PumlOperationPropertyList);
begin
  FPUMLHeaderLines.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetRelationshipProperties (const Value: tJson2PumlOperationPropertyList);
begin
  FRelationshipProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetRelationshipTypeArrowFormats
  (const Value: tJson2PumlRelationshipTypeArrowFormatList);
begin
  FRelationshipTypeArrowFormats.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.SetRelationshipTypeProperties
  (const Value: tJson2PumlPropertyValueDefinitionList);
begin
  FRelationshipTypeProperties.Assign (Value);
end;

procedure tJson2PumlConverterDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  Level: Integer;
  PropertyName: string;
  WriteEmpty: boolean;
begin
  if not OptionName.IsEmpty then
  begin
    WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
    WriteToJsonValue (oJsonOutPut, 'option', OptionName, iLevel + 1, iWriteEmpty);
    PropertyName := 'definition';
    Level := iLevel + 1;
    WriteEmpty := iWriteEmpty;
  end
  else
  begin
    PropertyName := iPropertyName;
    Level := iLevel;
    WriteEmpty := true;
  end;

  WriteObjectStartToJson (oJsonOutPut, Level, PropertyName);

  WriteToJsonValue (oJsonOutPut, 'continueAfterUnhandledObjects', ContinueAfterUnhandledObjectsStr, Level + 1,
    WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'groupDetailObjectsTogether', GroupDetailObjectsTogetherStr, Level + 1,
    WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'hideDuplicateRelations', HideDuplicateRelationsStr, Level + 1, WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'identifyObjectsByTypeAndIdent', IdentifyObjectsByTypeAndIdentStr, Level + 1,
    WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'legendShowInfo', LegendShowInfoStr, Level + 1, WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'legendShowObjectFormats', LegendShowObjectFormatsStr, Level + 1, WriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'legendShowFileInfos', LegendShowFileInfosStr, Level + 1, WriteEmpty, false);
  AttributeProperties.WriteToJson (oJsonOutPut, 'attributeProperties', Level + 1, WriteEmpty);
  ObjectProperties.WriteToJson (oJsonOutPut, 'objectProperties', Level + 1, WriteEmpty);
  ObjectTypeProperties.WriteToJson (oJsonOutPut, 'objectTypeProperties', Level + 1, WriteEmpty);
  ObjectTypeRenames.WriteToJson (oJsonOutPut, 'objectTypeRenames', Level + 1, WriteEmpty);
  ObjectIdentifierProperties.WriteToJson (oJsonOutPut, 'objectIdentifierProperties', Level + 1, WriteEmpty);
  ObjectTitleProperties.WriteToJson (oJsonOutPut, 'objectTitleProperties', Level + 1, WriteEmpty);
  ObjectDetailProperties.WriteToJson (oJsonOutPut, 'objectDetailProperties', Level + 1, WriteEmpty);
  RelationshipProperties.WriteToJson (oJsonOutPut, 'relationshipProperties', Level + 1, WriteEmpty);
  RelationshipTypeProperties.WriteToJson (oJsonOutPut, 'relationshipTypeProperties', Level + 1, WriteEmpty);
  RelationshipTypeArrowFormats.WriteToJson (oJsonOutPut, 'relationshipTypeArrowFormats', Level + 1, WriteEmpty);
  GroupProperties.WriteToJson (oJsonOutPut, 'groupProperties', Level + 1, WriteEmpty);
  CharacteristicProperties.WriteToJson (oJsonOutPut, 'characteristicProperties', Level + 1, WriteEmpty);
  HiddenProperties.WriteToJson (oJsonOutPut, 'hiddenProperties', Level + 1, WriteEmpty);
  PUMLHeaderLines.WriteToJson (oJsonOutPut, 'pumlHeaderLines', Level + 1, WriteEmpty);
  ObjectFormats.WriteToJson (oJsonOutPut, 'objectFormats', Level + 1, WriteEmpty);
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(Level)]));
  if not OptionName.IsEmpty then
  begin
    ClearJsonLastLineComma (oJsonOutPut);
    oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(iLevel)]));
  end;
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

constructor tJson2PumlOperationPropertyList.Create;
begin
  inherited Create;
  FOperation := jloMerge;
end;

procedure tJson2PumlOperationPropertyList.MergeWith (iMergeList: tJson2PumlOperationPropertyList);
var
  i, j: Integer;
begin
  if iMergeList = self then
    exit;
  OwnsObjects := false;
  if iMergeList.Operation = jloReplace then
    Clear;
  for i := 0 to iMergeList.Count - 1 do
  begin
    j := IndexOf (iMergeList[i]);
    if j < 0 then
    begin
      if (iMergeList.Objects[i] is tJson2PumlBaseObject) then
        AddBaseObject (tJson2PumlBaseObject(iMergeList.Objects[i]))
      else
        AddObject (iMergeList[i], iMergeList.Objects[i]);
    end
    else if Assigned (iMergeList.Objects[i]) and (iMergeList.Objects[i] is tJson2PumlBaseObject) and
      Assigned (Objects[j]) and (Objects[j] is tJson2PumlBaseObject) then
      tJson2PumlBaseObject (Objects[j]).MergeWith (tJson2PumlBaseObject(iMergeList.Objects[i]))
    else if not Assigned (Objects[j]) then
      Objects[j] := iMergeList.Objects[i];
  end;
end;

function tJson2PumlOperationPropertyList.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  JsonValue: TJSONValue;
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  if not Assigned (iJsonValue) then
    exit;
  if iJsonValue is TJSONArray then
    JsonValue := iJsonValue
  else if iJsonValue is TJSONObject then
    JsonValue := TJSONObject (iJsonValue).Values[iPropertyName]
  else
    exit;
  if not Assigned (JsonValue) then
    exit;
  Result := true;
  if JsonValue is TJSONArray then
    inherited ReadFromJson (JsonValue, iPropertyName)
  else if JsonValue is TJSONObject then
  begin
    DefinitionRecord := TJSONObject (JsonValue);
    Operation.FromString (GetJsonStringValue(DefinitionRecord, 'operation'));
    inherited ReadFromJson (DefinitionRecord, 'list');
  end;
end;

procedure tJson2PumlOperationPropertyList.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  if (Count <= 0) and (Operation = jloMerge) and not iWriteEmpty then
    exit;
  if Operation = jloMerge then
    inherited WriteToJson (oJsonOutPut, iPropertyName, iLevel, iWriteEmpty)
  else
  begin
    oJsonOutPut.Add (Format('%s%s {', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName)]));
    WriteToJsonValue (oJsonOutPut, 'operation', Operation.ToString, iLevel + 1, iWriteEmpty);
    inherited WriteToJson (oJsonOutPut, 'list', iLevel + 1, iWriteEmpty);
    WriteObjectEndToJson (oJsonOutPut, iLevel);
  end;
end;

constructor tJson2PumlPropertyValueDefinitionList.Create;
begin
  inherited;
  OwnsObjects := true;
end;

procedure tJson2PumlPropertyValueDefinitionList.AddDefinition (iPropertyName, iChildPropertyName,
  iNextValueSeparator: string);
var
  intDefinition: tJson2PumlPropertyValueDefinition;
begin
  intDefinition := tJson2PumlPropertyValueDefinition.Create;
  intDefinition.PropertyName := iPropertyName;
  intDefinition.ChildPropertyName := iChildPropertyName;
  intDefinition.NextValueSeparator := iNextValueSeparator;
  AddBaseObject (intDefinition);
end;

procedure tJson2PumlPropertyValueDefinitionList.Assign (Source: tPersistent);
var
  intDefinition: tJson2PumlPropertyValueDefinition;
begin
  if Source is tJson2PumlPropertyValueDefinitionList then
  begin
    Clear;
    for intDefinition in tJson2PumlPropertyValueDefinitionList (Source) do
      AddDefinition (intDefinition.PropertyName, intDefinition.ChildPropertyName, intDefinition.NextValueSeparator);
  end;
end;

function tJson2PumlPropertyValueDefinitionList.GetDefinition (Index: Integer): tJson2PumlPropertyValueDefinition;
begin
  Result := tJson2PumlPropertyValueDefinition (Objects[index]);
end;

function tJson2PumlPropertyValueDefinitionList.GetDefinitionByName (iPropertyName, iParentPropertyName,
  iParentObjectType, iConfigurationPropertyName: string; var oFoundCondition: string; iUseMatch: boolean = false;
  iSearchEmpyAsDefault: boolean = false): tJson2PumlPropertyValueDefinition;
var
  i: Integer;
begin
  i := IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, iConfigurationPropertyName,
    oFoundCondition, true, false);
  if i >= 0 then
    Result := Definition[i]
  else
    Result := nil;
end;

function tJson2PumlPropertyValueDefinitionList.GetEnumerator: tJson2PumlPropertyValueDefinitionEnumerator;
begin
  Result := tJson2PumlPropertyValueDefinitionEnumerator.Create (self);
end;

procedure tJson2PumlPropertyValueDefinitionList.ReadListValueFromJson (iJsonValue: TJSONValue);
var
  DefinitionRecord: TJSONObject;
  PropertyName: string;
  ChildPropertyName: string;
  NextValueSeparator: string;
begin
  if iJsonValue is TJSONObject then
  begin
    DefinitionRecord := TJSONObject (iJsonValue);
    PropertyName := GetJsonStringValue (DefinitionRecord, 'propertyName');
    ChildPropertyName := GetJsonStringArray (DefinitionRecord, 'childPropertyName');
    NextValueSeparator := GetJsonStringArray (DefinitionRecord, 'nextValueSeparator');
    AddDefinition (PropertyName, ChildPropertyName, NextValueSeparator);
  end
  else if iJsonValue is TJSONString then
  begin
    PropertyName := TJSONString (iJsonValue).Value;
    if PropertyName.IndexOf ('=') > 0 then
      AddDefinition (PropertyName.Substring(0, PropertyName.IndexOf('=')),
        PropertyName.Substring(PropertyName.IndexOf('=') + 1), '')
    else
      AddDefinition (PropertyName, '', '');
  end;
end;

constructor tJson2PumlPropertyValueDefinitionEnumerator.Create (AObjectList: tJson2PumlPropertyValueDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := AObjectList;
end;

function tJson2PumlPropertyValueDefinitionEnumerator.GetCurrent: tJson2PumlPropertyValueDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlPropertyValueDefinitionEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlObjectDefinitionList.Create;
begin
  inherited;
  OwnsObjects := true;
end;

procedure tJson2PumlObjectDefinitionList.AddDefinition (iObjectName: string; iGenerateWithoutIdentifier: boolean);
var
  intDefinition: tJson2PumlObjectDefinition;
begin
  intDefinition := tJson2PumlObjectDefinition.Create;
  intDefinition.ObjectName := iObjectName;
  intDefinition.GenerateWithoutIdentifier := iGenerateWithoutIdentifier;
  AddBaseObject (intDefinition);
end;

procedure tJson2PumlObjectDefinitionList.Assign (Source: tPersistent);
var
  intDefinition: tJson2PumlObjectDefinition;
begin
  if Source is tJson2PumlObjectDefinitionList then
  begin
    Clear;
    for intDefinition in tJson2PumlObjectDefinitionList (Source) do
      AddDefinition (intDefinition.ObjectName, intDefinition.GenerateWithoutIdentifier);
  end;
end;

function tJson2PumlObjectDefinitionList.GetDefinition (Index: Integer): tJson2PumlObjectDefinition;
begin
  Result := tJson2PumlObjectDefinition (Objects[index]);
end;

function tJson2PumlObjectDefinitionList.GetDefinitionByName (iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): tJson2PumlObjectDefinition;
var
  i: Integer;
begin
  i := IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, 'objectProperties', oFoundCondition,
    true, false);
  if i >= 0 then
    Result := Definition[i]
  else
    Result := nil;
end;

function tJson2PumlObjectDefinitionList.GetEnumerator: tJson2PumlObjectDefinitionEnumerator;
begin
  Result := tJson2PumlObjectDefinitionEnumerator.Create (self);
end;

procedure tJson2PumlObjectDefinitionList.ReadListValueFromJson (iJsonValue: TJSONValue);
var
  DefinitionRecord: TJSONObject;
  ObjectName: string;
  GenerateWithoutIdentifier: boolean;
begin
  if iJsonValue is TJSONObject then
  begin
    DefinitionRecord := TJSONObject (iJsonValue);
    ObjectName := GetJsonStringValue (DefinitionRecord, 'objectName');
    GenerateWithoutIdentifier := GetJsonStringValueBoolean (DefinitionRecord, 'generateWithoutIdentifier', false);
    AddDefinition (ObjectName, GenerateWithoutIdentifier);
  end
  else if iJsonValue is TJSONString then
  begin
    ObjectName := TJSONString (iJsonValue).Value;
    AddDefinition (ObjectName, false);
  end;
end;

constructor tJson2PumlObjectDefinitionEnumerator.Create (AObjectList: tJson2PumlObjectDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := AObjectList;
end;

function tJson2PumlObjectDefinitionEnumerator.GetCurrent: tJson2PumlObjectDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlObjectDefinitionEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlSingleFormatDefinition.Create;
begin
  inherited Create;
  FSkinParams := tStringList.Create ();
  FObjectFilter := tStringList.Create;
end;

destructor tJson2PumlSingleFormatDefinition.Destroy;
begin
  FObjectFilter.Free;
  FSkinParams.Free;
  inherited Destroy;
end;

procedure tJson2PumlSingleFormatDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlSingleFormatDefinition then
  begin
    FormatName := tJson2PumlSingleFormatDefinition (Source).FormatName;
    ObjectFilter.Assign (tJson2PumlSingleFormatDefinition(Source).ObjectFilter);
    IconColor := tJson2PumlSingleFormatDefinition (Source).IconColor;
    SkinParams.Text := tJson2PumlSingleFormatDefinition (Source).SkinParams.Text;
    CaptionSplitLengthStr := tJson2PumlSingleFormatDefinition (Source).CaptionSplitLengthStr;
    CaptionSplitCharacter := tJson2PumlSingleFormatDefinition (Source).CaptionSplitCharacter;
    CaptionShowIdentStr := tJson2PumlSingleFormatDefinition (Source).CaptionShowIdentStr;
    CaptionShowTitleStr := tJson2PumlSingleFormatDefinition (Source).CaptionShowTitleStr;
    CaptionShowTypeStr := tJson2PumlSingleFormatDefinition (Source).CaptionShowTypeStr;
    ShowCharacteristicsStr := tJson2PumlSingleFormatDefinition (Source).ShowCharacteristicsStr;
    ShowAttributesStr := tJson2PumlSingleFormatDefinition (Source).ShowAttributesStr;
    ShowIfEmptyStr := tJson2PumlSingleFormatDefinition (Source).ShowIfEmptyStr;
    ShowFromRelationsStr := tJson2PumlSingleFormatDefinition (Source).ShowFromRelationsStr;
    ShowNullValuesStr := tJson2PumlSingleFormatDefinition (Source).ShowNullValuesStr;
    ShowToRelationsStr := tJson2PumlSingleFormatDefinition (Source).ShowToRelationsStr;
    SortAttributesStr := tJson2PumlSingleFormatDefinition (Source).SortAttributesStr;
    ValueSplitLengthStr := tJson2PumlSingleFormatDefinition (Source).ValueSplitLengthStr;
  end;
end;

procedure tJson2PumlSingleFormatDefinition.Clear;
begin
  inherited;
  CaptionShowIdentStr := '';
  CaptionShowTitleStr := '';
  CaptionShowTypeStr := '';
  CaptionSplitLengthStr := '';
  CaptionSplitCharacter := '';
  ShowCharacteristicsStr := '';
  ShowAttributesStr := '';
  ShowIfEmptyStr := '';
  ShowFromRelationsStr := '';
  ShowToRelationsStr := '';
  SortAttributesStr := '';
  FormatName := '';
  IconColor := '';
  ValueSplitLengthStr := '';
  ObjectFilter.Clear;
  SkinParams.Clear;
end;

function tJson2PumlSingleFormatDefinition.GetCaptionShowIdent: boolean;
begin
  Result := StringToBoolean (CaptionShowIdentStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetCaptionShowTitle: boolean;
begin
  Result := StringToBoolean (CaptionShowTitleStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetCaptionShowType: boolean;
begin
  Result := StringToBoolean (CaptionShowTypeStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetCaptionSplitLength: Integer;
begin
  if CaptionSplitLengthStr.IsEmpty then
    Result := 0
  else
    Result := CaptionSplitLengthStr.ToInteger;
end;

function tJson2PumlSingleFormatDefinition.GetValueSplitLength: Integer;
begin
  if ValueSplitLengthStr.IsEmpty then
    Result := 0
  else
    Result := ValueSplitLengthStr.ToInteger;
end;

function tJson2PumlSingleFormatDefinition.GetIdent: string;
begin
  Result := FormatName;
end;

function tJson2PumlSingleFormatDefinition.GetShowAttributes: boolean;
begin
  Result := StringToBoolean (ShowAttributesStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetShowCharacteristics: boolean;
begin
  Result := StringToBoolean (ShowCharacteristicsStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetShowFromRelations: boolean;
begin
  Result := StringToBoolean (ShowFromRelationsStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetShowIfEmpty: boolean;
begin
  Result := StringToBoolean (ShowIfEmptyStr, false);
end;

function tJson2PumlSingleFormatDefinition.GetShowToRelations: boolean;
begin
  Result := StringToBoolean (ShowToRelationsStr, true);
end;

function tJson2PumlSingleFormatDefinition.GetIsFilled: boolean;
begin
  Result := not CaptionShowIdentStr.IsEmpty or not CaptionShowTitleStr.IsEmpty or not CaptionShowTypeStr.IsEmpty or
    not CaptionSplitCharacter.IsEmpty or not CaptionSplitLengthStr.IsEmpty or not IconColor.IsEmpty or
    not (ObjectFilter.Count > 0) or not ShowAttributesStr.IsEmpty or not ShowCharacteristicsStr.IsEmpty or
    not ShowIfEmptyStr.IsEmpty or not ShowFromRelationsStr.IsEmpty or not ShowNullValuesStr.IsEmpty or
    not ShowToRelationsStr.IsEmpty or not SortAttributesStr.IsEmpty or (SkinParams.Count > 0) or
    not ValueSplitLengthStr.IsEmpty;
end;

function tJson2PumlSingleFormatDefinition.GetShowNullValues: boolean;
begin
  Result := StringToBoolean (ShowNullValuesStr, false);
end;

function tJson2PumlSingleFormatDefinition.GetSortAttributes: boolean;
begin
  Result := StringToBoolean (SortAttributesStr, true);
end;

procedure tJson2PumlSingleFormatDefinition.MergeWith (iMergeDefinition: tJson2PumlBaseObject);
var
  Definition: tJson2PumlSingleFormatDefinition;
begin
  if (iMergeDefinition = self) or not (iMergeDefinition is tJson2PumlSingleFormatDefinition) then
    exit;
  Definition := tJson2PumlSingleFormatDefinition (iMergeDefinition);
  CaptionShowIdentStr := MergeValue (CaptionShowIdentStr, Definition.CaptionShowIdentStr);
  CaptionShowTitleStr := MergeValue (CaptionShowTitleStr, Definition.CaptionShowTitleStr);
  CaptionShowTypeStr := MergeValue (CaptionShowTypeStr, Definition.CaptionShowTypeStr);
  CaptionSplitCharacter := MergeValue (CaptionSplitCharacter, Definition.CaptionSplitCharacter);
  CaptionSplitLengthStr := MergeValue (CaptionSplitLengthStr, Definition.CaptionSplitLengthStr);
  FormatName := MergeValue (FormatName, Definition.FormatName);
  IconColor := MergeValue (IconColor, Definition.IconColor);
  if Definition.ObjectFilter.Count > 0 then
    ObjectFilter.Assign (Definition.ObjectFilter);
  ShowAttributesStr := MergeValue (ShowAttributesStr, Definition.ShowAttributesStr);
  ShowCharacteristicsStr := MergeValue (ShowCharacteristicsStr, Definition.ShowCharacteristicsStr);
  ShowFromRelationsStr := MergeValue (ShowFromRelationsStr, Definition.ShowFromRelationsStr);
  ShowIfEmptyStr := MergeValue (ShowIfEmptyStr, Definition.ShowIfEmptyStr);
  ShowNullValuesStr := MergeValue (ShowNullValuesStr, Definition.ShowNullValuesStr);
  ShowToRelationsStr := MergeValue (ShowToRelationsStr, Definition.ShowToRelationsStr);
  SortAttributesStr := MergeValue (SortAttributesStr, Definition.SortAttributesStr);
  if Definition.ObjectFilter.Count > 0 then
    SkinParams.Assign (Definition.SkinParams);
  ValueSplitLengthStr := MergeValue (ValueSplitLengthStr, Definition.ValueSplitLengthStr);
end;

function tJson2PumlSingleFormatDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Result := true;
  if ExistsJsonProperty (DefinitionRecord, 'definition') and ExistsJsonProperty (DefinitionRecord, 'formatName') then
  begin
    FormatName := GetJsonStringValue (DefinitionRecord, 'formatName');
    DefinitionRecord := GetJsonObject (DefinitionRecord, 'definition');
  end;
  CaptionShowIdentStr := GetJsonStringValueBoolean (DefinitionRecord, 'captionShowIdent', '');
  CaptionShowTitleStr := GetJsonStringValueBoolean (DefinitionRecord, 'captionShowTitle', '');
  CaptionShowTypeStr := GetJsonStringValueBoolean (DefinitionRecord, 'captionShowType', '');
  CaptionSplitCharacter := GetJsonStringValue (DefinitionRecord, 'captionSplitCharacter', '');
  CaptionSplitLengthStr := GetJsonStringValue (DefinitionRecord, 'captionSplitLength', '');
  IconColor := GetJsonStringValue (DefinitionRecord, 'iconColor');
  ObjectFilter.Text := GetJsonStringArray (DefinitionRecord, 'objectFilter');
  ShowAttributesStr := GetJsonStringValueBoolean (DefinitionRecord, 'showAttributes', '');
  ShowCharacteristicsStr := GetJsonStringValueBoolean (DefinitionRecord, 'showCharacteristics', '');
  ShowFromRelationsStr := GetJsonStringValueBoolean (DefinitionRecord, 'showFromRelations', '');
  ShowIfEmptyStr := GetJsonStringValueBoolean (DefinitionRecord, 'showIfEmpty', '');
  ShowNullValuesStr := GetJsonStringValueBoolean (DefinitionRecord, 'showNullValues', '');
  ShowToRelationsStr := GetJsonStringValueBoolean (DefinitionRecord, 'showToRelations', '');
  SortAttributesStr := GetJsonStringValueBoolean (DefinitionRecord, 'sortAttributes', '');
  SkinParams.Text := GetJsonStringArray (DefinitionRecord, 'skinParams');
  ValueSplitLengthStr := GetJsonStringValue (DefinitionRecord, 'valueSplitLength', '');
end;

procedure tJson2PumlSingleFormatDefinition.SetCaptionShowIdentStr (const Value: string);
begin
  FCaptionShowIdentStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetCaptionShowTitleStr (const Value: string);
begin
  FCaptionShowTitleStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetCaptionShowTypeStr (const Value: string);
begin
  FCaptionShowTypeStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowAttributesStr (const Value: string);
begin
  FShowAttributesStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetSortAttributesStr (const Value: string);
begin
  FSortAttributesStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowCharacteristicsStr (const Value: string);
begin
  FShowCharacteristicsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowFromRelationsStr (const Value: string);
begin
  FShowFromRelationsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowIfEmptyStr (const Value: string);
begin
  FShowIfEmptyStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowNullValuesStr (const Value: string);
begin
  FShowNullValuesStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetShowToRelationsStr (const Value: string);
begin
  FShowToRelationsStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlSingleFormatDefinition.SetSkinParams (const Value: tStringList);
begin
  FSkinParams := Value;
end;

procedure tJson2PumlSingleFormatDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  Level: Integer;
  PropertyName: string;
begin
  if not IsFilled then
    exit;
  if not FormatName.IsEmpty then
  begin
    WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
    WriteToJsonValue (oJsonOutPut, 'formatName', FormatName, iLevel + 1, iWriteEmpty);
    PropertyName := 'definition';
    Level := iLevel + 1;
  end
  else
  begin
    PropertyName := iPropertyName;
    Level := iLevel;
  end;

  WriteObjectStartToJson (oJsonOutPut, Level, PropertyName);
  WriteToJsonValue (oJsonOutPut, 'objectFilter', ObjectFilter, Level + 1, true, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'iconColor', IconColor, Level + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'skinParams', SkinParams, Level + 1, true, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'captionShowIdent', CaptionShowIdentStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'captionShowTitle', CaptionShowTitleStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'captionShowType', CaptionShowTypeStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'captionSplitCharacter', CaptionSplitCharacter, Level + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'captionSplitLength', CaptionSplitLengthStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showAttributes', ShowAttributesStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showCharacteristics', ShowCharacteristicsStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showFromRelations', ShowFromRelationsStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showIfEmpty', ShowIfEmptyStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showNullValues', ShowNullValuesStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'showToRelations', ShowToRelationsStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'sortAttributes', SortAttributesStr, Level + 1, iWriteEmpty, false);
  WriteToJsonValue (oJsonOutPut, 'valueSplitLength', ValueSplitLengthStr, Level + 1, iWriteEmpty, false);
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(Level)]));
  if not FormatName.IsEmpty then
  begin
    ClearJsonLastLineComma (oJsonOutPut);
    oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(iLevel)]));
  end;
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

constructor tJson2PumlFormatDefinitionEnumerator.Create (ACharacteristicList: tJson2PumlFormatDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := ACharacteristicList;
end;

function tJson2PumlFormatDefinitionEnumerator.GetCurrent: tJson2PumlSingleFormatDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlFormatDefinitionEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlFormatDefinitionList.Create;
begin
  inherited;
  OwnsObjects := true;
end;

procedure tJson2PumlFormatDefinitionList.AddDefinition (iDefinition: tJson2PumlSingleFormatDefinition);
begin
  AddBaseObject (iDefinition);
end;

procedure tJson2PumlFormatDefinitionList.Assign (Source: tPersistent);
var
  NewDefinition, intDefinition: tJson2PumlSingleFormatDefinition;
begin
  if Source is tJson2PumlFormatDefinitionList then
  begin
    Clear;
    for intDefinition in tJson2PumlFormatDefinitionList (Source) do
    begin
      NewDefinition := tJson2PumlSingleFormatDefinition.Create;
      NewDefinition.Assign (intDefinition);
      AddDefinition (NewDefinition);
    end;
  end;
end;

function tJson2PumlFormatDefinitionList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := tJson2PumlSingleFormatDefinition.Create;
end;

procedure tJson2PumlFormatDefinitionList.GeneratePuml (ipuml: TStrings);
var
  i: Integer;
  ObjectName: string;
  Color: tJson2PumlSingleFormatDefinition;

begin
  if Count < 0 then
    exit;
  ipuml.Add ('skinparam class {');
  for Color in self do
  begin
    if Color.FormatName.IsEmpty then
      ObjectName := ''
    else
      ObjectName := Format ('<<%s>>', [Color.FormatName.ToLower]);
    for i := 0 to Color.SkinParams.Count - 1 do
      if not Color.SkinParams.ValueFromIndex[i].IsEmpty then
        ipuml.Add (Format('%s%s %s', [Color.SkinParams.Names[i], ObjectName, Color.SkinParams.ValueFromIndex[i]]));
  end;
  ipuml.Add ('}');
  ipuml.Add ('');
end;

function tJson2PumlFormatDefinitionList.GetDefinition (Index: Integer): tJson2PumlSingleFormatDefinition;
begin
  Result := tJson2PumlSingleFormatDefinition (Objects[index]);
end;

function tJson2PumlFormatDefinitionList.GetDefinitionByName (iPropertyName, iParentPropertyName: string;
  var oPriority: Integer; var oFoundCondition: string): tJson2PumlSingleFormatDefinition;
var
  S: string;
  Search: string;
  FormatDefinition: tJson2PumlSingleFormatDefinition;
  i: Integer;
  l1, l2, l3: Integer;
begin
  Result := nil;
  oFoundCondition := '';
  l1 := 0;
  l2 := 0;
  l3 := 0;
  try
    for i := 1 to 2 do
    begin
      Inc (l1);
      l2 := 0;
      if i = 1 then
        Search := iPropertyName
      else
        Search := iParentPropertyName + '.' + iPropertyName;
      for FormatDefinition in self do
      begin
        Inc (l2);
        l3 := 0;
        if (FormatDefinition.ObjectFilter.Count <= 0) and not FormatDefinition.FormatName.IsEmpty then
        begin
          if MatchesMask (Search, FormatDefinition.FormatName) then
          begin
            oFoundCondition := BuildFoundCondition ('formats.formatName', Search, FormatDefinition.FormatName);
            Result := FormatDefinition;
            exit;
          end;
        end
        else
          for S in FormatDefinition.ObjectFilter do
          begin
            Inc (l3);
            if MatchesMask (Search, S) then
            begin
              oFoundCondition := BuildFoundCondition ('formats.definition.objectFilter', Search, S);
              Result := FormatDefinition;
              exit;
            end;
          end;
      end;
    end;
  finally
    oPriority := l3 + l2 * 1000 + l1 * 1000 * 1000;
  end;
end;

function tJson2PumlFormatDefinitionList.GetEnumerator: tJson2PumlFormatDefinitionEnumerator;
begin
  Result := tJson2PumlFormatDefinitionEnumerator.Create (self);
end;

constructor tJson2PumlFormatDefinition.Create;
begin
  inherited Create;
  FBaseFormat := tJson2PumlSingleFormatDefinition.Create ();
  FFormats := tJson2PumlFormatDefinitionList.Create ();
  FIntFormats := tJson2PumlFormatDefinitionList.Create ();
end;

destructor tJson2PumlFormatDefinition.Destroy;
begin
  FIntFormats.Free;
  FFormats.Free;
  FBaseFormat.Free;
  inherited Destroy;
end;

procedure tJson2PumlFormatDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlFormatDefinition then
  begin
    IntFormats.Assign (tJson2PumlFormatDefinition(Source).IntFormats);
    Formats.Assign (tJson2PumlFormatDefinition(Source).Formats);
    BaseFormat.Assign (tJson2PumlFormatDefinition(Source).BaseFormat);
  end;
end;

procedure tJson2PumlFormatDefinition.BuildFormatList;
var
  Format, NewFormat: tJson2PumlSingleFormatDefinition;
begin
  Formats.Clear;
  for Format in IntFormats do
  begin
    NewFormat := tJson2PumlSingleFormatDefinition.Create;
    NewFormat.Assign (BaseFormat);
    NewFormat.MergeWith (Format);
    Formats.AddDefinition (NewFormat);
  end;
end;

procedure tJson2PumlFormatDefinition.Clear;
begin
  BaseFormat.Clear;
  IntFormats.Clear;
  Formats.Clear;
end;

function tJson2PumlFormatDefinition.GetFormatByName (iPropertyName, iParentPropertyName: string; var oPriority: Integer;
  var oFoundCondition: string): tJson2PumlSingleFormatDefinition;
begin
  Result := Formats.GetDefinitionByName (iPropertyName, iParentPropertyName, oPriority, oFoundCondition);
  if not Assigned (Result) then
  begin
    Result := BaseFormat;
    oPriority := 9999999;
    oFoundCondition := '<default>';
  end;
end;

function tJson2PumlFormatDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlFormatDefinition.GetIsFilled: boolean;
begin
  Result := BaseFormat.IsFilled or Formats.IsFilled;
end;

procedure tJson2PumlFormatDefinition.MergeWith (iMergeDefinition: tJson2PumlBaseObject);
var
  Definition: tJson2PumlFormatDefinition;
begin
  if (iMergeDefinition = self) or not (iMergeDefinition is tJson2PumlFormatDefinition) then
    exit;
  Definition := tJson2PumlFormatDefinition (iMergeDefinition);
  BaseFormat.MergeWith (Definition.BaseFormat);
  IntFormats.MergeWith (Definition.IntFormats);
  BuildFormatList;
end;

function tJson2PumlFormatDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Result := BaseFormat.ReadFromJson (DefinitionRecord, 'baseFormat');
  IntFormats.ReadFromJson (DefinitionRecord, 'formats');
  BuildFormatList;
end;

procedure tJson2PumlFormatDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  if not IsFilled then
    exit;
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  BaseFormat.WriteToJson (oJsonOutPut, 'baseFormat', iLevel + 1, iWriteEmpty);
  IntFormats.WriteToJson (oJsonOutPut, 'formats', iLevel + 1, false);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlCharacteristicDefinitionEnumerator.Create (ACharacteristicList
  : tJson2PumlCharacteristicDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := ACharacteristicList;
end;

function tJson2PumlCharacteristicDefinitionEnumerator.GetCurrent: tJson2PumlCharacteristicDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlCharacteristicDefinitionEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlCharacteristicDefinitionList.Create;
begin
  inherited;
  OwnsObjects := true;
end;

procedure tJson2PumlCharacteristicDefinitionList.AddDefinition (iParentProperty: string;
  iCharacteristicType: tJson2PumlCharacteristicType; iPropertyList: tStringList = nil; iIncludeIndex: string = '');
var
  intDefinition: tJson2PumlCharacteristicDefinition;
  i: Integer;
begin
  if iParentProperty.IsEmpty then
    exit;
  i := IndexOf (iParentProperty);
  if i < 0 then
  begin
    intDefinition := tJson2PumlCharacteristicDefinition.Create;
    intDefinition.ParentProperty := iParentProperty;
    AddBaseObject (intDefinition);
  end
  else
    intDefinition := Definition[i];
  if Assigned (iPropertyList) then
    intDefinition.PropertyList.Assign (iPropertyList);
  intDefinition.IncludeIndexStr := iIncludeIndex;
  intDefinition.CharacteristicType := iCharacteristicType;
end;

procedure tJson2PumlCharacteristicDefinitionList.Assign (Source: tPersistent);
var
  intDefinition: tJson2PumlCharacteristicDefinition;
begin
  if Source is tJson2PumlCharacteristicDefinitionList then
  begin
    Clear;
    for intDefinition in tJson2PumlCharacteristicDefinitionList (Source) do
      AddDefinition (intDefinition.ParentProperty, intDefinition.CharacteristicType, intDefinition.PropertyList,
        intDefinition.IncludeIndexStr);
  end;
end;

function tJson2PumlCharacteristicDefinitionList.GetDefinition (Index: Integer): tJson2PumlCharacteristicDefinition;
begin
  Result := tJson2PumlCharacteristicDefinition (Objects[index]);
end;

function tJson2PumlCharacteristicDefinitionList.GetDefinitionByName (iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): tJson2PumlCharacteristicDefinition;
var
  i: Integer;
begin
  i := IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, 'characteristicProperties',
    oFoundCondition, true);
  if i >= 0 then
    Result := Definition[i]
  else
    Result := nil;
end;

function tJson2PumlCharacteristicDefinitionList.GetEnumerator: tJson2PumlCharacteristicDefinitionEnumerator;
begin
  Result := tJson2PumlCharacteristicDefinitionEnumerator.Create (self);
end;

procedure tJson2PumlCharacteristicDefinitionList.ReadListValueFromJson (iJsonValue: TJSONValue);
var
  DefinitionRecord: TJSONObject;
  ListProperties: tStringList;
  TempList: tStringList;
  ParentProperty, IncludeIndex: string;
  cType: tJson2PumlCharacteristicType;
begin
  if iJsonValue is TJSONObject then
  begin
    ListProperties := tStringList.Create;
    TempList := tStringList.Create;
    try
      DefinitionRecord := TJSONObject (iJsonValue);
      ParentProperty := GetJsonStringValue (DefinitionRecord, 'parentProperty');
      cType.FromString (GetJsonStringValue(DefinitionRecord, 'type'));

      if ParentProperty.IsEmpty then
        exit;
      GetJsonStringValueList (ListProperties, DefinitionRecord, 'propertyList');
      if ListProperties.Count <= 0 then // Compatibility to old structure
      begin
        GetJsonStringValueList (TempList, DefinitionRecord, 'nameProperty');
        ListProperties.AddStrings (TempList);
        GetJsonStringValueList (TempList, DefinitionRecord, 'valueProperty');
        ListProperties.AddStrings (TempList);
        GetJsonStringValueList (TempList, DefinitionRecord, 'infoProperty');
        ListProperties.AddStrings (TempList);
      end;
      IncludeIndex := GetJsonStringArray (DefinitionRecord, 'includeIndex');
      AddDefinition (ParentProperty, cType, ListProperties, IncludeIndex);
    finally
      ListProperties.Free;
      TempList.Free;
    end;
  end
  else if iJsonValue is TJSONString then
  begin
    ParentProperty := TJSONString (iJsonValue).Value;
    AddDefinition (ParentProperty, jctRecord);
  end;
end;

constructor tJson2PumlCharacteristicDefinition.Create;
begin
  inherited Create;
  FCharacteristicType := jctList;
  FPropertyList := tStringList.Create ();
end;

destructor tJson2PumlCharacteristicDefinition.Destroy;
begin
  FPropertyList.Free;
  inherited Destroy;
end;

procedure tJson2PumlCharacteristicDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlCharacteristicDefinition then
  begin
    CharacteristicType := tJson2PumlCharacteristicDefinition (Source).CharacteristicType;
    ParentProperty := tJson2PumlCharacteristicDefinition (Source).ParentProperty;
    PropertyList.Text := tJson2PumlCharacteristicDefinition (Source).PropertyList.Text;
  end;
end;

function tJson2PumlCharacteristicDefinition.GetIdent: string;
begin
  Result := ParentProperty;
end;

function tJson2PumlCharacteristicDefinition.GetIncludeIndex: boolean;
begin
  Result := StringToBoolean (IncludeIndexStr, false);
end;

function tJson2PumlCharacteristicDefinition.GetIsValid: boolean;
begin
  Result := not (ParentProperty.IsEmpty);
end;

function tJson2PumlCharacteristicDefinition.IsPropertyAllowed (iPropertyName, iParentPropertyName: string;
  var oFoundCondition: string): boolean;
var
  S: string;
  PropNameCombi: string;
  OnlyNegative: boolean;
  Negative: boolean;
  l: Integer;
begin
  if PropertyList.Count <= 0 then
  begin
    oFoundCondition := 'propertyList empty';
    Result := true
  end
  else
  begin
    Result := false;
    PropNameCombi := string.Join ('.', [iParentPropertyName, iPropertyName]).TrimLeft (['.']);
    OnlyNegative := true;
    for l := 0 to 1 do
    begin
      for S in PropertyList do
      begin
        if S.IsEmpty then
          continue;
        Negative := (S.Substring(0, 1) = '-');
        OnlyNegative := OnlyNegative and Negative;
        if (l = 0) and Negative then
        begin
          if MatchesMask ('-' + iPropertyName, S) then
          begin
            oFoundCondition := Format ('propertyList exclude "%s"', [S]);
            Result := false;
            exit;
          end;
        end
        else if (l = 1) and not Negative then
        begin
          if MatchesMask (iPropertyName, S) then
          begin
            oFoundCondition := Format ('propertyList include "%s"', [S]);
            Result := true;
            exit;
          end;
        end;
      end;
      if not Result and OnlyNegative then
      begin
        oFoundCondition := 'propertyList contains only exclude';
        Result := true;
      end;
    end;
  end;
end;

procedure tJson2PumlCharacteristicDefinition.SetIncludeIndexStr (const Value: string);
begin
  FIncludeIndexStr := ValidateBooleanInput (Value);
end;

procedure tJson2PumlCharacteristicDefinition.SortUsedColumnsByPropertyList (iUsedColumns: tStringList);
var
  i: Integer;
  col: string;
  j: Integer;
begin
  i := 0;
  for col in PropertyList do
  begin
    j := iUsedColumns.IndexOf (col);
    if j >= 0 then
    begin
      iUsedColumns.Move (j, i);
      Inc (i);
    end;
  end;
end;

procedure tJson2PumlCharacteristicDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  Value: string;
  IsRecord: boolean;
begin
  IsRecord := true;
  if (CharacteristicType = jctRecord) and (not IncludeIndex) and (PropertyList.Count <= 0) then
  begin
    Value := ClearPropertyValue (ParentProperty);
    IsRecord := false;
  end
  else
    Value := JsonAttributeValue ('parentProperty', ParentProperty) + JsonAttributeValue ('type',
      CharacteristicType.ToString) + JsonAttributeValueList ('propertyList', PropertyList) +
      JsonAttributeValue ('includeIndex', IncludeIndexStr, false);
  if IsRecord then
    Value := Format ('{%s}', [Value.trimRight([',', ' '])])
  else
    Value := Format ('"%s"', [Value]);
  oJsonOutPut.Add (Format('%s%s%s,', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName), Value]));
end;

procedure tJson2PumlObjectDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlObjectDefinition then
  begin
    ObjectName := tJson2PumlObjectDefinition (Source).ObjectName;
    GenerateWithoutIdentifier := tJson2PumlObjectDefinition (Source).GenerateWithoutIdentifier;
  end;
end;

function tJson2PumlObjectDefinition.GetIdent: string;
begin
  Result := ObjectName;
end;

procedure tJson2PumlObjectDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  if not GenerateWithoutIdentifier then
    oJsonOutPut.Add (Format('%s%s"%s",', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName),
      ClearPropertyValue(ObjectName)]))
  else
    oJsonOutPut.Add (Format('%s%s{%s,%s},', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName),
      JsonPropertyNameValue('objectName', ObjectName), JsonPropertyNameValue('generateWithoutIdentifier',
      BooleanToString(GenerateWithoutIdentifier))]));
end;

constructor tJson2PumlConverterGroupDefinition.Create;
begin
  inherited Create;
  FBaseOption := tJson2PumlConverterDefinition.Create ();
  FOptionList := tJson2PumlConverterDefinitionList.Create ();
  FDescription := tJson2PumlConverterGroupDescriptionDefinition.Create ();
end;

destructor tJson2PumlConverterGroupDefinition.Destroy;
begin
  FDescription.Free;
  FOptionList.Free;
  FBaseOption.Free;
  inherited Destroy;
end;

procedure tJson2PumlConverterGroupDefinition.Clear;
begin
  OptionList.Clear;
  BaseOption.Clear;
end;

procedure tJson2PumlConverterGroupDefinition.FillDefinitionFromOption (iDefinition: tJson2PumlConverterDefinition;
  iOption: string);
var
  SourceDefinition: tJson2PumlConverterDefinition;
begin
  SourceDefinition := OptionByName[iOption];
  FillDefinitionFromOption (iDefinition, SourceDefinition);
end;

procedure tJson2PumlConverterGroupDefinition.FillDefinitionFromOption (iDefinition,
  iSourceDefinition: tJson2PumlConverterDefinition);
begin
  iDefinition.Assign (BaseOption);
  iDefinition.MergeWith (iSourceDefinition);
end;

function tJson2PumlConverterGroupDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlConverterGroupDefinition.GetIsValid: boolean;
begin
  Result := Description.IsValid and BaseOption.IsValid and OptionList.IsValid and OptionList.IsFilled;
end;

function tJson2PumlConverterGroupDefinition.GetOptionByName (name: string): tJson2PumlConverterDefinition;
var
  i: Integer;
begin
  if name.IsEmpty then
    name := DefaultOption;
  if name.IsEmpty then
    Result := BaseOption
  else
  begin
    i := OptionList.IndexOf (name);
    if i >= 0 then
      Result := Options[i]
    else
      Result := BaseOption;
  end;
end;

function tJson2PumlConverterGroupDefinition.GetOptionCount: Integer;
begin
  Result := OptionList.Count;
end;

function tJson2PumlConverterGroupDefinition.GetOptions (Index: Integer): tJson2PumlConverterDefinition;
begin
  Result := OptionList.Definition[index];
end;

function tJson2PumlConverterGroupDefinition.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  DefinitionRecord: TJSONObject;
begin
  Result := false;
  Clear;
  DefinitionRecord := GetJsonObject (iJsonValue, iPropertyName);
  if not Assigned (DefinitionRecord) then
    exit;
  Description.ReadFromJson (DefinitionRecord, 'description');
  DefaultOption := GetJsonStringValue (DefinitionRecord, 'defaultOption');
  Result := BaseOption.ReadFromJson (DefinitionRecord, 'baseOption');
  OptionList.ReadFromJson (DefinitionRecord, 'options');
end;

procedure tJson2PumlConverterGroupDefinition.SetDefaultOption (const Value: string);
begin
  FDefaultOption := Value.ToLower;
end;

procedure tJson2PumlConverterGroupDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  Description.WriteToJson (oJsonOutPut, 'description', iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'defaultOption', DefaultOption, iLevel + 1, iWriteEmpty);
  OptionList.WriteToJson (oJsonOutPut, 'options', iLevel + 1, iWriteEmpty);
  BaseOption.WriteToJson (oJsonOutPut, 'baseOption', iLevel + 1, true);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlConverterGroupDefinition.WriteToJsonServiceListResult (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
var
  OptionsSl: tStringList;
  i: Integer;
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'name', ExtractFileName(SourceFileName), iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'displayName', Description.DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description.Description, iLevel + 1, iWriteEmpty);
  OptionsSl := tStringList.Create;
  try
    for i := 0 to OptionList.Count - 1 do
      if Options[i].IsValid then
        OptionsSl.Add (Options[i].OptionName);
    WriteToJsonValue (oJsonOutPut, 'options', OptionsSl, iLevel + 1, false, iWriteEmpty);
  finally
    OptionsSl.Free;
  end;
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

constructor tJson2PumlConverterDefinitionEnumerator.Create (ACharacteristicList: tJson2PumlConverterDefinitionList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := ACharacteristicList;
end;

function tJson2PumlConverterDefinitionEnumerator.GetCurrent: tJson2PumlConverterDefinition;
begin
  Result := fObjectList[FIndex];
end;

function tJson2PumlConverterDefinitionEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

constructor tJson2PumlConverterDefinitionList.Create;
begin
  inherited;
  Sorted := true;
  Duplicates := dupIgnore;
  OwnsObjects := true;
end;

procedure tJson2PumlConverterDefinitionList.AddDefinition (iDefinition: tJson2PumlConverterDefinition);
begin
  AddBaseObject (iDefinition);
end;

procedure tJson2PumlConverterDefinitionList.Assign (Source: tPersistent);
var
  intDefinition: tJson2PumlConverterDefinition;
begin
  if Source is tJson2PumlConverterDefinitionList then
  begin
    Clear;
    for intDefinition in tJson2PumlConverterDefinitionList (Source) do
      AddDefinition (intDefinition);
  end;
end;

function tJson2PumlConverterDefinitionList.GetDefinition (Index: Integer): tJson2PumlConverterDefinition;
begin
  Result := tJson2PumlConverterDefinition (Objects[index]);
end;

function tJson2PumlConverterDefinitionList.GetDefinitionByName (iOptionName: string): tJson2PumlConverterDefinition;
var
  i: Integer;
  FoundCondition: string;
begin
  i := IndexOfProperty (iOptionName, '', '', '', FoundCondition, false, false);
  if i >= 0 then
    Result := Definition[i]
  else
    Result := nil;
end;

function tJson2PumlConverterDefinitionList.GetEnumerator: tJson2PumlConverterDefinitionEnumerator;
begin
  Result := tJson2PumlConverterDefinitionEnumerator.Create (self);
end;

function tJson2PumlConverterDefinitionList.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  JsonValue: TJSONValue;
  JsonArray: TJSONArray;
  DefinitionRecord: TJSONObject;
  Definition: tJson2PumlConverterDefinition;
  i: Integer;
begin
  // inherited ReadFromJson (iJsonValue, iPropertyName);
  Result := false;
  Clear;
  if not Assigned (iJsonValue) then
    exit;
  if iJsonValue is TJSONArray then
    JsonValue := iJsonValue
  else if iJsonValue is TJSONObject then
    JsonValue := TJSONObject (iJsonValue).Values[iPropertyName]
  else
    exit;
  if not Assigned (JsonValue) then
    exit;
  Result := true;
  if JsonValue is TJSONArray then
  begin
    JsonArray := TJSONArray (JsonValue);
    for i := 0 to JsonArray.Count - 1 do
    begin
      JsonValue := JsonArray.Items[i];
      if JsonValue is TJSONObject then
      begin
        DefinitionRecord := TJSONObject (JsonValue);
        Definition := tJson2PumlConverterDefinition.Create;
        Definition.ReadFromJson (DefinitionRecord, '');
        AddDefinition (Definition);
      end;
    end;
  end;
end;

procedure tJson2PumlPropertyValueDefinition.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlPropertyValueDefinition then
  begin
    PropertyName := tJson2PumlPropertyValueDefinition (Source).PropertyName;
    ChildPropertyName := tJson2PumlPropertyValueDefinition (Source).ChildPropertyName;
  end;
end;

function tJson2PumlPropertyValueDefinition.GetIdent: string;
begin
  Result := PropertyName;
end;

procedure tJson2PumlPropertyValueDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  l: string;
  procedure Add (iName, iValue: string);
  var
    S: string;
  begin
    if iWriteEmpty or not iValue.IsEmpty then
    begin
      S := JsonPropertyNameValue (iName, ClearPropertyValue(iValue));
      if l.IsEmpty then
        l := S
      else
        l := Format ('%s, %s', [l, S]);
    end;
  end;

begin
  if ChildPropertyName.IsEmpty and NextValueSeparator.IsEmpty then
    oJsonOutPut.Add (Format('%s%s"%s",', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName),
      ClearPropertyValue(PropertyName)]))
  else
  begin
    l := '';
    Add ('propertyName', PropertyName);
    Add ('childPropertyName', ChildPropertyName);
    Add ('nextValueSeparator', NextValueSeparator);
    oJsonOutPut.Add (Format('%s%s{%s},', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName), l]));
  end;
end;

function tJson2PumlConverterGroupDescriptionDefinition.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlConverterGroupDescriptionDefinition.GetIsValid: boolean;
begin
  Result := not Description.IsEmpty;
end;

function tJson2PumlConverterGroupDescriptionDefinition.ReadFromJson (iJsonValue: TJSONValue;
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
  Description := GetJsonStringValue (Definition, 'description');
  DisplayName := GetJsonStringValue (Definition, 'displayName');
  Result := IsValid;
end;

procedure tJson2PumlConverterGroupDescriptionDefinition.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string;
  iLevel: Integer; iWriteEmpty: boolean = false);
begin
  WriteObjectStartToJson (oJsonOutPut, iLevel, iPropertyName);
  WriteToJsonValue (oJsonOutPut, 'displayName', DisplayName, iLevel + 1, iWriteEmpty);
  WriteToJsonValue (oJsonOutPut, 'description', Description, iLevel + 1, iWriteEmpty);
  WriteObjectEndToJson (oJsonOutPut, iLevel);
end;

function tJson2PumlRelationshipTypeArrowFormatList.GetFormat (iObjectType, iPropertyName, iRelationshipType: string;
  var oFoundCondition: string): string;

var
  ArrowFormat: string;
  function Search (iName: string): boolean;
  var
    i: Integer;
  begin
    i := IndexOfName (iName.ToLower);
    Result := i >= 0;
    if Result then
    begin
      ArrowFormat := ValueFromIndex[i];
      oFoundCondition := iName;
    end;
  end;

begin
  try
    ArrowFormat := '';
    if Search (Format('%s.%s', [iPropertyName, iRelationshipType])) then
      exit;
    if Search (iPropertyName) then
      exit;
    if Search (iRelationshipType) then
      exit;
  finally
    Result := ArrowFormat;
  end;
end;

end.
