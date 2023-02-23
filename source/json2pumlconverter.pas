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

uses System.JSON, System.Classes, json2pumldefinition, json2pumlpuml,
  json2pumlinputhandler, json2pumlloghandler, json2pumlconverterdefinition;

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
    ParentIsRelationship: Boolean;
    StopRecursion: Boolean;
    Level: Integer;
    ObjectLevel: Integer;
    function GetParentObjectType: string;
    property ParentObjectType: string read GetParentObjectType;
  end;

  TJson2PumlConverter = class(tPersistent)
  private
    FCurrentRecursionRecord: tJson2PumlRecursionRecord;
    FDefinition: tJson2PumlConverterDefinition;
    FInputHandler: TJson2PumlInputHandler;
    FInputHandlerRecord: TJson2PumlInputHandlerRecord;
    FLeadingObject: string;
    FPumlFile: string;
    FPumlObjects: tPumlObjectList;
    FTitle: string;
    procedure BuildObjectRelationships (iHierarchieParentObject, iPumlObject: tPumlObject;
      iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty: string; iAllways: Boolean);
    function GetFileLog: TStrings;
    function GetInputFilter: tJson2PumlFilterList;
    function GetJsonInput: TStrings;
    function GetPuml: TStrings;
    property CurrentRecursionRecord: tJson2PumlRecursionRecord read FCurrentRecursionRecord
      write FCurrentRecursionRecord;
  protected
    procedure AddFileLog (iLog: string = ''); overload;
    procedure AddFileLog (iLog: string; const iArgs: array of const); overload;
    procedure ConvertArray (iJsonArray: TJSONArray; iInfo: tJson2PumlRecursionRecord);
    procedure ConvertCharacteristic (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord;
      iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
    procedure ConvertObject (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord);
    procedure ConvertValue (iJsonValue: TJSONValue; iInfo: tJson2PumlRecursionRecord;
      iRecursionParent: tJson2PumlRecursionParent);
    procedure DecRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
      iSafeCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent);
    procedure GeneratePuml;
    function GetObjectIdent (iJsonObject: TJsonObject; iParentProperty: string; var oFoundCondition: string): string;
    function GetObjectTitleProperties (iJsonObject: TJsonObject; iParentProperty: string;
      var oFoundCondition: string): string;
    function GetObjectTypeProperties (iJsonObject: TJsonObject; iParentProperty: string;
      var oFoundCondition: string): string;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: TJsonObject; iParentProperty, iConfigurationPropertyName: string; var oFoundCondition: string)
      : string; overload;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: TJsonObject; iParentProperty: string; var oPropertyName: string; iConfigurationPropertyName: string;
      var oFoundCondition: string): string; overload;
    procedure GetRelationshipType (iJsonObject: TJsonObject; iPropertyName: string;
      var oRelationshipType, oRelationshipTypeProperty: string; var oFoundCondition: string);
    function IncRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent)
      : tJson2PumlRecursionRecord;
    function ParentPropertyName (iParentProperty, iPropertyName: string): string;
    procedure ReplaceObjectType (iPumlObject: tPumlObject; iObjectType: string);
    property PumlObjects: tPumlObjectList read FPumlObjects;
  public
    constructor Create;
    destructor Destroy; override;
    function Convert: Boolean;
    procedure GeneratePumlLegend (iUsedFormats: TStrings);
    property LeadingObject: string read FLeadingObject write FLeadingObject;
  published
    property Definition: tJson2PumlConverterDefinition read FDefinition write FDefinition;
    property FileLog: TStrings read GetFileLog;
    property InputFilter: tJson2PumlFilterList read GetInputFilter;
    property InputHandler: TJson2PumlInputHandler read FInputHandler write FInputHandler;
    property InputHandlerRecord: TJson2PumlInputHandlerRecord read FInputHandlerRecord write FInputHandlerRecord;
    property JsonInput: TStrings read GetJsonInput;
    property Puml: TStrings read GetPuml;
    property PumlFile: string read FPumlFile write FPumlFile;
    property Title: string read FTitle write FTitle;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections, System.Types, System.IOUtils, json2pumltools, Masks, jsontools, json2pumlconst,
  json2pumlbasedefinition, System.Math;

const
  cUmlRelationDirection: array [tUmlRelationDirection] of string = ('To', 'From');

  cJson2PumlRecursionParentFunction: array [tJson2PumlRecursionParent] of string = ('Start', 'ConvertObject',
    'ConvertArray', 'ConvertValue');

procedure TJson2PumlConverter.BuildObjectRelationships (iHierarchieParentObject, iPumlObject: tPumlObject;
  iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty: string; iAllways: Boolean);
