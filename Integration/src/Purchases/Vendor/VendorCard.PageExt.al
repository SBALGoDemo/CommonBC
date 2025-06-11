namespace SilverBay.Integration.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

pageextension 60401 SBSINTVendorCard extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            /// <summary>
            /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2798
            /// </summary>
            field(SBSINTIsCoupaVendor; Rec.SBSINTIsCoupaVendor)
            {
                ApplicationArea = All;
            }
        }
    }
}