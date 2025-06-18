namespace SilverBay.Inventory.StatusSummary.Tracking;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

/// <summary>
/// Migrated from query 50052 "Distinct Item Lot (Res. Entry)"
/// </summary>
query 60309 DistinctItemLotLocResEntry
{
    Access = Internal;
    Caption = 'Distinct Item Lot Location Reservation Entry';
    OrderBy = ascending(Item_No), ascending(Lot_No);

    elements
    {
        dataitem(Reservation_Entry; "Reservation Entry")
        {
            filter(Creation_Date_Filter; "Creation Date") { }
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
                DataItemLink = "No." = Reservation_Entry."Item No.";
                DataItemTableFilter = "Item Tracking Code" = filter(<> '');
                SqlJoinType = InnerJoin;
                column(Item_Tracking_Code; "Item Tracking Code") { }
            }
        }
    }
}