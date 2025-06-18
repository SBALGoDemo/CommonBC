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
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 Review later. 0 references
        // modify("Location Code")
        // {
        //     Visible = false;
        // }
        // moveafter("Global Dimension 1 Code"; "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")

        // addafter("Document No.")
        // {
        //     field("External Document No."; Rec."External Document No.")
        //     {
        //         ApplicationArea = all;
        //     }
        // }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        addafter("Lot No.")
        {
            field(SBSCOMNetWeight; Rec.SBSCOMNetWeight)
            {
                ApplicationArea = all;
            }
        }

        //TODO: 20250617 Confirmed Don't need
        // TODO: 20250617 Review later. 0 references
        //    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
        //     addafter(Quantity)
        //     {
        //         field("OBF-Quantity (Source UOM)";Rec."OBF-Quantity (Source UOM)")
        //         {
        //             ApplicationArea = all;
        //         }
        //     }
    }
}