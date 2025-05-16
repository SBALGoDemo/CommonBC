namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Utilities;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
/// This is a copy of the standard "Sales Lines" page with SourceTableTemporary set to true 
/// </summary>
page 60304 SalesLines
{
    ApplicationArea = All;
    Caption = 'Sales Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Caption = 'Control1';
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer to whom the items in the sales order will be shipped.';
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
                /// </summary>
                field(SalesPerson; this.SalesHeader."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                }
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Sell-to Customer Name"; "OBF-Sell-to Customer Name")
                // {
                //     Editable = false;
                //     ApplicationArea = All;
                // }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1017 - Add the columns “OBF-Unit Price (Sales Price UOM)” and “External Document No.” to Sales Lines page
                field(ExternalDocumentNo; this.SalesHeader."External Document No.")
                {
                    Caption = 'Customer PO';
                    ToolTip = 'Specifies the value of the Customer PO field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account. The type that you enter in this field determines what you can select in the No. field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.';
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = true;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units are being sold.';
                }
                /// <summary>
                /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1477 - Add Weight column to Sales Lines Page
                /// </summary>
                field("OBF-Line Net Weight"; Rec.SBSISSLineNetWeight)
                {
                    Caption = 'Line Net Weight';
                    ToolTip = 'Specifies the value of the Line Net Weight field.';
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity of items that remain to be shipped.';
                    Visible = false;
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page - Commented Out
                // field("OBF-Reserved Qty. (Base)";"OBF-Reserved Qty. (Base)")
                // {
                //     ApplicationArea = Basic,Suite;
                //     ToolTip = 'Specifies the Reserved Quantity for lots.';
                // }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page
                field("OBF-Allocated Quantity"; Rec.SBSISSAllocatedQuantity)
                {
                    Caption = 'Allocated Quantity';
                    ToolTip = 'This is the quantity that is allocated to lots in Item Tracking.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1017 - Add the columns “OBF-Unit Price (Sales Price UOM)” and “External Document No.” to Sales Lines page
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1199 - Add "Sales Unit Price" field and related functionality
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Sales Unit Price"; "OBF-Sales Unit Price")
                // {
                //     ApplicationArea = All;
                // }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related project. If you fill in this field and the Project Task No. field, then a project ledger entry will be posted together with the sales line.';
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to when the sale is related to a project.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; this.ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';
                    Visible = false;
                }
                field("ShortcutDimCode[4]"; this.ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';
                    Visible = false;
                }
                field("ShortcutDimCode[5]"; this.ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';
                    Visible = false;
                }
                field("ShortcutDimCode[6]"; this.ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';
                    Visible = false;
                }
                field("ShortcutDimCode[7]"; this.ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';
                    Visible = false;
                }
                field("ShortcutDimCode[8]"; this.ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';
                    Visible = false;
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1552-Allow Sorting "OBF-Sales Lines" page by Shipment Date
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1493- Change "Sales Lines" drilldown to show the "Shipment Date" from the "Sales Header"
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Order Shipment Date 2"; "OBF-Order Shipment Date 2")
                // {
                //     ApplicationArea = All;
                // }
                field(OrderDate; this.SalesHeader."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units on the order line have not yet been shipped.';
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-On-Hand Reserved Qty."; "OBF-On-Hand Reserved Qty.")
                // {
                //     ToolTip = 'Specifies how many units on the order line are reserved from On-Hand Qty.';
                //     Visible = ShowReserved;
                //     ApplicationArea = All;
                // }
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Committed Reserved Qty."; "OBF-Committed Reserved Qty.")
                // {
                //     ToolTip = 'Specifies how many units on the order line are reserved from Purchase Orders.';
                //     Visible = ShowReserved;
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        this.SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        PageManagement.PageRun(this.SalesHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(this.ShortcutDimCode);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
        this.SalesHeader.Get(Rec."Document Type", Rec."Document No.");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(this.ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        // ShowReserved: Boolean; //TODO: Review Later
        ShortcutDimCode: array[8] of Code[20];

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
    /// </summary>
    /// <param name="ItemNo"></param>
    /// <param name="VariantCode"></param>
    /// <param name="IncludeAllVariants"></param>
    /// <param name="LotIsOnHand"></param>
    procedure SetOnOrderCommittedSalesLines(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; LotIsOnHand: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
    begin
        ReservEntry.Reset();
        ReservEntry.SetRange("Item No.", ItemNo);
        ReservEntry.SetRange(Positive, false);
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange(SBSISSLotIsOnHand, LotIsOnHand);
        if not IncludeAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if ReservEntry.FindSet() then
            repeat
                if SalesLine.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.") then
                    if Rec.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.") then

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page -
                        //      Replace "OBF-Reserved Qty. (Base)" flowfield with "OBF-Allocated Quantity" normal field in following block of code

                        //Rec.CalcFields("OBF-Reserved Qty. (Base)");
                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // if LotIsOnHand then begin
                        //     Rec."OBF-On-Hand Reserved Qty." -= ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-Committed Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - Rec."OBF-On-Hand Reserved Qty.";
                        //     Rec."OBF-Committed Reserved Qty." := Rec."OBF-Allocated Quantity" - Rec."OBF-On-Hand Reserved Qty.";
                        // end else begin
                        //     Rec."OBF-Committed Reserved Qty." -= ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - "OBF-Committed Reserved Qty.";
                        //     Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Allocated Quantity" - "OBF-Committed Reserved Qty.";
                        // end;
                        Rec.Modify()
                    else begin
                        Rec.Init();
                        Rec.TransferFields(SalesLine);
                        //Rec.CalcFields("OBF-Reserved Qty. (Base)");

                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // if LotIsOnHand then begin
                        //     Rec."OBF-On-Hand Reserved Qty." := -ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-Committed Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - Rec."OBF-On-Hand Reserved Qty.";
                        //     Rec."OBF-Committed Reserved Qty." := Rec."OBF-Allocated Quantity" - Rec."OBF-On-Hand Reserved Qty.";
                        // end else begin
                        //     Rec."OBF-Committed Reserved Qty." := -ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - "OBF-Committed Reserved Qty.";
                        //     Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Allocated Quantity" - "OBF-Committed Reserved Qty.";
                        // end;

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1552-Allow Sorting "OBF-Sales Lines" page by Shipment Date
                        // Rec.CalcFields("OBF-Order Shipment Date");
                        // Rec."OBF-Order Shipment Date 2" := Rec."OBF-Order Shipment Date";

                        Rec.Insert();
                    end;
            until (ReservEntry.Next() = 0);
    end;

    internal procedure SetShowReserved(pShowReserved: Boolean)
    begin
        // this.ShowReserved := pShowReserved; //TODO: Review Later
    end;

    internal procedure SetUnallocatedSalesLines(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean)
    var
        SalesLine: Record "Sales Line";
        ItemTracking: Boolean;
        TrackingPercent: Decimal;
    begin
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if not IncludeAllVariants then
            SalesLine.SetRange("Variant Code", VariantCode);
        if SalesLine.FindSet() then
            repeat
                TrackingPercent := Round(SalesLine.SBSISSGetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking));
                if TrackingPercent <> 100 then begin
                    Rec.Init();
                    Rec.TransferFields(SalesLine);

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1552-Allow Sorting "OBF-Sales Lines" page by Shipment Date
                    //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                    // Rec.CalcFields("OBF-Order Shipment Date");
                    // Rec."OBF-Order Shipment Date 2" := Rec."OBF-Order Shipment Date";

                    Rec.Insert();
                end;
            until SalesLine.Next() = 0;
    end;
}