var
  added: Boolean;
  GroupObjectFrom, GroupObjectTo: Boolean;
  ArrowFormat: string;
  GroupFromCondition, GroupToCondition, ArrowCondition: string;
begin
  GroupObjectFrom := Definition.IsGroupProperty (iPumlObject.ObjectType, iHierarchieParentObject.ObjectType, '',
    GroupFromCondition);
  GroupObjectTo := Definition.IsGroupProperty (iHierarchieParentObject.ObjectType, iPumlObject.ObjectType, '',
    GroupToCondition);
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

function TJson2PumlConverter.GetFileLog: TStrings;
begin
  Result := InputHandlerRecord.ConverterLog;
end;

function TJson2PumlConverter.GetInputFilter: tJson2PumlFilterList;
begin
  Result := InputHandler.CmdLineParameter.InputFilterList;
end;

function TJson2PumlConverter.GetJsonInput: TStrings;
begin
  Result := InputHandlerRecord.JsonInput;
end;

function TJson2PumlConverter.GetPuml: TStrings;
begin
  Result := InputHandlerRecord.PUmlOutput;
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

procedure TJson2PumlConverter.ConvertArray (iJsonArray: TJSONArray; iInfo: tJson2PumlRecursionRecord);
var
  i: Integer;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
begin
  if not Assigned (iJsonArray) then
    Exit;
  SaveRecursionRecord := IncRecursionRecord (iInfo, trpArray);
  try
    for i := 0 to iJsonArray.Count - 1 do
    begin
      ConvertValue (iJsonArray.Items[i], iInfo, trpArray);
    end;
  finally
    DecRecursionRecord (iInfo, SaveRecursionRecord, trpArray);
  end;
end;

procedure TJson2PumlConverter.ConvertCharacteristic (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord;
  iCharacteristicDefinition: tJson2PumlCharacteristicDefinition);
var
  PropertyList: TStringList;
  cName, cValue: string;
  propName: string;
  i: Integer;
  FoundCondition: string;

  procedure AddPropertyListToCharacteristic;
  begin
    if PropertyList.Count > 0 then
    begin
      iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, PropertyList, iCharacteristicDefinition);
      PropertyList.Clear;
    end;

  end;

  procedure ConvertObjectProperties (iJsonObject: TJsonObject; iParentProperty: string);
  var
    i: Integer;
    PropertyName: string;
  begin
    for i := 0 to iJsonObject.Count - 1 do
    begin
      PropertyList.Clear;
      cName := iJsonObject.Pairs[i].JsonString.Value;
      if not iParentProperty.IsEmpty then
        PropertyName := Format ('%s.%s', [iParentProperty, cName])
      else
        PropertyName := cName;
      if not Definition.IsPropertyHidden (cName, iInfo.PropertyName, iInfo.ParentObjectType, FoundCondition) then
        if IsJsonSimple (iJsonObject.Pairs[i].JsonValue) then
        begin
          cValue := iJsonObject.Pairs[i].JsonValue.Value;
          if not iParentProperty.IsEmpty then
            PropertyList.AddPair ('parent', iParentProperty);
          PropertyList.AddPair ('attribute', cName);
          PropertyList.AddPair ('value', cValue);
        end
        else if iJsonObject.Pairs[i].JsonValue is TJSONArray then
        begin
          cValue := GetJsonStringArray (TJSONArray(iJsonObject.Pairs[i].JsonValue));
          if not iParentProperty.IsEmpty then
            PropertyList.AddPair ('parent', iParentProperty);
          PropertyList.AddPair ('attribute', cName);
          PropertyList.AddPair ('value', cValue);
          AddFileLog ('Property "%s.%s" fetched from array : "%s"', [iInfo.PropertyName, PropertyName, cValue]);
        end
        else if iJsonObject.Pairs[i].JsonValue is TJsonObject then
          ConvertObjectProperties (TJsonObject(iJsonObject.Pairs[i].JsonValue), PropertyName)
        else
          AddFileLog ('Property "%s.%s" will be ignored, it'' not a simple type', [iInfo.PropertyName, PropertyName])
      else
        AddFileLog ('Property "%s.%s" defined as hidden %s', [iInfo.PropertyName, PropertyName, FoundCondition]);
      AddPropertyListToCharacteristic;
    end;
  end;

