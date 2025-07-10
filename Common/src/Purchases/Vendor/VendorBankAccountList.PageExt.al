namespace SilverBay.Common.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2922 - Add Bank Info Indicators to Vendor and Vendor Bank Account Pages
/// </summary>
pageextension 60106 VendorBankAccountList extends "Vendor Bank Account List"
{
    layout
    {
        addlast(Control1)
        {
            field(SBSCOMVendorNo; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the related vendor record.';
            }
            field(SBSCOMOurAccountNo; Rec.SBSCOMOurAccountNo)
            {
                ApplicationArea = All;
            }
        }
    }
}