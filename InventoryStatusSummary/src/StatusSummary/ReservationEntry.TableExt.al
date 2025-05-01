namespace SilverBay.Inventory.StatusSummary;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

tableextension 60302 ReservationEntry extends "Reservation Entry"
{
    fields
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        field(60300; SBSISSPurResEntryisNeg; Boolean)
        {
            Caption = 'Purchase Reservation Entry is Negative';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60301; SBSISSLotIsOnHand2; Boolean)
        {
            CaptionML = ENU = 'Lot Is On Hand';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60302; SBSISSLotIsOnHand; Boolean)
        {
            CalcFormula = exist("Item Ledger Entry" where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            CaptionML = ENU = 'Lot Is On Hand';
            Editable = false;
            FieldClass = FlowField;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/760 - Add Cert Field to Purchase Orders
        field(60303; SBSISSSustCert; Code[10])
        {
            Caption = 'Sustainability Certification';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        field(60304; SBSISSContainerNo; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1185- Lot No. Properties
        field(60305; SBSISSLabel; Text[50])
        {
            Caption = 'Label';
            DataClassification = CustomerContent;
        }
        field(60306; SBSISSVessel; Text[50])
        {
            Caption = 'Vessel';
            DataClassification = CustomerContent;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        field(60307; SBSISSPurchaserCode; Code[20])
        {
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        field(60308; SBSISSItemCategoryCode; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Caption = 'Item Category Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60309; SBSISSISSUpdated; Boolean)
        {
            Caption = 'ISS Updated';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60310; SBSISSProductionDate; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1332 - Change Production Date using Item Reclass Journal
        field(60311; SBSISSNewProductionDate; Date)
        {
            Caption = 'New Production Date';
            DataClassification = CustomerContent;
        }
        field(60312; SBSISSNetWeight; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60313; SBSISSNetWeighttoHandle; Decimal)
        {
            Caption = 'Net Weight to Handle';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60314; SBSISSQuantitySourceUOM; Decimal)
        {
            Caption = 'Quantity (Source UOM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        field(60315; SBSISSPurchasedForFlowField; Code[20])
        {
            Caption = 'Purchased For';
            // CalcFormula = lookup("Purchase Line"."OBF-Purchased For" where("Document No." = field("Source ID"),
            //                                                                       "Line No." = field("Source Ref. No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Salesperson/Purchaser";
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
    procedure SetPurchResEntryIsNegative()
    begin
        if (Rec."Source Type" = Database::"Purchase Line") and
            (Rec."Source Subtype" = 1) and // Orders
            (Rec."Qty. to Handle (Base)" < 0) then
            Rec.SBSISSPurResEntryisNeg := true
        else
            Rec.SBSISSPurResEntryisNeg := false;
    end;
}