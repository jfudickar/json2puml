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

function GetJsonObject(iJsonValue: TJSONValue; iName: string): TJsonObject; overload;

function GetJsonStringArray (iJsonObject: TJsonObject; iName: string): string;

function GetJsonStringValue (iJsonObject: TJsonObject; iNames: TStrings; iValueSeparator: string = ''): string;
  overload;

function GetJsonStringValue (iJsonValue: TJsonValue; iPropertyName: string; iDefault: string = '';
  iValueSeparator: string = ''): string; overload;

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: Boolean): Boolean; overload;

function GetJsonStringValueBoolean (iJsonObject: TJsonObject; iName: string; iDefault: string = ''): string; overload;

function GetJsonStringValueInteger (iJsonObject: TJsonObject; iName: string; iDefault: Integer): Integer; overload;

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: TJsonValue; iPropertyName: string;
  iMaxRecords: Integer = MaxInt; iClearListBefore: Boolean = true);

function GetJsonValue (iJsonObject: TJsonObject; iName: string): TJsonValue;

function JsonLinePrefix (iLevel: Integer): string;

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: Boolean = false): string;

procedure PrettyPrintArray (jsonArray: TJsonArray; OutputStrings: TStrings; indent: Integer);

procedure PrettyPrintJSON (jsonValue: TJsonValue; OutputStrings: TStrings; indent: Integer = 0);

procedure PrettyPrintPair (jsonPair: TJSONPair; OutputStrings: TStrings; last: Boolean; indent: Integer);

function StringToBoolean (iValue: string; iDefault: Boolean): Boolean; overload;

function StringToBoolean (iValue: string; iDefault: string): string; overload;

function StringToInteger (iValue: string; iDefault: Integer): Integer;

function ValidateBooleanInput (iInput: string): string;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Boolean;
  iLevel: Integer); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Integer;
  iLevel: Integer); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: TJsonValue; iLevel: Integer;
  iWriteEmpty: Boolean = false); overload;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalues: TStrings; iLevel: Integer;
  iCompress: Boolean; iWriteEmpty: Boolean = false); overload;

function GetJsonObject(iJsonObject: TJsonObject; iName: string): TJsonObject; overload;

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
  jsonValue: TJsonValue;

begin
  InputFile := tStringList.Create;
  OutputFile := tStringList.Create;
  try
    InputFile.LoadFromFile (iFileName);
    jsonValue := TJsonObject.ParseJSONValue (InputFile.Text);
    if not Assigned (jsonValue) then
      Exit;
    PrettyPrintJSON (jsonValue, OutputFile, 0);
    // OutputFile.Text := jsonValue.ToString; //Format(2);
    if iOutputFileName.IsEmpty then
      OutputFile.SaveToFile (iFileName)
    else
      OutputFile.SaveToFile (iOutputFileName);
  finally
    InputFile.Free;
    OutputFile.Free;
  end;
end;

function GetJsonArray (iJsonObject: TJsonObject; iName: string): TJsonArray;
var
  jsonValue: TJsonValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    jsonValue := iJsonObject.Values[iName];
    if not Assigned (jsonValue) then
      Exit;
    if not (jsonValue is TJsonArray) then
      Exit;
    Result := TJsonArray (jsonValue);
  end;
end;

function GetJsonObject(iJsonValue: TJSONValue; iName: string): TJsonObject;
begin
  Result := nil;
  if not Assigned (iJsonValue) then
    Exit;
  if iJsonValue is TJSONObject then
    Result := GetJsonObject(TJSONObject(iJsonValue), iName);
end;

function GetJsonStringArray (iJsonObject: TJsonObject; iName: string): string;
var
  jsonValue: TJsonValue;
  jsonArray: TJsonArray;
  ResultList: tStringList;
  name, value: string;
  i: Integer;
begin
  Result := '';
  if not Assigned (iJsonObject) then
    Exit;
  jsonValue := iJsonObject.Values[iName];
  if not Assigned (jsonValue) then
    Exit;
  if jsonValue is TJSONString then
    Result := TJSONString (jsonValue).value
  else if jsonValue is TJSONBool then
    Result := TJSONBool (jsonValue).toString
  else if jsonValue is TJsonArray then
  begin
    jsonArray := TJsonArray (jsonValue);
    ResultList := tStringList.Create;
    try
      for i := 0 to jsonArray.Count - 1 do
      begin
        value := '';
        jsonValue := jsonArray.Items[i];
        if jsonValue is TJSONString then
          value := TJSONString (jsonValue).value;
        // if Assigned(jsonPair.JsonValue) and jsonPair.JsonValue is TJSONString then
        // Value := TJSONString(jsonPair.JsonValue).Value
        // else
        // Continue;
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

