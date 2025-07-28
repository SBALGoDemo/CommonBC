// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
pageextension 60306 LotNoInformationListExt extends "Lot No. Information List"
{
    layout
    {
        modify("Item No.")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify(Description)
        {
            Visible = false;
            ApplicationArea = All;
        }
        modify("Test Quality")
        {
            Visible = false;
            ApplicationArea = All;
        }
        modify("Certificate Number")
        {
            Visible = false;
            ApplicationArea = All;
        }
        modify(CommentField)
        {
            Visible = false;
            ApplicationArea = All;
        }

        addafter("Item No.")
        {
            field(SBSINVLocationCode; Rec.SBSINVLocationCode)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addlast(control1)
        {
            field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVLabel; Rec.SBSINVLabel)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVVessel; Rec.SBSINVVessel)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVContainerNo; Rec.SBSINVContainerNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVProductionDate; Rec.SBSINVProductionDate)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVVendorNo; Rec.SBSINVVendorNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVVendorName; Rec.SBSINVVendorName)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVIsAvailable; Rec.SBSINVIsAvailable)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVOnPurchaseOrder; Rec.SBSINVOnPurchaseOrder)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVOnHandQuantity; Rec.SBSINVOnHandQuantity)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVOnOrderQuantity; Rec.SBSINVOnOrderQuantity)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(SBSINVQtyOnSalesOrder; Rec.SBSINVQtyOnSalesOrder)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(UpdateLotNoInformation)
            {
                Caption = 'Update Lot No. Information';
                Image = Refresh;
                ApplicationArea = All;
                ToolTip = 'Update Lot No. Information from Item Ledger Entries and Purchase Lines.';
                trigger OnAction()
                var
                    LotNoInformation: Record "Lot No. Information";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    PurchaseLine: Record "Purchase Line";
                    Question: Text;
                    UpdateAllRecords: Boolean;
                    LotNoInfoRecordExists: Boolean;
                begin
                    Question := 'Do you want to update existing Lot No. Information records?';
                    UpdateAllRecords := Dialog.Confirm(Question);
                    ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
                    ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                    if ItemLedgerEntry.FindSet() then
                        repeat
                            LotNoInfoRecordExists := LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.");
                            if LotNoInfoRecordExists or UpdateAllRecords then
                                LotNoInformation.UpdateLotNoInfoForItemLedgerEntry(ItemLedgerEntry);
                        until ItemLedgerEntry.Next() = 0;

                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("No.", '<>%1', '');
                    PurchaseLine.SetFilter(SBSINVLotNo, '<>%1', '');
                    PurchaseLine.SetRange("Quantity (Base)", 0);
                    if PurchaseLine.FindSet() then
                        repeat
                            LotNoInformation.UpdateLotNoInfoForPurchaseLine(PurchaseLine);
                        until PurchaseLine.Next() = 0;
                end;
            }
        }
    }
}