namespace SilverBay.Inventory.StatusSummary.Item;

using Microsoft.Sales.Document;
using SilverBay.Common.Inventory.Item;
using SilverBay.Inventory.StatusSummary.Sales;

pageextension 60302 ItemFactbox extends "Item Factbox"
{
    layout
    {
        addafter(OnHand)
        {
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
        }
        addafter(OnOrder)
        {
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
        }
    }

    var
        UnallocatedSOWeight: Decimal;
        UnallocatedSOQty: Decimal;

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
    begin
        UnallocatedSOQty := SalesLine.SBSINVCalcOnOrderTotalUnallocated(Rec."No.", this.VariantCode, this.ShowAllVariants);
        UnallocatedSOWeight := UnallocatedSOQty * Rec."Net Weight";
    end;
}