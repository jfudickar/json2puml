program json2pumlunittestsui;

uses
  Vcl.Forms,
  DUnitX.Loggers.GUI.Vcl {GUIVCLTestRunner},
  uttJson2PumlFormatDefinition in 'uttJson2PumlFormatDefinition.pas',
  utJson2PumlCurlUtils in 'utJson2PumlCurlUtils.pas',
  utJson2PumlFileDescriptionParameterList in 'utJson2PumlFileDescriptionParameterList.pas',
  utJson2PumlBasePropertyList in 'utJson2PumlBasePropertyList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGUIVCLTestRunner, GUIVCLTestRunner);
  Application.Run;

end.
