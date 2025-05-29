namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// </summary>
page 60303 "Item Factbox"
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
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(VariantCode; this.VariantCode)
                {
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies a code that identifies an item variant.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }
                field(AsOfDate; Format(this.AsOfDate))
                {
                    Caption = 'As Of Date';
                    ToolTip = 'Specifies the value of the As Of Date field.';
                }
            }
            group(OnHand)
            {
                Caption = 'On Hand';

                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
                /// </summary>
                field(Inventory; this.TotalQty)
                {
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnHandDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Qty on Quality Hold"; QtyOnQualityHold)
                // {
                //     Caption = 'Quality Hold';
                //     DecimalPlaces = 0 : 3;
                //     ApplicationArea = All;
                // }
                field(TotalOnHandWeight; this.TotalOnHandWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnHandDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
                field(TotalValueOfInventoryOnHand; this.TotalValueOfInventoryOnHand)
                {
                    Caption = 'Total Value';
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Specifies the value of the Total Value field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnHandDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
                field(AverageCost; this.AverageCost)
                {
                    Caption = 'Average Cost per Pound';
                    ToolTip = 'Specifies the value of the Average Cost per Pound field.';
                }
            }
            group(OnHandCommittedGroup)
            {
                Caption = 'On Hand (Committed)';
                field(OnHandCommitted; this.OnHandCommitted)
                {
                    Caption = 'On Hand (Committed)';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Hand (Committed) field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, true);
                    end;
                }
                field(OnHandCommittedWeight; this.OnHandCommittedWeight)
                {
                    Caption = 'On Hand (Committed) Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Hand (Committed) Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, true);
                    end;
                }
            }
            group(OnHandAvailableGroup)
            {
                Caption = 'On Hand (Available)';
                field(OnHandAvailable; this.OnHandAvailable)
                {
                    Caption = 'On-Hand Available';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On-Hand Available field.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLotList: Page "Distinct Item Lot List";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if this.ShowAllVariants then
                            DistinctItemLotList.SetItem(Rec."No.", '', this.AsOfDate)
                        else
                            DistinctItemLotList.SetItem(Rec."No.", this.VariantCode, this.AsOfDate);
                        DistinctItemLotList.SetOnHandQtyFilter();
                        DistinctItemLotList.RunModal();
                    end;
                }
                field(OnHandAvailableWeight; this.OnHandAvailableWeight)
                {
                    Caption = 'On-Hand Available (Weight)';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On-Hand Available (Weight) field.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLotList: Page "Distinct Item Lot List";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if this.ShowAllVariants then
                            DistinctItemLotList.SetItem(Rec."No.", '', this.AsOfDate)
                        else
                            DistinctItemLotList.SetItem(Rec."No.", this.VariantCode, this.AsOfDate);
                        DistinctItemLotList.SetOnHandQtyFilter();
                        DistinctItemLotList.RunModal();
                    end;
                }
            }
            group(OnOrder)
            {
                Caption = 'On Order';
                field(OnOrderQty; this.OnOrderQty)
                {
                    Caption = 'On Order Qty';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Qty field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
                field(OnOrderWeight; this.OnOrderWeight)
                {
                    Caption = 'On Order Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
            }
            group(OnOrderCommittedGroup)
            {
                Caption = 'On Order Committed';
                field(OnOrderCommitted; this.OnOrderCommitted)
                {
                    Caption = 'On Order Committed';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Committed field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                    end;
                }
                field(OnOrderCommittedWeight; this.OnOrderCommittedWeight)
                {
                    Caption = 'On Order Committed Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Committed Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                    end;
                }
            }
            group(UnallocatedSO)
            {
                Caption = 'Unallocated Sales Orders';
                field(UnallocatedSOQty; this.UnallocatedSOQty)
                {
                    Caption = 'Unallocated SO Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Unallocated SO Qty. field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.UnallocatedSODrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
                field(UnallocatedSOWeight; this.UnallocatedSOWeight)
                {
                    Caption = 'Unallocated SO Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Unallocated SO Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.UnallocatedSODrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
            }
            group(Available)
            {
                Caption = 'Available ';
                field(TotalAvailableQuantity; this.TotalAvailableQuantity)
                {
                    Caption = 'Total Available Quantity';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'On Hand + On Order - On Hand Committed - On Order Committed';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
                field(TotalAvailableWeight; this.TotalAvailableWeight)
                {
                    Caption = 'Total Available Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Available Weight field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if this.AsOfDate <> 0D then
            Rec.SetFilter("Date Filter", '<=%1', this.AsOfDate);

        if not this.ShowAllVariants then
            Rec.SetRange("Variant Filter", this.VariantCode);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
        Rec.CalcFields(Inventory, "Qty. on Purch. Order");
        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // Rec.CalcFields("OBF-Qty on Quality Hold");
        this.TotalQty := Rec.Inventory - Rec.SBSISSQtyonQualityHold;
        // this.QtyOnQualityHold := Rec.SBSISSQtyonQualityHold;//TODO: Review Later
        this.TotalOnHandWeight := (Rec.Inventory - Rec.SBSISSQtyonQualityHold) * Rec."Net Weight";

        this.OnOrderQty := Rec."Qty. on Purch. Order";
        this.OnOrderWeight := this.OnOrderQty * Rec."Net Weight";
        this.OnOrderCommitted := this.InfoPaneMgmt.CalcInventoryOnOrderTotalCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnOrderCommittedWeight := this.OnOrderCommitted * Rec."Net Weight";
        this.OnHandCommitted := this.InfoPaneMgmt.CalcInventoryOnHandTotalCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnHandCommittedWeight := this.OnHandCommitted * Rec."Net Weight";
        this.OnHandAvailable := Rec.Inventory - this.OnHandCommitted - Rec.SBSISSQtyonQualityHold;
        this.OnHandAvailableWeight := this.TotalOnHandWeight - this.OnHandCommittedWeight;
        this.UnallocatedSOQty := this.InfoPaneMgmt.CalcOnOrderTotalUnallocated(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.UnallocatedSOWeight := this.UnallocatedSOQty * Rec."Net Weight";
        this.TotalAvailableQuantity := Rec.Inventory + this.OnOrderQty - this.OnHandCommitted - this.OnOrderCommitted - Rec.SBSISSQtyonQualityHold;
        this.TotalAvailableWeight := this.TotalOnHandWeight + this.OnOrderWeight - this.OnHandCommittedWeight - this.OnOrderCommittedWeight;
        this.TotalValueOfInventoryOnHand := this.InfoPaneMgmt.CalcInventoryOnHandTotalValue(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
        if this.TotalOnHandWeight <> 0 then
            this.AverageCost := this.TotalValueOfInventoryOnHand / this.TotalOnHandWeight
        else
            this.AverageCost := 0;
    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
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
        // QtyOnQualityHold: Decimal;//TODO: Review Later
        TotalAvailableQuantity: Decimal;
        TotalAvailableWeight: Decimal;
        TotalOnHandWeight: Decimal;
        TotalQty: Decimal;
        TotalValueOfInventoryOnHand: Decimal;
        UnallocatedSOQty: Decimal;
        UnallocatedSOWeight: Decimal;

    internal procedure SetValues(NewAsOfDate: Date; NewVariantCode: Code[10]; NewShowAllVariants: Boolean)
    begin
        this.AsOfDate := NewAsOfDate;
        this.ShowAllVariants := NewShowAllVariants;
        if this.ShowAllVariants then
            this.VariantCode := '***ALL***'
        else
            this.VariantCode := NewVariantCode;
    end;
}