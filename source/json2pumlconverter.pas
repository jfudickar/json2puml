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

unit json2pumlconverter;

interface

uses
  System.JSON, System.Classes, json2pumldefinition, json2pumlpuml, json2pumlinputhandler, json2pumlloghandler,
  json2pumlconverterdefinition, json2pumlconst;

type

  tJson2PumlRecursionParent = (trpStart, trpObject, trpArray, trpValue);

  tJson2PumlRecursionParentHelper = record helper for tJson2PumlRecursionParent
    function OperationName: string;
  end;

  tJson2PumlRecursionRecord = record
    ParentObject: tPumlObject;
    HierarchieParentObject: tPumlObject;
    ParentPropertyName: string;
    PropertyName: string;
    OriginalPropertyName: string;
    ParentRelationshipProperty: string;
    ParentRelationshipType: string;
    ParentRelationShipTypeProperty: string;
    ParentIsRelationship: boolean;
    StopRecursion: boolean;
    Level: integer;
    ArrayIndex: integer;
    ObjectLevel: integer;
    CharacteristicParentPropertyName: string;
    CharacteristicObject: tPumlCharacteristicObject;
    CharacteristicValue: tPumlCharacteristicValue;
    CharacteristicRecord: tPumlCharacteristicRecord;
    procedure Init (iLeadingObject: string);
    function GetParentObjectType: string;
    function GetInCharacteristicMode: boolean;
    function GetCurrentCharacteristicDefinition: tJson2PumlCharacteristicDefinition;
    function GetCurrentCharacteristicType: tJson2PumlCharacteristicType;
    property InCharacteristicMode: boolean read GetInCharacteristicMode;
    property ParentObjectType: string read GetParentObjectType;
    property CurrentCharacteristicDefinition: tJson2PumlCharacteristicDefinition
      read GetCurrentCharacteristicDefinition;
    property CurrentCharacteristicType: tJson2PumlCharacteristicType read GetCurrentCharacteristicType;
  end;

  TJson2PumlConverter = class(tPersistent)
  private
    FCurrentRecursionRecord: tJson2PumlRecursionRecord;
    FDefinition: tJson2PumlConverterDefinition;
    FInputHandler: tJson2PumlInputHandler;
    FInputHandlerRecord: tJson2PumlInputHandlerRecord;
    FLeadingObject: string;
    FPumlFile: string;
    FPumlObjects: tPumlObjectList;
    FTitle: string;
    procedure BuildObjectRelationships (iHierarchieParentObject, iPumlObject: tPumlObject;
      iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty: string; iAllways: boolean);
    procedure GeneratePumlLegendFileInfo (vAdd: boolean);
    procedure GeneratePumlLegendObjectCount (var vAdd: boolean);
    procedure GeneratePumlLegendObjectFormats (var vAdd: boolean; iUsedFormats: tStrings);
    function GetFileLog: tStrings;
    function GetInputFilter: tJson2PumlFilterList;
    function GetJsonInput: tStrings;
    function GetPuml: tStrings;
    property CurrentRecursionRecord: tJson2PumlRecursionRecord read FCurrentRecursionRecord
      write FCurrentRecursionRecord;
  protected
    procedure AddFileLog (iLog: string = ''); overload;
    procedure AddFileLog (iLog: string; const iArgs: array of const); overload;
    procedure ConvertArray (iJsonArray: tJSONArray; iInfo: tJson2PumlRecursionRecord);
    procedure ConvertObject (iJsonObject: tJSONObject; iInfo: tJson2PumlRecursionRecord);
    procedure ConvertValue (iJsonValue: tJSONValue; iInfo: tJson2PumlRecursionRecord;
      iRecursionParent: tJson2PumlRecursionParent);
    procedure DecRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
      iSafeCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent);
    procedure GeneratePuml;
    function GetObjectIdent (iJsonObject: tJSONObject; iParentProperty: string;
      var oPropertyName, oFoundCondition: string): string;
    function GetObjectTitleProperties (iJsonObject: tJSONObject; iParentProperty: string;
      var oPropertyName, oFoundCondition: string): string;
    function GetObjectTypeProperties (iJsonObject: tJSONObject; iParentProperty: string;
      var oFoundCondition: string): string;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: tJSONObject; iParentProperty, iConfigurationPropertyName: string; var oFoundCondition: string)
      : string; overload;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: tJSONObject; iParentProperty, iConfigurationPropertyName: string;
      var oPropertyName, oFoundCondition: string): string; overload;
    procedure GetRelationshipType (iJsonObject: tJSONObject; iPropertyName: string;
      var oRelationshipType, oRelationshipTypeProperty: string; var oFoundCondition: string);
    function IncRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent)
      : tJson2PumlRecursionRecord;
    function ParentPropertyName (iParentProperty, iPropertyName: string): string;
    procedure ReplaceObjectType (iPumlObject: tPumlObject; iObjectType: string);
    property PumlObjects: tPumlObjectList read FPumlObjects;
  public
    constructor Create;
    destructor Destroy; override;
    function Convert: boolean;
    procedure GeneratePumlLegend (iUsedFormats: tStrings);
    property LeadingObject: string read FLeadingObject write FLeadingObject;
  published
    property Definition: tJson2PumlConverterDefinition read FDefinition write FDefinition;
    property FileLog: tStrings read GetFileLog;
    property InputFilter: tJson2PumlFilterList read GetInputFilter;
    property InputHandler: tJson2PumlInputHandler read FInputHandler write FInputHandler;
    property InputHandlerRecord: tJson2PumlInputHandlerRecord read FInputHandlerRecord write FInputHandlerRecord;
    property JsonInput: tStrings read GetJsonInput;
    property Puml: tStrings read GetPuml;
    property PumlFile: string read FPumlFile write FPumlFile;
    property Title: string read FTitle write FTitle;
  end;

implementation

uses
  System.SysUtils, System.Generics.Collections, System.Types, System.IOUtils, json2pumltools, Masks, jsontools,
  json2pumlbasedefinition, System.Math;

