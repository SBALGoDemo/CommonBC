namespace SilverBay.Inventory.StatusSummary;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues 

tableextension 60302 "ReservationEntry" extends "Reservation Entry"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        field(60300; "OBF-Pur. Res. Entry is Neg."; Boolean)
        {
            Caption = 'Purchase Reservation Entry is Negative';
            Editable = false;
        }

        field(60301; "OBF-Lot Is On Hand2"; Boolean)
        {
            CaptionML = ENU = 'Lot Is On Hand';
            Editable = false;
        }
        field(60302; "OBF-Lot Is On Hand"; Boolean)
        {
            CaptionML = ENU = 'Lot Is On Hand';
            FieldClass = FlowField;
            CalcFormula = exist("Item Ledger Entry" where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/760 - Add Cert Field to Purchase Orders
        field(60303; "OBF-Sust. Cert"; Code[10])
        {
            Caption = 'Sustainability Certification';
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        field(60304; "OBF-Container No."; Code[20])
        {
            Caption = 'Container No.';
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1185- Lot No. Properties
        field(60305; "OBF-Label"; Text[50])
        {
            Caption = 'Label';
        }
        field(60306; "OBF-Vessel"; Text[50])
        {
            Caption = 'Vessel';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        field(60307; "OBF-Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        field(60308; "OBF-Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Editable = false;
        }
        field(60309; "OBF-ISS Updated"; Boolean)
        {
            Caption = 'ISS Updated';
            Editable = false;
        }

        field(60310; "OBF-Production Date"; Date)
        {
            Caption = 'Production Date';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1332 - Change Production Date using Item Reclass Journal   
        field(60311; "OBF-New Production Date"; Date)
        {
            Caption = 'New Production Date';
        }

        field(60312; "OBF-Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            Editable = false;
        }
        field(60313; "OBF-Net Weight to Handle"; Decimal)
        {
            Caption = 'Net Weight to Handle';
            Editable = false;
        }

        field(60314; "OBF-Quantity (Source UOM)"; decimal)
        {
            Caption = 'Quantity (Source UOM)';
            DecimalPlaces = 0 : 2;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        field(60315; "OBF-Purchased For (FlowField)"; Code[20])
        {
            Caption = 'Purchased For';
            TableRelation = "Salesperson/Purchaser";
            FieldClass = FlowField;
            // CalcFormula = lookup("Purchase Line"."OBF-Purchased For" where("Document No." = field("Source ID"),
            //                                                                       "Line No." = field("Source Ref. No.")));
            Editable = false;
        }

    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
    procedure SetPurchResEntryIsNegative()
    begin
        if (Rec."Source Type" = Database::"Purchase Line") and
            (Rec."Source Subtype" = 1) and // Orders
            (Rec."Qty. to Handle (Base)" < 0) then
            Rec."OBF-Pur. Res. Entry is Neg." := true
        else
            Rec."OBF-Pur. Res. Entry is Neg." := false;
    end;

}