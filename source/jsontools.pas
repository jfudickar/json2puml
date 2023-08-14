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

function BooleanToString (iValue: Boolean): string;

procedure ClearJsonLastLineComma (oJsonOutPut: TStrings);

function ClearJsonPropertyValue (iValue: string): string;

function ExistsJsonProperty (iJsonObject: TJsonObject; iName: string): Boolean;

procedure FormatJsonFile (iFileName: string; iOutputFileName: string = '');

function GetJsonArray (iJsonObject: TJsonObject; iName: string): TJsonArray;

function GetJsonObject (iJsonObject: TJsonObject; iName: string): TJsonObject; overload;

function GetJsonObject (iJsonValue: TJSONValue; iName: string): TJsonObject; overload;

function GetJsonStringArray (iJsonArray: TJsonArray): string; overload;

function GetJsonStringArray (iJsonObject: TJsonObject; iName: string): string; overload;

function GetJsonStringValue (iJsonObject: TJsonObject; iNames: TStrings; iValueSeparator: string = ''): string;
  overload;

function GetJsonStringValue (iJsonValue: TJSONValue; iPropertyName: string; iDefault: string = '';
  iValueSeparator: string = ''): string; overload;

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: Boolean): Boolean; overload;

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: string = ''): string; overload;

function GetJsonStringValueInteger (iJsonObject: TJsonObject; iName: string; iDefault: Integer): Integer; overload;

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: TJSONValue; iPropertyName: string;
  iMaxRecords: Integer = MaxInt; iClearListBefore: Boolean = true);

function GetJsonValue (iJsonObject: TJsonObject; iName: string): TJSONValue;

function IsJsonArraySimple (iJsonArray: TJsonArray): Boolean;

function IsJsonSimple (iJsonValue: TJSONValue): Boolean;

function JsonLinePrefix (iLevel: Integer): string;

function JsonPropertyName (iPropertyName: string): string;

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: Boolean = false;
  iValueQuotes: Boolean = true): string;

procedure PrettyPrintArray (JsonArray: TJsonArray; OutputStrings: TStrings; indent: Integer);

procedure PrettyPrintJSON (JsonValue: TJSONValue; OutputStrings: TStrings; indent: Integer = 0);

procedure PrettyPrintPair (JsonPair: TJSONPair; OutputStrings: TStrings; last: Boolean; indent: Integer);

function StringToBoolean (iValue: string; iDefault: Boolean): Boolean; overload;

function StringToBoolean (iValue: string; iDefault: string): string; overload;

function StringToInteger (iValue: string; iDefault: Integer): Integer;

function ValidateBooleanInput (iInput: string): string;

procedure WriteArrayEndToJson (oJsonOutPut: TStrings; iLevel: Integer);

procedure WriteArrayStartToJson (oJsonOutPut: TStrings; iLevel: Integer; iPropertyName: string);

procedure WriteObjectEndToJson (oJsonOutPut: TStrings; iLevel: Integer);

procedure WriteObjectStartToJson (oJsonOutPut: TStrings; iLevel: Integer; iPropertyName: string);

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Boolean;
  iLevel: Integer); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Integer;
  iLevel: Integer); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false; iValueQuotes: Boolean = true); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: TJSONValue; iLevel: Integer;
  iWriteEmpty: Boolean = false); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalues: TStrings; iLevel: Integer;
  iCompress: Boolean; iWriteEmpty: Boolean = false); overload;

procedure WriteToJsonValueBoolean (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false);

implementation

uses
  System.SysUtils, System.Generics.Collections;

const
  cTrue = 'true';
  cFalse = 'false';

function BooleanToString (iValue: Boolean): string;
begin
  if iValue then
    Result := cTrue
  else
    Result := cFalse;
end;

procedure ClearJsonLastLineComma (oJsonOutPut: TStrings);
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

function ExistsJsonProperty (iJsonObject: TJsonObject; iName: string): Boolean;
begin
  Result := false;
  if not Assigned (iJsonObject) then
    Exit;
  Result := Assigned (iJsonObject.Values[iName]);
end;

procedure FormatJsonFile (iFileName: string; iOutputFileName: string = '');
var
  InputFile, OutputFile: tStringList;
  JsonValue: TJSONValue;
begin
  InputFile := tStringList.Create;
  OutputFile := tStringList.Create;
  try
    InputFile.LoadFromFile (iFileName);
    JsonValue := TJsonObject.ParseJSONValue (InputFile.Text);
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

function GetJsonArray (iJsonObject: TJsonObject; iName: string): TJsonArray;
var
  JsonValue: TJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    JsonValue := iJsonObject.Values[iName];
    if not Assigned (JsonValue) then
      Exit;
    if not (JsonValue is TJsonArray) then
      Exit;
    Result := TJsonArray (JsonValue);
  end;
