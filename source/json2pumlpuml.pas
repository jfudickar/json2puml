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

unit json2pumlpuml;

interface

uses System.JSON, System.Classes, json2pumldefinition, json2pumlconst, json2pumlconverterdefinition;

type
  tPumlObject = class;

  tBasePumlObject = class(tPersistent)
  private
    function GetFilled: boolean; virtual;
    function GetIdent: string; virtual;
  public
    function CleanCRLF (iValue: string; iReplace: string = ';'): string;
    function TableLine (iColumns: TStringList; iHeader: boolean = False): string;
    procedure UpdateRedundant; virtual;
    property Filled: boolean read GetFilled;
    property Ident: string read GetIdent;
  end;

  tBasePumlStringList = class(TStringList)
  private
    function GetFilled: boolean; virtual;
    function GetFilledCount: Integer; virtual;
    function GetIdent: string; virtual;
  public
    function CleanCRLF (iValue: string; iReplace: string = ';'): string;
    function TableLine (iColumns: TStringList; iHeader: boolean = False): string;
    procedure UpdateRedundant; virtual;
    property Filled: boolean read GetFilled;
    property FilledCount: Integer read GetFilledCount;
    property Ident: string read GetIdent;
  end;

  tUmlRelationDirection = (urdTo, urdFrom);

  tUmlRelationDirectionHelper = record helper for tUmlRelationDirection
    procedure FromString (aValue: string);
    function ToString: string;
  end;

  tPumlObjectRelationship = class(tBasePumlObject)
  private
    FDirection: tUmlRelationDirection;
    FPropertyName: string;
    FRelatedObject: tPumlObject;
    FRelationshipType: string;
    FRelationshipTypeProperty: string;
    function GetFilled: boolean; override;
    function GetIdent: string; override;
    function GetRelatedObjectCaption: string;
    function GetRelatedObjectFilled: boolean;
    function GetRelatedObjectFiltered: boolean;
    function GetRelatedObjectTypeIdent: string;
  public
    procedure GeneratePuml (ipuml: TStrings);
    property Direction: tUmlRelationDirection read FDirection write FDirection;
    property PropertyName: string read FPropertyName write FPropertyName;
    property RelatedObject: tPumlObject read FRelatedObject write FRelatedObject;
    property RelatedObjectCaption: string read GetRelatedObjectCaption;
    property RelatedObjectFilled: boolean read GetRelatedObjectFilled;
    property RelatedObjectFiltered: boolean read GetRelatedObjectFiltered;
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
    constructor Create; overload;
    function addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
      RelatedObject: tPumlObject; Direction: tUmlRelationDirection; iAllways: boolean = true): boolean;
    procedure GeneratePuml (ipuml: TStrings; iDirection: tUmlRelationDirection; var iAddLine: boolean);
    function GetEnumerator: tPumlObjectRelationshipEnumerator;
    property FromCount: Integer read GetFromCount;
    property FromCountValid: Integer read GetFromCountValid;
    property Relationship[index: Integer]: tPumlObjectRelationship read GetRelationship; default;
    property ToCount: Integer read GetToCount;
    property ToCountValid: Integer read GetToCountValid;
  end;

  tPumlCharacteristicRecord = class(tBasePumlObject)
  private
    FIndex: Integer;
    FInfo: string;
    FName: string;
    FValue: string;
    function GetIdent: string; override;
  public
    property index: Integer read FIndex write FIndex;
    property Info: string read FInfo write FInfo;
    property name: string read FName write FName;
    property Value: string read FValue write FValue;
  end;

  tPumlCharacteristic = class;

  tPumlCharacteristicRecordEnumerator = class
  private
    fCharacteristic: tPumlCharacteristic;
    FIndex: Integer;
  public
    constructor Create (ACharacteristic: tPumlCharacteristic);
    function GetCurrent: tPumlCharacteristicRecord;
    function MoveNext: boolean;
    property Current: tPumlCharacteristicRecord read GetCurrent;
  end;

  tPumlCharacteristic = class(tBasePumlStringList)
  private
    FCharacteristicType: tJson2PumlCharacteristicType;
    FIncludeIndex: boolean;
    FInfoProperty: string;
    FNameProperty: string;
    FParentProperty: string;
    FValueProperty: string;
    function GetCharRecord (Index: Integer): tPumlCharacteristicRecord;
    function GetIdent: string; override;
  public
    procedure AddRecord (iName, iValue, iInfo: string);
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
    function GetEnumerator: tPumlCharacteristicRecordEnumerator;
    property CharRecord[index: Integer]: tPumlCharacteristicRecord read GetCharRecord; default;
  published
    property CharacteristicType: tJson2PumlCharacteristicType read FCharacteristicType write FCharacteristicType;
    property IncludeIndex: boolean read FIncludeIndex write FIncludeIndex;
    property InfoProperty: string read FInfoProperty write FInfoProperty;
    property NameProperty: string read FNameProperty write FNameProperty;
    property ParentProperty: string read FParentProperty write FParentProperty;
    property ValueProperty: string read FValueProperty write FValueProperty;
  end;

  tPumlCharacteristicList = class;

  tPumlCharacteristicEnumerator = class
  private
    fCharacteristicList: tPumlCharacteristicList;
    FIndex: Integer;
  public
    constructor Create (ACharacteristicList: tPumlCharacteristicList);
    function GetCurrent: tPumlCharacteristic;
    function MoveNext: boolean;
    property Current: tPumlCharacteristic read GetCurrent;
  end;

  tPumlCharacteristicList = class(tBasePumlStringList)
  private
    function GetPropertyCharacteristic (Index: Integer): tPumlCharacteristic;
  protected
    function AddPropertyCharacteristic (iParentProperty: string): tPumlCharacteristic;
  public
    constructor Create; overload;
    procedure AddCharacteristic (iParentProperty, iName, iValue, iInfo: string;
      iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
    procedure GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
    function GetEnumerator: tPumlCharacteristicEnumerator;
    property PropertyCharacteristic[index: Integer]: tPumlCharacteristic read GetPropertyCharacteristic; default;
  end;

  tPumlDetailObjectList = class(tBasePumlStringList)
  public
    procedure GeneratePuml (ipuml: TStrings; iParentObjectName, iParentObjectTitle: string);
    procedure GeneratePumlClassList (ipuml: TStrings);
  end;

  tPumlObjectValueList = class(tBasePumlStringList)
  private
    function GetFilledCount: Integer; override;
  public
    procedure AddPumlValueLine(ipuml: TStrings; iIndex: Integer);
    procedure AddValue (iName, iValue: string; iReplace: boolean = true);
  end;

  tPumlObject = class(tBasePumlObject)
  private
    FDetailObjects: tPumlDetailObjectList;
    FFiltered: boolean;
    FFormatDefinition: tJson2PumlSingleFormatDefinition;
    FIdentifyObjectsByTypeAndIdent: boolean;
    FInputFilter: tJson2PumlFilterList;
    FIsObjectDetail: boolean;
    FIsGroupProperty: boolean;
    FIsRelationship: boolean;
    FObjectIdent: string;
    FObjectTitle: string;
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
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddCharacteristic (iParentProperty, iName, iValue, iInfo: string;
      iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
    function addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
      RelatedObject: tPumlObject; Direction: tUmlRelationDirection; iAllways: boolean = true): boolean;
    procedure AddValue (iName, iValue: string; iReplace: boolean = true);
    function GeneratePuml (ipuml: TStrings): boolean;
    function IsFiltered: boolean;
    function ObjectCaption (iSeparator: string; iFormat: boolean): string;
    procedure UpdateRedundant; override;
    property Filtered: boolean read FFiltered write FFiltered;
    property FormatDefinition: tJson2PumlSingleFormatDefinition read FFormatDefinition write FFormatDefinition;
    property InputFilter: tJson2PumlFilterList read FInputFilter write FInputFilter;
    property IsObjectDetail: boolean read FIsObjectDetail write FIsObjectDetail;
    property IsGroupProperty: boolean read FIsGroupProperty write FIsGroupProperty;
    property IsRelationship: boolean read FIsRelationship write FIsRelationship;
    property ObjectIdentifier: string read GetObjectIdentifier;
    property ObjectTypeIdent: string read GetObjectTypeIdent;
    property PlantUmlIdent: string read GetPlantUmlIdent;
    property ShowObject: boolean read GetShowObject;
  published
    property DetailObjects: tPumlDetailObjectList read FDetailObjects;
    property IdentifyObjectsByTypeAndIdent: boolean read FIdentifyObjectsByTypeAndIdent
      write FIdentifyObjectsByTypeAndIdent;
    property ObjectIdent: string read FObjectIdent write FObjectIdent;
    property ObjectTitle: string read FObjectTitle write FObjectTitle;
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
    function SearchCreatePumlObject (iObjectType, iObjectIdent, iParentObjectType: string): tPumlObject;
    property ConverterDefinition: tJson2PumlConverterDefinition read FConverterDefinition write FConverterDefinition;
    property InputFilter: tJson2PumlFilterList read FInputFilter write FInputFilter;
    property PumlObject[index: Integer]: tPumlObject read GetPumlObject; default;
  end;

  tPumlRelationship = class(tBasePumlObject)
  private
    FFromObject: tPumlObject;
    FPropertyName: string;
    FRelationshipType: string;
    FRelationshipTypeProperty: string;
    FToObject: tPumlObject;
    function GetFilled: boolean; override;
    function GetFiltered: boolean;
    function GetFromObjectPlantUmlIdent: string;
    function GetFromObjectIdentifier: string;
    function GetIdent: string; override;
    function GetIsObjectDetailRelationship: boolean;
    function GetIsGroupPropertyRelationship: boolean;
    function GetToObjectPlantUmlIdent: string;
    function GetToObjectIdentifier: string;
  public
    constructor Create;
    function GeneratePuml (ipuml, iRelationshipTypeArrowFormats: TStrings): boolean;
    property Filtered: boolean read GetFiltered;
    property IsObjectDetailRelationship: boolean read GetIsObjectDetailRelationship;
    property IsGroupPropertyRelationship: boolean read GetIsGroupPropertyRelationship;
  published
    property FromObject: tPumlObject read FFromObject write FFromObject;
    property FromObjectPlantUmlIdent: string read GetFromObjectPlantUmlIdent;
    property FromObjectIdentifier: string read GetFromObjectIdentifier;
    property PropertyName: string read FPropertyName write FPropertyName;
    property RelationshipType: string read FRelationshipType write FRelationshipType;
    property RelationshipTypeProperty: string read FRelationshipTypeProperty write FRelationshipTypeProperty;
    property ToObject: tPumlObject read FToObject write FToObject;
    property ToObjectPlantUmlIdent: string read GetToObjectPlantUmlIdent;
    property ToObjectIdentifier: string read GetToObjectIdentifier;
  end;

  tPumlRelationshipList = class;

  tPumlRelationshipEnumerator = class
  private
    FIndex: Integer;
    fObjectList: tPumlRelationshipList;
  public
    constructor Create (ARelationshipList: tPumlRelationshipList);
    function GetCurrent: tPumlRelationship;
    function MoveNext: boolean;
    property Current: tPumlRelationship read GetCurrent;
  end;

  tPumlRelationshipList = class(tBasePumlStringList)
  private
    function GetRelationship (Index: Integer): tPumlRelationship;
  public
    constructor Create; overload;
    procedure addRelationship (FromObject, ToObject: tPumlObject; RelationshipType, RelationshipTypeProperty,
      PropertyName: string; iAddDuplicate: boolean);
    function GetEnumerator: tPumlRelationshipEnumerator;
    property Relationship[index: Integer]: tPumlRelationship read GetRelationship; default;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections, System.Types, System.IOUtils, json2pumltools;

const
  cUmlRelationDirection: array [tUmlRelationDirection] of string = ('To', 'From');

constructor tPumlRelationshipList.Create;
begin
  inherited;
  Sorted := true;
  duplicates := dupAccept;
  OwnsObjects := true;
end;

procedure tPumlRelationshipList.addRelationship (FromObject, ToObject: tPumlObject;
  RelationshipType, RelationshipTypeProperty, PropertyName: string; iAddDuplicate: boolean);
var
  PumlRelationship: tPumlRelationship;
begin
  PumlRelationship := tPumlRelationship.Create;
  PumlRelationship.FromObject := FromObject;
  PumlRelationship.ToObject := ToObject;
  PumlRelationship.RelationshipType := RelationshipType;
  PumlRelationship.RelationshipTypeProperty := RelationshipTypeProperty;
  PumlRelationship.PropertyName := PropertyName;
  if iAddDuplicate or (IndexOf(PumlRelationship.Ident) < 0) then
    AddObject (PumlRelationship.Ident, PumlRelationship)
  else
    PumlRelationship.Free;
end;

function tPumlRelationshipList.GetEnumerator: tPumlRelationshipEnumerator;
begin
  Result := tPumlRelationshipEnumerator.Create (Self);
end;

function tPumlRelationshipList.GetRelationship (Index: Integer): tPumlRelationship;
begin
  Result := tPumlRelationship (Objects[index]);
end;

constructor tPumlObjectList.Create;
begin
  inherited;
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

function tPumlObjectList.SearchCreatePumlObject (iObjectType, iObjectIdent, iParentObjectType: string): tPumlObject;
var
  pObject: tPumlObject;
  i: Integer;
  Format: tJson2PumlSingleFormatDefinition;
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
    Result := PumlObject[i];
    pObject.Free;
  end
  else
  begin
    Result := pObject;
    addPumlObject (pObject);
  end;
  Format := ConverterDefinition.ObjectFormats.GetFormatByName (iObjectType, iParentObjectType);
  if Assigned (Format) then
    Result.FormatDefinition := Format;
end;

constructor tPumlRelationship.Create;
begin
  inherited Create;
end;

function tPumlRelationship.GeneratePuml (ipuml, iRelationshipTypeArrowFormats: TStrings): boolean;
var
  line: string;
  Arrow: string;
  i: Integer;
  Comment: string;
begin
  Result := False;
  if not (FromObject.ShowObject and ToObject.ShowObject) then
    Exit;
  Result := true;
  i := iRelationshipTypeArrowFormats.IndexOfName (Format('%s.%s', [PropertyName, RelationshipType]).ToLower);
  if i < 0 then
    i := iRelationshipTypeArrowFormats.IndexOfName (PropertyName.ToLower);
  if i < 0 then
    i := iRelationshipTypeArrowFormats.IndexOfName (RelationshipType.ToLower);
  if i >= 0 then
    Arrow := iRelationshipTypeArrowFormats.ValueFromIndex[i]
  else
    Arrow := '';
  Arrow := Format ('-%s->', [Arrow]);
  if IsObjectDetailRelationship then
    Arrow := '*' + Arrow
  else if IsGroupPropertyRelationship then
    Arrow := 'o' + Arrow;
  line := Format ('%s %s %s', [FromObjectPlantUmlIdent, Arrow, ToObjectPlantUmlIdent]);
  Comment := PropertyName;
  if not RelationshipType.trim.IsEmpty then
  begin
    if not Comment.IsEmpty then
      Comment := Format ('%s\l', [Comment]);
    if not RelationshipTypeProperty.IsEmpty then
      Comment := Format ('%s%s: ', [Comment, RelationshipTypeProperty]);
    Comment := Format ('%s%s', [Comment, RelationshipType]);
  end;
  if not Comment.IsEmpty then
    line := Format ('%s:%s', [line, Comment]);
  ipuml.add (line);
end;

function tPumlRelationship.GetFilled: boolean;
begin
  Result := Assigned (FromObject) and FromObject.Filled and Assigned (ToObject) and ToObject.Filled;
end;

function tPumlRelationship.GetFiltered: boolean;
begin
  Result := FromObject.Filtered or ToObject.Filtered;
end;

function tPumlRelationship.GetFromObjectPlantUmlIdent: string;
begin
  if Assigned (FromObject) then
    Result := FromObject.PlantUmlIdent
  else
    Result := '';
end;

function tPumlRelationship.GetFromObjectIdentifier: string;
begin
  if Assigned (FromObject) then
    Result := FromObject.ObjectIdentifier
  else
    Result := '';
end;

function tPumlRelationship.GetIdent: string;
begin
  Result := Format ('%s=>%s:%s.%s', [FromObjectIdentifier, ToObjectIdentifier, RelationshipTypeProperty,
    RelationshipType]);
end;

function tPumlRelationship.GetIsObjectDetailRelationship: boolean;
begin
  if Assigned (ToObject) then
    Result := ToObject.IsObjectDetail
  else
    Result := False;
end;

function tPumlRelationship.GetIsGroupPropertyRelationship: boolean;
begin
  if Assigned (ToObject) then
    Result := ToObject.IsGroupProperty
  else
    Result := False;
end;

function tPumlRelationship.GetToObjectPlantUmlIdent: string;
begin
  if Assigned (ToObject) then
    Result := ToObject.PlantUmlIdent
  else
    Result := '';
end;

function tPumlRelationship.GetToObjectIdentifier: string;
begin
  if Assigned (ToObject) then
    Result := ToObject.ObjectIdentifier
  else
    Result := '';
end;

constructor tPumlObject.Create;
begin
  inherited Create;
  FValues := tPumlObjectValueList.Create ();
  FPropertyCharacteristics := tPumlCharacteristicList.Create ();
  FRelations := tPumlObjectRelationshipList.Create ();
  FDetailObjects := tPumlDetailObjectList.Create ();
  FDetailObjects.Sorted := true;
  FDetailObjects.duplicates := dupIgnore;
  FIsObjectDetail := False;
  FIsRelationship := False;
  FIsGroupProperty := False;
  FFiltered := true;
end;

destructor tPumlObject.Destroy;
begin
  FDetailObjects.Free;
  FRelations.Free;
  FPropertyCharacteristics.Free;
  FValues.Free;
  inherited Destroy;
end;

procedure tPumlObject.AddCharacteristic (iParentProperty, iName, iValue, iInfo: string;
  iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
begin
  PropertyCharacteristics.AddCharacteristic (iParentProperty, iName, iValue, iInfo, iCharacteristicDefinition);
end;

function tPumlObject.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
  RelatedObject: tPumlObject; Direction: tUmlRelationDirection; iAllways: boolean = true): boolean;
begin
  Result := Relations.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty, RelatedObject,
    Direction, iAllways);
