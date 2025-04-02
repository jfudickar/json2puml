unit utJson2PumlPuml;

interface

uses
  DUnitX.TestFramework,
  json2pumlpuml,
  System.SysUtils;

type
  [TestFixture]
  TPumlIdentifierCalculatorTests = class(TObject)
  private
    FCalculator: tPumlIdentifierCalculator;
  public
    constructor Create;
    destructor Destroy; override;
    [Test]
    [TestCase('abc', 'abc, abc')]
    [TestCase('abc', 'abc, abc')]
    [TestCase('Abc', 'abc1, Abc')]
    [TestCase('abc', 'abc, abc')]
    [TestCase('abc<', 'abc_, abc<')]
    [TestCase('abc|', 'abc_1, abc|')]
    [TestCase('abc$', 'abc_2, abc$')]
    [TestCase('abc#', 'abc_3, abc#')]
    [TestCase('abc#', 'abc_3, abc#')]
    [TestCase('abc|', 'abc_1, abc|')]
    procedure TestCalculateIdentifier_Parameterized(const AExpectedIdentifier, AInputIdentifier: string);
    [Test]
    [TestCase('abc', 'abc, abc')]
    [TestCase('abc', 'abc, abc')]
    [TestCase('Abc', 'abc1, Abc')]
    [TestCase('abc', 'abc, abc')]
    [TestCase('abc<', 'abc_, abc<')]
    [TestCase('abc|', 'abc_1, abc|')]
    [TestCase('abc$', 'abc_2, abc$')]
    [TestCase('abc#', 'abc_3, abc#')]
    [TestCase('abc#', 'abc_3, abc#')]
    [TestCase('abc|', 'abc_1, abc|')]
    [TestCase('abc.a', 'a_abc, abc,a')]
    [TestCase('abc.a', 'a_abc, abc,a')]
    [TestCase('abc<.a', 'a_abc_, abc<,a')]
    [TestCase('abc|.a', 'a_abc_1, abc|,a')]
    procedure TestPumlObject_PumlIdentifier(const AExpectedIdentifier: string; AObjectIdent : String; AObjectType : String);
  end;

implementation

uses
  DUnitX.Assert;

constructor TPumlIdentifierCalculatorTests.Create;
begin
  inherited Create;
  FCalculator := tPumlIdentifierCalculator.Create;
end;

destructor TPumlIdentifierCalculatorTests.Destroy;
begin
  FCalculator.Free;
  inherited Destroy;
end;

procedure TPumlIdentifierCalculatorTests.TestCalculateIdentifier_Parameterized(const AExpectedIdentifier,
    AInputIdentifier: string);
var
  ResultIdentifier: string;
begin
  ResultIdentifier := FCalculator.CalculateIdentifier(AInputIdentifier.trim);
  Assert.AreEqual(AExpectedIdentifier.trim, ResultIdentifier.trim,
    Format('Input: "%s", Expected: "%s", Actual: "%s"', [AInputIdentifier.trim, AExpectedIdentifier.trim, ResultIdentifier]));
end;

procedure TPumlIdentifierCalculatorTests.TestPumlObject_PumlIdentifier(const AExpectedIdentifier: string; AObjectIdent
    : String; AObjectType : String);
var pumlobject : TPumlObject;
begin
  pumlobject := TPumlObject.Create;
  try
    PumlObject.ObjectIdent := AObjectIdent;
    pumlobject.IdentifyObjectsByTypeAndIdent := not AObjectType.IsEmpty;
    if not AObjectType.IsEmpty then
      PumlObject.ObjectType := AObjectType;
    Assert.AreEqual(AExpectedIdentifier.trim, pumlobject.PlantUmlIdent.trim,
      Format('Input: "%s/%s", Expected: "%s", Actual: "%s"', [AObjectIdent, AObjectType, AExpectedIdentifier.trim, pumlobject.PlantUmlIdent]));
  finally
    pumlObject.Free
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TPumlIdentifierCalculatorTests);

end.
