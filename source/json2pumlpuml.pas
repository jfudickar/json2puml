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

uses System.JSON, System.Classes, json2pumldefinition, json2pumlconst, json2pumlconverterdefinition;

type
  tPumlObject = class;

  tPumlHelper = class
  public
    class function RelationLine (iFromIdent, iArrowFormat, iToIdent, iComment: string): string;
    class function PUmlIdentifier (iIdentifier: string): string;
    class function CleanCRLF (iValue: string): string;
    class function CleanValue (iValue: string; iSplitLength: Integer): string;
    class function ReplaceNewLine (iValue: string): string;
    class function ReplaceTab (iValue: string): string;
    class function ReplaceTabNewLine (iValue: string): string;
    class function TableColumn (iValue: string; iHeader: boolean = False): string;
    class function TableLine (const iColumns: array of const; iHeader: boolean = False): string; overload;
    class function TableLine (iColumns: TStringList; iHeader: boolean = False): string; overload;
  end;

  tBasePumlObject = class(tPersistent)
  private
    FParentUmlObject: tPumlObject;
    function GetFilled: boolean; virtual;
    function GetIdent: string; virtual;
  protected
    property ParentUmlObject: tPumlObject read FParentUmlObject;
  public
    constructor Create (iParentUmlObject: tPumlObject);
    procedure UpdateRedundant; virtual;
    property Filled: boolean read GetFilled;
    property Ident: string read GetIdent;
  end;

  tBasePumlStringList = class(TStringList)
  private
    FParentUmlObject: tPumlObject;
    function GetFilled: boolean; virtual;
    function GetFilledCount: Integer; virtual;
    function GetIdent: string; virtual;
  protected
    property ParentUmlObject: tPumlObject read FParentUmlObject;
  public
    constructor Create (iParentUmlObject: tPumlObject);
    procedure UpdateRedundant; virtual;
    property Filled: boolean read GetFilled;
    property FilledCount: Integer read GetFilledCount;
    property Ident: string read GetIdent;
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
    function GetRelatedObjectShowObject: boolean;
    function GetRelatedObjectFiltered: boolean;
    function GetRelatedObjectGroupName: string;
    function GetRelatedObjectTypeIdent: string;
    function GetRelatedObjectIdentifier: string;
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
    property RelatedObjectShowObject: boolean read GetRelatedObjectShowObject;
    property RelatedObjectFiltered: boolean read GetRelatedObjectFiltered;
    property RelatedObjectGroupName: string read GetRelatedObjectGroupName;
    property RelatedObjectTypeIdent: string read GetRelatedObjectTypeIdent;
    property RelatedObjectIdentifier: string read GetRelatedObjectIdentifier;
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
    constructor Create (iParentUmlObject: tPumlObject);
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

  tPumlCharacteristicRecord = class(tBasePumlStringList)
  private
    FIntIdent: string;
    function GetIdent: string; override;
  protected
    procedure AddProperties (iPropertyList: TStringList);
    property IntIdent: string read FIntIdent;
  public
  end;

  tPumlCharacteristicObject = class;

  tPumlCharacteristicRecordEnumerator = class
  private
    fCharacteristic: tPumlCharacteristicObject;
    FIndex: Integer;
  public
    constructor Create (ACharacteristic: tPumlCharacteristicObject);
    function GetCurrent: tPumlCharacteristicRecord;
    function MoveNext: boolean;
    property Current: tPumlCharacteristicRecord read GetCurrent;
  end;

  tPumlCharacteristicObject = class(tBasePumlStringList)
  private
    FDefinition: tJson2PumlCharacteristicDefinition;
    FParentProperty: string;
    FRecordProperties: tstringlist;
    FUsedProperties: TStringList;
    function GetIdent: string; override;
  protected
    procedure AddUsedProperties (iPropertyList: TStringList);
    procedure AddUsedProperty (iName: string);
    property RecordProperties: tstringlist read FRecordProperties;
    property UsedProperties: TStringList read FUsedProperties;
  public
    constructor Create(iParentUmlObject: tPumlObject);
    destructor Destroy; override;
    procedure AddRecord (iPropertyList: TStringList); overload;
    procedure AddRecord; overload;
    procedure AddRecordProperty(iPropertyName, iPropertyValue: string; iParentProperty: string = '');
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
    function GetEnumerator: tPumlCharacteristicRecordEnumerator;
  published
    property Definition: tJson2PumlCharacteristicDefinition read FDefinition write FDefinition;
    property ParentProperty: string read FParentProperty write FParentProperty;
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
    function GetPropertyCharacteristic (Index: Integer): tPumlCharacteristicObject;
  protected
    function AddCharacteristic(iParentProperty: string; iCharacteristicDefinition: tJson2PumlCharacteristicDefinition):
        tPumlCharacteristicObject;
  public
    constructor Create (iParentUmlObject: tPumlObject); overload;
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
    function GetEnumerator: tPumlCharacteristicObjectEnumerator;
    property PropertyCharacteristic[index: Integer]: tPumlCharacteristicObject read GetPropertyCharacteristic; default;
  end;

  tPumlDetailObjectList = class(tBasePumlStringList)
  public
    procedure GeneratePumlTogether (ipuml: TStrings; iParentObjectName, iParentObjectTitle: string);
    procedure GeneratePumlClassList (ipuml: TStrings);
  end;

  tPumlObjectValueList = class(tBasePumlStringList)
  private
    function GetFilledCount: Integer; override;
  public
    procedure AddPumlValueLine (ipuml: TStrings; iIndex: Integer);
    procedure AddValue (iName, iValue: string; iReplace: boolean = true);
  end;

  tPumlObject = class(tBasePumlObject)
  private
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
    FPropertyCharacteristics: tPumlCharacteristicList;
    FRelations: tPumlObjectRelationshipList;
    FValues: tPumlObjectValueList;
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
    constructor Create;
    destructor Destroy; override;
    function AddCharacteristic(iParentProperty: string; iCharacteristicDefinition: tJson2PumlCharacteristicDefinition):
        tPumlCharacteristicObject;
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
    property PropertyCharacteristics: tPumlCharacteristicList read FPropertyCharacteristics;
    property Relations: tPumlObjectRelationshipList read FRelations;
    property Values: tPumlObjectValueList read FValues;
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
    constructor Create; overload;
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
  System.Generics.Collections, System.Types, System.IOUtils, json2pumltools, System.Variants;