end;

procedure tPumlObject.AddValue (iName, iValue: string; iReplace: boolean = true);
begin
  Values.AddValue (iName, iValue, iReplace);
end;

function tPumlObject.GeneratePuml (ipuml: TStrings): boolean;
var
  i: Integer;
  idLine, NameLine: Integer;
  AddLine: boolean;
  Color: string;

begin
  Result := ShowObject;
  if not Result then
    Exit;
  AddLine := False;
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
  ipuml.add (Format('%s %s {', [GeneratePumlClassName, Color]));
  if (Values.Count > 0) and FormatDefinition.ShowAttributes then
  begin
    ipuml.add ('|= attribute |= value |');
    idLine := Values.IndexOfName ('id');
    NameLine := Values.IndexOfName ('Ident');
    if idLine >= 0 then
      Values.AddPumlValueLine (ipuml, idLine);
    if NameLine >= 0 then
      Values.AddPumlValueLine (ipuml, NameLine);
    for i := 0 to Values.Count - 1 do
      if (i <> idLine) and (i <> NameLine) then
        Values.AddPumlValueLine (ipuml, i);
    AddLine := true;
  end;
  if FormatDefinition.ShowCharacteristics then
    PropertyCharacteristics.GeneratePuml (ipuml, AddLine);
  if FormatDefinition.ShowFromRelations then
    Relations.GeneratePuml (ipuml, urdFrom, AddLine);
  if FormatDefinition.ShowToRelations then
    Relations.GeneratePuml (ipuml, urdTo, AddLine);
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
    Result := Format ('%s %s', [ObjectType.ToLower, ObjectIdent])
  else
    Result := ObjectIdent;
