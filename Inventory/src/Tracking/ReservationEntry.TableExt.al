namespace SilverBay.Inventory.Tracking;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues/// 
/// Migrated from tableextension 50066 "ReservationEntry" extends "Reservation Entry"
/// </summary>
tableextension 60301 ReservationEntry extends "Reservation Entry"
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        /// </summary>
        field(60300; SBSINVPurResEntryisNeg; Boolean)
        {
            Caption = 'Purchase Reservation Entry is Negative';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60301; SBSINVLotIsOnHand2; Boolean)
        {
            Caption = 'Lot Is On Hand';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60302; SBSINVLotIsOnHand; Boolean)
        {
            CalcFormula = exist("Item Ledger Entry" where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            Caption = 'Lot Is On Hand';
            Editable = false;
            FieldClass = FlowField;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2947 - Remove Unneeded Fields from Reservation Entry table extension 
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        /// </summary>
        field(60307; SBSINVPurchaserCode; Code[20])
        {
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            ObsoleteState = Pending;
            ObsoleteReason = 'Use Lot No. Information table extension instead.';
        }
        field(60310; SBSINVProductionDate; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Use Lot No. Information table extension instead.';
        }
        field(60312; SBSINVNetWeight; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60313; SBSINVNetWeighttoHandle; Decimal)
        {
            Caption = 'Net Weight to Handle';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}