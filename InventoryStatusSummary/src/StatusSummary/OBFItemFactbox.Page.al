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
                field(VariantCode; this.VariantCode)
                {
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
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

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
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
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, true);
                    end;
                }
                field(OnHandCommittedWeight; this.OnHandCommittedWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
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
                        DistinctItemLots: Page "OBF-Distinct Item Lots";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if this.ShowAllVariants then
                            DistinctItemLots.SetItem(Rec."No.", '', this.AsOfDate)
                        else
                            DistinctItemLots.SetItem(Rec."No.", this.VariantCode, this.AsOfDate);
                        DistinctItemLots.SetOnHandQtyFilter();
                        DistinctItemLots.RunModal();
                    end;
                }
                field(OnHandAvailableWeight; this.OnHandAvailableWeight)
                {
                    Caption = 'On-Hand Available (Weight)';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On-Hand Available (Weight) field.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLots: Page "OBF-Distinct Item Lots";
                    begin
                        Message('This drilldown is not fully implemented yet. Please contact support.');
                        if this.ShowAllVariants then
                            DistinctItemLots.SetItem(Rec."No.", '', this.AsOfDate)
                        else
                            DistinctItemLots.SetItem(Rec."No.", this.VariantCode, this.AsOfDate);
                        DistinctItemLots.SetOnHandQtyFilter();
                        DistinctItemLots.RunModal();
                    end;
                }
            }
            group(OnOrder)
            {
                Caption = 'On Order';
                field(OnOrderQty; this.OnOrderQty)
                {
                    CaptionML = ENU = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the OnOrderQty field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
                field(OnOrderWeight; this.OnOrderWeight)
                {
                    CaptionML = ENU = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the OnOrderWeight field.';
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
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.CommittedDrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                    end;
                }
                field(OnOrderCommittedWeight; this.OnOrderCommittedWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
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
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Qty. field.';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.UnallocatedSODrilldown(Rec."No.", this.VariantCode, this.ShowAllVariants);
                    end;
                }
                field(UnallocatedSOWeight; this.UnallocatedSOWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
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
                    Caption = 'Total Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTipML = ENU = '=On Hand + On Order - On Hand Committed - On Order Committed';
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
                    end;
                }
                field(TotalAvailableWeight; this.TotalAvailableWeight)
                {
                    Caption = 'Total Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Total Weight field.';
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
        // SetFilter("Inventory As Of Date Filter",'<=%1',AsOfDate);

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
        this.OnOrderCommitted := this.InfoPaneMgmt.CalcOnOrderCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnOrderCommittedWeight := this.OnOrderCommitted * Rec."Net Weight";
        this.OnHandCommitted := this.InfoPaneMgmt.CalcOnHandCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnHandCommittedWeight := this.OnHandCommitted * Rec."Net Weight";
        this.OnHandAvailable := Rec.Inventory - this.OnHandCommitted - Rec.SBSISSQtyonQualityHold;
        this.OnHandAvailableWeight := this.TotalOnHandWeight - this.OnHandCommittedWeight;
        this.UnallocatedSOQty := this.InfoPaneMgmt.CalcUnallocatedSO(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.UnallocatedSOWeight := this.UnallocatedSOQty * Rec."Net Weight";
        this.TotalAvailableQuantity := Rec.Inventory + this.OnOrderQty - this.OnHandCommitted - this.OnOrderCommitted - Rec.SBSISSQtyonQualityHold;
        this.TotalAvailableWeight := this.TotalOnHandWeight + this.OnOrderWeight - this.OnHandCommittedWeight - this.OnOrderCommittedWeight;
        this.TotalValueOfInventoryOnHand := this.InfoPaneMgmt.CalcInventoryValue(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
        if this.TotalOnHandWeight <> 0 then
            this.AverageCost := this.TotalValueOfInventoryOnHand / this.TotalOnHandWeight
        else
            this.AverageCost := 0;
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
        // QtyOnQualityHold: Decimal;//TODO: Review Later
        TotalAvailableQuantity: Decimal;
        TotalAvailableWeight: Decimal;
        TotalOnHandWeight: Decimal;
        TotalQty: Decimal;
        TotalValueOfInventoryOnHand: Decimal;
        UnallocatedSOQty: Decimal;
        UnallocatedSOWeight: Decimal;

    procedure SetValues(pAsOfDate: Date; pVariantCode: Code[10]; pShowAllVariants: Boolean)
    begin
        this.AsOfDate := pAsOfDate;
        this.ShowAllVariants := pShowAllVariants;
        if this.ShowAllVariants then
            this.VariantCode := '***ALL***'
        else
            this.VariantCode := pVariantCode;
    end;
}