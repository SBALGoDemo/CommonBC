// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
namespace SilverBay.Inventory.Tracking;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

tableextension 60305 SBSINVLotNoInformation extends "Lot No. Information"
{
    fields
    {
        field(60300; "SBSINVLocationCode"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(60302; "SBSINVOriginalLotNo"; Code[20])
        {
            Caption = 'Original Lot No.';
            Editable = false;
        }
        field(60305; SBSINVAlternateLotNo; Code[20])
        {
            Caption = 'Alternate Lot No.';
        }
        field(60310; SBSINVLabel; Text[50])
        {
            Caption = 'Label';
        }
        field(60315; "SBSINVVendorNo"; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(60320; "SBSINVVendorName"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(60325; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            Editable = false;
        }
        field(60330; "SBSINVContainerNo"; Code[20])
        {
            Caption = 'Container No.';
        }
        field(60340; "SBSINVProductionDate"; Date)
        {
            Caption = 'Production Date';
        }
        field(60345; "SBSINVExpirationDate"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(60350; "SBSINVIsAvailable"; Boolean)
        {
            Caption = 'Is Available';
            Editable = false;
        }

        field(60355; SBSINVOnHandQuantity; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                              "Lot No." = field("Lot No."), "Posting Date" = field("Date Filter")));
            Caption = 'On Hand Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the On Hand Quantity field.';
        }
        field(60360; SBSINVOnOrderQuantity; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                "Lot No." = field("Lot No."),
                                                                                "Source Type" = const(39),
                                                                                "Source Subtype" = const("1"),
                                                                                SBSINVLotIsOnHand2 = const(false)));
            Caption = 'On Order Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(60365; SBSINVQtyOnSalesOrder; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                 "Lot No." = field("Lot No."),
                                                                                 "Source Type" = const(37),
                                                                                 "Source Subtype" = const("1"),
                                                                                 "Source ID" = field(SBSINVSalesOrderFilter)));
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
        field(60405; SBSINVSelectedQuantity; Decimal)
        {
            Caption = 'Selected Quantity';
            trigger OnValidate();
            begin
                if SBSINVSelectedQuantity > SBSINVAvailableQuantity then
                    Error('The Selected Quantity (%1) is greater than the Available Quantity (%2)', SBSINVSelectedQuantity, SBSINVAvailableQuantity);
            end;
        }
        field(60410; SBSINVAvailableQuantity; Decimal)
        {
            Caption = 'Available Quantity'; //Note - This field is a placeholder for use on the Item Tracking Page; it must be calculated when needed
            Editable = false;
        }
        field(60415; SBSINVOnPurchaseOrder; Boolean)
        {
            Caption = 'On Purchase Order';
            FieldClass = FlowField;
            CalcFormula = exist("Reservation Entry" Where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                     "Lot No." = field("Lot No."),
                                                     "Source Type" = const(39),
                                                     "Source Subtype" = const("1")));
            Editable = false;
        }
        field(60420; SBSINVTotalQuantity; Decimal)
        {
            Caption = 'Total Quantity'; //Note - This field is a placeholder for use on the Item Tracking Page; it must be calculated when needed
            Editable = false;
        }
        field(60425; SBSINVReceiptDateILE; Date)
        {
            Caption = 'Receipt Date (ILE)';
        }
        field(60430; SBSINVItemCategoryCode; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(60435; SBSINVItemNetWeight; Decimal)
        {
            Caption = 'Item Net Weight';
            DataClassification = CustomerContent;
        }
        field(60440; SBSINVSalesOrderFilter; code[250])
        {
            Caption = 'Sales Order Filter';
            FieldClass = FlowFilter;
        }
        field(60445; SBSINVPurchaseOrderNo; Code[20])
        {
            Caption = 'PO Number';
            DataClassification = CustomerContent;
        }
        field(60450; SBSINVExpectedReceiptDate; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = CustomerContent;
        }
        field(60455; SBSINVBuyerCode; Code[20])
        {
            Caption = 'Buyer';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(60460; SBSINVUnitCost; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
    }

    procedure CreateLotNoInformation(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50])
    begin
        if not Rec.Get(ItemNo, VariantCode, LotNo) then begin
            Rec.Init();
            Rec.Validate("Item No.", ItemNo);
            Rec.Validate("Variant Code", VariantCode);
            Rec.Validate("Lot No.", LotNo);
            Rec.Insert(true);
        end;
    end;

    procedure UpdateLotNoInfoForPurchaseLine(PurchaseLine: Record "Purchase Line")
    var
        LotNoInformation: Record "Lot No. Information";
        Vendor: Record Vendor;
    begin
        if PurchaseLine.SBSINVLotNo = '' then
            exit;
        if PurchaseLine.Type <> PurchaseLine.Type::Item then
            exit;
        if PurchaseLine."No." = '' then
            exit;
        if not LotNoInformation.Get(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine.SBSINVLotNo) then begin
            LotNoInformation.CreateLotNoInformation(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine.SBSINVLotNo);
            LotNoInformation.Description := '';
            LotNoInformation.SBSINVVendorNo := PurchaseLine."Buy-from Vendor No.";
            if Vendor.Get(PurchaseLine."Buy-from Vendor No.") then
                LotNoInformation.SBSINVVendorName := Vendor.Name
            else
                LotNoInformation.SBSINVVendorName := '';
            LotNoInformation.Modify();
        end;
        if not CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine, LotNoInformation) then
            exit;
        LotNoInformation.SBSINVLocationCode := PurchaseLine."Location Code";
        LotNoInformation.SBSINVAlternateLotNo := PurchaseLine.SBSINVAlternateLotNo;
        LotNoInformation.SBSINVLabel := PurchaseLine.SBSINVLabel;
        LotNoInformation.SBSINVExpirationDate := PurchaseLine.SBSINVExpirationDate;
        LotNoInformation.SBSINVProductionDate := PurchaseLine.SBSINVProductionDate;
        LotNoInformation.SBSINVContainerNo := PurchaseLine.SBSINVContainerNo;
        LotNoInformation.SBSINVVessel := PurchaseLine.SBSINVVessel;
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;

    procedure UpdateLotNoInfoForItemLedgerEntry(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        LotNoInformation: Record "Lot No. Information";
        Vendor: Record Vendor;
    begin
        if ItemLedgerEntry."Lot No." = '' then
            exit;
        if ItemLedgerEntry."Item No." = '' then
            exit;
        if not LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            LotNoInformation.CreateLotNoInformation(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.");
            LotNoInformation.Description := '';
            LotNoInformation.SBSINVVendorNo := '';
            LotNoInformation.SBSINVVendorName := '';
            if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Purchase" then begin
                LotNoInformation.SBSINVVendorNo := ItemLedgerEntry."Source No.";
                if Vendor.Get(LotNoInformation.SBSINVVendorNo) then
                    LotNoInformation.SBSINVVendorName := Vendor.Name;
            end;
            LotNoInformation.Modify();
        end;
        LotNoInformation.SBSINVLocationCode := ItemLedgerEntry."Location Code";
        LotNoInformation.SBSINVAlternateLotNo := ItemLedgerEntry.SBSINVAlternateLotNo;
        LotNoInformation.SBSINVLabel := ItemLedgerEntry.SBSINVLabel;
        LotNoInformation.SBSINVExpirationDate := ItemLedgerEntry."Expiration Date";
        LotNoInformation.SBSINVProductionDate := ItemLedgerEntry.SBSINVProductionDate;
        LotNoInformation.SBSINVContainerNo := ItemLedgerEntry.SBSINVContainerNo;
        LotNoInformation.SBSINVVessel := ItemLedgerEntry.SBSINVVessel;
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;

    local procedure CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine: Record "Purchase Line"; LotNoInformation: Record "Lot No. Information"): Boolean
    begin
        if (PurchaseLine."Location Code" = LotNoInformation.SBSINVLocationCode) and
           (PurchaseLine.SBSINVAlternateLotNo = LotNoInformation.SBSINVAlternateLotNo) and
           (PurchaseLine.SBSINVLabel = LotNoInformation.SBSINVLabel) and
           (PurchaseLine.SBSINVExpirationDate = LotNoInformation.SBSINVExpirationDate) and
           (PurchaseLine.SBSINVProductionDate = LotNoInformation.SBSINVProductionDate) and
           (PurchaseLine.SBSINVContainerNo = LotNoInformation.SBSINVContainerNo) and
           (PurchaseLine.SBSINVVessel = LotNoInformation.SBSINVVessel) then
            exit(false)
        else
            exit(true);
    end;

    procedure DeleteLotNoInfoForPurchaseLine(PurchaseLine: Record "Purchase Line"; LotNo: Code[20])
    begin
        if LotNo = '' then
            exit;
        if PurchaseLine.Type <> PurchaseLine.Type::Item then
            exit;
        if PurchaseLine."No." = '' then
            exit;
        if Rec.Get(PurchaseLine."No.", PurchaseLine."Variant Code", LotNo) then
            Rec.Delete();
    end;
}