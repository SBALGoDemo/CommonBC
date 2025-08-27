namespace SilverBay.Inventory.Tracking;

using Microsoft.CRM.Team;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
/// </summary>
tableextension 60305 SBSINVLotNoInformation extends "Lot No. Information"
{
    fields
    {
        field(60301; SBSINVLocationCode; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
            ToolTip = 'Specifies the location code the lot is associated with.';
        }
        field(60302; SBSINVOriginalLotNo; Code[50])
        {
            Caption = 'Original Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the original lot number of the lot number information.';
        }
        field(60303; SBSINVAlternateLotNo; Code[50])
        {
            Caption = 'Alternate Lot No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the alternate lot number of the lot number information.';
        }
        field(60304; SBSINVLotText; Text[50])
        {
            Caption = 'Lot Text';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the lot text value of the lot number information.';
        }
        field(60305; SBSINVVendorNo; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            ToolTip = 'Specifies the vendor number involved with the record.';

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                Vendor.Get(SBSINVVendorNo);
                SBSINVVendorName := Vendor.Name;
            end;
        }
        field(60306; SBSINVVendorName; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the vendor''s name.';
        }
        field(60310; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the vessel of the lot number information.';
        }
        field(60311; SBSINVContainerNo; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the container number of the lot number information.';
        }
        field(60312; SBSINVProductionDate; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the production date of the lot number information.';
        }
        field(60313; SBSINVExpirationDate; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the last date that the item on the line can be used.';
        }
        field(60314; SBSINVIsAvailable; Boolean)
        {
            Caption = 'Is Available';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies if the item on the line is available.';
        }
        field(60315; SBSINVOnHandQuantity; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                              "Lot No." = field("Lot No."), "Posting Date" = field("Date Filter")));
            Caption = 'On Hand Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the value of the On Hand Quantity field.';
        }
        field(60316; SBSINVOnOrderQuantity; Decimal)
        {
            //TODO: Is this duplicated below via field(60320; SBSINVOnPurchaseOrder; Boolean)?
            CalcFormula = sum("Reservation Entry"."Qty. to Handle (Base)" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                                                "Lot No." = field("Lot No."),
                                                                                "Source Type" = const(39),
                                                                                "Source Subtype" = const("1"),
                                                                                SBSINVLotIsOnHand2 = const(false)));
            Caption = 'On Order Quantity';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the quantity of the lot that is on order.';
        }
        field(60317; SBSINVQtyOnSalesOrder; Decimal)
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
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
        /// </summary>
        field(60318; SBSINVSelectedQuantity; Decimal)
        {
            Caption = 'Selected Quantity';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the quantity currently selected by the user.';

            trigger OnValidate()
            var
                AvailableQuantity: Decimal;
            begin
                SelectLatestVersion();
                Rec.CalcFields(SBSINVOnHandQuantity, SBSINVOnOrderQuantity, SBSINVQtyOnSalesOrder);
                AvailableQuantity := Rec.SBSINVOnHandQuantity + Rec.SBSINVOnOrderQuantity - Rec.SBSINVQtyOnSalesOrder;
                if SBSINVSelectedQuantity > AvailableQuantity then
                    Error('The Selected Quantity (%1) is greater than the Available Quantity (%2)', SBSINVSelectedQuantity, AvailableQuantity);
            end;
        }
        field(60319; SBSINVAvailableQuantity; Decimal)
        {
            Caption = 'Available Quantity'; //Note - This field is a placeholder for use on the Item Tracking Page; it must be calculated when needed
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the available quantity of the lot.';
        }
        field(60320; SBSINVOnPurchaseOrder; Boolean)
        {
            CalcFormula = exist("Reservation Entry" where("Item No." = field("Item No."), "Variant Code" = field("Variant Code"),
                                                     "Lot No." = field("Lot No."),
                                                     "Source Type" = const(39),
                                                     "Source Subtype" = const("1")));
            Caption = 'On Purchase Order';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the quantity of the lot on purchase order lines.';
        }
        field(60321; SBSINVTotalQuantity; Decimal)
        {
            Caption = 'Total Quantity'; //Note - This field is a placeholder for use on the Item Tracking Page; it must be calculated when needed
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the total available quantity of this lot.';
        }
        field(60322; SBSINVReceiptDateILE; Date)
        {
            Caption = 'Receipt Date (ILE)';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date the lot was received into inventory.';
        }
        field(60323; SBSINVItemCategoryCode; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
            ToolTip = 'Specifies the category that the item belongs to.';
        }
        field(60324; SBSINVItemNetWeight; Decimal)
        {
            Caption = 'Item Net Weight';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Net Weight of the item.';

        }
        field(60325; SBSINVSalesOrderFilter; Code[250])
        {
            Caption = 'Sales Order Filter';
            FieldClass = FlowFilter;
        }
        field(60326; SBSINVSourceNo; Code[20])
        {
            Caption = 'Source Number';
            DataClassification = CustomerContent;
        }
        field(60327; SBSINVExpectedReceiptDate; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date that you expect the lot to be available in your warehouse.';
        }
        field(60328; SBSINVBuyerCode; Code[20])
        {
            Caption = 'Buyer';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the buyer''s code of the record.';
        }
        field(60329; SBSINVUnitCost; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the cost of one unit of the Lot.';
        }
        field(60330; SBSINVGrade; Code[20])
        {
            Caption = 'Grade';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Grade of the Lot.';
        }
        field(60331; SBSINVFacilityNumber; Code[20])
        {
            Caption = 'Facility Number';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Facility Number where the Lot originated.';
        }
        field(60332; SBSINVSpecialHandling; Text[50])
        {
            Caption = 'Special Handling';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the special handling instructions for the lot.';
        }
        field(60333; SBSINVCustomerGrades; Text[50])
        {
            Caption = 'Customer Grades';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the customer grades for the lot.';
        }
    }

    /// <summary>
    /// Creates a new Lot No. Information record if it does not already exist.
    /// </summary>
    /// <param name="SourceNo">The Document No. associated with the record</param>
    /// <param name="ItemNo">The Item No. associated with the record</param>
    /// <param name="VariantCode">The Variant Code associated with the record</param>
    /// <param name="LotNo">The Lot No. associated with the record</param>
    internal procedure SBSINVCreateLotNoInformation(SourceNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50])
    begin
        if not Rec.Get(ItemNo, VariantCode, LotNo) then begin
            Rec.Init();
            Rec.Validate("Item No.", ItemNo);
            Rec.Validate("Variant Code", VariantCode);
            Rec.Validate("Lot No.", LotNo);
            Rec.SBSINVSourceNo := SourceNo;
            Rec.Insert(true);
        end;
    end;

    /// <summary>
    /// Deletes a Lot No. Information record associated with a given Purchase Line and Lot No., if it exists.
    /// </summary>
    /// <param name="PurchaseLine">A purchase line record containing the key values for a lot number information record you need to delete</param>
    /// <param name="LotNo">The specific Lot No. value for which you need to delete the related lot number information record</param>
    internal procedure SBSINVDeleteLotNoInfoForPurchaseLine(PurchaseLine: Record "Purchase Line"; LotNo: Code[50])
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if this.SkipRecord(PurchaseLine, LotNo) then
            exit
        else
            if LotNoInformation.Get(PurchaseLine."No.", PurchaseLine."Variant Code", LotNo) then
                LotNoInformation.Delete(true);
    end;

    /// <summary>
    /// Sets custom fields on a Lot No. Information record based on values from an Item Ledger Entry record.
    /// If the Lot No. Information record does not exist, it will be created.
    /// </summary>
    /// <param name="ItemLedgerEntry">An item ledger entry record containing the value(s) to transfer to a lot number information record</param>
    internal procedure SBSINVSetCustomFieldsFromItemLedgerEntry(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if ItemLedgerEntry."Lot No." = '' then
            exit;
        if ItemLedgerEntry."Item No." = '' then
            exit;

        if not LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            LotNoInformation.SBSINVCreateLotNoInformation(ItemLedgerEntry."Source No.", ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.");

            if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase then
                LotNoInformation.Validate(SBSINVVendorNo, ItemLedgerEntry."Source No.");
        end;

        this.SBSINVSetAdditionalCustomFields(ItemLedgerEntry, LotNoInformation);
    end;

    /// <summary>
    /// Sets custom fields on a Lot No. Information record based on values from a Purchase Line record.
    /// If the Lot No. Information record does not exist, it will be created.
    /// </summary>
    /// <param name="PurchaseLine">A Purchase Line record containing the value(s) to transfer to a lot number information record</param>
    internal procedure SBSINVSetCustomFieldsFromPurchaseLine(PurchaseLine: Record "Purchase Line")
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if this.SkipRecord(PurchaseLine, PurchaseLine.SBSINVLotNo) then
            exit;

        if not LotNoInformation.Get(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine.SBSINVLotNo) then begin
            LotNoInformation.SBSINVCreateLotNoInformation(PurchaseLine."Document No.", PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine.SBSINVLotNo);
            LotNoInformation.Validate(SBSINVVendorNo, PurchaseLine."Buy-from Vendor No.");
            LotNoInformation.Modify();
        end;

        if not this.CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine, LotNoInformation) then
            exit;

        this.SBSINVSetAdditionalCustomFields(PurchaseLine, LotNoInformation);
    end;

    /// <summary>
    /// Determines if a Purchase Line record should be skipped when processing for Lot No. Information updates.
    /// </summary>
    /// <param name="PurchaseLine">The purchase line record being assessed</param>
    /// <param name="LotNo">The lot number value being assessed</param>
    /// <returns></returns>
    local procedure SkipRecord(PurchaseLine: Record "Purchase Line"; LotNo: Code[50]): Boolean
    begin
        case true of
            (LotNo = ''):
                exit(true);
            PurchaseLine.Type <> PurchaseLine.Type::Item:
                exit(true);
            (PurchaseLine."No." = ''):
                exit(true);
        end;
    end;

    /// <summary>
    /// Determines if any of the custom fields on a Purchase Line record have changed compared to the corresponding fields on a Lot No. Information record.
    /// </summary>
    /// <param name="PurchaseLine">The purchase line record being compared</param>
    /// <param name="LotNoInformation">The lot number information record being compared</param>
    /// <returns></returns>
    local procedure CheckIfPurchaseLineCustomFieldsChanged(PurchaseLine: Record "Purchase Line"; LotNoInformation: Record "Lot No. Information"): Boolean
    begin
        case true of
            (PurchaseLine."Location Code" <> LotNoInformation.SBSINVLocationCode):
                exit(true);
            (PurchaseLine.SBSINVAlternateLotNo <> LotNoInformation.SBSINVAlternateLotNo):
                exit(true);
            (PurchaseLine.SBSINVLotText <> LotNoInformation.SBSINVLotText):
                exit(true);
            (PurchaseLine.SBSINVExpirationDate <> LotNoInformation.SBSINVExpirationDate):
                exit(true);
            (PurchaseLine.SBSINVProductionDate <> LotNoInformation.SBSINVProductionDate):
                exit(true);
            (PurchaseLine.SBSINVContainerNo <> LotNoInformation.SBSINVContainerNo):
                exit(true);
            (PurchaseLine.SBSINVVessel <> LotNoInformation.SBSINVVessel):
                exit(true);
        end;
    end;

    /// <summary>
    /// Sets additional custom fields on a Lot No. Information record based on values from an Item Ledger Entry record.
    /// </summary>
    /// <param name="ItemLedgerEntry"></param>
    /// <param name="LotNoInformation"></param>
    local procedure SBSINVSetAdditionalCustomFields(ItemLedgerEntry: Record "Item Ledger Entry"; var LotNoInformation: Record "Lot No. Information")
    begin
        this.SBSINVDoSetAdditionalCustomFields(LotNoInformation, ItemLedgerEntry."Location Code", ItemLedgerEntry.SBSINVAlternateLotNo, ItemLedgerEntry.SBSINVLotText, ItemLedgerEntry."Expiration Date", ItemLedgerEntry.SBSINVProductionDate, ItemLedgerEntry.SBSINVContainerNo, ItemLedgerEntry.SBSINVVessel);
    end;

    /// <summary>
    /// Sets additional custom fields on a Lot No. Information record based on values from a Purchase Line record.
    /// </summary>
    /// <param name="PurchaseLine"></param>
    /// <param name="LotNoInformation"></param>
    local procedure SBSINVSetAdditionalCustomFields(PurchaseLine: Record "Purchase Line"; var LotNoInformation: Record "Lot No. Information")
    begin
        this.SBSINVDoSetAdditionalCustomFields(LotNoInformation, PurchaseLine."Location Code", PurchaseLine.SBSINVAlternateLotNo, PurchaseLine.SBSINVLotText, PurchaseLine.SBSINVExpirationDate, PurchaseLine.SBSINVProductionDate, PurchaseLine.SBSINVContainerNo, PurchaseLine.SBSINVVessel);
    end;

    /// <summary>
    /// Sets additional custom fields on a Lot No. Information record based on provided values.
    /// </summary>
    /// <param name="LotNoInformation"></param>
    /// <param name="LocationCode"></param>
    /// <param name="AlternateLotNo"></param>
    /// <param name="Label"></param>
    /// <param name="ExpirationDate"></param>
    /// <param name="ProductionDate"></param>
    /// <param name="ContainerNo"></param>
    /// <param name="Vessel"></param>
    local procedure SBSINVDoSetAdditionalCustomFields(var LotNoInformation: Record "Lot No. Information"; LocationCode: Code[20]; AlternateLotNo: Code[50]; Label: Text[50]; ExpirationDate: Date; ProductionDate: Date; ContainerNo: Code[20]; Vessel: Text[50])
    begin
        LotNoInformation.SBSINVLocationCode := LocationCode;
        LotNoInformation.SBSINVAlternateLotNo := AlternateLotNo;
        LotNoInformation.SBSINVLotText := Label;
        LotNoInformation.SBSINVExpirationDate := ExpirationDate;
        LotNoInformation.SBSINVProductionDate := ProductionDate;
        LotNoInformation.SBSINVContainerNo := ContainerNo;
        LotNoInformation.SBSINVVessel := Vessel;
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;
}