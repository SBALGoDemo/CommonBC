namespace SilverBay.Common.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2922 - Add Bank Info Indicators to Vendor and Vendor Bank Account Pages
/// </summary>
pageextension 60104 VendorCard extends "Vendor Card"
{
    layout
    {
        modify("Preferred Bank Account Code")
        {
            Importance = Promoted;
        }
    }
}