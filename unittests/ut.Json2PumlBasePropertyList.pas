unit ut.Json2PumlBasePropertyList;

interface

uses
  DUnitX.TestFramework, json2pumldefinition, json2pumlbasedefinition;

type

  [TestFixture]
  tJson2PumlBasePropertyListTest = class
  private
    FPropertyList: tJson2PumlBasePropertyList;

    procedure IndexOfProperty(iPropertyName, iParentPropertyName, iParentObjectType: string; iUseMatch: boolean; const
        iResultName: String);

  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    [Category('Exact')]
    [TestCase('x', 'x,,<NF>')]
    [TestCase('product', 'product,,product')]
    [TestCase('productList', 'productList,,<NF>')]
    [TestCase('order', 'order,,order=value')]
    [TestCase('test.order', 'order,test,order=value')]
    [TestCase('product.price', 'price,product,product.price')]
    [TestCase('product.item', 'item,product,product.item')]
    [TestCase('order.item', 'item,order,item')]
    [TestCase('amount', 'amount,,<NF>')]
    [TestCase('product.amount', 'amount,product,product.amount')]
    [TestCase('charge', 'charge,,<NF>')]
    [TestCase('product.charge', 'charge,product,<NF>')]
    [TestCase('productlist.amount', 'amount,productlist,<NF>')]
    procedure TestIndexOfPropertyExact(const iPropertyName, iParentPropertyName, iResultName: String);
    [Category('Match')]
    [TestCase('x', 'x,,<NF>')]
    [TestCase('product', 'product,,product')]
    [TestCase('productList', 'productList,,<NF>')]
    [TestCase('order', 'order,,order=value')]
    [TestCase('test.order', 'order,test,order=value')]
    [TestCase('product.price', 'price,product,product.price')]
    [TestCase('product.item', 'item,product,product.item')]
    [TestCase('order.item', 'item,order,item')]
    [TestCase('amount', 'amount,,<NF>')]
    [TestCase('product.amount', 'amount,product,product.amount')]
    [TestCase('charge', 'charge,,<NF>')]
    [TestCase('product.charge', 'charge,product,product*.*')]
    [TestCase('productlist.amount', 'amount,productlist,<NF>')]
    [TestCase('productOffering', 'productOffering,,<NF>')]
    procedure TestIndexOfPropertyMatch(const iPropertyName, iParentPropertyName, iResultName: String);

    property PropertyList: tJson2PumlBasePropertyList read FPropertyList
      write FPropertyList;
  end;

implementation

type
  tJson2PumlBasePropertyListAccess = class(tJson2PumlBasePropertyList);

procedure tJson2PumlBasePropertyListTest.IndexOfProperty(iPropertyName, iParentPropertyName, iParentObjectType: string;
    iUseMatch: boolean; const iResultName: String);
Var
  Index: Integer;
  ResultName : String;
  FoundCondition: String;
begin
  PropertyList.UseMatch := iUseMatch;
  Index := tJson2PumlBasePropertyListAccess(PropertyList)
    .IndexOfProperty(iPropertyName, iParentPropertyName, iParentObjectType,
    FoundCondition);
  if Index >= 0 then
    ResultName := PropertyList[Index]
  else
    ResultName := '<NF>';
  Assert.AreEqual(iResultName, ResultName, FoundCondition);
  Assert.IsNotEmpty(FoundCondition, 'FoundCondition');
  Assert.Pass(FoundCondition);
end;

procedure tJson2PumlBasePropertyListTest.Setup;
begin
  FPropertyList := tJson2PumlBasePropertyList.Create;
  FPropertyList.ConfigurationPropertyName := 'Unittest';
  FPropertyList.ItemList.Add('product*=value');
  FPropertyList.ItemList.Add('-productList');
  FPropertyList.ItemList.Add('product');
  FPropertyList.ItemList.Add('productParameter');
  FPropertyList.ItemList.Add('order=value');
  FPropertyList.ItemList.Add('product.amount');
  FPropertyList.ItemList.Add('product*.*');
  FPropertyList.ItemList.Add('product.price');
  FPropertyList.ItemList.Add('-product*.a*');
  FPropertyList.ItemList.Add('-*Offer*');
  FPropertyList.ItemList.Add('item');
  FPropertyList.ItemList.Add('product.item');
  FPropertyList.ItemList.Add('bill');
  FPropertyList.ItemList.Add('');
end;

procedure tJson2PumlBasePropertyListTest.TearDown;
begin
  FPropertyList.Free;
end;

procedure tJson2PumlBasePropertyListTest.TestIndexOfPropertyExact(const iPropertyName, iParentPropertyName,
    iResultName: String);
begin
  IndexOfProperty(iPropertyName, iParentPropertyName,'', False, iResultName);
end;

procedure tJson2PumlBasePropertyListTest.TestIndexOfPropertyMatch(const iPropertyName, iParentPropertyName,
    iResultName: String);
begin
  IndexOfProperty(iPropertyName, iParentPropertyName,'', True, iResultName);
end;

initialization

TDUnitX.RegisterTestFixture(tJson2PumlBasePropertyListTest);

end.
