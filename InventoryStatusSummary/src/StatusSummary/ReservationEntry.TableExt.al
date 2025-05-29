namespace SilverBay.Inventory.StatusSummary;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues/// 
/// </summary>
tableextension 60302 ReservationEntry extends "Reservation Entry"
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        /// </summary>
        field(60300; SBSISSPurResEntryisNeg; Boolean)
        {
            Access = Internal;
            Caption = 'Purchase Reservation Entry is Negative';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60301; SBSISSLotIsOnHand2; Boolean)
        {
            Access = Internal;
            Caption = 'Lot Is On Hand';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60302; SBSISSLotIsOnHand; Boolean)
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
        field(60303; SBSISSSustCert; Code[10])
        {
            Access = Internal;
            Caption = 'Sustainability Certification';
            DataClassification = CustomerContent;
            Editable = false;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        /// </summary>
        field(60304; SBSISSContainerNo; Code[20])
        {
            Access = Internal;
            Caption = 'Container No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1185- Lot No. Properties
        /// </summary>
        field(60305; SBSISSLabel; Text[50])
        {
            Access = Internal;
            Caption = 'Label';
            DataClassification = CustomerContent;
        }
        field(60306; SBSISSVessel; Text[50])
        {
            Access = Internal;
            Caption = 'Vessel';
            DataClassification = CustomerContent;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1074 - Lots for a Purchaser
        /// </summary>
        field(60307; SBSISSPurchaserCode; Code[20])
        {
            Access = Internal;
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        /// </summary>
        field(60308; SBSISSItemCategoryCode; Code[20])
        {
            Access = Internal;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Caption = 'Item Category Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60309; SBSISSUpdated; Boolean)
        {
            Access = Internal;
            Caption = 'ISS Updated';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60310; SBSISSProductionDate; Date)
        {
            Access = Internal;
            Caption = 'Production Date';
            DataClassification = CustomerContent;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1332 - Change Production Date using Item Reclass Journal
        /// </summary>
        field(60311; SBSISSNewProductionDate; Date)
        {
            Access = Internal;
            Caption = 'New Production Date';
            DataClassification = CustomerContent;
        }
        field(60312; SBSISSNetWeight; Decimal)
        {
            Access = Internal;
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60313; SBSISSNetWeighttoHandle; Decimal)
        {
            Access = Internal;
            Caption = 'Net Weight to Handle';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60314; SBSISSQuantitySourceUOM; Decimal)
        {
            Access = Internal;
            Caption = 'Quantity (Source UOM)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(60315; SBSISSPurchasedForFlowField; Code[20])
        // {
        //     Caption = 'Purchased For';
        //     Enabled = false;
        //     CalcFormula = lookup("Purchase Line"."OBF-Purchased For" where("Document No." = field("Source ID"),
        //                                                                           "Line No." = field("Source Ref. No.")));
        //     Editable = false;
        //     FieldClass = FlowField;
        //     TableRelation = "Salesperson/Purchaser";
        // }
    }
}