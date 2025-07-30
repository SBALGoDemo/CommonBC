namespace SilverBay.Inventory.Tracking;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Setup;

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
            field("LotAllocation"; LotAllocationText)
            {
                ApplicationArea = All;
                Caption = 'Lot Allocation';
                StyleExpr = 'AttentionAccent';
                Editable = false;
                trigger OnDrillDown();
                begin
                    OpenItemTrackingLines(Rec);
                    CurrPage.Update(false);
                    Rec.GetLotNoAndAllocatedQty(Rec);
                    UpdateUnitCostByLot(Rec);
                end;
            }
        }

        addafter(Quantity)
        {
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
            field(SBSINVAllocatedQuantity; Rec.SBSINVAllocatedQuantity)
            {
                ApplicationArea = all;
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    var
        LotAllocationLabel: Label 'Open Tracking';
        LotAllocationText: Text[40];

    trigger OnOpenPage();
    begin
        LotAllocationText := LotAllocationLabel;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    procedure OpenItemTrackingLines(var Rec: Record "Sales Line");
    var
        SpecialItemTrackingMgmt: Codeunit SpecialItemTrackingMgmt;
    begin
        SpecialItemTrackingMgmt.CallItemTracking_SalesLine(Rec);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/711 - Update the unit cost on a sales line based on the lot
    // The following Function calculates the weighted average of the cost of the lots on the Sales Line.
    // Most of the time, there will only be one lot; one ReservationEntry and one POReservationEntry
    procedure UpdateUnitCostByLot(var SalesLine: Record "Sales Line");
    var
        ReservationEntry: Record "Reservation Entry";
        POReservationEntry: Record "Reservation Entry";
        PurchaseLine: Record "Purchase Line";
        LotNoInformation: Record "Lot No. Information";
        SalesSetup: Record "Sales & Receivables Setup";
        CostTotal: Decimal;
        QtyTotal: Decimal;
        UnitCost: Decimal;
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
            exit;

        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", 1); //Sales Orders
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Item No.", SalesLine."No.");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.FindSet then
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
                    if POReservationEntry.FindFirst then
                        if PurchaseLine.Get(POReservationEntry."Source Subtype", POReservationEntry."Source ID", POReservationEntry."Source Ref. No.") then begin
                            if PurchaseLine."Unit Cost" > 0 then begin
                                QtyTotal -= ReservationEntry."Qty. to Handle (Base)";
                                CostTotal -= ReservationEntry."Qty. to Handle (Base)" * PurchaseLine."Unit Cost";
                            end;
                        end;
                end;
            until (ReservationEntry.Next = 0);

        if QtyTotal <> 0 then begin
            UnitCost := Round(CostTotal / QtyTotal, 0.00001);
            SalesLine.Validate("Unit Cost (LCY)", UnitCost);
            SalesLine.Modify;
            UnitPriceCostCheck(SalesLine, false);
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/794 - Updates to Unit Price Less then Unit Cost message
    procedure UnitPriceCostCheck(SalesLine: Record "Sales Line"; DoConfirm: boolean);
    var
        Confirmed: Boolean;
        CostCheckMsg: Text;
    begin
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
}