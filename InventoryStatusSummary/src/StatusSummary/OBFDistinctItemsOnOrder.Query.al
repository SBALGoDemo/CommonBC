namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Tracking;

query 60304 "OBF-Distinct Items On Order"
{
    Caption = 'OBF-Distinct Items On Order';
    OrderBy = ascending(Item_No);

    elements
    {
        dataitem(Reservation_Entry; "Reservation Entry")
        {
            column(Item_No; "Item No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}