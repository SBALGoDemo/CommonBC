namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Ledger;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
/// TODO: Review and refactor code in the page extension when possible. Significant amounts of the code can likely be simplified and made more intuitive by migrating it to procedures in codeunits. 
/// </summary>
pageextension 60304 ItemTrackingLines extends "Item Tracking Lines"
{
    layout
    {
        modify("Serial No.")
        {
            Visible = false;
        }
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2946 - Add Subform to Item Tracking Lines page
        addbefore(Control1)
        {
            part(SBSINVLotAllocationSubpage; "Lot Allocation Subpage")
            {
                ApplicationArea = All;
                Caption = 'Lot Allocation Subpage';
            }
        }
        addlast(Control1)
        {
            field(SBSINVAlternateLotNo; LotNoInformation.SBSINVAlternateLotNo)
            {
                ApplicationArea = All;
                Caption = 'Alternate Lot No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Alternate Lot No. field.';
            }
            field(SBSINVVessel; LotNoInformation.SBSINVVessel)
            {
                ApplicationArea = All;
                Caption = 'Vessel';
                Editable = false;
                ToolTip = 'Specifies the value of the Vessel field.';
            }
            field(SBSINVLotText; LotNoInformation.SBSINVLotText)
            {
                ApplicationArea = All;
                Caption = 'Lot Text';
                Editable = false;
                ToolTip = 'Specifies the value of the Lot Text field.';
            }
            field(SBSINVVendorNo; LotNoInformation.SBSINVVendorNo)
            {
                ApplicationArea = All;
                Caption = 'Vendor No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }
            field(SBSINVVendorName; LotNoInformation.SBSINVVendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field(SBSINVCountryofOriginCode; Rec.SBSINVCountryOfOriginCode)
            {
                ApplicationArea = All;
                Caption = 'Country of Origin Code';
                Editable = false;
                ToolTip = 'Specifies the value of the Country of Origin Code field.';
            }
            field(SBSINVContainerNo; LotNoInformation.SBSINVContainerNo)
            {
                ApplicationArea = All;
                Caption = 'Container No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Container No. field.';
            }
            field(SBSINVProductionDate; LotNoInformation.SBSINVProductionDate)
            {
                ApplicationArea = All;
                Caption = 'Production Date';
                Editable = false;
                ToolTip = 'Specifies the value of the Production Date field.';
            }
            field(SBSINVNewProductionDate; Rec.SBSINVNewProductionDate)
            {
                ApplicationArea = ItemTracking;
                Caption = 'New Production Date';
                Editable = NewExpirationDateEditable;
                ToolTip = 'Specifies a new Production date.';
                Visible = NewExpirationDateVisible;
            }
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    actions
    {
        addlast(FunctionsDemand)
        {
            action(SBSINVApplyLotAllocation)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Apply Lot Allocation (Alt+A)';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortcutKey = 'Alt+A';
                ToolTip = 'Select from existing, available lots.';
                Visible = FunctionsDemandVisible;

                trigger OnAction()
                var
                    TempLotNoInformation: Record "Lot No. Information" temporary;
                    xTrackingSpec: Record "Tracking Specification";
                begin
                    xTrackingSpec.CopyFilters(Rec);
                    if InsertIsBlocked then
                        exit;

                    CurrPage.SBSINVLotAllocationSubpage.Page.GetSelected(TempLotNoInformation);
                    CurrPage.SBSINVLotAllocationSubpage.Page.UpdateSelected();

                    if TempLotNoInformation.IsEmpty then
                        exit;

                    // Swap sign on the selected entries if parent is a negative supply line

                    if CurrentSignFactor > 0 then // Negative supply lines
                        if TempLotNoInformation.Find('-') then
                            repeat
                                TempLotNoInformation.SBSINVSelectedQuantity := -TempLotNoInformation.SBSINVSelectedQuantity;
                                TempLotNoInformation.Modify();
                            until TempLotNoInformation.Next() = 0;

                    // Modify the item tracking lines with the selected quantities
                    this.SBSINVAddSelectedTrackingToDataSet(TempLotNoInformation, Rec, CurrentSignFactor);

                    Rec."Bin Code" := '';
                    if Rec.FindSet() then
                        repeat
                            case Rec."Buffer Status" of
                                Rec."Buffer Status"::MODIFY:
                                    begin
                                        if TempItemTrackLineModify.Get(Rec."Entry No.") then
                                            TempItemTrackLineModify.Delete();
                                        if TempItemTrackLineInsert.Get(Rec."Entry No.") then begin
                                            TempItemTrackLineInsert.TransferFields(Rec);
                                            TempItemTrackLineInsert.Modify();
                                        end else begin
                                            TempItemTrackLineModify.TransferFields(Rec);
                                            TempItemTrackLineModify.Insert();
                                        end;
                                    end;
                                Rec."Buffer Status"::INSERT:
                                    begin
                                        TempItemTrackLineInsert.TransferFields(Rec);
                                        TempItemTrackLineInsert.Insert();
                                    end;
                            end;
                            Rec."Buffer Status" := 0;
                            Rec.Modify();
                        until Rec.Next() = 0;

                    LastEntryNo := Rec."Entry No.";
                    this.CalculateSums();

                    this.SBSINVUpdateUndefinedQtyArray();
                    CurrPage.SBSINVLotAllocationSubpage.Page.SetSelectedQuantity();
                    //UpdateEntriesOnAllocation(TempEntrySummary); //IBNH

                    Rec.CopyFilters(xTrackingSpec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if not LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            LotNoInformation.Init();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.SBSINVLotAllocationSubpage.Page.SetPageDataForItemVariantAndLocation(Rec."Item No.", Rec."Variant Code", Rec."Location Code");
    end;

    var
        LotNoInformation: Record "Lot No. Information";

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    /// </summary>
    /// <param name="TempLotNoInformation"></param>
    /// <param name="TempTrackingSpecification"></param>
    /// <param name="CurrentSignFactor"></param>
    internal procedure SBSINVAddSelectedTrackingToDataSet(var TempLotNoInformation: Record "Lot No. Information" temporary; var TempTrackingSpecification: Record "Tracking Specification" temporary; CurrentSignFactor: Integer)
    var
        TrackingSpecification2: Record "Tracking Specification";
        LastEntryNo: Integer;
    begin
        TempLotNoInformation.Reset();
        TempLotNoInformation.SetFilter(SBSINVSelectedQuantity, '<>%1', 0);
        if TempLotNoInformation.IsEmpty then
            exit;

        // To save general and pointer information
        TrackingSpecification2.Init();
        TrackingSpecification2."Item No." := TempTrackingSpecification."Item No.";
        TrackingSpecification2."Location Code" := TempTrackingSpecification."Location Code";
        TrackingSpecification2."Source Type" := TempTrackingSpecification."Source Type";
        TrackingSpecification2."Source Subtype" := TempTrackingSpecification."Source Subtype";
        TrackingSpecification2."Source ID" := TempTrackingSpecification."Source ID";
        TrackingSpecification2."Source Batch Name" := TempTrackingSpecification."Source Batch Name";
        TrackingSpecification2."Source Prod. Order Line" := TempTrackingSpecification."Source Prod. Order Line";
        TrackingSpecification2."Source Ref. No." := TempTrackingSpecification."Source Ref. No.";
        TrackingSpecification2.Positive := TempTrackingSpecification.Positive;
        TrackingSpecification2."Qty. per Unit of Measure" := TempTrackingSpecification."Qty. per Unit of Measure";
        TrackingSpecification2."Variant Code" := TempTrackingSpecification."Variant Code";

        TempTrackingSpecification.Reset();
        if TempTrackingSpecification.FindLast() then
            LastEntryNo := TempTrackingSpecification."Entry No.";

        TempLotNoInformation.FindFirst();
        repeat
            TempTrackingSpecification.SetRange("Lot No.", TempLotNoInformation."Lot No.");
            if TempTrackingSpecification.FindFirst() then begin
                TempTrackingSpecification.Validate("Quantity (Base)",
                TempTrackingSpecification."Quantity (Base)" + TempLotNoInformation.SBSINVSelectedQuantity);
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
                this.SBSINVTransferFromLotNoInformationToTrackingSpecification(TempTrackingSpecification, TempLotNoInformation);
                TempTrackingSpecification.Modify();
                //UpdateTrackingDataSetWithChange(TempTrackingSpecification, true, CurrentSignFactor, ChangeType::Modify);
            end else begin
                TempTrackingSpecification := TrackingSpecification2;
                TempTrackingSpecification."Entry No." := LastEntryNo + 1;
                LastEntryNo := TempTrackingSpecification."Entry No.";
                TempTrackingSpecification."Lot No." := TempLotNoInformation."Lot No.";
                TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::INSERT;
                this.SBSINVTransferFromLotNoInformationToTrackingSpecification(TempTrackingSpecification, TempLotNoInformation);
                if TempTrackingSpecification.IsReclass() then begin
                    TempTrackingSpecification."New Serial No." := TempTrackingSpecification."Serial No.";
                    TempTrackingSpecification."New Lot No." := TempTrackingSpecification."Lot No.";
                end;

                TempTrackingSpecification.Validate("Quantity (Base)", TempLotNoInformation.SBSINVSelectedQuantity);
                TempTrackingSpecification.Insert();
                //UpdateTrackingDataSetWithChange(TempTrackingSpecification, true, CurrentSignFactor, ChangeType::Insert);
            end;
        until TempLotNoInformation.Next() = 0;

        TempTrackingSpecification.Reset();
    end;

    local procedure SBSINVTransferFromLotNoInformationToTrackingSpecification(var TrackingSpecification: Record "Tracking Specification" temporary; var TempLotNoInformation: Record "Lot No. Information" temporary)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", TrackingSpecification."Item No.");
        ItemLedgerEntry.SetRange("Lot No.", TrackingSpecification."Lot No.");
        ItemLedgerEntry.SetFilter(Quantity, '>0');
        if not ItemLedgerEntry.IsEmpty then
            ItemLedgerEntry.FindFirst()
        else
            ItemLedgerEntry.Init();

        TempLotNoInformation.CalcFields(SBSINVOnOrderQuantity, SBSINVQtyOnSalesOrder);
        TempLotNoInformation.SBSINVTotalQuantity := TempLotNoInformation.SBSINVOnHandQuantity + TempLotNoInformation.SBSINVOnOrderQuantity - TempLotNoInformation.SBSINVQtyOnSalesOrder;

        if TempLotNoInformation.SBSINVTotalQuantity <> 0 then begin
            TrackingSpecification."Buffer Status2" := TrackingSpecification."Buffer Status2"::"ExpDate blocked";
            TrackingSpecification."Expiration Date" := TempLotNoInformation.SBSINVExpirationDate;
            if TrackingSpecification.IsReclass() then begin
                TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date";
                TrackingSpecification.SBSINVNewProductionDate := ItemLedgerEntry.SBSINVProductionDate;
            end else begin
                TrackingSpecification."New Expiration Date" := 0D;
                TrackingSpecification.SBSINVNewProductionDate := 0D;
            end;
        end else begin
            TrackingSpecification."Buffer Status2" := 0;
            TrackingSpecification."Expiration Date" := 0D;
            TrackingSpecification."New Expiration Date" := 0D;
            TrackingSpecification.SBSINVNewProductionDate := 0D;
        end;
    end;

    local procedure SBSINVUpdateUndefinedQtyArray()
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalTrackingSpecification."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalTrackingSpecification."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalTrackingSpecification."Qty. to Invoice (Base)";
    end;
}