// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders 
//     Reverse sign of "Qty. on Sales Orders" and "Net Weight on Sales Order" flowfields
//https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages

table 60300 "OBF-Distinct Item Lot"
{
    Caption = 'Lots';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Lot No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1532 - Inv. Status Overflow Issue
        field(5; "Item Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(6; "Item Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1532 - Inv. Status Overflow Issue
        field(7; "Search Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(8; "Pack Size"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Method of Catch"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Country of Origin"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Brand Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Item Category Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(13; "PO Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(14; "Alternate Lot No."; Code[20])
        // {
        //     CaptionML = ENU = 'Alternate Lot No.';
        //     CalcFormula = lookup("Lot No. Information"."OBF-Alternate Lot No." WHERE("Item No." = FIELD("Item No."),
        //                                                                             "Lot No." = FIELD("Lot No.")));
        //     FieldClass = FlowField;
        //     Editable = false;
        // }
        field(15; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(16; "Label Value"; Text[50])
        {
            Caption = 'Label';
            Editable = false;
        }
        field(17; "Buyer Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(18; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Vendor";
        }
        field(19; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(21; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost';
            DecimalPlaces = 2 : 5;
        }
        field(22; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
        }
        field(30; "On Hand Quantity"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                              "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                              "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
        }
        field(31; "Total Quantity for Item Lot"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                              "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                              "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
            DecimalPlaces = 0 : 0;
            Enabled = false;
        }
        field(32; "On Order Quantity"; Decimal)
        {
            Caption = 'On Order Quantity';
            CalcFormula = Sum("Reservation Entry"."Qty. to Handle (Base)" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                                "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                                "Source Type" = CONST(39),
                                                                                "Source Subtype" = CONST("1"),
                                                                                "OBF-Lot Is On Hand2" = const(false)));

            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(33; "Qty. on Sales Order"; Decimal)
        {
            Caption = 'Qty. on Sales Orders';
            CalcFormula = - Sum("Reservation Entry"."Qty. to Handle (Base)" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                                 "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                                 "Source Type" = CONST(37),
                                                                                 "Source Subtype" = CONST("1"),
                                                                                 "Source ID" = Field("Sales Order Filter")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(34; "Total Available Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Available Qty.';
            DecimalPlaces = 0 : 0;
        }
        field(35; "Total ILE Weight for Item Lot"; Decimal)
        {
            Caption = 'Total Weight for Item Lot';
            CalcFormula = Sum("Item Ledger Entry"."OBF-Net Weight" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                              "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                              "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(36; "On Order Weight"; Decimal)
        {
            Caption = 'On Order Weight';
            CalcFormula = Sum("Reservation Entry"."OBF-Net Weight to Handle" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                                 "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                                 "Source Type" = CONST(39),
                                                                                 "Source Subtype" = CONST("1")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(37; "Net Weight on Sales Order"; Decimal)
        {
            Caption = 'Net Weight on Sales Orders';
            CalcFormula = - Sum("Reservation Entry"."OBF-Net Weight" WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"),
                                                                                 "Location Code" = FIELD("Location Code"), "Lot No." = FIELD("Lot No."),
                                                                                 "Source Type" = CONST(37),
                                                                                 "Source Subtype" = CONST("1")));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(38; "Available Net Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Available Weight';
            DecimalPlaces = 0 : 0;
        }
        field(39; "On Hand Weight"; Decimal)
        {
            Caption = 'On Hand Weight';
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(40; "Value of Inventory on Hand"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value of Inventory on Hand.';
            DecimalPlaces = 2 : 2;
        }
        field(41; "Sales Order Filter"; code[250])
        {
            FieldClass = FlowFilter;
        }
        //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
        field(42; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(43; "Variant Code"; Code[10])
        {
            CaptionML = ENU = 'Variant Code';
            DataClassification = ToBeClassified;
        }
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
        field(44; "On Order Quantity 2"; Decimal)
        {
            Caption = 'On Order Quantity';
            Editable = false;
            DecimalPlaces = 0 : 0;
        }
        field(45; "On Order Weight 2"; Decimal)
        {
            Caption = 'On Order Weight';
            Editable = false;
            DecimalPlaces = 0 : 0;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
        field(52; "Sustainability Certification"; Code[10])
        {
            Caption = 'Sustainability Certification';
            FieldClass = Normal;
            TableRelation = "OBF-Certification";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
        field(60; "OBF-Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(61; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1195 - Hold Functionality
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        field(70; "Qty. on Quality Hold"; Decimal)
        {
            // CalcFormula = Sum("OBF-Quality Ledger Entry"."Quantity (Base)" Where("Item No." = field("Item No."),
            //                                                     "Variant Code" = field("Variant Code"),
            //                                                     "Location Code" = field("Location Code"),
            //                                                     "Lot No." = field("Lot No.")));
            Caption = 'Quantity on Quality Hold';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        field(75; "Qty. In Transit"; Decimal)
        {
            Caption = 'Qty. in Transit';
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" Where("Item No." = field("Item No."),
                                                                                 "Lot No." = field("Lot No."),
                                                                                 "Source Type" = CONST(39),
                                                                                 "Source Subtype" = CONST("1"),
                                                                                 "OBF-Pur. Res. Entry is Neg." = const(true)));
            FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 0;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        field(96; "Container No."; Code[20])
        {
            Caption = 'Container No.';
        }


        field(71; "On Hand Quantity 2"; Decimal)
        {
            Caption = 'On Hand Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(93; "Label Text"; Text[50])
        // {
        //     Caption = 'Label';
        //     Editable = false;
        //     CalcFormula = Lookup("Lot No. Information"."OBF-Label" WHERE("Item No." = FIELD("Item No."),
        //                                                                 "Lot No." = FIELD("Lot No."),
        //                                                                 "Variant Code" = field("Variant Code")));
        //     FieldClass = FlowField;
        // }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        field(50300; "OBF-Purchased For"; Code[20])
        {
            Caption = 'Purchased For';
            TableRelation = "Salesperson/Purchaser";
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Location Code", "Lot No.")
        {
        }
    }

    fieldgroups
    {
    }

    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders
    procedure CalcAvailableQtyExcludingOrder(ItemNo: Code[20]; VariantCode: code[10]; LocationCode: code[10]; LotNo: Code[20]; OrderNo: Code[20]): Decimal
    var
        DistinctItemLot: Record "OBF-Distinct Item Lot" temporary;
        AvailableQty: Decimal;
    begin
        DistinctItemLot."Entry No." := 1;
        DistinctItemLot."Item No." := ItemNo;
        DistinctItemLot."Variant Code" := VariantCode;
        DistinctItemLot."Location Code" := LocationCode;
        DistinctItemLot."Lot No." := LotNo;
        DistinctItemLot.SetFilter(DistinctItemLot."Sales Order Filter", '<>%1', OrderNo);
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        DistinctItemLot.CalcFields(DistinctItemLot."On Hand Quantity", DistinctItemLot."On Order Quantity", DistinctItemLot."Qty. on Sales Order"); // , DistinctItemLot."Qty. on Quality Hold"
        AvailableQty := DistinctItemLot."On Hand Quantity" + DistinctItemLot."On Order Quantity" - DistinctItemLot."Qty. on Sales Order"; // - DistinctItemLot."Qty. on Quality Hold";

        exit(AvailableQty);

    end;
}

