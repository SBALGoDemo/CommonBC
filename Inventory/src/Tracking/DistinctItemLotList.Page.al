namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using SilverBay.Inventory.System;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders
/// Reverse sign of "Qty. on Sales Orders" and Net Weight on Sales Orders in "Total Available Quantity" and "Total Available Net Weight" calculation
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
/// Drilldowns moved to Info Pane Management codeunit
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1195 - Hold Functionality
/// Replaced "Quantity on Quality Hold" with "Qty on Quality Hold"
/// Migrated from page 50054 "OBF-Distinct Item Lots"
/// </summary>
page 60303 DistinctItemLotList
{
    ApplicationArea = All;
    Caption = 'Distinct Item Lots';
    Editable = false;
    PageType = List;
    SourceTable = DistinctItemLot;
    layout
    {
        area(Content)
        {
            group(ItemInfo)
            {
                Caption = 'Item Information';
                field(ItemNo; Rec."Item No.")
                {
                    Editable = false;
                    Width = 10;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    Width = 30;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    Editable = false;
                    Width = 15;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Editable = false;
                    Width = 30;
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    Editable = false;
                    Visible = false;
                    Width = 10;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Editable = false;
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
                    Editable = false;
                    Width = 10;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.LocationOnDrillDown(Rec."Location Code");
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.VendorOnDrillDown(Rec."Vendor No.");
                    end;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                /// </summary>
                field("Container No."; Rec."Container No.")
                {
                    Editable = false;
                    Visible = true;
                    Width = 10;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
                /// </summary>
                field("On Hand Quantity 2"; Rec."On Hand Quantity 2")
                {
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnHandDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
                /// </summary>
                field("Qty. In Transit"; Rec."Qty. In Transit")
                {
                    Editable = false;
                    Width = 5;
                }
                field("On Order Quantity 2"; Rec."On Order Quantity 2")
                {
                    Caption = '+On Order Quantity';
                    Editable = false;
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    Caption = '-Qty. on Sales Orders';
                    Editable = false;
                    Width = 5;
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    Caption = 'Total Available Quantity';
                    Editable = false;
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("On Hand Weight"; Rec."On Hand Weight")
                {
                    Editable = false;
                    Visible = false;
                    Width = 10;
                }
                field("On Order Weight 2"; Rec."On Order Weight 2")
                {
                    Caption = '+On Order Weight';
                    Editable = false;
                    Visible = false;
                    Width = 10;
                }
                field("Net Weight on Sales Order"; Rec."Net Weight on Sales Order")
                {
                    Caption = '-Net Weight on Sales Orders';
                    Editable = false;
                    Visible = false;
                    Width = 10;
                }
                field("Available Net Weight"; Rec."Available Net Weight")
                {
                    Editable = false;
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Editable = false;
                    Width = 10;
                }
                field("PO Number"; Rec."PO Number")
                {
                    Editable = false;
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                    end;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = false;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                /// </summary>
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Editable = false;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                /// </summary>
                field("Production Date"; Rec."Production Date")
                {
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Editable = false;
                }
                field(Buyer; Rec."Buyer Code")
                {
                    trigger OnDrillDown()
                    begin
                        Rec.BuyerOnDrillDown();
                    end;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
                /// </summary>
                field("Purchased For"; Rec."Purchased For")
                {
                    Editable = false;
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
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        DateFilter: Date;

    internal procedure SetItem(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewDateFilter: Date)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        this.DateFilter := NewDateFilter;

        if this.DateFilter = 0D then
            this.DateFilter := Today();

        Rec.SetRange("Date Filter", 0D, this.DateFilter);

        this.SetPageDataForItem(NewItemNo, NewVariantCode);
    end;

    internal procedure SetOnHandQtyFilter()
    begin
        Rec.SetFilter("On Hand Quantity", '<>%1', 0);
    end;

    local procedure AddRecord(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]; NewLocation: Code[10]; FromILE: Boolean; var NewNextRowNo: Integer)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        PurchaseUnitCost: Decimal;
    begin
        NewNextRowNo += 1;
        Item.Get(NewItemNo);

        Rec.Init();
        Rec."Entry No." := NewNextRowNo;
        Rec."Item No." := NewItemNo;
        Rec."Variant Code" := NewVariantCode;
        Rec."Lot No." := NewLotNo;
        Rec."Location Code" := NewLocation;
        PurchaseUnitCost := 0;
        Rec.SetRange("Date Filter", 0D, this.DateFilter);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order", "On Hand Quantity", "Total ILE Weight for Item Lot", "On Order Weight", "Net Weight on Sales Order", "Qty. In Transit");

        Rec."On Hand Quantity 2" := Rec."On Hand Quantity"; //https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

        Rec."On Order Quantity 2" := Rec."On Order Quantity" + this.CalculateUnassigned(NewItemNo, NewVariantCode, NewLotNo, NewLocation);

        Rec."On Order Weight 2" := Rec."On Order Quantity 2" * Item."Net Weight";

        if (Rec."On Hand Quantity" <> 0) or (Rec."On Order Quantity 2" <> 0) or (Rec."Qty. on Sales Order" <> 0) then begin //https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            Rec."Item Category Code" := Item."Item Category Code";
            Rec."Country of Origin" := Item."Country/Region of Origin Code";
            Rec."Item Description" := Item.Description;
            Rec."Item Description 2" := Item."Description 2";
            Rec."Search Description" := Item."Search Description";

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
            Rec."Total Available Quantity" := Rec."On Hand Quantity" + Rec."On Order Quantity 2" - Rec."Qty. on Sales Order" - Rec."Qty. In Transit"; //https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

            if Rec."On Hand Quantity" <> 0 then
                Rec."On Hand Weight" := Rec."Total ILE Weight for Item Lot" - Rec."Qty. In Transit" * Item."Net Weight" //https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            else
                Rec."On Hand Weight" := 0;

            Rec."Available Net Weight" := Rec."Total Available Quantity" * Item."Net Weight";

            if FromILE then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", NewItemNo);
                ItemLedgerEntry.SetRange("Lot No.", NewLotNo);

                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet() then
                    repeat

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                        if ItemLedgerEntry.Quantity > 0 then
                            Rec."Expiration Date" := ItemLedgerEntry."Expiration Date";

                        if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" then begin
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
                ReservationEntry.SetRange("Item No.", NewItemNo);
                ReservationEntry.SetRange("Lot No.", NewLotNo);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype"::"1");
                if ReservationEntry.FindFirst() then begin
                    Rec."PO Number" := ReservationEntry."Source ID";

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                    Rec."Production Date" := ReservationEntry.SBSINVProductionDate;
                    Rec."Expiration Date" := ReservationEntry."Expiration Date";
                    if ReservationEntry.SBSINVPurchaserCode <> '' then
                        Rec."Buyer Code" := ReservationEntry.SBSINVPurchaserCode;

                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then begin
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                        Rec."Vendor No." := PurchaseLine."Buy-from Vendor No.";
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

    local procedure CalculateUnassigned(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]; NewLocationCode: Code[20]) UnassignedPurchaseLineQty: Decimal
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if NewLotNo <> '' then begin
            Rec.SetRange("Item No.", NewItemNo);
            Rec.SetRange("Variant Code", NewVariantCode);
            Rec.SetRange("Location Code", NewLocationCode);
            Rec.CalcSums("On Order Quantity 2");

            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            PurchaseLine.SetRange("No.", NewItemNo);
            PurchaseLine.SetRange("Variant Code", NewVariantCode);
            PurchaseLine.SetRange("Location Code", NewLocationCode);
            PurchaseLine.CalcSums("Outstanding Qty. (Base)");

            UnassignedPurchaseLineQty := PurchaseLine."Outstanding Qty. (Base)" - Rec."On Order Quantity 2";
            Rec.Reset();
            Rec.SetRange("Date Filter", 0D, this.DateFilter);
        end;
    end;

    local procedure RecordExists(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]) Result: Boolean
    begin
        Rec.SetRange("Item No.", NewItemNo);
        Rec.SetRange("Lot No.", NewLotNo);
        Rec.SetRange("Variant Code", NewVariantCode);
        Result := not Rec.IsEmpty;
        Rec.Reset();
    end;

    local procedure SetPageDataForItem(NewItemNo: Code[20]; NewVariantCode: Code[10])
    var
        DistinctItemLotLocResEntry: Query DistinctItemLotLocResEntry;
        DistinctItemLocationPurchLine: Query DistinctItemLocationPurchLine;
        DistinctItemLocationResEntry: Query DistinctItemLocationResEntry;
        NextRowNo: Integer;
    begin
        DistinctItemLotLocResEntry.SetRange(Item_No, NewItemNo);
        DistinctItemLotLocResEntry.SetRange(Variant_Code, NewVariantCode);
        DistinctItemLotLocResEntry.Open();
        while DistinctItemLotLocResEntry.Read() do
            if not this.RecordExists(DistinctItemLotLocResEntry.Item_No, DistinctItemLotLocResEntry.Variant_Code, DistinctItemLotLocResEntry.Lot_No) then
                this.AddRecord(DistinctItemLotLocResEntry.Item_No, DistinctItemLotLocResEntry.Variant_Code, DistinctItemLotLocResEntry.Lot_No, DistinctItemLotLocResEntry.Location_Code, false, NextRowNo);

        DistinctItemLocationResEntry.SetRange(Item_No, NewItemNo);
        DistinctItemLocationResEntry.SetRange(Variant_Code, NewVariantCode);
        DistinctItemLocationResEntry.Open();
        while DistinctItemLocationResEntry.Read() do
            if not this.RecordExists(DistinctItemLocationResEntry.Item_No, DistinctItemLocationResEntry.Variant_Code, '') then
                this.AddRecord(DistinctItemLocationResEntry.Item_No, DistinctItemLocationResEntry.Variant_Code, '', DistinctItemLocationResEntry.Location_Code, false, NextRowNo);

        DistinctItemLocationPurchLine.SetRange(Item_No, NewItemNo);
        DistinctItemLocationPurchLine.SetRange(Variant_Code, NewVariantCode);
        DistinctItemLocationPurchLine.Open();
        while DistinctItemLocationPurchLine.Read() do
            if not this.RecordExists(DistinctItemLocationPurchLine.Item_No, DistinctItemLocationPurchLine.Variant_Code, '') then
                this.AddRecord(DistinctItemLocationPurchLine.Item_No, DistinctItemLocationPurchLine.Variant_Code, '', DistinctItemLocationPurchLine.Location_Code, false, NextRowNo);
    end;
}