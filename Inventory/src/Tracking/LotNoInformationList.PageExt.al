namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
/// </summary>///
pageextension 60306 SBSINVLotNoInformationList extends "Lot No. Information List"
{
    layout
    {
        modify("Item No.")
        {
            ApplicationArea = All;
            Visible = true;
        }
        modify(Description)
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Test Quality")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Certificate Number")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify(CommentField)
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Item No.")
        {
            field(SBSINVLocationCode; Rec.SBSINVLocationCode)
            {
                ApplicationArea = All;
                Caption = 'Location Code';
                Editable = false;
                ToolTip = 'Specifies the value of the Location Code field.';
            }
        }
        addlast(Control1)
        {
            field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
            {
                ApplicationArea = All;
                Caption = 'Alternate Lot No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Alternate Lot No. field.';
            }
            field(SBSINVLabel; Rec.SBSINVLabel)
            {
                ApplicationArea = All;
                Caption = 'Label';
                Editable = false;
                ToolTip = 'Specifies the value of the Label field.';
            }
            field(SBSINVVessel; Rec.SBSINVVessel)
            {
                ApplicationArea = All;
                Caption = 'Vessel';
                Editable = false;
                ToolTip = 'Specifies the value of the Vessel field.';
            }
            field(SBSINVContainerNo; Rec.SBSINVContainerNo)
            {
                ApplicationArea = All;
                Caption = 'Container No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Container No. field.';
            }
            field(SBSINVProductionDate; Rec.SBSINVProductionDate)
            {
                ApplicationArea = All;
                Caption = 'Production Date';
                Editable = false;
                ToolTip = 'Specifies the value of the Production Date field.';
            }
            field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
            {
                ApplicationArea = All;
                Caption = 'Expiration Date';
                Editable = false;
                ToolTip = 'Specifies the value of the Expiration Date field.';
            }
            field(SBSINVVendorNo; Rec.SBSINVVendorNo)
            {
                ApplicationArea = All;
                Caption = 'Vendor No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }
            field(SBSINVVendorName; Rec.SBSINVVendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field(SBSINVIsAvailable; Rec.SBSINVIsAvailable)
            {
                ApplicationArea = All;
                Caption = 'Is Available';
                Editable = false;
                ToolTip = 'Specifies the value of the Is Available field.';
            }
            field(SBSINVOnPurchaseOrder; Rec.SBSINVOnPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'On Purchase Order';
                Editable = false;
                ToolTip = 'Specifies the value of the On Purchase Order field.';
            }
            field(SBSINVOnHandQuantity; Rec.SBSINVOnHandQuantity)
            {
                ApplicationArea = All;
                Caption = 'On Hand Quantity';
                Editable = false;
                ToolTip = 'Specifies the value of the On Hand Quantity field.';
            }
            field(SBSINVOnOrderQuantity; Rec.SBSINVOnOrderQuantity)
            {
                ApplicationArea = All;
                Caption = 'On Order Quantity';
                Editable = false;
                ToolTip = 'Specifies the value of the On Order Quantity field.';
            }
            field(SBSINVQtyOnSalesOrder; Rec.SBSINVQtyOnSalesOrder)
            {
                ApplicationArea = All;
                Caption = 'Qty. on Sales Orders';
                Editable = false;
                ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SBSINVUpdateLotNoInformation)
            {
                ApplicationArea = All;
                Caption = 'Update Lot No. Information';
                Image = Refresh;
                ToolTip = 'Update Lot No. Information from Item Ledger Entries and Purchase Lines.';

                trigger OnAction()
                begin
                    this.UpdateLotNoInfoFromItemLedgerEntries();
                    this.UpdateLotNoInfoFromPurchaseLines();
                end;
            }
        }
    }

    var
        UpdateExistingRecordsQst: Label 'Do you want to update existing Lot No. Information records?';

    local procedure UpdateLotNoInfoFromItemLedgerEntries()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        UpdateAllRecords: Boolean;
    begin
        UpdateAllRecords := Dialog.Confirm(UpdateExistingRecordsQst);

        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
        if ItemLedgerEntry.FindSet() then
            repeat
                if LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") or UpdateAllRecords then
                    LotNoInformation.SBSINVSetCustomFieldsFromItemLedgerEntry(ItemLedgerEntry);
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure UpdateLotNoInfoFromPurchaseLines()
    var
        PurchaseLine: Record "Purchase Line";
        LotNoInformation: Record "Lot No. Information";
    begin
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("No.", '<>%1', '');
        PurchaseLine.SetFilter(SBSINVLotNo, '<>%1', '');
        PurchaseLine.SetRange("Quantity (Base)", 0);
        if PurchaseLine.FindSet() then
            repeat
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(PurchaseLine);
            until PurchaseLine.Next() = 0;
    end;
}