const
  cUmlRelationDirection: array [tUmlRelationDirection] of string = ('To', 'From');

  cJson2PumlRecursionParentFunction: array [tJson2PumlRecursionParent] of string = ('Start', 'ConvertObject',
    'ConvertArray', 'ConvertValue');

constructor TJson2PumlConverter.Create;
begin
  inherited Create;
  FPumlObjects := tPumlObjectList.Create ();
end;

destructor TJson2PumlConverter.Destroy;
begin
  FPumlObjects.Free;
  inherited Destroy;
end;

procedure TJson2PumlConverter.AddFileLog (iLog: string = '');
var
  p: string;
begin
  p := p.PadRight (CurrentRecursionRecord.Level, #9);
  FileLog.Add (Format('%s%s', [p, iLog]));
end;

procedure TJson2PumlConverter.AddFileLog (iLog: string; const iArgs: array of const);
begin
  AddFileLog (Format(iLog, iArgs));
end;

procedure TJson2PumlConverter.BuildObjectRelationships (iHierarchieParentObject, iPumlObject: tPumlObject;
  iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty: string; iAllways: boolean);
var
  added: boolean;
  GroupObjectFrom, GroupObjectTo: boolean;
  ArrowFormat: string;
  GroupFromCondition, GroupToCondition, ArrowCondition: string;
begin
  GroupObjectTo := Definition.IsGroupProperty (iPumlObject.ObjectType, iHierarchieParentObject.ObjectType, '',
    GroupFromCondition);
  // GroupObjectFrom := Definition.IsGroupProperty (iHierarchieParentObject.ObjectType, iPumlObject.ObjectType, '', GroupToCondition);
  GroupObjectFrom := Definition.IsGroupProperty (iPumlObject.ObjectType, iHierarchieParentObject.ObjectType, '',
    GroupFromCondition);
  ArrowFormat := Definition.RelationshipTypeArrowFormats.GetFormat (iPumlObject.ObjectType, iRelationshipProperty,
    iRelationshipType, ArrowCondition);
  added := iHierarchieParentObject.addRelationship (iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty,
    iPumlObject, urdTo, GroupObjectFrom, GroupObjectTo, ArrowFormat, iAllways);
  if added then
  begin
    iPumlObject.addRelationship (iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty,
      iHierarchieParentObject, urdFrom, GroupObjectTo, GroupObjectFrom, ArrowFormat);
    AddFileLog ('Build Relationship to "%s"', [iHierarchieParentObject.ObjectIdentifier]);
    if GroupObjectFrom then
      AddFileLog ('  Grouping on parent side %s', [GroupFromCondition]);
    if GroupObjectTo then
      AddFileLog ('  Grouping on related side %s', [GroupToCondition]);
    if not ArrowFormat.IsEmpty then
      AddFileLog ('  Arrowformat "%s" found %s', [ArrowFormat, ArrowCondition])
  end
  else
    AddFileLog ('Relationship to "%s" skipped, already existing', [iHierarchieParentObject.ObjectIdentifier]);
end;

function TJson2PumlConverter.Convert: boolean;
var
  JsonValue: tJSONValue;
  InfoRec: tJson2PumlRecursionRecord;
begin
  Result := false;
  Puml.Clear;
  PumlObjects.Clear;
  PumlObjects.ConverterDefinition := Definition;
  PumlObjects.InputFilter := InputFilter;
  if FileExists (PumlFile) then
    tFile.Delete (PumlFile);

  JsonValue := tJSONObject.ParseJSONValue (JsonInput.Text);
  if not Assigned (JsonValue) then
    GlobalLoghandler.Error (jetUnableToParseInputFileStructure, [InputHandlerRecord.InputFile.OutputFileName])
  else
    try
      InfoRec.Init (LeadingObject);
      ConvertValue (JsonValue, InfoRec, trpStart);
      GeneratePuml;
      Result := true;
    finally
      JsonValue.Free;
    end;

end;

procedure TJson2PumlConverter.ConvertArray (iJsonArray: tJSONArray; iInfo: tJson2PumlRecursionRecord);
var
  i: integer;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
begin
  if not Assigned (iJsonArray) then
    Exit;
  SaveRecursionRecord := IncRecursionRecord (iInfo, trpArray);
  try
    for i := 0 to iJsonArray.Count - 1 do
    begin
      iInfo.ArrayIndex := i;
      if iInfo.InCharacteristicMode then
        iInfo.CharacteristicRecord := iInfo.CharacteristicValue.AddDetailRecord (i);
      ConvertValue (iJsonArray.Items[i], iInfo, trpArray);
    end;
  finally
    DecRecursionRecord (iInfo, SaveRecursionRecord, trpArray);
  end;
end;

procedure TJson2PumlConverter.ConvertObject (iJsonObject: tJSONObject; iInfo: tJson2PumlRecursionRecord);
var
  i: integer;
  PumlObject: tPumlObject;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
  IsObjectProperty, IsObjectDetail, IsRelationShip, IsCharacteristic: boolean;

  cName: string;
  RelationshipObject: string;
  RelationshipType: string;
  RelationshipProperty: string;
  ObjectIdent: string;
  ObjectIdentProperty: string;
  ObjectType: string;
  ObjectTitleProperty: string;
  ObjectTypeRenamed: string;
  CharacteristicDefinition: tJson2PumlCharacteristicDefinition;
  ObjectDefinition: tJson2PumlObjectDefinition;
  RelationshipTypeProperty: string;
  ObjectTitle: string;
  LogMessage: string;
  FoundCondition: string;

  function CheckObjectIdent (iObjectType: string): boolean;
  begin
    if ObjectIdent.IsEmpty then
      if Assigned (ObjectDefinition) and not ObjectDefinition.GenerateWithoutIdentifier then
        AddFileLog ('Object "%s" not created, no ident identified', [iObjectType])
      else
      begin
        if Assigned (iInfo.HierarchieParentObject) then
          ObjectIdent := iInfo.HierarchieParentObject.CalculateChildObjectDefaultIdent (ObjectTypeRenamed)
        else
          ObjectIdent := Format ('%s_%s', [ObjectTypeRenamed, 'root']);
        AddFileLog ('Default object ident "%s" generated', [ObjectIdent]);
      end;
    Result := not ObjectIdent.IsEmpty;
  end;

begin
  if not Assigned (iJsonObject) then
    Exit;

  PumlObject := nil;
  CharacteristicDefinition := nil;
  ObjectDefinition := nil;
  IsObjectProperty := false;
  IsObjectDetail := false;
  // IsRelationShip := false;
  IsCharacteristic := false;

  cName := '';
  RelationshipObject := '';
  RelationshipType := '';
  RelationshipProperty := '';
  ObjectIdent := '';
  ObjectIdentProperty := '';
  ObjectType := '';
  ObjectTitleProperty := '';
  ObjectTypeRenamed := '';
  RelationshipTypeProperty := '';
  ObjectTitle := '';

  SaveRecursionRecord := IncRecursionRecord (iInfo, trpObject);
  try
    ObjectType := GetObjectTypeProperties (iJsonObject, iInfo.PropertyName, FoundCondition);
    if not ObjectType.IsEmpty then
      AddFileLog ('Objecttype "%s" identified - "%s" %s', [ObjectType, 'objectTypeProperties', FoundCondition])
    else
    begin
      ObjectType := iInfo.PropertyName;
      if not ObjectType.IsEmpty then
        AddFileLog ('Objecttype "%s" used based on current property name', [ObjectType]);
    end;
    ObjectTypeRenamed := Definition.RenameObjectType (ObjectType, iInfo.ParentPropertyName, iInfo.ParentObjectType,
      FoundCondition);
    if ObjectTypeRenamed <> ObjectType then
      AddFileLog ('Objecttype renamed to "%s" %s', [ObjectTypeRenamed, FoundCondition]);
    ObjectIdent := GetObjectIdent (iJsonObject, iInfo.PropertyName, ObjectIdentProperty, FoundCondition);
    if not ObjectIdent.IsEmpty then
      AddFileLog ('Objectidentifier "%s" identified - "%s" %s', [ObjectIdent, 'objectIdentifierProperties',
        FoundCondition]);
    ObjectTitle := GetObjectTitleProperties (iJsonObject, iInfo.PropertyName, ObjectTitleProperty, FoundCondition);
    if not ObjectTitle.IsEmpty then
      AddFileLog ('Objecttitle "%s" identified - "%s" %s', [ObjectTitle, 'objectTitleProperties', FoundCondition]);

    if not iInfo.InCharacteristicMode then
    begin
      ObjectDefinition := Definition.ObjectProperties.GetDefinitionByName (ObjectTypeRenamed, iInfo.ParentPropertyName,
        iInfo.ParentObjectType, FoundCondition);
      IsObjectProperty := Assigned (ObjectDefinition);
      if IsObjectProperty then
        AddFileLog ('Objecttype "%s" defined as object %s', [ObjectTypeRenamed, FoundCondition]);

      CharacteristicDefinition := Definition.CharacteristicProperties.GetDefinitionByName (iInfo.PropertyName,
        iInfo.ParentPropertyName, iInfo.ParentObjectType, FoundCondition);
      IsCharacteristic := Assigned (CharacteristicDefinition);
      if IsCharacteristic then
        if Assigned (iInfo.ParentObject) then
          AddFileLog ('Object "%s.%s" defined as characteristic %s', [iInfo.ParentPropertyName, iInfo.PropertyName,
            FoundCondition])
        else
        begin
          AddFileLog ('Object "%s.%s" can not be used as characteristic %s, there is no parent object',
            [iInfo.ParentPropertyName, iInfo.PropertyName, FoundCondition]);
          IsCharacteristic := false;
        end;

      IsObjectDetail := Definition.IsObjectDetailProperty (iInfo.PropertyName, iInfo.ParentPropertyName,
        iInfo.ParentObjectType, FoundCondition);
      if IsObjectDetail then
        AddFileLog ('Object "%s.%s" defined as object detail %s', [iInfo.ParentPropertyName, iInfo.PropertyName,
          FoundCondition]);
      if IsObjectDetail and IsCharacteristic then
      begin
        AddFileLog ('Object "%s.%s" will be used as detail object and not as characteristic',
          [iInfo.ParentPropertyName, iInfo.PropertyName]);
        IsCharacteristic := false;
      end;
    end;

    IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentPropertyName,
      iInfo.ParentObjectType, FoundCondition);
    if IsRelationShip then
      AddFileLog ('Object "%s.%s" defined as relationship %s', [iInfo.ParentPropertyName, iInfo.PropertyName,
        FoundCondition]);
    if IsRelationShip then
    begin
      RelationshipObject := ObjectTypeRenamed;
      iInfo.CharacteristicObject := nil;
      GetRelationshipType (iJsonObject, iInfo.PropertyName, RelationshipType, RelationshipTypeProperty, FoundCondition);
      if not RelationshipType.IsEmpty then
        AddFileLog ('Relationshiptype "%s" identified %s', [RelationshipType, FoundCondition]);
      RelationshipProperty := iInfo.OriginalPropertyName;
    end
    else
    begin
      RelationshipObject := '';
      if iInfo.ParentRelationShipTypeProperty.IsEmpty then
      begin
        GetRelationshipType (iJsonObject, iInfo.PropertyName, RelationshipType, RelationshipTypeProperty,
          FoundCondition);
        if not RelationshipType.IsEmpty then
          AddFileLog ('Relationshiptype "%s" identified %s', [RelationshipType, FoundCondition]);
      end
      else
      begin
        RelationshipTypeProperty := iInfo.ParentRelationShipTypeProperty;
        RelationshipType := iInfo.ParentRelationshipType;
      end;
      RelationshipProperty := iInfo.ParentRelationshipProperty;
    end;
    if ObjectIdent.IsEmpty and IsObjectProperty and not IsObjectDetail and not IsCharacteristic then
      CheckObjectIdent (ObjectTypeRenamed);

    if not IsCharacteristic then
      if IsRelationShip and Definition.IsObjectProperty (RelationshipObject, '', '', FoundCondition) then
      begin
        AddFileLog ('Type "%s" identified as relationship object %s', [RelationshipObject, FoundCondition]);
        if CheckObjectIdent (RelationshipObject) then
        begin
          PumlObject := PumlObjects.SearchCreatePumlObject (Definition.RenameObjectType(RelationshipObject, '', '',
            FoundCondition), ObjectIdent, iInfo.ParentPropertyName, LogMessage, 'relationship object',
            Format('- "%s"/"%s"', ['relationshipProperties', 'objectProperties']));
          AddFileLog (LogMessage);
          PumlObject.IsRelationShip := true;
        end;
      end
      else if IsObjectProperty and not (ObjectIdent.IsEmpty) then
      begin
        PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, ObjectIdent, iInfo.ParentPropertyName,
          LogMessage);
        AddFileLog (LogMessage);
      end;

    if not Assigned (PumlObject) and IsObjectDetail and Assigned (iInfo.ParentObject) and not IsCharacteristic then
    begin
      if ObjectIdent.IsEmpty then
      begin
        ObjectIdent := iInfo.HierarchieParentObject.CalculateChildObjectDefaultIdent (ObjectTypeRenamed);
        AddFileLog ('Default object ident "%s" generated', [ObjectIdent]);
      end;

      PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, ObjectIdent, iInfo.ParentObject.ObjectType,
        LogMessage, 'detail object', Format('for %s - "%s"', [iInfo.ParentObject.ObjectTypeIdent,
        'objectDetailProperties']));
      iInfo.ParentObject.DetailObjects.AddObject (PumlObject.ObjectIdentifier, PumlObject);
      AddFileLog (LogMessage);
      PumlObject.IsObjectDetail := true;
    end;

    if not Assigned (PumlObject) and not IsCharacteristic and not iInfo.InCharacteristicMode then
      AddFileLog ('Objecttype "%s" is not defined , object will be ignored - "%s/%s/%s"',
        [ObjectTypeRenamed, 'objectProperties', 'objectDetailProperties', 'relationshipProperties']);

    if Assigned (iInfo.HierarchieParentObject) and Assigned (PumlObject) then
    begin
      if not iInfo.ParentIsRelationship or RelationshipProperty.IsEmpty then
        RelationshipProperty := iInfo.OriginalPropertyName;
      BuildObjectRelationships (iInfo.HierarchieParentObject, PumlObject, RelationshipProperty, RelationshipType,
        RelationshipTypeProperty, not Definition.HideDuplicateRelations);
    end;

    if not IsRelationShip then // to stop the recursive handover.
    begin
      RelationshipType := '';
      RelationshipTypeProperty := '';
    end;
    if not IsObjectDetail then
      if IsCharacteristic then
      begin
        iInfo.CharacteristicParentPropertyName := '';
        iInfo.CharacteristicObject := iInfo.ParentObject.AddCharacteristic (iInfo.PropertyName,
          CharacteristicDefinition);
        iInfo.CharacteristicValue := iInfo.CharacteristicObject;
        iInfo.CharacteristicRecord := iInfo.CharacteristicValue.AddDetailRecord (iInfo.ArrayIndex);
      end
      else if iInfo.InCharacteristicMode then
      begin
        // iInfo.CharacteristicValue := iInfo.CharacteristicRecord.AddValue (iInfo.PropertyName, '');
        // iInfo.CharacteristicRecord := iInfo.CharacteristicValue.AddDetailRecord (iInfo.ArrayIndex);
        iInfo.CharacteristicParentPropertyName :=
          string.join ('.', [iInfo.CharacteristicParentPropertyName, iInfo.PropertyName]).TrimLeft (['.']);
      end;
    if Assigned (PumlObject) then
    begin
      if not ObjectIdent.IsEmpty then
      begin
        iInfo.HierarchieParentObject := PumlObject;
        if PumlObject.ObjectIdentProperty.IsEmpty then
          PumlObject.ObjectIdentProperty := ObjectIdentProperty;
      end;
      if not ObjectTitle.IsEmpty and PumlObject.ObjectTitle.IsEmpty then
      begin
        PumlObject.ObjectTitle := ObjectTitle;
        PumlObject.ObjectTitleProperty := ObjectTitleProperty;
      end;
      ReplaceObjectType (PumlObject, ObjectTypeRenamed);
    end;
    if not IsCharacteristic and not iInfo.InCharacteristicMode then
      iInfo.ParentObject := PumlObject;
    iInfo.ParentRelationshipProperty := RelationshipProperty;
    iInfo.ParentRelationshipType := RelationshipType;
    iInfo.ParentRelationShipTypeProperty := RelationshipTypeProperty;
    iInfo.ParentIsRelationship := IsRelationShip;
    iInfo.ParentPropertyName := iInfo.PropertyName;
    if Definition.ContinueAfterUnhandledObjects or iInfo.InCharacteristicMode then
      iInfo.StopRecursion := false
    else
      iInfo.StopRecursion := (not (Assigned(PumlObject) or IsObjectDetail or IsRelationShip) and
        Assigned(iInfo.HierarchieParentObject));
    iInfo.ArrayIndex := - 1;
    for i := 0 to iJsonObject.Count - 1 do
    begin
      cName := iJsonObject.Pairs[i].JsonString.Value;
      if not Definition.IsPropertyHidden (cName, iInfo.ParentPropertyName, iInfo.ParentObjectType, FoundCondition) then
      begin
        iInfo.PropertyName := cName;
        iInfo.OriginalPropertyName := cName;
        ConvertValue (iJsonObject.Pairs[i].JsonValue, iInfo, trpObject);
      end
      else
        AddFileLog ('Stop property handling, property [%s.%s] is hidden %s',
          [iInfo.ParentPropertyName, cName, FoundCondition]);
    end;
  finally
    DecRecursionRecord (iInfo, SaveRecursionRecord, trpObject);
  end;