constructor tPumlObjectList.Create;
begin
  inherited Create (nil);
  Sorted := true;
  duplicates := dupIgnore;
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
  inherited Create (Self);
  FValues := tPumlObjectValueList.Create (Self);
  FPropertyCharacteristics := tPumlCharacteristicList.Create (Self);
  FRelations := tPumlObjectRelationshipList.Create (Self);
  FDetailObjects := tPumlDetailObjectList.Create (Self);
  FDetailObjects.Sorted := true;
  FDetailObjects.duplicates := dupIgnore;
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
  FPropertyCharacteristics.Free;
  FValues.Free;
  inherited Destroy;
end;

function tPumlObject.AddCharacteristic(iParentProperty: string; iCharacteristicDefinition:
    tJson2PumlCharacteristicDefinition): tPumlCharacteristicObject;
begin
  Result := PropertyCharacteristics.AddCharacteristic (iParentProperty, iCharacteristicDefinition);
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
  Values.AddValue (iName, iValue, iReplace);
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
//  if not ObjectType.IsEmpty then
//    ipuml.add (Format('<b>%s - %s</b>', [ObjectType, ObjectIdent]))
//  else
//    ipuml.add (Format('<b>%s</b>', [ObjectIdent]));
  if not ObjectType.IsEmpty then
    ipuml.add (Format('<b>%s</b>', [ObjectType]));
  if (Values.Count > 0) and FormatDefinition.ShowAttributes then
  begin
    ipuml.add (tPumlHelper.TableLine(['attribute', 'value'], true));
    idLine := Values.IndexOfName (ObjectIdentProperty);
    NameLine := Values.IndexOfName (ObjectTitleProperty);
    if idLine >= 0 then
      Values.AddPumlValueLine (ipuml, idLine);
    if NameLine >= 0 then
      Values.AddPumlValueLine (ipuml, NameLine);
    Lines := TStringList.Create;
    try
      for i := 0 to Values.Count - 1 do
        if (i <> idLine) and (i <> NameLine) then
          Values.AddPumlValueLine (Lines, i);
      if FormatDefinition.SortAttributes then
        Lines.Sort;
      ipuml.AddStrings (Lines);
    finally
      Lines.Free;
    end;
    AddLine := true;
  end;
  if FormatDefinition.ShowCharacteristics then
    PropertyCharacteristics.GeneratePuml (ipuml, AddLine);
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

