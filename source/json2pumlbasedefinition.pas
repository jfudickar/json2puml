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

unit json2pumlbasedefinition;

interface

uses System.JSON, System.Classes, json2pumlconst, Quick.Logger;

type
  tJson2PumlCalculateOutputFilenameEvent = function(iFileName, iSourceFileName: string; iNewFileExtension: string = '')
    : string of object;
  tJson2PumlNotifyChangeEvent = procedure(Sender: TObject; ProgressValue, ProgressMaxValue: Integer) of object;

  tJson2PumlOutputFormatHelper = record helper for tJson2PumlOutputFormat
    function FileExtension (iLeadingSeparator: boolean = false): string;
    procedure FromString (aValue: string);
    procedure FromStringExtension (aValue: string);
    function IsPumlOutput: boolean;
    function PumlGenerateFlag: string;
    function ServiceResultName: string;
    function ToString: string;
  public
    function FileName (const iFileName: string): string;
  end;

  tJson2PumlApplicationTypeHelper = record helper for tJson2PumlApplicationType
    function ApplicationName: string;
  end;

  tJson2PumlOutputFormatsHelper = record helper for tJson2PumlOutputFormats
    procedure FromString (aValue: string; iPumlOutputOnly: boolean; iSupportOutPutAll: boolean);
    function ToString (iPumlOutputOnly: boolean): string;
  end;

  tJson2PumlCharacteristicTypeHelper = record helper for tJson2PumlCharacteristicType
    procedure FromString (aValue: string);
    function ToString: string;
  end;

  tJson2PumlListOperationHelper = record helper for tJson2PumlListOperation
    procedure FromString (aValue: string);
    function ToString: string;
  end;

  tJson2PumlFileNameReplaceHelper = record helper for tJson2PumlFileNameReplace
    procedure FromString (aValue: string);
    function ToString: string;
  end;

  tJson2PumlErrorTypeHelper = record helper for tJson2PumlErrorType
    function Errorcode: string;
    function ErrorDescription: string;
    function ErrorMessage: string;
    function EventType: TEventType;
    function Failed: boolean;
    function HttpStatusCode: Integer;
    procedure RenderErrorResponse (oJson: TStringList; iLevel: Integer; iErrorMessage: string = '');
  end;

  tJson2PumlBaseObject = class(tPersistent)
  private
    FSourceFileName: string;
    FSourceFileNamePath: string;
  protected
    function GetFileNameExpanded (iFileName: string): string;
    function GetIdent: string; virtual; abstract;
    function GetIsFilled: boolean; virtual;
    function GetIsValid: boolean; virtual;
    function JsonAttributeValue (iPropertyName, iValue: string; iValueQuotes: boolean = true): string;
    function JsonAttributeValueList (iPropertyName: string; iValueList: TStringList): string;
    function MergeValue (iValue, iNewValue: string): string;
    procedure SetSourceFileName (const Value: string); virtual;
  public
    constructor Create; virtual;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; virtual;
    function Clone: tJson2PumlBaseObject; virtual;
    procedure MergeWith (iMergeDefinition: tJson2PumlBaseObject); virtual;
    function ReadFromJson (iJson, iFileName: string): boolean; overload; virtual;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; overload; virtual;
    function ReadFromJsonFile (iFileName: string): boolean; virtual;
    function SaveToFile (iJsonLines: TStrings; iFileName: string; iWriteEmpty: boolean = false): boolean;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); virtual;
    procedure WriteToJsonFile (iFileName: string; iWriteEmpty: boolean = false); virtual;
    property Ident: string read GetIdent;
    property IsFilled: boolean read GetIsFilled;
    property IsValid: boolean read GetIsValid;
    property SourceFileName: string read FSourceFileName write SetSourceFileName;
    property SourceFileNamePath: string read FSourceFileNamePath;
  end;

  tJson2PumlBaseList = class(tJson2PumlBaseObject)
  private
    FItemList: TStringList;
    function GetBaseObject (Index: Integer): tJson2PumlBaseObject;
    function GetCount: Integer;
    function GetDuplicates: TDuplicates;
    function GetNames (Index: Integer): string;
    function GetObjects (Index: Integer): TObject;
    function GetOwnsObjects: boolean;
    function GetSorted: boolean;
    function GetStrings (Index: Integer): string;
    function GetText: string;
    function GetValueFromIndex (Index: Integer): string;
    procedure SetDuplicates (const Value: TDuplicates);
    procedure SetObjects (Index: Integer; const Value: TObject);
    procedure SetOwnsObjects (const Value: boolean);
    procedure SetSorted (const Value: boolean);
    procedure SetStrings (Index: Integer; const Value: string);
    procedure SetText (const Value: string);
  protected
    function CreateListValueObject: tJson2PumlBaseObject; virtual;
    function GetIdent: string; override;
    function GetIsFilled: boolean; override;
    procedure ReadListValueFromJson (iJsonValue: TJSONValue); virtual;
    procedure SetSourceFileName (const Value: string); override;
    property BaseObject[index: Integer]: tJson2PumlBaseObject read GetBaseObject;
    property ValueFromIndex[index: Integer]: string read GetValueFromIndex;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddBaseObject (iBaseObject: tJson2PumlBaseObject);
    function AddObject (const S: string; AObject: TObject): Integer;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; override;
    procedure Delete (Index: Integer);
    function IndexOf (S: string): Integer;
    function IndexOfName (S: string): Integer;
    function ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean; overload; override;
    procedure Sort;
    procedure WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonItem (oJsonOutPut: TStrings; iPropertyName: string; iIndex, iLevel: Integer;
      iWriteEmpty: boolean = false); virtual;
    property Count: Integer read GetCount;
    property Duplicates: TDuplicates read GetDuplicates write SetDuplicates;
    property ItemList: TStringList read FItemList;
    property Names[index: Integer]: string read GetNames;
    property Objects[index: Integer]: TObject read GetObjects write SetObjects;
    property OwnsObjects: boolean read GetOwnsObjects write SetOwnsObjects;
    property Sorted: boolean read GetSorted write SetSorted;
    property Strings[index: Integer]: string read GetStrings write SetStrings; default;
    property Text: string read GetText write SetText;
  end;

  tJson2PumlBasePropertyList = class(tJson2PumlBaseList)
  protected
    function GetIsValid: boolean; override;
    function IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType, iConfigurationPropertyName: string;
      var oFoundCondition: string; iUseMatch: boolean = false; iSearchEmpyAsDefault: boolean = false): Integer;
  public
    constructor Create; override;
    function BuildFoundCondition (iConfigurationPropertyName, iConfiguredValue, iInputValue: string): string;
  end;

  tJson2PumlBaseObjectClass = class of tJson2PumlBaseObject;
  tJson2PumlBaseListClass = class of tJson2PumlBaseList;