end;

procedure TJson2PumlConverter.ConvertValue (iJsonValue: tJSONValue; iInfo: tJson2PumlRecursionRecord;
  iRecursionParent: tJson2PumlRecursionParent);
var
  PumlObject: tPumlObject;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
  ObjectTypeRenamed: string;
  Value: string;
  IsRelationShip: boolean;
  LogMessage: string;
  FoundCondition: string;
  ValuePropertyName: string;

  function IsCharacteristicPropertyAllowed (iPropertyName, iParentPropertyName: string;
    var oFoundCondition: string): boolean;
  begin
    Result := iInfo.CurrentCharacteristicDefinition.IsPropertyAllowed (iPropertyName, iParentPropertyName,
      oFoundCondition);
    if Result then
      AddFileLog ('characteristic property [%s] found %s', [iPropertyName, oFoundCondition])
    else
      AddFileLog ('property [%s] not allowed and skipped %s', [iPropertyName, oFoundCondition]);
  end;

begin
  if not Assigned (iJsonValue) then
    Exit;
  if iInfo.InCharacteristicMode then
    if iRecursionParent = trpArray then
      ValuePropertyName := Format ('[%d]', [iInfo.ArrayIndex])
    else
      ValuePropertyName := iInfo.PropertyName
  else
    ValuePropertyName := '';
  SaveRecursionRecord := IncRecursionRecord (iInfo, trpValue);
  try
    if iJsonValue is tJSONArray then
    begin
      if iInfo.InCharacteristicMode then
      begin
        if IsCharacteristicPropertyAllowed (ValuePropertyName, iInfo.CharacteristicParentPropertyName, FoundCondition)
        then
        begin
          iInfo.CharacteristicValue := iInfo.CharacteristicRecord.AddValue (ValuePropertyName, '');
          ConvertArray (iJsonValue as tJSONArray, iInfo);
        end;
      end
      else
        ConvertArray (iJsonValue as tJSONArray, iInfo);
    end
    else if iJsonValue is tJSONObject then
    begin
      if not iInfo.StopRecursion then
      begin
        if iInfo.InCharacteristicMode then
        begin
          if IsCharacteristicPropertyAllowed (ValuePropertyName, iInfo.CharacteristicParentPropertyName, FoundCondition)
          then
          begin
            iInfo.CharacteristicValue := iInfo.CharacteristicRecord.AddValue (ValuePropertyName, '');
            iInfo.CharacteristicRecord := iInfo.CharacteristicValue.AddDetailRecord ( - 1);
            ConvertObject (iJsonValue as tJSONObject, iInfo)
          end;
        end
        else
          ConvertObject (iJsonValue as tJSONObject, iInfo)
      end;
    end
    else if IsJsonSimple (iJsonValue) then
    begin
      if iJsonValue is TjsonNull then
        if Assigned (iInfo.ParentObject) and not (iInfo.ParentObject.FormatDefinition.ShowNullValues) then
        begin
          AddFileLog ('property [%s] skipped, null values hidden', [iInfo.PropertyName]);
          Exit;
        end
        else
          Value := cNullValue
      else
        Value := iJsonValue.Value;
      IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentPropertyName,
        iInfo.ParentObjectType, FoundCondition) and not (iJsonValue is TjsonNull);

      if Assigned (iInfo.ParentObject) then
        if IsRelationShip then
        begin
          AddFileLog ('Type "%s" identified as relationship object %s', [iInfo.PropertyName, FoundCondition]);
          ObjectTypeRenamed := Definition.RenameObjectType (iInfo.PropertyName, '', '', FoundCondition);
          if ObjectTypeRenamed <> iInfo.PropertyName then
            AddFileLog ('Objecttype renamed to "%s" %s', [ObjectTypeRenamed, FoundCondition]);
          PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, Value, iInfo.ParentObject.ObjectType,
            LogMessage);
          AddFileLog (LogMessage);
          ReplaceObjectType (PumlObject, ObjectTypeRenamed);
          BuildObjectRelationships (iInfo.ParentObject, PumlObject, iInfo.PropertyName, '', '',
            not Definition.HideDuplicateRelations);
        end
        else
        begin
          if iInfo.InCharacteristicMode then
          begin
            if IsCharacteristicPropertyAllowed (ValuePropertyName, iInfo.CharacteristicParentPropertyName,
              FoundCondition) then
            begin
              iInfo.CharacteristicValue := iInfo.CharacteristicRecord.AddValue (ValuePropertyName, Value);
            end
          end
          else
          begin
            if Definition.IsPropertyAllowed (iInfo.PropertyName, iInfo.ParentPropertyName, iInfo.ParentObjectType,
              FoundCondition) then
            begin
              iInfo.ParentObject.AddValue (iInfo.PropertyName, Value, not (iRecursionParent = trpArray));
              AddFileLog ('property [%s] value [%s] found %s', [iInfo.PropertyName, Value, FoundCondition]);
            end
            else
              AddFileLog ('property [%s] not allowed and skipped %s', [iInfo.PropertyName, FoundCondition]);
          end;
        end
      else
        AddFileLog ('property [%s] skipped, no parent object found', [iInfo.PropertyName]);
    end
    else
      AddFileLog ('property [%s] not handled, unknown class type %s', [iInfo.PropertyName, iJsonValue.ClassName]);
  finally
    DecRecursionRecord (iInfo, SaveRecursionRecord, trpValue);
  end;
