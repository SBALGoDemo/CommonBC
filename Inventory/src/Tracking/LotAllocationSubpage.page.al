// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2946 - Add Subform to Item Tracking Lines page
// Based on Orca Bay page 50093 "OBF-Lot Allocation Subpage" which had a different SourceTable
page 60307 "Lot Allocation Subpage"
{
    Caption = 'Lot Allocation';
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "Lot No. Information";
    SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SBSINVSelectedQuantity; Rec.SBSINVSelectedQuantity)
                {
                    Caption = 'Selected Quantity';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Style = Unfavorable;
                    trigger OnValidate();
                    begin
                        UpdateSelected();
                    end;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = OnPurchaseOrder;
                    ToolTip = 'Red font indicates that the Lot is on a Purchase Order and has not yet been received.';
                }
                field(SBSINVOnPurchaseOrder; Rec.SBSINVOnPurchaseOrder)
                {
                    Caption = 'On Purchase Order';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = OnPurchaseOrder;
                }
                field(SBSINVTotalQuantity; Rec.SBSINVTotalQuantity)
                {
                    Caption = 'Total Quantity';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }

                field(AvailableQuantity; AvailableQuantity)
                {
                    Caption = 'Available Quantity';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Unfavorable;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", DateFilter);
                    end;
                }
                field(AvailableNetWeight; AvailableNetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Available Weight';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Visible = false;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", DateFilter);
                    end;
                }
                field(OnHandQuantity; Rec.SBSINVOnHandQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'On Hand Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field("On Order Quantity"; Rec.SBSINVOnOrderQuantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. on Sales Order"; Rec.SBSINVQtyOnSalesOrder)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alternate Lot No."; LotNoInformation.SBSINVAlternateLotNo)
                {
                    Caption = 'Alternate Lot No.';
                    Editable = false;
                    ApplicationArea = All;
                }

                field("Label Text"; LotNoInformation.SBSINVLabel)
                {
                    Caption = 'Label Text';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Vessel; LotNoInformation.SBSINVVessel)
                {
                    Caption = 'Vessel';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Container No."; LotNoInformation.SBSINVContainerNo)
                {
                    Caption = 'Container No.';
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Source Number"; Rec.SBSINVSourceNo)
                {
                    Caption = 'Source Number';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Source Number for the Lot.';
                }
                field("Vendor Name"; Rec.SBSINVVendorName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Receipt Date (ILE)"; Rec.SBSINVReceiptDateILE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ExpectedReceiptDate; Rec.SBSINVExpectedReceiptDate)
                {
                    ApplicationArea = All;
                    Caption = 'Expected Receipt Date';
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                    Editable = false;
                }
                field("Production Date"; Rec.SBSINVProductionDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiration Date"; Rec.SBSINVExpirationDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Cost"; Rec.SBSINVUnitCost)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Buyer; Rec.SBSINVBuyerCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(OnOrderWeight; OnOrderWeight)
                {
                    ApplicationArea = All;
                    Caption = 'On Order Weight';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
                    end;
                }
                field(OnSalesOrderWeight; OnSalesOrderWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Weight on Sales Orders';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.CalcFields(SBSINVOnHandQuantity, SBSINVOnOrderQuantity, SBSINVQtyOnSalesOrder, SBSINVOnPurchaseOrder);
        AvailableQuantity := Rec.SBSINVOnHandQuantity + Rec.SBSINVOnOrderQuantity - Rec.SBSINVQtyOnSalesOrder;
        AvailableNetWeight := AvailableQuantity * Rec.SBSINVItemNetWeight;
        OnOrderWeight := Rec.SBSINVOnOrderQuantity * Rec.SBSINVItemNetWeight;
        OnSalesOrderWeight := Rec.SBSINVQtyOnSalesOrder * Rec.SBSINVItemNetWeight;
        OnPurchaseOrder := Rec.SBSINVOnPurchaseOrder;
        if not LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            LotNoInformation.Init();
    end;

    trigger OnOpenPage();
    begin
        DateFilter := CalcDate('1Y', WorkDate);
        Rec.SetRange(SBSINVIsAvailable, true);
        ItemCategoryFilter := Rec.GetFilter(SBSINVItemCategoryCode);
        ItemNoFilter := Rec.GetFilter("Item No.");
    end;

    procedure SetPageDataForItemVariant(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]);
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        Message('In SetPageDataForItemVariant: ItemNo=%1, VariantCode=%2, LocationCode=%3', ItemNo, VariantCode, LocationCode);
        if (ItemNo = '') then
            exit;

        if (ItemNo = gItemNo) and (VariantCode = gVariantCode) and (LocationCode = gLocationCode) then
            exit;

        gItemNo := ItemNo;
        gVariantCode := VariantCode;
        Rec.DeleteAll();

        LotNoInformation.SetRange("Item No.", ItemNo);
        LotNoInformation.SetRange("Variant Code", VariantCode);
        LotNoInformation.SetRange(SBSINVLocationCode, LocationCode);
        if LotNoInformation.FindSet() then
            repeat
                Rec := LotNoInformation;
                Rec.Insert();
            until LotNoInformation.Next() = 0;

    end;

    local procedure RecordExists(NewItemNo: Code[20]; NewVariantCode: Code[10]; NewLotNo: Code[50]) Result: Boolean
    begin
        Rec.SetRange("Item No.", NewItemNo);
        Rec.SetRange("Lot No.", NewLotNo);
        Rec.SetRange("Variant Code", NewVariantCode);
        Result := not Rec.IsEmpty;
        Rec.Reset();
    end;



    procedure UpdateSelected();
    begin
        Rec.SetFilter(SBSINVSelectedQuantity, '<>%1', 0);
        if Rec.FindSet() then
            repeat
                Rec.SBSINVAvailableQuantity := Rec.SBSINVAvailableQuantity - Rec.SBSINVSelectedQuantity;
                Rec.Modify;
            until Rec.Next() = 0;
    end;

    procedure SetSelectedQuantity();
    begin

        if Rec.FindSet then begin
            repeat
                Rec.SBSINVSelectedQuantity := 0;
                Rec.Modify;
            until Rec.Next = 0;
        end;
    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        LotNoInformation: Record "Lot No. Information";
        DateFilter: date;
        ItemCategoryFilter: Text;
        ItemNoFilter: Text;
        AvailableQuantity: Decimal;
        AvailableNetWeight: Decimal;
        OnOrderWeight: Decimal;
        OnSalesOrderWeight: Decimal;
        OnPurchaseOrder: Boolean;
        gItemNo: Code[20];
        gLocationCode: Code[20];
        gVariantCode: Code[10];
}