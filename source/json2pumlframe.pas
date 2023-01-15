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

unit json2pumlframe;

interface

{$DEFINE SVGICONIMAGE}

uses
  {$IFDEF SVGICONIMAGE}
  SVGIconImage,
  {$ENDIF}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TJson2PumlSingleFileFrameCreateMemoEvent = function(iParentControl: TWinControl; iName: string; iLabel: TLabel;
    var oMemoLines: TStrings; iUseHighlighter: Boolean) :TWinControl of object;

  TJson2PumlSingleFileFrame = class(TFrame)
    BottomPanel: TPanel;
    InputLabel: TLabel;
    InputPanel: TPanel;
    Label1: TLabel;
    LeadingObjectEdit: TEdit;
    NamePanel: TPanel;
    Panel1: TPanel;
    PNGFileNameEdit: TEdit;
    PNGTabSheet: TTabSheet;
    PUMLFileNameEdit: TEdit;
    PumlTabSheet: TTabSheet;
    ResultImage: TImage;
    ResultPageControl: TPageControl;
    PNGScrollBox: TScrollBox;
    Splitter1: TSplitter;
    LogFileTabSheet: TTabSheet;
    LogFileNameEdit: TEdit;
    SVGTabSheet: TTabSheet;
    SVGScrollBox: TScrollBox;
    SVGFileNameEdit: TEdit;
  private
    FInputFileName: string;
    FInputGroup: string;
    FJsonInput: TStrings;
    FPNGFileName: string;
    FPUmlFileName: string;
    FPUmlOutput: TStrings;
    FLogList: TStrings;
    FSVGFileName: string;
  {$IFDEF SVGICONIMAGE}
    SVGIconImage: TSVGIconImage;
  {$ENDIF}
    function GetJsonInput: TStrings;
    function GetLeadingObject: string;
    function GetPUmlOutput: TStrings;
    function GetLogList: TStrings;
    procedure SetInputFileName (const Value: string);
    procedure SetInputGroup (const Value: string);
    procedure SetJsonInput (const Value: TStrings);
    procedure SetLeadingObject (const Value: string);
    procedure SetPNGFileName (const Value: string);
    procedure SetPUmlFileName (const Value: string);
    procedure SetPUmlOutput (const Value: TStrings);
    procedure SetLogList (const Value: TStrings);
    procedure SetSVGFileName (const Value: string);
  public
    procedure CreateMemos (iCreateMemoProc: TJson2PumlSingleFileFrameCreateMemoEvent);
    property InputFileName: string read FInputFileName write SetInputFileName;
    property InputGroup: string read FInputGroup write SetInputGroup;
    property JsonInput: TStrings read GetJsonInput write SetJsonInput;
    property LeadingObject: string read GetLeadingObject write SetLeadingObject;
    property PNGFileName: string read FPNGFileName write SetPNGFileName;
    property PUmlFileName: string read FPUmlFileName write SetPUmlFileName;
    property PUmlOutput: TStrings read GetPUmlOutput write SetPUmlOutput;
    property LogList: TStrings read GetLogList write SetLogList;
    property SVGFileName: string read FSVGFileName write SetSVGFileName;
  end;

implementation

uses Vcl.Imaging.pngimage;

{$R *.dfm}

procedure TJson2PumlSingleFileFrame.CreateMemos (iCreateMemoProc: TJson2PumlSingleFileFrameCreateMemoEvent);
begin
  if Assigned (iCreateMemoProc) then
  begin
    iCreateMemoProc (InputPanel, 'InputMemo', InputLabel, FJsonInput, true);
    iCreateMemoProc (PumlTabSheet, 'PUmlMemo', nil, FPUmlOutput, false);
    iCreateMemoProc (LogFileTabSheet, 'LogFileMemo', nil, FLogList, false);
  end;

  {$IFDEF SVGICONIMAGE}
  SVGIconImage := TSVGIconImage.Create(Self);

  SVGIconImage.Name := 'SVGIconImage';
  SVGIconImage.Parent := SVGScrollBox;
  SVGIconImage.AutoSize := False;
  SVGIconImage.Align := alClient;
  SVGIconImage.Stretch := true;
  SVGIconImage.Proportional := true;
  {$ENDIF}

end;

function TJson2PumlSingleFileFrame.GetJsonInput: TStrings;
begin
  Result := FJsonInput;
end;

function TJson2PumlSingleFileFrame.GetLeadingObject: string;
begin
  Result := LeadingObjectEdit.Text;
end;

function TJson2PumlSingleFileFrame.GetPUmlOutput: TStrings;
begin
  Result := FPUmlOutput;
end;

function TJson2PumlSingleFileFrame.GetLogList: TStrings;
begin
  Result := FLogList;
end;

procedure TJson2PumlSingleFileFrame.SetInputFileName (const Value: string);
begin
  FInputFileName := Value;
  InputLabel.Caption := Format ('JSON Input [%s]: %s', [InputGroup, InputFileName]);
end;

procedure TJson2PumlSingleFileFrame.SetInputGroup (const Value: string);
begin
  FInputGroup := Value;
  InputLabel.Caption := Format ('JSON Input [%s]: %s', [InputGroup, InputFileName]);
end;

procedure TJson2PumlSingleFileFrame.SetJsonInput (const Value: TStrings);
begin
  FJsonInput.Assign (Value);
end;

procedure TJson2PumlSingleFileFrame.SetLeadingObject (const Value: string);
begin
  LeadingObjectEdit.Text := Value;
end;

procedure TJson2PumlSingleFileFrame.SetPNGFileName (const Value: string);
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

procedure TJson2PumlSingleFileFrame.SetPUmlFileName (const Value: string);
begin
  FPUmlFileName := Value;
  PUMLFileNameEdit.Text := Value;
end;

procedure TJson2PumlSingleFileFrame.SetPUmlOutput (const Value: TStrings);
begin
  FPUmlOutput.Assign (Value);
end;

procedure TJson2PumlSingleFileFrame.SetLogList (const Value: TStrings);
begin
  FLogList.Assign (Value);
end;

procedure TJson2PumlSingleFileFrame.SetSVGFileName (const Value: string);
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
    SVGIconImage.LoadFromFile(Value);
  end;
  {$ENDIF}
end;

end.
