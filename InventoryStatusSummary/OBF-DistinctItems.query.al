// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
query 50050 "OBF-Distinct Items On Hand"
{

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
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

query 50054 "OBF-Distinct Items On Order"
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

query 50060 "OBF-Dist. Items On Purch. Line"
{
    OrderBy = Ascending(Item_No);

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const(Order), Type = const(Item), "No." = FILTER(<> '');
            column(Item_No; "No.")
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