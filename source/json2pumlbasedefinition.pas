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

uses
  System.JSON, System.Classes, json2pumlconst, Quick.Logger;

type
  tJson2PumlPropertySearchMatchType = (psmExactExactPlus, psmExactPlus, psmExactExact, psmExact, psmMatchMatchPlus,
    psmMatchPlus, psmMatchMatch, psmMatch, psmExcludeExclude, psmExclude, psmNoMatch);

  tJson2PumlNotifyChangeType = (nctUndefined, nctExpand, nctConvert, nctGenerate);

  tJson2PumlCalculateOutputFilenameEvent = function(iFileName, iSourceFileName: string; iNewFileExtension: string = '')
    : string of object;
  tJson2PumlNotifyChangeEvent = procedure(Sender: tObject; ChangeType: tJson2PumlNotifyChangeType;
    ProgressValue, ProgressMaxValue: integer; ProgressInfo: string = '') of object;

  tJson2PumlOutputFormatHelper = record helper for tJson2PumlOutputFormat
    function FileExtension (iLeadingSeparator: boolean = false): string;
    procedure FromString (aValue: string);
    procedure FromStringExtension (aValue: string);
    function IsPumlOutput: boolean;
    function IsBinaryOutput: boolean;
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
    function EventType: tEventType;
    function Failed: boolean;
    function HttpStatusCode: integer;
    procedure RenderErrorResponse (oJson: tStrings; iLevel: integer; iErrorMessage: string = '');
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
    function JsonAttributeValueList (iPropertyName: string; iValueList: tStringList): string;
    function MergeValue (iValue, iNewValue: string): string;
    procedure SetSourceFileName (const Value: string); virtual;
  public
    constructor Create; virtual;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; virtual;
    function Clone: tJson2PumlBaseObject; virtual;
    procedure MergeWith (iMergeDefinition: tJson2PumlBaseObject); virtual;
    function ReadFromJson (iJson, iFileName: string): boolean; overload; virtual;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; overload; virtual;
    function ReadFromJsonFile (iFileName: string): boolean; virtual;
    function SaveToFile (iJsonLines: tStrings; iFileName: string; iWriteEmpty: boolean = false): boolean;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
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
    FItemList: tStringList;
    function GetBaseObject (Index: integer): tJson2PumlBaseObject;
    function GetCount: integer;
    function GetDuplicates: tDuplicates;
    function GetNames (Index: integer): string;
    function GetObjects (Index: integer): tObject;
    function GetOwnsObjects: boolean;
    function GetSorted: boolean;
    function GetStrings (Index: integer): string;
    function GetText: string;
    function GetValueFromIndex (Index: integer): string;
    procedure SetDuplicates (const Value: tDuplicates);
    procedure SetObjects (Index: integer; const Value: tObject);
    procedure SetOwnsObjects (const Value: boolean);
    procedure SetSorted (const Value: boolean);
    procedure SetStrings (Index: integer; const Value: string);
    procedure SetText (const Value: string);
  protected
    function CreateListValueObject: tJson2PumlBaseObject; virtual;
    function GetIdent: string; override;
    function GetIsFilled: boolean; override;
    procedure ReadListValueFromJson (iJsonValue: tJSONValue); virtual;
    procedure SetSourceFileName (const Value: string); override;
    property BaseObject[index: integer]: tJson2PumlBaseObject read GetBaseObject;
    property ValueFromIndex[index: integer]: string read GetValueFromIndex;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddBaseObject (iBaseObject: tJson2PumlBaseObject);
    function AddObject (const S: string; AObject: tObject): integer;
    procedure Assign (Source: tPersistent); override;
    procedure Clear; override;
    procedure Delete (Index: integer);
    function IndexOf (S: string): integer;
    function IndexOfName (S: string): integer;
    function ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean; overload; override;
    procedure Sort;
    procedure WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
      iWriteEmpty: boolean = false); override;
    procedure WriteToJsonItem (oJsonOutPut: tStrings; iPropertyName: string; iIndex, iLevel: integer;
      iWriteEmpty: boolean = false); virtual;
    property Count: integer read GetCount;
    property Duplicates: tDuplicates read GetDuplicates write SetDuplicates;
    property ItemList: tStringList read FItemList;
    property Names[index: integer]: string read GetNames;
    property Objects[index: integer]: tObject read GetObjects write SetObjects;
    property OwnsObjects: boolean read GetOwnsObjects write SetOwnsObjects;
    property Sorted: boolean read GetSorted write SetSorted;
    property Strings[index: integer]: string read GetStrings write SetStrings; default;
    property Text: string read GetText write SetText;
  end;

  tJson2PumlBasePropertyListEntry = class(tObject)
  private
    FFoundCondition: string;
    FPropertyIndex: integer;
  protected
  public
    constructor Create;
    property FoundCondition: string read FFoundCondition write FFoundCondition;
    property PropertyIndex: integer read FPropertyIndex write FPropertyIndex default - 1;
  end;

  tJson2PumlBasePropertyListCache = class(tObject)
  private
    FCacheList: tStringList;
  protected
    property CacheList: tStringList read FCacheList;
    function CacheName (const iPropertyName, iParentPropertyName, iParentObjectType: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetCache (const iPropertyName, iParentPropertyName, iParentObjectType: string; var oFoundCondition: string;
      var oPropertyIndex: integer): boolean;
    procedure AddCache (const iPropertyName, iParentPropertyName, iParentObjectType, iFoundCondition: string;
      iPropertyIndex: integer);
  end;

  tJson2PumlBasePropertyList = class(tJson2PumlBaseList)
  private
    FConfigurationPropertyName: string;
    FPropertyCache: tJson2PumlBasePropertyListCache;
    FSearchEmpyAsDefault: boolean;
    FUseMatch: boolean;
    procedure SetSearchEmpyAsDefault (const Value: boolean);
  protected
    function GetIsValid: boolean; override;
    procedure OnPropertyListChange (Sender: tObject);
    property PropertyCache: tJson2PumlBasePropertyListCache read FPropertyCache;
  public
    constructor Create; override;
    destructor Destroy; override;
    function BuildFoundCondition (iMatchType: tJson2PumlPropertySearchMatchType;
      const iConfigurationPropertyName, iConfiguredValue, iSearchValue: string): string;
    procedure Clear; override;
    function IndexOfProperty (const iPropertyName, iParentPropertyName, iParentObjectType: string;
      var oFoundCondition: string): integer;
    property ConfigurationPropertyName: string read FConfigurationPropertyName write FConfigurationPropertyName;
    property SearchEmpyAsDefault: boolean read FSearchEmpyAsDefault write SetSearchEmpyAsDefault default false;
    property UseMatch: boolean read FUseMatch write FUseMatch default false;
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

function tJson2PumlOutputFormatHelper.IsBinaryOutput: boolean;
begin
  Result := self in [jofPNG, jofSVG, jofPDF, jofZip];
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
  TempList: tStringList;
  S: string;
  f: tJson2PumlOutputFormat;
  allFound: boolean;
begin
  self := [];
  TempList := tStringList.Create;
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
    Clear;
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

function tJson2PumlBaseObject.JsonAttributeValueList (iPropertyName: string; iValueList: tStringList): string;
var
  i: integer;
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
  JsonValue: tJSONValue;
begin
  Result := false;
  Clear;
  if iJson.IsEmpty then
    exit;
  JsonValue := tJSONObject.ParseJSONValue (iJson) as tJSONValue;
  if Assigned (JsonValue) then
    try
      SourceFileName := iFileName;
      Result := ReadFromJson (JsonValue, '');
    finally
      JsonValue.Free;
    end;
end;

function tJson2PumlBaseObject.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
begin
  Result := false;
end;

function tJson2PumlBaseObject.ReadFromJsonFile (iFileName: string): boolean;
var
  Lines: tStringList;
begin
  Result := false;
  Clear;
  if not FileExists (iFileName) then
    exit;
  Lines := tStringList.Create;
  try
    Lines.LoadFromFile (iFileName);
    Result := ReadFromJson (Lines.Text, iFileName);
  finally
    Lines.Free;
  end;
end;

function tJson2PumlBaseObject.SaveToFile (iJsonLines: tStrings; iFileName: string;
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

procedure tJson2PumlBaseObject.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin

end;

procedure tJson2PumlBaseObject.WriteToJsonFile (iFileName: string; iWriteEmpty: boolean = false);
var
  TempList: tStringList;
begin
  TempList := tStringList.Create;
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
  FItemList := tStringList.Create ();
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

function tJson2PumlBaseList.AddObject (const S: string; AObject: tObject): integer;
begin
  Result := ItemList.AddObject (S, AObject);
end;

procedure tJson2PumlBaseList.Assign (Source: tPersistent);
var
  i: integer;
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

procedure tJson2PumlBaseList.Delete (Index: integer);
begin
  ItemList.Delete (index);
end;

function tJson2PumlBaseList.GetBaseObject (Index: integer): tJson2PumlBaseObject;
var
  obj: tObject;
begin
  obj := ItemList.Objects[index];
  if Assigned (obj) and (obj is tJson2PumlBaseObject) then
    Result := tJson2PumlBaseObject (obj)
  else
    Result := nil;
end;

function tJson2PumlBaseList.GetCount: integer;
begin
  Result := ItemList.Count;
end;

function tJson2PumlBaseList.GetDuplicates: tDuplicates;
begin
  Result := ItemList.Duplicates;
end;

function tJson2PumlBaseList.GetIdent: string;
begin
  Result := '';
end;

function tJson2PumlBaseList.GetIsFilled: boolean;
var
  i: integer;
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

function tJson2PumlBaseList.GetNames (Index: integer): string;
begin
  Result := ItemList.Names[index];
end;

function tJson2PumlBaseList.GetObjects (Index: integer): tObject;
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

function tJson2PumlBaseList.GetStrings (Index: integer): string;
begin
  Result := ItemList[index];
end;

function tJson2PumlBaseList.GetText: string;
begin
  Result := ItemList.Text;
end;

function tJson2PumlBaseList.GetValueFromIndex (Index: integer): string;
begin
  Result := ItemList.ValueFromIndex[index];
end;

function tJson2PumlBaseList.IndexOf (S: string): integer;
begin
  Result := ItemList.IndexOf (S);
end;

function tJson2PumlBaseList.IndexOfName (S: string): integer;
begin
  Result := ItemList.IndexOfName (S);
end;

function tJson2PumlBaseList.ReadFromJson (iJsonValue: tJSONValue; iPropertyName: string): boolean;
var
  JsonValue: tJSONValue;
  JsonArray: tJSONArray;
  Value: string;
  i: integer;
begin
  Result := false;
  Clear;
  if not Assigned (iJsonValue) then
    exit;
  if iJsonValue is tJSONArray then
    JsonValue := tJSONArray (iJsonValue)
  else if iJsonValue is tJSONObject then
    JsonValue := tJSONObject (iJsonValue).Values[iPropertyName]
  else
    exit;
  if not Assigned (JsonValue) then
    exit;
  Result := true;
  if JsonValue is tJSONArray then
  begin
    JsonArray := tJSONArray (JsonValue);
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

procedure tJson2PumlBaseList.ReadListValueFromJson (iJsonValue: tJSONValue);
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
  else if iJsonValue is tJSONString then
  begin
    Value := tJSONString (iJsonValue).Value;
    if (Value.IsEmpty) then
      exit;
    ItemList.add (Value);
  end
end;

procedure tJson2PumlBaseList.SetDuplicates (const Value: tDuplicates);
begin
  ItemList.Duplicates := Value;
end;

procedure tJson2PumlBaseList.SetObjects (Index: integer; const Value: tObject);
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
  i: integer;
begin
  inherited SetSourceFileName (Value);
  for i := 0 to Count - 1 do
    if Assigned (BaseObject[i]) then
      BaseObject[i].SourceFileName := SourceFileName;
end;

procedure tJson2PumlBaseList.SetStrings (Index: integer; const Value: string);
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

procedure tJson2PumlBaseList.WriteToJson (oJsonOutPut: tStrings; iPropertyName: string; iLevel: integer;
  iWriteEmpty: boolean = false);
var
  i: integer;
begin
  if (Count <= 0) and not iWriteEmpty then
    exit;
  WriteArrayStartToJson (oJsonOutPut, iLevel, iPropertyName);
  for i := 0 to Count - 1 do
    WriteToJsonItem (oJsonOutPut, '', i, iLevel, iWriteEmpty);
  WriteArrayEndToJson (oJsonOutPut, iLevel);
end;

procedure tJson2PumlBaseList.WriteToJsonItem (oJsonOutPut: tStrings; iPropertyName: string; iIndex, iLevel: integer;
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
  FUseMatch := true;
  FSearchEmpyAsDefault := false;
  FPropertyCache := tJson2PumlBasePropertyListCache.Create ();
  ItemList.OnChange := OnPropertyListChange;
end;

destructor tJson2PumlBasePropertyList.Destroy;
begin
  FPropertyCache.Free;
  inherited Destroy;
end;

function tJson2PumlBasePropertyList.BuildFoundCondition (iMatchType: tJson2PumlPropertySearchMatchType;
  const iConfigurationPropertyName, iConfiguredValue, iSearchValue: string): string;
begin
  case iMatchType of
    psmExactExactPlus, psmExactPlus, psmExactExact, psmExact:
      Result := Format ('- ["%s" : Exact Match : Configured "%s" : Search "%s"]',
        [iConfigurationPropertyName, iConfiguredValue, iSearchValue]);
    psmMatchMatchPlus, psmMatchPlus, psmMatchMatch, psmMatch:
      Result := Format ('- ["%s" : Wildcard match : Configured "%s" : Search "%s"]',
        [iConfigurationPropertyName, iConfiguredValue, iSearchValue]);
    psmExcludeExclude, psmExclude:
      Result := Format ('- ["%s" : Excluded : Configured "%s" : Search "%s"]',
        [iConfigurationPropertyName, iConfiguredValue, iSearchValue]);
    psmNoMatch:
      Result := Format ('- ["%s" : Not found "%s"]', [iConfigurationPropertyName, iSearchValue])
  end;
end;

procedure tJson2PumlBasePropertyList.Clear;
begin
  inherited Clear;
  PropertyCache.Clear;
end;

function tJson2PumlBasePropertyList.IndexOfProperty (const iPropertyName, iParentPropertyName,
  iParentObjectType: string; var oFoundCondition: string): integer;

var
  PropertyIndex: integer;
  ExcludeType: tJson2PumlPropertySearchMatchType;
  ExcludeIndex: integer;
  ParentPropertyName, ParentName: string;
  CurrentMatchType, OverallMatchType: tJson2PumlPropertySearchMatchType;
  ParentFilled: boolean;
  i: integer;

  function ListValue (iIndex: integer): string;
  begin
    Result := Names[iIndex];
    if Result.IsEmpty then
      Result := ItemList[iIndex];
  end;

  function CalculateMatchType (iIndex: integer): tJson2PumlPropertySearchMatchType;
  var
    IndexName: string;
    IndexPropertyName: string;
    IndexParentName: string;
    Splitted: tArray<string>;
  begin
    Result := psmNoMatch;
    IndexName := ListValue (iIndex);
    if ParentFilled and (IndexName = ParentPropertyName) then
      Result := psmExactExact
    else if ParentFilled and (IndexName = '+' + ParentPropertyName) then
      Result := psmExactExactPlus
    else if IndexName = iPropertyName then
      Result := psmExact
    else if IndexName = '+' + iPropertyName then
      Result := psmExactPlus
    else if UseMatch then
      if MatchesMask (iPropertyName, IndexName) then
        Result := psmMatch
      else if MatchesMask ('+' + iPropertyName, IndexName) then
        Result := psmMatchPlus
      else if MatchesMask ('-' + iPropertyName, IndexName) then
        Result := psmExclude
      else if ParentFilled then
      begin
        Splitted := IndexName.Split (['.'], 2, TStringSplitOptions.None);
        if Length (Splitted) > 1 then
        begin
          IndexPropertyName := Splitted[1];
          IndexParentName := Splitted[0];
          if MatchesMask (ParentName, IndexParentName) and MatchesMask (iPropertyName, IndexPropertyName) then
            Result := psmMatchMatch
          else if MatchesMask ('+' + ParentName, IndexParentName) and MatchesMask (iPropertyName, IndexPropertyName)
          then
            Result := psmMatchMatchPlus
          else if MatchesMask ('-' + ParentName, IndexParentName) and MatchesMask (iPropertyName, IndexPropertyName)
          then
            Result := psmExcludeExclude
        end;
      end;
  end;

  function found: boolean;
  begin
    Result := (PropertyIndex > - 1) and (ExcludeIndex < 0)
  end;

begin
  ExcludeType := psmNoMatch;
  ExcludeIndex := - 1;
  oFoundCondition := '';

  Result := - 1;
  PropertyIndex := - 1;
  if iPropertyName.IsEmpty then
    exit;

  if PropertyCache.GetCache (iPropertyName, iParentPropertyName, iParentObjectType, oFoundCondition, PropertyIndex) then
  begin
    Result := PropertyIndex;
    exit;
  end;

  try
    if not iParentPropertyName.IsEmpty then
      ParentName := iParentPropertyName
    else if not iParentObjectType.IsEmpty then
      ParentName := iParentObjectType
    else
      ParentName := '';
    ParentFilled := not ParentName.IsEmpty;
    ParentPropertyName := ParentName + '.' + iPropertyName;
    OverallMatchType := psmNoMatch;
    for i := 0 to Count - 1 do
    begin
      CurrentMatchType := CalculateMatchType (i);
      case CurrentMatchType of
        psmExactExactPlus, psmExactPlus, psmExactExact, psmExact, psmMatchMatchPlus, psmMatchPlus,
          psmMatchMatch, psmMatch:
          begin
            if CurrentMatchType < OverallMatchType then
            begin
              OverallMatchType := CurrentMatchType;
              PropertyIndex := i;
              oFoundCondition := ListValue (i);
            end;
          end;
        psmExcludeExclude, psmExclude:
          begin
            ExcludeType := CurrentMatchType;
            ExcludeIndex := i;
          end;
        psmNoMatch:
          ;
      end;
      if OverallMatchType in [psmExactExact] then
        break;
    end;

    if (OverallMatchType in [psmExactExact, psmExact, psmMatchMatch, psmMatch]) and (ExcludeType <> psmNoMatch) then
    begin
      OverallMatchType := ExcludeType;
      PropertyIndex := - 1;
    end;

    if not found and SearchEmpyAsDefault then
    begin
      oFoundCondition := '<default>';
      PropertyIndex := IndexOf ('');
      if found then
        oFoundCondition := BuildFoundCondition (psmExact, ConfigurationPropertyName, oFoundCondition, '')
      else
        oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, '', ParentPropertyName);
    end
    else
      case OverallMatchType of
        psmExactExactPlus, psmExactExact, psmMatchMatchPlus, psmMatchMatch:
          oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, ListValue(PropertyIndex),
            ParentPropertyName);
        psmExactPlus, psmExact, psmMatchPlus, psmMatch:
          oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, ListValue(PropertyIndex),
            iPropertyName);
        psmExcludeExclude:
          oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, ListValue(ExcludeIndex),
            ParentName);
        psmExclude:
          oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, ListValue(ExcludeIndex),
            iPropertyName);
        psmNoMatch:
          if ParentFilled then
            oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, '', iPropertyName)
          else
            oFoundCondition := BuildFoundCondition (OverallMatchType, ConfigurationPropertyName, '',
              ParentPropertyName);
      end;
    Result := PropertyIndex;
  finally
    PropertyCache.AddCache (iPropertyName, iParentPropertyName, iParentObjectType, oFoundCondition, Result);
  end;