implementation

uses
  System.SysUtils, System.IOUtils, json2pumltools, jsontools, System.Masks, System.Generics.Collections;

function tJson2PumlOutputFormatHelper.FileExtension (iLeadingSeparator: boolean = false): string;
begin
  Result := cJson2PumlOutputFormat[self];
  if not Result.IsEmpty and iLeadingSeparator then
    Result := tPath.ExtensionSeparatorChar + Result;
end;

function tJson2PumlOutputFormatHelper.FileName (const iFileName: string): string;
begin
  Result := ChangeFileExt (iFileName, self.FileExtension(true));
end;

procedure tJson2PumlOutputFormatHelper.FromString (aValue: string);
var
  dbot: tJson2PumlOutputFormat;
begin
  self := low(self);
  aValue := aValue.ToLower.Trim;
  for dbot := low(self) to high(self) do
    if aValue = dbot.ToString then
    begin
      self := dbot;
      exit;
    end;
end;

procedure tJson2PumlOutputFormatHelper.FromStringExtension (aValue: string);
var
  dbot: tJson2PumlOutputFormat;
begin
  self := low(self);
  aValue := aValue.ToLower.Trim.TrimLeft ([tPath.ExtensionSeparatorChar]);
  for dbot := low(self) to high(self) do
    if aValue = dbot.FileExtension then
    begin
      self := dbot;
      exit;
    end;
end;

function tJson2PumlOutputFormatHelper.IsPumlOutput: boolean;
begin
  Result := not self.PumlGenerateFlag.IsEmpty;
end;