end;

function tPumlObject.GetObjectTypeIdent: string;
begin
  Result := Format ('%s %s', [ObjectType.ToLower, ObjectIdent]);
end;

function tPumlObject.GetPlantUmlIdent: string;
begin
  Result := ObjectIdentifier.Replace (' ', '_').Replace ('-', '_').Replace (':', '_').Replace ('/', '_')
    .Replace ('\', '_').Replace ('.', '_');
end;

function tPumlObject.GetShowObject: boolean;
var
  r: tPumlObjectRelationship;
begin
  Result := Filtered;
  // If not filtered then the filled status can be ignored
  if Result then
  begin
    Result := Filled or FormatDefinition.ShowIfEmpty;
    if not Result then
      for r in Relations do
      begin
        Result := r.RelatedObjectFilled or FormatDefinition.ShowIfEmpty;
        if Result then
          Exit;
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

  procedure SplitIdent;
  var
    s: string;
    i: Integer;
  begin
    if (ObjectIdent.Length > SplitLength) and (SplitLength > 0) then
    begin
      NewIdent := '';
      s := ObjectIdent;
      i := s.Substring (SplitLength).IndexOf (FormatDefinition.CaptionSplitCharacter);
      while (i >= 0) and (s.Length - i - SplitLength > 5) do
      begin
        if iFormat then
          NewIdent := NewIdent + s.Substring (0, SplitLength + i) + '</i>' + iSeparator + '    <i>'
        else
          NewIdent := NewIdent + s.Substring (0, SplitLength + i) + iSeparator + '    ';
        s := s.Substring (SplitLength + i);
        i := s.Substring (SplitLength).IndexOf (FormatDefinition.CaptionSplitCharacter);
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
  if FormatDefinition.CaptionShowIdent and not IsObjectDetail and not IsGroupProperty then
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

procedure tPumlObjectRelationship.GeneratePuml (ipuml: TStrings);
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
    ipuml.add (Format('| %s | %s | %s |', [CleanCRLF(PropertyName, '\n'), CleanCRLF(rType, '\n'),
      CleanCRLF(RelatedObjectCaption, '\n')]))
  else
    ipuml.add (Format('| %s | %s | %s |', [CleanCRLF(RelatedObjectCaption, '\n'), CleanCRLF(PropertyName, '\n'),
      CleanCRLF(rType, '\n')]));
end;

function tPumlObjectRelationship.GetFilled: boolean;
begin
  Result := Assigned (RelatedObject) and RelatedObject.Filled;
end;

function tPumlObjectRelationship.GetIdent: string;
begin
  Result := string.Join (';', [Direction.ToString, RelatedObjectTypeIdent, PropertyName, RelationshipType]);
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

function tPumlObjectRelationship.GetRelatedObjectTypeIdent: string;
begin
  if Assigned (RelatedObject) then
    Result := RelatedObject.ObjectIdentifier
  else
    Result := '';
end;

constructor tPumlObjectRelationshipList.Create;
begin
  inherited;
  Sorted := true;
  duplicates := dupAccept;
  OwnsObjects := true;
end;

function tPumlObjectRelationshipList.addRelationship (PropertyName, RelationshipType, RelationshipTypeProperty: string;
  RelatedObject: tPumlObject; Direction: tUmlRelationDirection; iAllways: boolean = true): boolean;
var
  pumlObjectRelationship: tPumlObjectRelationship;
begin
  pumlObjectRelationship := tPumlObjectRelationship.Create;
  pumlObjectRelationship.PropertyName := PropertyName;
  pumlObjectRelationship.RelatedObject := RelatedObject;
  pumlObjectRelationship.RelationshipType := RelationshipType;
  pumlObjectRelationship.RelationshipTypeProperty := RelationshipTypeProperty;
  pumlObjectRelationship.Direction := Direction;
  Result := iAllways or (IndexOf(pumlObjectRelationship.Ident) < 0);
  if Result then
    AddObject (pumlObjectRelationship.Ident, pumlObjectRelationship)
  else
    pumlObjectRelationship.Free;
end;

procedure tPumlObjectRelationshipList.GeneratePuml (ipuml: TStrings; iDirection: tUmlRelationDirection;
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
      ipuml.add ('|= Relations To\n property |=\n type |=\n object |')
    else
      ipuml.add ('|= Relations From\n object |=\n property |=\n type |');
    TempList := TStringList.Create;
    try
      for r in Self do
        if (r.Direction = iDirection) then
          r.GeneratePuml (TempList);
      iAddLine := true;
      TempList.Sort;
      ipuml.AddStrings (TempList);
    finally
      TempList.Free;
    end;
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

constructor tPumlCharacteristicList.Create;
begin
  inherited;
  OwnsObjects := true;
end;

procedure tPumlCharacteristicList.AddCharacteristic (iParentProperty, iName, iValue, iInfo: string;
  iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
var
  Characteristic: tPumlCharacteristic;
begin
  Characteristic := AddPropertyCharacteristic (iParentProperty);
  Characteristic.IncludeIndex := iCharacteristicDefinition.IncludeIndex;
  Characteristic.NameProperty := iCharacteristicDefinition.NameProperties.Text;
  Characteristic.ValueProperty := iCharacteristicDefinition.ValueProperties.Text;
  Characteristic.InfoProperty := iCharacteristicDefinition.InfoProperties.Text;
  Characteristic.CharacteristicType := iCharacteristicDefinition.CharacteristicType;
  Characteristic.AddRecord (iName, iValue, iInfo);
end;

function tPumlCharacteristicList.AddPropertyCharacteristic (iParentProperty: string): tPumlCharacteristic;
var
  i: Integer;
begin
  i := IndexOf (iParentProperty);
  if i < 0 then
  begin
    Result := tPumlCharacteristic.Create;
    Result.ParentProperty := iParentProperty;
    AddObject (iParentProperty, Result);
  end
  else
    Result := PropertyCharacteristic[i];
end;

procedure tPumlCharacteristicList.GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
var
  PropertyCharacteristic: tPumlCharacteristic;
begin
  for PropertyCharacteristic in Self do
    PropertyCharacteristic.GeneratePuml (ipuml, iAddLine);
end;

function tPumlCharacteristicList.GetEnumerator: tPumlCharacteristicEnumerator;
begin
  Result := tPumlCharacteristicEnumerator.Create (Self);
end;

function tPumlCharacteristicList.GetPropertyCharacteristic (Index: Integer): tPumlCharacteristic;
begin
  Result := tPumlCharacteristic (Objects[index]);
end;

function tBasePumlObject.CleanCRLF (iValue: string; iReplace: string = ';'): string;
begin
  Result := iValue.TrimRight ([' ', #10, #13, #9]).Replace (#13#10, #10).Replace (#13, #10).Replace (#10, iReplace);
end;

function tBasePumlObject.GetFilled: boolean;
begin
  Result := true;
end;

function tBasePumlObject.GetIdent: string;
begin
  Result := '';
end;

function tBasePumlObject.TableLine (iColumns: TStringList; iHeader: boolean = False): string;
var
  s: string;
begin
  Result := '';
  if iColumns.Count <= 0 then
    Exit;
  Result := '|';
  for s in iColumns do
    if iHeader then
      Result := Format (' =%s |', [s])
    else
      Result := Format (' %s |', [s]);
  iColumns.Clear;
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
    Inc (FIndex);
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

constructor tPumlCharacteristicEnumerator.Create (ACharacteristicList: tPumlCharacteristicList);
begin
  inherited Create;
  FIndex := - 1;
  fCharacteristicList := ACharacteristicList;
end;

function tPumlCharacteristicEnumerator.GetCurrent: tPumlCharacteristic;
begin
  Result := fCharacteristicList[FIndex];
end;

function tPumlCharacteristicEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fCharacteristicList.Count - 1;
  if Result then
    Inc (FIndex);
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
    Inc (FIndex);
end;

constructor tPumlRelationshipEnumerator.Create (ARelationshipList: tPumlRelationshipList);
begin
  inherited Create;
  FIndex := - 1;
  fObjectList := ARelationshipList;
end;

function tPumlRelationshipEnumerator.GetCurrent: tPumlRelationship;
begin
  Result := fObjectList[FIndex];
end;

function tPumlRelationshipEnumerator.MoveNext: boolean;
begin
  Result := FIndex < fObjectList.Count - 1;
  if Result then
    Inc (FIndex);
end;

function tBasePumlStringList.CleanCRLF (iValue: string; iReplace: string = ';'): string;
begin
  Result := iValue.TrimRight ([' ', #10, #13, #9]).Replace (#13#10, #10).Replace (#13, #10).Replace (#10, iReplace);
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
          Inc (Result)
        else
      else if (Objects[i] is tBasePumlStringList) then
        if tBasePumlStringList (Objects[i]).Filled then
          Inc (Result)
        else
      else
        Inc (Result);
end;

function tBasePumlStringList.GetIdent: string;
begin
  Result := '';
end;

function tBasePumlStringList.TableLine (iColumns: TStringList; iHeader: boolean = False): string;
var
  s: string;
begin
  Result := '';
  if iColumns.Count <= 0 then
    Exit;
  Result := '|';
  for s in iColumns do
    if iHeader then
      Result := Format ('%s= %s |', [Result, s])
    else
      Result := Format ('%s %s |', [Result, s]);
  iColumns.Clear;
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

procedure tPumlDetailObjectList.GeneratePuml (ipuml: TStrings; iParentObjectName, iParentObjectTitle: string);
begin
  if (Count <= 0) then
    Exit;
  ipuml.add ('together {');
  if iParentObjectTitle.IsEmpty then
    ipuml.add (Format('  class %s ', [iParentObjectName]))
  else
    ipuml.add (Format('  class "%s" as %s ', [iParentObjectTitle, iParentObjectName]));
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

function tPumlCharacteristicRecord.GetIdent: string;
begin
  Result := Format ('%s-%s-%s-%d', [name, Value, Info, index]);
end;

constructor tPumlCharacteristicRecordEnumerator.Create (ACharacteristic: tPumlCharacteristic);
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
    Inc (FIndex);
end;

procedure tPumlCharacteristic.AddRecord (iName, iValue, iInfo: string);
var
  CharRec: tPumlCharacteristicRecord;
begin
  CharRec := tPumlCharacteristicRecord.Create;
  CharRec.Name := iName;
  CharRec.Value := iValue;
  CharRec.Info := iInfo;
  if IncludeIndex then
    CharRec.Index := Count
  else
    CharRec.Index := - 1;
  if IndexOf (CharRec.Ident) < 0 then
    AddObject (CharRec.Ident, CharRec)
  else
    CharRec.Free;
end;

procedure tPumlCharacteristic.GeneratePuml (ipuml: TStrings; var iAddLine: boolean);
var
  CharRec: tPumlCharacteristicRecord;
  Columns: TStringList;
  i: Integer;
begin
  if Count > 0 then
  begin
    Columns := TStringList.Create;
    try
      if iAddLine then
        ipuml.add ('---');
      if CharacteristicType = jctRecord then
      begin
        if IncludeIndex then
          Columns.add ('\n idx');
        Columns.add (Format('%s\n attribute', [ParentProperty]));
        Columns.add ('value');
        ipuml.add (TableLine(Columns, true));
      end
      else
      begin
        if IncludeIndex then
          Columns.add ('\n idx');
        Columns.add (Format('%s\n %s', [ParentProperty, CleanCRLF(NameProperty)]));
        if not ValueProperty.IsEmpty then
          Columns.add (CleanCRLF(ValueProperty));
        if not InfoProperty.IsEmpty then
          Columns.add (CleanCRLF(InfoProperty));
        ipuml.add (TableLine(Columns, true));
      end;
      i := 0;
      for CharRec in Self do
      begin
        if (CharacteristicType = jctRecord) or InfoProperty.IsEmpty then
        begin
          if IncludeIndex then
            Columns.add (i.ToString);
          Columns.add (CleanCRLF(CharRec.Name, '\n'));
          Columns.add (CleanCRLF(CharRec.Value, '\n'));
        end
        else
        begin
          if IncludeIndex then
            Columns.add (i.ToString);
          Columns.add (CleanCRLF(CharRec.Name, '\n'));
          if not ValueProperty.IsEmpty then
            Columns.add (CleanCRLF(CharRec.Value, '\n'));
          if not InfoProperty.IsEmpty then
            Columns.add (CleanCRLF(CharRec.Info, '\n'));
        end;
        ipuml.add (TableLine(Columns));
        Inc (i);
      end;
      iAddLine := true;
    finally
      Columns.Free
    end;
  end;
end;

function tPumlCharacteristic.GetCharRecord (Index: Integer): tPumlCharacteristicRecord;
begin
  Result := tPumlCharacteristicRecord (Objects[index]);
end;

function tPumlCharacteristic.GetEnumerator: tPumlCharacteristicRecordEnumerator;
begin
  Result := tPumlCharacteristicRecordEnumerator.Create (Self);
end;

function tPumlCharacteristic.GetIdent: string;
begin
  Result := ParentProperty;
end;

procedure tPumlObjectValueList.AddPumlValueLine(ipuml: TStrings; iIndex: Integer);
begin
  ipuml.add (Format('| %s | %s |', [Names[iIndex], CleanCRLF(ValueFromIndex[iIndex], '\n')]));
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
    If not ValueFromIndex[i].IsEmpty then
      Inc (Result);
end;

end.
