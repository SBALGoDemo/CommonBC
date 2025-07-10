namespace SilverBay.Common.TestTools.Configuration;

using System.TestTools.TestRunner;
using SilverBay.Common.Purchases.Vendor;
using SilverBay.Common.Sales.Document;

codeunit 80101 CommonTestSuiteInstall
{
    Access = Internal;
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        this.SetupTestSuite();
    end;

    local procedure SetupTestSuite()
    var
        ALTestSuite: Record "AL Test Suite";
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
        SuiteName: Code[10];
    begin
        SuiteName := 'SBSCOM';

        if ALTestSuite.Get(SuiteName) then
            ALTestSuite.Delete(true);

        TestSuiteMgt.CreateTestSuite(SuiteName);
        ALTestSuite.Get(SuiteName);

        TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, StrSubstNo('%1|%2', Codeunit::UTSalesOrders, Codeunit::UTVendorBankAccounts));
        TestSuiteMgt.ChangeTestRunner(ALTestSuite, Codeunit::"Test Runner - Isol. Disabled");
    end;
}