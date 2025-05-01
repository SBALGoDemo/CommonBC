// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 60304 "SalesLine" extends "Sales Line"
{
    fields
    {
        field(50000; "OBF-Site Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Site Code';
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                SubDimension.UpdateDimSetIDForSubDimension('SITE', "OBF-SITE Code", Rec."Dimension Set ID");
            end;
        }
        field(50001; "OBF-CIP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CIP Code';
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"), "CIP Code Blocked" = const(false));
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                //SubDimension.UpdateDimSetIDForSubDimension('CIP', "OBF-CIP Code", Rec."Dimension Set ID");
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        field(50002; "OBF-MSC Certification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MSC Certification';
            trigger OnValidate()
            begin
                //Rec.TestField(Type,Rec.Type::Item);
            end;
        }
        field(50003; "OBF-RFM Certification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'RFM Certification';
            trigger OnValidate()
            begin
                //Rec.TestField(Type,Rec.Type::Item);
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts        
        field(50004; "OBF-Is Van Info Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50005; "OBF-Is Certification Info Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(50021; "OBF-Line Net Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Net Weight';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
        field(50200; "OBF-Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Header"."Ship-to Code" where("No." = field("Document No.")));
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(50040; "OBF-Allocated Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Allocated Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50041; "OBF-Item Type"; Enum "Item Type")
        {
            Caption = 'Item Type';
            CalcFormula = Lookup(Item.Type where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "OBF-Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            CalcFormula = Lookup(Item."Item Tracking Code" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(50067; "OBF-Lot Number"; Text[250])
        {
            Caption = 'Lot Number(s)';
            Editable = false;
        }

        field(54000; "OBF-Off-Inv. Rebate Unit Rate"; Text[50])
        {
            Caption = 'Off-Inv. Rebate Unit Rate';
            Editable = false;
        }
        field(54001; "OBF-Off Invoice Rebate Amount"; Decimal)
        {
            Caption = 'Off-Invoice Rebate Amount';
            CalcFormula = Sum("OBF-Rebate Entry"."Rebate Amount" WHERE("Source Type" = FIELD("Document Type"),
                                                                         "Source No." = FIELD("Document No."),
                                                                         "Source Line No." = FIELD("Line No."),
                                                                         "Rebate Type" = FILTER("Off-Invoice")));
            Editable = false;
            FieldClass = FlowField;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates 
        field(54002; "OBF-Header Subsidiary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Header Subsidiary Code';
        }

        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                if Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code" then begin
                    SubDimension.RemoveSubDimensionsFromDimSetID(Rec."Dimension Set ID");
                    Rec."OBF-Site Code" := '';
                end;
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                SetCertificationFields();
            end;
        }

    }



    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    trigger OnDelete()
    begin
        DeleteRebateEntries();
    end;

    local procedure DeleteRebateEntries()
    var
        RebateEntry: Record "OBF-Rebate Entry";
    begin
        case "Document Type" of
            "Document Type"::Order:
                RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::Order);
            "Document Type"::Invoice:
                RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::Invoice);
            "Document Type"::"Credit Memo":
                RebateEntry.SetRange("Source Type", RebateEntry."Source Type"::"Credit Memo");
        end;

        RebateEntry.SetRange("Source No.", "Document No.");
        RebateEntry.SetRange("Source Line No.", "Line No.");
        RebateEntry.DeleteAll(true);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
    procedure SetCertificationFields()
    begin
        if Rec.Type <> Rec.Type::Item then
            exit;
        if Rec."No." = '' then
            exit;
        Rec."OBF-MSC Certification" := CheckItemCertification(Rec."No.", 'MSC');
        Rec."OBF-RFM Certification" := CheckItemCertification(Rec."No.", 'RFM');
    end;

    procedure CheckItemCertification(ItemNo: Code[20]; CertificationCode: Code[20]): Boolean
    var
        ItemCertification: Record "OBF-Item Certification";
    begin
        if (ItemNo = '') or (CertificationCode = '') then
            exit(false);
        ItemCertification.SetRange("Item No.", ItemNo);
        ItemCertification.SetRange("Certification Code", CertificationCode);
        exit(not ItemCertification.IsEmpty);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1789 - EDI - Silver Bay
    procedure GetLotNoAndAllocatedQty(var SalesLine: Record "Sales Line");
    var
        ReservEntry: Record "Reservation Entry";
        TrackingSpecific: Record "Tracking Specification";
        LotNo: Text[250];
        IntCount: Integer;
    begin
        SalesLine."OBF-Allocated Quantity" := 0;
        ReservEntry.Reset;
        ReservEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesLine."Document Type");
        if ReservEntry.Find('-') then begin
            repeat
                if ReservEntry."Lot No." <> '' then begin
                    if IntCount = 0 then
                        LotNo := ReservEntry."Lot No."
                    else
                        LotNo := CopyStr(LotNo + ',' + ReservEntry."Lot No.", 1, MaxStrLen(LotNo));
                    IntCount := IntCount + 1;
                end;
                SalesLine."OBF-Allocated Quantity" -= ReservEntry."Qty. to Handle (Base)";
            until ReservEntry.Next = 0;
            SalesLine."OBF-Lot Number" := LotNo;
        end else begin
            TrackingSpecific.SetCurrentKey(
            "Source ID", "Source Type", "Source Subtype",
            "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
            TrackingSpecific.SetRange("Source ID", SalesLine."Document No.");
            TrackingSpecific.SetRange("Source Type", Database::"Sales Line");
            TrackingSpecific.SetRange("Source Subtype", SalesLine."Document Type");
            TrackingSpecific.SetRange("Source Batch Name", '');
            TrackingSpecific.SetRange("Source Prod. Order Line", 0);
            TrackingSpecific.SetRange("Source Ref. No.", SalesLine."Line No.");
            if TrackingSpecific.Find('-') then begin
                repeat
                    if TrackingSpecific."Lot No." <> '' then begin
                        if IntCount = 0 then
                            LotNo := TrackingSpecific."Lot No."
                        else
                            LotNo := LotNo + ',' + TrackingSpecific."Lot No.";
                        IntCount := IntCount + 1;
                        SalesLine."OBF-Allocated Quantity" -= TrackingSpecific."Qty. to Handle (Base)";
                    end;
                until TrackingSpecific.Next = 0;
                SalesLine."OBF-Lot Number" := LotNo;
            end else
                SalesLine."OBF-Lot Number" := '';
        end;
        SalesLine.Modify;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
    procedure GetTrackingPercent(Qty: Decimal; var ItemTracking: Boolean): Decimal;
    var
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        PctInReserv: Decimal;
        Item: Record Item;
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

        if ReservationEntry.Find('-') then begin
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
            until ReservationEntry.Next = 0;
        end;

        TrackingSpecification.SetCurrentKey(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SetRange("Source ID", "Document No.");
        TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
        TrackingSpecification.SetRange("Source Subtype", "Document Type");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        TrackingSpecification.SetRange("Source Ref. No.", "Line No.");

        if TrackingSpecification.Find('-') then begin
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
            until TrackingSpecification.Next = 0;
        end;

        if Qty <> 0 then
            PctInReserv := PctInReserv / Qty * 100;

        exit(PctInReserv);
    end;

}