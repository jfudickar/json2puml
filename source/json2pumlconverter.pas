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
    ParentProperty: string;
    PropertyName: string;
    OriginalPropertyName: string;
    ParentRelationshipProperty: string;
    ParentRelationshipType: string;
    ParentRelationShipTypeProperty: string;
    ParentIsRelationship: Boolean;
    StopRecursion: Boolean;
    Level: Integer;
    ObjectLevel: Integer;
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
    FPumlRelationShips: tPumlRelationshipList;
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
    procedure ConvertObject (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord);
    procedure ConvertValue (iJsonValue: TJSONValue; iInfo: tJson2PumlRecursionRecord;
      iRecursionParent: tJson2PumlRecursionParent);
    function CreateGroupObject (var ioInfo: tJson2PumlRecursionRecord): tPumlObject;
    procedure DecRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
      iSafeCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent);
    procedure GeneratePuml;
    function GetObjectIdent (iJsonObject: TJsonObject; iParentPropertyName: string = ''): string;
    function GetObjectTitleProperties (iJsonObject: TJsonObject; iParentProperty: string): string;
    function GetObjectTypeProperties (iJsonObject: TJsonObject; iParentProperty: string): string;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: TJsonObject; iParentProperty: string): string; overload;
    function GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
      iJsonObject: TJsonObject; iParentProperty: string; var oPropertyName: string): string; overload;
    procedure GetRelationshipType (iJsonObject: TJsonObject; iPropertyName: string;
      var oRelationshipType, oRelationshipTypeProperty: string);
    function IncRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent)
      : tJson2PumlRecursionRecord;
    function ParentPropertyName (iParentProperty, iPropertyName: string): string;
    procedure ReplaceObjectType (iPumlObject: tPumlObject; iObjectType: string);
    property PumlObjects: tPumlObjectList read FPumlObjects;
    property PumlRelationShips: tPumlRelationshipList read FPumlRelationShips;
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
  json2pumlbasedefinition;

const
  cUmlRelationDirection: array [tUmlRelationDirection] of string = ('To', 'From');

  cJson2PumlRecursionParentFunction: array [tJson2PumlRecursionParent] of string = ('Start', 'ConvertObject',
    'ConvertArray', 'ConvertValue');

procedure TJson2PumlConverter.BuildObjectRelationships (iHierarchieParentObject, iPumlObject: tPumlObject;
  iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty: string; iAllways: Boolean);
var
  added: Boolean;
begin
  added := iHierarchieParentObject.addRelationship (iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty,
    iPumlObject, urdTo, iAllways);
  if added then
  begin
    iPumlObject.addRelationship (iRelationshipProperty, iRelationshipType, iRelationshipTypeProperty,
      iHierarchieParentObject, urdFrom);
    PumlRelationShips.addRelationship (iHierarchieParentObject, iPumlObject, iRelationshipType,
      iRelationshipTypeProperty, iRelationshipProperty, iAllways);
    AddFileLog ('Build Relationship to "%s"', [iHierarchieParentObject.ObjectIdentifier]);
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

