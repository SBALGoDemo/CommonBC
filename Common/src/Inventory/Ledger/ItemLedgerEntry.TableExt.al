namespace SilverBay.Common.Inventory.Ledger;

using Microsoft.Inventory.Ledger;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from tableextension 50067 "ItemLedgerEntry" extends "Item Ledger Entry"
/// </summary>
tableextension 60105 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        /// </summary>
        field(60100; SBSCOMNetWeight; Decimal)
        {
            // Access = Internal;
            // TODO: add note that this was moved from SilverBay
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Net Weight for the quantity of of the item ledger entry.';
        }

        // TODO: 20250617 Review later. 0 References 
        //TODO: 20250617 Confirmed Don't need       
        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1423 - Quantity (Source UOM) not populated in Item Ledger Entry table
        // field(54002; "OBF-Quantity (Source UOM)"; decimal)
        // {
        //     Caption = 'Quantity (Source UOM)';
        //     DecimalPlaces = 0 : 2;
        // }
    }
}