// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2894 - Migrate Orca Bay "Inv. Status by Item" page to Common/Inventory app
tableextension 60309 ItemExt extends Item
{
    fields
    {
        field(60300; "OBF-Qty. on Purchase Orders"; Decimal)
        {
            Caption = 'Qty. on Purchase Orders';
            CalcFormula = Sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("No."),
                                                                                 "Source Type" = const(39),
                                                                                 "Source Subtype" = const("1")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(60301; "OBF-Qty. on Sales Orders"; Decimal)
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