end;

procedure TJson2PumlConverter.DecRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
  iSafeCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent);
begin
  if iParent = trpObject then
    ioCurrentRecord.ObjectLevel := ioCurrentRecord.ObjectLevel - 1;
  ioCurrentRecord.Level := ioCurrentRecord.Level - 1;
  CurrentRecursionRecord := iSafeCurrentRecord;
  AddFileLog ('%s %s "%s"', [iParent.OperationName, 'Stopped', ioCurrentRecord.PropertyName]);
end;

procedure TJson2PumlConverter.GeneratePuml;
var
  PumlObject: tPumlObject;
  s: string;
  Formats: tStringList;
  GroupList, GroupCountList: tStringList;
begin
  AddFileLog ('Start PUML Generation');
  PumlObjects.UpdateRedundant;
  FCurrentRecursionRecord.Level := FCurrentRecursionRecord.Level + 1;
  Formats := tStringList.Create;
  Formats.Sorted := true;
  Formats.Duplicates := dupIgnore;
  GroupList := tStringList.Create;
  GroupList.Sorted := true;
  GroupList.Duplicates := dupIgnore;
  GroupCountList := tStringList.Create;
  try
    Puml.Add ('@startuml');
    Puml.Add ('');
    // Generating Header
    if Definition.PUMLHeaderLines.Count > 0 then
    begin
      for s in Definition.PUMLHeaderLines.ItemList do
        Puml.Add (s);
      Puml.Add ('');
    end;
    // Generating skinparams
    Definition.ObjectFormats.Formats.GeneratePuml (Puml);
    // Generating Title
    if not Title.IsEmpty then
    begin
      Puml.Add (Format('title "%s"', [Title]));
      Puml.Add ('');
    end;
    // Generating Header
    Puml.Add ('header');
    Puml.Add (Format('<b>%s', [tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(PumlFile))]));
    Puml.Add ('endheader');
    Puml.Add ('');
    // Generating Footer
    Puml.Add ('footer');
    Puml.Add (Format('<b>%s', [tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(PumlFile))]));
    Puml.Add ('endfooter');
    Puml.Add ('');
    // Generating Together
    if Definition.GroupDetailObjectsTogether then
      for PumlObject in PumlObjects do
        if PumlObject.ShowObject and not PumlObject.IsObjectDetail then
          PumlObject.DetailObjects.GeneratePumlTogether (Puml, PumlObject.PlantUmlIdent,
            PumlObject.ObjectCaption('\l', true));
    for PumlObject in PumlObjects do
      PumlObject.Relations.GeneratePumlRelationGroup (Puml, GroupList, GroupCountList);

    // Generating classes
    for PumlObject in PumlObjects do
      if PumlObject.GeneratePuml (Puml) then
      begin
        AddFileLog ('Generated : Object "%s" ', [PumlObject.ObjectTypeIdent]);
        Formats.Add (PumlObject.FormatDefinition.FormatName);
      end
      else
        AddFileLog ('Skipped   : Object "%s" ', [PumlObject.ObjectTypeIdent]);
    // Generating class relations
    for PumlObject in PumlObjects do
      PumlObject.Relations.GeneratePumlRelation (Puml, GroupList);

    // Generating Legend
    GeneratePumlLegend (Formats);
    Puml.Add ('');
    Puml.Add ('@enduml');
  finally
    FCurrentRecursionRecord.Level := FCurrentRecursionRecord.Level - 1;
    Formats.Free;
    GroupCountList.Free;
    GroupList.Free;
  end;
  AddFileLog ('Stop PUML Generation');