end;

function tJson2PumlBasePropertyList.GetIsValid: boolean;
var
  i: integer;
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

procedure tJson2PumlBasePropertyList.OnPropertyListChange (Sender: tObject);
begin
  PropertyCache.Clear;
end;

procedure tJson2PumlBasePropertyList.SetSearchEmpyAsDefault (const Value: boolean);
begin
  FSearchEmpyAsDefault := Value;
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

function tJson2PumlErrorTypeHelper.EventType: tEventType;
begin
  Result := cJson2PumlErrorInformation[self].EventType;
end;

function tJson2PumlErrorTypeHelper.Failed: boolean;
begin
  Result := cJson2PumlErrorInformation[self].EventType in [etError, etCritical, etException];
end;

function tJson2PumlErrorTypeHelper.HttpStatusCode: integer;
begin
  Result := cJson2PumlErrorInformation[self].HttpStatusCode;
end;

procedure tJson2PumlErrorTypeHelper.RenderErrorResponse (oJson: tStrings; iLevel: integer; iErrorMessage: string = '');
begin
  if Errorcode.IsEmpty then
    exit;
  WriteObjectStartToJson (oJson, iLevel, '');
  WriteToJsonValue (oJson, 'errorCode', Errorcode, iLevel + 1, false);
  WriteToJsonValue (oJson, 'errorClass', JSON2PUML_EVENTTYPENAMES[integer(EventType)], iLevel + 1, false);
  if iErrorMessage.IsEmpty then
    WriteToJsonValue (oJson, 'message', ErrorMessage, iLevel + 1, false)
  else
    WriteToJsonValue (oJson, 'message', iErrorMessage, iLevel + 1, false);
  WriteToJsonValue (oJson, 'description', ErrorDescription, iLevel + 1, false);
  WriteObjectEndToJson (oJson, iLevel);
