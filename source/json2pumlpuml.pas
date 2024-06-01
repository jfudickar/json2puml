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

unit json2pumlpuml;

interface

uses System.JSON, System.Classes, json2pumldefinition, json2pumlconst, json2pumlconverterdefinition,
  json2pumlbasedefinition;

type
  tPumlObject = class;

  tPumlHelper = class
  public
    class function CleanCRLF (iValue: string): string;
    class function CleanValue (iValue: string; iSplitLength: Integer): string;
    class function PUmlIdentifier (iIdentifier: string): string;
    class function RelationLine (iFromIdent, iArrowFormat, iToIdent, iComment: string): string;
    class function ReplaceNewLine (iValue: string): string;
    class function ReplaceTab (iValue: string): string;
    class function ReplaceTabNewLine (iValue: string): string;
    class function TableColumnSeparator: string;
    class function TableColumn (iValue: string; iHeader: boolean = False): string;
    class function TableLine (const iColumns: array of const; iHeader: boolean = False): string; overload;
    class function TableLine (iColumns: TStringList; iHeader: boolean = False; iClearColumns: boolean = true)
      : string; overload;
  end;

  tBasePumlObject = class(tPersistent)
  private
    FParentObject: tBasePumlObject;
    function GetFilled: boolean; virtual;
    function GetIdent: string; virtual;
    function GetIdentHierarchy: string;
    function GetParentUmlObject: tPumlObject;
  public
    constructor Create (iParentObject: tBasePumlObject); virtual;
    procedure clear; virtual;
    procedure UpdateRedundant; virtual;
    property Filled: boolean read GetFilled;
    property Ident: string read GetIdent;
    property IdentHierarchy: string read GetIdentHierarchy;
    property ParentObject: tBasePumlObject read FParentObject;
    property ParentUmlObject: tPumlObject read GetParentUmlObject;
  end;

  tBasePumlStringList = class(tBasePumlObject)
  private
    FItemList: TStringList;
    function GetBaseObject (Index: Integer): tJson2PumlBaseObject;
    function GetCount: Integer;
    function GetDuplicates: TDuplicates;
    function GetFilled: boolean; override;
    function GetFilledCount: Integer; virtual;
    function GetNames (Index: Integer): string;
    function GetObjects (Index: Integer): TObject;
    function GetOwnsObjects: boolean;
    function GetSorted: boolean;
    function GetStrings (Index: Integer): string;
    function GetText: string;
    procedure SetDuplicates (const Value: TDuplicates);
    procedure SetObjects (Index: Integer; const Value: TObject);
    procedure SetOwnsObjects (const Value: boolean);
    procedure SetSorted (const Value: boolean);
    procedure SetStrings (Index: Integer; const Value: string);
    procedure SetText (const Value: string);
  protected
    property BaseObject[index: Integer]: tJson2PumlBaseObject read GetBaseObject;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    destructor Destroy; override;
    function AddObject (const S: string; AObject: TObject): Integer;
    procedure Assign (Source: tPersistent); override;
    procedure clear; override;
    procedure Delete (Index: Integer);
    function IndexOf (S: string): Integer;
    function IndexOfName (S: string): Integer;
    procedure Sort;
    procedure UpdateRedundant; override;
    property Count: Integer read GetCount;
    property Duplicates: TDuplicates read GetDuplicates write SetDuplicates;
    property FilledCount: Integer read GetFilledCount;
    property ItemList: TStringList read FItemList;
    property Names[index: Integer]: string read GetNames;
    property Objects[index: Integer]: TObject read GetObjects write SetObjects;
    property OwnsObjects: boolean read GetOwnsObjects write SetOwnsObjects;
    property Sorted: boolean read GetSorted write SetSorted;
    property Strings[index: Integer]: string read GetStrings write SetStrings; default;
    property Text: string read GetText write SetText;
  end;

  tUmlRelationDirectionHelper = record helper for tUmlRelationDirection
    procedure FromString (aValue: string);
    function ToString: string;
  end;

  tPumlObjectRelationship = class(tBasePumlObject)
  private
    FArrowFormat: string;
    FDirection: tUmlRelationDirection;
    FGroupAtObject: boolean;
    FGroupAtRelatedObject: boolean;
    FPropertyName: string;
    FRelatedObject: tPumlObject;
    FRelationshipType: string;
    FRelationshipTypeProperty: string;
    function GetFilled: boolean; override;
    function GetIdent: string; override;
    function GetObjectGroupName: string;
    function GetRelatedObjectCaption: string;
    function GetRelatedObjectFilled: boolean;
    function GetRelatedObjectFiltered: boolean;
    function GetRelatedObjectGroupName: string;
    function GetRelatedObjectIdentifier: string;
    function GetRelatedObjectShowObject: boolean;
    function GetRelatedObjectTypeIdent: string;
  public
    procedure GeneratePumlObjectDetail (ipuml: TStrings);
    procedure GeneratePumlRelation (ipuml, iGroupList: TStrings);
    property ArrowFormat: string read FArrowFormat write FArrowFormat;
    property Direction: tUmlRelationDirection read FDirection write FDirection;
    property GroupAtObject: boolean read FGroupAtObject write FGroupAtObject;
    property GroupAtRelatedObject: boolean read FGroupAtRelatedObject write FGroupAtRelatedObject;
    property ObjectGroupName: string read GetObjectGroupName;
    property PropertyName: string read FPropertyName write FPropertyName;
    property RelatedObject: tPumlObject read FRelatedObject write FRelatedObject;
    property RelatedObjectCaption: string read GetRelatedObjectCaption;
    property RelatedObjectFilled: boolean read GetRelatedObjectFilled;
    property RelatedObjectFiltered: boolean read GetRelatedObjectFiltered;
    property RelatedObjectGroupName: string read GetRelatedObjectGroupName;
    property RelatedObjectIdentifier: string read GetRelatedObjectIdentifier;
    property RelatedObjectShowObject: boolean read GetRelatedObjectShowObject;
    property RelatedObjectTypeIdent: string read GetRelatedObjectTypeIdent;
    property RelationshipType: string read FRelationshipType write FRelationshipType;
    property RelationshipTypeProperty: string read FRelationshipTypeProperty write FRelationshipTypeProperty;
  end;

  tPumlObjectRelationshipList = class;

  tPumlObjectRelationshipEnumerator = class
  private
    FIndex: Integer;
    fRelationshipList: tPumlObjectRelationshipList;
  public
    constructor Create (ARelationshipList: tPumlObjectRelationshipList);
    function GetCurrent: tPumlObjectRelationship;
    function MoveNext: boolean;
    property Current: tPumlObjectRelationship read GetCurrent;
  end;

  tPumlObjectRelationshipList = class(tBasePumlStringList)
  private
    function GetDirectionCount (iDirection: tUmlRelationDirection; iValidOnly: boolean): Integer;
    function GetFromCount: Integer;
    function GetFromCountValid: Integer;
    function GetRelationship (Index: Integer): tPumlObjectRelationship;
    function GetToCount: Integer;
    function GetToCountValid: Integer;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    function addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
      RelatedObject: tPumlObject; iDirection: tUmlRelationDirection; iGroupAtObject, iGroupAtRelatedObject: boolean;
      iArrowFormat: string; iAllways: boolean = true): boolean;
    procedure GeneratePumlObjectDetail (ipuml: TStrings; iDirection: tUmlRelationDirection; var iAddLine: boolean);
    procedure GeneratePumlRelation (ipuml, iGroupList: TStrings);
    procedure GeneratePumlRelationGroup (ipuml, iGroupList, iGroupCountList: TStrings);
    function GetEnumerator: tPumlObjectRelationshipEnumerator;
    property FromCount: Integer read GetFromCount;
    property FromCountValid: Integer read GetFromCountValid;
    property Relationship[index: Integer]: tPumlObjectRelationship read GetRelationship; default;
    property ToCount: Integer read GetToCount;
    property ToCountValid: Integer read GetToCountValid;
  end;

  tPumlCharacteristicRecord = class;
  tPumlCharacteristicRecordList = class;

  tPumlCharacteristicValue = class(tBasePumlObject)
  private
    FAttribute: string;
    FDetailRecords: tPumlCharacteristicRecordList;
    FValue: string;
    function GetIdent: string; override;
    function GetFilled: boolean; override;
    function GetParentCharacteristicName: string;
    function GetParentCharacteristicNameAttribute: string;
    function GetParentCharacteristicNameIndex: string;
    function GetParentCharactisticRecord: tPumlCharacteristicRecord;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    destructor Destroy; override;
    function AddDetailRecord (iRow: Integer): tPumlCharacteristicRecord;
    function CalculateRecordLine (iIncludeParent: boolean; iSplitLength: Integer): string;
    procedure CalculateTableRow (iUsedColumns, iValueList: TStringList);
    procedure GeneratePumlAsRecord (ipuml: TStrings; iIncludeParent: boolean; iSplitLength: Integer);
    property Attribute: string read FAttribute write FAttribute;
    property DetailRecords: tPumlCharacteristicRecordList read FDetailRecords;
    property ParentCharacteristicName: string read GetParentCharacteristicName;
    property ParentCharacteristicNameAttribute: string read GetParentCharacteristicNameAttribute;
    property ParentCharacteristicNameIndex: string read GetParentCharacteristicNameIndex;
    property ParentCharactisticRecord: tPumlCharacteristicRecord read GetParentCharactisticRecord;
    property Value: string read FValue write FValue;
  end;

  tPumlCharacteristicValueEnumerator = class
  private
    FIndex: Integer;
    fRecord: tPumlCharacteristicRecord;
  public
    constructor Create (ARecord: tPumlCharacteristicRecord);
    function GetCurrent: tPumlCharacteristicValue;
    function MoveNext: boolean;
    property Current: tPumlCharacteristicValue read GetCurrent;
  end;

  tPumlCharacteristicRecord = class(tBasePumlStringList)
  private
    FRow: Integer;
    function GetAttribute: string;
    function GetIdent: string; override;
    function GetIncludeParentColumn: boolean;
    function GetFilled: boolean; override;
    function GetParentCharacteristicName: string;
    function GetParentCharacteristicNameIndex: string;
    function GetParentCharacteristicValue: tPumlCharacteristicValue;
    function GetValue (Index: Integer): tPumlCharacteristicValue;
  protected
    property IncludeParentColumn: boolean read GetIncludeParentColumn;
    property Row: Integer read FRow write FRow;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    function AddValue (iAttribute, iValue: string; iReplace: boolean = true): tPumlCharacteristicValue;
    procedure AddValues (iValueList: TStringList);
    function CalculateRecordLine: string;
    procedure CalculateTableRow (iUsedColumns, iValueList: TStringList);
    procedure GeneratePumlAsRecord (ipuml: TStrings; iIncludeHeader: boolean; iSplitLength: Integer;
      iSortLines: boolean);
    procedure CalculateTableRows (iDefinition: tJson2PumlCharacteristicDefinition;
      iUsedColumns, iTableRows: TStringList);
    function GetEnumerator: tPumlCharacteristicValueEnumerator;
    property Attribute: string read GetAttribute;
    property ParentCharacteristicName: string read GetParentCharacteristicName;
    property ParentCharacteristicNameIndex: string read GetParentCharacteristicNameIndex;
    property ParentCharacteristicValue: tPumlCharacteristicValue read GetParentCharacteristicValue;
    property Value[index: Integer]: tPumlCharacteristicValue read GetValue; default;
  end;

  tPumlCharacteristicRecordEnumerator = class
  private
    FIndex: Integer;
    fRecordList: tPumlCharacteristicRecordList;
  public
    constructor Create (ARecordList: tPumlCharacteristicRecordList);
    function GetCurrent: tPumlCharacteristicRecord;
    function MoveNext: boolean;
    property Current: tPumlCharacteristicRecord read GetCurrent;
  end;

  tPumlCharacteristicRecordList = class(tBasePumlStringList)
  private
    function GetFilled: boolean; override;
    function GetParentCharacteristicValue: tPumlCharacteristicValue;
    function GetRecords (Index: Integer): tPumlCharacteristicRecord;
  public
    function AddRecord (iRow: Integer): tPumlCharacteristicRecord;
    procedure GeneratePumlAsRecord (ipuml: TStrings; iIncludeHeader: boolean; iSplitLength: Integer;
      iSortLines: boolean);
    procedure GeneratePumlAsList (ipuml: TStrings; iDefinition: tJson2PumlCharacteristicDefinition;
      iSplitLength: Integer);
    function GetEnumerator: tPumlCharacteristicRecordEnumerator;
    property ParentCharacteristicValue: tPumlCharacteristicValue read GetParentCharacteristicValue;
    property Records[index: Integer]: tPumlCharacteristicRecord read GetRecords; default;
  end;

  tPumlCharacteristicObject = class(tPumlCharacteristicValue)
  private
    FDefinition: tJson2PumlCharacteristicDefinition;
    FUsedProperties: TStringList;
  protected
    procedure AddUsedProperties (iPropertyList: TStringList);
    procedure AddUsedProperty (iName: string);
    property UsedProperties: TStringList read FUsedProperties;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    destructor Destroy; override;
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean; iSplitLength: Integer; iSortLines: boolean);
  published
    property Definition: tJson2PumlCharacteristicDefinition read FDefinition write FDefinition;
  end;

  tPumlCharacteristicList = class;

  tPumlCharacteristicObjectEnumerator = class
  private
    fCharacteristicList: tPumlCharacteristicList;
    FIndex: Integer;
  public
    constructor Create (ACharacteristicList: tPumlCharacteristicList);
    function GetCurrent: tPumlCharacteristicObject;
    function MoveNext: boolean;
    property Current: tPumlCharacteristicObject read GetCurrent;
  end;

  tPumlCharacteristicList = class(tBasePumlStringList)
  private
    function GetCharacteristic (Index: Integer): tPumlCharacteristicObject;
    function GetIdent: string; override;
  protected
    function AddCharacteristic (iAttribute: string; iCharacteristicDefinition: tJson2PumlCharacteristicDefinition)
      : tPumlCharacteristicObject;
  public
    constructor Create (iParentObject: tBasePumlObject); override;
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean; iSplitLength: Integer; iSortLines: boolean);
    function GetEnumerator: tPumlCharacteristicObjectEnumerator;
    property Characteristic[index: Integer]: tPumlCharacteristicObject read GetCharacteristic; default;
  end;

  tPumlDetailObjectList = class(tBasePumlStringList)
  public
    constructor Create(iParentObject: tBasePumlObject); override;
    procedure GeneratePumlClassList (ipuml: TStrings);
    procedure GeneratePumlTogether (ipuml: TStrings; iParentObjectName, iParentObjectTitle: string);
  end;

  tPumlObject = class(tBasePumlObject)
  private
    FAttributes: tPumlCharacteristicRecord;
    FCharacteristics: tPumlCharacteristicList;
    FChildObjectCount: Integer;
    FDetailObjects: tPumlDetailObjectList;
    FFiltered: boolean;
    FFormatDefinition: tJson2PumlSingleFormatDefinition;
    FFormatPriority: Integer;
    FIdentifyObjectsByTypeAndIdent: boolean;
    FInputFilter: tJson2PumlFilterList;
    FIsObjectDetail: boolean;
    FIsRelationship: boolean;
    FObjectIdent: string;
    FObjectIdentProperty: string;
    FObjectTitle: string;
    FObjectTitleProperty: string;
    FObjectType: string;
    FParentObjectType: string;
    FRelations: tPumlObjectRelationshipList;
    function GetFilled: boolean; override;
    function GetIdent: string; override;
    function GetObjectIdentifier: string;
    function GetObjectTypeIdent: string;
    function GetPlantUmlIdent: string;
    function GetShowObject: boolean;
  protected
    function GeneratePumlClassName: string;
    property ChildObjectCount: Integer read FChildObjectCount;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function AddCharacteristic (iParentProperty: string; iCharacteristicDefinition: tJson2PumlCharacteristicDefinition)
      : tPumlCharacteristicObject;
    function addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
      RelatedObject: tPumlObject; iDirection: tUmlRelationDirection; iGroupAtObject, iGroupAtRelatedObject: boolean;
      iArrowFormat: string; iAllways: boolean = true): boolean;
    procedure AddValue (iName, iValue: string; iReplace: boolean = true);
    function CalculateChildObjectDefaultIdent (iChildObjectType: string): string;
    function GeneratePuml (ipuml: TStrings): boolean;
    function GeneratePumlColorDefinition: string;
    function IsFiltered: boolean;
    function ObjectCaption (iSeparator: string; iFormat: boolean): string;
    procedure UpdateRedundant; override;
    property Filtered: boolean read FFiltered write FFiltered;
    property FormatDefinition: tJson2PumlSingleFormatDefinition read FFormatDefinition write FFormatDefinition;
    property InputFilter: tJson2PumlFilterList read FInputFilter write FInputFilter;
    property IsObjectDetail: boolean read FIsObjectDetail write FIsObjectDetail;
    property IsRelationship: boolean read FIsRelationship write FIsRelationship;
    property ObjectIdentifier: string read GetObjectIdentifier;
    property ObjectTypeIdent: string read GetObjectTypeIdent;
    property PlantUmlIdent: string read GetPlantUmlIdent;
    property ShowObject: boolean read GetShowObject;
  published
    property Attributes: tPumlCharacteristicRecord read FAttributes;
    property Characteristics: tPumlCharacteristicList read FCharacteristics;
    property DetailObjects: tPumlDetailObjectList read FDetailObjects;
    property FormatPriority: Integer read FFormatPriority write FFormatPriority;
    property IdentifyObjectsByTypeAndIdent: boolean read FIdentifyObjectsByTypeAndIdent
      write FIdentifyObjectsByTypeAndIdent;
    property ObjectIdent: string read FObjectIdent write FObjectIdent;
    property ObjectIdentProperty: string read FObjectIdentProperty write FObjectIdentProperty;
    property ObjectTitle: string read FObjectTitle write FObjectTitle;
    property ObjectTitleProperty: string read FObjectTitleProperty write FObjectTitleProperty;
    property ObjectType: string read FObjectType write FObjectType;
    property ParentObjectType: string read FParentObjectType write FParentObjectType;
    property Relations: tPumlObjectRelationshipList read FRelations;
  end;

  tPumlObjectList = class;

  tPumlObjectEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tPumlObjectList;
  public
    constructor Create (AObjectList: tPumlObjectList);
    function GetCurrent: tPumlObject;
    function MoveNext: boolean;
    property Current: tPumlObject read GetCurrent;
  end;

  tPumlObjectList = class(tBasePumlStringList)
  private
    FConverterDefinition: tJson2PumlConverterDefinition;
    FInputFilter: tJson2PumlFilterList;
    function GetPumlObject (Index: Integer): tPumlObject;
  protected
    procedure addPumlObject (iPumlObject: tPumlObject);
  public
    constructor Create; reintroduce;
    function GetEnumerator: tPumlObjectEnumerator;
    function SearchCreatePumlObject (iObjectType, iObjectIdent, iParentObjectType: string; var oLogMessage: string;
      iFileLogObjectDescription: string = 'object'; iFileLogObjectAddition: string = ''): tPumlObject;
    property ConverterDefinition: tJson2PumlConverterDefinition read FConverterDefinition write FConverterDefinition;
    property InputFilter: tJson2PumlFilterList read FInputFilter write FInputFilter;
    property PumlObject[index: Integer]: tPumlObject read GetPumlObject; default;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections, System.Types, System.IOUtils, json2pumltools, System.Variants, json2pumlloghandler;