end;

procedure TJson2PumlConverter.GeneratePumlLegend (iUsedFormats: tStrings);
var
  i: integer;
  vAdd: boolean;
  FileLength: integer;

  procedure AddFileLine (iFileTitle, iFileName: string);
  begin
    Puml.Add (tPumlHelper.TableLine([iFileTitle,
      tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(iFileName))]));
    FileLength := Max (FileLength, tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(iFileName)).length);
  end;

begin
  if not Definition.ShowLegend then
    Exit;
  vAdd := false;
  Puml.Add ('');
  Puml.Add ('legend');
  FileLength := 0;
  if Definition.LegendShowInfo then
  begin
    vAdd := true;
    Puml.Add (tPumlHelper.TableLine(['<b>json2puml', '<b>' + FileVersion]));
    Puml.Add (tPumlHelper.TableLine(['Generated at', Format('%s %s', [DateTostr(Now), TimetoStr(Now)])]));
    AddFileLine ('Definition File', InputHandler.CurrentDefinitionFileName);
    if not InputHandler.CmdLineParameter.InputFileName.IsEmpty then
    begin
      AddFileLine ('Input File', InputHandlerRecord.InputFile.OutputFileName);
      if not InputHandler.CmdLineParameter.LeadingObject.IsEmpty then
        Puml.Add (tPumlHelper.TableLine(['Leading Object', InputHandler.CmdLineParameter.LeadingObject]));
    end;
    if not InputHandler.CurrentInputListFileName.IsEmpty then
      AddFileLine ('Input List File', InputHandler.CurrentInputListFileName);
    Puml.Add (tPumlHelper.TableLine(['Definition Option', Definition.OptionName]));
    for i := 0 to InputFilter.IdentFilter.Count - 1 do
      if i = 0 then
        Puml.Add (tPumlHelper.TableLine(['Ident Filter', InputFilter.IdentFilter[i]]))
      else
        Puml.Add (tPumlHelper.TableLine(['', InputFilter.IdentFilter[i]]));
    for i := 0 to InputFilter.TitleFilter.Count - 1 do
      if i = 0 then
        Puml.Add (tPumlHelper.TableLine(['Title Filter', InputFilter.TitleFilter[i]]))
      else
        Puml.Add (tPumlHelper.TableLine(['', InputFilter.TitleFilter[i]]));
  end;
  if not InputHandler.CurrentJobDescription.IsEmpty then
  begin
    if vAdd then
      Puml.Add ('')
    else
      vAdd := true;
    Puml.Add (tPumlHelper.TableLine(['<b>Job description'.PadRight(FileLength + 50)]));
    Puml.Add (tPumlHelper.TableLine([InputHandler.ReplaceCurlParameterValues
      (InputHandler.CurrentJobDescription, true)]));
  end;
  GeneratePumlLegendObjectFormats (vAdd, iUsedFormats);
  GeneratePumlLegendObjectCount (vAdd);
  GeneratePumlLegendFileInfo (vAdd);
  Puml.Add ('end legend');
  Puml.Add ('');
