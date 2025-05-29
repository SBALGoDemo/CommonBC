namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
/// </summary>
query 60300 DistinctItemLotLocationILE
{
    Access = Internal;
    Caption = 'Distinct Item Lot Location Item Ledger Entry';
    OrderBy = ascending(Item_No), ascending(Lot_No);

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(Posting_Date_Filter; "Posting Date") { }
            column(Item_No; "Item No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Lot_No; "Lot No.") { }
            column(Location_Code; "Location Code") { }
            column(Count_)
            {
                Method = Count;
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Item_Ledger_Entry."Item No.";
                DataItemTableFilter = "Item Tracking Code" = filter(<> '');
                SqlJoinType = InnerJoin;
                column(Item_Tracking_Code; "Item Tracking Code") { }
            }
        }
    }
}