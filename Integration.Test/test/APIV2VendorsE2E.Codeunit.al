namespace SilverBay.Integration.API.V2;

using Microsoft.Purchases.Vendor;
using System.IO;
using Microsoft.Bank.BankAccount;
#if CLEANEXCLUDEAPIV2
using Microsoft.Foundation.PaymentTerms;
using Microsoft.API.V2;
#endif

/// <summary>
/// Created as a clone of MS standard codeunit 139803 "APIV2 - Vendors E2E"
/// from https://github.com/microsoft/ALAppExtensions/tree/main/Apps/W1/APIV2 
/// as of this commit: https://github.com/microsoft/ALAppExtensions/commit/2be607112452c135c5a61a9681f03a524b8ed04d
/// </summary>
codeunit 80400 APIV2VendorsE2E
{
    // version Test,ERM,W1,All

    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Graph] [Vendor]
    end;

    var
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit "Assert";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        IsInitialized: Boolean;
        ServiceNameTxt: Label 'vendors';
        VendorKeyPrefixTxt: Label 'GRAPHVENDOR';
        EmptyJSONErr: Label 'The JSON should not be blank.';
        WrongPropertyValueErr: Label 'Incorrect property value for %1.', Comment = '%1=Property name';

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;

    [Test]
    procedure TestGetSimpleVendor()
    var
        Vendor: Record "Vendor";
        ResponseText: Text;
        TargetURL: Text;
    begin
        // [SCENARIO 201343] User can get a simple vendor with a GET request to the service.
        Initialize();

        // [GIVEN] A vendor exists in the system.
#if CLEANEXCLUDEAPIV2
        CreateSimpleVendor(Vendor);
#else
        this.CreateSimpleVendor(Vendor, true);
#endif


        // [WHEN] The user makes a GET request for a given Vendor.
        TargetURL := LibraryGraphMgt.CreateTargetURL(Vendor.SystemId, Page::APIV2Vendors, ServiceNameTxt);
        LibraryGraphMgt.GetFromWebService(ResponseText, TargetURL);

        // [THEN] The response text contains the vendor information.
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, Vendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, Vendor, true);
#endif
    end;

    [Test]
    procedure TestCreateSimpleVendor()
    var
        Vendor: Record "Vendor";
        TempVendor: Record "Vendor" temporary;
        VendorJSON: Text;
        ResponseText: Text;
        TargetURL: Text;
    begin
        // [SCENARIO 201343] Create an vendor through a POST method and check if it was created
        Initialize();

        // [GIVEN] The user has constructed a simple vendor JSON object to send to the service.
#if CLEANEXCLUDEAPIV2
        VendorJSON := GetSimpleVendorJSON(TempVendor);
#else
        VendorJSON := this.GetSimpleVendorJSON(TempVendor, true);
#endif

        // [WHEN] The user posts the JSON to the service.
        TargetURL := LibraryGraphMgt.CreateTargetURL('', Page::APIV2Vendors, ServiceNameTxt);
        LibraryGraphMgt.PostToWebService(TargetURL, VendorJSON, ResponseText);

        // [THEN] The response text contains the vendor information.
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, TempVendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, TempVendor, true);
#endif

        // [THEN] The vendor has been created in the database.        
        Vendor.Get(TempVendor."No.");
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, Vendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, Vendor, true);
#endif
    end;

    [Test]
    procedure TestCreateVendorWithTemplate()
    var
        ConfigTmplSelectionRules: Record "Config. Tmpl. Selection Rules";
        TempVendor: Record "Vendor" temporary;
        Vendor: Record "Vendor";
#if CLEANEXCLUDEAPIV2
        PaymentTerms: Record "Payment Terms";
#endif
        PaymentMethod: Record "Payment Method";
        RequestBody: Text;
        ResponseText: Text;
        TargetURL: Text;
#if not CLEANEXCLUDEAPIV2        
        TemplateOurAccountNo: Text[20];
#endif
    begin
        // [FEATURE] [Template]
        // [SCENARIO 201343] User can create a new vendor and have the system apply a template.
        Initialize();
#if CLEANEXCLUDEAPIV2
        LibraryInventory.CreatePaymentTerms(PaymentTerms);
#endif
        this.LibraryInventory.CreatePaymentMethod(PaymentMethod);
#if not CLEANEXCLUDEAPIV2
        TemplateOurAccountNo := CopyStr(this.LibraryUtility.GenerateRandomText(MaxStrLen(Vendor."Our Account No.")), 1, MaxStrLen(TemplateOurAccountNo));
#endif

        // [GIVEN] A template selection rule exists to set the payment terms based on the payment method.
        with Vendor do
            LibraryGraphMgt.CreateSimpleTemplateSelectionRule(ConfigTmplSelectionRules, Page::APIV2Vendors, Database::Vendor,
            FieldNo("Payment Method Code"), PaymentMethod.Code,
#if CLEANEXCLUDEAPIV2
                  FieldNo("Payment Terms Code"), PaymentTerms.Code);
