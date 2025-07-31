// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2978 - Set Expiration Date based on Production Date
tableextension 60320 PurchSetupExt extends "Purchases & Payables Setup"
{
    fields
    {
        field(60300; SBSINVEnableSetExpDate; Boolean)
        {
            Caption = 'Enable Set Expiration Date';
            DataClassification = ToBeClassified;
        }
    }
}