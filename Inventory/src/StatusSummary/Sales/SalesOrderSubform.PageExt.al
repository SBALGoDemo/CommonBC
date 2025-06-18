namespace SilverBay.Inventory.StatusSummary.Sales;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from pageextension 50042 "SalesOrderSubform" extends "Sales Order Subform"
/// </summary>
pageextension 60301 SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
            field(SBSINVAllocatedQuantity; Rec.SBSINVAllocatedQuantity)
            {
                ApplicationArea = all;
            }
        }
    }
}