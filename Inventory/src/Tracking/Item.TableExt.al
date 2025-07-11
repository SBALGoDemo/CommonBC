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
            CalcFormula = sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("No."),
                                                                                 "Source Type" = const(39),
                                                                                 "Source Subtype" = const("1")));
            Caption = 'Qty. on Purchase Orders';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(60301; SBSINVQtyonSalesOrders; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("No."),
                                                                                 "Source Type" = const(37),
                                                                                 "Source Subtype" = const("1")));
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}