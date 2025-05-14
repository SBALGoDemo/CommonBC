namespace SilverBay.Integration.TestTools.Configuration;

using System.TestTools.TestRunner;
using SilverBay.Integration.API.V2;

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
        SuiteName := 'API.V2';

        if ALTestSuite.Get(SuiteName) then
            ALTestSuite.Delete(true);

        TestSuiteMgt.CreateTestSuite(SuiteName);
        ALTestSuite.Get(SuiteName);

        TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, StrSubstNo('%1', Codeunit::APIV2VendorsE2E));
        TestSuiteMgt.ChangeTestRunner(ALTestSuite, Codeunit::"Test Runner - Isol. Disabled");
    end;
}