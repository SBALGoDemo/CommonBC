// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/469 - Top-down ISS Page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/614 - Prevent over-allocating lots on sales orders 
//     Reverse sign of "Qty. on Sales Orders" and Net Weight on Sales Orders in "Total Available Quantity" and "Total Available Net Weight" calculation
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS and Inv. Status by Item Pages
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
// Drilldowns moved to Info Pane Management codeunit
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1195 - Hold Functionality
// Replaced "Quantity on Quality Hold" with "Qty on Quality Hold"
page 60300 "OBF-Distinct Item Lots"
{
    Caption = 'Distinct Item Lots';
    PageType = List;
    SourceTable = "OBF-Distinct Item Lot";
    SourceTableTemporary = true;
    Editable = false;
    layout
    {
        area(content)
        {
            group("ItemInfo")
            {
                Caption = 'Item Information';
                field(ItemNo; Rec."Item No.")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = False;
                    Width = 30;
                    ApplicationArea = All;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    Editable = False;
                    Width = 15;
                    ApplicationArea = All;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Editable = False;
                    Width = 30;
                    ApplicationArea = All;
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    Visible = false;
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = True;
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'As Of Date';
                    Visible = True;
                    Editable = False;
                    ApplicationArea = All;
                }
            }
            repeater(Group)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                }

                // TODO: REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Alternate Lot No."; "Alternate Lot No.")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }

                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Width = 5;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.LocationOnDrillDown(Rec."Location Code");
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.VendorOnDrillDown(Rec."Vendor No.");
                    end;
                }

                // FIXME: REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Label Text"; "Label Text")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                field("Container No."; Rec."Container No.")
                {
                    Visible = True;
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
                field("Sustainability Certification"; Rec."Sustainability Certification")
                {
                    Visible = True;
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages                 
                field("On Hand Quantity 2"; Rec."On Hand Quantity 2")
                {
                    Editable = false;
                    Width = 5;
                    DecimalPlaces = 0 : 0;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.OnHandDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
                field("Qty. In Transit"; Rec."Qty. In Transit")
                {
                    Caption = 'Qty. in Transit';
                    Editable = False;
                    Width = 5;
                    ApplicationArea = All;
                }

                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Qty. on Quality Hold"; "Qty. on Quality Hold")
                // {
                //     Editable = false;
                //     Width = 5;
                //     DecimalPlaces = 0 : 0;
                //     ApplicationArea = All;
                // }

                field("On Order Quantity 2"; Rec."On Order Quantity 2")
                {
                    CaptionML = ENU = '+On Order Quantity';
                    Editable = False;
                    Width = 5;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    CaptionML = ENU = '-Qty. on Sales Orders';
                    Editable = False;
                    Width = 5;
                    ApplicationArea = All;
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    CaptionML = ENU = 'Total Available Quantity';
                    Editable = False;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", DateFilter);
                    end;
                }
                field("On Hand Weight"; Rec."On Hand Weight")
                {
                    Editable = False;
                    Visible = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("On Order Weight 2"; Rec."On Order Weight 2")
                {
                    CaptionML = ENU = '+On Order Weight';
                    Editable = False;
                    Visible = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Net Weight on Sales Order"; Rec."Net Weight on Sales Order")
                {
                    CaptionML = ENU = '-Net Weight on Sales Orders';
                    Editable = False;
                    Visible = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Available Net Weight"; Rec."Available Net Weight")
                {
                    CaptionML = ENU = 'Available Net Weight';
                    Editable = False;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", DateFilter);
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("PO Number"; Rec."PO Number")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                    end;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = False;
                    ApplicationArea = All;
                }
                //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Editable = False;
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                field("OBF-Production Date"; Rec."OBF-Production Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }

                field(Buyer; Rec."Buyer Code")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.BuyerOnDrillDown(Rec."Buyer Code");
                    End;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
                field("OBF-Purchased For"; Rec."OBF-Purchased For")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Show Source Document")
            {
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                end;
            }
        }

    }

    var
        InfoPaneMgmt: Codeunit "OBF-Info Pane Mgmt";
        DateFilter: Date;
        ItemNo: Code[20];
        i: Integer;

    trigger OnOpenPage();
    begin
        Rec.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.");
        Rec.FindFirst;
        Rec.SetRange("Date Filter", 0D, DateFilter);
        CurrPage.Update;
    end;

    procedure SetItem(pItemNo: Code[20]; pVariantCode: Code[10]; pDateFilter: Date);
    begin
        ItemNo := pItemNo;
        if pDateFilter = 0D then
            DateFilter := Today
        else
            DateFilter := pDateFilter;
        Rec.DELETEALL;
        Rec.SetRange("Date Filter", 0D, DateFilter);
        SetPageDataForItem(pItemNo, pVariantCode, DateFilter);
    end;

    procedure SetOnHandQtyFilter();
    begin
        Rec.SetFilter("On Hand Quantity", '<>%1', 0);
    end;

    local procedure SetPageDataForItem(ItemNo: Code[20]; VariantCode: Code[10]; pDateFilter: Date);
    var
        //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
        DistinctItemLotResEntry: query "Distinct Item Lot (Res. Entry)";
        DistinctItemLocOnOrder: Query "OBF-Distinct Item Loc On Order";
        DistinctItemsOnPurchLine: Query "OBF-Dist. Items On Purch. Line";
        NextRowNo: Integer;
        LastItemNo: Code[20];
        LastLotNo: Code[20];
    begin
        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // ItemVariantLotInfo.SetRange(Rec."Item No.", ItemNo);
        // ItemVariantLotInfo.SetRange(Rec."Variant Code", VariantCode);

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
        // ItemVariantLotInfo.SetFilter("Quantity on Hand", '>0');

        // if ItemVariantLotInfo.FindSet then
        //     repeat
        //         AddRecord(ItemVariantLotInfo."Item No.", ItemVariantLotInfo."Variant Code", ItemVariantLotInfo."Lot No.", ItemVariantLotInfo."Location Code", True, pDateFilter, NextRowNo);
        //     until (ItemVariantLotInfo.Next = 0);

        DistinctItemLotResEntry.SetRange(Item_No, ItemNo);
        DistinctItemLotResEntry.SetRange(Variant_Code, VariantCode);
        DistinctItemLotResEntry.OPEN;
        while DistinctItemLotResEntry.READ do
            if not RecordExists(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No) then
                AddRecord(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No, DistinctItemLotResEntry.Location_Code, False, pDateFilter, NextRowNo);

        DistinctItemLocOnOrder.SetRange(Item_No, ItemNo);
        DistinctItemLocOnOrder.SetRange(Variant_Code, VariantCode);
        DistinctItemLocOnOrder.OPEN;
        while DistinctItemLocOnOrder.READ do begin
            if not RecordExists(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '') then
                AddRecord(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '',
                        DistinctItemLocOnOrder.Location_Code, False, pDateFilter, NextRowNo);
        end;

        DistinctItemsOnPurchLine.SetRange(Item_No, ItemNo);
        DistinctItemsOnPurchLine.SetRange(Variant_Code, VariantCode);
        DistinctItemsOnPurchLine.OPEN;
        while DistinctItemsOnPurchLine.READ do begin
            if not RecordExists(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '') then
                AddRecord(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '',
                        DistinctItemsOnPurchLine.Location_Code, False, pDateFilter, NextRowNo);
        end;

    end;

    local procedure AddRecord(pItemNo: Code[20]; pVariantCode: code[10]; pLotNo: Code[20]; pLocation: Code[20]; FromILE: Boolean; pDateFilter: Date; var pNextRowNo: Integer);
    var
        Item: Record Item;
        //MethodofCatch: Record "OBF-Method of Catch";
        QtyonSalesOrder: Decimal;
        WeightonSalesOrder: Decimal;
        ItemUOMPurch: Record "Item Unit of Measure";
        ItemUOMSalesPrice: Record "Item Unit of Measure";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
        InventorySetup: Record "Inventory Setup";
        //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
        UnassignedPurchaseLineQty: Decimal;
        PurchaseUnitCost: Decimal;
    begin
        Item.get(pItemNo);
        InventorySetup.Get;
        pNextRowNo += 1;
        Rec.init;
        Rec."Entry No." := pNextRowNo;
        Rec."Item No." := pItemNo;
        Rec."Variant Code" := pVariantCode;
        Rec."Lot No." := pLotNo;
        Rec."Location Code" := pLocation;
        PurchaseUnitCost := 0;
        Rec.SetRange("Date Filter", 0D, pDateFilter);

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order", "On Hand Quantity",
            "Total ILE Weight for Item Lot", "On Order Weight", "Net Weight on Sales Order"
            , "Qty. In Transit");

        Rec.CalcFields("Qty. on Sales Order", "Net Weight on Sales Order", "Qty. In Transit");

        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay      
        // Rec.CalcFields("Qty. on Quality Hold");

        Rec."On Hand Quantity 2" := Rec."On Hand Quantity" - Rec."Qty. on Quality Hold";

        if pLotNo = '' then begin
            CalculateUnassigned(pItemNo, pVariantCode, pLocation, UnassignedPurchaseLineQty);
            Rec.SetRange("Date Filter", 0D, pDateFilter);
        end;
        Rec."On Order Quantity 2" := Rec."On Order Quantity" + UnassignedPurchaseLineQty;

        //"On Order Weight 2" := "On Order Weight" + UnassignedPurchaseLineQty * Item."Net Weight";
        Rec."On Order Weight 2" := Rec."On Order Quantity 2" * Item."Net Weight";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements - commented out
        // if "On Order Quantity 2" < 0 then begin
        //     "On Order Quantity 2" := 0;
        //     "On Order Weight 2" := 0;
        // end;

        if (Rec."On Hand Quantity" <> 0) or (Rec."On Order Quantity 2" <> 0) or (Rec."Qty. on Sales Order" <> 0) or (Rec."Qty. on Quality Hold" <> 0) then begin
            Rec."Item Category Code" := Item."Item Category Code";
            Rec."Country of Origin" := Item."Country/Region of Origin Code";
            Rec."Item Description" := Item.Description;
            Rec."Item Description 2" := Item."Description 2";
            Rec."Search Description" := Item."Search Description";

            // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            // Rec."Pack Size" := Item."OBF-Pack Size";
            // IF MethodofCatch.get(Item."OBF-Method of Catch") then
            //     Rec."Method of Catch" := MethodofCatch.Description;
            // Rec."Brand Code" := Item."OBF-Brand Code";

            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
            // Rec."Buyer Code" := Item."OBF-Purchaser Code";

            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
            // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
            //     Rec."OBF-Purchased For" := ItemVariantLotInfo."Purchased For";

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/906 - Add column for "Quantity on Hold" to Inv. Status Summary pages
            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1425 -Inv. Status Summary Issue with In Transit Purchase Orders
            Rec."Total Available Quantity" := Rec."On Hand Quantity" + Rec."On Order Quantity 2" - Rec."Qty. on Sales Order" - Rec."Qty. on Quality Hold" - Rec."Qty. In Transit";

            if Rec."On Hand Quantity" <> 0 then
                Rec."On Hand Weight" := Rec."Total ILE Weight for Item Lot" - Rec."Qty. on Quality Hold" * Item."Net Weight" - Rec."Qty. In Transit" * Item."Net Weight"
            else
                Rec."On Hand Weight" := 0;

            //"Available Net Weight" := "On Hand Weight" + "On Order Weight 2" - "Net Weight on Sales Order";
            Rec."Available Net Weight" := Rec."Total Available Quantity" * Item."Net Weight";



            if FromILE then begin
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", pItemNo);
                ItemLedgerEntry.SetRange("Lot No.", pLotNo);

                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet then
                    repeat

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/826 - Add Production and Expiration Dates to Misc. Pages
                        if ItemLedgerEntry.Quantity > 0 then begin
                            Rec."Expiration Date" := ItemLedgerEntry."Expiration Date";

                            // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                            // Rec."OBF-Production Date" := ItemLedgerEntry."OBF-Production Date";

                            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1040 - Set Receipt Date on Item Ledger Entries                        
                            // Rec."Receipt Date" := ItemLedgerEntry."OBF-Receipt Date";

                            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/926 - Add Sustainability Cert to Inv. Status Summary Pages
                            // Rec."Sustainability Certification" := ItemLedgerEntry."OBF-Sustainability Cert.";

                            // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                            // Rec."Container No." := ItemLedgerEntry."OBF-Container No.";

                        end;

                        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
                        //     Rec."Value of Inventory on Hand" := ItemVariantLotInfo."Value Of Inventory On Hand";
                        IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" Then begin
                            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance                            
                            // if ItemLedgerEntry."OBF-Purchase Order No." <> '' then
                            //     Rec."PO Number" := ItemLedgerEntry."OBF-Purchase Order No."
                            // else
                            Rec."PO Number" := ItemLedgerEntry."Document No.";

                            IF PurchRcptHeader.get(ItemLedgerEntry."Document No.") then
                                if PurchRcptHeader."Purchaser Code" <> '' then
                                    Rec."Buyer Code" := PurchRcptHeader."Purchaser Code";
                        end else
                            if (Rec."Receipt Date" = 0D) and (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") then
                                Rec."PO Number" := ItemLedgerEntry."Document No.";


                        IF ItemLedgerEntry."Source Type" = ItemLedgerEntry."Source Type"::Vendor then
                            Rec."Vendor No." := ItemLedgerEntry."Source No.";

                    until (ItemLedgerEntry.Next = 0);
            end else begin
                ReservationEntry.reset;
                ReservationEntry.SetRange("Item No.", pItemNo);
                ReservationEntry.SetRange("Lot No.", pLotNo);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype"::"1");
                if ReservationEntry.FindFirst then begin
                    Rec."PO Number" := ReservationEntry."Source ID";

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance
                    Rec."OBF-Production Date" := ReservationEntry."OBF-Production Date";
                    Rec."Expiration Date" := ReservationEntry."Expiration Date";
                    if ReservationEntry."OBF-Purchaser Code" <> '' then
                        Rec."Buyer Code" := ReservationEntry."OBF-Purchaser Code";

                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then begin
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1055 - Inv. Status Performance                            
                        Rec."Vendor No." := PurchaseLine."Buy-from Vendor No.";

                        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                        // Rec."Sustainability Certification" := PurchaseLine."OBF-Sustainability Cert.";

                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1151 - Enhanced Container Functionality
                        // Rec."Container No." := PurchaseLine."OBF-Container No.";

                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements    
                        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1200 - Add "Purchase Unit Cost" field and related functionality
                        // PurchaseUnitCost := PurchaseLine."OBF-Purchase Unit Cost";

                    end;

                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - END
                end;
            end;
            if Rec."On Hand Weight" <> 0 then
                Rec."Unit Cost" := Rec."Value of Inventory on Hand" / Rec."On Hand Weight"
            else

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1079 - Inv. Status Page Improvements    
                Rec."Unit Cost" := PurchaseUnitCost;

            Rec.Insert;
            i += 1;
        end;
    end;

    local procedure RecordExists(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[20]): Boolean;
    var
        result: Boolean;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Lot No.", pLotNo);
        Rec.SetRange("Variant Code", pVariantCode);
        result := not Rec.IsEmpty;
        Rec.reset;
        exit(result);
    end;

    local procedure CalculateUnassigned(pItemNo: Code[20]; pVariantCode: Code[10]; pLocationCode: code[20]; var UnassignedPurchaseLineQty: Decimal);
    var
        result: Decimal;
        AssignedPurchaseLineQty: Decimal;
        AssignedPurchaseLineWeight: Decimal;
        PurchaseLine: Record "Purchase Line";
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Variant Code", pVariantCode);
        Rec.SetRange("Location Code", pLocationCode);
        Rec.CalcSums("On Order Quantity 2", "On Order Weight 2");
        AssignedPurchaseLineQty := Rec."On Order Quantity 2";
        AssignedPurchaseLineWeight := Rec."On Order Weight 2";
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", pItemNo);
        PurchaseLine.SetRange("Variant Code", pVariantCode);
        PurchaseLine.SetRange("Location Code", pLocationCode);
        PurchaseLine.CalcSums("Outstanding Qty. (Base)");
        UnassignedPurchaseLineQty := PurchaseLine."Outstanding Qty. (Base)" - AssignedPurchaseLineQty;
        Rec.reset;
    end;

}

