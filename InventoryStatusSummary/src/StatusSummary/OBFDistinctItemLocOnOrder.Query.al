namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Tracking;

query 60302 "OBF-Distinct Item Loc On Order"
{
    OrderBy = Ascending(Item_No);

    elements
    {
        dataitem(Reservation_Entry; "Reservation Entry")
        {
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}