end;

constructor tJson2PumlBasePropertyListCache.Create;
begin
  inherited Create;
  FCacheList := tStringList.Create;
  FCacheList.OwnsObjects := true;
  FCacheList.Sorted := true;
  FCacheList.Duplicates := dupError;
end;

destructor tJson2PumlBasePropertyListCache.Destroy;
begin
  FCacheList.Free;
  inherited Destroy;
end;

procedure tJson2PumlBasePropertyListCache.AddCache (const iPropertyName, iParentPropertyName, iParentObjectType,
  iFoundCondition: string; iPropertyIndex: integer);
var
  Entry: tJson2PumlBasePropertyListEntry;
begin
  Entry := tJson2PumlBasePropertyListEntry.Create;
  Entry.FoundCondition := iFoundCondition;
  Entry.PropertyIndex := iPropertyIndex;
  CacheList.AddObject (CacheName(iPropertyName, iParentPropertyName, iParentObjectType), Entry);
end;

function tJson2PumlBasePropertyListCache.CacheName (const iPropertyName, iParentPropertyName,
  iParentObjectType: string): string;
begin
  Result := string.Join ('#', [iPropertyName, iParentPropertyName, iParentObjectType]);
end;

procedure tJson2PumlBasePropertyListCache.Clear;
begin
  CacheList.Clear;
end;

function tJson2PumlBasePropertyListCache.GetCache (const iPropertyName, iParentPropertyName, iParentObjectType: string;
  var oFoundCondition: string; var oPropertyIndex: integer): boolean;
var
  Index: integer;
  Entry: tJson2PumlBasePropertyListEntry;
begin
  index := CacheList.IndexOf (CacheName(iPropertyName, iParentPropertyName, iParentObjectType));
  Result := index >= 0;
  if Result then
  begin
    Entry := tJson2PumlBasePropertyListEntry (CacheList.Objects[index]);
    oFoundCondition := Entry.FoundCondition;
    oPropertyIndex := Entry.PropertyIndex;
  end;
end;

constructor tJson2PumlBasePropertyListEntry.Create;
begin
  inherited Create;
  FPropertyIndex := - 1;
end;

end.
