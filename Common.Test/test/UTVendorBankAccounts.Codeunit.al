namespace SilverBay.Common.Purchases.Vendor;

using Microsoft.Purchases.Vendor;
using System.TestLibraries.Utilities;

codeunit 80102 UTVendorBankAccounts
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] UT Vendor Bank Accounts
    end;

    var
        LibraryPurchase: Codeunit "Library - Purchase";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit "Library Assert";
        WrongFieldValueErr: Label 'Incorrect field value for %1.', Comment = '%1=Property name';

    [Test]
    procedure TestUIOnVendorBankAccountsList()
    var
        VendorBankAccountList: TestPage "Vendor Bank Account List";
    begin
        //[SCENARIO #80102-0004] Additional fields are visible on Vendor Bank Account List

        // [GIVEN] Vendor Bank Account List page
        this.ViewVendorBankAccountList(VendorBankAccountList);

        //[THEN] Our Account No. field is visible on the Vendor Bank Account List page
        this.VerifyUIOnVendorBankAccountList(VendorBankAccountList);
    end;

    //     #region UI Tests
    [Test]
    procedure TestUIOnVendorStatisticsFactBox()
    var
        VendorCard: TestPage "Vendor Card";
        VendorList: TestPage "Vendor List";
    begin
        //[SCENARIO #80102-0003] Additional fields are visible on Vendor Statistics FactBox

        // [GIVEN] Vendor List page
        this.ViewVendorList(VendorList);

        //[THEN] No. of Bank Accounts field is visible on the Vendor Statistics FactBox page
        this.VerifyUIOnVendorStatisticsFactBox(VendorList);

        // [GIVEN] Vendor Card page
        this.ViewVendorCard(VendorCard);

        //[THEN] No. of Bank Accounts field is visible on the Vendor Statistics FactBox page
        this.VerifyUIOnVendorStatisticsFactBox(VendorCard);
    end;

    [Test]
    procedure TestVendorBankAccountOurAccountNo()
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        //[SCENARIO #80102-0002] Our Account No. flowfield outputs the expected value for a vendor bank account

        // [GIVEN] A Vendor with one or more bank accounts and Our Account No. is blank
        this.CreateVendorWithBankAccounts(Vendor, VendorBankAccount);

        //[THEN] Our Account No. field in vendor bank account record(s) has the expected value
        this.VerifyVendorBankAccountOurAccountNo(Vendor, VendorBankAccount);

        // [GIVEN] A Vendor with one or more bank accounts and Our Account No. is NOT blank
        this.CreateVendorWithBankAccounts(Vendor, VendorBankAccount);
        Vendor."Our Account No." := this.LibraryUtility.GenerateRandomText(20);
        Vendor.Modify();

        //[THEN] Our Account No. field in vendor bank account record(s) has the expected value
        this.VerifyVendorBankAccountOurAccountNo(Vendor, VendorBankAccount);
    end;

    //     #region Tests
    [Test]
    procedure TestVendorNoOfBankAccounts()
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        //[SCENARIO #80102-0001] No. of Bank Accounts flowfield outputs the expected value for a vendor

        // [GIVEN] A Vendor with 0 bank accounts
        this.CreateVendor(Vendor);

        //[THEN] No. of Bank Accounts has the expected value
        this.VerifyVendorNoBankAccounts(Vendor, 0);

        // [GIVEN] A Vendor with one or more bank accounts
        this.CreateVendorWithBankAccounts(Vendor, VendorBankAccount);

        //[THEN] No. of Bank Accounts has the expected value
        this.VerifyVendorNoBankAccounts(Vendor, VendorBankAccount);
    end;
    //     #endregion UI Tests
    //     #endregion Tests

    local procedure CreateVendor(var Vendor: Record Vendor)
    begin
        this.LibraryPurchase.CreateVendor(Vendor);
    end;

    local procedure CreateVendorWithBankAccounts(var Vendor: Record Vendor; VendorBankAccount: Record "Vendor Bank Account")
    var
        i, MaxBankAccounts : Integer;
    begin
        MaxBankAccounts := Random(10);

        this.CreateVendor(Vendor);
        for i := 1 to MaxBankAccounts do
            this.LibraryPurchase.CreateVendorBankAccount(VendorBankAccount, Vendor."No.");
    end;

    local procedure VerifyUIOnVendorBankAccountList(var VendorBankAccountList: TestPage "Vendor Bank Account List")
    begin
        this.Assert.IsTrue(VendorBankAccountList.SBSCOMOurAccountNo.Visible(), 'Vendor Bank Account List - Visible');
        VendorBankAccountList.Close();
    end;

    local procedure VerifyUIOnVendorStatisticsFactBox(var VendorList: TestPage "Vendor List")
    begin
        this.Assert.IsTrue(VendorList.VendorStatisticsFactBox.SBSCOMNoOfBankAccounts.Visible(), 'Vendor List - Visible');
        VendorList.Close();
    end;

    local procedure VerifyUIOnVendorStatisticsFactBox(var VendorCard: TestPage "Vendor Card")
    begin
        this.Assert.IsTrue(VendorCard.VendorStatisticsFactBox.SBSCOMNoOfBankAccounts.Visible(), 'Vendor Card - Visible');
        VendorCard.Close();
    end;

    local procedure VerifyVendorBankAccountOurAccountNo(Vendor: Record Vendor; VendorBankAccount: Record "Vendor Bank Account")
    begin
        VendorBankAccount.Reset();
        VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
        VendorBankAccount.SetFilter(SBSCOMOurAccountNo, '<>%1', Vendor."Our Account No.");
        this.Assert.IsTrue(VendorBankAccount.IsEmpty(), StrSubstNo(this.WrongFieldValueErr, VendorBankAccount.FieldCaption(SBSCOMOurAccountNo)));
    end;

    local procedure VerifyVendorNoBankAccounts(Vendor: Record Vendor; NoBankAccounts: Integer)
    begin
        Vendor.CalcFields(SBSCOMNoOfBankAccounts);
        this.Assert.AreEqual(Vendor.SBSCOMNoOfBankAccounts, NoBankAccounts, StrSubstNo(this.WrongFieldValueErr, Vendor.FieldCaption(SBSCOMNoOfBankAccounts)));
    end;

    local procedure VerifyVendorNoBankAccounts(Vendor: Record Vendor; VendorBankAccount: Record "Vendor Bank Account")
    begin
        VendorBankAccount.Reset();
        VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
        this.VerifyVendorNoBankAccounts(Vendor, VendorBankAccount.Count());
    end;

    local procedure ViewVendorBankAccountList(var VendorBankAccountList: TestPage "Vendor Bank Account List")
    begin
        VendorBankAccountList.OpenView();
    end;

    local procedure ViewVendorCard(var VendorCard: TestPage "Vendor Card")
    begin
        VendorCard.OpenView();
    end;

    local procedure ViewVendorList(var VendorList: TestPage "Vendor List")
    begin
        VendorList.OpenView();
    end;
}