function tJson2PumlOutputFormatHelper.PumlGenerateFlag: string;
begin
  Result := cJson2PumlOutputFormatFlag[self];
end;

function tJson2PumlOutputFormatHelper.ServiceResultName: string;
begin
  Result := cJson2PumlServiceResultName[self];
end;

function tJson2PumlOutputFormatHelper.ToString: string;
begin
  Result := cJson2PumlOutputFormat[self];
end;

procedure tJson2PumlOutputFormatsHelper.FromString (aValue: string; iPumlOutputOnly: boolean;
  iSupportOutPutAll: boolean);
var
  TempList: TStringList;
  S: string;
  f: tJson2PumlOutputFormat;
  allFound: boolean;
begin
  self := [];
  TempList := TStringList.Create;
  try
    TempList.LineBreak := ',';
    TempList.Text := aValue.ToLower;
    allFound := (S.IndexOf(cOpenOutputAll) >= 0) and iSupportOutPutAll;
    for S in TempList do
      for f := low(tJson2PumlOutputFormat) to high(tJson2PumlOutputFormat) do
        if ((S.Trim = f.ToString) or allFound) and (not iPumlOutputOnly or f.IsPumlOutput) then
          self := self + [f];
  finally
    TempList.Free;
  end;
end;

function tJson2PumlOutputFormatsHelper.ToString (iPumlOutputOnly: boolean): string;
var
  S: string;
  f: tJson2PumlOutputFormat;
begin
  S := '';
  for f in self do
    if (not iPumlOutputOnly or f.IsPumlOutput) then
      S := string.Join (',', [S, f.ToString]);
  Result := S.TrimLeft ([',']);
end;

procedure tJson2PumlCharacteristicTypeHelper.FromString (aValue: string);
var
  dbot: tJson2PumlCharacteristicType;
begin
  self := jctList;
  aValue := aValue.ToLower.Trim;
  for dbot := low(self) to high(self) do
    if aValue = dbot.ToString then
    begin
      self := dbot;
      exit;
    end;
end;

function tJson2PumlCharacteristicTypeHelper.ToString: string;
begin
  Result := cJson2PumlCharacteristicType[self];
end;

procedure tJson2PumlListOperationHelper.FromString (aValue: string);
var
  dbot: tJson2PumlListOperation;
begin
  self := jloMerge;
  aValue := aValue.ToLower.Trim;
  for dbot := low(self) to high(self) do
    if aValue = dbot.ToString.ToLower then
    begin
      self := dbot;
      exit;
    end;
end;

function tJson2PumlListOperationHelper.ToString: string;
begin
  Result := cJson2PumlListHandlingMode[self];
end;

constructor tJson2PumlBaseObject.Create;
begin
  inherited;
end;

procedure tJson2PumlBaseObject.Assign (Source: tPersistent);
begin
  if Source is tJson2PumlBaseObject then
  begin
    SourceFileName := tJson2PumlBaseObject (Source).SourceFileName;
  end;
end;

procedure tJson2PumlBaseObject.Clear;
begin
end;

function tJson2PumlBaseObject.Clone: tJson2PumlBaseObject;
begin
  Result := tJson2PumlBaseObjectClass (self.ClassType).Create;
  Result.Assign (self);
end;

function tJson2PumlBaseObject.GetFileNameExpanded (iFileName: string): string;
begin
  if not iFileName.IsEmpty then
    Result := PathCombineIfRelative (SourceFileNamePath, iFileName)
  else
    Result := iFileName;
end;

function tJson2PumlBaseObject.GetIsFilled: boolean;
begin
  Result := true;
end;

function tJson2PumlBaseObject.GetIsValid: boolean;
begin
  Result := IsFilled;
end;

function tJson2PumlBaseObject.JsonAttributeValue (iPropertyName, iValue: string; iValueQuotes: boolean = true): string;
begin
  Result := '';
  if iPropertyName.IsEmpty or iValue.IsEmpty then
    exit;
  Result := Format ('%s, ', [JsonPropertyNameValue(iPropertyName, iValue, iValueQuotes)]);
end;

function tJson2PumlBaseObject.JsonAttributeValueList (iPropertyName: string; iValueList: TStringList): string;
var
  i: Integer;
