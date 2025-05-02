namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1663 - Create Site Dimension Lookup based on Subsidiary
tableextension 60304 SalesLine extends "Sales Line"
{
    fields
    {

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                this.SBSISSSetCertificationFields();
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                if Rec."Shortcut Dimension 1 Code" <> xRec."Shortcut Dimension 1 Code" then begin
                    SubDimension.RemoveSubDimensionsFromDimSetID(Rec."Dimension Set ID");
                    Rec.SBSISSSiteCode := '';
                end;
            end;
        }
        field(60300; SBSISSSiteCode; Code[20])
        {
            Caption = 'Site Code';
            DataClassification = CustomerContent;
            TableRelation = "OBF-Subsidiary Site"."Site Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"));
            trigger OnValidate()
            var
                SubDimension: Codeunit "OBF-Sub Dimension";
            begin
                SubDimension.UpdateDimSetIDForSubDimension('SITE', SBSISSSiteCode, Rec."Dimension Set ID");
            end;
        }
        field(60301; SBSISSCIPCode; Code[20])
        {
            Caption = 'CIP Code';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not Needed';
            ObsoleteState = Pending;
            TableRelation = "OBF-Subsidiary CIP"."CIP Code" where("Subsidiary Code" = field("Shortcut Dimension 1 Code"), "CIP Code Blocked" = const(false));
            trigger OnValidate()
            begin
                //SubDimension.UpdateDimSetIDForSubDimension('CIP', "OBF-CIP Code", Rec."Dimension Set ID");
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
        field(60302; SBSISSMSCCertification; Boolean)
        {
            Caption = 'MSC Certification';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //Rec.TestField(Type,Rec.Type::Item);
            end;
        }
        field(60303; SBSISSRFMCertification; Boolean)
        {
            Caption = 'RFM Certification';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //Rec.TestField(Type,Rec.Type::Item);
            end;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1630 - Printed Document Layouts
        field(60304; SBSISSIsVanInfoLine; Boolean)
        {
            Caption = 'IsVanInfoLine';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60305; SBSISSIsCertificationInfoLine; Boolean)
        {
            Caption = 'IsCertificationInfoLine';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
        field(60306; SBSISSLineNetWeight; Decimal)
        {
            Caption = 'Line Net Weight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1788 - Sales Workflow
        field(60307; SBSISSAllocatedQuantity; Decimal)
        {
            Caption = 'Allocated Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(60308; SBSISSItemType; Enum "Item Type")
        {
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
            Caption = 'Item Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60309; SBSISSItemTrackingCode; Code[10])
        {
            CalcFormula = lookup(Item."Item Tracking Code" where("No." = field("No.")));
            Caption = 'Item Tracking Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60310; SBSISSLotNumber; Text[250])
        {
            Caption = 'Lot Number(s)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60311; SBSISSShiptoCode; Code[10])
        {
            CalcFormula = lookup("Sales Header"."Ship-to Code" where("No." = field("Document No.")));
            Caption = 'Ship-to Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60312; SBSISSOffInvRebateUnitRate; Text[50])
        {
            Caption = 'Off-Inv. Rebate Unit Rate';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60313; SBSISSOffInvoiceRebateAmount; Decimal)
        {
            CalcFormula = sum("OBF-Rebate Entry"."Rebate Amount" where("Source Type" = field("Document Type"),
                                                                         "Source No." = field("Document No."),
                                                                         "Source Line No." = field("Line No."),
                                                                         "Rebate Type" = filter("Off-Invoice")));
            Caption = 'Off-Invoice Rebate Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1808 - Multi Entity Management Enhancements for Rebates
        field(60314; SBSISSHeaderSubsidiaryCode; Code[20])
        {
            Caption = 'Header Subsidiary Code';
            DataClassification = CustomerContent;
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    trigger OnDelete()
    begin
        this.DeleteRebateEntries();
    end;

    procedure SBSISSCheckItemCertification(ItemNo: Code[20]; CertificationCode: Code[20]): Boolean
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
    procedure SBSISSGetLotNoAndAllocatedQty(var SalesLine: Record "Sales Line")
    var
        ReservEntry: Record "Reservation Entry";
        TrackingSpecific: Record "Tracking Specification";
        IntCount: Integer;
        LotNo: Text[250];
    begin
        IntCount := 0;
        SalesLine.SBSISSAllocatedQuantity := 0;
        ReservEntry.Reset();
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
                SalesLine.SBSISSAllocatedQuantity -= ReservEntry."Qty. to Handle (Base)";
            until ReservEntry.Next() = 0;
            SalesLine.SBSISSLotNumber := LotNo;
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
                            LotNo := CopyStr(LotNo + ',' + TrackingSpecific."Lot No.", 1, MaxStrLen(LotNo));
                        IntCount := IntCount + 1;
                        SalesLine.SBSISSAllocatedQuantity -= TrackingSpecific."Qty. to Handle (Base)";
                    end;
                until TrackingSpecific.Next() = 0;
                SalesLine.SBSISSLotNumber := LotNo;
            end else
                SalesLine.SBSISSLotNumber := '';
        end;
        SalesLine.Modify();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
    procedure SBSISSGetTrackingPercent(Qty: Decimal; var ItemTracking: Boolean): Decimal
    var
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        PctInReserv: Decimal;
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

        if ReservationEntry.Find('-') then
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
            until ReservationEntry.Next() = 0;

        TrackingSpecification.SetCurrentKey(
          "Source ID", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        TrackingSpecification.SetRange("Source ID", "Document No.");
        TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
        TrackingSpecification.SetRange("Source Subtype", "Document Type");
        TrackingSpecification.SetRange("Source Batch Name", '');
        TrackingSpecification.SetRange("Source Prod. Order Line", 0);
        TrackingSpecification.SetRange("Source Ref. No.", "Line No.");

        if TrackingSpecification.Find('-') then
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
            until TrackingSpecification.Next() = 0;

        if Qty <> 0 then
            PctInReserv := PctInReserv / Qty * 100;

        exit(PctInReserv);
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
    procedure SBSISSSetCertificationFields()
    begin
        if Rec.Type <> Rec.Type::Item then
            exit;
        if Rec."No." = '' then
            exit;
        Rec.SBSISSMSCCertification := this.SBSISSCheckItemCertification(Rec."No.", 'MSC');
        Rec.SBSISSRFMCertification := this.SBSISSCheckItemCertification(Rec."No.", 'RFM');
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
}