constructor tPumlObjectList.Create;
begin
  inherited Create (nil);
  Sorted := true;
  Duplicates := dupIgnore;
  OwnsObjects := true;
end;

procedure tPumlObjectList.addPumlObject (iPumlObject: tPumlObject);
begin
  AddObject (iPumlObject.ObjectIdentifier, iPumlObject);
end;

function tPumlObjectList.GetEnumerator: tPumlObjectEnumerator;
begin
  Result := tPumlObjectEnumerator.Create (Self);
end;

function tPumlObjectList.GetPumlObject (Index: Integer): tPumlObject;
begin
  Result := tPumlObject (Objects[index]);
end;

function tPumlObjectList.SearchCreatePumlObject (iObjectType, iObjectIdent, iParentObjectType: string;
  var oLogMessage: string; iFileLogObjectDescription: string = 'object'; iFileLogObjectAddition: string = '')
  : tPumlObject;
var
  pObject: tPumlObject;
  i: Integer;
  FormatDefinition: tJson2PumlSingleFormatDefinition;
  Search: string;
  FormatMsg: string;
  Priority: Integer;
  FoundCondition: string;

begin
  Result := nil;
  if iObjectIdent.IsEmpty then
    Exit;

  pObject := tPumlObject.Create;
  pObject.InputFilter := InputFilter;
  pObject.IdentifyObjectsByTypeAndIdent := ConverterDefinition.IdentifyObjectsByTypeAndIdent;
  pObject.ObjectType := iObjectType;
  pObject.ParentObjectType := iParentObjectType;
  pObject.ObjectIdent := iObjectIdent;
  i := IndexOf (pObject.ObjectIdentifier);
  if i >= 0 then
  begin
    oLogMessage := 'Use existing';
    Search := Format (' (based on search condition "%s")', [pObject.ObjectIdentifier]);
    Result := PumlObject[i];
    pObject.Free;
  end
  else
  begin
    oLogMessage := 'Create new';
    Search := '';
    Result := pObject;
    addPumlObject (pObject);
  end;
  FormatDefinition := ConverterDefinition.ObjectFormats.GetFormatByName (iObjectType, iParentObjectType, Priority,
    FoundCondition);
  if (Priority < Result.FormatPriority) or not Assigned (Result.FormatDefinition) then
  begin
    Result.FormatDefinition := FormatDefinition;
    Result.FormatPriority := Priority;
    if FormatDefinition.FormatName.IsEmpty then
      FormatMsg := '<default>'
    else
      FormatMsg := FormatDefinition.FormatName;
    FormatMsg := Format (' (Format : %s - Prio : %d - Condition : %s)', [FormatMsg, Priority, FoundCondition]);
  end
  else
    FormatMsg := Format (' (Format "%s" not changed)', [FormatDefinition.FormatName]);;

  oLogMessage := Format ('%s %s "%s":"%s" %s', [oLogMessage, iFileLogObjectDescription, Result.ObjectType,
    Result.ObjectIdent, Search, iFileLogObjectAddition.trim]).trim;
  if not FormatMsg.IsEmpty then
    oLogMessage := Format ('%s%s', [oLogMessage, FormatMsg]);

