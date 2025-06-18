namespace SilverBay.Common.Inventory.Item;

using Microsoft.Inventory.Item;

/// <summary>
/// Migrated from table 50019 "OBF-Item Availability Buffer"
/// </summary>
tableextension 60101 Item extends Item
{
    fields
    {
        field(60101; SBSCOMQtyonQualityHold; Decimal)
        {
            Access = Internal;
            Caption = 'Qty. on Quality Hold';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 0;
            Enabled = false;
            Editable = false;
            //TODO: 20250617 Confirmed Don't need
            //TODO: 20250617 Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            //CalcFormula = Sum("OBF-Quality Ledger Entry"."Quantity (Base)" Where("Item No." = field("No.")));
            // FieldClass = FlowField;
        }
    }
}