procedure TJson2PumlConverter.ConvertObject (iJsonObject: TJsonObject; iInfo: tJson2PumlRecursionRecord);
var
  i: Integer;
  PumlObject: tPumlObject;
  SaveRecursionRecord: tJson2PumlRecursionRecord;
  IsObjectProperty, IsObjectDetail, IsRelationShip, IsCharacteristic: Boolean;

  cname, cvalue, cinfo: string;
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
begin
  AlreadyHandled := false;
  if not Assigned (iJsonObject) then
    Exit;

  SaveRecursionRecord := IncRecursionRecord (iInfo, trpObject);
  try
    CharacteristicDefinition := Definition.CharacteristicProperties.GetDefinitionByName (iInfo.PropertyName,
      iInfo.ParentProperty);
    IsCharacteristic := Assigned (CharacteristicDefinition);
    ObjectIdent := GetObjectIdent (iJsonObject, iInfo.PropertyName);
    if not ObjectIdent.IsEmpty then
      AddFileLog ('Objectidentifier "%s" identified', [ObjectIdent]);
    ObjectTitle := GetObjectTitleProperties (iJsonObject, iInfo.PropertyName);
    if not ObjectTitle.IsEmpty then
      AddFileLog ('Objecttitle "%s" identified', [ObjectTitle]);
    ObjectType := GetObjectTypeProperties (iJsonObject, iInfo.PropertyName);
    if not ObjectType.IsEmpty then
      AddFileLog ('Objecttype "%s" identified', [ObjectType])
    else
    begin
      ObjectType := iInfo.PropertyName;
      if not ObjectType.IsEmpty then
        AddFileLog ('Objecttype "%s" used based on property', [ObjectType]);
    end;
    ObjectTypeRenamed := Definition.RenameObjectType (ObjectType);
    if ObjectTypeRenamed <> ObjectType then
      AddFileLog ('Objecttype renamed to "%s"', [ObjectTypeRenamed]);
    ObjectDefinition := Definition.ObjectProperties.GetDefinitionByName (ObjectTypeRenamed, iInfo.ParentProperty);
    IsObjectProperty := Assigned (ObjectDefinition);
    if not IsObjectProperty then
      AddFileLog ('Objecttype "%s" is not handled, object will be ignored', [ObjectTypeRenamed]);

    IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentProperty);
    IsObjectDetail := Definition.IsObjectDetailProperty (iInfo.PropertyName, iInfo.ParentProperty);
    if IsRelationShip then
    begin
      RelationshipObject := ObjectTypeRenamed;
      GetRelationshipType (iJsonObject, iInfo.PropertyName, RelationshipType, RelationshipTypeProperty);
      RelationshipProperty := iInfo.OriginalPropertyName;
    end
    else
    begin
      RelationshipObject := '';
      if iInfo.ParentRelationShipTypeProperty.IsEmpty then
        GetRelationshipType (iJsonObject, iInfo.PropertyName, RelationshipType, RelationshipTypeProperty)
      else
      begin
        RelationshipTypeProperty := iInfo.ParentRelationShipTypeProperty;
        RelationshipType := iInfo.ParentRelationshipType;
      end;
      RelationshipProperty := iInfo.ParentRelationshipProperty;
    end;

    if ObjectIdent.IsEmpty and IsObjectProperty and ObjectDefinition.GenerateWithoutIdentifier and
      not IsObjectDetail and not IsRelationShip and not IsCharacteristic then
    begin
      if Assigned (iInfo.HierarchieParentObject) then
        ObjectIdent := Format ('%s_%s_%d', [ObjectTypeRenamed, iInfo.HierarchieParentObject.ObjectIdentifier,
          iInfo.HierarchieParentObject.Relations.ToCount])
      else
        ObjectIdent := Format ('%s_%s', [ObjectTypeRenamed, 'root']);
      AddFileLog ('Default object ident "%s" generated', [ObjectIdent]);
    end;
    if ObjectIdent.IsEmpty and IsObjectProperty then
      AddFileLog ('Object not created, no ident identified');
    if IsCharacteristic or (ObjectIdent.IsEmpty) then
      PumlObject := nil
    else if IsRelationShip and Definition.IsObjectProperty (RelationshipObject) then
    begin
      PumlObject := PumlObjects.SearchCreatePumlObject (Definition.RenameObjectType(RelationshipObject), ObjectIdent,
        iInfo.ParentProperty);
      PumlObject.IsRelationShip := true;
      AddFileLog ('Create Relationship Object "%s":"%s"', [PumlObject.ObjectType, ObjectIdent]);
    end
    else if IsObjectProperty then
    begin
      PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, ObjectIdent, iInfo.ParentProperty);
      if ObjectType = ObjectTypeRenamed then
        AddFileLog ('Create Object "%s":"%s"', [PumlObject.ObjectType, ObjectIdent])
      else
        AddFileLog ('Create Object "%s":"%s" (org type: %s)', [PumlObject.ObjectType, ObjectIdent, ObjectType]);
    end
    else
      PumlObject := nil;
    if not Assigned (PumlObject) and IsObjectDetail and Assigned (iInfo.ParentObject) then
    begin
      if ObjectIdent.IsEmpty then
      begin
        ObjectIdent := Format ('%s_%s_%d', [ObjectTypeRenamed, iInfo.ParentObject.Ident,
          iInfo.HierarchieParentObject.Relations.ToCount]);
        AddFileLog ('Default object ident "%s" generated', [ObjectIdent]);
      end;

      PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, ObjectIdent, iInfo.ParentObject.ObjectType);
      PumlObject.IsObjectDetail := true;
      iInfo.ParentObject.DetailObjects.AddObject (PumlObject.ObjectIdentifier, PumlObject);
      AddFileLog ('Create Detail Object "%s":"%s" for %s', [PumlObject.ObjectType, ObjectIdent,
        iInfo.ParentObject.ObjectTypeIdent]);
    end;

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
      AddFileLog ('Handle as %s characteristic', [CharacteristicDefinition.CharacteristicType.ToString]);
      if CharacteristicDefinition.CharacteristicType = jctList then
      begin
        cname := GetJsonStringValue (iJsonObject, CharacteristicDefinition.NameProperties);
        cvalue := GetJsonStringValue (iJsonObject, CharacteristicDefinition.ValueProperties);
        cinfo := GetJsonStringValue (iJsonObject, CharacteristicDefinition.InfoProperties);
        if not cname.IsEmpty then
          iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, cname, cvalue, cinfo,
            CharacteristicDefinition)
        else
          AddFileLog ('Name property %s not filled, value will be ignored', [CharacteristicDefinition.NameProperties.Text]);
      end
      else
      begin
        for i := 0 to iJsonObject.Count - 1 do
        begin
          cname := iJsonObject.Pairs[i].JsonString.Value;
          if not Definition.IsPropertyHidden (cname, iInfo.PropertyName) then
            if iJsonObject.Pairs[i].JsonValue is TJSONString then
            begin
              cvalue := TJSONString (iJsonObject.Pairs[i].JsonValue).Value;
              iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, cname, cvalue, '',
                CharacteristicDefinition);
            end;
        end;
      end;
    end;
    if Assigned (PumlObject) then
    begin
      if not ObjectIdent.IsEmpty then
        iInfo.HierarchieParentObject := PumlObject;
      if not ObjectTitle.IsEmpty and PumlObject.ObjectTitle.IsEmpty then
        PumlObject.ObjectTitle := ObjectTitle;
    end;
    ReplaceObjectType (PumlObject, ObjectType);
    iInfo.ParentObject := PumlObject;
    iInfo.ParentRelationshipProperty := RelationshipProperty;
    iInfo.ParentRelationshipType := RelationshipType;
    iInfo.ParentRelationShipTypeProperty := RelationshipTypeProperty;
    iInfo.ParentProperty := iInfo.PropertyName;
    iInfo.ParentIsRelationship := IsRelationShip;
    if Definition.ContinueAfterUnhandledObjects then
      iInfo.StopRecursion := false
    else
      iInfo.StopRecursion := not (Assigned(PumlObject) or IsObjectDetail or IsRelationShip) and
        Assigned (iInfo.HierarchieParentObject);
    if not AlreadyHandled then
      for i := 0 to iJsonObject.Count - 1 do
      begin
        cname := iJsonObject.Pairs[i].JsonString.Value;
        if not Definition.IsPropertyHidden (cname, iInfo.ParentProperty) then
        begin
          iInfo.PropertyName := cname;
          iInfo.OriginalPropertyName := cname;
          ConvertValue (iJsonObject.Pairs[i].JsonValue, iInfo, trpObject);
        end
        else
          AddFileLog ('Stop property handling, property [%s.%s] is hidden', [iInfo.ParentProperty, cname]);
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
    else if (iJsonValue is TJSONString) or (iJsonValue is TJSONBool) then
    begin
      Value := iJsonValue.Value;
      IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentProperty);
      if Assigned (iInfo.ParentObject) and IsRelationShip then
      begin
        ObjectTypeRenamed := Definition.RenameObjectType (iInfo.PropertyName);
        PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, Value, iInfo.ParentObject.ObjectType);
        AddFileLog ('Create Object "%s":"%s"', [PumlObject.ObjectType, Value]);
        ReplaceObjectType (PumlObject, ObjectTypeRenamed);
        BuildObjectRelationships (iInfo.ParentObject, PumlObject, iInfo.PropertyName, '', '',
          not Definition.HideDuplicateRelations);
      end
      else
      begin
        if Assigned (iInfo.ParentObject) then
          if Definition.IsPropertyAllowed (iInfo.PropertyName, iInfo.ParentProperty) then
          begin
            iInfo.ParentObject.AddValue (iInfo.PropertyName, Value, not (iRecursionParent = trpArray));
            AddFileLog ('property [%s] value [%s] found', [iInfo.PropertyName, Value]);
          end
          else
            AddFileLog ('property [%s.%s] not allowed and skipped', [iInfo.ParentProperty, iInfo.PropertyName]);
      end;
    end;
  finally
    DecRecursionRecord (iInfo, SaveRecursionRecord, trpValue);
  end;
