namespace SilverBay.Inventory.StatusSummary;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// </summary>
codeunit 60300 InfoPaneMgmt
{
    Access = Internal;

    procedure BuyerOnDrillDown(BuyerCode: Code[20])
    var
        Purchaser: Record "Salesperson/Purchaser";
        PurchaserCard: Page "Salesperson/Purchaser Card";
    begin
        Purchaser.SetRange(Code, BuyerCode);
        PurchaserCard.SetTableView(Purchaser);
        PurchaserCard.RunModal();
    end;

    procedure CalcInventoryValue(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; AsOfDate: Date): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalValueOfInventoryOnHand: Decimal;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Serial No.");
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
        if not IncludeAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
        TotalValueOfInventoryOnHand := 0;
        if ItemLedgerEntry.FindSet() then
            repeat
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                TotalValueOfInventoryOnHand += ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)";
            until ItemLedgerEntry.Next() = 0;
        exit(TotalValueOfInventoryOnHand);
    end;

    procedure CalcOnHandCommitted(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        TotalOnHandCommitted: Decimal;

    begin
        ReservEntry.Reset();
        ReservEntry.SetRange("Item No.", ItemNo);
        ReservEntry.SetRange(Positive, false);
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange(SBSISSLotIsOnHand, true);
        if not IncludeAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        TotalOnHandCommitted := 0;
        if ReservEntry.FindSet() then
            repeat
                TotalOnHandCommitted += Abs(ReservEntry."Quantity (Base)");
            until ReservEntry.Next() = 0;
        exit(TotalOnHandCommitted);
    end;


    procedure CalcOnOrderCommitted(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal
    var
        ReservationEntry: Record "Reservation Entry";
        TotalSOReservation: Decimal;
    begin
        TotalSOReservation := 0;
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if not IncludeAllVariants then
            ReservationEntry.SetRange("Variant Code", VariantCode);
        ReservationEntry.SetRange(SBSISSLotIsOnHand, false);
        if ReservationEntry.FindSet() then
            repeat
                TotalSOReservation += Abs(ReservationEntry."Quantity (Base)");
            until ReservationEntry.Next() = 0;

        exit(TotalSOReservation);
    end;

    procedure CalcUnallocatedSO(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal
    var
        SalesLine: Record "Sales Line";
        TempSalesLine2: Record "Sales Line" temporary;
        ItemTracking: Boolean;
        lTotalUnallocatedSO: Decimal;
        TrackingPercent: Decimal;
    begin
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if not IncludeAllVariants then
            SalesLine.SetRange("Variant Code", VariantCode);
        if SalesLine.FindSet() then begin
            repeat
                TrackingPercent := Round(SalesLine.SBSISSGetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking));
                if TrackingPercent <> 100 then begin
                    TempSalesLine2.Init();
                    TempSalesLine2.TransferFields(SalesLine);
                    TempSalesLine2.Insert();
                end;
            until SalesLine.Next() = 0;
            if TempSalesLine2.FindSet() then
                repeat
                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page - Original Code
                    // SalesLineTemp2.CalcFields("OBF-Reserved Qty. (Base)");
                    // lTotalUnallocatedSO += SalesLineTemp2.Quantity - SalesLineTemp2."OBF-Reserved Qty. (Base)";
                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End Original Code

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
                    lTotalUnallocatedSO += TempSalesLine2.Quantity - TempSalesLine2.SBSISSAllocatedQuantity;
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End
                until TempSalesLine2.Next() = 0;
        end;
        exit(lTotalUnallocatedSO);
    end;

    procedure CheckItemTrackingCodeNotBlank(ItemNo: Code[20]; var Item: Record Item): Boolean
    begin
        if Item."No." <> ItemNo then
            Item.Get(ItemNo);
        exit(Item."Item Tracking Code" <> '');
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
        SalesLines.SetShowReserved(true);
        SalesLines.RunModal();
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="LotNo"></param>
    /// <param name="LocationCode"></param>
    procedure InTransitDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[10]; LocationCode: Code[10])
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
        ReservationEntry.SetRange(SBSISSPurResEntryisNeg, true);
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
    procedure OnHandDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[10]; LocationCode: Code[10])
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

    procedure OnOrderDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[10]; LocationCode: Code[10])
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

    procedure SalesOrderAllocateToPO_Drilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean)
    var
        POReservationEntry: Record "Reservation Entry";
        ReservationEntry: Record "Reservation Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
        AvailItemTrackLines: Page "Avail. - Item Tracking Lines";
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        POReservationEntry.Reset();
        POReservationEntry.SetRange("Source Type", Database::"Sales Line");
        POReservationEntry.SetRange("Item No.", ItemNo);
        if not IncludeAllVariants then
            ReservationEntry.SetRange("Variant Code", VariantCode);
        if ReservationEntry.FindSet() then
            repeat
                POReservationEntry.SetRange("Lot No.", ReservationEntry."Lot No.");
                if not POReservationEntry.IsEmpty then begin
                    TempReservationEntry := TempReservationEntry;
                    TempReservationEntry.Insert();
                end;
            until ReservationEntry.Next() = 0;
        if not TempReservationEntry.IsEmpty then begin
            AvailItemTrackLines.SetTableView(TempReservationEntry);
            AvailItemTrackLines.RunModal();
            ;
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

    procedure TotalAvailQtyDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[10]; DateFilter: Date)
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