end;

constructor tPumlObject.Create;
begin
  inherited Create (nil);
  FAttributes := tPumlCharacteristicRecord.Create (Self);
  FCharacteristics := tPumlCharacteristicList.Create (Self);
  FRelations := tPumlObjectRelationshipList.Create (Self);
  FDetailObjects := tPumlDetailObjectList.Create (Self);
  FIsObjectDetail := False;
  FIsRelationship := False;
  FFiltered := true;
  FChildObjectCount := 0;
  FFormatPriority := MaxInt;
end;

destructor tPumlObject.Destroy;
begin
  FDetailObjects.Free;
  FRelations.Free;
  FCharacteristics.Free;
  FAttributes.Free;
  inherited Destroy;
end;

function tPumlObject.AddCharacteristic (iParentProperty: string;
  iCharacteristicDefinition: tJson2PumlCharacteristicDefinition): tPumlCharacteristicObject;
begin
  Result := Characteristics.AddCharacteristic (iParentProperty, iCharacteristicDefinition);
end;

function tPumlObject.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
  RelatedObject: tPumlObject; iDirection: tUmlRelationDirection; iGroupAtObject, iGroupAtRelatedObject: boolean;
  iArrowFormat: string; iAllways: boolean = true): boolean;
begin
  Result := Relations.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty, RelatedObject,
    iDirection, iGroupAtObject, iGroupAtRelatedObject, iArrowFormat, iAllways);
end;

procedure tPumlObject.AddValue (iName, iValue: string; iReplace: boolean = true);
begin
  Attributes.AddValue (iName, iValue, iReplace);
end;

function tPumlObject.CalculateChildObjectDefaultIdent (iChildObjectType: string): string;
begin
  inc (FChildObjectCount);
  Result := Format ('%s_%s_%d', [iChildObjectType, ObjectIdentifier, ChildObjectCount]);
end;

function tPumlObject.GeneratePuml (ipuml: TStrings): boolean;
var
  i: Integer;
  idLine, NameLine: Integer;
  AddLine: boolean;
  Color: string;
  Lines: TStringList;

begin
  Result := ShowObject;
  if not Result then
    Exit;
  AddLine := False;
  Color := GeneratePumlColorDefinition;
  ipuml.add (Format('%s %s {', [GeneratePumlClassName, Color]));
  // if not ObjectType.IsEmpty then
  // ipuml.add (Format('<b>%s - %s</b>', [ObjectType, ObjectIdent]))
  // else
  // ipuml.add (Format('<b>%s</b>', [ObjectIdent]));
  if not ObjectType.IsEmpty then
    ipuml.add (Format('<b>%s</b>', [ObjectType]));
  if (Attributes.Count > 0) and FormatDefinition.ShowAttributes then
  begin
    ipuml.add (tPumlHelper.TableLine(['attribute', 'value'], true));
    idLine := Attributes.IndexOfName (ObjectIdentProperty);
    NameLine := Attributes.IndexOfName (ObjectTitleProperty);
    if idLine >= 0 then
      Attributes.Value[idLine].GeneratePumlAsRecord (ipuml, False, FormatDefinition.ValueSplitLength);
    if NameLine >= 0 then
      Attributes.Value[NameLine].GeneratePumlAsRecord (ipuml, False, FormatDefinition.ValueSplitLength);
    Lines := TStringList.Create;
    try
      for i := 0 to Attributes.Count - 1 do
        if (i <> idLine) and (i <> NameLine) then
          Attributes.Value[i].GeneratePumlAsRecord (Lines, False, FormatDefinition.ValueSplitLength);
      if FormatDefinition.SortAttributes then
        Lines.Sort;
      ipuml.AddStrings (Lines);
    finally
      Lines.Free;
    end;
    AddLine := true;
  end;
  if FormatDefinition.ShowCharacteristics then
    Characteristics.GeneratePuml (ipuml, AddLine, FormatDefinition.ValueSplitLength, FormatDefinition.SortAttributes);
  if FormatDefinition.ShowFromRelations then
    Relations.GeneratePumlObjectDetail (ipuml, urdFrom, AddLine);
  if FormatDefinition.ShowToRelations then
    Relations.GeneratePumlObjectDetail (ipuml, urdTo, AddLine);
  ipuml.add ('}');
end;

function tPumlObject.GeneratePumlClassName: string;
begin
  Result := Format ('class "%s" as %s', [ObjectCaption('\l', true), PlantUmlIdent]);
end;

function tPumlObject.GeneratePumlColorDefinition: string;
var
  Color: string;
begin
  if not ObjectType.IsEmpty then
    Color := ObjectType.Substring (0, 1)
  else if not ObjectTitle.IsEmpty then
    Color := ObjectTitle.Substring (0, 1)
  else if not FormatDefinition.FormatName.IsEmpty then
    Color := FormatDefinition.FormatName.Substring (0, 1)
  else if not ObjectIdent.IsEmpty then
    Color := ObjectIdent.Substring (0, 1)
  else
    Color := ' ';
  if Assigned (FormatDefinition) then
  begin
    if FormatDefinition.IconColor.IsEmpty then
      FormatDefinition.IconColor := 'Peru';
    Color := Format ('(%s,%s)', [Color.ToUpper, FormatDefinition.IconColor]);
    if not FormatDefinition.FormatName.IsEmpty then
      Color := Format ('%s %s', [Color, FormatDefinition.FormatName.ToLower]);
  end
  else
    Color := Format ('(%s,Peru)', [Color.ToUpper]);
  Color := Format ('<< %s >>', [Color]);
  Result := Color;
