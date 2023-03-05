unit json2pumlvcltools;

interface

uses
  Vcl.ActnList, Vcl.Controls, Vcl.StdCtrls, System.Classes;

type
  tJson2PumlPage = (jpExeute, jpOutput, jpDefinitionFile,jpParameterFile, jpInputList, jpCurlAuthenticationFile, jpCurlParameterFile,
    jpOptionFile, jpGlobalConfig);
  TJson2PumlCreateMemoEvent = function(iParentControl: TWinControl; iName: string; iLabel: TLabel;
    var oMemoLines: TStrings; iUseHighlighter, iReadOnly: Boolean): TWinControl of object;
  TJson2PumlGetConfigFileName = function(iPage: tJson2PumlPage): string of object;
  TJson2PumlSetConfigFileName = procedure(iPage: tJson2PumlPage; iFileName: string) of object;
  TJson2PumlLoadConfigFileName = procedure(iPage: tJson2PumlPage; iFileName: string) of object;

const
  cJson2PumlPageTitle: array [tJson2PumlPage] of string = ('Exeute', 'Output Files', 'Definition File', 'Parameter File', 'Input List File', 'Curl Authentication File',
    'Curl Parameter File', 'Option File', 'Global Configuration');
  cJson2PumlPageShortCutText: array [tJson2PumlPage] of string = ('Ctrl+F1', 'Ctrl+F2', 'Ctrl+F3', 'Ctrl+F4', 'Ctrl+F5',
    'Ctrl+F6', 'Ctrl+F7', 'Ctrl+F8', 'Ctrl+F9');
  cJson2PumlPageConfig: array [tJson2PumlPage] of Boolean = (false, false, true, true, true, true, true, true, true);

type
  tJson2PumlPageHelper = record helper for tJson2PumlPage
    procedure SetToShowAction (iAction: TAction);
    function ShortCutText: string;
    function Title: string;
    function IsConfig: Boolean;
    function TabSheetCaption: string;
  end;

implementation

uses
  System.SysUtils, Vcl.Menus;

function tJson2PumlPageHelper.IsConfig: Boolean;
begin
  Result := cJson2PumlPageConfig[self];
end;

procedure tJson2PumlPageHelper.SetToShowAction (iAction: TAction);
begin
  if not Assigned (iAction) then
    Exit;
  iAction.Caption := Format ('Show %s', [Title]);
  iAction.ShortCut := TextToShortCut (ShortCutText);
end;

function tJson2PumlPageHelper.ShortCutText: string;
begin
  Result := cJson2PumlPageShortCutText[self];
end;

function tJson2PumlPageHelper.TabSheetCaption: string;
begin
  Result := Format ('%s (%s)', [Title, ShortCutText]);
end;

function tJson2PumlPageHelper.Title: string;
begin
  Result := cJson2PumlPageTitle[self];
end;

end.
