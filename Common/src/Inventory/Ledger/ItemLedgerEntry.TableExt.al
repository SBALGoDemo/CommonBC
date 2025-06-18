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
        /// Migrated from field(51001; "OBF-Net Weight"; Decimal)
        /// </summary>
        field(60100; SBSCOMNetWeight; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Net Weight for the quantity of of the item ledger entry.';
        }
    }
}