end;

function GetJsonObject (iJsonValue: TJSONValue; iName: string): TJsonObject;
begin
  Result := nil;
  if not Assigned (iJsonValue) then
    Exit;
  if iJsonValue is TJsonObject then
    Result := GetJsonObject (TJsonObject(iJsonValue), iName);
end;

function GetJsonStringArray (iJsonObject: TJsonObject; iName: string): string;
var
  JsonValue: TJSONValue;
  JsonArray: TJsonArray;
begin
  Result := '';
  if not Assigned (iJsonObject) then
    Exit;
  JsonValue := iJsonObject.Values[iName];
  if not Assigned (JsonValue) then
    Exit;
  if JsonValue is TJSONString then
    Result := TJSONString (JsonValue).value
  else if JsonValue is TJSONBool then
    Result := TJSONBool (JsonValue).toString
  else if JsonValue is TJSONNumber then
    Result := TJSONNumber (JsonValue).toString
  else if JsonValue is TJsonArray then
  begin
    JsonArray := TJsonArray (JsonValue);
    Result := GetJsonStringArray (JsonArray);
  end;
end;

function GetJsonStringArray (iJsonArray: TJsonArray): string;
var
  JsonValue: TJSONValue;
  ResultList: tStringList;
  name, value: string;
  i: Integer;
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

function GetJsonStringValue (iJsonObject: TJsonObject; iNames: TStrings; iValueSeparator: string = ''): string;
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

function GetJsonStringValue (iJsonValue: TJSONValue; iPropertyName: string; iDefault: string = '';
  iValueSeparator: string = ''): string;
var
  i: Integer;
  ValueList: tStringList;
  MaxRecords: Integer;

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

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: Boolean): Boolean; overload;
begin
  Result := StringToBoolean (GetJsonStringValueBoolean(iJsonObject, iName, ''), iDefault);
end;

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: string = ''): string;
begin
  Result := StringToBoolean (GetJsonStringValue(iJsonObject, iName, ''), iDefault);
end;

function GetJsonStringValueInteger (iJsonObject: TJsonObject; iName: string; iDefault: Integer): Integer;
begin
  Result := StringToInteger (GetJsonStringValue(iJsonObject, iName, iDefault.toString), iDefault);
end;

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: TJSONValue; iPropertyName: string;
  iMaxRecords: Integer = MaxInt; iClearListBefore: Boolean = true);
var
  JsonValue: TJSONValue;
  JsonArray: TJsonArray;
  jsonObject: TJsonObject;
  i, p: Integer;
  value: string;
  ObjectProperty, DetailProperty: string;

  function Split (iFilter, iSearchOperator: string; var oFilterProperty, oFilterOperator, oFilterValue: string)
    : Boolean;
  var
    p: Integer;
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

  function SplitAll (iFilter: string; var oFilterProperty, oFilterOperator, oFilterValue: string): Boolean;
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
    var oFilterProperty, oFilterOperator, oFilterValue: string): Boolean;
  var
    p1, p2: Integer;
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

  function FilterObject (iJsonObject: TJsonObject; var iFilterPropertyName: string): Boolean;
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
  if iPropertyName.Trim.IsEmpty and (iJsonValue is TJsonObject) then
    Exit;
  value := '';
  if iJsonValue is TJsonObject then
  begin
    jsonObject := TJsonObject (iJsonValue);
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
  else if iJsonValue is TJsonArray then
  begin
    JsonArray := TJsonArray (iJsonValue);
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
    if iJsonValue is TJSONString then
      value := TJSONString (iJsonValue).value
    else if iJsonValue is TJSONBool then
      value := TJSONBool (iJsonValue).toString
    else if iJsonValue is TJSONNumber then
      value := TJSONNumber (iJsonValue).toString;
    if not value.IsEmpty then
      iValueList.Add (value);
  end;
end;

function GetJsonValue (iJsonObject: TJsonObject; iName: string): TJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
    Result := iJsonObject.Values[iName]
  else
    Result := TJSONValue (iJsonObject);
end;

function JsonLinePrefix (iLevel: Integer): string;
var
  i: Integer;
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

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: Boolean = false;
  iValueQuotes: Boolean = true): string;
begin
  if iWriteEmpty or not iPropertyvalue.IsEmpty then
    if iPropertyvalue.IsEmpty then
      Result := Format ('"%s": null', [iPropertyName])
    else if iValueQuotes then
      Result := Format ('"%s": "%s"', [iPropertyName, ClearJsonPropertyValue(iPropertyvalue)])
    else
      Result := Format ('"%s": %s', [iPropertyName, ClearJsonPropertyValue(iPropertyvalue)]);
