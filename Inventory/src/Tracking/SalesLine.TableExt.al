namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
/// Migrated from tableextension 50006 "SalesLine" extends "Sales Line"
/// </summary>
tableextension 60302 SalesLine extends "Sales Line"
{
    fields
    {
        field(60300; SBSINVAllocatedQuantity; Decimal)
        {
            Caption = 'Allocated Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'This is the quantity that is allocated to lots in Item Tracking.';
        }

        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
        /// </summary>
        field(60301; SBSINVLotNumber; Text[250])
        {
            Caption = 'Lot Number(s)';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
    /// </summary>
    /// <param name="SalesLine"></param>
    internal procedure SBSINVGetLotNoAndAllocatedQty(var SalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        i: Integer;
        LotNo: Text[250];
    begin
        // TODO: Review and refactor when possible. Significant amounts of the code can likely be simplified and made more intuitive by migrating it to procedures in codeunits.
        i := 0;
        SalesLine.SBSINVAllocatedQuantity := 0;
        ReservationEntry.Reset();
        ReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        if ReservationEntry.Find('-') then begin
            repeat
                if ReservationEntry."Lot No." <> '' then begin
                    if i = 0 then
                        LotNo := ReservationEntry."Lot No."
                    else
                        LotNo := CopyStr(LotNo + ',' + ReservationEntry."Lot No.", 1, MaxStrLen(LotNo));
                    i := i + 1;
                end;

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
                SalesLine.SBSINVAllocatedQuantity -= ReservationEntry."Qty. to Handle (Base)";
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End
            until ReservationEntry.Next() = 0;
            SalesLine.SBSINVLotNumber := LotNo;
        end else begin
            TrackingSpecification.SetCurrentKey(
            "Source ID", "Source Type", "Source Subtype",
            "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
            TrackingSpecification.SetRange("Source ID", SalesLine."Document No.");
            TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
            TrackingSpecification.SetRange("Source Subtype", SalesLine."Document Type");
            TrackingSpecification.SetRange("Source Batch Name", '');
            TrackingSpecification.SetRange("Source Prod. Order Line", 0);
            TrackingSpecification.SetRange("Source Ref. No.", SalesLine."Line No.");
            if TrackingSpecification.Find('-') then begin
                repeat
                    if TrackingSpecification."Lot No." <> '' then begin
                        if i = 0 then
                            LotNo := TrackingSpecification."Lot No."
                        else
                            LotNo := LotNo + ',' + TrackingSpecification."Lot No.";
                        i := i + 1;

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
                        SalesLine.SBSINVAllocatedQuantity -= TrackingSpecification."Qty. to Handle (Base)";
                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End
                    end;
                until TrackingSpecification.Next() = 0;
                SalesLine.SBSINVLotNumber := LotNo;

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/729 - Sales Order Lot Number Issue
            end else
                SalesLine.SBSINVLotNumber := '';
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/729 - End
        end;
        SalesLine.Modify();
    end;

    internal procedure SBSINVCalcOnOrderTotalUnallocated(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean) OnOrderTotalUnallocated: Decimal
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
                if Round(SBSINVGetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking)) <> 100 then
                    SalesLine.Mark(true);
            until SalesLine.Next() = 0;

            SalesLine.MarkedOnly(true);
            SalesLine.CalcSums(Quantity, SBSINVAllocatedQuantity);
            OnOrderTotalUnallocated += SalesLine.Quantity - SalesLine.SBSINVAllocatedQuantity;
        end;
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
    /// </summary>
    /// <param name="Qty"></param>
    /// <param name="ItemTracking"></param>
    /// <returns></returns>
    internal procedure SBSINVGetTrackingPercent(Qty: Decimal; var ItemTracking: Boolean): Decimal
    var
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        PctInReserv: Decimal;
    begin
        // TODO: Review and refactor code in the page when possible. Significant amounts of the code can likely be simplified and made more intuitive by migrating it to procedures in codeunits.
        ItemTracking := false;

        if not (Type = Type::Item) then
            exit(0);

        if not Item.Get("No.") then
            exit(0);

        if Item."Item Tracking Code" = '' then
            exit(0);

        ItemTracking := true;

        if Qty = 0 then
            exit(0);

        ReservationEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line",
          "Reservation Status", "Shipment Date", "Expected Receipt Date");

        ReservationEntry.SetRange("Source ID", "Document No.");
        ReservationEntry.SetRange("Source Ref. No.", "Line No.");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");

        if ReservationEntry.Find('-') then
            repeat
                if (ReservationEntry."Lot No." <> '') or (ReservationEntry."Serial No." <> '') then begin
                    if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]
                    then
                        PctInReserv += ReservationEntry."Quantity (Base)";
                    if "Document Type" in
                       ["Document Type"::Quote,
                        "Document Type"::Order,
                        "Document Type"::Invoice,
                        "Document Type"::"Blanket Order"]
                    then
                        PctInReserv += -ReservationEntry."Quantity (Base)";
                end;
            until ReservationEntry.Next() = 0;

        TrackingSpecification.SetCurrentKey(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SetRange("Source ID", "Document No.");
        TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
        TrackingSpecification.SetRange("Source Subtype", "Document Type");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        TrackingSpecification.SetRange("Source Ref. No.", "Line No.");

        if TrackingSpecification.Find('-') then
            repeat
                if (TrackingSpecification."Lot No." <> '') or (TrackingSpecification."Serial No." <> '') then begin
                    if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]
                    then
                        PctInReserv += TrackingSpecification."Quantity (Base)";
                    if "Document Type" in
                       ["Document Type"::Quote,
                        "Document Type"::Order,
                        "Document Type"::Invoice,
                        "Document Type"::"Blanket Order"]
                    then
                        PctInReserv += -TrackingSpecification."Quantity (Base)";
                end;
            until TrackingSpecification.Next() = 0;

        if Qty <> 0 then
            PctInReserv := PctInReserv / Qty * 100;

        exit(PctInReserv);
    end;
}