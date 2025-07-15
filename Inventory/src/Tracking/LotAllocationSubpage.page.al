// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
// Based on Orca Bay page 50093 "OBF-Lot Allocation Subpage" which had a different SourceTable
page 60305 "Lot Allocation Subpage"
{
    Caption = 'Lot Allocation';
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = DistinctItemLot;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Selected Quantity"; Rec."Selected Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Style = Unfavorable;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Attention;
                    StyleExpr = OnPurchaseOrder;
                    ToolTip = 'Red font indicates that the Lot is on a Purchase Order and has not yet been received.';
                }
                field("On Purchase Order"; Rec."On Purchase Order")
                {
                    ApplicationArea = All;
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field("Available Quantity"; Rec."Available Quantity")
                {
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
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", DateFilter);
                    end;
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
                field("PO Number"; Rec."PO Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Receipt Date (ILE)"; Rec."Receipt Date (ILE)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ExpectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expected Receipt Date';
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                    Editable = false;
                }
                field("Production Date"; Rec."Production Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Value Of Inventory On Hand"; Rec."Value Of Inventory On Hand")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Buyer; Rec."Buyer Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(OnHandQuantity; Rec."On Hand Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'On Hand Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field("On Order Quantity"; Rec."On Order Quantity")
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
                        InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(OnSalesOrderWeight; OnSalesOrderWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Weight on Sales Orders';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field("Qty. In Transit"; Rec."Qty. In Transit")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order", "On Purchase Order");
        AvailableQuantity := Rec."On Hand Quantity" + Rec."On Order Quantity" - Rec."Qty. on Sales Order";
        AvailableNetWeight := AvailableQuantity * Rec."Item Net Weight";
        OnOrderWeight := Rec."On Order Quantity" * Rec."Item Net Weight";
        OnSalesOrderWeight := Rec."Qty. on Sales Order" * Rec."Item Net Weight";
        OnPurchaseOrder := Rec."On Purchase Order";
        if not LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            LotNoInformation.Init();
    end;

    trigger OnOpenPage();
    begin
        DateFilter := CalcDate('1Y', WorkDate);
        Rec.SetRange("Is Available", true);
        ItemCategoryFilter := Rec.GetFilter("Item Category Code");
        ItemNoFilter := Rec.GetFilter("Item No.");
    end;

    procedure SetPageDataForItemAndLocation(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]);
    begin
        if (ItemNo = '') or (LocationCode = '') then
            exit;

        if (ItemNo = gItemNo) and (LocationCode = gLocationCode) and (VariantCode = gVariantCode) then
            exit;

        gItemNo := ItemNo;
        gVariantCode := VariantCode;
        gLocationCode := LocationCode;
        Rec.DeleteAll();

    end;

    procedure UpdateSelected();
    begin
        Rec.SetFilter("Selected Quantity", '<>%1', 0);
        if Rec.FindSet() then
            repeat
                Rec."Available Quantity" := Rec."Available Quantity" - Rec."Selected Quantity";
                Rec.Modify;
            until Rec.Next() = 0;
    end;

    procedure SetSelectedQuantity();
    begin

        if Rec.FindSet then begin
            repeat
                Rec."Selected Quantity" := 0;
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