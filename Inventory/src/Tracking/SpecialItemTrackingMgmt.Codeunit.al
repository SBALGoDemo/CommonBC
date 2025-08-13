namespace SilverBay.Inventory.Tracking;

using Microsoft.Foundation.Enums;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Transfer;
using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
using Microsoft.Service.Document;
using Microsoft.Warehouse.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
/// This codeunit was copied from the codeunit 50054 "OBF-Special Item Tracking Mgmt"
/// </summary>
codeunit 60303 SpecialItemTrackingMgmt
{
    Access = Internal;

    procedure CallItemTracking2_PurchLine(var PurchLine: Record "Purchase Line"; SecondSourceQuantityArray: array[3] of Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ItemTrackingForm: Page "Item Tracking Lines";
    begin
        PurchLineReserve.InitFromPurchLine(TrackingSpecification, PurchLine);
        ItemTrackingForm.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
        ItemTrackingForm.SetSecondSourceQuantity(SecondSourceQuantityArray);
        Commit();
        ItemTrackingForm.RunModal();
    end;

    procedure CallItemTracking2_TrasfLine(var TransLine: Record "Transfer Line"; Direction: Enum "Transfer Direction"; SecondSourceQuantityArray: array[3] of Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
        AvailabilityDate: Date;
    begin
        TransferLineReserve.InitFromTransLine(TrackingSpecification, TransLine, AvailabilityDate, Direction);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, AvailabilityDate);
        ItemTrackingLines.SetSecondSourceQuantity(SecondSourceQuantityArray);
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure CallItemTracking_ProdOrderComp(var ProdOrderComp: Record "Prod. Order Component")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ProdOrderCompReserve: Codeunit "Prod. Order Comp.-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        if ProdOrderComp.Status = ProdOrderComp.Status::Finished then
            ItemTrackingDocMgt.ShowItemTrackingForProdOrderComp(Database::"Prod. Order Component",
            ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.", ProdOrderComp."Line No.")
        else begin
            ProdOrderComp.TestField("Item No.");
            ProdOrderCompReserve.InitFromProdOrderComp(TrackingSpecification, ProdOrderComp);
            ItemTrackingLines.SetSourceSpec(TrackingSpecification, ProdOrderComp."Due Date");
            ItemTrackingLines.SetInbound(ProdOrderComp.IsInbound());
            Commit();
            ItemTrackingLines.RunModal();
        end;
    end;

    procedure CallItemTracking_ProdOrderLine(var ProdOrderLine: Record "Prod. Order Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        ProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        if ProdOrderLine.Status = ProdOrderLine.Status::Finished then
            ItemTrackingDocMgt.ShowItemTrackingForProdOrderComp(Database::"Prod. Order Line",
            ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.", 0)
        else begin
            ProdOrderLine.TestField("Item No.");
            ProdOrderLineReserve.InitFromProdOrderLine(TrackingSpecification, ProdOrderLine);
            ItemTrackingLines.SetSourceSpec(TrackingSpecification, ProdOrderLine."Due Date");
            ItemTrackingLines.SetInbound(ProdOrderLine.IsInbound());
            Commit();
            ItemTrackingLines.RunModal();
        end;
    end;

    procedure CallItemTracking_PurchaseLine_NegativeQty(var PurchaseLine: Record "Purchase Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        PurchaseLine.TestField(Type, PurchaseLine.Type::Item);
        PurchaseLine.TestField("No.");

        if PurchaseLine."Line No." = 0 then
            Error('You must click off of the Purchase Line before opening item tracking');

        PurchLineReserve.InitFromPurchLine(TrackingSpecification, PurchaseLine);

        ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchaseLine."Order Date");
        ItemTrackingLines.SetInbound(PurchaseLine.IsInbound());
        //ItemTrackingLines.SetInitTrackingSpec(TrackingSpecification);
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure CallItemTracking_SalesLine(var SalesLine: Record "Sales Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
        RunMode: Enum "Item Tracking Run Mode";
    begin
        SalesLine.TestField(Type, SalesLine.Type::Item);
        SalesLine.TestField("No.");
        if SalesLine."Line No." = 0 then
            Error('You must click off of the Sales Line before opening item tracking');

        SalesLineReserve.InitFromSalesLine(TrackingSpecification, SalesLine);
        if ((SalesLine."Document Type" = SalesLine."Document Type"::Invoice) and (SalesLine."Shipment No." <> '')) or
            ((SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") and (SalesLine."Return Receipt No." <> ''))
        then
            ItemTrackingLines.SetRunMode(RunMode::"Combined Ship/Rcpt");
        if SalesLine."Drop Shipment" then begin
            ItemTrackingLines.SetRunMode(RunMode::"Drop Shipment");
            if SalesLine."Purchase Order No." <> '' then
                ItemTrackingLines.SetSecondSourceRowID(ItemTrackingMgt.ComposeRowID(Database::"Purchase Line",
                    1, SalesLine."Purchase Order No.", '', 0, SalesLine."Purch. Order Line No."));
        end;
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, SalesLine."Shipment Date");
        ItemTrackingLines.SetInbound(SalesLine.IsInbound());
        //ItemTrackingLines.SetInitTrackingSpec(TrackingSpecification);
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure CallItemTracking_ServiceLine(var ServiceLine: Record "Service Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
        RunMode: Enum "Item Tracking Run Mode";
    begin
        ServiceLineReserve.InitFromServLine(TrackingSpecification, ServiceLine, false);
        if ((ServiceLine."Document Type" = ServiceLine."Document Type"::Invoice) and
        (ServiceLine."Shipment No." <> ''))
    then
            ItemTrackingLines.SetRunMode(RunMode::"Combined Ship/Rcpt");
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, ServiceLine."Needed by Date");
        ItemTrackingLines.SetInbound(ServiceLine.IsInbound());
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure CallItemTracking_TransferLine(var TransLine: Record "Transfer Line"; Direction: Enum "Transfer Direction")
    var
        TrackingSpecification: Record "Tracking Specification";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
        AvalabilityDate: Date;
    begin
        TransferLineReserve.InitFromTransLine(TrackingSpecification, TransLine, AvalabilityDate, Direction);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, AvalabilityDate);
        ItemTrackingLines.SetInbound(TransLine.IsInbound());
        //ItemTrackingLines.SetInitTrackingSpec(TrackingSpecification);
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure CallItemTrackingSecondSource(var SalesLine: Record "Sales Line"; SecondSourceQuantityArray: array[3] of Decimal; AsmToOrder: Boolean)
    var
        TrackingSpecification: Record "Tracking Specification";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
    begin
        if SecondSourceQuantityArray[1] = Database::"Warehouse Shipment Line" then
            ItemTrackingLines.SetSecondSourceID(Database::"Warehouse Shipment Line", AsmToOrder);

        SalesLineReserve.InitFromSalesLine(TrackingSpecification, SalesLine);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, SalesLine."Shipment Date");
        ItemTrackingLines.SetSecondSourceQuantity(SecondSourceQuantityArray);
        Commit();
        ItemTrackingLines.RunModal();
    end;

    procedure FilterReservFor(var FilterReservEntry: Record "Reservation Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        FilterReservEntry.SetSourceFilter(
        Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Line No.", false);
        //FilterReservEntry.SetSourceFilter2(ItemJnlLine."Journal Batch Name", 0);
        FilterReservEntry.SetTrackingFilterFromItemJnlLine(ItemJnlLine);
    end;

    procedure ItemJnlCallItemTracking(var ItemJnlLine: Record "Item Journal Line"; IsReclass: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ItemTrackingLines: Page "Item Tracking Lines";
        RunMode: Enum "Item Tracking Run Mode";
        Text006: Label 'You cannot define item tracking on %1 %2';
    begin
        ItemJnlLine.TestField("Item No.");
        if ItemJnlLine."Line No." = 0 then
            Error('You must click off of the line before opening item tracking');

        if not ItemJnlLine.ItemPosting() then begin
            ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, false);
            FilterReservFor(ReservEntry, ItemJnlLine);
            ReservEntry.ClearTrackingFilter();
            if ReservEntry.IsEmpty then
                Error(Text006, ItemJnlLine.FieldCaption("Operation No."), ItemJnlLine."Operation No.");
        end;
        ItemJnlLineReserve.InitFromItemJnlLine(TrackingSpecification, ItemJnlLine);
        if IsReclass then
            ItemTrackingLines.SetRunMode(RunMode::Reclass);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, ItemJnlLine."Posting Date");
        ItemTrackingLines.SetInbound(ItemJnlLine.IsInbound());
        Commit();
        if ItemJnlLine."Entry Type" in [ItemJnlLine."Entry Type"::"Positive Adjmt.", ItemJnlLine."Entry Type"::Purchase, ItemJnlLine."Entry Type"::Output] then
            ItemTrackingLines.Editable(false);
        ItemTrackingLines.RunModal();
    end;

    procedure ProdOrderOpenItemTrackingLines(ProdOrderLine: Record "Prod. Order Line")
    begin
        CallItemTracking_ProdOrderLine(ProdOrderLine);
    end;

    procedure PurchaseCallItemTracking(var PurchLine: Record "Purchase Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ItemTrackingLines: Page "Item Tracking Lines";
        RunMode: Enum "Item Tracking Run Mode";
    begin
        if PurchLine."Line No." = 0 then
            Error('You must click off of the Purchase Line before opening item tracking');

        PurchLineReserve.InitFromPurchLine(TrackingSpecification, PurchLine);
        if ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) and
        (PurchLine."Receipt No." <> '')) or
       ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") and
        (PurchLine."Return Shipment No." <> ''))
    then
            ItemTrackingLines.SetRunMode(RunMode::"Combined Ship/Rcpt");
        if PurchLine."Drop Shipment" then begin
            ItemTrackingLines.SetRunMode(RunMode::"Drop Shipment");
            if PurchLine."Sales Order No." <> '' then
                ItemTrackingLines.SetSecondSourceRowID(ItemTrackingMgt.ComposeRowID(Database::"Sales Line",
                1, PurchLine."Sales Order No.", '', 0, PurchLine."Sales Order Line No."));
        end;
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, PurchLine."Expected Receipt Date");
        ItemTrackingLines.SetInbound(PurchLine.IsInbound());
        //ItemTrackingLines.SetInitTrackingSpec(TrackingSpecification);
        Commit();
        ItemTrackingLines.Editable(false);
        ItemTrackingLines.RunModal();
    end;

    procedure TransferLineOpenItemTrackingLines(TransferLine: Record "Transfer Line"; Direction: Enum "Transfer Direction")
    begin
        TransferLine.TestField(TransferLine."Item No.");
        TransferLine.TestField("Quantity (Base)");
        CallItemTracking_TransferLine(TransferLine, Direction);
    end;

    procedure WhseReceiptOpenItemTrackingLines(WhseReceiptLine: Record "Warehouse Receipt Line")
    var
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        TransferLine: Record "Transfer Line";
        SecondSourceQtyArray: array[3] of Decimal;
        Direction: Enum "Transfer Direction";
    begin
        WhseReceiptLine.TestField(WhseReceiptLine."No.");
        WhseReceiptLine.TestField(WhseReceiptLine."Qty. (Base)");

        if Item."No." <> WhseReceiptLine."Item No." then
            Item.Get(WhseReceiptLine."Item No.");

        Item.TestField("Item Tracking Code");

        SecondSourceQtyArray[1] := Database::"Warehouse Receipt Line";
        SecondSourceQtyArray[2] := WhseReceiptLine."Qty. to Receive (Base)";
        SecondSourceQtyArray[3] := 0;

        case WhseReceiptLine."Source Type" of
            Database::"Purchase Line":

                if PurchaseLine.Get(WhseReceiptLine."Source Subtype", WhseReceiptLine."Source No.", WhseReceiptLine."Source Line No.") then
                    CallItemTracking2_PurchLine(PurchaseLine, SecondSourceQtyArray);
            Database::"Sales Line":

                if SalesLine.Get(WhseReceiptLine."Source Subtype", WhseReceiptLine."Source No.", WhseReceiptLine."Source Line No.") then
                    CallItemTrackingSecondSource(SalesLine, SecondSourceQtyArray, false);
            Database::"Transfer Line":
                begin
                    Direction := Direction::Inbound;
                    if TransferLine.Get(WhseReceiptLine."Source No.", WhseReceiptLine."Source Line No.") then
                        CallItemTracking2_TrasfLine(TransferLine, Direction, SecondSourceQtyArray);
                end
        end;
    end;

    procedure WhseShipOpenItemTrackingLines(WhseShipmentLine: Record "Warehouse Shipment Line")
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
        TransferLine: Record "Transfer Line";
        SecondSourceQtyArray: array[3] of Decimal;
        Direction: Enum "Transfer Direction";
    begin
        WhseShipmentLine.TestField(WhseShipmentLine."No.");
        WhseShipmentLine.TestField(WhseShipmentLine."Qty. (Base)");

        if Item."No." <> WhseShipmentLine."Item No." then
            Item.Get(WhseShipmentLine."Item No.");

        Item.TestField("Item Tracking Code");

        SecondSourceQtyArray[1] := Database::"Warehouse Shipment Line";
        SecondSourceQtyArray[2] := WhseShipmentLine."Qty. to Ship (Base)";
        SecondSourceQtyArray[3] := 0;

        case WhseShipmentLine."Source Type" of
            Database::"Sales Line":

                if SalesLine.Get(WhseShipmentLine."Source Subtype", WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then
                    CallItemTrackingSecondSource(SalesLine, SecondSourceQtyArray, WhseShipmentLine."Assemble to Order");
            Database::"Service Line":

                if ServiceLine.Get(WhseShipmentLine."Source Subtype", WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then
                    CallItemTracking_ServiceLine(ServiceLine);
            // DATABASE::"Purchase Line" :
            // BEGIN
            //     IF PurchaseLine.Get("Source Subtype", "Source No.", "Source Line No.") THEN
            //         ReservePurchLine.CallItemTracking2(PurchaseLine, SecondSourceQtyArray);
            // END;
            Database::"Transfer Line":
                begin
                    Direction := Direction::Outbound;
                    if TransferLine.Get(WhseShipmentLine."Source No.", WhseShipmentLine."Source Line No.") then
                        CallItemTracking2_TrasfLine(TransferLine, Direction, SecondSourceQtyArray);
                end
        end;
    end;
}