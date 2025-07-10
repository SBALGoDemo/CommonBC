namespace SilverBay.Inventory.Status;

using Microsoft.Inventory.Item;
// using Microsoft.Inventory.Ledger;
// using Microsoft.Inventory.Tracking;
// using Microsoft.Purchases.Document;
// using Microsoft.Purchases.History;
using SilverBay.Inventory.System;
using SilverBay.Inventory.Tracking;


/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2894 - Migrate Orca Bay "Inv. Status by Item" page to Common/Inventory app
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
/// Migrated from page 50095 "OBF-Inv. Status by Item"
/// </summary>
page 60312 InventoryStatusByItem
{
    PageType = List;
    UsageCategory = Tasks;
    SourceTable = Item;
    Editable = false;
    Caption = 'Inventory Status By Item';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Width = 7;
                    DrillDown = true;
                    DrillDownPageId = "Item Card";
                    ToolTip = 'Specifies the item number.';
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.ShowItem(Rec."No.");
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Width = 40;
                    ToolTip = 'Specifies the item description.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Width = 15;
                    ToolTip = 'Specifies the second item description.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    Width = 30;
                    ToolTip = 'Specifies the search description for the item.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Width = 7;
                    ToolTip = 'Specifies the item category code.';
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = All;
                    Width = 7;
                    ToolTip = 'Specifies the country or region of origin code.';
                }
                field(OnHandQuantity; OnHandQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'On Hand Quantity';
                    ToolTip = 'Excludes Quantity on Quality Hold. Shows the current on hand quantity for the item.';
                    Width = 7;
                    DecimalPlaces = 0 : 0;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                    Caption = '+On Order Quantity';
                    Width = 7;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the quantity on purchase order for the item.';
                }
                field("OBF-Qty. on Sales Orders"; Rec.SBSINVQtyonSalesOrders)
                {
                    ApplicationArea = All;
                    Caption = '-Qty. on Sales Orders';
                    Width = 7;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the quantity on sales orders for the item.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold 
                field(TotalAvailableQuantity; TotalAvailableQuantity)
                {
                    ApplicationArea = All;
                    Caption = '=Total Available Quantity';
                    ToolTip = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders; Excludes Quantity on Quality Hold.';
                    Width = 7;
                    DecimalPlaces = 0 : 0;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", VariantCode, ShowAllVariants, DateFilter);
                    end;
                }
                field(OnHandWeight; OnHandWeight)
                {
                    ApplicationArea = All;
                    Caption = 'On Hand Weight';
                    Visible = false;
                    Width = 8;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the on hand weight for the item.';
                }
                field(OnOrderNetWeight; OnOrderNetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'On Order Net Weight';
                    Visible = false;
                    Width = 8;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the net weight on order for the item.';
                }
                field(NetWeightOnSalesOrders; NetWeightOnSalesOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Net Weight on Sales Orders';
                    Visible = false;
                    Width = 8;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the net weight on sales orders for the item.';
                }
                field(AvailableNetWeight; AvailableNetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Available Net Weight';
                    Width = 8;
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Shows the available net weight for the item.';
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDown(Rec."No.", VariantCode, ShowAllVariants, DateFilter);
                    end;
                }
                field(ShowItemLots; ShowItemLotsText)
                {
                    ApplicationArea = All;
                    Caption = 'Show Item Lots';
                    StyleExpr = 'AttentionAccent';
                    ToolTip = 'Click to view item lots for this item.';
                    trigger OnDrillDown();
                    var
                        DistinctItemLotLocations: Page DistinctItemLotList;
                    begin
                        DistinctItemLotLocations.SetItem(Rec."No.", VariantCode, DateFilter);
                        DistinctItemLotLocations.RunModal();
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(ItemFactBox; ItemFactbox)
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        VariantCode := '';
        Datefilter := CalcDate('<1Y>', WorkDate());
        Rec.Setfilter(Inventory, '<>%1', 0);
    end;

    trigger OnAfterGetRecord();
    begin
        ShowItemLotsText := ShowItemLotsLbl;
        ShowAllVariants := true;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1483 - Issue with Qty. on Quality Hold 
        Rec.CalcFields(Inventory, "Qty. on Purch. Order", SBSINVQtyonSalesOrders);
        OnHandQuantity := Rec.Inventory;

        TotalAvailableQuantity := OnHandQuantity + Rec."Qty. on Purch. Order" - Rec.SBSINVQtyonSalesOrders;
        AvailableNetWeight := TotalAvailableQuantity * Rec."Net Weight";
        OnOrderNetWeight := Rec."Qty. on Purch. Order" * Rec."Net Weight";
        NetWeightOnSalesOrders := Rec.SBSINVQtyonSalesOrders * Rec."Net Weight";
        OnHandWeight := OnHandQuantity * Rec."Net Weight";
        AvailableNetWeight := TotalAvailableQuantity * Rec."Net Weight";
    end;

    var
        InfoPaneMgmt: Codeunit InfoPaneMgmt;
        DateFilter: Date;
        ShowAllVariants: Boolean;
        VariantCode: code[10];
        ShowItemLotsText: Text[40];
        ShowItemLotsLbl: Label 'Show Item Lots';
        OnHandQuantity: Decimal;
        TotalAvailableQuantity: Decimal;
        AvailableNetWeight: Decimal;
        OnOrderNetWeight: Decimal;
        NetWeightOnSalesOrders: Decimal;
        OnHandWeight: Decimal;
}

