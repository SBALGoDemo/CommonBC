namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;
using System.TestLibraries.Utilities;
using Microsoft.Sales.Customer;

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

        //[THEN] Ship-to City field is visible on the Sales Order List page
        this.VerifyUIOnSalesOrderList(SalesOrderList);
    end;

    [Test]
    procedure TestUIValuesOnSalesOrderList()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesOrderList: TestPage "Sales Order List";
    begin
        //[SCENARIO #0002] Additional fields for Silver Bay requirements display the expected values on Sales Order List

        // [GIVEN] Customer has non-blank City specified in address
        this.CreateCustomerWithAddress(Customer);

        // [GIVEN] Sales Order for the customer
        this.CreateSalesOrderForCustomerNo(SalesHeader, Customer."No.");

        // [GIVEN] Sales Order List page
        this.ViewSalesOrderList(SalesOrderList, SalesHeader);

        //[THEN] Ship-to City on the Sales Order List page has the expected Ship-to City value
        this.VerifyUIValuesOnSalesOrderList(SalesOrderList, Customer);
    end;
    //     #endregion UI Tests

    local procedure CreateCustomerWithAddress(var Customer: Record Customer)
    begin
        this.LibrarySales.CreateCustomer(Customer);
        this.LibrarySales.CreateCustomerAddress(Customer);
    end;

    local procedure CreateSalesOrderForCustomerNo(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        this.LibrarySales.CreateSalesOrderForCustomerNo(SalesHeader, CustomerNo);
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
        this.Assert.IsTrue(SalesOrderList.SBSCOMShiptoCity.Visible(), 'Visible');
        SalesOrderList.Close();
    end;

    local procedure VerifyUIValuesOnSalesOrderList(var SalesOrderList: TestPage "Sales Order List"; Customer: Record Customer)
    begin
        this.Assert.AreEqual(Customer.City, SalesOrderList.SBSCOMShiptoCity.Value, StrSubstNo(this.WrongFieldValueErr, SalesOrderList.SBSCOMShiptoCity.Caption()));
        SalesOrderList.Close();
    end;
}