namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;

tableextension 60301 Item extends Item
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(60300; SBSISSExcludefromWeightCalc; Boolean)
        {
            CaptionML = ENU = 'Exclude from Weight Calculation';
            DataClassification = CustomerContent;
        }
        field(60301; SBSISSQtyonQualityHold; Decimal)
        {
            Caption = 'Qty. on Quality Hold';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            Enabled = false;
            Editable = false;
            //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            //CalcFormula = Sum("OBF-Quality Ledger Entry"."Quantity (Base)" Where("Item No." = field("No.")));
            // FieldClass = FlowField;
        }
    }
}