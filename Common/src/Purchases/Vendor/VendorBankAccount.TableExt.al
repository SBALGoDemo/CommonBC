namespace SilverBay.Common.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2922 - Add Bank Info Indicators to Vendor and Vendor Bank Account Pages
/// </summary>
tableextension 60108 VendorBankAccount extends "Vendor Bank Account"
{
    fields
    {
        field(60100; SBSCOMOurAccountNo; Text[20])
        {
            Caption = 'Our Account No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."Our Account No." where("No." = field("Vendor No.")));
            ToolTip = 'Specifies your account number with the vendor, if you have one.';
        }
    }
}