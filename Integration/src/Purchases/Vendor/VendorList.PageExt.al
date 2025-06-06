namespace SilverBay.Integration.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

pageextension 60400 SBSINTVendorList extends "Vendor List"
{
    layout
    {
        addlast(Control1)
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