end;

procedure TJson2PumlConverter.GeneratePumlLegendFileInfo (vAdd: boolean);
var
  FileDetailRecord: tJson2PumlFileDetailRecord;
  i: integer;
begin
  if (InputHandlerRecord.InputFile.Output.SourceFiles.Count > 0) and Definition.LegendShowFileInfos then
  begin
    if vAdd then
      Puml.Add ('');
    Puml.Add (tPumlHelper.TableLine(['File', 'Date', 'Size (kb)', 'Lines', 'Records'], true));
    for i := 0 to InputHandlerRecord.InputFile.Output.SourceFiles.Count - 1 do
    begin
      FileDetailRecord := tJson2PumlFileDetailRecord (InputHandlerRecord.InputFile.Output.SourceFiles.Objects[i]);
      Puml.Add (tPumlHelper.TableLine([tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath
        (FileDetailRecord.Filename)), DateTimeToStr(FileDetailRecord.FileDate),
        Format('%4.3f', [FileDetailRecord.FileSize / 1024]).PadLeft(12), FileDetailRecord.NoOfLines.ToString.PadLeft(8),
        FileDetailRecord.NoOfRecords.ToString.PadLeft(12)]));
    end;
  end;
end;

procedure TJson2PumlConverter.GeneratePumlLegendObjectCount (var vAdd: boolean);
var
  ObjectCount: tStringList;
  PumlObject: tPumlObject;
  i: integer;
