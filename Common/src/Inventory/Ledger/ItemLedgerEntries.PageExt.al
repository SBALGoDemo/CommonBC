namespace SilverBay.Common.Inventory.Ledger;

using Microsoft.Inventory.Ledger;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay        
/// Migrated from pageextension 50033 "ItemLedgerEntries" extends "Item Ledger Entries"
/// </summary>
pageextension 60100 ItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        addafter("Lot No.")
        {
            field(SBSCOMNetWeight; Rec.SBSCOMNetWeight)
            {
                ApplicationArea = all;
            }
        }
    }
}