end;

function tPumlObject.GetFilled: boolean;
begin
  Result := Attributes.Filled or Characteristics.Filled or
    ((Relations.GetFromCount >= 1) and (Relations.GetToCount >= 1));
end;

function tPumlObject.GetIdent: string;
begin
  Result := ObjectIdentifier;
end;

function tPumlObject.GetObjectIdentifier: string;
begin
  if IdentifyObjectsByTypeAndIdent then
    Result := ObjectTypeIdent
  else
    Result := ObjectIdent;
end;

function tPumlObject.GetObjectTypeIdent: string;
begin
  Result := Format ('%s %s', [ObjectType.ToLower, ObjectIdent]);
end;

function tPumlObject.GetPlantUmlIdent: string;
begin
  Result := tPumlHelper.PUmlIdentifier (ObjectIdentifier);
end;

function tPumlObject.GetShowObject: boolean;
var
  r: tPumlObjectRelationship;
  Cnt: Integer;
begin
  Cnt := 0;
  Result := Filtered;
  // If not filtered then the filled status can be ignored
  if Result then
  begin
    Result := Filled or FormatDefinition.ShowIfEmpty;
    if not Result then
      for r in Relations do
      begin
        if r.RelatedObjectFilled then
          Cnt := Cnt + 1;
        if Cnt > 1 then
        begin
          Result := true;
          Exit;
        end;
      end;
  end;
end;

function tPumlObject.IsFiltered: boolean;
var
  r: tPumlObjectRelationship;
begin
  Result := InputFilter.Matches (ObjectIdent, ObjectTitle);
  // If the object is not matching, it could be matching based on the related object
  if not Result then
  begin
    for r in Relations do
    begin
      Result := InputFilter.Matches (r.RelatedObject.ObjectIdent, r.RelatedObject.ObjectTitle);
      if Result then
        Exit;
    end;
  end;
end;

function tPumlObject.ObjectCaption (iSeparator: string; iFormat: boolean): string;
var
  NewCaption: string;
  NewCaptionLengh: Integer;
  NewIdent: string;
  SplitLength: Integer;

  procedure addpart (iValue: string; iFormatChar: string);
  var
    S: string;
  begin
    if iValue.IsEmpty then
      Exit;
    if iFormat then
      S := Format ('<%s>%s</%s>', [iFormatChar, iValue, iFormatChar])
    else
      S := iValue;
    if NewCaption.IsEmpty then
      NewCaption := S
    else if (NewCaptionLengh > SplitLength) and (SplitLength > 0) then
      NewCaption := Format ('%s%s%s', [NewCaption, iSeparator, S])
    else
      NewCaption := Format ('%s %s', [NewCaption, S]);
    NewCaptionLengh := NewCaptionLengh + Length (iValue);
  end;

  function SplitPosition (S: string): Integer;
  begin
    Result := S.Substring (SplitLength).IndexOf (FormatDefinition.CaptionSplitCharacter);
    if (Result < 0) and (S.Length > round(SplitLength * 1.5)) then
      Result := SplitLength;
  end;

  procedure SplitIdent;
  var
    S: string;
    i: Integer;
  begin
    if (ObjectIdent.Length > SplitLength) and (SplitLength > 0) then
    begin
      NewIdent := '';
      S := ObjectIdent;
      i := SplitPosition (S);
      while (i >= 0) and (S.Length - i - SplitLength > 5) do
      begin
        if iFormat then
          NewIdent := NewIdent + S.Substring (0, SplitLength + i) + '</i>' + iSeparator + '    <i>'
        else
          NewIdent := NewIdent + S.Substring (0, SplitLength + i) + iSeparator + '    ';
        S := S.Substring (SplitLength + i);
        i := SplitPosition (S);
      end;
      NewIdent := NewIdent + S;
    end
    else
    begin
      NewIdent := ObjectIdent;
    end;
  end;

begin
  SplitLength := FormatDefinition.CaptionSplitLength;
  NewCaption := '';
  NewCaptionLengh := 0;
  SplitIdent;
  if FormatDefinition.CaptionShowType then
    addpart (ObjectType, 'u');
  if FormatDefinition.CaptionShowIdent and not IsObjectDetail then
    addpart (NewIdent, 'i');
  if FormatDefinition.CaptionShowTitle then
    addpart (ObjectTitle, 'b');
  if NewCaption.IsEmpty then
    addpart (ObjectIdent, 'i');
  Result := NewCaption;
end;

procedure tPumlObject.UpdateRedundant;
begin
  Filtered := IsFiltered;
end;

procedure tPumlObjectRelationship.GeneratePumlObjectDetail (ipuml: TStrings);
var
  rType: string;
begin
  if not RelatedObject.ShowObject then
    Exit;
  if RelationshipTypeProperty.IsEmpty then
    rType := RelationshipType
  else
    rType := Format ('%s: %s', [RelationshipTypeProperty, RelationshipType]);

  if Direction = urdTo then
    ipuml.add (tPumlHelper.TableLine([tPumlHelper.CleanCRLF(PropertyName), tPumlHelper.CleanCRLF(rType),
      RelatedObjectCaption]))
  else
    ipuml.add (tPumlHelper.TableLine([RelatedObjectCaption, tPumlHelper.CleanCRLF(PropertyName),
      tPumlHelper.CleanCRLF(rType)]));
end;

procedure tPumlObjectRelationship.GeneratePumlRelation (ipuml, iGroupList: TStrings);
var
  Comment: string;
  FromIdent: string;
  ToIdent: string;
begin
  if not RelatedObjectShowObject then
    Exit;
  if not (Direction = urdTo) then
    Exit;
  if iGroupList.IndexOf (ObjectGroupName) >= 0 then
    FromIdent := ObjectGroupName
  else
    FromIdent := ParentUmlObject.PlantUmlIdent;
  if iGroupList.IndexOf (RelatedObjectGroupName) >= 0 then
    ToIdent := RelatedObjectGroupName
  else
    ToIdent := RelatedObject.PlantUmlIdent;
  Comment := PropertyName;
  if not RelationshipType.trim.IsEmpty then
  begin
    if not Comment.IsEmpty then
      Comment := Format ('%s\l', [Comment]);
    if not RelationshipTypeProperty.IsEmpty then
      Comment := Format ('%s%s: ', [Comment, RelationshipTypeProperty]);
    Comment := Format ('%s%s', [Comment, RelationshipType]);
  end;

  ipuml.add (tPumlHelper.RelationLine(FromIdent, ArrowFormat, ToIdent, Comment));

end;

function tPumlObjectRelationship.GetFilled: boolean;
begin
  Result := Assigned (RelatedObject) and RelatedObject.Filled;
end;

function tPumlObjectRelationship.GetIdent: string;
begin
  Result := string.Join (';', [ParentUmlObject.ObjectIdentifier, Direction.ToString, RelatedObjectIdentifier,
    PropertyName, RelationshipType]);
end;

function tPumlObjectRelationship.GetObjectGroupName: string;
begin
  Result := tPumlHelper.PUmlIdentifier (string.Join('_', [ParentUmlObject.ObjectIdentifier, 'group',
    RelatedObject.ObjectType, PropertyName]));
end;

function tPumlObjectRelationship.GetRelatedObjectCaption: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectCaption ('\n ', true)
  else
    Result := '';
end;

function tPumlObjectRelationship.GetRelatedObjectFilled: boolean;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.Filled
  else
    Result := False;
end;

function tPumlObjectRelationship.GetRelatedObjectFiltered: boolean;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.Filtered
  else
    Result := False;
end;

function tPumlObjectRelationship.GetRelatedObjectGroupName: string;
begin
  Result := tPumlHelper.PUmlIdentifier (string.Join('_', [RelatedObject.ObjectIdentifier, 'group',
    ParentUmlObject.ObjectType, PropertyName]));
end;

function tPumlObjectRelationship.GetRelatedObjectIdentifier: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectIdentifier
  else
    Result := '';
end;

function tPumlObjectRelationship.GetRelatedObjectShowObject: boolean;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ShowObject
  else
    Result := False;
end;

function tPumlObjectRelationship.GetRelatedObjectTypeIdent: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectTypeIdent
  else
    Result := '';
end;

constructor tPumlObjectRelationshipList.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  Sorted := true;
  Duplicates := dupAccept;
  OwnsObjects := true;
end;

function tPumlObjectRelationshipList.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
  RelatedObject: tPumlObject; iDirection: tUmlRelationDirection; iGroupAtObject, iGroupAtRelatedObject: boolean;
  iArrowFormat: string; iAllways: boolean = true): boolean;
var
  pumlObjectRelationship: tPumlObjectRelationship;