begin
  Result := '';
  if iPropertyName.IsEmpty or (iValueList.Count <= 0) then
    exit;
  if iValueList.Count = 1 then
    Result := JsonAttributeValue (iPropertyName, iValueList[0])
  else
  begin
    for i := 0 to iValueList.Count - 1 do
      Result := Format ('%s, "%s"', [Result, ClearJsonPropertyValue(iValueList[i])]);
    Result := Format ('"%s": [%s],', [iPropertyName, Result.TrimLeft([' ', ','])]);
  end;
end;

function tJson2PumlBaseObject.MergeValue (iValue, iNewValue: string): string;
begin
  if not iNewValue.IsEmpty then
    Result := iNewValue
  else
    Result := iValue;
end;

procedure tJson2PumlBaseObject.MergeWith (iMergeDefinition: tJson2PumlBaseObject);
begin
  self.Assign (iMergeDefinition);
end;

function tJson2PumlBaseObject.ReadFromJson (iJson, iFileName: string): boolean;
var
  JsonValue: TJSONValue;
begin
  Result := false;
  Clear;
  if iJson.IsEmpty then
    exit;
  JsonValue := TJSONObject.ParseJSONValue (iJson) as TJSONValue;
  if Assigned (JsonValue) then
    try
      SourceFileName := iFileName;
      Result := ReadFromJson (JsonValue, '');
    finally
      JsonValue.Free;
    end;
end;

function tJson2PumlBaseObject.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
begin
  Result := false;
end;

function tJson2PumlBaseObject.ReadFromJsonFile (iFileName: string): boolean;
var
  Lines: TStringList;
begin
  Result := false;
  Clear;
  if not FileExists (iFileName) then
    exit;
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile (iFileName);
    Result := ReadFromJson (Lines.Text, iFileName);
  finally
    Lines.Free;
  end;
end;

function tJson2PumlBaseObject.SaveToFile (iJsonLines: TStrings; iFileName: string;
  iWriteEmpty: boolean = false): boolean;
begin
  Result := ReadFromJson (iJsonLines.Text, SourceFileName);
  if Result then
  begin
    TFile.copy (iFileName, iFileName + '.bak', true);
    WriteToJsonFile (iFileName, iWriteEmpty);
    iJsonLines.LoadFromFile (iFileName);
    SourceFileName := iFileName;
  end;
end;

procedure tJson2PumlBaseObject.SetSourceFileName (const Value: string);
begin
  FSourceFileName := Value;
  FSourceFileNamePath := ExtractFilePath (FSourceFileName);
end;

procedure tJson2PumlBaseObject.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
begin

end;

procedure tJson2PumlBaseObject.WriteToJsonFile (iFileName: string; iWriteEmpty: boolean = false);
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  try
    WriteToJson (TempList, '', 0, iWriteEmpty);
    TempList.SaveToFile (iFileName);
  finally
    TempList.Free;
  end;
end;

constructor tJson2PumlBaseList.Create;
begin
  inherited Create;
  FItemList := TStringList.Create ();
  FItemList.OwnsObjects := true;
end;

destructor tJson2PumlBaseList.Destroy;
begin
  FItemList.Free;
  inherited Destroy;
end;

procedure tJson2PumlBaseList.AddBaseObject (iBaseObject: tJson2PumlBaseObject);
begin
  if Assigned (iBaseObject) then
    if iBaseObject.IsValid then
      AddObject (iBaseObject.Ident, iBaseObject)
    else
      iBaseObject.Free;
end;

function tJson2PumlBaseList.AddObject (const S: string; AObject: TObject): Integer;
begin
  Result := ItemList.AddObject (S, AObject);
end;

procedure tJson2PumlBaseList.Assign (Source: tPersistent);
var
  i: Integer;
begin
  inherited Assign (Source);
  if Source is tJson2PumlBaseList then
    if not OwnsObjects then
      ItemList.Assign (tJson2PumlBaseList(Source).ItemList)
    else
    begin
      for i := 0 to tJson2PumlBaseList(Source).Count - 1 do
      begin
        if Assigned (tJson2PumlBaseList(Source).BaseObject[i]) then
          AddObject (tJson2PumlBaseList(Source)[i], tJson2PumlBaseList(Source).BaseObject[i].Clone)
        else
          AddObject (tJson2PumlBaseList(Source)[i], tJson2PumlBaseList(Source).ItemList.Objects[i]);
      end;
    end;
