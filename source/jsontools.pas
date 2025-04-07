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

unit jsontools;

interface

uses
  System.Classes, System.JSON;

function BooleanToString (iValue: boolean): string;

procedure ClearJsonLastLineComma (oJsonOutPut: tStrings);

function ClearJsonPropertyValue (iValue: string): string;

function ExistsJsonProperty (iJsonObject: tJSONObject; iName: string): boolean;

procedure FormatJsonFile (iFileName: string; iOutputFileName: string = '');

function GetJsonFileRecordCount (iFileName: string): integer;

function GetJsonArray (iJsonObject: tJSONObject; iName: string): tJSONArray;

function GetJsonObject (iJsonObject: tJSONObject; iName: string): tJSONObject; overload;

function GetJsonObject (iJsonValue: tJSONValue; iName: string): tJSONObject; overload;

function GetJsonStringArray (iJsonArray: tJSONArray): string; overload;

function GetJsonStringArray (iJsonObject: tJSONObject; iName: string): string; overload;

function GetJsonStringValue (iJsonObject: tJSONObject; iNames: tStrings; iValueSeparator: string = ''): string;
  overload;

function GetJsonStringValue (iJsonValue: tJSONValue; iPropertyName: string; iDefault: string = '';
  iValueSeparator: string = ''): string; overload;

function GetJsonStringValueBoolean (iJsonObject: tJSONObject; iName: string; iDefault: boolean): boolean; overload;

function GetJsonStringValueBoolean (iJsonObject: tJSONObject; iName: string; iDefault: string = ''): string; overload;

function GetJsonStringValueInteger (iJsonObject: tJSONObject; iName: string; iDefault: integer): integer; overload;

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: tJSONValue; iPropertyName: string;
  iMaxRecords: integer = MaxInt; iClearListBefore: boolean = true);

function GetJsonValue (iJsonObject: tJSONObject; iName: string): tJSONValue;

function IsJsonArraySimple (iJsonArray: tJSONArray): boolean;

function IsJsonSimple (iJsonValue: tJSONValue): boolean;

function IsJsonFilled (iJsonValue: tJSONValue): boolean;

function JsonLinePrefix (iLevel: integer): string;

function JsonPropertyName (iPropertyName: string): string;

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: boolean = false;
  iValueQuotes: boolean = true): string;

procedure PrettyPrintArray (JsonArray: tJSONArray; OutputStrings: tStrings; indent: integer);

procedure PrettyPrintJSON (JsonValue: tJSONValue; OutputStrings: tStrings; indent: integer = 0);

procedure PrettyPrintPair (JsonPair: tJSONPair; OutputStrings: tStrings; last: boolean; indent: integer);

function StringToBoolean (iValue: string; iDefault: boolean): boolean; overload;

function StringToBoolean (iValue: string; iDefault: string): string; overload;

function StringToInteger (iValue: string; iDefault: integer): integer;

function ValidateBooleanInput (iInput: string): string;

procedure WriteArrayEndToJson (oJsonOutPut: tStrings; iLevel: integer);

procedure WriteArrayStartToJson (oJsonOutPut: tStrings; iLevel: integer; iPropertyName: string);

procedure WriteObjectEndToJson (oJsonOutPut: tStrings; iLevel: integer);

procedure WriteObjectStartToJson (oJsonOutPut: tStrings; iLevel: integer; iPropertyName: string);

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: boolean;
  iLevel: integer); overload;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: integer;
  iLevel: integer); overload;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName, iPropertyvalue: string; iLevel: integer;
  iWriteEmpty: boolean = false; iValueQuotes: boolean = true); overload;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: tJSONValue; iLevel: integer;
  iWriteEmpty: boolean = false); overload;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalues: tStrings; iLevel: integer;
  iCompress: boolean; iWriteEmpty: boolean = false); overload;

procedure WriteToJsonValueBoolean (oJsonOutPut: tStrings; iPropertyName, iPropertyvalue: string; iLevel: integer;
  iWriteEmpty: boolean = false);

function GetJsonStringRecordCount (const iJson: string): integer;

implementation

uses
  System.SysUtils, System.Generics.Collections;

const
  cTrue = 'true';
  cFalse = 'false';

function BooleanToString (iValue: boolean): string;
begin
  if iValue then
    Result := cTrue
  else
    Result := cFalse;
end;

procedure ClearJsonLastLineComma (oJsonOutPut: tStrings);
var
  s: string;
