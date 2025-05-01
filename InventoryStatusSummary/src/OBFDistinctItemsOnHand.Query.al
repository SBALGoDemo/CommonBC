// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
query 60303 "OBF-Distinct Items On Hand"
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