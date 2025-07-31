// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2978 - Set Expiration Date based on Production Date
codeunit 60304 SBSINVOnUpgrade
{
    Subtype = Upgrade;
    trigger OnUpgradePerCompany();
    begin
        InitPurchaseSetupCustomFields();
    end;

    procedure InitPurchaseSetupCustomFields();
    var
        PurchSetup: record "Purchases & Payables Setup";
    begin
        PurchSetup.Get;
        PurchSetup.SBSINVEnableSetExpDate := true;
        PurchSetup.Modify;
    end;
}