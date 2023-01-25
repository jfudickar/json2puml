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
    function CreateGroupObject (iObjectType: string; var ioInfo: tJson2PumlRecursionRecord): tPumlObject;
    procedure DecRecursionRecord (var ioCurrentRecord: tJson2PumlRecursionRecord;
      iSafeCurrentRecord: tJson2PumlRecursionRecord; iParent: tJson2PumlRecursionParent);
    procedure GeneratePuml;
    function GetObjectIdent (iJsonObject: TJsonObject; iParentPropertyName: string;
      var oFoundCondition: string): string;
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
  json2pumlbasedefinition, System.Math;

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
  LogMessage: string;
  FoundCondition: string;

begin
  AlreadyHandled := false;
  if not Assigned (iJsonObject) then
    Exit;

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
    ObjectTypeRenamed := Definition.RenameObjectType (ObjectType, iInfo.ParentProperty, FoundCondition);
    if ObjectTypeRenamed <> ObjectType then
      AddFileLog ('Objecttype renamed to "%s" %s', [ObjectTypeRenamed, FoundCondition]);

    ObjectDefinition := Definition.ObjectProperties.GetDefinitionByName (ObjectTypeRenamed, iInfo.ParentProperty,
      FoundCondition);
    IsObjectProperty := Assigned (ObjectDefinition);
    if IsObjectProperty then
      AddFileLog ('Objecttype "%s" defined as object %s', [ObjectTypeRenamed, FoundCondition]);

    CharacteristicDefinition := Definition.CharacteristicProperties.GetDefinitionByName (iInfo.PropertyName,
      iInfo.ParentProperty, FoundCondition);
    IsCharacteristic := Assigned (CharacteristicDefinition);
    if IsCharacteristic then
      AddFileLog ('Object "%s.%s" defined as characteristic %s', [iInfo.ParentProperty, iInfo.PropertyName,
        FoundCondition]);
    IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentProperty, FoundCondition);
    if IsRelationShip then
      AddFileLog ('Object "%s.%s" defined as relationship %s', [iInfo.ParentProperty, iInfo.PropertyName,
        FoundCondition]);
    IsObjectDetail := Definition.IsObjectDetailProperty (iInfo.PropertyName, iInfo.ParentProperty, FoundCondition);
    if IsObjectDetail then
      AddFileLog ('Object "%s.%s" defined as object detail %s', [iInfo.ParentProperty, iInfo.PropertyName,
        FoundCondition]);
    if IsObjectDetail and IsCharacteristic then
    begin
      AddFileLog ('Object "%s.%s" will be used as detail object and not as characteristic',
        [iInfo.ParentProperty, iInfo.PropertyName]);
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
        GetRelationshipType (iJsonObject, iInfo.PropertyName, RelationshipType, RelationshipTypeProperty,
          FoundCondition)
      else
      begin
        RelationshipTypeProperty := iInfo.ParentRelationShipTypeProperty;
        RelationshipType := iInfo.ParentRelationshipType;
      end;
      RelationshipProperty := iInfo.ParentRelationshipProperty;
    end;

    if ObjectIdent.IsEmpty and IsObjectProperty and not IsObjectDetail { and not IsRelationShip } and not IsCharacteristic
    then
    begin
      if not ObjectDefinition.GenerateWithoutIdentifier then
        AddFileLog ('Object not created, no ident identified')
      else
      begin
        if Assigned (iInfo.HierarchieParentObject) then
          ObjectIdent := iInfo.HierarchieParentObject.CalculateChildObjectDefaultIdent (ObjectTypeRenamed)
        else
          ObjectIdent := Format ('%s_%s', [ObjectTypeRenamed, 'root']);
        AddFileLog ('Default object ident "%s" generated', [ObjectIdent]);
      end;
    end;

    if IsCharacteristic then
      PumlObject := nil
    else if IsRelationShip and Definition.IsObjectProperty (RelationshipObject, '', FoundCondition) then
    begin
      AddFileLog ('Type "%s" identified as relationship object %s', [RelationshipObject, FoundCondition]);
      PumlObject := PumlObjects.SearchCreatePumlObject (Definition.RenameObjectType(RelationshipObject, '',
        FoundCondition), ObjectIdent, iInfo.ParentProperty, LogMessage, 'relationship object',
        Format('- "%s"/"%s"', ['relationshipProperties', 'objectProperties']));
      AddFileLog (LogMessage);
      PumlObject.IsRelationShip := true;
    end
    else if IsObjectProperty and not (ObjectIdent.IsEmpty) then
    begin
      PumlObject := PumlObjects.SearchCreatePumlObject (ObjectTypeRenamed, ObjectIdent, iInfo.ParentProperty,
        LogMessage);
      AddFileLog (LogMessage);
      CreateGroupObject (ObjectTypeRenamed, iInfo);
    end
    else
      PumlObject := nil;

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
      AddFileLog ('Handle as %s characteristic - "%s"', [CharacteristicDefinition.CharacteristicType.ToString,
        'characteristicProperties']);
      if CharacteristicDefinition.CharacteristicType = jctList then
      begin
        cname := GetJsonStringValue (iJsonObject, CharacteristicDefinition.NameProperties);
        cvalue := GetJsonStringValue (iJsonObject, CharacteristicDefinition.ValueProperties);
        cinfo := GetJsonStringValue (iJsonObject, CharacteristicDefinition.InfoProperties);
        if not cname.IsEmpty then
          iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, cname, cvalue, cinfo,
            CharacteristicDefinition)
        else
          AddFileLog ('Name property %s not filled, value will be ignored',
            [CharacteristicDefinition.NameProperties.Text]);
      end
      else
      begin
        for i := 0 to iJsonObject.Count - 1 do
        begin
          cname := iJsonObject.Pairs[i].JsonString.Value;
          if not Definition.IsPropertyHidden (cname, iInfo.PropertyName, FoundCondition) then
            if IsJsonSimple (iJsonObject.Pairs[i].JsonValue) then
            begin
              cvalue := iJsonObject.Pairs[i].JsonValue.Value;
              iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, cname, cvalue, '',
                CharacteristicDefinition);
            end
            else if iJsonObject.Pairs[i].JsonValue is TJSONArray then
            begin
              cvalue := GetJsonStringArray(TJSONArray(iJsonObject.Pairs[i].JsonValue));
              iInfo.ParentObject.AddCharacteristic (iInfo.OriginalPropertyName, cname, cvalue, '',
                CharacteristicDefinition);
              AddFileLog ('Property "%s.%s" fetched from array : "%s"',
                [iInfo.PropertyName, cname,cvalue]);
            end
            else
              AddFileLog ('Property "%s.%s" will be ignored, it'' not a simple type',
                [iInfo.PropertyName, cname])
          else
            AddFileLog ('Property "%s.%s" defined as hidden %s', [iInfo.PropertyName, cname, FoundCondition]);
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
        if not Definition.IsPropertyHidden (cname, iInfo.ParentProperty, FoundCondition) then
        begin
          iInfo.PropertyName := cname;
          iInfo.OriginalPropertyName := cname;
          ConvertValue (iJsonObject.Pairs[i].JsonValue, iInfo, trpObject);
        end
        else
          AddFileLog ('Stop property handling, property [%s.%s] is hidden %s',
            [iInfo.ParentProperty, cname, FoundCondition]);
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
      IsRelationShip := Definition.IsRelationshipProperty (iInfo.PropertyName, iInfo.ParentProperty, FoundCondition);

      if Assigned (iInfo.ParentObject) then
        if IsRelationShip then
        begin
          AddFileLog ('Type "%s" identified as relationship object %s', [iInfo.PropertyName, FoundCondition]);
          ObjectTypeRenamed := Definition.RenameObjectType (iInfo.PropertyName, '', FoundCondition);
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
          if Definition.IsPropertyAllowed (iInfo.PropertyName, iInfo.ParentProperty, FoundCondition) then
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

