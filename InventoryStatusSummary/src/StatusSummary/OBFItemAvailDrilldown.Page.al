namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

page 60302 "OBF-Item Avail. Drilldown"
{
    Caption = 'Item Avail. Drilldown';
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTableTemporary = true;
    SourceTable = "OBF-Item Availability Buffer";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date for the entry.';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the number of the item in the entry.';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the variant of the item on the line.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the entry.';
                    ApplicationArea = All;
                    Width = 30;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    ApplicationArea = All;
                }
                field(LotOnHandText; LotOnHandText)
                {
                    Caption = 'Lot Is On Hand';
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                    Width = 10;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    CaptionML = ENU = 'Remaining / Reserved Qty.';
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed or the quantity that is reserved on sales or purchase orders.';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number for the entry.';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Entry No. 2"; Rec."Entry No. 2")
                {
                    ToolTip = 'Specifies the entry number for the entry.';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
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
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                var
                    SalesHeader: Record "Sales Header";
                    PurchaseHeader: Record "Purchase Header";
                    SalesOrder: Page "Sales Order";
                    PurchaseOrder: Page "Purchase Order";
                begin
                    case rec."Document Type" of
                        Rec."Document Type"::"Sales Order":
                            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Document No.") then begin
                                SalesOrder.SetRecord(SalesHeader);
                                SalesOrder.RunModal;
                            end;
                        Rec."Document Type"::"Purchase Order":
                            if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, Rec."Document No.") then begin
                                PurchaseOrder.SetRecord(PurchaseHeader);
                                PurchaseOrder.RunModal;
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.CalcFields("Lot Is On Hand");
        if Rec."Lot No." = '' then
            LotOnHandText := ''
        else
            LotOnHandText := format(Rec."Lot Is On Hand");
    end;

    procedure SetItemData(ItemNo: Code[20]; VariantCode: Code[10]; ShowAllVariants: Boolean; AsOfDate: Date);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        NextEntryNo: integer;
    begin
        Rec.Reset;
        Rec.DeleteAll;
        ItemLedgerEntry.FindLast;
        NextEntryNo := ItemLedgerEntry."Entry No." + 1;
        AddSeparatorRecToBuffer(NextEntryNo, '----- On Hand Quantity -----');
        AddILERemainingQtyToBuffer(ItemNo, VariantCode, '', ShowAllVariants, AsOfDate, NextEntryNo);
        NextEntryNo := 0;
        AddSeparatorRecToBuffer(NextEntryNo, '--- On Purch. Order Quantity ---');
        AddPurchaseLinesToBuffer(ItemNo, VariantCode, ShowAllVariants, AsOfDate, NextEntryNo);
        AddSeparatorRecToBuffer(NextEntryNo, '--- On Sales Order Quantity ---');
        AddSalesReservToBuffer(ItemNo, VariantCode, '', ShowAllVariants, AsOfDate, NextEntryNo);
        Rec.FindLast;
    end;

    procedure SetItemLotData(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; AsOfDate: Date);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
        NextEntryNo: integer;
    begin
        ItemLedgerEntry.FindLast;
        NextEntryNo := ItemLedgerEntry."Entry No." + 10000;
        AddSeparatorRecToBuffer(NextEntryNo, '----- On Hand Quantity -----');
        AddILERemainingQtyToBuffer(ItemNo, VariantCode, LotNo, False, AsOfDate, NextEntryNo);
        NextEntryNo := 0;
        AddSeparatorRecToBuffer(NextEntryNo, '--- On Purch. Order Quantity ---');
        AddPurchaseReservToBuffer(ItemNo, VariantCode, LotNo, false, AsOfDate, NextEntryNo);
        AddSeparatorRecToBuffer(NextEntryNo, '--- On Sales Order Quantity ---');
        AddSalesReservToBuffer(ItemNo, VariantCode, LotNo, false, AsOfDate, NextEntryNo);
        Rec.FindLast;
    end;

    local procedure AddILERemainingQtyToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; ShowAllVariants: Boolean; AsOfDate: Date; var NextEntryNo: integer);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservEntry: Record "Reservation Entry";
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
        if ItemLedgerEntry.FindSet then
            repeat
                Rec.TransferFields(ItemLedgerEntry);
                Rec."Entry No. 2" := Rec."Entry No.";
                NextEntryNo -= 1;
                Rec."Entry No." := NextEntryNo;
                Rec.Insert;
            until ItemLedgerEntry.Next = 0;
    End;

    local procedure AddPurchaseReservToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; ShowAllVariants: Boolean; AsOfDate: Date;
      var NextEntryNo: integer);
    var
        ReservEntry: Record "Reservation Entry";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
    begin
        Item.get(ItemNo);
        ReservEntry.RESET;
        ReservEntry.SetRange("Item No.", ItemNo);
        if not ShowAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            ReservEntry.SetRange("Lot No.", LotNo);
        ReservEntry.SetRange("Source Type", 39);
        ReservEntry.SetRange("Source SubType", 1);
        IF ReservEntry.FindSet THEN
            REPEAT
                IF PurchaseHeader.get(PurchaseHeader."Document Type"::Order, ReservEntry."Source ID") then
                    IF PurchaseLine.get(PurchaseHeader."Document Type", PurchaseHeader."No.", ReservEntry."Source Ref. No.") then begin
                        NextEntryNo -= 1;
                        Rec.init;
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
                        Rec.Insert;
                    end;
            until ReservEntry.next = 0;
    End;

    local procedure AddSalesReservToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; ShowAllVariants: Boolean; AsOfDate: Date;
      var NextEntryNo: integer);
    var
        ReservEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        ReservEntry.RESET;
        ReservEntry.SetRange("Item No.", ItemNo);
        if not ShowAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if LotNo <> '' then
            ReservEntry.SetRange("Lot No.", LotNo);
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("Source SubType", 1);
        IF ReservEntry.FindSet THEN
            REPEAT
                IF SalesHeader.get(SalesHeader."Document Type"::Order, ReservEntry."Source ID") then
                    IF SalesLine.get(SalesHeader."Document Type", SalesHeader."No.", ReservEntry."Source Ref. No.") then begin
                        NextEntryNo -= 1;
                        Rec.init;
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
                        Rec.Insert;
                    end;
            until ReservEntry.next = 0;
    End;

    local procedure AddSeparatorRecToBuffer(var NextEntryNo: integer; Desc: text[50]);
    begin
        Rec.init;
        Rec."Entry Type" := Rec."Entry Type"::" ";
        Rec.Description := Desc;
        if NextEntryNo = -1 then // There were no Purchase Lines so overwrite purchase line separator rec with sales line separator
            Rec.Modify
        else begin
            NextEntryNo -= 1;
            Rec."Entry No." := NextEntryNo;
            Rec."Entry No. 2" := 0;
            Rec.Insert;
        end;
    end;

    local procedure AddPurchaseLinesToBuffer(ItemNo: Code[20]; VariantCode: Code[10]; ShowAllVariants: Boolean; AsOfDate: Date;
      var NextEntryNo: integer);
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
    begin
        Item.get(ItemNo);
        PurchaseLine.SetRange("No.", ItemNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if not ShowAllVariants then
            PurchaseLine.SetRange("Variant Code", VariantCode);
        PurchaseLine.SetFilter("Quantity (Base)", '<>%1', 0);
        IF PurchaseLine.FindSet THEN
            REPEAT
                NextEntryNo -= 1;
                Rec.init;
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
                //Rec."OBF-Quantity (Source UOM)" := ReservEntry."Quantity (Base)" * PurchaseLine."Qty. per Unit of Measure";
                Rec."Entry Type" := Rec."Entry Type"::Purchase;
                Rec."Document Type" := Rec."Document Type"::"Purchase Order";
                Rec.Description := PurchaseLine.Description;
                Rec."Item Category Code" := Item."Item Category Code";
                Rec."Location Code" := PurchaseLine."Location Code";

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                //Rec."Lot No." := PurchaseLine."OBF-Lot No.";

                Rec.Insert;
            until PurchaseLine.next = 0;
    End;

    var
        LotOnHandText: Text[10];
}

