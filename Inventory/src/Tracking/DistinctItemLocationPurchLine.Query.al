namespace SilverBay.Inventory.Tracking;

using Microsoft.Purchases.Document;

/// <summary>
/// Migrated from query 50060 "OBF-Dist. Items On Purch. Line"
/// </summary>
query 60300 DistinctItemLocationPurchLine
{
    Access = Internal;
    Caption = 'Distinct Item Location Purchase Line';
    OrderBy = ascending(Item_No);

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            DataItemTableFilter = "Document Type" = const(Order), Type = const(Item), "No." = filter(<> '');
            column(Item_No; "No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Location_Code; "Location Code") { }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}