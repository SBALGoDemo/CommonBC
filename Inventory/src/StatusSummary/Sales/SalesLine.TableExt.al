namespace SilverBay.Inventory.StatusSummary.Sales;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
/// Migrated from tableextension 50006 "SalesLine" extends "Sales Line"
/// </summary>
tableextension 60300 SalesLine extends "Sales Line"
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
    }

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
}