end;

procedure tJson2PumlBaseList.Clear;
begin
  ItemList.Clear;
  inherited Clear;
end;

function tJson2PumlBaseList.CreateListValueObject: tJson2PumlBaseObject;
begin
  Result := nil;
end;

procedure tJson2PumlBaseList.Delete (Index: Integer);
begin
  ItemList.Delete (index);
end;

function tJson2PumlBaseList.GetBaseObject (Index: Integer): tJson2PumlBaseObject;
var
  obj: TObject;
begin
  obj := ItemList.Objects[index];
  if Assigned (obj) and (obj is tJson2PumlBaseObject) then
    Result := tJson2PumlBaseObject (obj)
  else
    Result := nil;
end;

function tJson2PumlBaseList.GetCount: Integer;
begin
  Result := ItemList.Count;
end;

function tJson2PumlBaseList.GetDuplicates: TDuplicates;
begin
  Result := ItemList.Duplicates;
end;

function tJson2PumlBaseList.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlBaseList.GetIsFilled: boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
    if Assigned (BaseObject[i]) then
      if BaseObject[i].IsFilled then
      begin
        Result := true;
        exit;
      end;
end;

function tJson2PumlBaseList.GetNames (Index: Integer): string;
begin
  Result := ItemList.Names[index];
end;

function tJson2PumlBaseList.GetObjects (Index: Integer): TObject;
begin
  Result := ItemList.Objects[index];
end;

function tJson2PumlBaseList.GetOwnsObjects: boolean;
begin
  Result := ItemList.OwnsObjects;
end;

function tJson2PumlBaseList.GetSorted: boolean;
begin
  Result := ItemList.Sorted;
end;

function tJson2PumlBaseList.GetStrings (Index: Integer): string;
begin
  Result := ItemList[index];
end;

function tJson2PumlBaseList.GetText: string;
begin
  Result := ItemList.Text;
end;

function tJson2PumlBaseList.GetValueFromIndex (Index: Integer): string;
begin
  Result := ItemList.ValueFromIndex[index];
end;

function tJson2PumlBaseList.IndexOf (S: string): Integer;
begin
  Result := ItemList.IndexOf (S);
end;

function tJson2PumlBaseList.IndexOfName (S: string): Integer;
begin
  Result := ItemList.IndexOfName (S);
end;

function tJson2PumlBaseList.ReadFromJson (iJsonValue: TJSONValue; iPropertyName: string): boolean;
var
  JsonValue: TJSONValue;
  JsonArray: TJSONArray;
  Value: string;
  i: Integer;
begin
  Result := false;
  Clear;
  if not Assigned (iJsonValue) then
    exit;
  if iJsonValue is TJSONArray then
    JsonValue := TJSONArray (iJsonValue)
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
      Value := '';
      JsonValue := JsonArray.Items[i];
      ReadListValueFromJson (JsonValue);
    end;
  end
  else
    ReadListValueFromJson (JsonValue);
end;

procedure tJson2PumlBaseList.ReadListValueFromJson (iJsonValue: TJSONValue);
var
  Value: string;
  ListValueObject: tJson2PumlBaseObject;
begin
  ListValueObject := CreateListValueObject;
  if Assigned (ListValueObject) then
  begin
    if ListValueObject.ReadFromJson (iJsonValue, '') then
      AddBaseObject (ListValueObject)
    else
      ListValueObject.Free;
  end
  else if iJsonValue is TJSONString then
  begin
    Value := TJSONString (iJsonValue).Value;
    if (Value.IsEmpty) then
      exit;
    ItemList.add (Value);
  end
end;

procedure tJson2PumlBaseList.SetDuplicates (const Value: TDuplicates);
begin
  ItemList.Duplicates := Value;
end;

procedure tJson2PumlBaseList.SetObjects (Index: Integer; const Value: TObject);
begin
  ItemList.Objects[index] := Value;
end;

procedure tJson2PumlBaseList.SetOwnsObjects (const Value: boolean);
begin
  ItemList.OwnsObjects := Value;
