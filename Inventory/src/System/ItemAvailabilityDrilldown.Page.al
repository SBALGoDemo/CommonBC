namespace SilverBay.Inventory.System;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

/// <summary>
/// TODO: Monitor and consider migrating this object to the Common app if/when a future requirement would 
/// cause us to want to take dependency on the Inventory app rather than Common because of the code location.
/// This code was initially created in the Inventory app to expedite refactoring and deployment of code originally
/// written for Orca Bay to Silver Bay's BC. 
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// Migrated from page 50058 "OBF-Item Avail. Drilldown"
/// </summary>
page 60301 ItemAvailabilityDrilldown
{
    ApplicationArea = All;
    Caption = 'Item Availability Drilldown';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = ItemAvailabilityBuffer;
    SourceTableView = sorting("Entry No.")
                      order(descending);

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Caption = 'Control1';
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting/Receipt /Shipment Date';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                }
                field("Document Type"; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    BlankZero = true;
                    Caption = 'Document Line No.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    Width = 30;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Caption = 'Expiration Date';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                }
                field(LotOnHandText; this.LotOnHandText)
                {
                    Caption = 'Lot Is On Hand';
                    ToolTip = 'Specifies the value of the Lot Is On Hand field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    Width = 10;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Quantity';
                    Visible = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    BlankZero = true;
                    Caption = 'Remaining / Reserved Qty.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    Visible = false;
                }
                field("Entry No. 2"; Rec."Entry No. 2")
                {
                    BlankZero = true;
                    Caption = 'Entry No.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Show Document")
            {
                Caption = 'Show Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Document action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    SalesHeader: Record "Sales Header";
                    PurchaseOrder: Page "Purchase Order";
                    SalesOrder: Page "Sales Order";
                begin
                    case Rec."Document Type" of
                        Rec."Document Type"::"Sales Order":
                            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Document No.") then begin
                                SalesOrder.SetRecord(SalesHeader);
                                SalesOrder.RunModal();
                            end;
                        Rec."Document Type"::"Purchase Order":
                            if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, Rec."Document No.") then begin
                                PurchaseOrder.SetRecord(PurchaseHeader);
                                PurchaseOrder.RunModal();
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetAutoCalcFields("Lot Is On Hand");
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Lot No." = '' then
            this.LotOnHandText := ''
        else
            this.LotOnHandText := Format(Rec."Lot Is On Hand");
    end;

    var
        LotOnHandText: Text[10];

    internal procedure SetItemData(ItemNo: Code[20]; VariantCode: Code[10]; ShowAllVariants: Boolean; AsOfDate: Date)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        NextEntryNo: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        ItemLedgerEntry.FindLast();
        NextEntryNo := ItemLedgerEntry."Entry No." + 1;
        this.AddSeparatorRecToBuffer(NextEntryNo, '----- On Hand Quantity -----');
        this.AddILERemainingQtyToBuffer(ItemNo, VariantCode, '', ShowAllVariants, AsOfDate, NextEntryNo);
        NextEntryNo := 0;
        this.AddSeparatorRecToBuffer(NextEntryNo, '--- On Purch. Order Quantity ---');
        this.AddPurchaseLinesToBuffer(ItemNo, VariantCode, ShowAllVariants, NextEntryNo);
        this.AddSeparatorRecToBuffer(NextEntryNo, '--- On Sales Order Quantity ---');
        this.AddSalesReservToBuffer(ItemNo, VariantCode, '', ShowAllVariants, NextEntryNo);
        Rec.FindLast();
    end;

    internal procedure SetItemLotData(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; AsOfDate: Date)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        NextEntryNo: Integer;
    begin
        ItemLedgerEntry.FindLast();
        NextEntryNo := ItemLedgerEntry."Entry No." + 10000;
        this.AddSeparatorRecToBuffer(NextEntryNo, '----- On Hand Quantity -----');
        this.AddILERemainingQtyToBuffer(ItemNo, VariantCode, LotNo, false, AsOfDate, NextEntryNo);
        NextEntryNo := 0;
        this.AddSeparatorRecToBuffer(NextEntryNo, '--- On Purch. Order Quantity ---');
        this.AddPurchaseReservToBuffer(ItemNo, VariantCode, LotNo, false, NextEntryNo);
        this.AddSeparatorRecToBuffer(NextEntryNo, '--- On Sales Order Quantity ---');
        this.AddSalesReservToBuffer(ItemNo, VariantCode, LotNo, false, NextEntryNo);
        Rec.FindLast();
    end;

    local procedure AddILERemainingQtyToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ShowAllVariants: Boolean; AsOfDate: Date; var NextEntryNo: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        if not ShowAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            ItemLedgerEntry.SetRange("Lot No.", LotNo);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
        if (AsOfDate >= Today) or (AsOfDate = 0D) then
            ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        if ItemLedgerEntry.FindSet() then
            repeat
                Rec.TransferFields(ItemLedgerEntry);
                Rec."Entry No. 2" := Rec."Entry No.";
                NextEntryNo -= 1;
                Rec."Entry No." := NextEntryNo;
                Rec.Insert();
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure AddPurchaseLinesToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; ShowAllVariants: Boolean; var NextEntryNo: Integer)
    var
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
    begin
        Item.Get(ItemNo);
        PurchaseLine.SetRange("No.", ItemNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if not ShowAllVariants then
            PurchaseLine.SetRange("Variant Code", VariantCode);
        PurchaseLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if PurchaseLine.FindSet() then
            repeat
                NextEntryNo -= 1;
                Rec.Init();
                Rec."Entry No." := NextEntryNo;
                Rec."Entry No. 2" := 0;
                Rec."Item No." := ItemNo;
                Rec."Variant Code" := PurchaseLine."Variant Code";
                Rec."Document Type" := Rec."Document Type"::"Purchase Order";
                Rec."Document No." := PurchaseLine."Document No.";
                Rec."Document Line No." := PurchaseLine."Line No.";
                Rec."Posting Date" := PurchaseLine."Expected Receipt Date";
                Rec.Quantity := PurchaseLine."Quantity (Base)";
                Rec."Remaining Quantity" := PurchaseLine."Outstanding Qty. (Base)";
                Rec."Entry Type" := Rec."Entry Type"::Purchase;
                Rec."Document Type" := Rec."Document Type"::"Purchase Order";
                Rec.Description := PurchaseLine.Description;
                Rec."Item Category Code" := Item."Item Category Code";
                Rec."Location Code" := PurchaseLine."Location Code";

                Rec.Insert();
            until PurchaseLine.Next() = 0;
    end;

    local procedure AddPurchaseReservToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ShowAllVariants: Boolean; var NextEntryNo: Integer)
    var
        Item: Record Item;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ReservEntry: Record "Reservation Entry";
    begin
        Item.Get(ItemNo);
        ReservEntry.Reset();
        ReservEntry.SetRange("Item No.", ItemNo);
        if not ShowAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            ReservEntry.SetRange("Lot No.", LotNo);
        ReservEntry.SetRange("Source Type", 39);
        ReservEntry.SetRange("Source Subtype", 1);
        if ReservEntry.FindSet() then
            repeat
                if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, ReservEntry."Source ID") then
                    if PurchaseLine.Get(PurchaseHeader."Document Type", PurchaseHeader."No.", ReservEntry."Source Ref. No.") then begin
                        NextEntryNo -= 1;
                        Rec.Init();
                        Rec."Entry No." := NextEntryNo;
                        Rec."Entry No. 2" := 0;
                        Rec."Item No." := ItemNo;
                        Rec."Variant Code" := PurchaseLine."Variant Code";
                        Rec."Document Type" := Rec."Document Type"::"Purchase Order";
                        Rec."Document No." := PurchaseLine."Document No.";
                        Rec."Document Line No." := PurchaseLine."Line No.";
                        Rec."Posting Date" := PurchaseLine."Expected Receipt Date";
                        Rec.Quantity := PurchaseLine."Quantity (Base)";
                        Rec."Remaining Quantity" := ReservEntry."Quantity (Base)";
                        Rec."Entry Type" := Rec."Entry Type"::Purchase;
                        Rec."Document Type" := Rec."Document Type"::"Purchase Order";
                        Rec.Description := PurchaseLine.Description;
                        Rec."Item Category Code" := Item."Item Category Code";
                        Rec."Location Code" := PurchaseLine."Location Code";
                        Rec."Lot No." := ReservEntry."Lot No.";
                        Rec.Insert();
                    end;
            until ReservEntry.Next() = 0;
    end;

    local procedure AddSalesReservToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ShowAllVariants: Boolean; var NextEntryNo: Integer)
    var
        Item: Record Item;
        ReservEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        Item.Get(ItemNo);
        ReservEntry.Reset();
        ReservEntry.SetRange("Item No.", ItemNo);
        if not ShowAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            ReservEntry.SetRange("Lot No.", LotNo);
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype", 1);
        if ReservEntry.FindSet() then
            repeat
                if SalesHeader.Get(SalesHeader."Document Type"::Order, ReservEntry."Source ID") then
                    if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", ReservEntry."Source Ref. No.") then begin
                        NextEntryNo -= 1;
                        Rec.Init();
                        Rec."Entry No." := NextEntryNo;
                        Rec."Entry No. 2" := 0;
                        Rec."Item No." := ItemNo;
                        Rec."Variant Code" := SalesLine."Variant Code";
                        Rec."Entry Type" := Rec."Entry Type"::Sale;
                        Rec."Document Type" := Rec."Document Type"::"Sales Order";
                        Rec."Document No." := SalesLine."Document No.";
                        Rec."Document Line No." := SalesLine."Line No.";
                        Rec."Posting Date" := SalesLine."Shipment Date";
                        Rec.Quantity := -SalesLine."Quantity (Base)";
                        Rec."Remaining Quantity" := ReservEntry."Quantity (Base)";
                        Rec.Description := SalesLine.Description;
                        Rec."Item Category Code" := Item."Item Category Code";
                        Rec."Location Code" := SalesLine."Location Code";
                        Rec."Lot No." := ReservEntry."Lot No.";
                        Rec.Insert();
                    end;
            until ReservEntry.Next() = 0;
    end;

    local procedure AddSeparatorRecToBuffer(var NextEntryNo: Integer; Desc: Text[50])
    begin
        Rec.Init();
        Rec."Entry Type" := Rec."Entry Type"::" ";
        Rec.Description := Desc;
        if NextEntryNo = -1 then // There were no Purchase Lines so overwrite purchase line separator rec with sales line separator
            Rec.Modify()
        else begin
            NextEntryNo -= 1;
            Rec."Entry No." := NextEntryNo;
            Rec."Entry No. 2" := 0;
            Rec.Insert();
        end;
    end;
}