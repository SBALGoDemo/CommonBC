query 60301 "Distinct Item Lot (Res. Entry)"
{
    OrderBy = Ascending(Item_No), Ascending(Lot_No);

    elements
    {
        dataitem(Reservation_Entry; "Reservation Entry")
        {
            filter(Creation_Date_Filter; "Creation Date")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Lot_No; "Lot No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Count_)
            {
                Method = Count;
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Reservation_Entry."Item No.";
                SqlJoinType = InnerJoin;
                column(Item_Tracking_Code; "Item Tracking Code")
                {
                }
            }
        }
    }
}