end;

procedure tJson2PumlBaseList.SetSorted (const Value: boolean);
begin
  ItemList.Sorted := Value;
end;

procedure tJson2PumlBaseList.SetSourceFileName (const Value: string);
var
  i: Integer;
begin
  inherited SetSourceFileName (Value);
  for i := 0 to Count - 1 do
    if Assigned (BaseObject[i]) then
      BaseObject[i].SourceFileName := SourceFileName;
end;

procedure tJson2PumlBaseList.SetStrings (Index: Integer; const Value: string);
begin
  ItemList[index] := Value;
end;

procedure tJson2PumlBaseList.SetText (const Value: string);
begin
  ItemList.Text := Value;
end;

procedure tJson2PumlBaseList.Sort;
begin
  ItemList.Sort;
end;

procedure tJson2PumlBaseList.WriteToJson (oJsonOutPut: TStrings; iPropertyName: string; iLevel: Integer;
  iWriteEmpty: boolean = false);
var
  i: Integer;
begin
  if (Count <= 0) and not iWriteEmpty then
    exit;
  WriteArrayStartToJson (oJsonOutPut, iLevel, iPropertyName);
  for i := 0 to Count - 1 do
    WriteToJsonItem (oJsonOutPut, '', i, iLevel + 1, iWriteEmpty);
  WriteArrayEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlBaseList.WriteToJsonItem (oJsonOutPut: TStrings; iPropertyName: string; iIndex, iLevel: Integer;
  iWriteEmpty: boolean = false);
begin
  if Assigned (BaseObject[iIndex]) then
    BaseObject[iIndex].WriteToJson (oJsonOutPut, iPropertyName, iLevel + 1, iWriteEmpty)
  else
    oJsonOutPut.add (Format('%s%s"%s",', [JsonLinePrefix(iLevel + 1), JsonPropertyName(iPropertyName),
      ClearJsonPropertyValue(self[iIndex])]));
end;

constructor tJson2PumlBasePropertyList.Create;
begin
  inherited Create;
  OwnsObjects := true;
end;

function tJson2PumlBasePropertyList.BuildFoundCondition (iConfigurationPropertyName, iConfiguredValue,
  iInputValue: string): string;
begin
  if iInputValue.IsEmpty then
    Result := Format ('- ["%s" : Configured "%s"]', [iConfigurationPropertyName, iConfiguredValue])
  else if iConfiguredValue.IsEmpty then
    Result := Format ('- ["%s" : Not found "%s"]', [iConfigurationPropertyName, iInputValue])
  else
    Result := Format ('- ["%s" : Configured "%s" : Input "%s"]', [iConfigurationPropertyName, iConfiguredValue,
      iInputValue]);
end;

function tJson2PumlBasePropertyList.IndexOfProperty (iPropertyName, iParentPropertyName, iParentObjectType,
  iConfigurationPropertyName: string; var oFoundCondition: string; iUseMatch: boolean = false;
  iSearchEmpyAsDefault: boolean = false): Integer;

var
  PropertyIndex: Integer;

  function found: boolean;
  begin
    Result := PropertyIndex >= 0;
  end;

  procedure DirectSearch (iValue: string);
  begin
    if not found then
      PropertyIndex := IndexOfName (iValue);
    if not found then
      PropertyIndex := IndexOf (iValue);
    if found then
      oFoundCondition := iValue;
  end;
  procedure MatchSearch (iValue: string);
  var
    i: Integer;
    S: string;
  begin
    if found then
      exit;
    for i := 0 to Count - 1 do
    begin
      S := Names[i];
      if S.IsEmpty then
        S := ItemList[i];
      if MatchesMask (iValue, S) then
        PropertyIndex := i;
      if found then
        break;
    end;
    if found then
      oFoundCondition := iValue;
  end;

