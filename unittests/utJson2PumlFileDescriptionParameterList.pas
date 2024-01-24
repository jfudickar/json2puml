unit utJson2PumlFileDescriptionParameterList;

interface

uses
  DUnitX.TestFramework, json2pumldefinition, json2pumlbasedefinition;

type

  [TestFixture]
  tJson2PumlFileDescriptionParameterListTest = class
  private
    FParameterList: tJson2PumlFileDescriptionParameterList;

    procedure AddParameter (iName: string; iDisplayName: string = ''; iMandatory: boolean = false;
      iMandatoryGroup: string = ''; iRegularExpresson: string = ''; iDefault: string = '');
    procedure TestValidatedInputParameter (iExpectedResult: boolean; iParameter1, iParameter2, iParameter3, iParameter4,
      iParameter5: string);
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Category('Simple')]
    [TestCase('id=1 abc=1', 'true,id=1,abc=1,,')]
    [TestCase('id=1 z=1', 'true,id=1,z=1,,')]
    [TestCase('id=1 code=12345', 'true,id=1,code=12345,,')]
    [TestCase('id=1 code=1', 'false,id=1,code=1,,')]
    [TestCase('id=1 x=1', 'true,id=1,x=1,,')]
    [TestCase('id=1 x=a', 'false,id=1,x=a,,')]
    [TestCase('id=1 x', 'true,id=1,x,,')]
    [TestCase('id', 'false,id,,,')]
    [TestCase('<empty>', 'false,,,,')]
    procedure TestValidatedInputParameterSimple (iExpectedResult: boolean;
      iParameter1, iParameter2, iParameter3, iParameter4, iParameter5: string);
    [Category('MandatoryGroup 1')]
    [TestCase('id=1 id2=1 id2=3 id4=123', 'true,id=1,id2=1,id3=1,id4=123')]
    [TestCase('id=1 id4=1', 'false,id=1,id4=1,,')]
    [TestCase('id=1 id2=1 id2=3', 'true,id=1,id2=1,id3=1,')]
    [TestCase('id=1 id3=1', 'true,id=1,id3=1,,')]
    [TestCase('id=1 id2=1', 'true,id=1,id2=1,,')]
    [TestCase('id=1', 'false,id=1,,,')]
    [TestCase('id', 'false,id,,,')]
    [TestCase('<empty>', 'false,,,,')]
    procedure TestValidatedInputParameterMandatoryGroup1(iExpectedResult: boolean; iParameter1, iParameter2, iParameter3,
        iParameter4, iParameter5: string);
    [Category('MandatoryGroup 2')]
    [TestCase('last=a', 'true,last=a,,')]
    [TestCase('first=a', 'false,first=a,,')]
    [TestCase('id2=1 last=a', 'true,id2=1,last=a,,')]
    [TestCase('id2=1 first=a', 'true,id2=1,first=a,,')]
    [TestCase('id2=1', 'false,id2=1,,,')]
    [TestCase('<empty>', 'false,,,,')]
    procedure TestValidatedInputParameterMandatoryGroup2(iExpectedResult: boolean; iParameter1, iParameter2, iParameter3,
        iParameter4, iParameter5: string);
    property ParameterList: tJson2PumlFileDescriptionParameterList read FParameterList write FParameterList;
  end;

implementation

uses
  System.SysUtils, System.Classes;

type
  tJson2PumlBasePropertyListAccess = class(tJson2PumlBasePropertyList);

procedure tJson2PumlFileDescriptionParameterListTest.AddParameter (iName: string; iDisplayName: string = '';
  iMandatory: boolean = false; iMandatoryGroup: string = ''; iRegularExpresson: string = ''; iDefault: string = '');
var
  Parameter: tJson2PumlFileDescriptionParameterDefinition;
