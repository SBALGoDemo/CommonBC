// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS 
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

//  Note: This page was copied from and is similar to Page 50054 "Distinct Item Lots"

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
// Drilldowns moved to Info Pane Management codeunit
page 60301 "OBF-Inv. Stat. Summary by Date"
{
    Caption = 'Inv. Stat. Summary by Date';
    PageType = List;
    SourceTable = "OBF-Distinct Item Lot";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = True;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field(DateFilter; DateFilter)
                {
                    Caption = 'As of Date Filter';
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        Rec.DeleteAll;
                        Rec.SetRange("Date Filter", 0D, DateFilter);
                        SetPageData(DateFilter);
                        Rec.FindFirst;
                        CurrPage.Update;
                        CurrPage."Item FactBox".Page.SetValues(DateFilter, '', true);
                    end;
                }
            }
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.ShowItem(Rec."Item No.");
                    end;
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
                    Visible = false;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                    Visible = false;
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
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    Width = 10;
                    ApplicationArea = All;
                }
                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Alternate Lot No."; Rec."Alternate Lot No.")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }
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
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = False;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Editable = False;
                    ApplicationArea = All;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date                     
                field("OBF-Production Date"; Rec."OBF-Production Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                }

                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                field("On Hand Quantity"; Rec."On Hand Quantity")
                {
                    Editable = false;
                    Width = 5;
                    ApplicationArea = All;
                }
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
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Editable = False;
                    Width = 10;
                    ApplicationArea = All;
                }
                // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Label Text"; Rec."Label Text")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }
                field("Buyer Code"; Rec."Buyer Code")
                {
                    Editable = false;
                    Width = 5;
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnDrillDown();
                    begin
                        InfoPaneMgmt.BuyerOnDrillDown(Rec."Buyer Code");
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
                field("OBF-Purchased For"; Rec."OBF-Purchased For")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
        }
        area(factboxes)
        {
            part("Item FactBox"; "OBF-Item Factbox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Item No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1399 - Prompt for Date when opening Inv. Status by Date
            action(GetData)
            {
                Image = ListPage;
                Caption = 'Get Data';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    SetPageData(DateFilter);
                    Rec.FindFirst;
                    CurrPage.Update;
                end;
            }

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
        InventorySetup: Record "Inventory Setup";
        DateFilter: Date;
        i: Integer;

    trigger OnOpenPage();
    begin
        CurrPage.Editable(true);
        DateFilter := CALCDATE('1Y', WORKDATE);
        Rec.SetRange("Date Filter", 0D, DateFilter);

        Rec.DeleteAll;
        Rec."Item No." := ' ';
        Rec.Insert();

        Rec.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.");
        Rec.FindFirst;
        CurrPage.Update;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        CurrPage."Item FactBox".Page.SetValues(DateFilter, '', true);
    end;

    local procedure SetPageData(pDateFilter: Date);
    var
        ISSDistinctItemLots: Query "Distinct Item Lot Locations";
        DistinctItemLotResEntry: query "Distinct Item Lot (Res. Entry)";
        DistinctItemLocOnOrder: Query "OBF-Distinct Item Loc On Order";
        DistinctItemsOnPurchLine: Query "OBF-Dist. Items On Purch. Line";
        ItemT: Record Item;
        NextRowNo: Integer;
    begin
        Rec.DeleteAll;
        InventorySetup.Get;
        ISSDistinctItemLots.SetRange(Posting_Date_Filter, 0D, pDateFilter);
        ISSDistinctItemLots.Open;
        while ISSDistinctItemLots.Read do begin
            if ISSDistinctItemLots.Item_Tracking_Code <> '' then
                if not RecordExists(ISSDistinctItemLots.Item_No, ISSDistinctItemLots.Variant_Code, ISSDistinctItemLots.Lot_No,
                                    ISSDistinctItemLots.Location_Code) then
                    AddRecord(ISSDistinctItemLots.Item_No, ISSDistinctItemLots.Variant_Code, ISSDistinctItemLots.Lot_No,
                              ISSDistinctItemLots.Location_Code, true, pDateFilter, NextRowNo);
        end;

        DistinctItemLotResEntry.Open;
        while DistinctItemLotResEntry.Read do begin
            if DistinctItemLotResEntry.Item_Tracking_Code <> '' then
                if not RecordExists(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No,
                                    DistinctItemLotResEntry.Location_Code) then
                    AddRecord(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No,
                              DistinctItemLotResEntry.Location_Code, false, pDateFilter, NextRowNo);
        end;

        DistinctItemLocOnOrder.Open;
        while DistinctItemLocOnOrder.Read do begin
            if InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemLocOnOrder.Item_No, ItemT) then
                if not RecordExists(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '', DistinctItemLocOnOrder.Location_Code) then
                    AddRecord(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '',
                              DistinctItemLocOnOrder.Location_Code, false, pDateFilter, NextRowNo);
        end;

        DistinctItemsOnPurchLine.Open;
        while DistinctItemsOnPurchLine.Read do begin
            if InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemsOnPurchLine.Item_No, ItemT) then
                if not RecordExists(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '', DistinctItemsOnPurchLine.Location_Code) then
                    AddRecord(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '',
                              DistinctItemsOnPurchLine.Location_Code, false, pDateFilter, NextRowNo);
        end;
    end;

    local procedure AddRecord(pItemNo: Code[20]; pVariantCode: code[10]; pLotNo: Code[50]; pLocation: Code[20]; FromILE: Boolean; pDateFilter: Date; var pNextRowNo: Integer);
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
        UnassignedPurchaseLineQty: Decimal;
    //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
    begin
        Item.Get(pItemNo);
        pNextRowNo += 1;
        Rec.Init;
        Rec."Entry No." := pNextRowNo;
        Rec."Item No." := pItemNo;
        Rec."Variant Code" := pVariantCode;
        Rec."Lot No." := pLotNo;
        Rec."Location Code" := pLocation;
        UnassignedPurchaseLineQty := 0;
        Rec.SetRange("Date Filter", 0D, pDateFilter);
        Rec.CalcFields("On Hand Quantity", "On Order Quantity", "Qty. on Sales Order",
                       "Total ILE Weight for Item Lot", "On Order Weight", "Net Weight on Sales Order");
        if pLotNo = '' then begin
            CalculateUnassigned(pItemNo, pVariantCode, pLocation, UnassignedPurchaseLineQty);
            Rec.SetRange("Date Filter", 0D, pDateFilter);
        end;
        Rec."On Order Quantity 2" := Rec."On Order Quantity" + UnassignedPurchaseLineQty;
        Rec."On Order Weight 2" := Rec."On Order Weight" + UnassignedPurchaseLineQty * Item."Net Weight";
        if Rec."On Order Quantity 2" < 0 then begin
            Rec."On Order Quantity 2" := 0;
            Rec."On Order Weight 2" := 0;
        end;

        Rec."Item Category Code" := Item."Item Category Code";
        Rec."Country of Origin" := Item."Country/Region of Origin Code";
        Rec."Item Description" := Item.Description;
        Rec."Item Description 2" := Item."Description 2";
        Rec."Search Description" := Item."Search Description";

        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
        // Rec."Pack Size" := Item."OBF-Pack Size";
        // if MethodofCatch.Get(Item."OBF-Method of Catch") then
        //     Rec."Method of Catch" := MethodofCatch.Description;
        // Rec."Brand Code" := Item."OBF-Brand Code";

        // // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
        // Rec."Buyer Code" := Item."OBF-Purchaser Code";

        if (Rec."On Hand Quantity" <> 0) or (Rec."On Order Quantity 2" > 0) then begin
            Rec."Total Available Quantity" := Rec."On Hand Quantity" + Rec."On Order Quantity 2" - Rec."Qty. on Sales Order";
            Rec."On Hand Weight" := Rec."Total ILE Weight for Item Lot";
            Rec."Available Net Weight" := Rec."On Hand Weight" + Rec."On Order Weight 2" - Rec."Net Weight on Sales Order";
            if FromILE then begin
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", pItemNo);
                ItemLedgerEntry.SetRange("Variant Code", pVariantCode);
                ItemLedgerEntry.SetRange("Location Code", pLocation);
                ItemLedgerEntry.SetRange("Lot No.", pLotNo);
                ItemLedgerEntry.SetRange("Posting Date", 0D, pDateFilter);
                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet then
                    repeat
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        Rec."Value of Inventory on Hand" := Rec."Value of Inventory on Hand" + ItemLedgerEntry."Cost Amount (Expected)" +
                                ItemLedgerEntry."Cost Amount (Actual)";

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1040 - Set Receipt Date on Item Ledger Entries 
                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                        // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay                     
                        // if ItemLedgerEntry.Quantity > 0 then begin
                        //     Rec."Receipt Date" := ItemLedgerEntry."OBF-Receipt Date";
                        //     Rec."OBF-Production Date" := ItemLedgerEntry."OBF-Production Date";
                        // end;

                        if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" then begin
                            Rec."PO Number" := ItemLedgerEntry."Document No.";
                            if PurchRcptHeader.Get(ItemLedgerEntry."Document No.") then
                                if PurchRcptHeader."Purchaser Code" <> '' then
                                    Rec."Buyer Code" := PurchRcptHeader."Purchaser Code";
                        end else
                            if (Rec."Receipt Date" = 0D) and (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Positive Adjmt.") then
                                Rec."PO Number" := ItemLedgerEntry."Document No.";

                        if ItemLedgerEntry."Source Type" = ItemLedgerEntry."Source Type"::Vendor then
                            Rec."Vendor No." := ItemLedgerEntry."Source No.";

                    until (ItemLedgerEntry.Next = 0);
            end else begin
                ReservationEntry.Reset;
                ReservationEntry.SetRange("Item No.", pItemNo);
                ReservationEntry.SetRange("Lot No.", pLotNo);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype"::"1");
                if ReservationEntry.FindFirst then begin
                    Rec."PO Number" := ReservationEntry."Source ID";
                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - END

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date                     
                    Rec."OBF-Production Date" := ReservationEntry."OBF-Production Date";

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
                    if ReservationEntry."OBF-Purchaser Code" <> '' then
                        Rec."Buyer Code" := ReservationEntry."OBF-Purchaser Code";

                end;
            end;
            if Rec."On Hand Weight" <> 0 then
                Rec."Unit Cost" := Rec."Value of Inventory on Hand" / Rec."On Hand Weight"
            else
                Rec."Unit Cost" := 0;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
            // REVIEW LATER // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
            //     Rec."OBF-Purchased For" := ItemVariantLotInfo."Purchased For";

            Rec.Insert;
            i += 1;
        end;
    end;

    local procedure RecordExists(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[50]; pLocationCode: code[10]): Boolean;
    var
        result: Boolean;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Lot No.", pLotNo);
        Rec.SetRange("Variant Code", pVariantCode);
        Rec.SetRange("Location Code", pLocationCode);
        result := not Rec.IsEmpty;
        Rec.Reset;
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
        Rec.Reset;
    end;
}