begin
  Result := - 1;
  PropertyIndex := - 1;
  if iPropertyName.IsEmpty then
    exit;
  DirectSearch (iPropertyName);
  if not found and not iParentPropertyName.IsEmpty then
    DirectSearch (iParentPropertyName + '.' + iPropertyName);
  if not found and not iParentObjectType.IsEmpty then
    DirectSearch (iParentObjectType + '.' + iPropertyName);
  if not found and iUseMatch then
  begin
    MatchSearch (iPropertyName);
    if not found and not iParentPropertyName.IsEmpty then
      MatchSearch (iParentPropertyName + '.' + iPropertyName);
    if not found and not iParentObjectType.IsEmpty then
      MatchSearch (iParentObjectType + '.' + iPropertyName);
  end;
  if not found and iSearchEmpyAsDefault then
  begin
    oFoundCondition := '<default>';
    PropertyIndex := IndexOf ('');
    if found then
      oFoundCondition := BuildFoundCondition (iConfigurationPropertyName, oFoundCondition, '');
  end
  else if found then
    oFoundCondition := BuildFoundCondition (iConfigurationPropertyName, self[PropertyIndex], oFoundCondition)
  else if not iParentObjectType.IsEmpty then
    oFoundCondition := BuildFoundCondition (iConfigurationPropertyName, '', iParentObjectType + '.' + iPropertyName)
  else if not iParentPropertyName.IsEmpty then
    oFoundCondition := BuildFoundCondition (iConfigurationPropertyName, '', iParentPropertyName + '.' + iPropertyName)
  else
    oFoundCondition := BuildFoundCondition (iConfigurationPropertyName, '', iPropertyName);
  Result := PropertyIndex;
end;

function tJson2PumlBasePropertyList.GetIsValid: boolean;
var
  i: Integer;
begin
  Result := true;
  if Result then
    for i := 0 to Count - 1 do
      if Assigned (BaseObject[i]) then
      begin
        Result := Result and BaseObject[i].IsValid;
        if not Result then
          exit;
      end;
end;

procedure tJson2PumlFileNameReplaceHelper.FromString (aValue: string);
var
  dbot: tJson2PumlFileNameReplace;
begin
  self := low(self);
  aValue := aValue.ToLower.Trim;
  for dbot := low(self) to high(self) do
    if aValue = dbot.ToString.ToLower then
    begin
      self := dbot;
      exit;
    end;
end;

function tJson2PumlFileNameReplaceHelper.ToString: string;
begin
  Result := cJson2PumlFileNameReplace[self];
end;

function tJson2PumlApplicationTypeHelper.ApplicationName: string;
begin
  Result := cJson2PumlApplicationTypeName[self];
end;

function tJson2PumlErrorTypeHelper.Errorcode: string;
begin
  Result := cJson2PumlErrorInformation[self].Errorcode;
end;

function tJson2PumlErrorTypeHelper.ErrorDescription: string;
begin
  Result := cJson2PumlErrorInformation[self].ErrorDescription;
end;

function tJson2PumlErrorTypeHelper.ErrorMessage: string;
begin
  Result := cJson2PumlErrorInformation[self].ErrorMessage;
end;

function tJson2PumlErrorTypeHelper.EventType: TEventType;
begin
  Result := cJson2PumlErrorInformation[self].EventType;
end;

function tJson2PumlErrorTypeHelper.Failed: boolean;
begin
  Result := cJson2PumlErrorInformation[self].EventType in [etError, etCritical, etException];
end;

function tJson2PumlErrorTypeHelper.HttpStatusCode: Integer;
begin
  Result := cJson2PumlErrorInformation[self].HttpStatusCode;
end;

procedure tJson2PumlErrorTypeHelper.RenderErrorResponse (oJson: TStringList; iLevel: Integer;
  iErrorMessage: string = '');
begin
  if Errorcode.IsEmpty then
    exit;
  WriteObjectStartToJson (oJson, iLevel, '');
  WriteToJsonValue (oJson, 'errorCode', Errorcode, iLevel + 1, false);
  WriteToJsonValue (oJson, 'errorClass', JSON2PUML_EVENTTYPENAMES[Integer(EventType)], iLevel + 1, false);
  if iErrorMessage.IsEmpty then
    WriteToJsonValue (oJson, 'message', ErrorMessage, iLevel + 1, false)
  else
    WriteToJsonValue (oJson, 'message', iErrorMessage, iLevel + 1, false);
  WriteToJsonValue (oJson, 'description', ErrorDescription, iLevel + 1, false);
  WriteObjectEndToJson (oJson, iLevel);
end;

end.