begin
  PropertyList := TStringList.Create;
  try
    AddFileLog ('Handle as %s characteristic - "%s"', [iCharacteristicDefinition.CharacteristicType.ToString,
      'characteristicProperties']);
    if iCharacteristicDefinition.CharacteristicType = jctList then
    begin
      for propName in iCharacteristicDefinition.PropertyList do
        if not propName.IsEmpty then
        begin
          cValue := GetJsonStringValue (iJsonObject, propName);
          if not cValue.IsEmpty then
            PropertyList.AddPair (propName, cValue);
        end;
      AddPropertyListToCharacteristic;
    end
    else
    begin
      ConvertObjectProperties (iJsonObject, '');
    end;
  finally
    PropertyList.Free;
  end;
end;

procedure TJson2PumlConverter.ConvertObject (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord);
var
  i: Integer;
  PumlObject: tPumlObject;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
  IsObjectProperty, IsObjectDetail, IsRelationShip, IsCharacteristic: Boolean;

  cName: string;
  RelationshipObject: string;
  RelationshipType: string;
  RelationshipProperty: string;
  ObjectIdent: string;
  ObjectType: string;
  ObjectTypeRenamed: string;
  CharacteristicDefinition: tJson2PumlCharacteristicDefinition;
  ObjectDefinition: tJson2PumlObjectDefinition;
  RelationshipTypeProperty: string;
  AlreadyHandled: Boolean;
  ObjectTitle: string;
  LogMessage: string;
  FoundCondition: string;

  function CheckObjectIdent (iObjectType: string): Boolean;
  begin
    if ObjectIdent.IsEmpty then
      if not ObjectDefinition.GenerateWithoutIdentifier then
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
  AlreadyHandled := false;
  if not Assigned (iJsonObject) then
    Exit;

  PumlObject := nil;

  SaveRecursionRecord := IncRecursionRecord (iInfo, trpObject);
  try
    ObjectIdent := GetObjectIdent (iJsonObject, iInfo.PropertyName, FoundCondition);
    if not ObjectIdent.IsEmpty then
      AddFileLog ('Objectidentifier "%s" identified - "%s" %s', [ObjectIdent, 'objectIdentifierProperties',
        FoundCondition]);
    ObjectTitle := GetObjectTitleProperties (iJsonObject, iInfo.PropertyName, FoundCondition);
    if not ObjectTitle.IsEmpty then
      AddFileLog ('Objecttitle "%s" identified - "%s" %s', [ObjectTitle, 'objectTitleProperties', FoundCondition]);
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

    ObjectDefinition := Definition.ObjectProperties.GetDefinitionByName (ObjectTypeRenamed, iInfo.ParentPropertyName,
      iInfo.ParentObjectType, FoundCondition);
    IsObjectProperty := Assigned (ObjectDefinition);
    if IsObjectProperty then
      AddFileLog ('Objecttype "%s" defined as object %s', [ObjectTypeRenamed, FoundCondition]);

    CharacteristicDefinition := Definition.CharacteristicProperties.GetDefinitionByName (iInfo.PropertyName,
      iInfo.ParentPropertyName, iInfo.ParentObjectType, FoundCondition);
    IsCharacteristic := Assigned (CharacteristicDefinition);
    if IsCharacteristic then
      AddFileLog ('Object "%s.%s" defined as characteristic %s', [iInfo.ParentPropertyName, iInfo.PropertyName,
        FoundCondition]);
    IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentPropertyName,
      iInfo.ParentObjectType, FoundCondition);
    if IsRelationShip then
      AddFileLog ('Object "%s.%s" defined as relationship %s', [iInfo.ParentPropertyName, iInfo.PropertyName,
        FoundCondition]);
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

    if IsRelationShip then
    begin
      RelationshipObject := ObjectTypeRenamed;
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

    if not Assigned (PumlObject) and not IsCharacteristic then
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
    if IsCharacteristic and Assigned (iInfo.ParentObject) and not IsObjectDetail then
    begin
      AlreadyHandled := true;
      ConvertCharacteristic (iJsonObject, iInfo, CharacteristicDefinition);
    end;
    if Assigned (PumlObject) then
    begin
      if not ObjectIdent.IsEmpty then
        iInfo.HierarchieParentObject := PumlObject;
      if not ObjectTitle.IsEmpty and PumlObject.ObjectTitle.IsEmpty then
        PumlObject.ObjectTitle := ObjectTitle;
    end;
    ReplaceObjectType (PumlObject, ObjectTypeRenamed);
    iInfo.ParentObject := PumlObject;
    iInfo.ParentRelationshipProperty := RelationshipProperty;
    iInfo.ParentRelationshipType := RelationshipType;
    iInfo.ParentRelationShipTypeProperty := RelationshipTypeProperty;
    iInfo.ParentPropertyName := iInfo.PropertyName;
    iInfo.ParentIsRelationship := IsRelationShip;
    if Definition.ContinueAfterUnhandledObjects then
      iInfo.StopRecursion := false
    else
      iInfo.StopRecursion := not (Assigned(PumlObject) or IsObjectDetail or IsRelationShip) and
        Assigned (iInfo.HierarchieParentObject);
    if not AlreadyHandled then
      for i := 0 to iJsonObject.Count - 1 do
      begin
        cName := iJsonObject.Pairs[i].JsonString.Value;
        if not Definition.IsPropertyHidden (cName, iInfo.ParentPropertyName, iInfo.ParentObjectType, FoundCondition)
        then
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

