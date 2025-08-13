namespace SilverBay.Inventory.Tracking;

using Microsoft.Purchases.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
/// </summary>
pageextension 60303 PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        addafter(Type)
        {
            field(SBSINVAssignLotOrOpenTrackingText; SBSINVAssignLotOrOpenTrackingText)
            {
                ApplicationArea = All;
                Caption = 'Assign Lot/Open Tracking (Shift+Alt+L)';
                Editable = false;
                StyleExpr = 'AttentionAccent';
                ToolTip = 'Specifies the value of the Assign Lot/Open Tracking (Shift+Alt+L) field.';
                trigger OnDrillDown()
                begin
                    this.SBSINVAssignLotOrOpenItemTracking();
                end;
            }
        }
        addbefore("Direct Unit Cost")
        {
            field(SBSINVLotNo; Rec.SBSINVLotNo)
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
                Editable = SBSINVAdditionalFieldsEditable;
                trigger OnValidate()
                begin
                    this.SBSINVSetAssignOrOpenTrackingText();
                    CurrPage.Update();
                end;
            }
            field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
            {
                ApplicationArea = All;
                Caption = 'Alternate Lot No.';
                Editable = SBSINVAdditionalFieldsEditable;
            }
            field(SBSINVLabel; Rec.SBSINVLabel)
            {
                ApplicationArea = All;
                Caption = 'Label';
                Editable = SBSINVAdditionalFieldsEditable;
            }
            field(SBSINVVessel; Rec.SBSINVVessel)
            {
                ApplicationArea = All;
                Caption = 'Vessel';
                Editable = SBSINVAdditionalFieldsEditable;
            }
            field(SBSINVProductionDate; Rec.SBSINVProductionDate)
            {
                ApplicationArea = All;
                Caption = 'Production Date';
                Editable = SBSINVAdditionalFieldsEditable;
                Width = 14;
            }
            field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Expiration Date';
                Editable = SBSINVAdditionalFieldsEditable;
                Width = 14;
            }
            field(SBSINVContainerNo; Rec.SBSINVContainerNo)
            {
                ApplicationArea = All;
                Caption = 'Container No.';
                Editable = SBSINVAdditionalFieldsEditable;
                Width = 15;
            }
            field(SBSINVCountryOfOrigin; Rec.SBSINVCountryOfOrigin)
            {
                ApplicationArea = All;
                Caption = 'Country of Origin';
            }
        }
        movefirst(Control1; Type)
        modify(Description)
        {
            QuickEntry = false;
            Width = 40;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Qty. to Receive")
        {
            Visible = false;
        }
        modify("Quantity Received")
        {
            Visible = false;
        }
        modify("Qty. to Invoice")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Quantity Invoiced")
        {
            Visible = false;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify("GST/HST")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify(ShortcutDimCode7)
        {
            Visible = false;
        }
        modify(ShortcutDimCode8)
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        this.SBSINVSetAssignOrOpenTrackingText();
        this.SBSINVSetAdditionalFieldsEditable();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Quantity = xRec.Quantity then
            exit(true);
        this.SBSINVSetAssignOrOpenTrackingText();
        exit(true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SBSINVAssignLotOrOpenTrackingText := '';
    end;

    var
        SBSINVAdditionalFieldsEditable: Boolean;
        SBSINVAssignLotOrOpenTrackingText: Text;

    internal procedure SBSINVSetAdditionalFieldsEditable()
    begin
        SBSINVAdditionalFieldsEditable := Rec.Quantity > 0;
    end;

    local procedure SBSINVAssignLotOrOpenItemTracking()
    begin
        if Rec.Quantity > 0 then begin
            if Rec.SBSINVLotNo = '' then
                Rec.SBSINVAssignNewLotNo()
            else
                this.SBSINVSpecialOpenItemTrackingLines();
            this.SBSINVSetAssignOrOpenTrackingText();
            CurrPage.Update();
        end else begin
            this.SBSINVOpenItemTrackingLinesNegativeQty(Rec);
            CurrPage.Update(false);
        end;
    end;

    // TODO: there is no need to pass the PurchaseLine as a parameter, it can be used directly from Rec. Refactor this later.
    local procedure SBSINVOpenItemTrackingLinesNegativeQty(var PurchaseLine: Record "Purchase Line")
    var
        SpecialItemTrackingMgmt: Codeunit SpecialItemTrackingMgmt;
    begin
        SpecialItemTrackingMgmt.CallItemTracking_PurchaseLine_NegativeQty(PurchaseLine);
    end;

    local procedure SBSINVSetAssignOrOpenTrackingText()
    begin
        // TODO: refactor this into a case statement.
        // https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-control-statements#programming-conventions-1
        if (Rec.Type <> Rec.Type::Item) or (Rec.Quantity = 0) then
            SBSINVAssignLotOrOpenTrackingText := ''
        else
            if (Rec.SBSINVLotNo = '') and (Rec.Quantity > 0) then
                SBSINVAssignLotOrOpenTrackingText := 'Assign Lot (Shift+Alt+L)'
            else
                SBSINVAssignLotOrOpenTrackingText := 'Open Tracking';
    end;

    local procedure SBSINVSpecialOpenItemTrackingLines()
    var
        SpecialTrackingMgmt: Codeunit SpecialItemTrackingMgmt;
    begin
        Rec.TestField(Type, Rec.Type::Item);
        Rec.TestField("No.");

        Rec.TestField("Quantity (Base)");

        SpecialTrackingMgmt.PurchaseCallItemTracking(Rec);
    end;
}