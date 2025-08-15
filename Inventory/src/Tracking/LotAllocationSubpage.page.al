namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;
using SilverBay.Inventory.System;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2946 - Add Subform to Item Tracking Lines page
/// Based on Orca Bay page 50093 "OBF-Lot Allocation Subpage" which had a different SourceTable
/// TODO: Review and refactor code in the page when possible. Significant amounts of the code can likely be simplified and made more intuitive by migrating it to procedures in codeunits. /// 
/// </summary>
page 60307 "Lot Allocation Subpage"
{
    ApplicationArea = All;
    Caption = 'Lot Allocation';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Lot No. Information";
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field(SBSINVSelectedQuantity; Rec.SBSINVSelectedQuantity)
                {
                    Caption = 'Selected Quantity';
                    DecimalPlaces = 0 : 5;
                    Style = Unfavorable;
                    ToolTip = 'Specifies the value of the Selected Quantity field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                    Editable = false;
                    Style = Attention;
                    StyleExpr = OnPurchaseOrder;
                    ToolTip = 'Red font indicates that the Lot is on a Purchase Order and has not yet been received.';
                }
                field(SBSINVOnPurchaseOrder; Rec.SBSINVOnPurchaseOrder)
                {
                    Caption = 'On Purchase Order';
                    Editable = false;
                    StyleExpr = OnPurchaseOrder;
                    ToolTip = 'Specifies the value of the On Purchase Order field.';
                }
                field(SBSINVTotalQuantity; Rec.SBSINVTotalQuantity)
                {
                    Caption = 'Total Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Quantity on Hand + Qty. on Purchase Order.';
                }
                field(AvailableQuantity; Rec.SBSINVAvailableQuantity)
                {
                    Caption = 'Available Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Unfavorable;
                    ToolTip = 'Specifies the value of the Quantity on Hand + Qty. on Purchase Order - Qty. on Sales Orders.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field(AvailableNetWeight; this.AvailableNetWeight)
                {
                    Caption = 'Available Weight';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Available Weight field.';
                    Visible = false;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field(OnHandQuantity; Rec.SBSINVOnHandQuantity)
                {
                    Caption = 'On Hand Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Hand Quantity field.';
                }
                field("On Order Quantity"; Rec.SBSINVOnOrderQuantity)
                {
                    Caption = 'On Order Quantity';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Quantity field.';
                }
                field("Qty. on Sales Order"; Rec.SBSINVQtyOnSalesOrder)
                {
                    Caption = 'Qty. on Sales Orders';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
                }
                field("Alternate Lot No."; this.LotNoInformation.SBSINVAlternateLotNo)
                {
                    Caption = 'Alternate Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Alternate Lot No. field.';
                }
                field("Lot Text"; this.LotNoInformation.SBSINVLotText)
                {
                    Caption = 'Lot Text';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lot Text field.';
                }
                field(Vessel; this.LotNoInformation.SBSINVVessel)
                {
                    Caption = 'Vessel';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vessel field.';
                }
                field("Container No."; this.LotNoInformation.SBSINVContainerNo)
                {
                    Caption = 'Container No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Container No. field.';
                }
                field("Source Number"; Rec.SBSINVSourceNo)
                {
                    Caption = 'Source Number';
                    Editable = false;
                    ToolTip = 'Specifies the Source Number for the Lot.';
                }
                field("Vendor Name"; Rec.SBSINVVendorName)
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Receipt Date (ILE)"; Rec.SBSINVReceiptDateILE)
                {
                    Caption = 'Receipt Date (ILE)';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receipt Date (ILE) field.';
                }
                field(ExpectedReceiptDate; Rec.SBSINVExpectedReceiptDate)
                {
                    Caption = 'Expected Receipt Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                }
                field("Production Date"; Rec.SBSINVProductionDate)
                {
                    Caption = 'Production Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Production Date field.';
                }
                field("Expiration Date"; Rec.SBSINVExpirationDate)
                {
                    Caption = 'Expiration Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field("Unit Cost"; Rec.SBSINVUnitCost)
                {
                    Caption = 'Unit Cost';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Buyer; Rec.SBSINVBuyerCode)
                {
                    Caption = 'Buyer';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Buyer field.';
                }
                field(OnOrderWeight; this.OnOrderWeight)
                {
                    Caption = 'On Order Weight';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
                    end;
                }
                field(OnSalesOrderWeight; this.OnSalesOrderWeight)
                {
                    Caption = 'Weight on Sales Orders';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Weight on Sales Orders field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(SBSINVOnHandQuantity, SBSINVOnOrderQuantity, SBSINVQtyOnSalesOrder, SBSINVOnPurchaseOrder);
        this.AvailableNetWeight := Rec.SBSINVAvailableQuantity * Rec.SBSINVItemNetWeight;
        this.OnOrderWeight := Rec.SBSINVOnOrderQuantity * Rec.SBSINVItemNetWeight;
        this.OnSalesOrderWeight := Rec.SBSINVQtyOnSalesOrder * Rec.SBSINVItemNetWeight;
        this.OnPurchaseOrder := Rec.SBSINVOnPurchaseOrder;
        if not this.LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            this.LotNoInformation.Init();
    end;

    trigger OnOpenPage()
    begin
        this.DateFilter := CalcDate('<1Y>', WorkDate());
        Rec.SetRange(SBSINVIsAvailable, true);
        this.ItemCategoryFilter := Rec.GetFilter(SBSINVItemCategoryCode);
        this.ItemNoFilter := Rec.GetFilter("Item No.");
    end;

    var
        LotNoInformation: Record "Lot No. Information";
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        OnPurchaseOrder: Boolean;
        VariantCode: Code[10];
        ItemNo: Code[20];
        LocationCode: Code[20];
        DateFilter: Date;
        AvailableNetWeight: Decimal;
        OnOrderWeight: Decimal;
        OnSalesOrderWeight: Decimal;
        ItemCategoryFilter: Text;
        ItemNoFilter: Text;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2973 - Add "Open Tracking" link to Sales Order Subform
    /// </summary>
    /// <param name="TempLotNoInformation"></param>
    internal procedure GetSelected(var TempLotNoInformation: Record "Lot No. Information" temporary)
    begin
        TempLotNoInformation.Reset();
        TempLotNoInformation.DeleteAll();
        Rec.SetFilter(SBSINVSelectedQuantity, '<>%1', 0);
        if Rec.FindSet() then
            repeat
                TempLotNoInformation := Rec;
                TempLotNoInformation.Insert();
            until Rec.Next() = 0;
        Rec.SetRange(SBSINVSelectedQuantity);
    end;

    procedure SetPageDataForItemVariantAndLocation(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLocationCode: Code[10])
    var
        LotNoInformation2: Record "Lot No. Information";
    begin
        if (NewItemNo = '') or (NewLocationCode = '') then
            exit;

        if (NewItemNo = this.ItemNo) and (NewVariantCode = this.VariantCode) and (NewLocationCode = this.LocationCode) then
            exit;

        this.ItemNo := NewItemNo;
        this.VariantCode := NewVariantCode;
        this.LocationCode := NewLocationCode;

        Rec.DeleteAll();

        LotNoInformation2.SetRange("Item No.", NewItemNo);
        LotNoInformation2.SetRange("Variant Code", NewVariantCode);
        LotNoInformation2.SetRange(SBSINVLocationCode, NewLocationCode);
        if LotNoInformation2.FindSet() then
            repeat
                if not this.LotExists(LotNoInformation2."Lot No.") then begin
                    Rec := LotNoInformation2;
                    Rec.CalcFields(SBSINVOnHandQuantity, SBSINVOnOrderQuantity, SBSINVQtyOnSalesOrder);
                    Rec.SBSINVAvailableQuantity := Rec.SBSINVOnHandQuantity + Rec.SBSINVOnOrderQuantity - Rec.SBSINVQtyOnSalesOrder;
                    Rec.Insert();
                end;
            until LotNoInformation2.Next() = 0;
    end;

    procedure SetSelectedQuantity()
    begin
        if Rec.FindSet() then
            repeat
                Rec.SBSINVSelectedQuantity := 0;
                Rec.Modify();
            until Rec.Next() = 0;
    end;

    procedure UpdateSelected()
    begin
        Rec.SetFilter(SBSINVSelectedQuantity, '<>%1', 0);
        if Rec.FindSet() then
            repeat
                Rec.SBSINVAvailableQuantity := Rec.SBSINVAvailableQuantity - Rec.SBSINVSelectedQuantity;
                Rec.Modify();
            until Rec.Next() = 0;
        Rec.SetRange(SBSINVSelectedQuantity);
    end;

    local procedure LotExists(LotNo: Code[50]) Result: Boolean
    begin
        Rec.SetRange("Lot No.", LotNo);
        Result := not Rec.IsEmpty;
        Rec.SetRange("Lot No.");
    end;
}