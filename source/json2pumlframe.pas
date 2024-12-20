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

unit json2pumlframe;

interface

{$I json2puml.inc}

uses
{$IFDEF SVGICONIMAGE}
  SVGIconImage,
{$ENDIF}
{$IFDEF SKIASVG}
  System.IOUtils, System.Skia, Vcl.Skia,
{$ENDIF}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, json2pumlvcltools;

type
  TJson2PumlOutputFileFrame = class(TFrame)
    BottomPanel: TPanel;
    InputPanel: TPanel;
    Label1: TLabel;
    LeadingObjectEdit: TEdit;
    NamePanel: TPanel;
    Panel1: TPanel;
    PNGFileNameEdit: TButtonedEdit;
    PNGTabSheet: TTabSheet;
    PUMLFileNameEdit: TButtonedEdit;
    PumlTabSheet: TTabSheet;
    ResultImage: TImage;
    ResultPageControl: TPageControl;
    PNGScrollBox: TScrollBox;
    Splitter1: TSplitter;
    LogFileTabSheet: TTabSheet;
    LogFileNameEdit: TButtonedEdit;
    SVGTabSheet: TTabSheet;
    SVGScrollBox: TScrollBox;
    SVGFileNameEdit: TButtonedEdit;
    Panel2: TPanel;
    InputLabel: TLabel;
    InputFileNameEdit: TButtonedEdit;

  private
    FInputFileName: string;
    FInputGroup: string;
    FJsonInput: tStrings;
    FPNGFileName: string;
    FPUmlFileName: string;
    FPUmlOutput: tStrings;
    FLogList: tStrings;
    FConverterLogFileName: string;
    FSVGFileName: string;
{$IFDEF SVGICONIMAGE}
    SVGIconImage: TSVGIconImage;
{$ENDIF}
{$IFDEF SKIASVG}
    SkSvg: TSkSvg;
{$ENDIF}
    function GetJsonInput: tStrings;
    function GetLeadingObject: string;
    function GetPUmlOutput: tStrings;
    function GetLogList: tStrings;
    procedure SetInputFileName (const Value: string);
    procedure SetInputGroup (const Value: string);
    procedure SetJsonInput (const Value: tStrings);
    procedure SetLeadingObject (const Value: string);
    procedure SetPNGFileName (const Value: string);
    procedure SetPUmlFileName (const Value: string);
    procedure SetPUmlOutput (const Value: tStrings);
    procedure SetLogList (const Value: tStrings);
    procedure SetConverterLogFileName (const Value: string);
    procedure SetSVGFileName (const Value: string);
  public
    procedure CreateMemos (iCreateMemoProc: TJson2PumlCreateMemoEvent);
    property InputFileName: string read FInputFileName write SetInputFileName;
    property InputGroup: string read FInputGroup write SetInputGroup;
    property JsonInput: tStrings read GetJsonInput write SetJsonInput;
    property LeadingObject: string read GetLeadingObject write SetLeadingObject;
    property PNGFileName: string read FPNGFileName write SetPNGFileName;
    property PUmlFileName: string read FPUmlFileName write SetPUmlFileName;
    property PUmlOutput: tStrings read GetPUmlOutput write SetPUmlOutput;
    property LogList: tStrings read GetLogList write SetLogList;
    property ConverterLogFileName: string read FConverterLogFileName write SetConverterLogFileName;
    property SVGFileName: string read FSVGFileName write SetSVGFileName;
  end;

implementation

uses
  Vcl.Imaging.pngimage;

{$R *.dfm}

procedure TJson2PumlOutputFileFrame.CreateMemos (iCreateMemoProc: TJson2PumlCreateMemoEvent);
begin
  if Assigned (iCreateMemoProc) then
  begin
    iCreateMemoProc (InputPanel, 'InputMemo', InputLabel, FJsonInput, true, true);
    iCreateMemoProc (PumlTabSheet, 'PUmlMemo', nil, FPUmlOutput, false, true);
    iCreateMemoProc (LogFileTabSheet, 'LogFileMemo', nil, FLogList, false, true);
  end;