begin
  pumlObjectRelationship := tPumlObjectRelationship.Create (Self);
  pumlObjectRelationship.PropertyName := PropertyName;
  pumlObjectRelationship.RelatedObject := RelatedObject;
  pumlObjectRelationship.RelationshipType := RelationshipType;
  pumlObjectRelationship.RelationshipTypeProperty := RelationshipTypeProperty;
  pumlObjectRelationship.Direction := iDirection;
  pumlObjectRelationship.GroupAtObject := iGroupAtObject;
  pumlObjectRelationship.GroupAtRelatedObject := iGroupAtRelatedObject;
  pumlObjectRelationship.ArrowFormat := iArrowFormat;
  Result := iAllways or (IndexOf(pumlObjectRelationship.Ident) < 0);
  if Result then
    AddObject (pumlObjectRelationship.Ident, pumlObjectRelationship)
  else
    pumlObjectRelationship.Free;
end;

procedure tPumlObjectRelationshipList.GeneratePumlObjectDetail (ipuml: TStrings; iDirection: tUmlRelationDirection;
  var iAddLine: boolean);
var
  r: tPumlObjectRelationship;
  TempList: TStringList;
begin
  if (GetDirectionCount(iDirection, true) > 0) then
  begin
    if iAddLine then
      ipuml.add ('---');
    if iDirection = urdTo then
    begin
      ipuml.add ('<b>relations to</b>');
      ipuml.add (tPumlHelper.TableLine(['property', 'type', ' object'], true));
    end
    else
    begin
      ipuml.add ('<b>relations from</b>');
      ipuml.add (tPumlHelper.TableLine(['object', 'property', 'type'], true));
    end;
    TempList := TStringList.Create;
    try
      for r in Self do
        if (r.Direction = iDirection) then
          r.GeneratePumlObjectDetail (TempList);
      iAddLine := true;
      TempList.Sort;
      ipuml.AddStrings (TempList);
    finally
      TempList.Free;
    end;
  end;
end;

procedure tPumlObjectRelationshipList.GeneratePumlRelation (ipuml, iGroupList: TStrings);
var
  r: tPumlObjectRelationship;
begin
  for r in Self do
    r.GeneratePumlRelation (ipuml, iGroupList);
end;