begin
  if Definition.LegendShowObjectCount then
  begin
    ObjectCount := tStringList.Create;
    try
      for PumlObject in PumlObjects do
        if PumlObject.ShowObject and not PumlObject.IsObjectDetail then
        begin
          i := ObjectCount.IndexOfName (PumlObject.ObjectType);
          if i < 0 then
            ObjectCount.AddPair (PumlObject.ObjectType, '1')
          else
            ObjectCount.Values[PumlObject.ObjectType] := (ObjectCount.ValueFromIndex[i].ToInteger + 1).ToString;
        end;
      if ObjectCount.Count > 0 then
      begin
        ObjectCount.Sort;
        if vAdd then
          Puml.Add ('')
        else
          vAdd := true;;
        Puml.Add (tPumlHelper.TableLine(['Objecttype', 'Count'], true));
        for i := 0 to ObjectCount.Count - 1 do
          Puml.Add (tPumlHelper.TableLine([ObjectCount.Names[i], ObjectCount.ValueFromIndex[i].PadLeft(8)], false));
      end;
    finally
      ObjectCount.Free;
    end;
    vAdd := true;
  end;
end;

procedure TJson2PumlConverter.GeneratePumlLegendObjectFormats (var vAdd: boolean; iUsedFormats: tStrings);
var
  Colors: tStringList;
  f: string;
  ObjectFormat: tJson2PumlSingleFormatDefinition;
  s: string;
  Param: string;
  Value: string;
  Line: string;
  i: integer;
  i1: integer;
begin
  if Definition.LegendShowObjectFormats then
  begin
    Colors := tStringList.Create;
    try
      for f in iUsedFormats do
      begin
        if Definition.ObjectFormats.Formats.IndexOf (f) < 0 then
          Continue;
        ObjectFormat := Definition.ObjectFormats.Formats[Definition.ObjectFormats.Formats.IndexOf(f)];
        for s in ObjectFormat.SkinParams do
        begin
          i := s.IndexOf ('=');
          if i < 0 then
            Continue
          else
          begin
            Param := s.Substring (0, i);
            Value := s.Substring (i + 1);
            if Param.Trim.ToLower.Equals ('backgroundcolor') then
              Colors.AddPair (ObjectFormat.FormatName, Value);
          end;
        end;
      end;
      if Colors.Count > 0 then
      begin
        if vAdd then
          Puml.Add ('');
        Line := '|';
        for i := 1 to min(5, Colors.Count) do
          if i = 1 then
            Line := Line + tPumlHelper.TableColumn ('  ', true) + tPumlHelper.TableColumn ('Objectformat', true)
          else
            Line := Line + tPumlHelper.TableColumn ('  ', true) + tPumlHelper.TableColumn ('', true);
        Puml.Add (Line);
        Line := '|';
        i := 0;
        while Colors.Count > 0 do
        begin
          inc (i);
          if i > 5 then
          begin
            Puml.Add (Line);
            Line := '|';
            i := 0;
          end;
          Line := Line + tPumlHelper.TableColumn (Format('<back:%s>   </back>', [Colors.ValueFromIndex[0]]));
          Line := Line + tPumlHelper.TableColumn (Colors.Names[0]);
          Colors.Delete (0);
        end;
        if i > 0 then
        begin
          for i1 := 1 to 5 - Colors.Count do
            Line := Line + tPumlHelper.TableColumn ('  ', true) + tPumlHelper.TableColumn ('  ', true);
          Puml.Add (Line);
        end;
      end;
    finally
      Colors.Free;
    end;
    vAdd := true;
  end;
end;

function TJson2PumlConverter.GetFileLog: tStrings;
begin
  Result := InputHandlerRecord.ConverterLog;
end;

function TJson2PumlConverter.GetInputFilter: tJson2PumlFilterList;
begin
  Result := InputHandler.CmdLineParameter.InputFilterList;
end;

function TJson2PumlConverter.GetJsonInput: tStrings;
begin
  Result := InputHandlerRecord.JsonInput;
end;

function TJson2PumlConverter.GetObjectIdent (iJsonObject: tJSONObject; iParentProperty: string;
  var oPropertyName, oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectIdentifierProperties, iJsonObject, iParentProperty,
    'objectIdentifierProperties', oPropertyName, oFoundCondition);
end;

function TJson2PumlConverter.GetObjectTitleProperties (iJsonObject: tJSONObject; iParentProperty: string;
  var oPropertyName, oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTitleProperties, iJsonObject, iParentProperty,
    'objectTitleProperties', oPropertyName, oFoundCondition);
end;

