namespace SilverBay.Inventory.Status;

using Microsoft.Inventory.Item;
using SilverBay.Inventory.System;
using SilverBay.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2894 - Migrate Orca Bay "Inv. Status by Item" page to Common/Inventory app
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
/// Migrated from page 50095 "OBF-Inv. Status by Item"
/// </summary>
page 60305 InventoryStatusByItem
{
    ApplicationArea = All;
    Caption = 'Inventory Status By Item';
    AdditionalSearchTerms = 'ISS,Silver,Bay,Inventory';
    Editable = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Tasks;
    AboutTitle = 'About Inventory Status by Item';
    //TODO: Add additional AboutText and other help comments to make this page more self-documenting 
    AboutText = 'The Inventory Status By Item page...';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    DrillDown = true;
                    DrillDownPageId = "Item Card";
                    ToolTip = 'Specifies the item number.';
                    Width = 7;
                    trigger OnDrillDown()
                    begin
                        InfoPaneMgmt.ShowItem(Rec."No.");
                    end;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the item description.';
                    Width = 40;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the second item description.';
                    Width = 15;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Caption = 'Search Description';
                    ToolTip = 'Specifies the search description for the item.';
                    Width = 30;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                    ToolTip = 'Specifies the item category code.';
                    Width = 7;
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    Caption = 'Country/Region of Origin Code';
                    ToolTip = 'Specifies the country or region of origin code.';
                    Width = 7;
                }
                field(OnHandQuantity; OnHandQuantity)
                {
                    Caption = 'On Hand Quantity';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Excludes Quantity on Quality Hold. Shows the current on hand quantity for the item.';
                    Width = 7;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    Caption = '+On Order Quantity';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the quantity on purchase order for the item.';
                    Width = 7;
                }
                field("OBF-Qty. on Sales Orders"; Rec.SBSINVQtyonSalesOrders)
                {
                    Caption = '-Qty. on Sales Orders';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the quantity on sales orders for the item.';
                    Width = 7;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
                field(TotalAvailableQuantity; TotalAvailableQuantity)
                {
                    Caption = '=Total Available Quantity';
                    DecimalPlaces = 0 : 0;
                    ToolTip = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders; Excludes Quantity on Quality Hold.';
                    Width = 7;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.DateFilter);
                    end;
                }
                field(OnHandWeight; OnHandWeight)
                {
                    Caption = 'On Hand Weight';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the on hand weight for the item.';
                    Visible = false;
                    Width = 8;
                }
                field(OnOrderNetWeight; OnOrderNetWeight)
                {
                    Caption = 'On Order Net Weight';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the net weight on order for the item.';
                    Visible = false;
                    Width = 8;
                }
                field(NetWeightOnSalesOrders; NetWeightOnSalesOrders)
                {
                    Caption = 'Net Weight on Sales Orders';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the net weight on sales orders for the item.';
                    Visible = false;
                    Width = 8;
                }
                field(AvailableNetWeight; AvailableNetWeight)
                {
                    Caption = 'Available Net Weight';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the available net weight for the item.';
                    Width = 8;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", this.VariantCode, this.ShowAllVariants, this.DateFilter);
                    end;
                }
                field(ShowItemLots; ShowItemLotsText)
                {
                    Caption = 'Show Item Lots';
                    StyleExpr = 'AttentionAccent';
                    ToolTip = 'Click to view item lots for this item.';
                    trigger OnDrillDown()
                    var
                        DistinctItemLotLocations: Page DistinctItemLotList;
                    begin
                        DistinctItemLotLocations.SetItem(Rec."No.", this.VariantCode, this.DateFilter);
                        DistinctItemLotLocations.RunModal();
                    end;
                }
            }
        }
        area(FactBoxes)
        {
            part(ItemFactBox; ItemFactbox)
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        this.VariantCode := '';
        this.DateFilter := CalcDate('<1Y>', WorkDate());
        Rec.SetFilter(Inventory, '<>%1', 0);
    end;

    trigger OnAfterGetRecord()
    begin
        this.ShowItemLotsText := this.ShowItemLotsLbl;
        this.ShowAllVariants := true;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold
        Rec.CalcFields(Inventory, "Qty. on Purch. Order", SBSINVQtyonSalesOrders);
        this.OnHandQuantity := Rec.Inventory;

        this.TotalAvailableQuantity := this.OnHandQuantity + Rec."Qty. on Purch. Order" - Rec.SBSINVQtyonSalesOrders;
        this.AvailableNetWeight := this.TotalAvailableQuantity * Rec."Net Weight";
        this.OnOrderNetWeight := Rec."Qty. on Purch. Order" * Rec."Net Weight";
        this.NetWeightOnSalesOrders := Rec.SBSINVQtyonSalesOrders * Rec."Net Weight";
        this.OnHandWeight := this.OnHandQuantity * Rec."Net Weight";
        this.AvailableNetWeight := this.TotalAvailableQuantity * Rec."Net Weight";
    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        ShowAllVariants: Boolean;
        VariantCode: Code[10];
        DateFilter: Date;
        AvailableNetWeight: Decimal;
        NetWeightOnSalesOrders: Decimal;
        OnHandQuantity: Decimal;
        OnHandWeight: Decimal;
        OnOrderNetWeight: Decimal;
        TotalAvailableQuantity: Decimal;
        ShowItemLotsLbl: Label 'Show Item Lots';
        ShowItemLotsText: Text[40];
}