namespace SilverBay.Common.Inventory.Tracking;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

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
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/760 - Add Cert Field to Purchase Orders
        /// </summary>
        //TODO: 20250617 Confirmed Don't need
        //TODO:20250617  Review Later. 0 References // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(60103; SBSCOMSustCert; Code[10])
        // {
        //     Access = Internal;
        //     Caption = 'Sustainability Certification';
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        /// </summary>
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 eview Later. 0 References // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay        
        // field(60104; SBSCOMContainerNo; Code[20])
        // {
        //     Access = Internal;
        //     Caption = 'Container No.';
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1185- Lot No. Properties
        /// </summary>
        // field(60105; SBSCOMLabel; Text[50])
        // {
        //     Access = Internal;
        //     Caption = 'Label';
        //     DataClassification = CustomerContent;
        // }
        // field(60106; SBSCOMVessel; Text[50])
        // {
        //     Access = Internal;
        //     Caption = 'Vessel';
        //     DataClassification = CustomerContent;
        // }
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
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 Review Later. 0 References 
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        /// </summary>
        // field(60108; SBSCOMItemCategoryCode; Code[20])
        // {
        //     Access = Internal;
        //     CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
        //     Caption = 'Item Category Code';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(60109; SBSCOMUpdated; Boolean)
        // {
        //     Access = Internal;
        //     Caption = 'ISS Updated';
        //     DataClassification = CustomerContent;
        //     Editable = false;
        // }
        field(60110; SBSCOMProductionDate; Date)
        {
            Access = Internal;
            Caption = 'Production Date';
            DataClassification = CustomerContent;
        }
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 Review Later. 0 References 
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1332 - Change Production Date using Item Reclass Journal
        /// </summary>
        // field(60111; SBSCOMNewProductionDate; Date)
        // {
        //     Access = Internal;
        //     Caption = 'New Production Date';
        //     DataClassification = CustomerContent;
        // }
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
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 Review Later. 0 References 
        // field(60114; SBSCOMQuantitySourceUOM; Decimal)
        // {
        //     Access = Internal;
        //     Caption = 'Quantity (Source UOM)';
        //     DataClassification = CustomerContent;
        //     DecimalPlaces = 0 : 2;
        // }
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        //TODO: 20250617 Confirmed Don't need
        //TODO: 20250617 Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(60115; SBSCOMPurchasedForFlowField; Code[20])
        // {
        //     Caption = 'Purchased For';
        //     Enabled = false;
        //     // CalcFormula = lookup("Purchase Line"."OBF-Purchased For" where("Document No." = field("Source ID"),
        //     //                                                                       "Line No." = field("Source Ref. No.")));
        //     Editable = false;
        //     FieldClass = FlowField;
        //     TableRelation = "Salesperson/Purchaser";
        // }
    }
}