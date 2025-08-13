namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from pageextension 50042 "SalesOrderSubform" extends "Sales Order Subform"
/// </summary>
pageextension 60302 SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
        addafter(Type)
        {
            field(SBSINVLotAllocation; SBSINVLotAllocationText)
            {
                ApplicationArea = All;
                Caption = 'Lot Allocation';
                Editable = false;
                StyleExpr = 'AttentionAccent';
                ToolTip = 'Specifies the value of the Lot Allocation field.';
                trigger OnDrillDown()
                begin
                    this.SBSINVOpenItemTrackingLines(Rec);
                    CurrPage.Update(false);
                    Rec.SBSINVGetLotNoAndAllocatedQty(Rec);
                    this.SBSINVUpdateUnitCostByLot(Rec);
                end;
            }
        }
        addafter(Quantity)
        {
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
            field(SBSINVAllocatedQuantity; Rec.SBSINVAllocatedQuantity)
            {
                ApplicationArea = All;
                Caption = 'Allocated Quantity';
                ToolTip = 'Specifies the value of the Allocated Quantity field.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        SBSINVLotAllocationText := SBSINVLotAllocationLbl;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    var
        SBSINVLotAllocationLbl: Label 'Open Tracking';
        SBSINVLotAllocationText: Text[40];

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    internal procedure SBSINVOpenItemTrackingLines(var SalesLine: Record "Sales Line")
    var
        SpecialItemTrackingMgmt: Codeunit SpecialItemTrackingMgmt;
    begin
        // TODO: there is no need to pass the SalesLine as a parameter, it can be used directly from Rec. Refactor this later.
        SpecialItemTrackingMgmt.CallItemTracking_SalesLine(SalesLine);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/794 - Updates to Unit Price Less then Unit Cost message
    internal procedure SBSINVUnitPriceCostCheck(SalesLine: Record "Sales Line"; DoConfirm: Boolean)
    var
        Confirmed: Boolean;
        CostCheckMsg: Text;
    begin
        // TODO: there is no need to pass the SalesLine as a parameter, it can be used directly from Rec. Refactor this later.
        if not GuiAllowed then
            exit;

        if (SalesLine.Type <> SalesLine.Type::Item) or
            (SalesLine."Unit Price" = 0) or
            (SalesLine.SBSINVLotNumber = '') then
            exit;

        if (SalesLine."Unit Price" >= SalesLine."Unit Cost") then
            exit;

        CostCheckMsg := StrSubstNo('For Item %1-%2, the Unit Price (%3) is less than the Unit Cost (%4).',
                    SalesLine."No.", SalesLine.Description, SalesLine."Unit Price", SalesLine."Unit Cost");
        if DoConfirm then begin
            CostCheckMsg += ' Do you want to continue?';
            Confirmed := Dialog.Confirm(CostCheckMsg);
            if not Confirmed then
                Error('The Unit Price was not updated.');
        end else
            Message(CostCheckMsg);
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/711 - Update the unit cost on a sales line based on the lot
    /// The following Function calculates the weighted average of the cost of the lots on the Sales Line.
    /// Most of the time, there will only be one lot; one ReservationEntry and one POReservationEntry
    /// </summary>
    /// <param name="SalesLine"></param>
    internal procedure SBSINVUpdateUnitCostByLot(var SalesLine: Record "Sales Line")
    var
        LotNoInformation: Record "Lot No. Information";
        PurchaseLine: Record "Purchase Line";
        POReservationEntry: Record "Reservation Entry";
        ReservationEntry: Record "Reservation Entry";
        CostTotal: Decimal;
        QtyTotal: Decimal;
        UnitCost: Decimal;
    begin
        // TODO: there is no need to pass the SalesLine as a parameter, it can be used directly from Rec. Refactor this later.
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
            exit;

        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", 1); //Sales Orders
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Item No.", SalesLine."No.");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.FindSet() then
            repeat
                if LotNoInformation.Get(SalesLine."No.", SalesLine."Variant Code", ReservationEntry."Lot No.") then begin
                    QtyTotal -= ReservationEntry."Qty. to Handle (Base)";
                    CostTotal -= ReservationEntry."Qty. to Handle (Base)" * LotNoInformation.SBSINVUnitCost;
                end else begin
                    POReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                    POReservationEntry.SetRange("Source Subtype", 1); //Purchase Orders
                    POReservationEntry.SetRange("Item No.", SalesLine."No.");
                    POReservationEntry.SetRange("Lot No.", ReservationEntry."Lot No.");
                    POReservationEntry.SetCurrentKey("Lot No.");
                    if POReservationEntry.FindFirst() then
                        if PurchaseLine.Get(POReservationEntry."Source Subtype", POReservationEntry."Source ID", POReservationEntry."Source Ref. No.") then
                            if PurchaseLine."Unit Cost" > 0 then begin
                                QtyTotal -= ReservationEntry."Qty. to Handle (Base)";
                                CostTotal -= ReservationEntry."Qty. to Handle (Base)" * PurchaseLine."Unit Cost";
                            end;
                end;
            until (ReservationEntry.Next() = 0);

        if QtyTotal <> 0 then begin
            UnitCost := Round(CostTotal / QtyTotal, 0.00001);
            SalesLine.Validate("Unit Cost (LCY)", UnitCost);
            SalesLine.Modify();
            this.SBSINVUnitPriceCostCheck(SalesLine, false);
        end;
    end;
}