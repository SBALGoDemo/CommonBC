namespace SilverBay.Inventory.System;

using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using SilverBay.Inventory.Tracking;

/// <summary>
/// TODO: Monitor and consider migrating this object to the Common app if/when a future requirement would 
/// cause us to want to take dependency on the Inventory app rather than Common because of the code location.
/// This code was initially created in the Inventory app to expedite refactoring and deployment of code originally
/// written for Orca Bay to Silver Bay's BC. 
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// Migrated from page 50057 "OBF-Item Factbox"
/// </summary>
page 60302 ItemFactbox
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
                    ApplicationArea = All;
                    Caption = 'On Hand (Committed)';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Hand (Committed) field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetOnOrderCommittedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                        SalesLines.RunModal();
                    end;
                }
                field(OnHandCommittedWeight; this.OnHandCommittedWeight)
                {
                    ApplicationArea = All;
                    Caption = 'On Hand (Committed) Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Hand (Committed) Weight field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetOnOrderCommittedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                        SalesLines.RunModal();
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
                        DistinctItemLotList: Page DistinctItemLotList;
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
                        DistinctItemLotList: Page DistinctItemLotList;
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
                    ApplicationArea = All;
                    Caption = 'On Order Committed';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Committed field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetOnOrderCommittedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                        SalesLines.RunModal();
                    end;
                }
                field(OnOrderCommittedWeight; this.OnOrderCommittedWeight)
                {
                    ApplicationArea = All;
                    Caption = 'On Order Committed Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the On Order Committed Weight field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetOnOrderCommittedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants, false);
                        SalesLines.RunModal();
                    end;
                }
            }
            group(UnallocatedSO)
            {
                Caption = 'Unallocated Sales Orders';
                field(UnallocatedSOQty; UnallocatedSOQty)
                {
                    ApplicationArea = All;
                    Caption = 'Unallocated SO Qty.';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Unallocated SO Qty. field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetUnallocatedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants);
                        SalesLines.RunModal();
                    end;
                }
                field(UnallocatedSOWeight; UnallocatedSOWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Unallocated SO Weight';
                    DecimalPlaces = 0 : 3;
                    ToolTip = 'Specifies the value of the Unallocated SO Weight field.';

                    trigger OnDrillDown()
                    var
                        SalesLines: Page SalesLines;
                    begin
                        SalesLines.SetUnallocatedSalesLines(Rec."No.", this.VariantCode, this.ShowAllVariants);
                        SalesLines.RunModal();
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
    var
        SalesLine: Record "Sales Line";
    begin
        if this.AsOfDate <> 0D then
            Rec.SetFilter("Date Filter", '<=%1', this.AsOfDate);

        if not this.ShowAllVariants then
            Rec.SetRange("Variant Filter", this.VariantCode);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
        Rec.CalcFields(Inventory, "Qty. on Purch. Order");

        this.OnOrderQty := Rec."Qty. on Purch. Order";
        this.OnOrderWeight := this.OnOrderQty * Rec."Net Weight";
        this.OnOrderCommitted := this.InfoPaneMgmt.CalcInventoryOnOrderTotalCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnOrderCommittedWeight := this.OnOrderCommitted * Rec."Net Weight";
        this.OnHandCommitted := this.InfoPaneMgmt.CalcInventoryOnHandTotalCommitted(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.OnHandCommittedWeight := this.OnHandCommitted * Rec."Net Weight";
        this.OnHandAvailable := Rec.Inventory - this.OnHandCommitted; // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        this.OnHandAvailableWeight := this.TotalOnHandWeight - this.OnHandCommittedWeight;
        this.TotalAvailableQuantity := Rec.Inventory + this.OnOrderQty - this.OnHandCommitted - this.OnOrderCommitted; // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        this.TotalAvailableWeight := this.TotalOnHandWeight + this.OnOrderWeight - this.OnHandCommittedWeight - this.OnOrderCommittedWeight;
        this.TotalValueOfInventoryOnHand := this.InfoPaneMgmt.CalcInventoryOnHandTotalValue(Rec."No.", this.VariantCode, this.ShowAllVariants, this.AsOfDate);
        this.UnallocatedSOQty := SalesLine.SBSINVCalcOnOrderTotalUnallocated(Rec."No.", this.VariantCode, this.ShowAllVariants);
        this.UnallocatedSOWeight := UnallocatedSOQty * Rec."Net Weight";

        if this.TotalOnHandWeight <> 0 then
            this.AverageCost := this.TotalValueOfInventoryOnHand / this.TotalOnHandWeight
        else
            this.AverageCost := 0;

    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        AsOfDate: Date;
        AverageCost: Decimal;
        OnHandAvailable: Decimal;
        OnHandAvailableWeight: Decimal;
        OnOrderQty: Decimal;
        OnOrderWeight: Decimal;
        TotalAvailableQuantity: Decimal;
        TotalAvailableWeight: Decimal;
        TotalOnHandWeight: Decimal;
        TotalQty: Decimal;
        TotalValueOfInventoryOnHand: Decimal;

        // protected var
        UnallocatedSOWeight: Decimal;
        UnallocatedSOQty: Decimal;
        OnHandCommitted: Decimal;
        OnHandCommittedWeight: Decimal;
        OnOrderCommitted: Decimal;
        OnOrderCommittedWeight: Decimal;
        ShowAllVariants: Boolean;
        VariantCode: Code[10];

    procedure SetValues(NewAsOfDate: Date; NewVariantCode: Code[10]; NewShowAllVariants: Boolean)
    begin
        this.AsOfDate := NewAsOfDate;
        this.ShowAllVariants := NewShowAllVariants;
        if this.ShowAllVariants then
            this.VariantCode := '***ALL***'
        else
            this.VariantCode := NewVariantCode;
    end;
}