function tPumlObject.GetFilled: boolean;
begin
  Result := Values.Filled or PropertyCharacteristics.Filled or
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
    s: string;
  begin
    if iValue.IsEmpty then
      Exit;
    if iFormat then
      s := Format ('<%s>%s</%s>', [iFormatChar, iValue, iFormatChar])
    else
      s := iValue;
    if NewCaption.IsEmpty then
      NewCaption := s
    else if (NewCaptionLengh > SplitLength) and (SplitLength > 0) then
      NewCaption := Format ('%s%s%s', [NewCaption, iSeparator, s])
    else
      NewCaption := Format ('%s %s', [NewCaption, s]);
    NewCaptionLengh := NewCaptionLengh + Length (iValue);
  end;

  Function SplitPosition (s : String) : Integer;
  begin
    Result := s.Substring (SplitLength).IndexOf (FormatDefinition.CaptionSplitCharacter);
    if (Result < 0) and (s.Length > round(Splitlength*1.5)) then
      Result := SplitLength;
  end;


  procedure SplitIdent;
  var
    s: string;
    i: Integer;
  begin
    if (ObjectIdent.Length > SplitLength) and (SplitLength > 0) then
    begin
      NewIdent := '';
      s := ObjectIdent;
      i := SplitPosition (s);
      while (i >= 0) and (s.Length - i - SplitLength > 5) do
      begin
        if iFormat then
          NewIdent := NewIdent + s.Substring (0, SplitLength + i) + '</i>' + iSeparator + '    <i>'
        else
          NewIdent := NewIdent + s.Substring (0, SplitLength + i) + iSeparator + '    ';
        s := s.Substring (SplitLength + i);
        i := SplitPosition (s);
      end;
      NewIdent := NewIdent + s;
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
      tPumlHelper.CleanValue(RelatedObjectCaption, ParentUmlObject.FormatDefinition.ValueSplitLength)]))
  else
    ipuml.add (tPumlHelper.TableLine([tPumlHelper.CleanValue(RelatedObjectCaption,
      ParentUmlObject.FormatDefinition.ValueSplitLength), tPumlHelper.CleanCRLF(PropertyName),
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

function tPumlObjectRelationship.GetRelatedObjectShowObject: boolean;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ShowObject
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
  Result := tPumlHelper.PUmlIdentifier (string.join('_', [RelatedObject.ObjectIdentifier, 'group',
    ParentUmlObject.ObjectType, PropertyName]));
end;

function tPumlObjectRelationship.GetRelatedObjectTypeIdent: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectTypeIdent
  else
    Result := '';
end;

function tPumlObjectRelationship.GetRelatedObjectIdentifier: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectIdentifier
  else
    Result := '';
end;

constructor tPumlObjectRelationshipList.Create (iParentUmlObject: tPumlObject);
begin
  inherited Create (iParentUmlObject);
  Sorted := true;
  duplicates := dupAccept;
  OwnsObjects := true;
end;

function tPumlObjectRelationshipList.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
  RelatedObject: tPumlObject; iDirection: tUmlRelationDirection; iGroupAtObject, iGroupAtRelatedObject: boolean;
  iArrowFormat: string; iAllways: boolean = true): boolean;
var
  pumlObjectRelationship: tPumlObjectRelationship;
begin
  pumlObjectRelationship := tPumlObjectRelationship.Create (ParentUmlObject);
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
    GroupTitle : string;
    ClassIdent: string;
    Color: string;
    ParentObject: tPumlObject;
  begin
    if (iDirection = urdTo) and r.GroupAtObject then
    begin
      GroupIdent := r.ObjectGroupName;
      //GroupTitle := r.RelatedObject.ObjectType+' ->\n'+r.ParentUmlObject.ObjectType;
      GroupTitle := r.ParentUmlObject.ObjectType+' ->\n'+r.RelatedObject.ObjectType;
    end
    else if (iDirection = urdFrom) and r.GroupAtRelatedObject then
    begin
      GroupIdent := r.RelatedObjectGroupName;
      GroupTitle := r.ParentUmlObject.ObjectType+' ->\n'+r.RelatedObject.ObjectType;
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
          'from ' + r.ParentUmlObject.ObjectType));
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

constructor tPumlCharacteristicList.Create (iParentUmlObject: tPumlObject);
begin
  inherited Create (iParentUmlObject);
  OwnsObjects := true;
  // Sorted := true;
  // duplicates := dupError;
end;

