// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
query 50051 "Distinct Item Lot Locations"
{
    OrderBy = Ascending(Item_No), Ascending(Lot_No);

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            //DataItemTableFilter = "Remaining Quantity"=FILTER(<>0);
            filter(Posting_Date_Filter; "Posting Date")
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
                DataItemLink = "No." = Item_Ledger_Entry."Item No.";
                SqlJoinType = InnerJoin;
                column(Item_Tracking_Code; "Item Tracking Code")
                {
                }
            }
        }
    }
}

query 50052 "Distinct Item Lot (Res. Entry)"
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
query 50061 "OBF-Distinct Item Loc On Order"
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