{$IFDEF SVGICONIMAGE}
  SVGIconImage := TSVGIconImage.Create (Self);

  SVGIconImage.Name := 'SVGIconImage';
  SVGIconImage.Parent := SVGScrollBox;
  SVGIconImage.AutoSize := false;
  SVGIconImage.Align := alClient;
  SVGIconImage.Stretch := false;
  SVGIconImage.Proportional := true;
{$ENDIF}
{$IFDEF SKIASVG}
  SkSvg := TSkSvg.Create (Self);

  SkSvg.Name := 'SkSvg';
  SkSvg.Parent := SVGScrollBox;
  SkSvg.Align := alClient;
{$ENDIF}
end;

function TJson2PumlOutputFileFrame.GetJsonInput: tStrings;
begin
  Result := FJsonInput;
end;

function TJson2PumlOutputFileFrame.GetLeadingObject: string;
begin
  Result := LeadingObjectEdit.Text;
end;

function TJson2PumlOutputFileFrame.GetPUmlOutput: tStrings;
begin
  Result := FPUmlOutput;
end;

function TJson2PumlOutputFileFrame.GetLogList: tStrings;
begin
  Result := FLogList;
end;

procedure TJson2PumlOutputFileFrame.SetInputFileName (const Value: string);
begin
  FInputFileName := Value;
  // InputLabel.Caption := Format ('JSON Input [%s]: %s', [InputGroup, InputFileName]);
  InputFileNameEdit.Text := InputFileName;
end;

procedure TJson2PumlOutputFileFrame.SetInputGroup (const Value: string);
begin
  FInputGroup := Value;
  // InputLabel.Caption := Format ('JSON Input [%s]: %s', [InputGroup, InputFileName]);
end;

procedure TJson2PumlOutputFileFrame.SetJsonInput (const Value: tStrings);
begin
  FJsonInput.Assign (Value);
end;

procedure TJson2PumlOutputFileFrame.SetLeadingObject (const Value: string);
begin
  LeadingObjectEdit.Text := Value;
end;

procedure TJson2PumlOutputFileFrame.SetPNGFileName (const Value: string);
var
  png: TPNGImage;
begin
  if FileExists (Value) then
    FPNGFileName := Value
  else
    FPNGFileName := '';
  PNGTabSheet.TabVisible := FileExists (Value);
  PNGFileNameEdit.Text := Value;
  if PNGTabSheet.TabVisible then
    ResultPageControl.ActivePage := PNGTabSheet;
  if PNGTabSheet.TabVisible then
  begin
    png := TPNGImage.Create;
    try
      png.LoadFromFile (Value);
      ResultImage.Picture.Graphic := png;
    finally
      png.Free;
    end;
  end;
end;

procedure TJson2PumlOutputFileFrame.SetPUmlFileName (const Value: string);
begin
  FPUmlFileName := Value;
  PUMLFileNameEdit.Text := Value;
end;

procedure TJson2PumlOutputFileFrame.SetPUmlOutput (const Value: tStrings);
begin
  FPUmlOutput.Assign (Value);
end;

procedure TJson2PumlOutputFileFrame.SetLogList (const Value: tStrings);
begin
  FLogList.Assign (Value);
end;

procedure TJson2PumlOutputFileFrame.SetConverterLogFileName (const Value: string);
begin
  FConverterLogFileName := Value;
  LogFileNameEdit.Text := Value;
end;

procedure TJson2PumlOutputFileFrame.SetSVGFileName (const Value: string);
begin
  if FileExists (Value) then
    FSVGFileName := Value
  else
    FSVGFileName := '';
  SVGTabSheet.TabVisible := FileExists (Value);
  SVGFileNameEdit.Text := Value;
{$IFDEF SVGICONIMAGE}
  if SVGTabSheet.TabVisible then
    ResultPageControl.ActivePage := SVGTabSheet;
  if SVGTabSheet.TabVisible then
  begin
    SVGIconImage.LoadFromFile (Value);
  end;
{$ENDIF}
{$IFDEF SKIASVG}
  if SVGTabSheet.TabVisible then
    ResultPageControl.ActivePage := SVGTabSheet;
  if SVGTabSheet.TabVisible then
  begin
    SkSvg.svg.Source := TFile.ReadAllText (Value);
  end;
{$ENDIF}
end;

end.
