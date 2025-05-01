// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues
// This is a copy of the standard "Sales Lines" page with SourceTableTemporary set to true

page 60304 "OBF-Sales Lines"
{
    // version NAVW111.00,NAVNA11.00

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
        area(content)
        {
            repeater(Control1)
            {
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

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
                field(SalesPerson; SalesHeader."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - End

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

                // field("OBF-Sell-to Customer Name"; "OBF-Sell-to Customer Name")
                // {
                //     Editable = false;
                //     ApplicationArea = All;
                // }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1017 - Add the columns “OBF-Unit Price (Sales Price UOM)” and “External Document No.” to Sales Lines page
                field(ExternalDocumentNo; SalesHeader."External Document No.")
                {
                    Caption = 'Customer PO';
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Advanced;
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
                    ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Advanced;
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
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = true;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units are being sold.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1477 - Add Weight column to Sales Lines Page 
                field("OBF-Line Net Weight"; Rec."OBF-Line Net Weight")
                {
                    ApplicationArea = All;
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
                field("OBF-Allocated Quantity"; Rec."OBF-Allocated Quantity")
                {
                    ToolTipML = ENU = 'This is the quantity that is allocated to lots in Item Tracking.';
                    ApplicationArea = All;
                }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - End

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1017 - Add the columns “OBF-Unit Price (Sales Price UOM)” and “External Document No.” to Sales Lines page
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1199 - Add "Sales Unit Price" field and related functionality

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
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
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the sales line.';
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies which work type the resource applies to when the sale is related to a job.';
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
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1552-Allow Sorting "OBF-Sales Lines" page by Shipment Date
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1493- Change "Sales Lines" drilldown to show the "Shipment Date" from the "Sales Header"

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Order Shipment Date 2"; "OBF-Order Shipment Date 2")
                // {
                //     ApplicationArea = All;
                // }

                field(OrderDate; SalesHeader."Order Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units on the order line have not yet been shipped.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-On-Hand Reserved Qty."; "OBF-On-Hand Reserved Qty.")
                // {
                //     ToolTip = 'Specifies how many units on the order line are reserved from On-Hand Qty.';
                //     Visible = ShowReserved;
                //     ApplicationArea = All;
                // }

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("OBF-Committed Reserved Qty."; "OBF-Committed Reserved Qty.")
                // {
                //     ToolTip = 'Specifies how many units on the order line are reserved from Purchase Orders.';
                //     Visible = ShowReserved;
                //     ApplicationArea = All;
                // }
                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - End

            }
        }
    }

    actions
    {
        area(navigation)
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
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction();
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        PageManagement.PageRun(SalesHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - End

    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(ShortcutDimCode);
    end;

    procedure SetUnallocatedSalesLines(ItemNo: Code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean);
    var
        SalesLine: Record "Sales Line";
        TrackingPercent: Decimal;
        ItemTracking: Boolean;
        InfoPaneMgmt: Codeunit "OBF-Info Pane Mgmt";
    begin
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if not IncludeAllVariants then
            SalesLine.SetRange("Variant Code", VariantCode);
        if SalesLine.FindSet then begin
            repeat
                TrackingPercent := Round(SalesLine.GetTrackingPercent(SalesLine."Quantity (Base)", ItemTracking));
                if TrackingPercent <> 100 then begin
                    Rec.Init;
                    Rec.TransferFields(SalesLine);

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1552-Allow Sorting "OBF-Sales Lines" page by Shipment Date
                    // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                    // Rec.CalcFields("OBF-Order Shipment Date");
                    // Rec."OBF-Order Shipment Date 2" := Rec."OBF-Order Shipment Date";

                    Rec.Insert;
                end;
            until SalesLine.Next = 0;
        end;
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/758 - Create new On Order Committed Drilldown
    Procedure SetOnOrderCommittedSalesLines(ItemNo: code[20]; VariantCode: Code[10]; IncludeAllVariants: Boolean; LotIsOnHand: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntryTEMP: Record "Reservation Entry" temporary;
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
    begin
        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", ItemNo);
        ReservEntry.SetRange(Positive, false);
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("OBF-Lot Is On Hand", LotIsOnHand);
        if not IncludeAllVariants then
            ReservEntry.SetRange("Variant Code", VariantCode);
        if ReservEntry.FindSet then
            repeat
                if SalesLine.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.") then
                    if Rec.Get(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.") then begin

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/755 - Add "Allocated Quantity" column to "Sales Lines" page - 
                        //      Replace "OBF-Reserved Qty. (Base)" flowfield with "OBF-Allocated Quantity" normal field in following block of code

                        //Rec.CalcFields("OBF-Reserved Qty. (Base)");
                        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // if LotIsOnHand then begin
                        //     Rec."OBF-On-Hand Reserved Qty." -= ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-Committed Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - Rec."OBF-On-Hand Reserved Qty.";
                        //     Rec."OBF-Committed Reserved Qty." := Rec."OBF-Allocated Quantity" - Rec."OBF-On-Hand Reserved Qty.";
                        // end else begin
                        //     Rec."OBF-Committed Reserved Qty." -= ReservEntry."Qty. to Handle (Base)";
                        //     //Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Reserved Qty. (Base)" - "OBF-Committed Reserved Qty.";
                        //     Rec."OBF-On-Hand Reserved Qty." := Rec."OBF-Allocated Quantity" - "OBF-Committed Reserved Qty.";
                        // end;
                        Rec.Modify;
                    end else begin
                        Rec.Init;
                        Rec.TransferFields(SalesLine);
                        //Rec.CalcFields("OBF-Reserved Qty. (Base)");

                        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
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

                        Rec.Insert;
                    end;
            until (ReservEntry.Next = 0);
    end;

    procedure SetShowReserved(pShowReserved: Boolean);
    begin
        ShowReserved := pShowReserved;
    end;

    var
        SalesHeader: Record "Sales Header";
        ShortcutDimCode: array[8] of Code[20];
        ShowReserved: Boolean;
}

