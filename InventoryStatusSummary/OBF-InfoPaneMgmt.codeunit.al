// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

codeunit 50056 "OBF-Info Pane Mgmt"
{
    trigger OnRun();
    begin
    end;

    procedure CalcOnOrderCommitted(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal;
    var
        ReservationEntry: Record "Reservation Entry";
        POReservationEntry: Record "Reservation Entry";
        TotalSOReservation: Decimal;
    begin
        TotalSOReservation := 0;
        ReservationEntry.reset;
        ReservationEntry.SetRange("Source Type", database::"Sales Line");
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if not IncludeAllVariants then
            reservationEntry.SetRange("Variant Code", VariantCode);
        ReservationEntry.SetRange("OBF-Lot Is On Hand", false);
        if ReservationEntry.FindSet then
            repeat
                TotalSOReservation += abs(ReservationEntry."Quantity (Base)");
            until ReservationEntry.Next = 0;

        exit(TotalSOReservation);
    end;

    procedure CalcInventoryValue(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; AsOfDate: date): Decimal;
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
        TotalValueOfInventoryOnHand: Decimal;
    begin
        ItemLedgerEntry.reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.", "Serial No.");
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SETFilter("Lot No.", '<>%1', '');
        if not IncludeAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
        TotalValueOfInventoryOnHand := 0;
        IF ItemLedgerEntry.FindSet THEN
            REPEAT
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                TotalValueOfInventoryOnHand += ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)";
            UNTIL ItemLedgerEntry.NEXT = 0;
        exit(TotalValueOfInventoryOnHand);
    end;

    procedure CalcOnHandCommitted(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal;
    var
        ReservEntry: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        TotalOnHandCommitted: Decimal;

    begin
        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", ItemNo);
        ReservEntry.SetRange(Positive, false);
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        ReservEntry.SetRange("Source Type", database::"Sales Line");
        ReservEntry.SetRange("OBF-Lot Is On Hand", true);
        if not IncludeAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        TotalOnHandCommitted := 0;
        if ReservEntry.FindSet then
            repeat
                TotalOnHandCommitted += Abs(ReservEntry."Quantity (Base)");
            until ReservEntry.Next = 0;
        EXIT(TotalOnHandCommitted);
    end;

    procedure CalcUnallocatedSO(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean): Decimal;
    var
        SalesLine: Record "Sales Line";
        SalesLineTemp2: Record "Sales Line" temporary;
        TrackingPercent: Decimal;
        ItemTracking: Boolean;
        lTotalUnallocatedSO: Decimal;
    begin
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if not IncludeAllVariants then
            SalesLine.SetRange("Variant Code", VariantCode);
        if SalesLine.FindSet then begin
            repeat
                TrackingPercent := Round(SalesLine.GetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking));
                if TrackingPercent <> 100 then begin
                    SalesLineTemp2.Init;
                    SalesLineTemp2.TransferFields(SalesLine);
                    SalesLineTemp2.Insert;
                end;
            until SalesLine.Next = 0;
            If SalesLineTemp2.FindSet then
                repeat
                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page - Original Code
                    // SalesLineTemp2.CalcFields("OBF-Reserved Qty. (Base)");
                    // lTotalUnallocatedSO += SalesLineTemp2.Quantity - SalesLineTemp2."OBF-Reserved Qty. (Base)";
                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End Original Code

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
                    lTotalUnallocatedSO += SalesLineTemp2.Quantity - SalesLineTemp2."OBF-Allocated Quantity";
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End

                until SalesLineTemp2.Next = 0;
        end;
        exit(lTotalUnallocatedSO);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
    Procedure CommittedDrilldown(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; LotIsOnHand: Boolean)
    var
        SalesLines: page "OBF-Sales Lines";
    begin
        SalesLines.SetOnOrderCommittedSalesLines(ItemNo, VariantCode, IncludeAllVariants, LotIsOnHand);
        SalesLines.SetShowReserved(true);
        SalesLines.RunModal;
    end;
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - End

    procedure OnHandDrilldown(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; AsOfDate: date);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.reset;
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        if not IncludeAllVariants then
            ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if AsOfDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);
        if (AsOfDate >= Today) or (AsOfDate = 0D) then
            ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        ItemLedgerEntries.SetTableView(ItemLedgerEntry);
        ItemLedgerEntries.Run;
    End;

    procedure OnOrderDrilldown(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean);
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
            PurchaseLines.RunModal;
        end;
    end;

    procedure OnOrderDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; LocationCode: Code[10]);
    var
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        PurchaseLines: page "Purchase Lines";
        ReservationEntries: page "Reservation Entries";
    begin
        if LotNo = '' then begin
            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
            PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);
            PurchaseLine.SetRange("No.", ItemNo);
            PurchaseLine.SetRange("Variant Code", VariantCode);
            PurchaseLine.SetRange("Location Code", LocationCode);
            PurchaseLines.SetTableView(PurchaseLine);
            PurchaseLines.RunModal;
        end else begin
            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservationEntry.SetRange("Source Subtype", 1);
            ReservationEntry.SetRange("Item No.", ItemNo);
            ReservationEntry.SetRange("Variant Code", VariantCode);
            ReservationEntry.SetRange("Location Code", LocationCode);
            ReservationEntry.SetRange("Lot No.", LotNo);
            ReservationEntries.SetTableView(ReservationEntry);
            ReservationEntries.RunModal;
        end;
    End;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
    procedure InTransitDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; LocationCode: Code[10]);
    var
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        PurchaseLines: page "Purchase Lines";
        ReservationEntries: page "Reservation Entries";
    begin
        if LotNo = '' then
            exit;

        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetRange("Variant Code", VariantCode);
        ReservationEntry.SetRange("Location Code", LocationCode);
        ReservationEntry.SetRange("Lot No.", LotNo);
        ReservationEntry.SetRange("OBF-Pur. Res. Entry is Neg.",true);
        ReservationEntries.SetTableView(ReservationEntry);
        ReservationEntries.RunModal;
    End;

    procedure TotalAvailQtyDrillDown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; DateFilter: Date);
    var
        ItemAvailDrilldown: Page "OBF-Item Avail. Drilldown";
    begin
        ItemAvailDrilldown.SetItemData(ItemNo, VariantCode, IncludeAllVariants, DateFilter);
        ItemAvailDrilldown.RunModal;
    End;

    procedure TotalAvailQtyDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; DateFilter: Date);
    var
        ItemAvailDrilldown: Page "OBF-Item Avail. Drilldown";
    begin
        ItemAvailDrilldown.SetItemLotData(ItemNo, VariantCode, LotNo, DateFilter);
        ItemAvailDrilldown.RunModal;
    End;

    procedure UnallocatedSODrilldown(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean);
    var
        SalesLines: page "OBF-Sales Lines";
    begin
        SalesLines.SetUnallocatedSalesLines(ItemNo, VariantCode, IncludeAllVariants);
        SalesLines.RunModal;
    end;

    procedure SalesOrderAllocateToPO_Drilldown(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean);
    var
        ReservationEntry: Record "Reservation Entry";
        POReservationEntry: Record "Reservation Entry";
        ReservationEntryTemp: Record "Reservation Entry" temporary;
        AvailItemTrackLines: Page "Avail. - Item Tracking Lines";
        TotalSOReservation: Decimal;
    begin
        TotalSOReservation := 0;
        ReservationEntry.reset;
        ReservationEntry.SetRange("Source Type", database::"Sales Line");
        ReservationEntry.SetRange("Item No.", ItemNo);
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        POReservationEntry.reset;
        POReservationEntry.SetRange("Source Type", database::"Sales Line");
        POReservationEntry.SetRange("Item No.", ItemNo);
        if not IncludeAllVariants then
            reservationEntry.SetRange("Variant Code", VariantCode);
        if ReservationEntry.FindSet then begin
            repeat
                POReservationEntry.SetRange("Lot No.", ReservationEntry."Lot No.");
                if not POReservationEntry.IsEmpty then begin
                    ReservationEntryTemp := ReservationEntryTemp;
                    ReservationEntryTemp.Insert;
                end;

            until ReservationEntry.Next = 0;
        end;
        if not ReservationEntryTemp.IsEmpty then begin
            AvailItemTrackLines.SetTableView(ReservationEntryTEMP);
            AvailItemTrackLines.RunModal;
            ;
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
    procedure OnHandDrillDownByLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[20]; LocationCode: Code[10]);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.reset;
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        ItemLedgerEntries.SetTableView(ItemLedgerEntry);
        ItemLedgerEntries.Run;
    end;

    procedure CheckItemTrackingCodeNotBlank(ItemNo: code[20]; var Item: Record Item): Boolean
    begin
        if Item."No." <> ItemNo then
            Item.get(ItemNo);
        exit(Item."Item Tracking Code" <> '');
    end;


    procedure ShowItem(ItemNo: code[20])
    var
        Item: Record Item;
        ItemCard: Page "Item Card";
    begin
        Item.SetRange("No.", ItemNo);
        ItemCard.SETTABLEVIEW(Item);
        ItemCard.LOOKUPMODE(TRUE);

        IF ItemCard.RUNMODAL = ACTION::LookupOK THEN;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements 
    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1402 - Show Posted Invoice when drilling into PO Number
    procedure PONumberOnDrillDown(PONumber: code[20]);
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseOrder: Page "Purchase Order";
        PurchInvHeader: Record "Purch. Inv. Header";
        PostedPurchaseInvoice: Page "Posted Purchase Invoice";
        PostedPurchaseInvoices: Page "Posted Purchase Invoices";
        NumInvoices: Integer;
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetRange("No.", PONumber);
        IF PurchaseHeader.findfirst then begin
            PurchaseOrder.SetTableView(PurchaseHeader);
            PurchaseOrder.RunModal();
        end else begin           
            PurchInvHeader.SetRange("Order No.", PONumber);
            NumInvoices := PurchInvHeader.Count;
            case NumInvoices of 
                0: Exit;
                1: begin 
                    PurchInvHeader.FindFirst();
                    PostedPurchaseInvoice.SetTableView(PurchInvHeader);
                    PostedPurchaseInvoice.RunModal;    
                end;
                else begin 
                    PostedPurchaseInvoices.SetTableView(PurchInvHeader);
                    PostedPurchaseInvoices.RunModal;
                end;
            end; 
        end;
    End;

    procedure LocationOnDrillDown(LocationCode: code[10]);
    var
        Location: Record Location;
        LocationCard: Page "Location Card";
    begin
        Location.SetRange(Code, LocationCode);
        LocationCard.SETTABLEVIEW(Location);
        LocationCard.RunModal;
    end;

    procedure VendorOnDrillDown(VendorNo: code[20]);
    var
        Vendor: Record Vendor;
        VendorCard: Page "Vendor Card";
    begin
        Vendor.SetRange("No.", VendorNo);
        VendorCard.SETTABLEVIEW(Vendor);
        VendorCard.RunModal;
    End;

    Procedure BuyerOnDrillDown(BuyerCode: code[20]);
    var
        Purchaser: Record "Salesperson/Purchaser";
        PurchaserCard: Page "Salesperson/Purchaser Card";
    begin
        Purchaser.SetRange(Code, BuyerCode);
        PurchaserCard.SETTABLEVIEW(Purchaser);
        PurchaserCard.RunModal;
    End;
}