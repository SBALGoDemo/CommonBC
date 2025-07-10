namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2894 - Migrate Orca Bay "Inv. Status by Item" page to Common/Inventory app
/// Migrated from tableextension 50063 "Item" extends Item
/// </summary>
tableextension 60308 Item extends Item
{
    fields
    {
        field(60300; SBSINVQtyonPurchaseOrders; Decimal)
        {
            Caption = 'Qty. on Purchase Orders';
            CalcFormula = Sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("No."),
                                                                                 "Source Type" = const(39),
                                                                                 "Source Subtype" = const("1")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(60301; SBSINVQtyonSalesOrders; Decimal)
        {
            Caption = 'Qty. on Sales Orders';
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("No."),
                                                                                 "Source Type" = const(37),
                                                                                 "Source Subtype" = const("1")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
    }
}