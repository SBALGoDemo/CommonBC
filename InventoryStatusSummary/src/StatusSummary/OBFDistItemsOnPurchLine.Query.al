namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Purchases.Document;

query 60305 "OBF-Dist. Items On Purch. Line"
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