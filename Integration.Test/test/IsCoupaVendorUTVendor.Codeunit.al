namespace SilverBay.Integration.Purchases.Vendor;

using Microsoft.Purchases.Vendor;
using System.TestLibraries.Utilities;

codeunit 80404 IsCoupaVendorUTVendor
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] IsCoupaVendor UT Vendor
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryPurchase: Codeunit "Library - Purchase";

    [Test]
    [HandlerFunctions('HandleConfirmIsCoupaVendorConfirmation')]
    procedure TestConfirmFieldChange()
    var
        Vendor: Record Vendor;
        IsCoupaVendor: Boolean;
    begin
        //[SCENARIO #0001] Confirm IsCoupaVendor field on vendor record

        //[GIVEN] Vendor
        this.CreateVendor(Vendor);

        //[WHEN] IsCoupaVendor field changed is confirmed
        IsCoupaVendor := not Vendor.SBSINTIsCoupaVendor;
        this.SetIsCoupaVendor(Vendor, IsCoupaVendor);

        //[THEN] new IsCoupaVendor value is persisted on Vendor record
        this.VerifyIsCoupaVendorOnVendor(Vendor."No.", IsCoupaVendor);
    end;

    [Test]
    [HandlerFunctions('HandleDenyIsCoupaVendorConfirmation')]
    procedure TestDenyFieldChange()
    var
        Vendor: Record Vendor;
        IsCoupaVendor: Boolean;
    begin
        //[SCENARIO #0002] Deny IsCoupaVendor field on vendor record

        //[GIVEN] Vendor
        this.CreateVendor(Vendor);

        //[WHEN] IsCoupaVendor field changed is denied
        IsCoupaVendor := not Vendor.SBSINTIsCoupaVendor;
        this.SetIsCoupaVendor(Vendor, IsCoupaVendor);

        //[THEN] new IsCoupaVendor value is NOT persisted on Vendor record
        this.VerifyIsCoupaVendorOnVendor(Vendor."No.", not IsCoupaVendor);
    end;

    #region UI Tests

    [Test]
    procedure TestUIOnVendorCard()
    var
        VendorCard: TestPage "Vendor Card";
    begin
        //[SCENARIO #0003] IsCoupaVendor field is visible and editable on vendor card

        // [GIVEN] Vendor card in edit mode
        this.EditVendorCard(VendorCard);

        //[THEN] IsCoupaVendor field is visible and editable on vendor card
        this.VerifyIsCoupaVendorUIOnVendorCard(VendorCard);
    end;

    [Test]
    [HandlerFunctions('HandleConfirmIsCoupaVendorConfirmation')]
    procedure TestAssignFieldOnVendorCard()
    var
        VendorCard: TestPage "Vendor Card";
        VendorNo: Code[20];
        IsCoupaVendor: Boolean;
    begin
        //[SCENARIO #0004] Assign IsCoupaVendor on vendor card

        // [GIVEN] Vendor card in edit mode
        this.EditVendorCard(VendorCard);

        //[GIVEN] IsCoupaVendor value is changed
        Evaluate(IsCoupaVendor, VendorCard.SBSINTIsCoupaVendor.Value());
        IsCoupaVendor := not IsCoupaVendor;

        //[WHEN] IsCoupaVendor value is specified on vendor card
        VendorNo := this.SetIsCoupaVendorOnVendorCard(VendorCard, IsCoupaVendor);

        //[THEN] new IsCoupaVendor value is persisted on Vendor record
        this.VerifyIsCoupaVendorOnVendor(VendorNo, IsCoupaVendor);
    end;

    #endregion UI Tests

    local procedure CreateVendor(var Vendor: Record Vendor)
    begin
        this.LibraryPurchase.CreateVendor(Vendor);
    end;

    local procedure SetIsCoupaVendor(var Vendor: Record Vendor; IsCoupaVendor: Boolean)
    begin
        Vendor.Validate(SBSINTIsCoupaVendor, IsCoupaVendor);
        Vendor.Modify();
    end;

    local procedure EditVendorCard(var VendorCard: TestPage "Vendor Card")
    begin
        VendorCard.OpenEdit();
    end;

    local procedure SetIsCoupaVendorOnVendorCard(var VendorCard: TestPage "Vendor Card"; IsCoupaVendor: Boolean) VendorNo: Code[20]
    begin
        VendorCard.SBSINTIsCoupaVendor.SetValue(IsCoupaVendor);
        VendorNo := VendorCard."No.".Value();
        VendorCard.Close();
    end;

    local procedure VerifyIsCoupaVendorUIOnVendorCard(var VendorCard: TestPage "Vendor Card")
    begin
        this.Assert.IsTrue(VendorCard.SBSINTIsCoupaVendor.Visible(), 'Visible');
        this.Assert.IsTrue(VendorCard.SBSINTIsCoupaVendor.Editable(), 'Editable');
        VendorCard.Close();
    end;

    local procedure VerifyIsCoupaVendorOnVendor(VendorNo: Code[20]; IsCoupaVendor: Boolean)
    var
        Vendor: Record Vendor;
        FieldOnTableTxt: Label '%1 on %2';
    begin
        Vendor.Get(VendorNo);
        this.Assert.AreEqual(
            IsCoupaVendor,
            Vendor.SBSINTIsCoupaVendor,
            StrSubstNo(
                FieldOnTableTxt,
                Vendor.FieldCaption(SBSINTIsCoupaVendor),
                Vendor.TableCaption())
            );
    end;

    [ConfirmHandler]
    procedure HandleConfirmIsCoupaVendorConfirmation(Question: Text; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [ConfirmHandler]
    procedure HandleDenyIsCoupaVendorConfirmation(Question: Text; var Reply: Boolean)
    begin
        Reply := false;
    end;
}