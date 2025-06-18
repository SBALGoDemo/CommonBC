namespace SilverBay.Common.Inventory.Status;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using SilverBay.Common.Inventory.Tracking;
using SilverBay.Common.Inventory.Item;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// Note: This page was copied from and is similar to Page 50054 "Distinct Item Lots"
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
/// Drilldowns moved to Info Pane Management codeunit
/// Migrated from page 50053 "OBF-Inv. Stat. Summary by Date"
/// </summary>
page 60106 InventoryStatusSummaryByDate
{
    ApplicationArea = All;
    Caption = 'Inventory Status Summary by Date';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = DistinctItemLot;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field(DateFilter; this.DateFilter)
                {
                    Caption = 'As of Date Filter';
                    ToolTip = 'Specifies the value of the As of Date Filter field.';
                    trigger OnValidate()
                    begin
                        Rec.DeleteAll();
                        Rec.SetRange("Date Filter", 0D, this.DateFilter);
                        this.SetPageData();
                        Rec.FindFirst();
                        CurrPage.Update();
                        CurrPage.ItemFactBox.Page.SetValues(this.DateFilter, '', true);
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Group';
                field(ItemNo; Rec."Item No.")
                {
                    Editable = false;
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.ShowItem(Rec."Item No.");
                    end;
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
                    Visible = false;
                    Width = 10;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Editable = false;
                    Visible = false;
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
                field("Lot No."; Rec."Lot No.")
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
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Editable = false;
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                /// </summary>
                field("Production Date"; Rec."Production Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = false;
                    Width = 10;
                }
                field("On Hand Quantity"; Rec."On Hand Quantity")
                {
                    Editable = false;
                    Width = 5;
                }
                field("On Order Quantity 2"; Rec."On Order Quantity 2")
                {
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
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Editable = false;
                    Width = 10;
                }
                field("Buyer Code"; Rec."Buyer Code")
                {
                    Editable = false;
                    Visible = false;
                    Width = 5;
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
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(ItemFactBox; "Item Factbox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = field("Item No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(GetData)
            {
                Caption = 'Get Data';
                Description = '// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1399 - Prompt for Date when opening Inv. Status by Date';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Get Data action.';
                trigger OnAction()
                begin
                    this.SetPageData();
                    Rec.FindFirst();
                    CurrPage.Update();
                end;
            }

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
    var
        DateFormula: DateFormula;
    begin
        Evaluate(DateFormula, '1Y');
        this.DateFilter := CalcDate(DateFormula, WorkDate());

        Rec.DeleteAll();
        Rec.SetRange("Date Filter", 0D, this.DateFilter);
        Rec."Item No." := '';
        Rec.Insert();

        Rec.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.");
        Rec.FindFirst();

        CurrPage.Editable(true);
        CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ItemFactBox.Page.SetValues(this.DateFilter, '', true);
    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        DateFilter: Date;

    local procedure AddRecord(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]; NewLocation: Code[10]; FromILE: Boolean; var NewNextRowNo: Integer)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        UnassignedPurchaseLineQty: Decimal;
    begin
        NewNextRowNo += 1;
        Item.Get(NewItemNo);

        Rec.Init();
        Rec."Entry No." := NewNextRowNo;
        Rec."Item No." := NewItemNo;
        Rec."Variant Code" := NewVariantCode;
        Rec."Lot No." := NewLotNo;
        Rec."Location Code" := NewLocation;
        Rec.SetRange("Date Filter", 0D, this.DateFilter);
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order",
                       "Total ILE Weight for Item Lot", "On Order Weight", "Net Weight on Sales Order");

        UnassignedPurchaseLineQty := this.CalcUnassignedPurchaseLineQty(NewItemNo, NewVariantCode, NewLotNo, NewLocation);

        Rec."On Order Quantity 2" := Rec."On Order Quantity" + UnassignedPurchaseLineQty;
        Rec."On Order Weight 2" := Rec."On Order Weight" + UnassignedPurchaseLineQty * Item."Net Weight";
        if Rec."On Order Quantity 2" < 0 then begin
            Rec."On Order Quantity 2" := 0;
            Rec."On Order Weight 2" := 0;
        end;

        Rec."Item Category Code" := Item."Item Category Code";
        Rec."Country of Origin" := Item."Country/Region of Origin Code";
        Rec."Item Description" := Item.Description;
        Rec."Item Description 2" := Item."Description 2";
        Rec."Search Description" := Item."Search Description";

        if (Rec."On Hand Quantity" <> 0) or (Rec."On Order Quantity 2" > 0) then begin
            Rec."Total Available Quantity" := Rec."On Hand Quantity" + Rec."On Order Quantity 2" - Rec."Qty. on Sales Order";
            Rec."On Hand Weight" := Rec."Total ILE Weight for Item Lot";
            Rec."Available Net Weight" := Rec."On Hand Weight" + Rec."On Order Weight 2" - Rec."Net Weight on Sales Order";
            if FromILE then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", NewItemNo);
                ItemLedgerEntry.SetRange("Variant Code", NewVariantCode);
                ItemLedgerEntry.SetRange("Location Code", NewLocation);
                ItemLedgerEntry.SetRange("Lot No.", NewLotNo);
                ItemLedgerEntry.SetRange("Posting Date", 0D, this.DateFilter);
                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet() then
                    repeat
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        Rec."Value of Inventory on Hand" := Rec."Value of Inventory on Hand" + ItemLedgerEntry."Cost Amount (Expected)" +
                                ItemLedgerEntry."Cost Amount (Actual)";

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
                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                    Rec."Production Date" := ReservationEntry.SBSCOMProductionDate;

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
                    if ReservationEntry.SBSCOMPurchaserCode <> '' then
                        Rec."Buyer Code" := ReservationEntry.SBSCOMPurchaserCode;
                end;
            end;
            if Rec."On Hand Weight" <> 0 then
                Rec."Unit Cost" := Rec."Value of Inventory on Hand" / Rec."On Hand Weight"
            else
                Rec."Unit Cost" := 0;

            Rec.Insert();
        end;
    end;

    local procedure CalcUnassignedPurchaseLineQty(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]; NewLocationCode: Code[20]) UnassignedPurchaseLineQty: Decimal
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if NewLotNo = '' then begin
            Rec.SetRange("Item No.", NewItemNo);
            Rec.SetRange("Variant Code", NewVariantCode);
            Rec.SetRange("Location Code", NewLocationCode);
            Rec.CalcSums("On Order Quantity 2", "On Order Weight 2");

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

    local procedure RecordExists(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]; NewLocationCode: Code[10]) Result: Boolean
    begin
        Rec.SetRange("Item No.", NewItemNo);
        Rec.SetRange("Lot No.", NewLotNo);
        Rec.SetRange("Variant Code", NewVariantCode);
        Rec.SetRange("Location Code", NewLocationCode);
        Result := not Rec.IsEmpty;
        Rec.Reset();
        exit(Result);
    end;

    local procedure SetPageData()
    var
        DistinctItemLotLocResEntry: Query DistinctItemLotLocResEntry;
        DistinctItemLotLocationILE: Query DistinctItemLotLocationILE;
        DistinctItemLocationPurchLine: Query DistinctItemLocationPurchLine;
        DistinctItemLocationResEntry: Query DistinctItemLocationResEntry;
        NextRowNo: Integer;
    begin
        Rec.DeleteAll();

        DistinctItemLotLocationILE.SetRange(Posting_Date_Filter, 0D, this.DateFilter);
        DistinctItemLotLocationILE.Open();
        while DistinctItemLotLocationILE.Read() do
            if not this.RecordExists(DistinctItemLotLocationILE.Item_No, DistinctItemLotLocationILE.Variant_Code, DistinctItemLotLocationILE.Lot_No, DistinctItemLotLocationILE.Location_Code) then
                this.AddRecord(DistinctItemLotLocationILE.Item_No, DistinctItemLotLocationILE.Variant_Code, DistinctItemLotLocationILE.Lot_No, DistinctItemLotLocationILE.Location_Code, true, NextRowNo);

        DistinctItemLotLocResEntry.Open();
        while DistinctItemLotLocResEntry.Read() do
            if not this.RecordExists(DistinctItemLotLocResEntry.Item_No, DistinctItemLotLocResEntry.Variant_Code, DistinctItemLotLocResEntry.Lot_No, DistinctItemLotLocResEntry.Location_Code) then
                this.AddRecord(DistinctItemLotLocResEntry.Item_No, DistinctItemLotLocResEntry.Variant_Code, DistinctItemLotLocResEntry.Lot_No, DistinctItemLotLocResEntry.Location_Code, false, NextRowNo);

        DistinctItemLocationResEntry.Open();
        while DistinctItemLocationResEntry.Read() do
            if this.InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemLocationResEntry.Item_No) then
                if not this.RecordExists(DistinctItemLocationResEntry.Item_No, DistinctItemLocationResEntry.Variant_Code, '', DistinctItemLocationResEntry.Location_Code) then
                    this.AddRecord(DistinctItemLocationResEntry.Item_No, DistinctItemLocationResEntry.Variant_Code, '', DistinctItemLocationResEntry.Location_Code, false, NextRowNo);

        DistinctItemLocationPurchLine.Open();
        while DistinctItemLocationPurchLine.Read() do
            if this.InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemLocationPurchLine.Item_No) then
                if not this.RecordExists(DistinctItemLocationPurchLine.Item_No, DistinctItemLocationPurchLine.Variant_Code, '', DistinctItemLocationPurchLine.Location_Code) then
                    this.AddRecord(DistinctItemLocationPurchLine.Item_No, DistinctItemLocationPurchLine.Variant_Code, '', DistinctItemLocationPurchLine.Location_Code, false, NextRowNo);
    end;
}