begin
  Parameter := tJson2PumlFileDescriptionParameterDefinition.Create;
  Parameter.name := iName;
  Parameter.DisplayName := iDisplayName;
  Parameter.Mandatory := iMandatory;
  Parameter.MandatoryGroup := iMandatoryGroup;
  Parameter.RegularExpression := iRegularExpresson;
  Parameter.DefaultValue := iDefault;
  FParameterList.AddBaseObject (Parameter);
end;

procedure tJson2PumlFileDescriptionParameterListTest.Setup;

begin
  FParameterList := tJson2PumlFileDescriptionParameterList.Create;
end;

procedure tJson2PumlFileDescriptionParameterListTest.TearDown;
begin
  FParameterList.Free;
end;

procedure tJson2PumlFileDescriptionParameterListTest.TestValidatedInputParameter (iExpectedResult: boolean;
  iParameter1, iParameter2, iParameter3, iParameter4, iParameter5: string);

var
  InputCurlParameterList: tJson2PumlCurlParameterList;
  ValidateResult: boolean;
  ErrorList: TStringList;
  s: string;
  procedure AddParameter (iParameter: string);
  var
    name, Value: string;
    List: TArray<string>;
  begin
    if iParameter.IsEmpty then
      Exit;
    List := iParameter.Split (['=']);
    name := List[0];
    if Length (List) > 1 then
      Value := List[1]
    else
      Value := '';
    InputCurlParameterList.AddParameter (name, Value);
  end;

begin
  InputCurlParameterList := tJson2PumlCurlParameterList.Create;
  AddParameter (iParameter1);
  AddParameter (iParameter2);
  AddParameter (iParameter3);
  AddParameter (iParameter4);
  AddParameter (iParameter5);
  ErrorList := TStringList.Create;
  try
    ValidateResult := ParameterList.ValidatedInputParameter (InputCurlParameterList, ErrorList);
    Assert.AreEqual (iExpectedResult, ValidateResult);
    for s in ErrorList do
      TDUnitX.CurrentRunner.Log (TLogLevel.Information, s);
  finally
    ErrorList.Free;
  end;
end;

procedure tJson2PumlFileDescriptionParameterListTest.TestValidatedInputParameterSimple (iExpectedResult: boolean;
  iParameter1, iParameter2, iParameter3, iParameter4, iParameter5: string);
begin
  AddParameter ('id', 'Identifier', true, '', '^[0-9]+$');
  AddParameter ('x', '', false, '', '^[0-9]+$');
  AddParameter ('z', '', false, '', '');
  AddParameter ('code', '', false, '', '^[0-9]{5}$');
  TestValidatedInputParameter(iExpectedResult, iParameter1, iParameter2, iParameter3, iParameter4, iParameter5);
end;

procedure tJson2PumlFileDescriptionParameterListTest.TestValidatedInputParameterMandatoryGroup1(iExpectedResult:
    boolean; iParameter1, iParameter2, iParameter3, iParameter4, iParameter5: string);
begin
  AddParameter ('id', 'Identifier', true, '', '^[0-9]+$');
  AddParameter ('id2', 'Identifier2', true, 'a', '^[0-9]+$');
  AddParameter ('id3', 'Identifier3', true, 'a', '^[0-9]+$');
  TestValidatedInputParameter(iExpectedResult, iParameter1, iParameter2, iParameter3, iParameter4, iParameter5);
end;

procedure tJson2PumlFileDescriptionParameterListTest.TestValidatedInputParameterMandatoryGroup2(iExpectedResult:
    boolean; iParameter1, iParameter2, iParameter3, iParameter4, iParameter5: string);
begin
  AddParameter ('id2', 'Identifier2', true, 'a', '^[0-9]+$');
  AddParameter ('id3', 'Identifier3', true, 'a', '^[0-9]+$');
  AddParameter ('first', 'First Name', true, 'b');
  AddParameter ('last', 'Last Name', true, 'a,b');
  TestValidatedInputParameter(iExpectedResult, iParameter1, iParameter2, iParameter3, iParameter4, iParameter5);
end;

initialization

TDUnitX.RegisterTestFixture (tJson2PumlFileDescriptionParameterListTest);

end.
