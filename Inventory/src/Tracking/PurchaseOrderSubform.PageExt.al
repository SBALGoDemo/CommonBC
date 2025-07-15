// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
pageextension 60303 PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        addafter(Type)
        {
            field(SBSINVAssignLotOrOpenTrackingText; SBSINVAssignLotOrOpenTrackingText)
            {
                Caption = 'Assign Lot/Open Tracking (Shift+Alt+L)';
                Editable = false;
                StyleExpr = 'AttentionAccent';
                ApplicationArea = All;
                trigger OnDrillDown();
                begin
                    Message('This function has not been implemented yet.');
                end;
            }
        }
        addbefore("Direct Unit Cost")
        {
            field(SBSINVLotNo; Rec.SBSINVLotNo)
            {
                Editable = AdditionalFieldsEditable;
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    SetAssignOrOpenTrackingText();
                    CurrPage.Update();
                end;
            }
            field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
            {
                Editable = AdditionalFieldsEditable;
                ApplicationArea = All;
            }
            field(SBSINVLabel; Rec.SBSINVLabel)
            {
                Editable = AdditionalFieldsEditable;
                ApplicationArea = All;
            }
            field(SBSINVVessel; Rec.SBSINVVessel)
            {
                Editable = AdditionalFieldsEditable;
                ApplicationArea = All;
            }
            field(SBSINVProductionDate; Rec.SBSINVProductionDate)
            {
                Editable = AdditionalFieldsEditable;
                Width = 14;
                ApplicationArea = All;
            }
            field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
            {
                Editable = AdditionalFieldsEditable;
                Width = 14;
                ApplicationArea = All;
            }
            field(SBSINVContainerNo; Rec.SBSINVContainerNo)
            {
                Editable = AdditionalFieldsEditable;
                Width = 15;
                ApplicationArea = All;
            }
            field(SBSINVCountryOfOrigin; Rec.SBSINVCountryOfOrigin)
            {
                ApplicationArea = All;
            }
        }
        movefirst(Control1; Type)
        modify(Description)
        {
            Width = 40;
            QuickEntry = false;
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

    var
        SBSINVAssignLotOrOpenTrackingText: Text;
        AdditionalFieldsEditable: Boolean;

    trigger OnAfterGetRecord();
    begin
        SetAssignOrOpenTrackingText();
        SetAdditionalFieldsEditable();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Quantity = xRec.Quantity then
            exit(true);
        SetAssignOrOpenTrackingText();
        exit(true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SBSINVAssignLotOrOpenTrackingText := '';
    end;

    local procedure SetAssignOrOpenTrackingText()
    begin
        if (Rec.Type <> Rec.Type::Item) or (rec.Quantity = 0) then
            SBSINVAssignLotOrOpenTrackingText := ''
        else if (Rec.SBSINVLotNo = '') and (rec.Quantity > 0) then
            SBSINVAssignLotOrOpenTrackingText := 'Assign Lot (Shift+Alt+L)'
        else
            SBSINVAssignLotOrOpenTrackingText := 'Open Tracking';
    end;

    procedure SetAdditionalFieldsEditable()
    begin
        AdditionalFieldsEditable := Rec.Quantity > 0;
    end;

}