namespace SilverBay.Common.Sales.Document;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
/// Migrated from tableextension 50006 "SalesLine" extends "Sales Line"
/// </summary>
tableextension 60100 SalesLine extends "Sales Line"
{
    fields
    {
        field(60107; SBSCOMAllocatedQuantity; Decimal)
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
    internal procedure SBSCOMGetTrackingPercent(Qty: Decimal; var ItemTracking: Boolean): Decimal
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

    //TODO: 20250617 Confirmed Don't need
    //TODO:20250617 Review Later. 0 References 
    // /// <summary>
    // /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
    // /// </summary>
    // internal procedure SBSCOMSetCertificationFields()
    // begin
    //     if Rec.Type <> Rec.Type::Item then
    //         exit;
    //     if Rec."No." = '' then
    //         exit;
    //     Rec.SBSCOMMSCCertification := this.SBSCOMCheckItemCertification(Rec."No.", 'MSC');
    //     Rec.SBSCOMRFMCertification := this.SBSCOMCheckItemCertification(Rec."No.", 'RFM');
    // end;

    // local procedure DeleteRebateEntries()
    // var
    //     RebateEntry: Record "OBF-Rebate Entry";
    // begin
    //     case "Document Type" of
    //         "Document Type"::Order:
    //             RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::Order);
    //         "Document Type"::Invoice:
    //             RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::Invoice);
    //         "Document Type"::"Credit Memo":
    //             RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::"Credit Memo");
    //     end;

    //     RebateEntry.SetRange("Source No.", "Document No.");
    //     RebateEntry.SetRange("Source Line No.", "Line No.");
    //     RebateEntry.DeleteAll(true);
    // end;
}