namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;

tableextension 60301 "Item" extends Item
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50020; "OBF-Exclude from Weight Calc."; Boolean)
        {
            CaptionML = ENU = 'Exclude from Weight Calculation';
        }

        field(51002; "OBF-Qty on Quality Hold"; Decimal)
        {
            Caption = 'Qty. on Quality Hold';
            Editable = false;
            DecimalPlaces = 0 : 0;
            // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            //CalcFormula = Sum("OBF-Quality Ledger Entry"."Quantity (Base)" Where("Item No." = field("No.")));
            FieldClass = FlowField;
        }
    }
}