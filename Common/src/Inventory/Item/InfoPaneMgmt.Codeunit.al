namespace SilverBay.Common.Inventory.Item;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;
using SilverBay.Common.Sales.Document;
using SilverBay.Common.Inventory.Availability;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// Migrated from codeunit 50056 "OBF-Info Pane Mgmt"
/// </summary>
codeunit 60106 InfoPaneMgmt
{
    Access = Internal;

    procedure CalcInventoryOnHandTotalValue(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; AsOfDate: Date) InventoryOnHandTotalValue: Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetLoadFields("Cost Amount (Actual)", "Cost Amount (Expected)");
        ItemLedgerEntry.SetAutoCalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Serial No.");
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');

        if not IncludeAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);

        if ItemLedgerEntry.FindSet(false) then
            repeat
                InventoryOnHandTotalValue += ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)";
            until ItemLedgerEntry.Next() = 0;
    end;

    procedure CalcInventoryOnHandTotalCommitted(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean) InventoryOnHandTotalCommitted: Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetRange(Positive, false);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange(SBSCOMLotIsOnHand, true);

        if not IncludeAllVariants then
            ReservationEntry.SetRange("Variant Code", VariantCode);

        ReservationEntry.CalcSums("Quantity (Base)");

        InventoryOnHandTotalCommitted := Abs(ReservationEntry."Quantity (Base)");
    end;

    procedure CalcInventoryOnOrderTotalCommitted(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean) InventoryOnOrderTotalCommitted: Decimal
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');

        if not IncludeAllVariants then
            ReservationEntry.SetRange("Variant Code", VariantCode);

        ReservationEntry.SetRange(SBSCOMLotIsOnHand, false);

        ReservationEntry.CalcSums("Quantity (Base)");

        InventoryOnOrderTotalCommitted := Abs(ReservationEntry."Quantity (Base)");
    end;

    procedure CalcOnOrderTotalUnallocated(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean) OnOrderTotalUnallocated: Decimal
    var
        SalesLine: Record "Sales Line";
        ItemTracking: Boolean;
    begin
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if not IncludeAllVariants then
            SalesLine.SetRange("Variant Code", VariantCode);
        if SalesLine.FindSet() then begin
            repeat
                if Round(SalesLine.SBSCOMGetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking)) <> 100 then
                    SalesLine.Mark(true);
            until SalesLine.Next() = 0;

            SalesLine.MarkedOnly(true);
            SalesLine.CalcSums(Quantity, SBSCOMAllocatedQuantity);
            OnOrderTotalUnallocated += SalesLine.Quantity - SalesLine.SBSCOMAllocatedQuantity;
        end;
    end;

    procedure CheckItemTrackingCodeNotBlank(ItemNo: Code[20]) ItemTrackingCodeNotBlank: Boolean
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        ItemTrackingCodeNotBlank := Item."Item Tracking Code" <> '';
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="IncludeAllVariants"></param>
    /// <param name="LotIsOnHand"></param>
    procedure CommittedDrilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; LotIsOnHand: Boolean)
    var
        SalesLines: Page SalesLines;
    begin
        SalesLines.SetOnOrderCommittedSalesLines(ItemNo, VariantCode, IncludeAllVariants, LotIsOnHand);
        SalesLines.RunModal();
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="LotNo"></param>
    /// <param name="LocationCode"></param>
    procedure InTransitDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; LocationCode: Code[10])
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntries: Page "Reservation Entries";
    begin
        if LotNo = '' then
            exit;

        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetRange("Variant Code", VariantCode);
        ReservationEntry.SetRange("Location Code", LocationCode);
        ReservationEntry.SetRange("Lot No.", LotNo);
        ReservationEntry.SetRange(SBSCOMPurResEntryisNeg, true);
        ReservationEntries.SetTableView(ReservationEntry);
        ReservationEntries.RunModal();
    end;

    procedure LocationOnDrillDown(LocationCode: Code[10])
    var
        Location: Record Location;
        LocationCard: Page "Location Card";
    begin
        Location.SetRange(Code, LocationCode);
        LocationCard.SetTableView(Location);
        LocationCard.RunModal();
    end;

    procedure OnHandDrilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; AsOfDate: Date)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        if not IncludeAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
        if (AsOfDate >= Today) or (AsOfDate = 0D) then
            ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);

        ItemLedgerEntries.SetTableView(ItemLedgerEntry);
        ItemLedgerEntries.Run();
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="LotNo"></param>
    /// <param name="LocationCode"></param>
    procedure OnHandDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; LocationCode: Code[10])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetRange("Location Code", LocationCode);

        ItemLedgerEntries.SetTableView(ItemLedgerEntry);
        ItemLedgerEntries.Run();
    end;

    procedure OnOrderDrilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLines: Page "Purchase Lines";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", ItemNo);
        if not IncludeAllVariants then
            PurchaseLine.SetRange("Variant Code", VariantCode);
        PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);

        if not PurchaseLine.IsEmpty then begin
            PurchaseLines.SetTableView(PurchaseLine);
            PurchaseLines.RunModal();
        end;
    end;

    procedure OnOrderDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; LocationCode: Code[10])
    var
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        PurchaseLines: Page "Purchase Lines";
        ReservationEntries: Page "Reservation Entries";
    begin
        if LotNo = '' then begin
            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);
            PurchaseLine.SetRange("No.", ItemNo);
            PurchaseLine.SetRange("Variant Code", VariantCode);
            PurchaseLine.SetRange("Location Code", LocationCode);

            PurchaseLines.SetTableView(PurchaseLine);
            PurchaseLines.RunModal();
        end else begin
            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservationEntry.SetRange("Source Subtype", 1);
            ReservationEntry.SetRange("Item No.", ItemNo);
            ReservationEntry.SetRange("Variant Code", VariantCode);
            ReservationEntry.SetRange("Location Code", LocationCode);
            ReservationEntry.SetRange("Lot No.", LotNo);

            ReservationEntries.SetTableView(ReservationEntry);
            ReservationEntries.RunModal();
        end;
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1402 - Show Posted Invoice when drilling into PO Number
    /// </summary>
    /// <param name="PONumber"></param>
    procedure PONumberOnDrillDown(PONumber: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaseHeader: Record "Purchase Header";
        PostedPurchaseInvoice: Page "Posted Purchase Invoice";
        PostedPurchaseInvoices: Page "Posted Purchase Invoices";
        PurchaseOrder: Page "Purchase Order";
        NumInvoices: Integer;
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetRange("No.", PONumber);
        if PurchaseHeader.FindFirst() then begin
            PurchaseOrder.SetTableView(PurchaseHeader);
            PurchaseOrder.RunModal();
        end else begin
            PurchInvHeader.SetRange("Order No.", PONumber);
            NumInvoices := PurchInvHeader.Count;
            case NumInvoices of
                0:
                    exit;
                1:
                    begin
                        PurchInvHeader.FindFirst();
                        PostedPurchaseInvoice.SetTableView(PurchInvHeader);
                        PostedPurchaseInvoice.RunModal();
                    end;
                else begin
                    PostedPurchaseInvoices.SetTableView(PurchInvHeader);
                    PostedPurchaseInvoices.RunModal();
                end;
            end;
        end;
    end;

    procedure ShowItem(ItemNo: Code[20])
    var
        Item: Record Item;
        ItemCard: Page "Item Card";
    begin
        Item.SetRange("No.", ItemNo);
        ItemCard.SetTableView(Item);
        ItemCard.LookupMode(true);

        if ItemCard.RunModal() = Action::LookupOK then;
    end;

    procedure TotalAvailQtyDrillDown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; DateFilter: Date)
    var
        ItemAvailabilityDrilldown: Page ItemAvailabilityDrilldown;
    begin
        ItemAvailabilityDrilldown.SetItemData(ItemNo, VariantCode, IncludeAllVariants, DateFilter);
        ItemAvailabilityDrilldown.RunModal();
    end;

    procedure TotalAvailQtyDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; DateFilter: Date)
    var
        ItemAvailabilityDrilldown: Page ItemAvailabilityDrilldown;
    begin
        ItemAvailabilityDrilldown.SetItemLotData(ItemNo, VariantCode, LotNo, DateFilter);
        ItemAvailabilityDrilldown.RunModal();
    end;

    procedure UnallocatedSODrilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean)
    var
        SalesLines: Page SalesLines;
    begin
        SalesLines.SetUnallocatedSalesLines(ItemNo, VariantCode, IncludeAllVariants);
        SalesLines.RunModal();
    end;

    procedure VendorOnDrillDown(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
        VendorCard: Page "Vendor Card";
    begin
        Vendor.SetRange("No.", VendorNo);
        VendorCard.SetTableView(Vendor);
        VendorCard.RunModal();
    end;
}