end;

function TJson2PumlConverter.CreateGroupObject (var ioInfo: tJson2PumlRecursionRecord): tPumlObject;
var
  ObjectType, ObjectIdent: string;
  PumlObject: tPumlObject;
begin
  Result := nil;
  if not Definition.IsGroupProperty (ioInfo.PropertyName, ioInfo.ParentProperty, ObjectType) then
    Exit;
  ObjectIdent := Format ('%s_%s', [ObjectType, ioInfo.ParentObject.Ident]);
  AddFileLog ('Group object ident "%s" generated', [ObjectIdent]);
  PumlObject := PumlObjects.SearchCreatePumlObject (ObjectType, ObjectIdent, ioInfo.ParentObject.ObjectType);
  PumlObject.IsGroupProperty := true;
  ioInfo.ParentObject.DetailObjects.AddObject (PumlObject.ObjectIdentifier, PumlObject);
  AddFileLog ('Create Detail Object "%s":"%s" for %s', [PumlObject.ObjectType, ObjectIdent,
    ioInfo.ParentObject.ObjectTypeIdent]);
  BuildObjectRelationships (ioInfo.HierarchieParentObject, PumlObject, '', '', '', false);
  ioInfo.ParentObject := PumlObject;
  ioInfo.HierarchieParentObject := PumlObject;

  Result := PumlObject;
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
  PumlRelationship: tPumlRelationship;
  s: string;
  Formats: TStringList;
