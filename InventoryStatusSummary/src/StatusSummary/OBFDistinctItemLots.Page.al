namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders
//     Reverse sign of "Qty. on Sales Orders" and Net Weight on Sales Orders in "Total Available Quantity" and "Total Available Net Weight" calculation
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
// Drilldowns moved to Info Pane Management codeunit
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1195 - Hold Functionality
// Replaced "Quantity on Quality Hold" with "Qty on Quality Hold"
page 60300 "OBF-Distinct Item Lots"
{
    ApplicationArea = All;
    Caption = 'Distinct Item Lots';
    Editable = false;
    PageType = List;
    SourceTable = DistinctItemLot;
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            group(ItemInfo)
            {
                Caption = 'Item Information';
                field(ItemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Width = 10;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                    Width = 10;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Item Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Width = 30;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    Caption = 'Item Description 2';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description 2 field.';
                    Width = 15;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Caption = 'Search Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Search Description field.';
                    Width = 30;
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    Caption = 'Pack Size';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Pack Size field.';
                    Width = 10;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Caption = 'Method of Catch';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Method of Catch field.';
                    Width = 10;
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    Caption = 'Country of Origin';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Country of Origin field.';
                    Width = 10;
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    Caption = 'Brand Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Brand Code field.';
                    Visible = false;
                    Width = 10;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                    Visible = true;
                    Width = 10;
                }
                field(DateFilter; this.DateFilter)
                {
                    Caption = 'As Of Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the As Of Date field.';
                    Visible = true;
                }
            }
            repeater(Group)
            {
                Caption = 'Group';
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                    Width = 10;
                }

                // TODO: REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Alternate Lot No."; "Alternate Lot No.")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }

                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.LocationOnDrillDown(Rec."Location Code");
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.VendorOnDrillDown(Rec."Vendor No.");
                    end;
                }

                // FIXME: REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Label Text"; "Label Text")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                field("Container No."; Rec."Container No.")
                {
                    Caption = 'Container No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Visible = true;
                    Width = 10;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
                field("Sustainability Certification"; Rec."Sustainability Certification")
                {
                    Caption = 'Sustainability Certification';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sustainability Certification field.';
                    Visible = true;
                    Width = 10;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
                field("On Hand Quantity 2"; Rec."On Hand Quantity 2")
                {
                    Caption = 'On Hand Quantity';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Hand Quantity field.';
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnHandDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
                field("Qty. In Transit"; Rec."Qty. In Transit")
                {
                    Caption = 'Qty. in Transit';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. in Transit field.';
                    Width = 5;
                }

                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Qty. on Quality Hold"; "Qty. on Quality Hold")
                // {
                //     Editable = false;
                //     Width = 5;
                //     DecimalPlaces = 0 : 0;
                //     ApplicationArea = All;
                // }

                field("On Order Quantity 2"; Rec."On Order Quantity 2")
                {
                    CaptionML = ENU = '+On Order Quantity';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Quantity field.';
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    CaptionML = ENU = '-Qty. on Sales Orders';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
                    Width = 5;
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    CaptionML = ENU = 'Total Available Quantity';
                    Editable = false;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("On Hand Weight"; Rec."On Hand Weight")
                {
                    Caption = 'On Hand Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Hand Weight field.';
                    Visible = false;
                    Width = 10;
                }
                field("On Order Weight 2"; Rec."On Order Weight 2")
                {
                    CaptionML = ENU = '+On Order Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Weight field.';
                    Visible = false;
                    Width = 10;
                }
                field("Net Weight on Sales Order"; Rec."Net Weight on Sales Order")
                {
                    CaptionML = ENU = '-Net Weight on Sales Orders';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Weight on Sales Orders field.';
                    Visible = false;
                    Width = 10;
                }
                field("Available Net Weight"; Rec."Available Net Weight")
                {
                    CaptionML = ENU = 'Available Net Weight';
                    Editable = false;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    Width = 10;
                }
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Caption = 'Value of Inventory on Hand.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Value of Inventory on Hand. field.';
                    Width = 10;
                }
                field("PO Number"; Rec."PO Number")
                {
                    Caption = 'PO Number';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PO Number field.';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                    end;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Caption = 'Receipt Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receipt Date field.';
                }
                //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                field("OBF-Production Date"; Rec."OBF-Production Date")
                {
                    Caption = 'Production Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Production Date field.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Caption = 'Expiration Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field(Buyer; Rec."Buyer Code")
                {
                    Caption = 'Buyer Code';
                    ToolTip = 'Specifies the value of the Buyer Code field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.BuyerOnDrillDown(Rec."Buyer Code");
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
                field("OBF-Purchased For"; Rec."OBF-Purchased For")
                {
                    Caption = 'Purchased For';
                    ToolTip = 'Specifies the value of the Purchased For field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Show Source Document")
            {
                Caption = 'Show Source Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Source Document action.';
                trigger OnAction()
                begin
                    this.InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.");
        Rec.FindFirst();
        Rec.SetRange("Date Filter", 0D, this.DateFilter);
        CurrPage.Update();
    end;

    var
        InfoPaneMgmt: Codeunit "OBF-Info Pane Mgmt";
        ItemNo: Code[20];
        DateFilter: Date;

    procedure SetItem(pItemNo: Code[20]; pVariantCode: Code[10]; pDateFilter: Date)
    begin
        this.ItemNo := pItemNo;
        if pDateFilter = 0D then
            this.DateFilter := Today
        else
            this.DateFilter := pDateFilter;
        Rec.DeleteAll();
        Rec.SetRange("Date Filter", 0D, this.DateFilter);
        this.SetPageDataForItem(pItemNo, pVariantCode, this.DateFilter);
    end;

    procedure SetOnHandQtyFilter()
    begin
        Rec.SetFilter("On Hand Quantity", '<>%1', 0);
    end;

    local procedure AddRecord(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[10]; pLocation: Code[10]; FromILE: Boolean; pDateFilter: Date; var pNextRowNo: Integer)
    var
        InventorySetup: Record "Inventory Setup";
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        PurchaseUnitCost: Decimal;
        //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
        UnassignedPurchaseLineQty: Decimal;
    begin
        Item.Get(pItemNo);
        InventorySetup.Get();
        pNextRowNo += 1;
        Rec.Init();
        Rec."Entry No." := pNextRowNo;
        Rec."Item No." := pItemNo;
        Rec."Variant Code" := pVariantCode;
        Rec."Lot No." := pLotNo;
        Rec."Location Code" := pLocation;
        PurchaseUnitCost := 0;
        Rec.SetRange("Date Filter", 0D, pDateFilter);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order", "On Hand Quantity",
            "Total ILE Weight for Item Lot", "On Order Weight", "Net Weight on Sales Order"
            , "Qty. In Transit");

        Rec.CalcFields("Qty. on Sales Order", "Net Weight on Sales Order", "Qty. In Transit");

        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // Rec.CalcFields("Qty. on Quality Hold");

        Rec."On Hand Quantity 2" := Rec."On Hand Quantity" - Rec."Qty. on Quality Hold";

        if pLotNo = '' then begin
            this.CalculateUnassigned(pItemNo, pVariantCode, pLocation, UnassignedPurchaseLineQty);
            Rec.SetRange("Date Filter", 0D, pDateFilter);
        end;
        Rec."On Order Quantity 2" := Rec."On Order Quantity" + UnassignedPurchaseLineQty;

        //"On Order Weight 2" := "On Order Weight" + UnassignedPurchaseLineQty * Item."Net Weight";
        Rec."On Order Weight 2" := Rec."On Order Quantity 2" * Item."Net Weight";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements - commented out
        // if "On Order Quantity 2" < 0 then begin
        //     "On Order Quantity 2" := 0;
        //     "On Order Weight 2" := 0;
        // end;

        if (Rec."On Hand Quantity" <> 0) or (Rec."On Order Quantity 2" <> 0) or (Rec."Qty. on Sales Order" <> 0) or (Rec."Qty. on Quality Hold" <> 0) then begin
            Rec."Item Category Code" := Item."Item Category Code";
            Rec."Country of Origin" := Item."Country/Region of Origin Code";
            Rec."Item Description" := Item.Description;
            Rec."Item Description 2" := Item."Description 2";
            Rec."Search Description" := Item."Search Description";

            //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            // Rec."Pack Size" := Item."OBF-Pack Size";
            // IF MethodofCatch.get(Item."OBF-Method of Catch") then
            //     Rec."Method of Catch" := MethodofCatch.Description;
            // Rec."Brand Code" := Item."OBF-Brand Code";

            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
            // Rec."Buyer Code" := Item."OBF-Purchaser Code";

            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
            // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
            //     Rec."OBF-Purchased For" := ItemVariantLotInfo."Purchased For";

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
            Rec."Total Available Quantity" := Rec."On Hand Quantity" + Rec."On Order Quantity 2" - Rec."Qty. on Sales Order" - Rec."Qty. on Quality Hold" - Rec."Qty. In Transit";

            if Rec."On Hand Quantity" <> 0 then
                Rec."On Hand Weight" := Rec."Total ILE Weight for Item Lot" - Rec."Qty. on Quality Hold" * Item."Net Weight" - Rec."Qty. In Transit" * Item."Net Weight"
            else
                Rec."On Hand Weight" := 0;

            //"Available Net Weight" := "On Hand Weight" + "On Order Weight 2" - "Net Weight on Sales Order";
            Rec."Available Net Weight" := Rec."Total Available Quantity" * Item."Net Weight";

            if FromILE then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", pItemNo);
                ItemLedgerEntry.SetRange("Lot No.", pLotNo);

                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet() then
                    repeat

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                        if ItemLedgerEntry.Quantity > 0 then
                            Rec."Expiration Date" := ItemLedgerEntry."Expiration Date";
                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // Rec."OBF-Production Date" := ItemLedgerEntry."OBF-Production Date";
                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1040 - Set Receipt Date on Item Ledger Entries
                        // Rec."Receipt Date" := ItemLedgerEntry."OBF-Receipt Date";
                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
                        // Rec."Sustainability Certification" := ItemLedgerEntry."OBF-Sustainability Cert.";
                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                        // Rec."Container No." := ItemLedgerEntry."OBF-Container No.";

                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
                        //     Rec."Value of Inventory on Hand" := ItemVariantLotInfo."Value Of Inventory On Hand";
                        if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" then begin
                            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                            // if ItemLedgerEntry."OBF-Purchase Order No." <> '' then
                            //     Rec."PO Number" := ItemLedgerEntry."OBF-Purchase Order No."
                            // else
                            Rec."PO Number" := ItemLedgerEntry."Document No.";

                            if PurchRcptHeader.Get(ItemLedgerEntry."Document No.") then
                                if PurchRcptHeader."Purchaser Code" <> '' then
                                    Rec."Buyer Code" := PurchRcptHeader."Purchaser Code";
                        end else
                            if (Rec."Receipt Date" = 0D) and (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") then
                                Rec."PO Number" := ItemLedgerEntry."Document No.";

                        if ItemLedgerEntry."Source Type" = ItemLedgerEntry."Source Type"::Vendor then
                            Rec."Vendor No." := ItemLedgerEntry."Source No.";
                    until (ItemLedgerEntry.Next() = 0);
            end else begin
                ReservationEntry.Reset();
                ReservationEntry.SetRange("Item No.", pItemNo);
                ReservationEntry.SetRange("Lot No.", pLotNo);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype"::"1");
                if ReservationEntry.FindFirst() then begin
                    Rec."PO Number" := ReservationEntry."Source ID";

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                    Rec."OBF-Production Date" := ReservationEntry.SBSISSProductionDate;
                    Rec."Expiration Date" := ReservationEntry."Expiration Date";
                    if ReservationEntry.SBSISSPurchaserCode <> '' then
                        Rec."Buyer Code" := ReservationEntry.SBSISSPurchaserCode;

                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then begin
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                        Rec."Vendor No." := PurchaseLine."Buy-from Vendor No.";

                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // Rec."Sustainability Certification" := PurchaseLine."OBF-Sustainability Cert.";

                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                        // Rec."Container No." := PurchaseLine."OBF-Container No.";

                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements
                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1200 - Add "Purchase Unit Cost" field and related functionality
                        // PurchaseUnitCost := PurchaseLine."OBF-Purchase Unit Cost";
                    end;

                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - END
                end;
            end;
            if Rec."On Hand Weight" <> 0 then
                Rec."Unit Cost" := Rec."Value of Inventory on Hand" / Rec."On Hand Weight"
            else

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements
                Rec."Unit Cost" := PurchaseUnitCost;

            Rec.Insert();
        end;
    end;

    local procedure CalculateUnassigned(pItemNo: Code[20]; pVariantCode: Code[10]; pLocationCode: Code[20]; var UnassignedPurchaseLineQty: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        AssignedPurchaseLineQty: Decimal;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Variant Code", pVariantCode);
        Rec.SetRange("Location Code", pLocationCode);
        Rec.CalcSums("On Order Quantity 2", "On Order Weight 2");
        AssignedPurchaseLineQty := Rec."On Order Quantity 2";
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", pItemNo);
        PurchaseLine.SetRange("Variant Code", pVariantCode);
        PurchaseLine.SetRange("Location Code", pLocationCode);
        PurchaseLine.CalcSums("Outstanding Qty. (Base)");
        UnassignedPurchaseLineQty := PurchaseLine."Outstanding Qty. (Base)" - AssignedPurchaseLineQty;
        Rec.Reset();
    end;

    local procedure RecordExists(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[10]): Boolean
    var
        result: Boolean;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Lot No.", pLotNo);
        Rec.SetRange("Variant Code", pVariantCode);
        result := not Rec.IsEmpty;
        Rec.Reset();
        exit(result);
    end;

    local procedure SetPageDataForItem(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewDateFilter: Date)
    var
        //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
        DistinctItemLotResEntry: Query DistinctItemLotResEntry;
        DistinctItemsOnPurchLine: Query "OBF-Dist. Items On Purch. Line";
        DistinctItemLocOnOrder: Query "OBF-Distinct Item Loc On Order";
        NextRowNo: Integer;
    begin
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // ItemVariantLotInfo.SetRange(Rec."Item No.", ItemNo);
        // ItemVariantLotInfo.SetRange(Rec."Variant Code", VariantCode);

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        // ItemVariantLotInfo.SetFilter("Quantity on Hand", '>0');

        // if ItemVariantLotInfo.FindSet then
        //     repeat
        //         AddRecord(ItemVariantLotInfo."Item No.", ItemVariantLotInfo."Variant Code", ItemVariantLotInfo."Lot No.", ItemVariantLotInfo."Location Code", True, pDateFilter, NextRowNo);
        //     until (ItemVariantLotInfo.Next = 0);

        DistinctItemLotResEntry.SetRange(Item_No, NewItemNo);
        DistinctItemLotResEntry.SetRange(Variant_Code, NewVariantCode);
        DistinctItemLotResEntry.Open();
        while DistinctItemLotResEntry.Read() do
            if not this.RecordExists(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No) then
                this.AddRecord(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No, DistinctItemLotResEntry.Location_Code, false, NewDateFilter, NextRowNo);

        DistinctItemLocOnOrder.SetRange(Item_No, NewItemNo);
        DistinctItemLocOnOrder.SetRange(Variant_Code, NewVariantCode);
        DistinctItemLocOnOrder.Open();
        while DistinctItemLocOnOrder.Read() do
            if not this.RecordExists(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '') then
                this.AddRecord(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '',
                        DistinctItemLocOnOrder.Location_Code, false, NewDateFilter, NextRowNo);

        DistinctItemsOnPurchLine.SetRange(Item_No, NewItemNo);
        DistinctItemsOnPurchLine.SetRange(Variant_Code, NewVariantCode);
        DistinctItemsOnPurchLine.Open();
        while DistinctItemsOnPurchLine.Read() do
            if not this.RecordExists(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '') then
                this.AddRecord(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '',
                        DistinctItemsOnPurchLine.Location_Code, false, NewDateFilter, NextRowNo);
    end;
}
