namespace SilverBay.Integration.TestTools.Configuration;

using System.TestTools.TestRunner;
using SilverBay.Integration.API.V2;
using SilverBay.Integration.Purchases.Vendor;

codeunit 80402 APITestSuiteInstall
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
        SuiteName := 'SBSINT';

        if ALTestSuite.Get(SuiteName) then
            ALTestSuite.Delete(true);

        TestSuiteMgt.CreateTestSuite(SuiteName);
        ALTestSuite.Get(SuiteName);

        TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, StrSubstNo('%1|%2', Codeunit::APIV2VendorsE2E, Codeunit::IsCoupaVendorUTVendor));
        TestSuiteMgt.ChangeTestRunner(ALTestSuite, Codeunit::"Test Runner - Isol. Disabled");
    end;
}