namespace SilverBay.Common.Inventory.Tracking;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues/// 
/// Migrated from tableextension 50066 "ReservationEntry" extends "Reservation Entry"
/// </summary>
tableextension 60102 ReservationEntry extends "Reservation Entry"
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        /// </summary>
        field(60100; SBSCOMPurResEntryisNeg; Boolean)
        {
            Access = Internal;
            Caption = 'Purchase Reservation Entry is Negative';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60101; SBSCOMLotIsOnHand2; Boolean)
        {
            Access = Internal;
            Caption = 'Lot Is On Hand';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60102; SBSCOMLotIsOnHand; Boolean)
        {
            Access = Internal;
            CalcFormula = exist("Item Ledger Entry" where("Item No." = field("Item No."), "Lot No." = field("Lot No.")));
            Caption = 'Lot Is On Hand';
            Editable = false;
            FieldClass = FlowField;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        /// </summary>
        field(60107; SBSCOMPurchaserCode; Code[20])
        {
            Access = Internal;
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(60110; SBSCOMProductionDate; Date)
        {
            Access = Internal;
            Caption = 'Production Date';
            DataClassification = CustomerContent;
        }
        field(60112; SBSCOMNetWeight; Decimal)
        {
            Access = Internal;
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60113; SBSCOMNetWeighttoHandle; Decimal)
        {
            Access = Internal;
            Caption = 'Net Weight to Handle';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}