#else
                  FieldNo("Our Account No."), TemplateOurAccountNo);
#endif

        // [GIVEN] The user has constructed a vendor object containing a templated payment method code.
        CreateSimpleVendor(TempVendor);
        TempVendor."Payment Method Code" := PaymentMethod.Code;

        RequestBody := GetSimpleVendorJSON(TempVendor);
        RequestBody := LibraryGraphMgt.AddPropertytoJSON(RequestBody, 'paymentMethodId', PaymentMethod.SystemId);
#if CLEANEXCLUDEAPIV2
        RequestBody := LibraryGraphMgt.AddPropertytoJSON(RequestBody, 'paymentTermsId', PaymentTerms.SystemId);
#endif

        // [WHEN] The user sends the request to the endpoint in a POST request.
        TargetURL := LibraryGraphMgt.CreateTargetURL('', Page::APIV2Vendors, ServiceNameTxt);
        LibraryGraphMgt.PostToWebService(TargetURL, RequestBody, ResponseText);

        // [THEN] The response contains the sent vendor values and also the updated Payment Terms
#if CLEANEXCLUDEAPIV2
        TempVendor."Payment Terms Code" := PaymentTerms.Code;
        VerifyVendorSimpleProperties(ResponseText, TempVendor);
#else
        TempVendor."Our Account No." := TemplateOurAccountNo;
        this.VerifyVendorSimpleProperties(ResponseText, TempVendor, true);
#endif
        VerifyVendorAddress(ResponseText, Vendor);

        // [THEN] The vendor is created in the database with the payment terms set from the template.
        Vendor.Get(TempVendor."No.");
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, Vendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, Vendor, true);
#endif
        VerifyVendorAddress(ResponseText, Vendor);

        // Cleanup
        ConfigTmplSelectionRules.DELETE(true);
    end;

    [Test]
    procedure TestModifyVendor()
    var
        Vendor: Record "Vendor";
        TempVendor: Record "Vendor" temporary;
        RequestBody: Text;
        ResponseText: Text;
        TargetURL: Text;
    begin
        // [SCENARIO 201343] User can modify a vendor through a PATCH request.
        Initialize();

        // [GIVEN] A vendor exists.
        CreateSimpleVendor(Vendor);
        TempVendor.TransferFields(Vendor);
#if CLEANEXCLUDEAPIV2
        TempVendor.Name := LibraryUtility.GenerateGUID();
        RequestBody := GetSimpleVendorJSON(TempVendor);
#else
        TempVendor."Our Account No." := CopyStr(this.LibraryUtility.GenerateRandomText(MaxStrLen(Vendor."Our Account No.")), 1, MaxStrLen(Vendor."Our Account No."));
        RequestBody := this.GetSimpleVendorJSON(TempVendor, true);
#endif        

        // [WHEN] The user makes a patch request to the service.
        TargetURL := LibraryGraphMgt.CreateTargetURL(Vendor.SystemId, Page::APIV2Vendors, ServiceNameTxt);
        LibraryGraphMgt.PatchToWebService(TargetURL, RequestBody, ResponseText);

        // [THEN] The response text contains the new values.
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, TempVendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, TempVendor, true);
#endif

        // [THEN] The record in the database contains the new values.
        Vendor.Get(Vendor."No.");
#if CLEANEXCLUDEAPIV2
        VerifyVendorSimpleProperties(ResponseText, Vendor);
#else
        this.VerifyVendorSimpleProperties(ResponseText, Vendor, true);
#endif
    end;

    [Test]
    procedure TestDeleteVendor()
    var
        Vendor: Record "Vendor";
        VendorNo: Code[20];
        TargetURL: Text;
        Responsetext: Text;
    begin
        // [SCENARIO 201343] User can delete a vendor by making a DELETE request.
        Initialize();

        // [GIVEN] A vendor exists.
        CreateSimpleVendor(Vendor);
        VendorNo := Vendor."No.";

        // [WHEN] The user makes a DELETE request to the endpoint for the vendor.
        TargetURL := LibraryGraphMgt.CreateTargetURL(Vendor.SystemId, Page::APIV2Vendors, ServiceNameTxt);
        LibraryGraphMgt.DeleteFromWebService(TargetURL, '', Responsetext);

        // [THEN] The response is empty.
        Assert.AreEqual('', Responsetext, 'DELETE response should be empty.');

        // [THEN] The vendor is no longer in the database.
        Vendor.SetRange("No.", VendorNo);
        Assert.IsTrue(Vendor.IsEmpty(), 'Vendor should be deleted.');
    end;

    local procedure CreateSimpleVendor(var Vendor: Record "Vendor")
    begin
        Vendor.Init();
        Vendor."No." := GetNextVendorID();
        Vendor.Name := LibraryUtility.GenerateGUID();
        Vendor.Insert(true);

        Commit();
    end;