begin
  if oJsonOutPut.Count < 0 then
    Exit;
  s := oJsonOutPut[oJsonOutPut.Count - 1].TrimRight;
  if s.Substring (s.Length - 1) = ',' then
    oJsonOutPut[oJsonOutPut.Count - 1] := s.Substring (0, s.Length - 1);
end;

function ClearJsonPropertyValue (iValue: string): string;
begin
  Result := iValue.TrimRight ([' ', #10, #13, #9]).replace ('\', '\\').replace ('"', '\"').replace (#13#10, #10)
    .replace (#13, #10).replace (#10, '\n');
end;

function ExistsJsonProperty (iJsonObject: tJSONObject; iName: string): boolean;
begin
  Result := false;
  if not Assigned (iJsonObject) then
    Exit;
  Result := Assigned (iJsonObject.Values[iName]);
end;

procedure FormatJsonFile (iFileName: string; iOutputFileName: string = '');
var
  InputFile, OutputFile: tStringList;
  JsonValue: tJSONValue;
begin
  InputFile := tStringList.Create;
  OutputFile := tStringList.Create;
  try
    InputFile.LoadFromFile (iFileName);
    JsonValue := tJSONObject.ParseJSONValue (InputFile.Text);
    if Assigned (JsonValue) then
      try
        PrettyPrintJSON (JsonValue, OutputFile, 0);
        // OutputFile.Text := jsonValue.ToString; //Format(2);
        if iOutputFileName.IsEmpty then
          OutputFile.SaveToFile (iFileName)
        else
          OutputFile.SaveToFile (iOutputFileName);
      finally
        JsonValue.Free;
      end;
  finally
    InputFile.Free;
    OutputFile.Free;
  end;
end;

function GetJsonArray (iJsonObject: tJSONObject; iName: string): tJSONArray;
var
  JsonValue: tJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    JsonValue := iJsonObject.Values[iName];
    if not Assigned (JsonValue) then
      Exit;
    if not (JsonValue is tJSONArray) then
      Exit;
    Result := tJSONArray (JsonValue);
  end;
end;

function GetJsonObject (iJsonValue: tJSONValue; iName: string): tJSONObject;
begin
  Result := nil;
  if not Assigned (iJsonValue) then
    Exit;
  if iJsonValue is tJSONObject then
    Result := GetJsonObject (tJSONObject(iJsonValue), iName);
end;

function GetJsonStringArray (iJsonObject: tJSONObject; iName: string): string;
var
  JsonValue: tJSONValue;
  JsonArray: tJSONArray;
begin
  Result := '';
  if not Assigned (iJsonObject) then
    Exit;
  JsonValue := iJsonObject.Values[iName];
  if not Assigned (JsonValue) then
    Exit;
  if JsonValue is tJSONString then
    Result := tJSONString (JsonValue).value
  else if JsonValue is tJSONBool then
    Result := tJSONBool (JsonValue).toString
  else if JsonValue is tJSONNumber then
    Result := tJSONNumber (JsonValue).toString
  else if JsonValue is tJSONArray then
  begin
    JsonArray := tJSONArray (JsonValue);
    Result := GetJsonStringArray (JsonArray);
  end;
end;

function GetJsonStringArray (iJsonArray: tJSONArray): string;
var
  JsonValue: tJSONValue;
  ResultList: tStringList;
  name, value: string;
  i: integer;
begin
  Result := '';
  if not Assigned (iJsonArray) then
    Exit;
  ResultList := tStringList.Create;
  try
    for i := 0 to iJsonArray.Count - 1 do
    begin
      value := '';
      JsonValue := iJsonArray.Items[i];
      if IsJsonSimple (JsonValue) then
        value := JsonValue.value;
      if (value.IsEmpty) and (name.IsEmpty) then
        Continue
      else if (not value.IsEmpty) and (not name.IsEmpty) then
        ResultList.AddPair (name, value)
      else if (not name.IsEmpty) then
        ResultList.Add (name)
      else
        ResultList.Add (value);
    end;
    Result := ResultList.Text;
  finally
    ResultList.Free;
  end;
end;

function GetJsonStringValue (iJsonObject: tJSONObject; iNames: tStrings; iValueSeparator: string = ''): string;
var
  s: string;
  value: string;
begin
  Result := '';
  for s in iNames do
  begin
    value := GetJsonStringValue (iJsonObject, s);
    if Result.IsEmpty then
      Result := value
    else
      Result := Result + iValueSeparator + value;
    if not Result.IsEmpty and iValueSeparator.IsEmpty then
      Exit;
  end;
end;

function GetJsonStringValue (iJsonValue: tJSONValue; iPropertyName: string; iDefault: string = '';
  iValueSeparator: string = ''): string;
var
  i: integer;
  ValueList: tStringList;
  MaxRecords: integer;

begin
  Result := '';
  ValueList := tStringList.Create;
  try
    if iValueSeparator.IsEmpty then
      MaxRecords := 1
    else
      MaxRecords := MaxInt;
    GetJsonStringValueList (ValueList, iJsonValue, iPropertyName, MaxRecords, true);
    for i := 0 to ValueList.Count - 1 do
      if Result.IsEmpty then
        Result := ValueList[i]
      else
        Result := Format ('%s%s%s', [Result, iValueSeparator, ValueList[i]]);
    if Result.IsEmpty then
      Result := iDefault;
  finally
    ValueList.Free;
  end;
end;

function GetJsonStringValueBoolean (iJsonObject: tJSONObject; iName: string; iDefault: boolean): boolean; overload;
begin
  Result := StringToBoolean (GetJsonStringValueBoolean(iJsonObject, iName, ''), iDefault);
end;

function GetJsonStringValueBoolean (iJsonObject: tJSONObject; iName: string; iDefault: string = ''): string;
begin
  Result := StringToBoolean (GetJsonStringValue(iJsonObject, iName, ''), iDefault);
end;

function GetJsonStringValueInteger (iJsonObject: tJSONObject; iName: string; iDefault: integer): integer;
begin
  Result := StringToInteger (GetJsonStringValue(iJsonObject, iName, iDefault.toString), iDefault);
end;

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: tJSONValue; iPropertyName: string;
  iMaxRecords: integer = MaxInt; iClearListBefore: boolean = true);
var
  JsonValue: tJSONValue;
  JsonArray: tJSONArray;
  jsonObject: tJSONObject;
  i, p: integer;
  value: string;
  ObjectProperty, DetailProperty: string;

  function Split (iFilter, iSearchOperator: string; var oFilterProperty, oFilterOperator, oFilterValue: string)
    : boolean;
  var
    p: integer;
  begin
    p := iFilter.IndexOf (iSearchOperator);
    Result := p >= 0;
    if not Result then
      Exit;
    oFilterProperty := iFilter.Substring (0, p).Trim;
    oFilterValue := iFilter.Substring (p + iSearchOperator.Length).Trim;
    oFilterOperator := iSearchOperator;
    Result := not oFilterProperty.IsEmpty and not oFilterValue.IsEmpty;
    if oFilterValue = '""' then
      oFilterValue := '';
  end;

  function SplitAll (iFilter: string; var oFilterProperty, oFilterOperator, oFilterValue: string): boolean;
  begin
    Result := true;
    if Split (iFilter, '!=', oFilterProperty, oFilterOperator, oFilterValue) then
      oFilterOperator := '<>'
    else if Split (iFilter, '<>', oFilterProperty, oFilterOperator, oFilterValue) then
    else if Split (iFilter, '<', oFilterProperty, oFilterOperator, oFilterValue) then
    else if Split (iFilter, '<=', oFilterProperty, oFilterOperator, oFilterValue) then
    else if Split (iFilter, '>', oFilterProperty, oFilterOperator, oFilterValue) then
    else if Split (iFilter, '>=', oFilterProperty, oFilterOperator, oFilterValue) then
    else if Split (iFilter, '=', oFilterProperty, oFilterOperator, oFilterValue) then
    else
      Result := false;
  end;

  function GetFilterFromProperty (var iFilterPropertyName: string;
    var oFilterProperty, oFilterOperator, oFilterValue: string): boolean;
  var
    p1, p2: integer;
    Filter: string;
  begin
    p1 := iFilterPropertyName.IndexOf ('[');
    p2 := iFilterPropertyName.IndexOf (']');
    Result := (p1 >= 0) and (p2 > p1);
    if not Result then
      Exit;
    Filter := iFilterPropertyName.Substring (p1 + 1, p2 - p1 - 1).Trim;
    iFilterPropertyName := iFilterPropertyName.Substring (0, p1).Trim;
    Result := SplitAll (Filter, oFilterProperty, oFilterOperator, oFilterValue);
  end;

  function FilterObject (iJsonObject: tJSONObject; var iFilterPropertyName: string): boolean;
  var
    FilterProperty, FilterOperator, FilterValue: string;
    ObjectValue: string;
  begin
    if GetFilterFromProperty (iFilterPropertyName, FilterProperty, FilterOperator, FilterValue) then
    begin
      ObjectValue := GetJsonStringValue (iJsonObject, FilterProperty);
      if ObjectValue.IsEmpty then
      begin
        if FilterOperator = '<>' then
          Result := true
        else
          Result := false;
        Exit;
      end;
      if FilterOperator = '=' then
        Result := ObjectValue = FilterValue
      else if FilterOperator = '<>' then
        Result := ObjectValue <> FilterValue
      else if FilterOperator = '<=' then
        Result := ObjectValue <= FilterValue
      else if FilterOperator = '<' then
        Result := ObjectValue < FilterValue
      else if FilterOperator = '>=' then
        Result := ObjectValue >= FilterValue
      else if FilterOperator = '>' then
        Result := ObjectValue > FilterValue
      else
        Result := false;
    end
    else
      Result := true;
  end;

begin
  if not Assigned (iValueList) then
    Exit;
  if iClearListBefore then
    iValueList.Clear;
  if not Assigned (iJsonValue) then
    Exit;
  if iPropertyName.Trim.IsEmpty and (iJsonValue is tJSONObject) then
    Exit;
  value := '';
  if iJsonValue is tJSONObject then
  begin
    jsonObject := tJSONObject (iJsonValue);
    p := iPropertyName.IndexOf ('.');
    if p >= 0 then
    begin
      ObjectProperty := iPropertyName.Substring (0, p).Trim;
      DetailProperty := iPropertyName.Substring (p + 1).Trim;
    end
    else
    begin
      ObjectProperty := '';
      DetailProperty := iPropertyName.Trim;
    end;
    if ObjectProperty.IsEmpty then
    begin
      if not FilterObject (jsonObject, DetailProperty) then
        Exit;
      if DetailProperty.IsEmpty then
        Exit;
      JsonValue := jsonObject.Values[DetailProperty];
      if not Assigned (JsonValue) then
        Exit;
      GetJsonStringValueList (iValueList, JsonValue, '', iMaxRecords, false);
    end
    else
    begin
      if not FilterObject (jsonObject, ObjectProperty) then
        Exit;
      JsonValue := jsonObject.Values[ObjectProperty];
      if not Assigned (JsonValue) then
        Exit;
      GetJsonStringValueList (iValueList, JsonValue, DetailProperty, iMaxRecords, false);
    end;
  end
  else if iJsonValue is tJSONArray then
  begin
    JsonArray := tJSONArray (iJsonValue);
    for i := 0 to JsonArray.Count - 1 do
    begin
      JsonValue := JsonArray.Items[i];
      GetJsonStringValueList (iValueList, JsonValue, iPropertyName, iMaxRecords, false);
      if iValueList.Count >= iMaxRecords then
        break;
    end;
  end
  else
  begin
    if iJsonValue is tJSONString then
      value := tJSONString (iJsonValue).value
    else if iJsonValue is tJSONBool then
      value := tJSONBool (iJsonValue).toString
    else if iJsonValue is tJSONNumber then
      value := tJSONNumber (iJsonValue).toString;
    if not value.IsEmpty then
      iValueList.Add (value);
  end;
end;

function GetJsonValue (iJsonObject: tJSONObject; iName: string): tJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
    Result := iJsonObject.Values[iName]
  else
    Result := tJSONValue (iJsonObject);
end;

function JsonLinePrefix (iLevel: integer): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to iLevel do
    Result := Result + #9;
end;

function JsonPropertyName (iPropertyName: string): string;
begin
  if not iPropertyName.IsEmpty then
    Result := Format ('"%s": ', [iPropertyName])
  else
    Result := '';
end;

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: boolean = false;
  iValueQuotes: boolean = true): string;
begin
  if iWriteEmpty or not iPropertyvalue.IsEmpty then
    if iPropertyvalue.IsEmpty then
      Result := Format ('"%s": null', [iPropertyName])
    else if iValueQuotes then
      Result := Format ('"%s": "%s"', [iPropertyName, ClearJsonPropertyValue(iPropertyvalue)])
    else
      Result := Format ('"%s": %s', [iPropertyName, ClearJsonPropertyValue(iPropertyvalue)]);
end;

procedure PrettyPrintArray (JsonArray: tJSONArray; OutputStrings: tStrings; indent: integer);
var
  i: integer;
begin
  OutputStrings.Add (JsonLinePrefix(indent) + '[');
  for i := 0 to JsonArray.Count - 1 do
  begin
    PrettyPrintJSON (JsonArray.Items[i], OutputStrings, indent + 1);
    if i < JsonArray.Count - 1 then
      OutputStrings[OutputStrings.Count - 1] := OutputStrings[OutputStrings.Count - 1] + ',';
  end;
  OutputStrings.Add (JsonLinePrefix(indent) + ']');
end;

procedure PrettyPrintJSON (JsonValue: tJSONValue; OutputStrings: tStrings; indent: integer = 0);
var
  i: integer;
begin
  if JsonValue is tJSONObject then
  begin
    OutputStrings.Add (JsonLinePrefix(indent) + '{');
    for i := 0 to tJSONObject(JsonValue).Count - 1 do
      PrettyPrintPair (tJSONObject(JsonValue).Pairs[i], OutputStrings, i = tJSONObject(JsonValue).Count - 1,
        indent + 1);
    OutputStrings.Add (JsonLinePrefix(indent) + '}');
  end
  else if JsonValue is tJSONArray then
    PrettyPrintArray (tJSONArray(JsonValue), OutputStrings, indent)
  else
    OutputStrings.Add (JsonLinePrefix(indent) + JsonValue.tojson);
end;

procedure PrettyPrintPair (JsonPair: tJSONPair; OutputStrings: tStrings; last: boolean; indent: integer);
const
  TEMPLATE = '%s : %s';
var
  line: string;
  newList: tStringList;
begin
  newList := tStringList.Create;
  try
    PrettyPrintJSON (JsonPair.JsonValue, newList, indent);
    line := Format (TEMPLATE, [JsonPair.JsonString.toString, Trim(newList.Text)]);
  finally
    newList.Free;
  end;

  line := JsonLinePrefix (indent) + line;
  if not last then
    line := line + ',';
  OutputStrings.Add (line);
end;

function StringToBoolean (iValue: string; iDefault: boolean): boolean;
begin
  if iValue.Trim.ToLower.Equals (cTrue) then
    Result := true
  else if iValue.Trim.ToLower.Equals (cFalse) then
    Result := false
  else
    Result := iDefault;
end;

function StringToBoolean (iValue: string; iDefault: string): string;
begin
  if iValue.Trim.ToLower.Equals (cTrue) then
    Result := cTrue
  else if iValue.Trim.ToLower.Equals (cFalse) then
    Result := cFalse
  else
    Result := iDefault;
end;

function StringToInteger (iValue: string; iDefault: integer): integer;
begin
  try
    if iValue.Trim.IsEmpty then
      Result := iDefault
    else
      Result := iValue.ToInteger;
  except
    on e: exception do
      Result := iDefault;
  end;
end;

function ValidateBooleanInput (iInput: string): string;
begin
  Result := StringToBoolean (iInput, '');
end;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: boolean; iLevel: integer);
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, BooleanToString(iPropertyvalue), iLevel, false, false)
end;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: integer;
  iLevel: integer); overload;
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, iPropertyvalue.toString, iLevel, false, false)
end;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName, iPropertyvalue: string; iLevel: integer;
  iWriteEmpty: boolean = false; iValueQuotes: boolean = true);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if not iWriteEmpty and iPropertyvalue.Trim.IsEmpty then
    Exit;
  oJsonOutPut.Add (Format('%s%s,', [JsonLinePrefix(iLevel), JsonPropertyNameValue(iPropertyName, iPropertyvalue,
    iWriteEmpty, iValueQuotes)]));