end;

procedure PrettyPrintArray (JsonArray: TJsonArray; OutputStrings: TStrings; indent: Integer);
var
  i: Integer;
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

procedure PrettyPrintJSON (JsonValue: TJSONValue; OutputStrings: TStrings; indent: Integer = 0);
var
  i: Integer;
begin
  if JsonValue is TJsonObject then
  begin
    OutputStrings.Add (JsonLinePrefix(indent) + '{');
    for i := 0 to TJsonObject(JsonValue).Count - 1 do
      PrettyPrintPair (TJsonObject(JsonValue).Pairs[i], OutputStrings, i = TJsonObject(JsonValue).Count - 1,
        indent + 1);
    OutputStrings.Add (JsonLinePrefix(indent) + '}');
  end
  else if JsonValue is TJsonArray then
    PrettyPrintArray (TJsonArray(JsonValue), OutputStrings, indent)
  else
    OutputStrings.Add (JsonLinePrefix(indent) + JsonValue.tojson);
end;

procedure PrettyPrintPair (JsonPair: TJSONPair; OutputStrings: TStrings; last: Boolean; indent: Integer);
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

function StringToBoolean (iValue: string; iDefault: Boolean): Boolean;
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

function StringToInteger (iValue: string; iDefault: Integer): Integer;
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

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Boolean; iLevel: Integer);
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, BooleanToString(iPropertyvalue), iLevel, false, false)
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Integer;
  iLevel: Integer); overload;
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, iPropertyvalue.toString, iLevel, false, false)
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false; iValueQuotes: Boolean = true);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if not iWriteEmpty and iPropertyvalue.Trim.IsEmpty then
    Exit;
  oJsonOutPut.Add (Format('%s%s,', [JsonLinePrefix(iLevel), JsonPropertyNameValue(iPropertyName, iPropertyvalue,
    iWriteEmpty, iValueQuotes)]));
end;

procedure WriteToJsonValueBoolean (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false);
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, iPropertyvalue, iLevel, iWriteEmpty, false);
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: TJSONValue; iLevel: Integer;
  iWriteEmpty: Boolean = false);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if Assigned (iPropertyvalue) then
    if iPropertyvalue is TJSONNull then
      if iWriteEmpty then
        oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, 'null']))
      else
    else
      oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, iPropertyvalue.toString]))
  else if iWriteEmpty then
    oJsonOutPut.Add (Format('%s"%s":%s,', [JsonLinePrefix(iLevel), iPropertyName, 'null']));
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalues: TStrings; iLevel: Integer;
  iCompress: Boolean; iWriteEmpty: Boolean = false);
var
  Prefix: string;
  i: Integer;
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

function GetJsonObject (iJsonObject: TJsonObject; iName: string): TJsonObject;
var
  JsonValue: TJSONValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    JsonValue := iJsonObject.Values[iName];
    if not Assigned (JsonValue) then
      Exit;
    if not (JsonValue is TJsonObject) then
      Exit;
    Result := TJsonObject (JsonValue);
  end
  else
    Result := iJsonObject;
end;

function IsJsonSimple (iJsonValue: TJSONValue): Boolean;
begin
  Result := (iJsonValue is TJSONString) or (iJsonValue is TJSONBool) or (iJsonValue is TJSONNumber) or
    (iJsonValue is TJSONNull);
end;

function IsJsonArraySimple (iJsonArray: TJsonArray): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 0 to iJsonArray.Count - 1 do
  begin
    Result := Result and IsJsonSimple (iJsonArray.Items[i]);
    if not Result then
      Exit;
  end;
end;

procedure WriteArrayStartToJson (oJsonOutPut: TStrings; iLevel: Integer; iPropertyName: string);
begin
  if (iLevel > 0) or not iPropertyName.IsEmpty then
    oJsonOutPut.Add (Format('%s%s [', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName)]))
  else
    oJsonOutPut.Add ('[');
end;

procedure WriteArrayEndToJson (oJsonOutPut: TStrings; iLevel: Integer);
begin
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s],', [JsonLinePrefix(iLevel)]));
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

procedure WriteObjectStartToJson (oJsonOutPut: TStrings; iLevel: Integer; iPropertyName: string);
begin
  oJsonOutPut.Add (Format('%s%s{', [JsonLinePrefix(iLevel), JsonPropertyName(iPropertyName)]));
end;

procedure WriteObjectEndToJson (oJsonOutPut: TStrings; iLevel: Integer);
begin
  ClearJsonLastLineComma (oJsonOutPut);
  oJsonOutPut.Add (Format('%s},', [JsonLinePrefix(iLevel)]));
  if iLevel <= 0 then
    ClearJsonLastLineComma (oJsonOutPut);
end;

end.