procedure TJson2PumlConverter.ConvertValue (iJsonValue: TJSONValue; iInfo: tJson2PumlRecursionRecord;
  iRecursionParent: tJson2PumlRecursionParent);
var
  PumlObject: tPumlObject;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
  ObjectTypeRenamed: string;
  Value: string;
  IsRelationShip: Boolean;
  LogMessage: string;
  FoundCondition: string;
begin
  if not Assigned (iJsonValue) then
    Exit;
  SaveRecursionRecord := IncRecursionRecord (iInfo, trpValue);
  try
    if iJsonValue is TJSONArray then
      ConvertArray (iJsonValue as TJSONArray, iInfo)
    else if iJsonValue is TJsonObject then
    begin
      if not iInfo.StopRecursion then
        ConvertObject (iJsonValue as TJsonObject, iInfo)
    end
    else if IsJsonSimple (iJsonValue) then
    begin
      Value := iJsonValue.Value;
      IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentPropertyName,
        iInfo.ParentObjectType, FoundCondition);

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
          if Definition.IsPropertyAllowed (iInfo.PropertyName, iInfo.ParentPropertyName, iInfo.ParentObjectType,
            FoundCondition) then
          begin
            iInfo.ParentObject.AddValue (iInfo.PropertyName, Value, not (iRecursionParent = trpArray));
            AddFileLog ('property [%s] value [%s] found %s', [iInfo.PropertyName, Value, FoundCondition]);
          end
          else
            AddFileLog ('property [%s] not allowed and skipped %s', [iInfo.PropertyName, FoundCondition]);
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
  Formats: TStringList;
  GroupList, GroupCountList: TStringList;
begin
  AddFileLog ('Start PUML Generation');
  PumlObjects.UpdateRedundant;
  FCurrentRecursionRecord.Level := FCurrentRecursionRecord.Level + 1;
  Formats := TStringList.Create;
  Formats.Sorted := true;
  Formats.Duplicates := dupIgnore;
  GroupList := TStringList.Create;
  GroupList.Sorted := true;
  GroupList.Duplicates := dupIgnore;
  GroupCountList := TStringList.Create;
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

function TJson2PumlConverter.GetObjectIdent (iJsonObject: TJsonObject; iParentProperty: string;
  var oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectIdentifierProperties, iJsonObject, iParentProperty,
    'objectIdentifierProperties', oFoundCondition);
end;

function TJson2PumlConverter.GetObjectTitleProperties (iJsonObject: TJsonObject; iParentProperty: string;
  var oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTitleProperties, iJsonObject, iParentProperty,
    'objectTitleProperties', oFoundCondition);
end;

function TJson2PumlConverter.GetObjectTypeProperties (iJsonObject: TJsonObject; iParentProperty: string;
  var oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTypeProperties, iJsonObject, iParentProperty,
    'objectTypeProperties', oFoundCondition);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: TJsonObject; iParentProperty, iConfigurationPropertyName: string; var oFoundCondition: string): string;
var
  PropertyName: string;
begin
  Result := GetPropertyValueListProperties (iDefinitionList, iJsonObject, iParentProperty, PropertyName,
    iConfigurationPropertyName, oFoundCondition);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: TJsonObject; iParentProperty: string; var oPropertyName: string; iConfigurationPropertyName: string;
  var oFoundCondition: string): string;
var
  Search: string;
  Value: string;
  LastSep, Sep: string;
  Definition: tJson2PumlPropertyValueDefinition;
begin
  Result := '';
  LastSep := '';
  oPropertyName := '';
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
      Search := string.Join ('.', [Search, Definition.ChildPropertyName]);

      Value := GetJsonStringValue (iJsonObject, Search, '', Sep);

      if not Value.IsEmpty then
      begin
        if oPropertyName.IsEmpty then
          oPropertyName := Search
        else
          oPropertyName := string.Join (';', [oPropertyName, Search]);
        if Result.IsEmpty then
          Result := Value
        else
          Result := string.Join (LastSep, [Result, Value]);
        if Sep.IsEmpty then
          Exit;
        LastSep := Sep;
      end;
    end;
  finally
    oFoundCondition := iDefinitionList.BuildFoundCondition (iConfigurationPropertyName,
      oPropertyName.TrimRight(['.']), Result);
  end;
