namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
/// </summary>
tableextension 60310 SBSINVPurchaseLine extends "Purchase Line"
{
    fields
    {
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60302; SBSINVLotNo; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a lot number if the item carries such a number.';

            trigger OnValidate()
            var
                NewLotNo: Code[50];
                OriginalLotNo: Code[50];
            begin
                // TODO: This code can be improved by refactoring it out into smaller procedures/functions to enhance readability and maintainability. This should not all be in an "OnValidate" trigger.
                Rec.TestField("Location Code");
                Rec.TestField(Type, Rec.Type::Item);
                this.CheckIfLotAlreadyReceived();
                OriginalLotNo := xRec.SBSINVLotNo;
                NewLotNo := Rec.SBSINVLotNo;
                // TODO: The following code can likely be improved via use of a case statement for better clarity.
                if (OriginalLotNo = '') and (NewLotNo <> '') then begin
                    this.CheckIfDuplicateLot(NewLotNo);
                    this.CreateReservationEntryForPurchaseLine(Rec);
                end else
                    if (OriginalLotNo <> '') and (NewLotNo = '') then begin
                        this.CheckIfSOReservationsExistForItemAndLot(Rec."No.", OriginalLotNo, Rec.Type, Rec.Quantity);
                        this.DeleteReservationEntriesForPOLine();
                        LotNoInformation.SBSINVDeleteLotNoInfoForPurchaseLine(Rec, OriginalLotNo);
                    end else
                        if NewLotNo <> OriginalLotNo then begin
                            this.CheckIfDuplicateLot(NewLotNo);
                            LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
                            LotNoInformation.SBSINVDeleteLotNoInfoForPurchaseLine(Rec, OriginalLotNo);
                            this.UpdateLotOnSales(OriginalLotNo, NewLotNo, Rec.SBSINVProductionDate, Rec.SBSINVProductionDate, Rec.SBSINVExpirationDate, Rec.SBSINVExpirationDate);
                            this.UpdateLotOnPurchaseLineReservationEntry(Rec, NewLotNo);
                        end;
            end;
        }
        field(60303; SBSINVAlternateLotNo; Code[50])
        {
            Caption = 'Alternate Lot No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Alternate Lot No. field.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60304; SBSINVLabel; Text[50])
        {
            Caption = 'Label';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Label field.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60310; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Vessel field.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60311; SBSINVContainerNo; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Container No. field.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60330; SBSINVCountryOfOrigin; Text[30])
        {
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("No.")));
            Caption = 'Country of Origin';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the value of the Country of Origin field.';
        }
        field(60312; SBSINVProductionDate; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Production Date field.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
        field(60313; SBSINVExpirationDate; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the last date that the item on the line can be used.';

            trigger OnValidate()
            begin
                LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
            end;
        }
    }

    var
        LotNoInformation: Record "Lot No. Information";
        DocumentNumberBlankErr: Label 'Document No. must not be blank';
        LotExistsErr: Label 'Lot %1 already exists', Comment = '%1 = Lot No.';
        LotRecievedErr: Label 'You cannot change %1 after the lot has been received.', Comment = '%1 = name of the field being changed.';
        SalesReservationsExistErr: Label 'Sales Order Reservations Exist for Item %1 Lot %2', Comment = '%1 = an item number, %2 = a lot number';

    internal procedure SBSINVAssignNewLotNo()
    begin
        // TODO: Review this code for consistency with other similar functions. Do we have a good reason for using TestField here but in other parts of the related code we're simply exiting procedures on the same conditions?
        // TODO: Improve / simplify this procedure by migrating the "tests" to their own procedure that'd control whether or not the balance of the procedure code would execute.
        if Rec.Quantity = 0 then
            exit;
        Rec.TestField(Type, Rec.Type::Item);
        Rec.TestField(SBSINVLotNo, '');
        Rec.TestField("Location Code");

        Rec.SBSINVLotNo := this.SBSINVGetNextLotNoForDocumentNo(Rec."Document No.", '', Rec."Document No.");
        this.CreateReservationEntryForPurchaseLine(Rec);
        LotNoInformation.SBSINVSetCustomFieldsFromPurchaseLine(Rec);
    end;

    internal procedure SBSINVGetNextLotNoForDocumentNo(SourceID: Code[20]; SourceBatchName: Code[20]; DocumentNo: Code[20]) NewLotNo: Code[50]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
    begin
        // TODO: Improve / simplify this procedure by migrating the "tests" to their own procedure that'd control whether or not the balance of the procedure code would execute.        
        if DocumentNo = '' then
            Error(DocumentNumberBlankErr);

        // TODO: Improve / simplify this procedure by refactoring the logic for generating the new lot number in the following 2 code blocks into a separate procedures.
        ReservationEntry.SetRange("Source ID", SourceID);
        ReservationEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservationEntry.SetFilter("Lot No.", DocumentNo + '*');
        ReservationEntry.SetCurrentKey("Lot No.");
        if ReservationEntry.FindLast() then
            NewLotNo := IncStr(ReservationEntry."Lot No.")
        else
            NewLotNo := DocumentNo + '-001';

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1409 - Issue with Undo Receipt
        ItemLedgerEntry.SetRange("Lot No.", NewLotNo);
        ItemLedgerEntry.SetCurrentKey("Lot No.");
        if not ItemLedgerEntry.IsEmpty then begin
            ItemLedgerEntry.SetFilter("Lot No.", DocumentNo + '*');
            ItemLedgerEntry.FindLast();
            NewLotNo := IncStr(ItemLedgerEntry."Lot No.");
        end;

        exit(NewLotNo);
    end;

    local procedure CheckIfDuplicateLot(LotNo: Code[50])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        if not ItemLedgerEntry.IsEmpty then
            Error(LotExistsErr, LotNo);
    end;

    local procedure CheckIfLotAlreadyReceived()
    var
        PurchaseLineRecRef: RecordRef;
        CurrFieldRef: FieldRef;
        FieldName: Text;
    begin
        if Rec."Quantity Received" > 0 then begin
            if CurrFieldNo = 0 then
                FieldName := 'Lot Information'
            else begin
                PurchaseLineRecRef.Open(Database::"Purchase Line");
                CurrFieldRef := PurchaseLineRecRef.Field(CurrFieldNo);
                FieldName := CurrFieldRef.Caption();
            end;
            Error(LotRecievedErr, FieldName);
        end;
    end;

    local procedure CheckIfSOReservationsExistForItemAndLot(ItemNo: Code[20]; LotNo: Code[50]; PurchaseLineType: Enum "Purchase Line Type"; PurchaseLineQuantity: Decimal)
    var
        SalesLineReservationEntry: Record "Reservation Entry";
    begin
        // TODO: Improve / simplify this procedure by migrating the "tests" to their own procedure that'd control whether or not the balance of the procedure code would execute.
        if PurchaseLineType <> PurchaseLineType::Item then
            exit;
        if PurchaseLineQuantity <= 0 then
            exit;
        if LotNo = '' then
            exit;

        SalesLineReservationEntry.SetRange("Item No.", ItemNo);
        SalesLineReservationEntry.SetRange("Lot No.", LotNo);
        SalesLineReservationEntry.SetRange("Source Type", Database::"Sales Line");
        SalesLineReservationEntry.SetRange("Source Subtype", 1);
        if not SalesLineReservationEntry.IsEmpty then
            Error(SalesReservationsExistErr, ItemNo, LotNo);
    end;

    local procedure CopyPurchaseLineToTrackingSpecification(PurchaseLine: Record "Purchase Line"; var TrackingSpecification: Record "Tracking Specification")
    begin
        TrackingSpecification."Source Type" := Database::"Purchase Line";
        TrackingSpecification."Source Subtype" := 1;
        TrackingSpecification."Source ID" := PurchaseLine."Document No.";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := PurchaseLine."Line No.";
        TrackingSpecification."Item No." := PurchaseLine."No.";
        TrackingSpecification.Description := '';
        TrackingSpecification."Variant Code" := PurchaseLine."Variant Code";
        TrackingSpecification."Location Code" := PurchaseLine."Location Code";
        TrackingSpecification."Serial No." := '';
        TrackingSpecification."Lot No." := PurchaseLine.SBSINVLotNo;
        TrackingSpecification."Qty. per Unit of Measure" := PurchaseLine."Qty. per Unit of Measure";
        TrackingSpecification."Quantity (Base)" := PurchaseLine."Quantity (Base)";
        TrackingSpecification."Expiration Date" := PurchaseLine.SBSINVExpirationDate;
    end;

    local procedure CreateReservationEntryForPurchaseLine(PurchaseLine: Record "Purchase Line")
    var
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ShipmentDate: Date;
        CurrentEntryStatus: Enum "Reservation Status";
        TransferredFromEntryNo: Integer;
    begin
        this.CopyPurchaseLineToTrackingSpecification(PurchaseLine, TrackingSpecification);
        CurrentEntryStatus := CurrentEntryStatus::Surplus;
        ShipmentDate := 0D;
        TransferredFromEntryNo := 0;

        if not PurchLineReserve.FindReservEntry(PurchaseLine, ReservationEntry) then begin
            CreateReservEntry.CreateReservEntryFor(
                      TrackingSpecification."Source Type",
                      TrackingSpecification."Source Subtype",
                      TrackingSpecification."Source ID",
                      TrackingSpecification."Source Batch Name",
                      TrackingSpecification."Source Prod. Order Line",
                      TrackingSpecification."Source Ref. No.",
                      TrackingSpecification."Qty. per Unit of Measure",
                      0,
                      TrackingSpecification."Quantity (Base)",
                      ReservationEntry);

            CreateReservEntry.CreateEntry(TrackingSpecification."Item No.",
                      TrackingSpecification."Variant Code",
                      TrackingSpecification."Location Code",
                      TrackingSpecification.Description,
                      PurchaseLine."Expected Receipt Date",
                      ShipmentDate, TransferredFromEntryNo, CurrentEntryStatus);
            CreateReservEntry.GetLastEntry(ReservationEntry);
            ReservationEntry.CopyTrackingFromSpec(TrackingSpecification);
            ReservationEntry.Modify();
        end;
    end;

    local procedure DeleteReservationEntriesForPOLine()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Item No.", Rec."No.");
        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Source ID", Rec."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
        if not ReservationEntry.IsEmpty then
            ReservationEntry.DeleteAll();
    end;

    local procedure FindReservationEntryForPurchaseLine(PurchaseLine: Record "Purchase Line"; var ReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.", "Serial No.");
        ReservationEntry.SetRange(Positive, true);
        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetFilter("Source ID", PurchaseLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchaseLine."Line No.");
        ReservationEntry.SetRange("Item No.", PurchaseLine."No.");
        ReservationEntry.SetRange("Variant Code", PurchaseLine."Variant Code");
        ReservationEntry.SetRange("Location Code", PurchaseLine."Location Code");
        ReservationEntry.FindFirst();
    end;

    local procedure UpdateLotOnPurchaseLineReservationEntry(PurchaseLine: Record "Purchase Line"; NewLotNo: Code[50])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if PurchaseLine.SBSINVLotNo = '' then
            exit;

        this.FindReservationEntryForPurchaseLine(PurchaseLine, ReservationEntry);

        ReservationEntry.FindSet();
        repeat
            ReservationEntry."Lot No." := NewLotNo;
            ReservationEntry."Expiration Date" := PurchaseLine.SBSINVExpirationDate;
            ReservationEntry.Quantity := PurchaseLine.Quantity;
            ReservationEntry."Quantity (Base)" := PurchaseLine."Quantity (Base)";
            ReservationEntry."Qty. to Handle (Base)" := PurchaseLine."Qty. to Receive (Base)";
            ReservationEntry."Qty. to Invoice (Base)" := PurchaseLine."Qty. to Invoice (Base)";
            ReservationEntry.Modify();
        until (ReservationEntry.Next() = 0);
    end;

    local procedure UpdateLotOnSales(OriginalLotNo: Code[50]; NewLotNo: Code[50]; OriginalProductionDate: Date; NewProductionDate: Date;
                                        OriginalExpirationDate: Date; NewExpirationDate: Date)
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
    begin
        // TODO: Improve / simplify this procedure by migrating the "tests" to their own procedure that'd control whether or not the balance of the procedure code would execute.
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        if Rec."No." = '' then
            exit;
        if (OriginalLotNo = '') then
            exit;
        if (NewLotNo = OriginalLotNo) and
           (NewProductionDate = OriginalProductionDate) and
           (NewExpirationDate = OriginalExpirationDate) then
            exit;

        // TODO: Improve / simplify this procedure by refactoring the logic in the following 2 code blocks into separate procedures.
        ReservationEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.", "Serial No.");
        ReservationEntry.SetRange(Positive, false);
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Item No.", Rec."No.");
        ReservationEntry.SetRange("Variant Code", Rec."Variant Code");
        ReservationEntry.SetRange("Location Code", Rec."Location Code");
        ReservationEntry.SetRange("Lot No.", OriginalLotNo);
        ReservationEntry.SetFilter("Source ID", '<>%1', '');
        if ReservationEntry.FindSet() then
            repeat
                ReservationEntry2 := ReservationEntry;
                ReservationEntry2."Lot No." := NewLotNo;
                ReservationEntry2."Expiration Date" := Rec.SBSINVExpirationDate;
                ReservationEntry2.Modify(false);
                if SalesLine.Get(ReservationEntry."Source Subtype", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.") then begin
                    TempSalesLine := SalesLine;
                    TempSalesLine.SetRecFilter();
                    if TempSalesLine.IsEmpty then
                        TempSalesLine.Insert();
                end;
            until ReservationEntry.Next() = 0;

        SelectLatestVersion();
        TempSalesLine.Reset();
        if TempSalesLine.FindSet() then
            repeat
                SalesLine := TempSalesLine;
                SalesLine.SBSINVGetLotNoAndAllocatedQty(SalesLine);
            until (TempSalesLine.Next() = 0);
    end;
}