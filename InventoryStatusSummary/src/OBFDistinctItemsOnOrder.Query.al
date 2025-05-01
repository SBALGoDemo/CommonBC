query 60304 "OBF-Distinct Items On Order"
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
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}