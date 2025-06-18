namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from pageextension 50031 "SalesLines" extends "Sales Lines"
/// </summary>
pageextension 60101 SalesLines extends "Sales Lines"
{
    layout
    {
        addafter("Qty. to Ship")
        {
            /// <summary>
            /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
            /// </summary>
            field(SBSCOMAllocatedQuantity; Rec.SBSCOMAllocatedQuantity)
            {
                ApplicationArea = all;
            }
        }
    }
}