function TJson2PumlConverter.CreateGroupObject (iObjectType: string; var ioInfo: tJson2PumlRecursionRecord)
  : tPumlObject;
var
  ObjectType, ObjectIdent: string;
  PumlObject: tPumlObject;
  LogMessage: string;
  FoundCondition: string;
begin
  Result := nil;
  if not Definition.IsGroupProperty (iObjectType, ioInfo.ParentProperty, FoundCondition, ObjectType) then
    Exit;
  ObjectIdent := Format ('%s_%s_%s', ['group', ObjectType, ioInfo.ParentObject.ObjectIdentifier]);
  AddFileLog ('  Group object ident "%s" generated %s', [ObjectIdent, FoundCondition]);
  PumlObject := PumlObjects.SearchCreatePumlObject (ObjectType, ObjectIdent, ioInfo.ParentObject.ObjectType, LogMessage,
    'group object', Format('for %s', [ioInfo.ParentObject.ObjectTypeIdent]));
  AddFileLog ('  ' + LogMessage);
  PumlObject.IsGroupObject := true;
  ioInfo.ParentObject.DetailObjects.AddObject (PumlObject.ObjectIdentifier, PumlObject);
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

    Puml.Add (Format('<b>%s', [tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(PumlFile))]));
    Puml.Add ('');
    Puml.Add ('endheader');
    Puml.Add ('footer');
    Puml.Add ('');
    Puml.Add (Format('<b>%s', [tPumlHelper.ReplaceTabNewLine(InputHandler.CleanSummaryPath(PumlFile))]));
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

function TJson2PumlConverter.GetObjectIdent (iJsonObject: TJsonObject; iParentPropertyName: string;
  var oFoundCondition: string): string;
begin
  Result := GetPropertyValueListProperties (Definition.ObjectIdentifierProperties, iJsonObject, iParentPropertyName,
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
  if not InputHandler.CurrentDescription.IsEmpty then
  begin
    if vAdd then
      Puml.Add ('')
    else
      vAdd := true;
    Puml.Add (tPumlHelper.TableLine(['<b>Description'.PadRight(FileLength + 50)]));
    Puml.Add (tPumlHelper.TableLine([InputHandler.CurrentDescription]));
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
          Line := Line + tPumlHelper.TableColumn ('  ', true) + tPumlHelper.TableColumn ('Objectformat', true);
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

end.