end;

procedure WriteToJsonValueBoolean (oJsonOutPut: tStrings; iPropertyName, iPropertyvalue: string; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, iPropertyvalue, iLevel, iWriteEmpty, false);
end;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalue: tJSONValue; iLevel: integer;
  iWriteEmpty: boolean = false);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if Assigned (iPropertyvalue) then
    if iPropertyvalue is tJSONNull then
      if iWriteEmpty then
        oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, 'null']))
      else
    else
      oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, iPropertyvalue.toString]))
  else if iWriteEmpty then
    oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, 'null']));
end;

procedure WriteToJsonValue (oJsonOutPut: tStrings; iPropertyName: string; iPropertyvalues: tStrings; iLevel: integer;
  iCompress: boolean; iWriteEmpty: boolean = false);
var
  Prefix: string;
  i: integer;
  s: string;
begin
  if iPropertyName.IsEmpty then
    Exit;
  if (iPropertyvalues.Count <= 0) and not iWriteEmpty then
    Exit;
  Prefix := JsonLinePrefix (iLevel);
  if iPropertyvalues.Count = 0 then
    oJsonOutPut.Add (Format('%s"%s": [],', [Prefix, iPropertyName]))
  else if iCompress and (iPropertyvalues.Count <= 1) then
    oJsonOutPut.Add (Format('%s"%s": ["%s"],', [Prefix, iPropertyName, ClearJsonPropertyValue(iPropertyvalues[0])]))
  else
  begin
    oJsonOutPut.Add (Format('%s"%s": [', [Prefix, iPropertyName]));
    for i := 0 to iPropertyvalues.Count - 1 do
    begin
      if i = iPropertyvalues.Count - 1 then
        s := ''
      else
        s := ',';
      oJsonOutPut.Add (Format('%s%s"%s"%s', [Prefix, #9, ClearJsonPropertyValue(iPropertyvalues[i]), s]));
    end;
    oJsonOutPut.Add (Format('%s],', [Prefix]));
  end;
end;

function GetJsonObject (iJsonObject: tJSONObject; iName: string): tJSONObject;
var
  JsonValue: tJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    JsonValue := iJsonObject.Values[iName];
    if not Assigned (JsonValue) then
      Exit;
    if not (JsonValue is tJSONObject) then
      Exit;
    Result := tJSONObject (JsonValue);
  end
  else
    Result := iJsonObject;
end;

function IsJsonSimple (iJsonValue: tJSONValue): boolean;
begin
  Result := (iJsonValue is tJSONString) or (iJsonValue is tJSONBool) or (iJsonValue is tJSONNumber) or
    (iJsonValue is tJSONNull);
end;

function IsJsonFilled (iJsonValue: tJSONValue): boolean;
begin
  if iJsonValue is tJSONArray then
    Result := tJSONArray (iJsonValue).Count > 0
  else if iJsonValue is tJSONObject then
    Result := tJSONArray (iJsonValue).Count > 0
  else
    Result := not iJsonValue.toString.IsEmpty;
end;

function IsJsonArraySimple (iJsonArray: tJSONArray): boolean;
var
  i: integer;
begin
  Result := true;
  for i := 0 to iJsonArray.Count - 1 do
  begin
    Result := Result and IsJsonSimple (iJsonArray.Items[i]);
    if not Result then
      Exit;
  end;
end;

procedure WriteArrayStartToJson (oJsonOutPut: tStrings; iLevel: integer; iPropertyName: string);
begin
  if (iLevel > 0) or not iPropertyName.IsEmpty then
    oJsonOutPut.Add (Format('%s%s[', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName)]))
  else
    oJsonOutPut.Add ('[');
end;

procedure WriteArrayEndToJson (oJsonOutPut: tStrings; iLevel: integer);
begin
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s],', [JsonLinePrefix(iLevel)]));
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

procedure WriteObjectStartToJson (oJsonOutPut: tStrings; iLevel: integer; iPropertyName: string);
begin
  oJsonOutPut.Add (Format('%s%s{', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName)]));
end;

procedure WriteObjectEndToJson (oJsonOutPut: tStrings; iLevel: integer);
begin
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(iLevel)]));
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

function GetJsonFileRecordCount (iFileName: string): integer;
var
  InputFile: tStringList;
begin
  InputFile := tStringList.Create;
  try
    InputFile.LoadFromFile (iFileName);
    Result := GetJsonStringRecordCount (InputFile.Text);
  finally
    InputFile.Free;
  end;
end;

function GetJsonStringRecordCount (const iJson: string): integer;
var
  JsonValue: tJSONValue;
begin
  Result := 0;
  JsonValue := tJSONObject.ParseJSONValue (iJson);
  if Assigned (JsonValue) then
    try
      if JsonValue is tJSONArray then
        Result := tJSONArray (JsonValue).Count
      else
        Result := 1;
    finally
      JsonValue.Free;
    end;
end;

end.