function TJson2PumlConverter.GetObjectTypeProperties (iJsonObject: tJSONObject; iParentProperty: string;
  var oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTypeProperties, iJsonObject, iParentProperty,
    'objectTypeProperties', oFoundCondition);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: tJSONObject; iParentProperty, iConfigurationPropertyName: string; var oFoundCondition: string): string;
var
  PropertyName: string;
begin
  Result := GetPropertyValueListProperties (iDefinitionList, iJsonObject, iParentProperty, iConfigurationPropertyName,
    PropertyName, oFoundCondition);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: tJSONObject; iParentProperty, iConfigurationPropertyName: string;
  var oPropertyName, oFoundCondition: string): string;
var
  Search: string;
  Value: string;
  LastSep, Sep: string;
  Definition: tJson2PumlPropertyValueDefinition;
  PropertyName: string;
begin
  Result := '';
  LastSep := '';
  PropertyName := '';
  try
    for Definition in iDefinitionList do
    begin
      Search := Definition.PropertyName;
      if Search.IndexOf ('.') >= 0 then
        if MatchesMask (Search, iParentProperty + '.*') then
          Search := Search.Substring (Search.IndexOf('.') + 1)
        else
          Continue;

      Sep := Definition.NextValueSeparator;
      Search := string.join ('.', [Search, Definition.ChildPropertyName]);

      Value := GetJsonStringValue (iJsonObject, Search, '', Sep);

      if not Value.IsEmpty then
      begin
        if PropertyName.IsEmpty then
          PropertyName := Search
        else
          PropertyName := string.join (';', [PropertyName, Search]);
        if Result.IsEmpty then
          Result := Value
        else
          Result := string.join (LastSep, [Result, Value]);
        if Sep.IsEmpty then
          Exit;
        LastSep := Sep;
      end;
    end;
  finally
    oFoundCondition := iDefinitionList.BuildFoundCondition (psmExact, iConfigurationPropertyName,
      PropertyName.TrimRight(['.']), Result);
    oPropertyName := PropertyName.TrimRight (['.']);
  end;
end;

function TJson2PumlConverter.GetPuml: tStrings;
begin
  Result := InputHandlerRecord.PUmlOutput;
end;

procedure TJson2PumlConverter.GetRelationshipType (iJsonObject: tJSONObject; iPropertyName: string;
  var oRelationshipType, oRelationshipTypeProperty: string; var oFoundCondition: string);
begin
  oRelationshipType := GetPropertyValueListProperties (Definition.RelationshipTypeProperties, iJsonObject,
    iPropertyName, 'relationshipTypeProperties', oRelationshipTypeProperty, oFoundCondition);
end;

function TJson2PumlConverter.IncRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
  iParent: tJson2PumlRecursionParent): tJson2PumlRecursionRecord;
begin
  Result := CurrentRecursionRecord;
  AddFileLog ('%s %s "%s"', [iParent.OperationName, 'Started', ioCurrentRecord.PropertyName]);
  if iParent = trpObject then
    ioCurrentRecord.ObjectLevel := ioCurrentRecord.ObjectLevel + 1;
  ioCurrentRecord.Level := ioCurrentRecord.Level + 1;
  CurrentRecursionRecord := ioCurrentRecord;
end;

function TJson2PumlConverter.ParentPropertyName (iParentProperty, iPropertyName: string): string;
begin
  if iParentProperty.IsEmpty then
    Result := iPropertyName
  else
    Result := Format ('%s.%s', [iParentProperty, iPropertyName]);
end;

procedure TJson2PumlConverter.ReplaceObjectType (iPumlObject: tPumlObject; iObjectType: string);
var
  oldIdx, newIdx: integer;
begin
  if not Assigned (iPumlObject) or iObjectType.IsEmpty or (iPumlObject.ObjectType = iObjectType) then
    Exit;
  if Definition.IdentifyObjectsByTypeAndIdent then
    Exit;
  if iPumlObject.ObjectType.IsEmpty then
  begin
    AddFileLog ('Objecttype changed to %s', [iObjectType]);
    iPumlObject.ObjectType := iObjectType
  end
  else
  begin
    oldIdx := Definition.ObjectProperties.IndexOf (iPumlObject.ObjectType);
    newIdx := Definition.ObjectProperties.IndexOf (iObjectType);
    if (newIdx < oldIdx) and (newIdx > 0) then
    begin
      AddFileLog ('Objecttype changed to %s', [iObjectType]);
      iPumlObject.ObjectType := iObjectType;
    end;
  end;
end;

function tJson2PumlRecursionParentHelper.OperationName: string;
begin
  Result := cJson2PumlRecursionParentFunction[self];
end;

procedure tJson2PumlRecursionRecord.Init (iLeadingObject: string);
begin
  ParentObject := nil;
  HierarchieParentObject := nil;
  PropertyName := iLeadingObject;
  OriginalPropertyName := iLeadingObject;
  ParentPropertyName := '';
  ParentRelationshipProperty := '';
  ParentRelationshipType := '';
  ParentRelationShipTypeProperty := '';
  ParentIsRelationship := false;
  StopRecursion := false;
  Level := 0;
  ObjectLevel := 0;
  ArrayIndex := - 1;
  CharacteristicParentPropertyName := '';
  CharacteristicObject := nil;
end;

function tJson2PumlRecursionRecord.GetCurrentCharacteristicDefinition: tJson2PumlCharacteristicDefinition;
begin
  if Assigned (CharacteristicObject) then
    Result := CharacteristicObject.Definition
  else
    Result := nil;
end;

function tJson2PumlRecursionRecord.GetCurrentCharacteristicType: tJson2PumlCharacteristicType;
begin
  if Assigned (CurrentCharacteristicDefinition) then
    Result := CurrentCharacteristicDefinition.CharacteristicType
  else
    Result := jctUndefined;
end;

function tJson2PumlRecursionRecord.GetInCharacteristicMode: boolean;
begin
  Result := Assigned (CharacteristicObject);
end;

function tJson2PumlRecursionRecord.GetParentObjectType: string;
begin
  if Assigned (ParentObject) then
    Result := ParentObject.ObjectType
  else
    Result := '';
end;

end.