function GetJsonStringValue (iJsonValue: TJsonValue; iPropertyName: string; iDefault: string = '';
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

procedure GetJsonStringValueList (iValueList: tStringList; iJsonValue: TJsonValue; iPropertyName: string;
  iMaxRecords: Integer = MaxInt; iClearListBefore: Boolean = true);
var
  jsonValue: TJsonValue;
  jsonArray: TJsonArray;
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
      jsonValue := jsonObject.Values[DetailProperty];
      if not Assigned (jsonValue) then
        Exit;
      GetJsonStringValueList (iValueList, jsonValue, '', iMaxRecords, false);
    end
    else
    begin
      if not FilterObject (jsonObject, ObjectProperty) then
        Exit;
      jsonValue := jsonObject.Values[ObjectProperty];
      if not Assigned (jsonValue) then
        Exit;
      GetJsonStringValueList (iValueList, jsonValue, DetailProperty, iMaxRecords, false);
    end;
  end
  else if iJsonValue is TJsonArray then
  begin
    jsonArray := TJsonArray (iJsonValue);
    for i := 0 to jsonArray.Count - 1 do
    begin
      jsonValue := jsonArray.Items[i];
      GetJsonStringValueList (iValueList, jsonValue, iPropertyName, iMaxRecords, false);
      if iValueList.Count >= iMaxRecords then
        break;
    end;
  end
  else
  begin
    if iJsonValue is TJSONString then
      value := TJSONString (iJsonValue).value
    else if iJsonValue is TJSONBool then
      value := TJSONBool (iJsonValue).toString;
    if not value.IsEmpty then
      iValueList.Add (value);
  end;
end;

function GetJsonValue (iJsonObject: TJsonObject; iName: string): TJsonValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
    Result := iJsonObject.Values[iName]
  else
    Result := TJsonValue (iJsonObject);
end;

function JsonLinePrefix (iLevel: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to iLevel do
    Result := Result + #9;
end;

function JsonPropertyNameValue (iPropertyName, iPropertyvalue: string; iWriteEmpty: Boolean = false): string;
begin
  if iWriteEmpty or not iPropertyvalue.IsEmpty then
    if iPropertyvalue.IsEmpty then
      Result := Format ('"%s": null', [iPropertyName])
    else
      Result := Format ('"%s": "%s"', [iPropertyName, ClearJsonPropertyValue(iPropertyvalue)]);
end;

procedure PrettyPrintArray (jsonArray: TJsonArray; OutputStrings: TStrings; indent: Integer);
var
  i: Integer;
begin
  OutputStrings.Add (JsonLinePrefix(indent) + '[');
  for i := 0 to jsonArray.Count - 1 do
  begin
    PrettyPrintJSON (jsonArray.Items[i], OutputStrings, indent + 1);
    if i < jsonArray.Count - 1 then
      OutputStrings[OutputStrings.Count - 1] := OutputStrings[OutputStrings.Count - 1] + ',';
  end;
  OutputStrings.Add (JsonLinePrefix(indent) + ']');
end;

procedure PrettyPrintJSON (jsonValue: TJsonValue; OutputStrings: TStrings; indent: Integer = 0);
var
  i: Integer;
begin
  if jsonValue is TJsonObject then
  begin
    OutputStrings.Add (JsonLinePrefix(indent) + '{');
    for i := 0 to TJsonObject(jsonValue).Count - 1 do
      PrettyPrintPair (TJsonObject(jsonValue).Pairs[i], OutputStrings, i = TJsonObject(jsonValue).Count - 1,
        indent + 1);
    OutputStrings.Add (JsonLinePrefix(indent) + '}');
  end
  else if jsonValue is TJsonArray then
    PrettyPrintArray (TJsonArray(jsonValue), OutputStrings, indent)
  else
    OutputStrings.Add (JsonLinePrefix(indent) + jsonValue.tojson);
end;

procedure PrettyPrintPair (jsonPair: TJSONPair; OutputStrings: TStrings; last: Boolean; indent: Integer);
const
  TEMPLATE = '%s : %s';
var
  line: string;
  newList: tStringList;
begin
  newList := tStringList.Create;
  try
    PrettyPrintJSON (jsonPair.jsonValue, newList, indent);
    line := Format (TEMPLATE, [jsonPair.JsonString.toString, Trim(newList.Text)]);
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
  WriteToJsonValue (oJsonOutPut, iPropertyName, BooleanToString(iPropertyvalue), iLevel)
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: Integer;
  iLevel: Integer); overload;
begin
  WriteToJsonValue (oJsonOutPut, iPropertyName, iPropertyvalue.toString, iLevel)
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName, iPropertyvalue: string; iLevel: Integer;
  iWriteEmpty: Boolean = false);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if not iWriteEmpty and iPropertyvalue.Trim.IsEmpty then
    Exit;
  oJsonOutPut.Add (Format('%s%s,', [JsonLinePrefix(iLevel), JsonPropertyNameValue(iPropertyName, iPropertyvalue,
    iWriteEmpty)]));
end;

procedure WriteToJsonValue (oJsonOutPut: TStrings; iPropertyName: string; iPropertyvalue: TJsonValue; iLevel: Integer;
  iWriteEmpty: Boolean = false);
begin
  if iPropertyName.IsEmpty then
    Exit;
  if Assigned (iPropertyvalue) then
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

function GetJsonObject(iJsonObject: TJsonObject; iName: string): TJsonObject;
var
  jsonValue: TJsonValue;
begin
  Result := nil;
  if not Assigned (iJsonObject) then
    Exit;
  if not iName.IsEmpty then
  begin
    jsonValue := iJsonObject.Values[iName];
    if not Assigned (jsonValue) then
      Exit;
    if not (jsonValue is TJsonObject) then
      Exit;
    Result := TJsonObject (jsonValue);
  end
  else
    Result := iJsonObject;
end;

end.
