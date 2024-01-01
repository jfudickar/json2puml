program json2pumlunittestsui;

uses
  Vcl.Forms,
  DUnitX.Loggers.GUI.Vcl {GUIVCLTestRunner},
  ut.Json2PumlBasePropertyList in 'ut.Json2PumlBasePropertyList.pas',
  uttJson2PumlFormatDefinition in 'uttJson2PumlFormatDefinition.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGUIVCLTestRunner, GUIVCLTestRunner);
  Application.Run;

end.