procedure tPumlObjectRelationshipList.GeneratePumlRelationGroup (ipuml, iGroupList, iGroupCountList: TStrings);
var
  r: tPumlObjectRelationship;

  procedure CheckGroup (iDirection: tUmlRelationDirection);
  var
    i: Integer;
    GroupIdent: string;
    GroupTitle: string;
    ClassIdent: string;
    Color: string;
    ParentObject: tPumlObject;
  begin
    if (iDirection = urdTo) and r.GroupAtObject then
    begin
      GroupIdent := r.ObjectGroupName;
      // GroupTitle := r.RelatedObject.ObjectType+' ->\n'+r.ParentUmlObject.ObjectType;
      GroupTitle := r.ParentUmlObject.ObjectType + ' ->\n' + r.RelatedObject.ObjectType;
    end
    else if (iDirection = urdFrom) and r.GroupAtRelatedObject then
    begin
      GroupIdent := r.RelatedObjectGroupName;
      GroupTitle := r.ParentUmlObject.ObjectType + ' ->\n' + r.RelatedObject.ObjectType;
    end
    else
      Exit;
    i := iGroupCountList.IndexOfName (GroupIdent);
    if i < 0 then
      iGroupCountList.AddPair (GroupIdent, '1')
    else if iGroupCountList.ValueFromIndex[i].ToInteger <= 1 then
    begin
      if iDirection = urdTo then
        ParentObject := r.ParentUmlObject
      else
        ParentObject := r.RelatedObject;
      // ClassIdent := Format('diamond %s', [GroupIdent]);
      ClassIdent := Format ('class "%s" as %s', [GroupTitle, GroupIdent]);
      Color := ParentObject.GeneratePumlColorDefinition;

      ipuml.add (Format('''generate relation group %s', [ParentObject.ObjectTypeIdent]));
      iGroupList.add (GroupIdent);
      ipuml.add ('together {');
      ipuml.add (Format('  %s', [ParentObject.GeneratePumlClassName]));
      ipuml.add (Format('  %s', [ClassIdent]));
      ipuml.add ('}');
      if iDirection = urdTo then
        ipuml.add (tPumlHelper.RelationLine(r.ParentUmlObject.PlantUmlIdent, r.ArrowFormat, GroupIdent,
          'to ' + r.PropertyName))
      else
        ipuml.add (tPumlHelper.RelationLine(GroupIdent, r.ArrowFormat, r.RelatedObject.PlantUmlIdent,
          Format('from\n%s.%s', [r.ParentUmlObject.ObjectType, r.PropertyName])));
      iGroupCountList.ValueFromIndex[i] := (iGroupCountList.ValueFromIndex[i].ToInteger + 1).ToString;
      ipuml.add (Format('%s %s', [ClassIdent, Color]));
    end;
  end;

begin
  for r in Self do
    if (r.Filled) and (r.Direction = urdTo) then
    begin
      CheckGroup (urdTo);
      CheckGroup (urdFrom);
    end;
end;

function tPumlObjectRelationshipList.GetDirectionCount (iDirection: tUmlRelationDirection; iValidOnly: boolean)
  : Integer;
var
  r: tPumlObjectRelationship;
begin
  Result := 0;
  for r in Self do
    if (r.Direction = iDirection) and (not iValidOnly or r.Filled) then
      Result := Result + 1;
end;

function tPumlObjectRelationshipList.GetEnumerator: tPumlObjectRelationshipEnumerator;
begin
  Result := tPumlObjectRelationshipEnumerator.Create (Self);
end;

function tPumlObjectRelationshipList.GetFromCount: Integer;
begin
  Result := GetDirectionCount (urdFrom, False);
end;

function tPumlObjectRelationshipList.GetFromCountValid: Integer;
begin
  Result := GetDirectionCount (urdFrom, true);
end;

function tPumlObjectRelationshipList.GetRelationship (Index: Integer): tPumlObjectRelationship;
begin
  Result := tPumlObjectRelationship (Objects[index]);
end;

function tPumlObjectRelationshipList.GetToCount: Integer;
begin
  Result := GetDirectionCount (urdTo, False);
end;

function tPumlObjectRelationshipList.GetToCountValid: Integer;
begin
  Result := GetDirectionCount (urdTo, true);
end;

constructor tPumlCharacteristicList.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  OwnsObjects := true;
  // Sorted := true;
  // duplicates := dupError;
end;

function tPumlCharacteristicList.AddCharacteristic (iAttribute: string;
  iCharacteristicDefinition: tJson2PumlCharacteristicDefinition): tPumlCharacteristicObject;
var
  i: Integer;
begin
  Result := tPumlCharacteristicObject.Create (Self);
  Result.Attribute := iAttribute;
  Result.Definition := iCharacteristicDefinition;
  i := IndexOf (Result.Ident);
  if i < 0 then
    Result := Characteristic[AddObject(Result.Ident, Result)]
  else
  begin
    Result.Free;
    Result := Characteristic[i];
  end;
end;

procedure tPumlCharacteristicList.GeneratePuml (ipuml: TStrings; var iAddLine: boolean; iSplitLength: Integer;
  iSortLines: boolean);
var
  Characteristic: tPumlCharacteristicObject;
begin
  if iSortLines then
    Self.Sort;
  for Characteristic in Self do
    Characteristic.GeneratePuml (ipuml, iAddLine, iSplitLength, iSortLines);
end;

function tPumlCharacteristicList.GetCharacteristic (Index: Integer): tPumlCharacteristicObject;
begin
  Result := tPumlCharacteristicObject (Objects[index]);
end;

function tPumlCharacteristicList.GetEnumerator: tPumlCharacteristicObjectEnumerator;
begin
  Result := tPumlCharacteristicObjectEnumerator.Create (Self);
end;

function tPumlCharacteristicList.GetIdent: string;
begin
  Result := 'CharList';
end;

constructor tBasePumlObject.Create (iParentObject: tBasePumlObject);
begin
  inherited Create;
  FParentObject := iParentObject;
end;

procedure tBasePumlObject.clear;
begin

end;

function tBasePumlObject.GetFilled: boolean;
begin
  Result := true;
end;

function tBasePumlObject.GetIdent: string;
begin
  Result := '';
end;

function tBasePumlObject.GetIdentHierarchy: string;
begin
  if Assigned (ParentObject) then
    Result := string.Join ('.', [ParentObject.IdentHierarchy, Ident])
  else
    Result := Ident;
end;

function tBasePumlObject.GetParentUmlObject: tPumlObject;
begin
  if Assigned (FParentObject) then
    if ParentObject is tPumlObject then
      Result := tPumlObject (ParentObject)
    else
      Result := FParentObject.ParentUmlObject
  else
    Result := nil;
end;

procedure tBasePumlObject.UpdateRedundant;
begin
end;

constructor tPumlObjectRelationshipEnumerator.Create (ARelationshipList: tPumlObjectRelationshipList);
begin
  inherited Create;
  FIndex := - 1;
  fRelationshipList := ARelationshipList;
end;

function tPumlObjectRelationshipEnumerator.GetCurrent: tPumlObjectRelationship;
begin
  Result := fRelationshipList[FIndex];
end;

function tPumlObjectRelationshipEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fRelationshipList.Count - 1;
  if Result then
    inc (FIndex);
end;

procedure tUmlRelationDirectionHelper.FromString (aValue: string);
var
  dbot: tUmlRelationDirection;
begin
  Self := low(dbot);
  aValue := aValue.ToLower.trim;
  for dbot := low(Self) to high(Self) do
    if aValue = dbot.ToString.ToLower then
    begin
      Self := dbot;
      Exit;
    end;
end;

function tUmlRelationDirectionHelper.ToString: string;
begin
  Result := cUmlRelationDirection[Self];
end;

constructor tPumlCharacteristicObjectEnumerator.Create (ACharacteristicList: tPumlCharacteristicList);
begin
  inherited Create;
  FIndex := - 1;
  fCharacteristicList := ACharacteristicList;
end;

function tPumlCharacteristicObjectEnumerator.GetCurrent: tPumlCharacteristicObject;
begin
  Result := fCharacteristicList[FIndex];
end;

function tPumlCharacteristicObjectEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fCharacteristicList.Count - 1;
  if Result then
    inc (FIndex);
end;

constructor tPumlObjectEnumerator.Create (AObjectList: tPumlObjectList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := AObjectList;
end;

function tPumlObjectEnumerator.GetCurrent: tPumlObject;
begin
  Result := fObjectList[FIndex];
end;

function tPumlObjectEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    inc (FIndex);
end;

constructor tBasePumlStringList.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  FItemList := TStringList.Create;
  FItemList.OwnsObjects := true;
end;

destructor tBasePumlStringList.Destroy;
begin
  FItemList.Free;
  inherited Destroy;
end;

function tBasePumlStringList.AddObject (const S: string; AObject: TObject): Integer;
begin
  Result := ItemList.AddObject (S, AObject);
end;

procedure tBasePumlStringList.Assign (Source: tPersistent);
begin
  inherited Assign (Source);
  if Source is tBasePumlStringList then
    ItemList.Assign (tBasePumlStringList(Source).ItemList);
end;

procedure tBasePumlStringList.clear;
begin
  ItemList.clear;
  inherited clear;
end;

procedure tBasePumlStringList.Delete (Index: Integer);
begin
  ItemList.Delete (index);
end;

function tBasePumlStringList.GetBaseObject (Index: Integer): tJson2PumlBaseObject;
var
  obj: TObject;
begin
  obj := ItemList.Objects[index];
  if Assigned (obj) and (obj is tJson2PumlBaseObject) then
    Result := tJson2PumlBaseObject (obj)
  else
    Result := nil;
end;

function tBasePumlStringList.GetCount: Integer;
begin
  Result := ItemList.Count;
end;

function tBasePumlStringList.GetDuplicates: TDuplicates;
begin
  Result := ItemList.Duplicates;
end;

function tBasePumlStringList.GetFilled: boolean;
begin
  Result := FilledCount > 0;
end;

function tBasePumlStringList.GetFilledCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if Assigned (Objects[i]) then
      if (Objects[i] is tBasePumlObject) then
        if tBasePumlObject (Objects[i]).Filled then
          inc (Result)
        else
      else if (Objects[i] is tBasePumlStringList) then
        if tBasePumlStringList (Objects[i]).Filled then
          inc (Result)
        else
      else
        inc (Result);
end;

function tBasePumlStringList.GetNames (Index: Integer): string;
begin
  Result := ItemList.Names[index];
end;

function tBasePumlStringList.GetObjects (Index: Integer): TObject;
begin
  Result := ItemList.Objects[index];
end;

function tBasePumlStringList.GetOwnsObjects: boolean;
begin
  Result := ItemList.OwnsObjects;
end;

function tBasePumlStringList.GetSorted: boolean;
begin
  Result := ItemList.Sorted;
end;

function tBasePumlStringList.GetStrings (Index: Integer): string;
begin
  Result := ItemList[index];
end;

function tBasePumlStringList.GetText: string;
begin
  Result := ItemList.Text;
end;

function tBasePumlStringList.IndexOf (S: string): Integer;
begin
  Result := ItemList.IndexOf (S);
end;

function tBasePumlStringList.IndexOfName (S: string): Integer;
begin
  Result := ItemList.IndexOfName (S);
end;

procedure tBasePumlStringList.SetDuplicates (const Value: TDuplicates);
begin
  ItemList.Duplicates := Value;
end;

procedure tBasePumlStringList.SetObjects (Index: Integer; const Value: TObject);
begin
  ItemList.Objects[index] := Value;
end;

procedure tBasePumlStringList.SetOwnsObjects (const Value: boolean);
begin
  ItemList.OwnsObjects := Value;
end;

procedure tBasePumlStringList.SetSorted (const Value: boolean);
begin
  ItemList.Sorted := Value;
end;

procedure tBasePumlStringList.SetStrings (Index: Integer; const Value: string);
begin
  ItemList[index] := Value;
end;

procedure tBasePumlStringList.SetText (const Value: string);
begin
  ItemList.Text := Value;
end;

procedure tBasePumlStringList.Sort;
begin
  ItemList.Sort;
end;

procedure tBasePumlStringList.UpdateRedundant;
var
  i: Integer;
begin
  inherited UpdateRedundant;
  for i := 0 to Count - 1 do
    if Assigned (Objects[i]) then
      if (Objects[i] is tBasePumlObject) then
        tBasePumlObject (Objects[i]).UpdateRedundant;
end;

constructor tPumlDetailObjectList.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  Sorted := true;
  Duplicates := dupIgnore;
  OwnsObjects := False;
end;

procedure tPumlDetailObjectList.GeneratePumlClassList (ipuml: TStrings);
var
  i: Integer;
begin
  if Count <= 0 then
    Exit;
  for i := 0 to Count - 1 do
  begin
    if Assigned (Objects[i]) and (Objects[i] is tPumlObject) and tPumlObject (Objects[i]).ShowObject then
    begin
      ipuml.add (Format('  %s', [tPumlObject(Objects[i]).GeneratePumlClassName]));
      tPumlObject (Objects[i]).DetailObjects.GeneratePumlClassList (ipuml);
    end
    else
      ipuml.add (Format('  class %s ', [Strings[i]]));
  end;
end;

procedure tPumlDetailObjectList.GeneratePumlTogether (ipuml: TStrings; iParentObjectName, iParentObjectTitle: string);
begin
  if (Count <= 0) then
    Exit;
  ipuml.add ('together {');
  ipuml.add (Format('  %s', [ParentUmlObject.GeneratePumlClassName]));
  GeneratePumlClassList (ipuml);
  ipuml.add ('}');
  ipuml.add ('');
end;

constructor tPumlCharacteristicRecord.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
end;

function tPumlCharacteristicRecord.AddValue (iAttribute, iValue: string; iReplace: boolean = true)
  : tPumlCharacteristicValue;
var
  NewValue: tPumlCharacteristicValue;
  i: Integer;
begin
  NewValue := tPumlCharacteristicValue.Create (Self);
  NewValue.Attribute := iAttribute;
  NewValue.Value := iValue;
  i := IndexOf (NewValue.Ident);
  if i >= 0 then
    if iReplace then
    begin
      Delete (i);
      AddObject (NewValue.Ident, NewValue);
      Result := NewValue;
    end
    else
    begin
      NewValue.Free;
      Result := Value[i];
    end
  else
  begin
    AddObject (NewValue.Ident, NewValue);
    Result := NewValue;
  end;
end;

procedure tPumlCharacteristicRecord.AddValues (iValueList: TStringList);
var
  i: Integer;
begin
  for i := 0 to iValueList.Count - 1 do
    AddValue (iValueList.Names[i], iValueList.ValueFromIndex[i]);
end;

function tPumlCharacteristicRecord.CalculateRecordLine: string;
begin
  Result := '';

end;

procedure tPumlCharacteristicRecord.CalculateTableRow (iUsedColumns, iValueList: TStringList);
var
  CharVal: tPumlCharacteristicValue;
begin
  for CharVal in Self do
    CharVal.CalculateTableRow (iUsedColumns, iValueList);
end;

procedure tPumlCharacteristicRecord.CalculateTableRows (iDefinition: tJson2PumlCharacteristicDefinition;
  iUsedColumns, iTableRows: TStringList);
var
  ValueList: TStringList;
  CharVal: tPumlCharacteristicValue;
begin
  ValueList := TStringList.Create;
  try
    for CharVal in Self do
      CharVal.CalculateTableRow (iUsedColumns, ValueList);
    if ValueList.Count > 0 then
      iTableRows.add (ValueList.Text);
  finally
    ValueList.Free;
  end;
end;

procedure tPumlCharacteristicRecord.GeneratePumlAsRecord (ipuml: TStrings; iIncludeHeader: boolean;
  iSplitLength: Integer; iSortLines: boolean);
var
  CharVal: tPumlCharacteristicValue;
  IncludeParent: boolean;
  Lines: TStringList;
begin
  IncludeParent := IncludeParentColumn;
  if iIncludeHeader then
  begin
    ipuml.add (Format('<b>%s</b>', [ParentCharacteristicValue.Attribute]));
    if IncludeParent then
      ipuml.add (tPumlHelper.TableLine(['parent', 'attribute', 'value'], true))
    else
      ipuml.add (tPumlHelper.TableLine(['attribute', 'value'], true));
  end;
  Lines := TStringList.Create;
  try
    for CharVal in Self do
      CharVal.GeneratePumlAsRecord (Lines, IncludeParent, iSplitLength);
    if iSortLines then
      Lines.Sort;
    ipuml.AddStrings (Lines);
  finally
    Lines.Free;
  end;
end;

function tPumlCharacteristicRecord.GetAttribute: string;
begin
  if Assigned (ParentCharacteristicValue) then
    Result := ParentCharacteristicValue.Attribute
  else
    Result := '';
end;

function tPumlCharacteristicRecord.GetEnumerator: tPumlCharacteristicValueEnumerator;
begin
  Result := tPumlCharacteristicValueEnumerator.Create (Self);
end;

function tPumlCharacteristicRecord.GetIdent: string;
begin
  Result := Format ('%4d', [Row]);
end;

function tPumlCharacteristicRecord.GetIncludeParentColumn: boolean;
var
  CharValue: tPumlCharacteristicValue;
begin
  Result := not ParentCharacteristicName.IsEmpty;
  if not Result then
    for CharValue in Self do
      if CharValue.DetailRecords.Filled then
      begin
        Result := true;
        Exit;
      end;
end;

function tPumlCharacteristicRecord.GetFilled: boolean;
var
  CharValue: tPumlCharacteristicValue;
begin
  Result := False;
  for CharValue in Self do
  begin
    Result := CharValue.Filled;
    if Result then
      Exit;
  end;
end;

function tPumlCharacteristicRecord.GetParentCharacteristicName: string;
begin
  if Assigned (ParentCharacteristicValue) then
    if ParentCharacteristicValue is tPumlCharacteristicObject then
      Result := ''
    else
      Result := ParentCharacteristicValue.ParentCharacteristicNameAttribute
  else
    Result := '';
end;

function tPumlCharacteristicRecord.GetParentCharacteristicNameIndex: string;
var
  Idx: string;
begin
  if Assigned (ParentCharacteristicValue) then
    if ParentCharacteristicValue is tPumlCharacteristicObject then
      Result := ''
    else
    begin
      if (ParentCharacteristicValue.DetailRecords.Count > 0) and (Row >= 0) then
        Idx := Format ('[%d]', [Row])
      else
        Idx := '';
      Result := string.Join ('.', [ParentCharacteristicValue.ParentCharacteristicNameIndex,
        ParentCharacteristicValue.Attribute]).TrimLeft (['.']);
    end
  else
    Result := '';
end;

function tPumlCharacteristicRecord.GetParentCharacteristicValue: tPumlCharacteristicValue;
begin
  if ParentObject is tPumlCharacteristicValue then
    Result := tPumlCharacteristicValue (ParentObject)
  else
    Result := nil;
end;

function tPumlCharacteristicRecord.GetValue (Index: Integer): tPumlCharacteristicValue;
begin
  Result := tPumlCharacteristicValue (Objects[index]);
end;

constructor tPumlCharacteristicRecordEnumerator.Create (ARecordList: tPumlCharacteristicRecordList);
begin
  inherited Create;
  FIndex := - 1;
  fRecordList := ARecordList;
end;

function tPumlCharacteristicRecordEnumerator.GetCurrent: tPumlCharacteristicRecord;
begin
  Result := tPumlCharacteristicRecord (fRecordList.Objects[FIndex]);
end;

function tPumlCharacteristicRecordEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fRecordList.Count - 1;
  if Result then
    inc (FIndex);
end;

constructor tPumlCharacteristicObject.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  FUsedProperties := TStringList.Create ();
end;

destructor tPumlCharacteristicObject.Destroy;
begin
  FUsedProperties.Free;
  inherited Destroy;
end;

procedure tPumlCharacteristicObject.AddUsedProperties (iPropertyList: TStringList);
var
  i: Integer;
begin
  for i := 0 to iPropertyList.Count - 1 do
    AddUsedProperty (iPropertyList.Names[i]);
end;

procedure tPumlCharacteristicObject.AddUsedProperty (iName: string);
begin
  if UsedProperties.IndexOf (iName) < 0 then
    UsedProperties.add (iName);
end;

procedure tPumlCharacteristicObject.GeneratePuml (ipuml: TStrings; var iAddLine: boolean; iSplitLength: Integer;
  iSortLines: boolean);
// var
// CharRec: tPumlCharacteristicRecord;
// Columns: TStringList;
// Lines: TStringList;
// PropName: string;
// i, j: Integer;
// S: string;
begin
  if not Filled then
    Exit;
  if iAddLine then
    ipuml.add ('---');
  iAddLine := true;
  if Definition.CharacteristicType = jctRecord then
    DetailRecords.GeneratePumlAsRecord (ipuml, true, iSplitLength, iSortLines)
  else
    DetailRecords.GeneratePumlAsList (ipuml, Definition, iSplitLength);

  // if DetailRecords.Count > 0 then
  // begin
  // Columns := TStringList.Create;
  // Lines := TStringList.Create;
  // try
  // if iAddLine then
  // ipuml.add ('---');
  // ipuml.add (Format('<b>%s</b>', [ParentProperty]));
  // if Definition.CharacteristicType = jctRecord then
  // begin
  // i := UsedProperties.IndexOf ('parent');
  // if i > 0 then
  // UsedProperties.Move (i, 0);
  // end
  // else
  // begin
  // i := 0;
  // for s in Definition.Propertylist do
  // begin
  // if s.IsEmpty then
  // Continue;
  // if s.Substring (0, 1) = '-' then
  // Continue;
  // j := UsedProperties.IndexOf (s);
  // if j >= 0 then
  // begin
  // UsedProperties.Move (j, i);
  // inc (i);
  // end;
  // end;
  // end;
  // if Definition.IncludeIndex then
  // Columns.add ('idx');
  // for PropName in UsedProperties do
  // if not PropName.IsEmpty then
  // Columns.add (tPumlHelper.CleanValue(PropName, ParentUmlObject.FormatDefinition.ValueSplitLength));
  // ipuml.add (tPumlHelper.TableLine(Columns, true));
  // for CharRec in Self do
  // begin
  // Columns.Clear;
  // for PropName in UsedProperties do
  // if not PropName.IsEmpty then
  // Columns.add (tPumlHelper.CleanValue(CharRec.Values[PropName],
  // ParentUmlObject.FormatDefinition.ValueSplitLength));
  // Lines.add (tPumlHelper.TableLine(Columns));
  // end;
  // if ParentUmlObject.FormatDefinition.SortAttributes then
  // Lines.Sort;
  // if not Definition.IncludeIndex then
  // ipuml.AddStrings (Lines)
  // else
  // for i := 0 to Lines.Count - 1 do
  // ipuml.add (Format('| %d %s', [i + 1, Lines[i]]));
  // iAddLine := true;
  // finally
  // Columns.Free;
  // Lines.Free;
  // end;
  // end;
end;

class function tPumlHelper.CleanCRLF (iValue: string): string;
begin
  Result := iValue.TrimRight ([' ', #10, #13, #9]).Replace (#13#10, #10).Replace (#13, #10).Replace (#10, cNewLinePuml);
end;

class function tPumlHelper.CleanValue (iValue: string; iSplitLength: Integer): string;
var
  Value: string;
  i: Integer;
begin
  Value := CleanCRLF (iValue);
  if (Value.IndexOf('https://') = 0) or (Value.IndexOf('http://') = 0) then
    Value := Format ('[[%s]]', [Value]);
  if iSplitLength <= 0 then
  begin
    Result := Value;
    Exit;
  end;
  Result := '';
  while Value.Length > iSplitLength do
  begin
    i := Value.IndexOf (cNewLinePuml);
    if i < 0 then
      i := Value.Length - 1;
    if i < iSplitLength then
    begin
      Result := Result + Value.Substring (0, i + 1) + cNewLinePuml;
      Value := Value.Substring (i + 2);
    end
    else
    begin
      i := Value.Substring (0, iSplitLength).LastIndexOf (' ');
      if i < 0 then
        i := Value.IndexOf (' ');
      if (i < 0) and (Value.Length > round(iSplitLength * 1.5)) then
        i := iSplitLength;
      if i > 0 then
      begin
        Result := Result + Value.Substring (0, i) + cNewLinePuml;
        Value := Value.Substring (i);
      end
      else
      begin
        Result := Result + Value + cNewLinePuml;
        Value := '';
      end;
    end;
  end;
  Result := Result + Value;
end;

class function tPumlHelper.PUmlIdentifier (iIdentifier: string): string;
begin
  Result := iIdentifier.Replace (' ', '_').Replace ('-', '_').Replace (':', '_').Replace ('/', '_').Replace ('\', '_')
    .Replace ('.', '_').ToLower;
end;

class function tPumlHelper.RelationLine (iFromIdent, iArrowFormat, iToIdent, iComment: string): string;
begin
  Result := Format ('%s -%s-> %s', [iFromIdent, iArrowFormat, iToIdent]);
  if not iComment.IsEmpty then
    Result := Format ('%s:%s', [Result, iComment]);
end;

class function tPumlHelper.ReplaceNewLine (iValue: string): string;
begin
  Result := iValue.Replace ('\n', '\\n');
end;

class function tPumlHelper.ReplaceTab (iValue: string): string;
begin
  Result := iValue.Replace ('\t', '\<U+200B>t');
end;

class function tPumlHelper.ReplaceTabNewLine (iValue: string): string;
begin
  Result := ReplaceTab (ReplaceNewLine(iValue));
end;

class function tPumlHelper.TableColumn (iValue: string; iHeader: boolean = False): string;
begin
  if iHeader then
    Result := Format ('= %s %s', [iValue.Replace('\n', '\n '), TableColumnSeparator])
  else
    Result := Format (' %s %s', [iValue.Replace('\n', '\n '), TableColumnSeparator]);
end;

class function tPumlHelper.TableColumnSeparator: string;
begin
  Result := '|';
end;

class function tPumlHelper.TableLine (const iColumns: array of const; iHeader: boolean = False): string;
var
  i: Integer;
begin
  Result := '';
  if high(iColumns) < 0 then
    Exit;
  Result := TableColumnSeparator;
  for i := 0 to high(iColumns) do
    Result := Result + TableColumn ('%s', iHeader);
  Result := Format (Result, iColumns).Replace ('\n', '\n ');
end;

class function tPumlHelper.TableLine (iColumns: TStringList; iHeader: boolean = False;
  iClearColumns: boolean = true): string;
var
  S: string;
begin
  Result := '';
  if iColumns.Count <= 0 then
    Exit;
  Result := TableColumnSeparator;
  for S in iColumns do
    Result := Result + TableColumn (S, iHeader);
  if iClearColumns then
    iColumns.clear;
end;

constructor tPumlCharacteristicValue.Create (iParentObject: tBasePumlObject);
begin
  inherited Create (iParentObject);
  FDetailRecords := tPumlCharacteristicRecordList.Create (Self);
end;

destructor tPumlCharacteristicValue.Destroy;
begin
  FDetailRecords.Free;
  inherited Destroy;
end;

function tPumlCharacteristicValue.AddDetailRecord (iRow: Integer): tPumlCharacteristicRecord;
begin
  Result := DetailRecords.AddRecord (iRow);
end;

function tPumlCharacteristicValue.CalculateRecordLine (iIncludeParent: boolean; iSplitLength: Integer): string;
begin
  if iIncludeParent then
    Result := tPumlHelper.TableLine ([ParentCharacteristicNameIndex, Attribute, tPumlHelper.CleanValue(Value,
      iSplitLength)])
  else
    Result := tPumlHelper.TableLine ([Attribute, tPumlHelper.CleanValue(Value, iSplitLength)]);
end;

procedure tPumlCharacteristicValue.CalculateTableRow (iUsedColumns, iValueList: TStringList);
var
  Name: string;
  CharRec: tPumlCharacteristicRecord;
begin
  if DetailRecords.Count > 0 then
  begin
    for CharRec in DetailRecords do
      CharRec.CalculateTableRow (iUsedColumns, iValueList);
  end
  else
  begin
    name := ParentCharacteristicNameAttribute;
    iValueList.AddPair (name, Value);
    if iUsedColumns.IndexOf (name) < 0 then
      iUsedColumns.add (name);
  end;
end;

procedure tPumlCharacteristicValue.GeneratePumlAsRecord (ipuml: TStrings; iIncludeParent: boolean;
  iSplitLength: Integer);
begin
  if DetailRecords.Count > 0 then
    DetailRecords.GeneratePumlAsRecord (ipuml, False, iSplitLength, False)
  else
    ipuml.add (CalculateRecordLine(iIncludeParent, iSplitLength));
end;

function tPumlCharacteristicValue.GetIdent: string;
begin
  Result := Attribute;
end;

function tPumlCharacteristicValue.GetFilled: boolean;
begin
  Result := not Attribute.IsEmpty;
  if not Result then
    Result := DetailRecords.Filled
end;

function tPumlCharacteristicValue.GetParentCharacteristicName: string;
begin
  if Assigned (ParentCharactisticRecord) then
    Result := ParentCharactisticRecord.ParentCharacteristicName
  else
    Result := '';
end;

function tPumlCharacteristicValue.GetParentCharacteristicNameAttribute: string;
begin
  Result := string.Join ('.', [ParentCharacteristicName, Attribute]).TrimLeft (['.']);;
end;

function tPumlCharacteristicValue.GetParentCharacteristicNameIndex: string;
begin
  if Assigned (ParentCharactisticRecord) then
    Result := ParentCharactisticRecord.ParentCharacteristicNameIndex
  else
    Result := '';
end;

function tPumlCharacteristicValue.GetParentCharactisticRecord: tPumlCharacteristicRecord;
begin
  if ParentObject is tPumlCharacteristicRecord then
    Result := tPumlCharacteristicRecord (ParentObject)
  else
    Result := nil;
end;

constructor tPumlCharacteristicValueEnumerator.Create (ARecord: tPumlCharacteristicRecord);
begin
  inherited Create;
  FIndex := - 1;
  fRecord := ARecord;
end;

function tPumlCharacteristicValueEnumerator.GetCurrent: tPumlCharacteristicValue;
begin
  Result := tPumlCharacteristicValue (fRecord.Objects[FIndex]);
end;

function tPumlCharacteristicValueEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fRecord.Count - 1;
  if Result then
    inc (FIndex);
end;

function tPumlCharacteristicRecordList.AddRecord (iRow: Integer): tPumlCharacteristicRecord;
var
  NewRecord: tPumlCharacteristicRecord;
  i: Integer;
begin
  NewRecord := tPumlCharacteristicRecord.Create (ParentObject);
  NewRecord.Row := iRow;
  i := IndexOf (NewRecord.Ident);
  if i >= 0 then
  begin
    NewRecord.Free;
    Result := Records[i];
  end
  else
  begin
    AddObject (NewRecord.Ident, NewRecord);
    Result := NewRecord;
  end;
end;

procedure tPumlCharacteristicRecordList.GeneratePumlAsRecord (ipuml: TStrings; iIncludeHeader: boolean;
  iSplitLength: Integer; iSortLines: boolean);
var
  CharRec: tPumlCharacteristicRecord;
begin
  for CharRec in Self do
    CharRec.GeneratePumlAsRecord (ipuml, iIncludeHeader, iSplitLength, iSortLines);
end;

procedure tPumlCharacteristicRecordList.GeneratePumlAsList (ipuml: TStrings;
  iDefinition: tJson2PumlCharacteristicDefinition; iSplitLength: Integer);
var
  CharRec: tPumlCharacteristicRecord;
  UsedColumns: TStringList;
  TableRows: TStringList;
  ValueList: TStringList;
  Columns: TStringList;
  ResultRows: TStringList;
  Row: string;
  Col: string;
  i: Integer;
  r: Integer;
begin
  ipuml.add (Format('<b>%s</b>', [ParentCharacteristicValue.Attribute]));

  UsedColumns := TStringList.Create;
  Columns := TStringList.Create;
  ValueList := TStringList.Create;
  TableRows := TStringList.Create;
  ResultRows := TStringList.Create;
  try
    for CharRec in Self do
      CharRec.CalculateTableRows (iDefinition, UsedColumns, TableRows);
    iDefinition.SortUsedColumnsByPropertyList (UsedColumns);
    if iDefinition.IncludeIndex then
      UsedColumns.Insert (0, 'idx');
    ipuml.add (tPumlHelper.TableLine(UsedColumns, true, False));
    if iDefinition.IncludeIndex then
      UsedColumns.Delete (0); // to prevent empty columns because for idx there is no value
    for Row in TableRows do
    begin
      if iDefinition.IncludeIndex then
        Columns.add (r.ToString);
      ValueList.Text := Row;
      for Col in UsedColumns do
      begin
        i := ValueList.IndexOfName (Col);
        if i >= 0 then
          Columns.add (tPumlHelper.CleanValue(ValueList.ValueFromIndex[i], iSplitLength))
        else
          Columns.add ('');
      end;
      ResultRows.add (tPumlHelper.TableLine(Columns, False));
    end;
    if iDefinition.SortRows then
      ResultRows.Sort;
    r := 0;
    for Row in ResultRows do
    begin
      inc (r);
      if iDefinition.IncludeIndex then
        ipuml.add (Format('%s %s %s', [tPumlHelper.TableColumnSeparator, r.ToString, Row]))
      else
        ipuml.add (Row);
    end;

  finally
    ResultRows.Free;
    Columns.Free;
    UsedColumns.Free;
    ValueList.Free;
    TableRows.Free;
  end;
end;

function tPumlCharacteristicRecordList.GetEnumerator: tPumlCharacteristicRecordEnumerator;
begin
  Result := tPumlCharacteristicRecordEnumerator.Create (Self);
end;

function tPumlCharacteristicRecordList.GetFilled: boolean;
var
  CharRec: tPumlCharacteristicRecord;
begin
  Result := False;
  for CharRec in Self do
  begin
    Result := CharRec.Filled;
    if Result then
      Exit;
  end;
end;

function tPumlCharacteristicRecordList.GetParentCharacteristicValue: tPumlCharacteristicValue;
begin
  if ParentObject is tPumlCharacteristicValue then
    Result := tPumlCharacteristicValue (ParentObject)
  else
    Result := nil;
end;

function tPumlCharacteristicRecordList.GetRecords (Index: Integer): tPumlCharacteristicRecord;
begin
  Result := tPumlCharacteristicRecord (Objects[index]);
end;

end.
