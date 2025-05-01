namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

page 60303 "OBF-Item Factbox"
{
    ApplicationArea = All;
    Caption = 'Item Details - Summary';
    PageType = CardPart;
    SourceTable = Item;
    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                Caption = 'Parameters';
                field("No."; Rec."No.")
                {
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(VariantCode; VariantCode)
                {
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the item.';
                }
                field(AsOfDate; Format(AsOfDate))
                {
                    Caption = 'As Of Date';
                    ToolTip = 'Specifies the value of the As Of Date field.';
                }
            }
            group(OnHand)
            {
                Caption = 'On Hand';

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
                field(Inventory; TotalQty)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.OnHandDrilldown(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
                    end;
                }

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Qty on Quality Hold"; QtyOnQualityHold)
                // {
                //     Caption = 'Quality Hold';
                //     DecimalPlaces = 0 : 3;
                //     ApplicationArea = All;
                // }

                field(TotalOnHandWeight; TotalOnHandWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.OnHandDrilldown(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
                    end;
                }
                field(TotalValueOfInventoryOnHand; TotalValueOfInventoryOnHand)
                {
                    Caption = 'Total Value';
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Specifies the value of the Total Value field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.OnHandDrilldown(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
                    end;
                }
                field(AverageCost; AverageCost)
                {
                    Caption = 'Average Cost per Pound';
                    ToolTip = 'Specifies the value of the Average Cost per Pound field.';
                }
            }
            group(OnHandCommittedGroup)
            {
                Caption = 'On Hand (Committed)';
                field(OnHandCommitted; OnHandCommitted)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.CommittedDrilldown(Rec."No.", VariantCode, ShowAllVariants, true);
                    end;
                }
                field(OnHandCommittedWeight; OnHandCommittedWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.CommittedDrilldown(Rec."No.", VariantCode, ShowAllVariants, true);
                    end;
                }
            }
            group(OnHandAvailableGroup)
            {
                Caption = 'On Hand (Available)';
                field(OnHandAvailable; OnHandAvailable)
                {
                    Caption = 'On-Hand Available';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On-Hand Available field.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLots: Page "OBF-Distinct Item Lots";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if ShowAllVariants then
                            DistinctItemLots.SetItem(Rec."No.", '', AsOfDate)
                        else
                            DistinctItemLots.SetItem(Rec."No.", VariantCode, AsOfDate);
                        DistinctItemLots.SetOnHandQtyFilter();
                        DistinctItemLots.RunModal();
                    end;
                }
                field(OnHandAvailableWeight; OnHandAvailableWeight)
                {
                    Caption = 'On-Hand Available (Weight)';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On-Hand Available (Weight) field.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLots: Page "OBF-Distinct Item Lots";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if ShowAllVariants then
                            DistinctItemLots.SetItem(Rec."No.", '', AsOfDate)
                        else
                            DistinctItemLots.SetItem(Rec."No.", VariantCode, AsOfDate);
                        DistinctItemLots.SetOnHandQtyFilter();
                        DistinctItemLots.RunModal();
                    end;
                }
            }
            group(OnOrder)
            {
                Caption = 'On Order';
                field(OnOrderQty; OnOrderQty)
                {
                    CaptionML = ENU = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the OnOrderQty field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.OnOrderDrilldown(Rec."No.", VariantCode, ShowAllVariants);
                    end;
                }
                field(OnOrderWeight; OnOrderWeight)
                {
                    CaptionML = ENU = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the OnOrderWeight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.OnOrderDrilldown(Rec."No.", VariantCode, ShowAllVariants);
                    end;
                }
            }
            group(OnOrderCommittedGroup)
            {
                Caption = 'On Order Committed';
                field(OnOrderCommitted; OnOrderCommitted)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.CommittedDrilldown(Rec."No.", VariantCode, ShowAllVariants, false);
                    end;
                }
                field(OnOrderCommittedWeight; OnOrderCommittedWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.CommittedDrilldown(Rec."No.", VariantCode, ShowAllVariants, false);
                    end;
                }
            }
            group(UnallocatedSO)
            {
                Caption = 'Unallocated Sales Orders';
                field(UnallocatedSOQty; UnallocatedSOQty)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.UnallocatedSODrilldown(Rec."No.", VariantCode, ShowAllVariants);
                    end;
                }
                field(UnallocatedSOWeight; UnallocatedSOWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.UnallocatedSODrilldown(Rec."No.", VariantCode, ShowAllVariants);
                    end;
                }
            }
            group(Available)
            {
                Caption = 'Available ';
                field(TotalAvailableQuantity; TotalAvailableQuantity)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTipML = ENU = '=On Hand + On Order - On Hand Committed - On Order Committed';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
                    end;
                }
                field(TotalAvailableWeight; TotalAvailableWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if AsOfDate <> 0D then
            Rec.SetFilter("Date Filter", '<=%1', AsOfDate);
        // SetFilter("Inventory As Of Date Filter",'<=%1',AsOfDate);

        if not ShowAllVariants then
            Rec.SetRange("Variant Filter", VariantCode);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
        Rec.CalcFields(Inventory, "Qty. on Purch. Order");
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // Rec.CalcFields("OBF-Qty on Quality Hold");
        TotalQty := Rec.Inventory - Rec.SBSISSQtyonQualityHold;
        QtyOnQualityHold := Rec.SBSISSQtyonQualityHold;
        TotalOnHandWeight := (Rec.Inventory - Rec.SBSISSQtyonQualityHold) * Rec."Net Weight";

        OnOrderQty := Rec."Qty. on Purch. Order";
        OnOrderWeight := OnOrderQty * Rec."Net Weight";
        OnOrderCommitted := InfoPaneMgmt.CalcOnOrderCommitted(Rec."No.", VariantCode, ShowAllVariants);
        OnOrderCommittedWeight := OnOrderCommitted * Rec."Net Weight";
        OnHandCommitted := InfoPaneMgmt.CalcOnHandCommitted(Rec."No.", VariantCode, ShowAllVariants);
        OnHandCommittedWeight := OnHandCommitted * Rec."Net Weight";
        OnHandAvailable := Rec.Inventory - OnHandCommitted - Rec.SBSISSQtyonQualityHold;
        OnHandAvailableWeight := TotalOnHandWeight - OnHandCommittedWeight;
        UnallocatedSOQty := InfoPaneMgmt.CalcUnallocatedSO(Rec."No.", VariantCode, ShowAllVariants);
        UnallocatedSOWeight := UnallocatedSOQty * Rec."Net Weight";
        TotalAvailableQuantity := Rec.Inventory + OnOrderQty - OnHandCommitted - OnOrderCommitted - Rec.SBSISSQtyonQualityHold;
        TotalAvailableWeight := TotalOnHandWeight + OnOrderWeight - OnHandCommittedWeight - OnOrderCommittedWeight;
        TotalValueOfInventoryOnHand := InfoPaneMgmt.CalcInventoryValue(Rec."No.", VariantCode, ShowAllVariants, AsOfDate);
        if TotalOnHandWeight <> 0 then
            AverageCost := TotalValueOfInventoryOnHand / TotalOnHandWeight
        else
            AverageCost := 0;
    end;

    var
        InfoPaneMgmt: Codeunit "OBF-Info Pane Mgmt";
        ShowAllVariants: Boolean;
        VariantCode: Code[10];
        AsOfDate: Date;
        AverageCost: Decimal;
        OnHandAvailable: Decimal;
        OnHandAvailableWeight: Decimal;
        OnHandCommitted: Decimal;
        OnHandCommittedWeight: Decimal;
        OnOrderCommitted: Decimal;
        OnOrderCommittedWeight: Decimal;
        OnOrderQty: Decimal;
        OnOrderWeight: Decimal;
        QtyOnQualityHold: Decimal;
        TotalAvailableQuantity: Decimal;
        TotalAvailableWeight: Decimal;
        TotalOnHandWeight: Decimal;
        TotalQty: Decimal;
        TotalValueOfInventoryOnHand: Decimal;
        UnallocatedSOQty: Decimal;
        UnallocatedSOWeight: Decimal;

    procedure SetValues(pAsOfDate: Date; pVariantCode: Code[10]; pShowAllVariants: Boolean)
    begin
        AsOfDate := pAsOfDate;
        ShowAllVariants := pShowAllVariants;
        if ShowAllVariants then
            VariantCode := '***ALL***'
        else
            VariantCode := pVariantCode;
    end;
}