end;

procedure TJson2PumlConverter.GetRelationshipType (iJsonObject: TJsonObject; iPropertyName: string;
  var oRelationshipType, oRelationshipTypeProperty: string; var oFoundCondition: string);
begin
  oRelationshipType := GetPropertyValueListProperties (Definition.RelationshipTypeProperties, iJsonObject,
    iPropertyName, oRelationshipTypeProperty, 'relationshipTypeProperties', oFoundCondition);
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
  oldIdx, newIdx: Integer;
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

function TJson2PumlConverter.Convert: Boolean;
var
  jValue: TJSONValue;
  InfoRec: tJson2PumlRecursionRecord;
begin
  Result := false;
  Puml.Clear;
  PumlObjects.Clear;
  PumlObjects.ConverterDefinition := Definition;
  PumlObjects.InputFilter := InputFilter;
  if FileExists (PumlFile) then
    tFile.Delete (PumlFile);

  jValue := TJsonObject.ParseJSONValue (JsonInput.Text);
  if not Assigned (jValue) then
    GlobalLoghandler.Error ('Unable to parse JSON structure of file "%s"',
      [InputHandlerRecord.InputFile.OutputFileName])
  else
  begin
    InfoRec.ParentObject := nil;
    InfoRec.HierarchieParentObject := nil;
    InfoRec.ParentPropertyName := '';
    InfoRec.PropertyName := LeadingObject;
    InfoRec.OriginalPropertyName := LeadingObject;
    InfoRec.ParentRelationshipProperty := '';
    InfoRec.ParentRelationshipType := '';
    InfoRec.ParentRelationShipTypeProperty := '';
    InfoRec.StopRecursion := false;
    InfoRec.ParentIsRelationship := false;
    InfoRec.Level := 0;
    InfoRec.ObjectLevel := 0;
    ConvertValue (jValue, InfoRec, trpStart);
    GeneratePuml;
    Result := true;
  end;
end;

procedure TJson2PumlConverter.GeneratePumlLegend (iUsedFormats: TStrings);
var
  f, s: string;
  i: Integer;
  Colors: TStringList;
  ObjectFormat: tJson2PumlSingleFormatDefinition;
  FileDetailRecord: TJson2PumlFileDetailRecord;
  Param, Value: string;
  vAdd: Boolean;
  Line: string;
  FileLength: Integer;

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
    Puml.Add (tPumlHelper.TableLine([InputHandler.CurlParameterList.ReplaceParameterValues(InputHandler.CurrentJobDescription)]));
  end;
  if Definition.LegendShowObjectFormats then
  begin
    Colors := TStringList.Create;
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
          for i := 1 to 5 - Colors.Count do
            Line := Line + tPumlHelper.TableColumn ('  ', true) + tPumlHelper.TableColumn ('  ', true);
          Puml.Add (Line);
        end;
      end;
    finally
      Colors.Clear;
    end;
    vAdd := true;
  end;
  if (InputHandlerRecord.InputFile.Output.SourceFiles.Count > 0) and Definition.LegendShowFileInfos then
  begin
    if vAdd then
      Puml.Add ('');
    Puml.Add (tPumlHelper.TableLine(['File', 'Date', 'Size (kb)', 'No Of Lines'], true));
    for i := 0 to InputHandlerRecord.InputFile.Output.SourceFiles.Count - 1 do
    begin
      FileDetailRecord := TJson2PumlFileDetailRecord (InputHandlerRecord.InputFile.Output.SourceFiles.Objects[i]);
      Puml.Add (tPumlHelper.TableLine([tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath
        (FileDetailRecord.Filename)), DateTimeToStr(FileDetailRecord.FileDate),
        Format('%4.3f', [FileDetailRecord.FileSize / 1024]).PadLeft(12),
        FileDetailRecord.NoOfLines.ToString.PadLeft(12)]));
    end;
  end;
  Puml.Add ('end legend');
  Puml.Add ('');
end;

function tJson2PumlRecursionParentHelper.OperationName: string;
begin
  Result := cJson2PumlRecursionParentFunction[self];
end;

function tJson2PumlRecursionRecord.GetParentObjectType: string;
begin
  if Assigned (ParentObject) then
    Result := ParentObject.ObjectType
  else
    Result := '';
end;

end.