#if not CLEANEXCLUDEAPIV2
    local procedure CreateSimpleVendor(var Vendor: Record "Vendor"; IncludeCustomAPIFields: Boolean)
    begin
        this.CreateSimpleVendor(Vendor);

        if IncludeCustomAPIFields then begin
            Vendor."Our Account No." := CopyStr(this.LibraryUtility.GenerateRandomText(MaxStrLen(Vendor."Our Account No.")), 1, MaxStrLen(Vendor."Our Account No."));
            Vendor.Modify(true);

            Commit();
        end;
    end;
#endif

    local procedure GetNextVendorID(): Text[20]
    var
        Vendor: Record "Vendor";
    begin
        Vendor.SetFilter("No.", StrSubstNo('%1*', VendorKeyPrefixTxt));
        if Vendor.FindLast() then
            exit(IncStr(Vendor."No."));

        exit(CopyStr(VendorKeyPrefixTxt + '00001', 1, 20));
    end;

    local procedure GetSimpleVendorJSON(var Vendor: Record "Vendor") SimpleVendorJSON: Text
    var
        CustomerJson: Text;
    begin
        if Vendor."No." = '' then
            Vendor."No." := GetNextVendorID();
        if Vendor.Name = '' then
            Vendor.Name := LibraryUtility.GenerateGUID();
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'number', Vendor."No.");
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'displayName', Vendor.Name);
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'addressLine1', Vendor.Address);
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'addressLine2', Vendor."Address 2");
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'city', Vendor.City);
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'state', Vendor.County);
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'country', Vendor."Country/Region Code");
        CustomerJson := LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'postalCode', Vendor."Post Code");
        SimpleVendorJSON := CustomerJson;
    end;

#if not CLEANEXCLUDEAPIV2

    /// <summary>
    /// Add additional base app and custom fields for Silver Bay / Orca Bay requirements here
    /// </summary>
    /// <returns></returns>
    local procedure GetSimpleVendorJSON(var Vendor: Record "Vendor"; IncludeCustomAPIFields: Boolean) SimpleVendorJSON: Text
    var
        CustomerJson: Text;
    begin
        CustomerJson := this.GetSimpleVendorJSON(Vendor);

        if IncludeCustomAPIFields and (Vendor."Our Account No." = '') then
            Vendor."Our Account No." := CopyStr(this.LibraryUtility.GenerateRandomText(MaxStrLen(Vendor."Our Account No.")), 1, MaxStrLen(Vendor."Our Account No."));

        if IncludeCustomAPIFields then
            CustomerJson := this.LibraryGraphMgt.AddPropertytoJSON(CustomerJson, 'ourAccountNo', Vendor."Our Account No.");

        SimpleVendorJSON := CustomerJson;
    end;
#endif

    local procedure VerifyVendorSimpleProperties(VendorJSON: Text; Vendor: Record "Vendor")
    begin
        Assert.AreNotEqual('', VendorJSON, EmptyJSONErr);
        LibraryGraphMgt.VerifyIDInJson(VendorJSON);
        VerifyPropertyInJSON(VendorJSON, 'number', Vendor."No.");
        VerifyPropertyInJSON(VendorJSON, 'displayName', Vendor.Name);
        VerifyPropertyInJSON(VendorJSON, 'addressLine1', Vendor.Address);
        VerifyPropertyInJSON(VendorJSON, 'addressLine2', Vendor."Address 2");
        VerifyPropertyInJSON(VendorJSON, 'city', Vendor.City);
        VerifyPropertyInJSON(VendorJSON, 'state', Vendor.County);
        VerifyPropertyInJSON(VendorJSON, 'country', Vendor."Country/Region Code");
        VerifyPropertyInJSON(VendorJSON, 'postalCode', Vendor."Post Code");
    end;

#if not CLEANEXCLUDEAPIV2
    local procedure VerifyVendorSimpleProperties(VendorJSON: Text; Vendor: Record "Vendor"; IncludeCustomAPIFields: Boolean)
    begin
        this.VerifyVendorSimpleProperties(VendorJSON, Vendor);

        #region SBSINT - Add additional base app & custom fields for Silver Bay / Orca Bay requirements here
        if IncludeCustomAPIFields then
            this.VerifyPropertyInJSON(VendorJSON, 'ourAccountNo', Vendor."Our Account No.");
        #endregion SBSINT
    end;
#endif

    local procedure VerifyPropertyInJSON(JSON: Text; PropertyName: Text; ExpectedValue: Text)
    var
        PropertyValue: Text;
    begin
        LibraryGraphMgt.GetObjectIDFromJSON(JSON, PropertyName, PropertyValue);
        Assert.AreEqual(ExpectedValue, PropertyValue, StrSubstNo(WrongPropertyValueErr, PropertyName));
    end;

    local procedure VerifyVendorAddress(VendorJSON: Text; var Vendor: Record "Vendor")
    begin
        with Vendor do
            LibraryGraphMgt.VerifyAddressProperties(VendorJSON, Address, "Address 2", City, County, "Country/Region Code", "Post Code");
    end;
}