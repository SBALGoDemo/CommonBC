namespace SilverBay.Inventory.StatusSummary;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders
/// Reverse sign of "Qty. on Sales Orders" and "Net Weight on Sales Order" flowfields
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
/// </summary>
table 60300 DistinctItemLot
{
    Access = Internal;
    Caption = 'Lots';
    DataClassification = CustomerContent;
    Extensible = false;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Specifies the value of the Item No. field.';
        }
        field(3; "Lot No."; Code[10])
        {
            Caption = 'Lot No.';
            ToolTip = 'Specifies the value of the Lot No. field.';
        }
        field(4; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            ToolTip = 'Specifies the value of the Location Code field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1532 - Inv. Status Overflow Issue        
        /// </summary>
        field(5; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            ToolTip = 'Specifies the value of the Item Description field.';
        }
        field(6; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
            ToolTip = 'Specifies the value of the Item Description 2 field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1532 - Inv. Status Overflow Issue 
        /// </summary>
        field(7; "Search Description"; Text[100])
        {
            Caption = 'Search Description';
            ToolTip = 'Specifies the value of the Search Description field.';
        }
        field(8; "Pack Size"; Text[30])
        {
            Caption = 'Pack Size';
            ToolTip = 'Specifies the value of the Pack Size field.';
        }
        field(9; "Method of Catch"; Text[50])
        {
            Caption = 'Method of Catch';
            ToolTip = 'Specifies the value of the Method of Catch field.';
        }
        field(10; "Country of Origin"; Text[30])
        {
            Caption = 'Country of Origin';
            ToolTip = 'Specifies the value of the Country of Origin field.';
        }
        field(11; "Brand Code"; Code[20])
        {
            Caption = 'Brand Code';
            ToolTip = 'Specifies the value of the Brand Code field.';
        }
        field(12; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            ToolTip = 'Specifies the value of the Item Category Code field.';
        }
        field(13; "PO Number"; Code[20])
        {
            Caption = 'PO Number';
            ToolTip = 'Specifies the value of the PO Number field.';
        }
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(14; "Alternate Lot No."; Code[20])
        // {
        //     Caption = 'Alternate Lot No.';
        //     CalcFormula = lookup("Lot No. Information"."OBF-Alternate Lot No." WHERE("Item No." = FIELD("Item No."),
        //                                                                             "Lot No." = FIELD("Lot No.")));
        //     FieldClass = FlowField;
        //     Editable = false;
        // }
        field(15; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(16; "Label Value"; Text[50])
        {
            Caption = 'Label';
            Editable = false;
        }
        field(17; "Buyer Code"; Code[20])
        {
            Caption = 'Buyer Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the value of the Buyer Code field.';
        }
        field(18; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(19; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the Vendor Name field.';
        }
        field(21; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 2 : 5;
            ToolTip = 'Specifies the value of the Unit Cost field.';
        }
        field(22; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            ToolTip = 'Specifies the value of the Receipt Date field.';
        }
        field(30; "On Hand Quantity"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                              "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                              "Posting Date" = field("Date Filter")));
            Caption = 'On Hand Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the On Hand Quantity field.';
        }
        field(31; "Total Quantity for Item Lot"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                              "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                              "Posting Date" = field("Date Filter")));
            Caption = 'Total Quantity for Item Lot';
            DecimalPlaces = 0 : 0;
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(32; "On Order Quantity"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                                "Source Type" = const(39),
                                                                                "Source Subtype" = const("1"),
                                                                                SBSISSLotIsOnHand2 = const(false)));
            Caption = 'On Order Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Qty. on Sales Order"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                 "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                                 "Source Type" = const(37),
                                                                                 "Source Subtype" = const("1"),
                                                                                 "Source ID" = field("Sales Order Filter")));
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
        }
        field(34; "Total Available Quantity"; Decimal)
        {
            Caption = 'Available Qty.';
            DecimalPlaces = 0 : 0;
            ToolTip = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
        }
        field(35; "Total ILE Weight for Item Lot"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."OBF-Net Weight" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                              "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                              "Posting Date" = field("Date Filter")));
            Caption = 'Total Weight for Item Lot';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "On Order Weight"; Decimal)
        {
            CalcFormula = sum("Reservation Entry".SBSISSNetWeighttoHandle where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                 "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                                 "Source Type" = const(39),
                                                                                 "Source Subtype" = const("1")));
            Caption = 'On Order Weight';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Net Weight on Sales Order"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry".SBSISSNetWeight where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                 "Location Code" = field("Location Code"), "Lot No." = field("Lot No."),
                                                                                 "Source Type" = const(37),
                                                                                 "Source Subtype" = const("1")));
            Caption = 'Net Weight on Sales Orders';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the Net Weight on Sales Orders field.';
        }
        field(38; "Available Net Weight"; Decimal)
        {
            Caption = 'Available Weight';
            DecimalPlaces = 0 : 0;
            ToolTip = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
        }
        field(39; "On Hand Weight"; Decimal)
        {
            Caption = 'On Hand Weight';
            DecimalPlaces = 0 : 0;
            Editable = false;
            ToolTip = 'Specifies the value of the On Hand Weight field.';
        }
        field(40; "Value of Inventory on Hand"; Decimal)
        {
            Caption = 'Value of Inventory on Hand.';
            DecimalPlaces = 2 : 2;
            ToolTip = 'Specifies the value of the Value of Inventory on Hand. field.';
        }
        field(41; "Sales Order Filter"; Code[250])
        {
            Caption = 'Sales Order Filter';
            FieldClass = FlowFilter;
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page 
        /// </summary>
        field(42; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            ToolTip = 'Specifies the value of the Expected Receipt Date field.';
        }
        field(43; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            ToolTip = 'Specifies the value of the Variant Code field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
        /// </summary>
        field(44; "On Order Quantity 2"; Decimal)
        {
            Caption = 'On Order Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            ToolTip = 'Specifies the value of the On Order Quantity field.';
        }
        field(45; "On Order Weight 2"; Decimal)
        {
            Caption = 'On Order Weight';
            DecimalPlaces = 0 : 0;
            Editable = false;
            ToolTip = 'Specifies the value of the On Order Weight field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
        /// </summary>
        field(52; "Sustainability Certification"; Code[10])
        {
            Caption = 'Sustainability Certification';
            FieldClass = Normal;
            TableRelation = "OBF-Certification";
            ToolTip = 'Specifies the value of the Sustainability Certification field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
        /// </summary>
        field(60; "Production Date"; Date)
        {
            Caption = 'Production Date';
            ToolTip = 'Specifies the value of the Production Date field.';
        }
        field(61; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            ToolTip = 'Specifies the value of the Expiration Date field.';
        }

        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1195 - Hold Functionality
        ///TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        /// </summary>
        field(70; "Qty. on Quality Hold"; Decimal)
        {
            // CalcFormula = Sum("OBF-Quality Ledger Entry"."Quantity (Base)" Where("Item No." = field("Item No."),
            //                                                     "Variant Code" = field("Variant Code"),
            //                                                     "Location Code" = field("Location Code"),
            //                                                     "Lot No." = field("Lot No.")));
            Caption = 'Quantity on Quality Hold';
            DecimalPlaces = 0 : 0;
            Editable = false;
            // FieldClass = FlowField;            
        }
        field(71; "On Hand Quantity 2"; Decimal)
        {
            Caption = 'On Hand Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the value of the On Hand Quantity field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        /// </summary>
        field(75; "Qty. In Transit"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."),
                                                                                 "Lot No." = field("Lot No."),
                                                                                 "Source Type" = const(39),
                                                                                 "Source Subtype" = const("1"),
                                                                                 SBSISSPurResEntryisNeg = const(true)));
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the Qty. in Transit field.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
        /// </summary>
        field(96; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            ToolTip = 'Specifies the value of the Container No. field.';
        }
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // field(93; "Label Text"; Text[50])
        // {
        //     Caption = 'Label';
        //     Editable = false;
        //     CalcFormula = Lookup("Lot No. Information"."OBF-Label" WHERE("Item No." = FIELD("Item No."),
        //                                                                 "Lot No." = FIELD("Lot No."),
        //                                                                 "Variant Code" = field("Variant Code")));
        //     FieldClass = FlowField;
        // }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
        /// </summary>
        field(100; "Purchased For"; Code[20])
        {
            Caption = 'Purchased For';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the value of the Purchased For field.';
        }
    }

    keys
    {
        key(Key1; "Entry No.") { }
        key(Key2; "Item No.", "Variant Code", "Location Code", "Lot No.") { }
    }



    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="LocationCode"></param>
    /// <param name="LotNo"></param>
    /// <param name="OrderNo"></param>
    /// <returns></returns>
    procedure CalcAvailableQtyExcludingOrder(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; LotNo: Code[10]; OrderNo: Code[20]) AvailableQuantity: Decimal
    var
        TempDistinctItemLot: Record DistinctItemLot temporary;
    begin
        TempDistinctItemLot."Entry No." := 1;
        TempDistinctItemLot."Item No." := ItemNo;
        TempDistinctItemLot."Variant Code" := VariantCode;
        TempDistinctItemLot."Location Code" := LocationCode;
        TempDistinctItemLot."Lot No." := LotNo;
        TempDistinctItemLot.SetFilter(TempDistinctItemLot."Sales Order Filter", '<>%1', OrderNo);
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        TempDistinctItemLot.CalcFields(TempDistinctItemLot."On Hand Quantity", TempDistinctItemLot."On Order Quantity", TempDistinctItemLot."Qty. on Sales Order"); // , DistinctItemLot."Qty. on Quality Hold"
        AvailableQuantity := TempDistinctItemLot."On Hand Quantity" + TempDistinctItemLot."On Order Quantity" - TempDistinctItemLot."Qty. on Sales Order"; // - DistinctItemLot."Qty. on Quality Hold";
    end;
}