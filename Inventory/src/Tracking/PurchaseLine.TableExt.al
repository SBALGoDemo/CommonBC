// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2855 - Add Purchase Order Subform lot tracking enhancements
tableextension 60310 PurchaseLine extends "Purchase Line"
{
    fields
    {
        field(60300; SBSINVLotNo; Code[20])
        {
            Caption = 'Lot No.';
            trigger OnValidate()
            var
                LotNoInformation: Record "Lot No. Information";
                OriginalLotNo: Code[20];
                NewLotNo: Code[20];
            begin
                Rec.TestField("Location Code");
                Rec.TestField(Type, Rec.Type::Item);
                CheckIfLotAlreadyReceived();
                OriginalLotNo := xRec.SBSINVLotNo;
                NewLotNo := Rec.SBSINVLotNo;
                if (OriginalLotNo = '') and (NewLotNo <> '') then begin
                    CheckIfDuplicateLot(NewLotNo);
                    CreateReservationEntryForPurchaseLine(Rec);
                end else if (OriginalLotNo <> '') and (NewLotNo = '') then begin
                    CheckIfSOReservationsExistForItemAndLot(Rec."No.", OriginalLotNo, Rec.Type, Rec.Quantity);
                    DeleteReservationEntriesForPOLine();
                    DeleteLotNoInfoForPurchaseLine(Rec, OriginalLotNo);
                end else if NewLotNo <> OriginalLotNo then begin
                    CheckIfDuplicateLot(NewLotNo);
                    UpdateLotNoInfoForPurchaseLine(Rec, xRec);
                    DeleteLotNoInfoForPurchaseLine(Rec, OriginalLotNo);
                    UpdateLotOnSales(OriginalLotNo, NewLotNo, Rec.SBSINVProductionDate, Rec.SBSINVProductionDate, Rec.SBSINVExpirationDate, Rec.SBSINVExpirationDate);
                    UpdateLotOnPurchaseLineReservationEntry(Rec, OriginalLotNo, NewLotNo);
                end;
            end;
        }
        field(60305; SBSINVAlternateLotNo; Code[20])
        {
            Caption = 'Alternate Lot No.';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
        field(60310; SBSINVLabel; Text[50])
        {
            Caption = 'Label';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
        field(60325; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
        field(60330; SBSINVContainerNo; Code[20])
        {
            Caption = 'Container No.';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
        field(60335; SBSINVCountryOfOrigin; Text[30])
        {
            Caption = 'Country of Origin';
            TableRelation = "Country/Region";
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("No.")));
            fieldClass = Flowfield;
            Editable = false;
        }
        field(60340; SBSINVProductionDate; Date)
        {
            Caption = 'Production Date';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
        field(60345; SBSINVExpirationDate; Date)
        {
            Caption = 'Expiration Date';
            trigger OnValidate()
            begin
                UpdateLotNoInfoForPurchaseLine(Rec, xRec);
            end;
        }
    }
    local procedure UpdateLotNoInfoForPurchaseLine(PurchaseLine: Record "Purchase Line"; xPurchaseLine: record "Purchase Line")
    var
        LotNoInformation: Record "Lot No. Information";
        InventorySetup: Record "Inventory Setup";
        Vendor: Record Vendor;
    begin
        if PurchaseLine.SBSINVLotNo = '' then
            exit;
        if PurchaseLine.Type <> PurchaseLine.Type::Item then
            exit;
        if PurchaseLine."No." = '' then
            exit;
        if not CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine, xPurchaseLine) then
            exit;
        if not LotNoInformation.Get(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine.SBSINVLotNo) then begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := PurchaseLine."No.";
            LotNoInformation."Variant Code" := PurchaseLine."Variant Code";
            LotNoInformation."Lot No." := PurchaseLine.SBSINVLotNo;
            LotNoInformation.Description := '';
            LotNoInformation.SBSINVVendorNo := PurchaseLine."Buy-from Vendor No.";
            if Vendor.Get(PurchaseLine."Buy-from Vendor No.") then
                LotNoInformation.SBSINVVendorName := Vendor.Name
            else
                LotNoInformation.SBSINVVendorName := '';
            LotNoInformation.Insert();
        end;
        LotNoInformation.SBSINVAlternateLotNo := PurchaseLine.SBSINVAlternateLotNo;
        LotNoInformation.SBSINVLabel := PurchaseLine.SBSINVLabel;
        LotNoInformation.SBSINVExpirationDate := PurchaseLine.SBSINVExpirationDate;
        LotNoInformation.SBSINVProductionDate := PurchaseLine.SBSINVProductionDate;
        LotNoInformation.SBSINVContainerNo := PurchaseLine.SBSINVContainerNo;
        LotNoInformation.SBSINVVessel := PurchaseLine.SBSINVVessel;
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;

    local procedure DeleteLotNoInfoForPurchaseLine(PurchaseLine: Record "Purchase Line"; LotNo: Code[20])
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNo = '' then
            exit;
        if PurchaseLine.Type <> PurchaseLine.Type::Item then
            exit;
        if PurchaseLine."No." = '' then
            exit;
        if LotNoInformation.Get(PurchaseLine."No.", PurchaseLine."Variant Code", LotNo) then
            LotNoInformation.Delete();
    end;

    local procedure CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine: Record "Purchase Line"; xPurchaseLine: record "Purchase Line"): Boolean
    begin
        if (PurchaseLine.SBSINVAlternateLotNo = xPurchaseLine.SBSINVAlternateLotNo) and
           (PurchaseLine.SBSINVLabel = xPurchaseLine.SBSINVLabel) and
           (PurchaseLine.SBSINVExpirationDate = xPurchaseLine.SBSINVExpirationDate) and
           (PurchaseLine.SBSINVProductionDate = xPurchaseLine.SBSINVProductionDate) and
           (PurchaseLine.SBSINVContainerNo = xPurchaseLine.SBSINVContainerNo) and
           (PurchaseLine.SBSINVVessel = xPurchaseLine.SBSINVVessel) then
            exit(false)
        else
            exit(true);
    end;

    local procedure DeleteReservationEntriesForPOLine();
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

    local procedure CheckIfLotAlreadyReceived();
    var
        PurchaseLineRecRef: RecordRef;
        CurrFieldRef: FieldRef;
        FieldName: Text[50];
    begin
        if Rec."Quantity Received" > 0 then begin
            if CurrFieldNo = 0 then
                FieldName := 'Lot Information'
            else begin
                PurchaseLineRecRef.Open(Database::"Purchase Line");
                CurrFieldRef := PurchaseLineRecRef.Field(CurrFieldNo);
                FieldName := CurrFieldRef.Caption;
            end;
            Error('You cannot change %1 after the lot has been received.', FieldName);
        end;
    end;

    local procedure CreateReservationEntryForPurchaseLine(PurchaseLine: Record "Purchase Line");
    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TrackingSpecification: Record "Tracking Specification";
        InventorySetup: Record "Inventory Setup";
        ReservationEntry: Record "Reservation Entry";
        ShipmentDate: Date;
        CurrentEntryStatus: Enum "Reservation Status";
        TransferredFromEntryNo: Integer;
    begin
        CopyPurchaseLineToTrackingSpecification(PurchaseLine, TrackingSpecification);
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

    local procedure CopyPurchaseLineToTrackingSpecification(PurchaseLine: Record "Purchase Line"; var TrackingSpecification: record "Tracking Specification");
    begin
        TrackingSpecification."Source Type" := DATABASE::"Purchase Line";
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

    local procedure CheckIfDuplicateLot(LotNo: Code[20])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        if not ItemLedgerEntry.IsEmpty then
            Error('Lot %1 already exists', LotNo);
    end;

    local procedure UpdateLotOnPurchaseLineReservationEntry(PurchaseLine: Record "Purchase Line"; OriginalLotNo: Code[20]; NewLotNo: Code[20])
    var
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        InventorySetup: Record "Inventory Setup";
        NumResEntries: Integer;
    begin
        if PurchaseLine.SBSINVLotNo = '' then
            exit;
        FindReservationEntryForPurchaseLine(PurchaseLine, ReservationEntry);
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

    local procedure UpdateLotOnSales(OriginalLotNo: Code[20]; NewLotNo: Code[20]; OriginalProductionDate: Date; NewProductionDate: Date;
                                        OriginalExpirationDate: Date; NewExpirationDate: Date)
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        SalesLineTemp: Record "Sales Line" temporary;
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        if Rec."No." = '' then
            exit;
        If (OriginalLotNo = '') then
            exit;
        if (NewLotNo = OriginalLotNo) and
           (NewProductionDate = OriginalProductionDate) and
           (NewExpirationDate = OriginalExpirationDate) then
            exit;
        ReservationEntry.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.", "Serial No.");
        ReservationEntry.SetRange(Positive, false);
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", 1);
        ReservationEntry.SetRange("Item No.", Rec."No.");
        ReservationEntry.SetRange("Variant Code", Rec."Variant Code");
        ReservationEntry.SetRange("Location Code", Rec."Location Code");
        ReservationEntry.SetRange("Lot No.", OriginalLotNo);
        ReservationEntry.SetFilter("Source ID", '<>%1', '');
        If ReservationEntry.FindSet then
            repeat
                ReservationEntry2 := ReservationEntry;
                ReservationEntry2."Lot No." := NewLotNo;
                ReservationEntry2."Expiration Date" := Rec.SBSINVExpirationDate;
                ReservationEntry2.Modify(false);
                if SalesLine.Get(ReservationEntry."Source Subtype", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.") then begin
                    SalesLineTemp := SalesLine;
                    SalesLineTemp.SetRecFilter;
                    if SalesLineTemp.IsEmpty then
                        SalesLineTemp.Insert;
                end;
            until ReservationEntry.Next = 0;
        SelectLatestVersion;
        SalesLineTemp.Reset;
        if SalesLineTemp.FindSet then
            repeat
                SalesLine := SalesLineTemp;
                SalesLine.GetLotNoAndAllocatedQty(SalesLine);
            until (SalesLineTemp.Next = 0);
    end;

    local procedure CheckIfSOReservationsExistForItemAndLot(ItemNo: Code[20]; LotNo: Code[20]; PurchaseLineType: enum "Purchase Line Type"; PurchaseLineQuantity: Decimal);
    var
        SalesLineReservationEntry: Record "Reservation Entry";
    begin
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
            Error('Sales Order Reservations Exist for Item %1 Lot %2', ItemNo, LotNo);
    end;
}