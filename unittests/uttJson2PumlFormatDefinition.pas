unit uttJson2PumlFormatDefinition;

interface

uses
  DUnitX.TestFramework, json2pumlconverterdefinition;

type

  [TestFixture]
  tJson2PumlFormatDefinitionTest = class
  private
    FFormatDefinition: tJson2PumlFormatDefinition;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Default/No matching format found', 'Unknown,,')]
    [TestCase('Format Name only', 'Empty,,Empty')]
    [TestCase('product', 'product,,A')]
    [TestCase('product.item', 'item,product,C')]
    [TestCase('productOffer', 'productOffer,,B')]
    [TestCase('productOffer.charge', 'productOffer.charge,,B')]
    [TestCase('bill.charge', 'charge,bill,')]
    procedure TestGetFormatByName (const iPropertyName, iParentPropertyName, iFormatName: string);
    property FormatDefinition: tJson2PumlFormatDefinition read FFormatDefinition write FFormatDefinition;
  end;

implementation

procedure tJson2PumlFormatDefinitionTest.Setup;
var
  SingleFormat: tJson2PumlSingleFormatDefinition;
begin
  FFormatDefinition := tJson2PumlFormatDefinition.Create;

  SingleFormat := tJson2PumlSingleFormatDefinition.Create;
  SingleFormat.FormatName := 'Empty';
  SingleFormat.IconColor := 'Red';
  FormatDefinition.Formats.AddDefinition (SingleFormat);

  SingleFormat := tJson2PumlSingleFormatDefinition.Create;
  SingleFormat.FormatName := 'A';
  SingleFormat.ObjectFilter.Itemlist.Add('product*');
  SingleFormat.ObjectFilter.Itemlist.Add('product*.*');
  SingleFormat.ObjectFilter.Itemlist.Add('-*Offer*');
  FormatDefinition.Formats.AddDefinition (SingleFormat);

  SingleFormat := tJson2PumlSingleFormatDefinition.Create;
  SingleFormat.FormatName := 'B';
  SingleFormat.ObjectFilter.Itemlist.Add('productOffer');
  SingleFormat.ObjectFilter.Itemlist.Add('productOffer.*');
  FormatDefinition.Formats.AddDefinition (SingleFormat);

  SingleFormat := tJson2PumlSingleFormatDefinition.Create;
  SingleFormat.FormatName := 'C';
  SingleFormat.ObjectFilter.Itemlist.Add('item');
  FormatDefinition.Formats.AddDefinition (SingleFormat);
//
//  SingleFormat := tJson2PumlSingleFormatDefinition.Create;
//  SingleFormat.FormatName := 'C';
//  FormatDefinition.Formats.AddDefinition (SingleFormat);

end;

procedure tJson2PumlFormatDefinitionTest.TearDown;
begin
  FFormatDefinition.Free;
end;

procedure tJson2PumlFormatDefinitionTest.TestGetFormatByName (const iPropertyName, iParentPropertyName,
  iFormatName: string);
var
  SingleFormat: tJson2PumlSingleFormatDefinition;
  Priority: Integer;
  FoundCondition: string;
begin
  SingleFormat := FormatDefinition.GetFormatByName (iPropertyName, iParentPropertyName, Priority, FoundCondition);
  Assert.isnotnull(SingleFormat);
  Assert.AreEqual(iFormatName, SingleFormat.FormatName, FoundCondition);
  Assert.IsNotEmpty(FoundCondition, 'FoundCondition');
  Assert.Pass(FoundCondition);
end;

initialization

TDUnitX.RegisterTestFixture (tJson2PumlFormatDefinitionTest);

end.