function tPumlCharacteristicList.AddCharacteristic(iParentProperty: string; iCharacteristicDefinition:
    tJson2PumlCharacteristicDefinition): tPumlCharacteristicObject;
var
  i: Integer;
begin
  Result := tPumlCharacteristicObject.Create (ParentUmlObject);
  Result.ParentProperty := iParentProperty;
  Result.Definition := iCharacteristicDefinition;
  i := IndexOf (Result.Ident);
  if i < 0 then
    AddObject (Result.Ident, Result)
  else
  begin
    Result.Free;
    Result := tPumlCharacteristicObject (Objects[i]);
  end;
end;

procedure tPumlCharacteristicList.GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
var
  PropertyCharacteristic: tPumlCharacteristicObject;
begin
  for PropertyCharacteristic in Self do
    PropertyCharacteristic.GeneratePuml (ipuml, iAddLine);
end;

function tPumlCharacteristicList.GetEnumerator: tPumlCharacteristicObjectEnumerator;
begin
  Result := tPumlCharacteristicObjectEnumerator.Create (Self);
end;

function tPumlCharacteristicList.GetPropertyCharacteristic (Index: Integer): tPumlCharacteristicObject;
begin
  Result := tPumlCharacteristicObject (Objects[index]);
end;

constructor tBasePumlObject.Create (iParentUmlObject: tPumlObject);
begin
  inherited Create;
  FParentUmlObject := iParentUmlObject;
end;

function tBasePumlObject.GetFilled: boolean;
begin
  Result := true;
end;

function tBasePumlObject.GetIdent: string;
begin
  Result := '';
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

constructor tBasePumlStringList.Create (iParentUmlObject: tPumlObject);
begin
  inherited Create;
  FParentUmlObject := iParentUmlObject;
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

function tBasePumlStringList.GetIdent: string;
begin
  Result := '';
end;

procedure tBasePumlStringList.UpdateRedundant;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Assigned (Objects[i]) then
      if (Objects[i] is tBasePumlObject) then
        tBasePumlObject (Objects[i]).UpdateRedundant;
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

procedure tPumlCharacteristicRecord.AddProperties (iPropertyList: TStringList);
begin
  AddStrings (iPropertyList);
  iPropertyList.Sort;
  FIntIdent := iPropertyList.Text;
end;

function tPumlCharacteristicRecord.GetIdent: string;
begin
  Result := IntIdent;
end;

constructor tPumlCharacteristicRecordEnumerator.Create (ACharacteristic: tPumlCharacteristicObject);
begin
  inherited Create;
  FIndex := - 1;
  fCharacteristic := ACharacteristic;
end;

function tPumlCharacteristicRecordEnumerator.GetCurrent: tPumlCharacteristicRecord;
begin
  Result := tPumlCharacteristicRecord (fCharacteristic.Objects[FIndex]);
end;

function tPumlCharacteristicRecordEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fCharacteristic.Count - 1;
  if Result then
    inc (FIndex);
end;

constructor tPumlCharacteristicObject.Create(iParentUmlObject: tPumlObject);
begin
  inherited Create (iParentUmlObject);
  FUsedProperties := TStringList.Create ();
  FRecordProperties := tstringlist.Create();
end;

destructor tPumlCharacteristicObject.Destroy;
begin
  FRecordProperties.Free;
  FUsedProperties.Free;
  inherited Destroy;
end;

procedure tPumlCharacteristicObject.AddRecord (iPropertyList: TStringList);
var
  Rec: tPumlCharacteristicRecord;
begin
  if iPropertyList.Count < 0 then
    Exit;
  Rec := tPumlCharacteristicRecord.Create (ParentUmlObject);
  Rec.AddProperties (iPropertyList);
  if IndexOf (Rec.Ident) < 0 then
  begin
    AddUsedProperties (Rec);
    AddObject (Rec.Ident, Rec);
  end
  else
    Rec.Free;
end;

procedure tPumlCharacteristicObject.AddRecord;
begin
  AddRecord(RecordProperties);
  RecordProperties.Clear;
end;

procedure tPumlCharacteristicObject.AddRecordProperty(iPropertyName, iPropertyValue: string; iParentProperty: string =
    '');
begin
  if Definition.CharacteristicType = jctList then
    RecordProperties.AddPair(string.Join('.',[iParentProperty, iPropertyName]).TrimLeft(['.']), iPropertyValue)
  else
  begin
    if not iParentProperty.IsEmpty then
      RecordProperties.AddPair('parent', iParentProperty);
    RecordProperties.AddPair('attribute', iPropertyName);
    RecordProperties.AddPair('value', iPropertyValue);
    AddRecord;
  end;
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

