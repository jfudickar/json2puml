unit json2pumlAbout;

interface

uses
  WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, json2pumldefinition, Vcl.Imaging.pngimage;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormShow (Sender: TObject);
  private
    FCmdLineParameter: tJson2PumlCommandLineParameter;
    { Private declarations }
  public
    property CmdLineParameter: tJson2PumlCommandLineParameter read FCmdLineParameter write FCmdLineParameter;
    { Public declarations }
  end;

procedure ShowJson2PumlAbout (CmdLineParameter: tJson2PumlCommandLineParameter);

implementation

uses
  json2pumlconst, json2pumltools;

{$R *.dfm}

procedure ShowJson2PumlAbout (CmdLineParameter: tJson2PumlCommandLineParameter);
var
  AboutBox: TAboutBox;
begin
  AboutBox := TAboutBox.Create (nil);
  try
    AboutBox.CmdLineParameter := CmdLineParameter;
    AboutBox.ShowModal;
  finally
    AboutBox.Free;
  end;
end;

procedure TAboutBox.FormShow (Sender: TObject);
begin
  //
  ProductName.Caption := cJson2PumlApplicationTypeName[jatUI];
  Version.Caption := fileVersion;
  Copyright.Caption := FileCopyright;
  if assigned (CmdLineParameter) then
    CmdLineParameter.GenerateHelpScreen (Memo1.Lines)
end;

end.
