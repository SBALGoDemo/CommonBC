namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;
using System.TestLibraries.Utilities;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Shipping;

codeunit 80100 UTSalesOrders
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] UT "Sales Order List"
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryInventory: Codeunit "Library - Inventory";
        WrongFieldValueErr: Label 'Incorrect field value for %1.', Comment = '%1=Property name';

    //     #region UI Tests
    [Test]
    procedure TestUIOnSalesOrderList()
    var
        SalesOrderList: TestPage "Sales Order List";
    begin
        //[SCENARIO #0001] Additional fields for Silver Bay requirements are visible on Sales Order List

        // [GIVEN] Sales Order List page
        this.ViewSalesOrderList(SalesOrderList);

        //[THEN] Additional fields are visible on the Sales Order List page
        this.VerifyUIOnSalesOrderList(SalesOrderList);
    end;

    [Test]
    procedure TestUIValuesOnSalesOrderList()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        ShippingAgent: Record "Shipping Agent";
        SalesOrderList: TestPage "Sales Order List";
    begin
        //[SCENARIO #0002] Additional fields for Silver Bay requirements display the expected values on Sales Order List

        // [GIVEN] Customer has non-blank City specified in address
        this.CreateCustomerWithAddress(Customer);

        // [GIVEN] Sales Order for the customer
        this.CreateSalesOrderForCustomerNo(SalesHeader, ShippingAgent, Customer."No.");

        // [GIVEN] Sales Order List page
        this.ViewSalesOrderList(SalesOrderList, SalesHeader);

        //[THEN] Ship-to City on the Sales Order List page has the expected Ship-to City value
        this.VerifyUIValuesOnSalesOrderList(SalesOrderList, ShippingAgent, Customer);
    end;
    //     #endregion UI Tests

    local procedure CreateCustomerWithAddress(var Customer: Record Customer)
    begin
        this.LibrarySales.CreateCustomer(Customer);
        this.LibrarySales.CreateCustomerAddress(Customer);
    end;

    local procedure CreateSalesOrderForCustomerNo(var SalesHeader: Record "Sales Header"; ShippingAgent: Record "Shipping Agent"; CustomerNo: Code[20])
    begin
        this.LibrarySales.CreateSalesOrderForCustomerNo(SalesHeader, CustomerNo);
        this.LibraryInventory.CreateShippingAgent(ShippingAgent);
        SalesHeader."Shipping Agent Code" := ShippingAgent.Code;
    end;

    local procedure ViewSalesOrderList(var SalesOrderList: TestPage "Sales Order List")
    begin
        SalesOrderList.OpenView();
    end;

    local procedure ViewSalesOrderList(var SalesOrderList: TestPage "Sales Order List"; SalesHeader: Record "Sales Header")
    begin
        SalesOrderList.OpenView();
        SalesOrderList.GoToRecord(SalesHeader);
    end;

    local procedure VerifyUIOnSalesOrderList(var SalesOrderList: TestPage "Sales Order List")
    begin
        this.Assert.IsTrue(SalesOrderList."Shipment Date".Visible(), 'Visible');
        this.Assert.IsTrue(SalesOrderList.SBSCOMShippingAgentCode.Visible(), 'Visible');
        this.Assert.IsTrue(SalesOrderList.SBSCOMShiptoCity.Visible(), 'Visible');
        this.Assert.IsTrue(SalesOrderList.SBSCOMShiptoCounty.Visible(), 'Visible');
        this.Assert.IsTrue(SalesOrderList.SBSCOMOrderDate.Visible(), 'Visible');
        this.Assert.IsTrue(SalesOrderList.SBSCOMCreatedByUser.Visible(), 'Visible');
        SalesOrderList.Close();
    end;

    local procedure VerifyUIValuesOnSalesOrderList(var SalesOrderList: TestPage "Sales Order List"; ShippingAgent: Record "Shipping Agent"; Customer: Record Customer)
    begin
        this.Assert.AreEqual(Format(WorkDate(), 0, '<Month>/<Day>/<Year4>'), SalesOrderList."Shipment Date".Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList."Shipment Date".Caption()));
        this.Assert.AreEqual(ShippingAgent.Code, SalesOrderList.SBSCOMShippingAgentCode.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList.SBSCOMShippingAgentCode.Caption()));
        this.Assert.AreEqual(Customer.City, SalesOrderList.SBSCOMShiptoCity.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList.SBSCOMShiptoCity.Caption()));
        this.Assert.AreEqual(Customer.County, SalesOrderList.SBSCOMShiptoCounty.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList.SBSCOMShiptoCounty.Caption()));
        this.Assert.AreEqual(Format(WorkDate(), 0, '<Month>/<Day>/<Year4>'), SalesOrderList.SBSCOMOrderDate.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList."Shipment Date".Caption()));
        this.Assert.AreEqual(Database.UserId(), SalesOrderList.SBSCOMCreatedByUser.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList.SBSCOMCreatedByUser.Caption()));
        SalesOrderList.Close();
    end;
}