procedure tPumlCharacteristicObject.GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
var
  CharRec: tPumlCharacteristicRecord;
  Columns: TStringList;
  Lines: TStringList;
  PropName: string;
  i,j: Integer;
  s :string;
begin
  if Count > 0 then
  begin
    Columns := TStringList.Create;
    Lines := TStringList.Create;
    try
      if iAddLine then
        ipuml.add ('---');
      ipuml.add (Format('<b>%s</b>', [ParentProperty]));
      if Definition.CharacteristicType = jctRecord then
      begin
        i := UsedProperties.IndexOf ('parent');
        if i > 0 then
          UsedProperties.Move (i, 0);
      end
      else
      begin
        i := 0;
        for s in Definition.Propertylist do
        begin
          if s.IsEmpty then
            Continue;
          if s.substring(0,1) = '-' then
            Continue;
          j := UsedProperties.IndexOf(s);
          if j >= 0 then
          begin
            UsedProperties.Move(j,i);
            inc(i);
          end;
        end;
      end;
      if Definition.IncludeIndex then
        Columns.add ('idx');
      for PropName in UsedProperties do
        if not PropName.IsEmpty then
          Columns.add (tPumlHelper.CleanValue(PropName, ParentUmlObject.FormatDefinition.ValueSplitLength));
      ipuml.add (tPumlHelper.TableLine(Columns, true));
      for CharRec in Self do
      begin
        Columns.Clear;
        for PropName in UsedProperties do
          if not PropName.IsEmpty then
            Columns.add (tPumlHelper.CleanValue(CharRec.Values[PropName],
              ParentUmlObject.FormatDefinition.ValueSplitLength));
        Lines.add (tPumlHelper.TableLine(Columns));
      end;
      if ParentUmlObject.FormatDefinition.SortAttributes then
        Lines.Sort;
      if not Definition.IncludeIndex then
        ipuml.AddStrings (Lines)
      else
        for i := 0 to Lines.Count - 1 do
          ipuml.add (Format('| %d %s', [i + 1, Lines[i]]));
      iAddLine := true;
    finally
      Columns.Free;
      Lines.Free;
    end;
  end;
end;

function tPumlCharacteristicObject.GetEnumerator: tPumlCharacteristicRecordEnumerator;
begin
  Result := tPumlCharacteristicRecordEnumerator.Create (Self);
end;

function tPumlCharacteristicObject.GetIdent: string;
begin
  Result := ParentProperty;
end;

procedure tPumlObjectValueList.AddPumlValueLine (ipuml: TStrings; iIndex: Integer);
begin
  ipuml.add (tPumlHelper.TableLine([Names[iIndex], tPumlHelper.CleanValue(ValueFromIndex[iIndex],
    ParentUmlObject.FormatDefinition.ValueSplitLength)]));
end;

procedure tPumlObjectValueList.AddValue (iName, iValue: string; iReplace: boolean = true);
var
  i: Integer;
begin
  i := IndexOfName (iName);
  if i >= 0 then
    if iReplace then
      Values[iName] := iValue
    else if not iValue.IsEmpty then
      Values[iName] := Format ('%s\n %s', [Values[iName], iValue])
    else
  else
    AddPair (iName, iValue);
end;

function tPumlObjectValueList.GetFilledCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if not ValueFromIndex[i].IsEmpty then
      inc (Result);
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
      if (i < 0) and (Value.Length > Round(iSplitLength*1.5)) then
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
    Result := Format ('= %s |', [iValue])
  else
    Result := Format (' %s |', [iValue]);
end;

class function tPumlHelper.TableLine (const iColumns: array of const; iHeader: boolean = False): string;
var
  i: Integer;
begin
  Result := '';
  if high(iColumns) < 0 then
    Exit;
  Result := '|';
  for i := 0 to high(iColumns) do
    Result := Result + TableColumn ('%s', iHeader);
  Result := Format (Result, iColumns);
end;

class function tPumlHelper.TableLine (iColumns: TStringList; iHeader: boolean = False): string;
var
  s: string;
begin
  Result := '';
  if iColumns.Count <= 0 then
    Exit;
  Result := '|';
  for s in iColumns do
    Result := Result + TableColumn (s, iHeader);
  iColumns.Clear;
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

end.
