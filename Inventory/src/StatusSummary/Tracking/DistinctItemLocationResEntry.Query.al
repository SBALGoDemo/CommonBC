namespace SilverBay.Inventory.StatusSummary.Tracking;

using Microsoft.Inventory.Tracking;

/// <summary>
/// Migrated from query 50061 "OBF-Distinct Item Loc On Order"
/// </summary>
query 60301 DistinctItemLocationResEntry
{
    Access = Internal;
    Caption = 'Distinct Item Location Reservation Entry';
    OrderBy = ascending(Item_No);

    elements
    {
        dataitem(Reservation_Entry; "Reservation Entry")
        {
            column(Item_No; "Item No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Location_Code; "Location Code") { }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}