begin
  AddFileLog ('Start PUML Generation');
  PumlObjects.UpdateRedundant;
  PumlRelationShips.UpdateRedundant;
  FCurrentRecursionRecord.Level := FCurrentRecursionRecord.Level + 1;
  Formats := TStringList.Create;
  Formats.Sorted := true;
  Formats.Duplicates := dupIgnore;
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
    Puml.Add ('header');
    Puml.Add (Format('<b>%s', [PumlFile.Replace('\', '\<U+200B>')]));
    Puml.Add ('');
    Puml.Add ('endheader');
    Puml.Add ('footer');
    Puml.Add ('');
    Puml.Add (Format('<b>%s', [PumlFile.Replace('\', '\<U+200B>')]));
    Puml.Add ('endfooter');
    // Generating Together
    if Definition.GroupDetailObjectsTogether then
      for PumlObject in PumlObjects do
        if PumlObject.ShowObject and not PumlObject.IsObjectDetail then
          PumlObject.DetailObjects.GeneratePuml (Puml, PumlObject.PlantUmlIdent, PumlObject.ObjectCaption('\l', true));
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
    for PumlRelationship in PumlRelationShips do
      if PumlRelationship.GeneratePuml (Puml, Definition.RelationshipTypeArrowFormats.ItemList) then
        AddFileLog ('Generated : Relation "%s"', [PumlRelationship.Ident])
      else
        AddFileLog ('Skipped   : Relation "%s"', [PumlRelationship.Ident]);
    // Generating Legend
    GeneratePumlLegend (Formats);
    Puml.Add ('');
    Puml.Add ('@enduml');
  finally
    FCurrentRecursionRecord.Level := FCurrentRecursionRecord.Level - 1;
    Formats.Free;
  end;
  AddFileLog ('Stop PUML Generation');
end;

function TJson2PumlConverter.GetObjectIdent (iJsonObject: TJsonObject; iParentPropertyName: string = ''): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectIdentifierProperties, iJsonObject, iParentPropertyName);
end;

function TJson2PumlConverter.GetObjectTitleProperties (iJsonObject: TJsonObject; iParentProperty: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTitleProperties, iJsonObject, iParentProperty);
end;

function TJson2PumlConverter.GetObjectTypeProperties (iJsonObject: TJsonObject; iParentProperty: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectTypeProperties, iJsonObject, iParentProperty);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: TJsonObject; iParentProperty: string): string;
var
  PropertyName: string;
begin
  Result := GetPropertyValueListProperties (iDefinitionList, iJsonObject, iParentProperty, PropertyName);
end;

function TJson2PumlConverter.GetPropertyValueListProperties (iDefinitionList: tJson2PumlPropertyValueDefinitionList;
  iJsonObject: TJsonObject; iParentProperty: string; var oPropertyName: string): string;
var
  Search: string;
  Value: string;
  LastSep, Sep: string;
  Definition: tJson2PumlPropertyValueDefinition;
begin
  Result := '';
  LastSep := '';
  oPropertyName := '';
  for Definition in iDefinitionList do
  begin
    Search := Definition.PropertyName;
    if Search.IndexOf ('.') >= 0 then
      if not MatchesMask (Search, iParentProperty + '.*') then
        Continue
      else
        Search := Search.Substring (Search.IndexOf('.') + 1);

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
end;

procedure TJson2PumlConverter.GetRelationshipType (iJsonObject: TJsonObject; iPropertyName: string;
  var oRelationshipType, oRelationshipTypeProperty: string);
begin
  oRelationshipType := GetPropertyValueListProperties (Definition.RelationshipTypeProperties, iJsonObject,
    iPropertyName, oRelationshipTypeProperty);
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
  FPumlRelationShips := tPumlRelationshipList.Create (nil);
  FPumlObjects := tPumlObjectList.Create ();
end;

destructor TJson2PumlConverter.Destroy;
begin
  FPumlObjects.Free;
  FPumlRelationShips.Free;
  inherited Destroy;
end;

function TJson2PumlConverter.Convert: Boolean;
var
  jValue: TJSONValue;
  InfoRec: tJson2PumlRecursionRecord;
begin
  Result := false;
  Puml.Clear;
  PumlRelationShips.Clear;
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
    InfoRec.ParentProperty := '';
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
begin
  if not Definition.ShowLegend then
    Exit;
  vAdd := false;
  Puml.Add ('legend');
  if Definition.LegendShowInfo then
  begin
    vAdd := true;
    Puml.Add (Format('| <b>json2puml | <b>%s\n |', [FileVersion]));
    Puml.Add (Format('| Generated at | %s %s |', [DateTostr(Now), TimetoStr(Now)]));
    // Puml.add (Format('| PUML File | %s |', [PumlFile]));
    Puml.Add (Format('| Definition File | %s |', [InputHandler.CurrentDefinitionFileName.Replace('\', '\<U+200B>')]));
    if not InputHandler.CmdLineParameter.InputFileName.IsEmpty then
    begin
      Puml.Add (Format('| Input File | %s |', [InputHandlerRecord.InputFile.OutputFileName.Replace('\', '\<U+200B>')]));
      if not InputHandler.CmdLineParameter.LeadingObject.IsEmpty then
        Puml.Add (Format('| Leading Object | %s |', [InputHandler.CmdLineParameter.LeadingObject]));
    end;
    if not InputHandler.CurrentInputListFileName.IsEmpty then
      Puml.Add (Format('| Input List File | %s |', [InputHandler.CurrentInputListFileName.Replace('\', '\<U+200B>')]));
    Puml.Add (Format('| Definition Option | %s |', [Definition.OptionName]));
    for i := 0 to InputFilter.IdentFilter.Count - 1 do
      if i = 0 then
        Puml.Add (Format('| Ident Filter | %s |', [InputFilter.IdentFilter[i]]))
      else
        Puml.Add (Format('| | %s |', [InputFilter.IdentFilter[i]]));
    for i := 0 to InputFilter.TitleFilter.Count - 1 do
      if i = 0 then
        Puml.Add (Format('| Title Filter | %s |', [InputFilter.TitleFilter[i]]))
      else
        Puml.Add (Format('| | %s |', [InputFilter.TitleFilter[i]]));
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
              Colors.Add (Format('|<back:%s>   </back>| %s |', [Value, ObjectFormat.FormatName]));
          end;
        end;
      end;
      if Colors.Count > 0 then
      begin
        if vAdd then
          Puml.Add ('');
        Puml.Add ('|= |= Objectformat |');
        Puml.AddStrings (Colors);
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
    Puml.Add ('|= File |= Date |= Size (kb) |= No Of Lines |');
    for i := 0 to InputHandlerRecord.InputFile.Output.SourceFiles.Count - 1 do
    begin
      FileDetailRecord := TJson2PumlFileDetailRecord (InputHandlerRecord.InputFile.Output.SourceFiles.Objects[i]);
      Puml.Add (Format('| %s | %s | %s | %s |', [FileDetailRecord.Filename.Replace('\t', '\\t'),
        DateTimeToStr(FileDetailRecord.FileDate), Format('%4.3f', [FileDetailRecord.FileSize / 1024]).PadLeft(12),
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

end.
