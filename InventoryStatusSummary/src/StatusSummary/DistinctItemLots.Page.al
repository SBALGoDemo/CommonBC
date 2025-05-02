namespace SilverBay.Inventory.StatusSummary;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/638 - Add Variant info to ISS
// https://odydev.visualstudio.com/ThePlan/_workitems/edit/678 - Item Factbox Issues

//  Note: This page was copied from and is similar to Page 50054 "Distinct Item Lots"

// https://odydev.visualstudio.com/ThePlan/_workitems/edit/664 - Inv. Status Summary page enhancements
// Drilldowns moved to Info Pane Management codeunit
page 60305 InventoryStatusSummaryByDate
{
    ApplicationArea = All;
    Caption = 'Inventory Status Summary by Date';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = DistinctItemLot;
    SourceTableTemporary = true;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field(DateFilter; this.DateFilter)
                {
                    Caption = 'As of Date Filter';
                    ToolTip = 'Specifies the value of the As of Date Filter field.';
                    trigger OnValidate()
                    begin
                        Rec.DeleteAll();
                        Rec.SetRange("Date Filter", 0D, this.DateFilter);
                        this.SetPageData(this.DateFilter);
                        Rec.FindFirst();
                        CurrPage.Update();
                        CurrPage."Item FactBox".Page.SetValues(this.DateFilter, '', true);
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Group';
                field(ItemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.ShowItem(Rec."Item No.");
                    end;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                    Width = 10;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Item Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description field.';
                    Width = 30;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    Caption = 'Item Description 2';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description 2 field.';
                    Width = 15;
                }
                field("Search Description"; Rec."Search Description")
                {
                    Caption = 'Search Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Search Description field.';
                    Width = 30;
                }
                field("Pack Size"; Rec."Pack Size")
                {
                    Caption = 'Pack Size';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Pack Size field.';
                    Visible = false;
                    Width = 10;
                }
                field("Method of Catch"; Rec."Method of Catch")
                {
                    Caption = 'Method of Catch';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Method of Catch field.';
                    Visible = false;
                    Width = 10;
                }
                field("Country of Origin"; Rec."Country of Origin")
                {
                    Caption = 'Country of Origin';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Country of Origin field.';
                    Width = 10;
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    Caption = 'Brand Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Brand Code field.';
                    Visible = false;
                    Width = 10;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                    Visible = true;
                    Width = 10;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                    Width = 10;
                }
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Alternate Lot No."; Rec."Alternate Lot No.")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }
                field("PO Number"; Rec."PO Number")
                {
                    Caption = 'PO Number';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PO Number field.';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.LocationOnDrillDown(Rec."Location Code");
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.VendorOnDrillDown(Rec."Vendor No.");
                    end;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Caption = 'Receipt Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receipt Date field.';
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                field("OBF-Production Date"; Rec."OBF-Production Date")
                {
                    Caption = 'Production Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Production Date field.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    Width = 10;
                }
                field("On Hand Quantity"; Rec."On Hand Quantity")
                {
                    Caption = 'On Hand Quantity';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Hand Quantity field.';
                    Width = 5;
                }
                field("On Order Quantity 2"; Rec."On Order Quantity 2")
                {
                    CaptionML = ENU = '+On Order Quantity';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Quantity field.';
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.OnOrderDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."Location Code");
                    end;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    CaptionML = ENU = '-Qty. on Sales Orders';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty. on Sales Orders field.';
                    Width = 5;
                }
                field("Total Available Quantity"; Rec."Total Available Quantity")
                {
                    CaptionML = ENU = 'Total Available Quantity';
                    Editable = false;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("On Hand Weight"; Rec."On Hand Weight")
                {
                    Caption = 'On Hand Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Hand Weight field.';
                    Visible = false;
                    Width = 10;
                }
                field("On Order Weight 2"; Rec."On Order Weight 2")
                {
                    CaptionML = ENU = '+On Order Weight';
                    Editable = false;
                    ToolTip = 'Specifies the value of the On Order Weight field.';
                    Visible = false;
                    Width = 10;
                }
                field("Net Weight on Sales Order"; Rec."Net Weight on Sales Order")
                {
                    CaptionML = ENU = '-Net Weight on Sales Orders';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Net Weight on Sales Orders field.';
                    Visible = false;
                    Width = 10;
                }
                field("Available Net Weight"; Rec."Available Net Weight")
                {
                    CaptionML = ENU = 'Available Net Weight';
                    Editable = false;
                    ToolTipML = ENU = '=On Hand Quantity + On Order Quantity - Quantity on Sales Orders';
                    Width = 10;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.TotalAvailQtyDrillDownByLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", this.DateFilter);
                    end;
                }
                field("Value of Inventory on Hand"; Rec."Value of Inventory on Hand")
                {
                    Caption = 'Value of Inventory on Hand.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Value of Inventory on Hand. field.';
                    Width = 10;
                }
                //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
                // field("Label Text"; Rec."Label Text")
                // {
                //     Editable = false;
                //     Width = 5;
                //     ApplicationArea = All;
                // }
                field("Buyer Code"; Rec."Buyer Code")
                {
                    Caption = 'Buyer Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Buyer Code field.';
                    Visible = false;
                    Width = 5;
                    trigger OnDrillDown()
                    begin
                        this.InfoPaneMgmt.BuyerOnDrillDown(Rec."Buyer Code");
                    end;
                }

                // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
                field("OBF-Purchased For"; Rec."OBF-Purchased For")
                {
                    Caption = 'Purchased For';
                    ToolTip = 'Specifies the value of the Purchased For field.';
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part("Item FactBox"; "OBF-Item Factbox")
            {
                ApplicationArea = Suite;
                Caption = 'OBF-Item Factbox';
                SubPageLink = "No." = field("Item No.");
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
                Caption = 'Get Data';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Get Data action.';
                trigger OnAction()
                begin
                    this.SetPageData(this.DateFilter);
                    Rec.FindFirst();
                    CurrPage.Update();
                end;
            }

            action("Show Source Document")
            {
                Caption = 'Show Source Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Show Source Document action.';
                trigger OnAction()
                begin
                    this.InfoPaneMgmt.PONumberOnDrillDown(Rec."PO Number");
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        DateFormula: DateFormula;
    begin
        Evaluate(DateFormula, '1Y');
        CurrPage.Editable(true);
        this.DateFilter := CalcDate(DateFormula, WorkDate());

        Rec.SetRange("Date Filter", 0D, this.DateFilter);
        Rec.DeleteAll();
        Rec."Item No." := ' ';
        Rec.Insert();

        Rec.SetCurrentKey("Item No.", "Variant Code", "Location Code", "Lot No.");
        Rec.FindFirst();
        CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage."Item FactBox".Page.SetValues(this.DateFilter, '', true);
    end;

    var
        InventorySetup: Record "Inventory Setup";
        InfoPaneMgmt: Codeunit "OBF-Info Pane Mgmt";
        DateFilter: Date;

    local procedure AddRecord(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[10]; pLocation: Code[10]; FromILE: Boolean; pDateFilter: Date; var pNextRowNo: Integer)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        UnassignedPurchaseLineQty: Decimal;
    //ItemVariantLotInfo: Record "OBF-Item Variant Lot Info";
    begin
        Item.Get(pItemNo);
        pNextRowNo += 1;
        Rec.Init();
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
            this.CalculateUnassigned(pItemNo, pVariantCode, pLocation, UnassignedPurchaseLineQty);
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

        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
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
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", pItemNo);
                ItemLedgerEntry.SetRange("Variant Code", pVariantCode);
                ItemLedgerEntry.SetRange("Location Code", pLocation);
                ItemLedgerEntry.SetRange("Lot No.", pLotNo);
                ItemLedgerEntry.SetRange("Posting Date", 0D, pDateFilter);
                Rec."Value of Inventory on Hand" := 0;
                if ItemLedgerEntry.FindSet() then
                    repeat
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        Rec."Value of Inventory on Hand" := Rec."Value of Inventory on Hand" + ItemLedgerEntry."Cost Amount (Expected)" +
                                ItemLedgerEntry."Cost Amount (Actual)";

                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1040 - Set Receipt Date on Item Ledger Entries
                        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                        //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
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
                    until (ItemLedgerEntry.Next() = 0);
            end else begin
                ReservationEntry.Reset();
                ReservationEntry.SetRange("Item No.", pItemNo);
                ReservationEntry.SetRange("Lot No.", pLotNo);
                ReservationEntry.SetRange("Source Type", 39);
                ReservationEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype"::"1");
                if ReservationEntry.FindFirst() then begin
                    Rec."PO Number" := ReservationEntry."Source ID";
                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - Add "Expected Receipt Date" to Inv. Status page
                    if PurchaseLine.Get(PurchaseLine."Document Type"::Order, Rec."PO Number", ReservationEntry."Source Ref. No.") then
                        Rec."Expected Receipt Date" := PurchaseLine."Expected Receipt Date";
                    //https://odydev.visualstudio.com/ThePlan/_workitems/edit/629 - END

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1378 -   Add Production Date to Inv. Status by Date
                    Rec."OBF-Production Date" := ReservationEntry.SBSISSProductionDate;

                    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1653 - Wrong Purchaser for Work Order Lots on ISS by Date
                    if ReservationEntry.SBSISSPurchaserCode <> '' then
                        Rec."Buyer Code" := ReservationEntry.SBSISSPurchaserCode;
                end;
            end;
            if Rec."On Hand Weight" <> 0 then
                Rec."Unit Cost" := Rec."Value of Inventory on Hand" / Rec."On Hand Weight"
            else
                Rec."Unit Cost" := 0;

            // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1654 - Need "Purchased For" field for lots
            //TODO: Review Later // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Migrate Inv. Status by Date page to Silver Bay
            // if ItemVariantLotInfo.Get(pItemNo, pVariantCode, pLotNo, pLocation) then
            //     Rec."OBF-Purchased For" := ItemVariantLotInfo."Purchased For";

            Rec.Insert();
        end;
    end;

    local procedure CalculateUnassigned(pItemNo: Code[20]; pVariantCode: Code[10]; pLocationCode: Code[20]; var UnassignedPurchaseLineQty: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        AssignedPurchaseLineQty: Decimal;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Variant Code", pVariantCode);
        Rec.SetRange("Location Code", pLocationCode);
        Rec.CalcSums("On Order Quantity 2", "On Order Weight 2");
        AssignedPurchaseLineQty := Rec."On Order Quantity 2";
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", pItemNo);
        PurchaseLine.SetRange("Variant Code", pVariantCode);
        PurchaseLine.SetRange("Location Code", pLocationCode);
        PurchaseLine.CalcSums("Outstanding Qty. (Base)");
        UnassignedPurchaseLineQty := PurchaseLine."Outstanding Qty. (Base)" - AssignedPurchaseLineQty;
        Rec.Reset();
    end;

    local procedure RecordExists(pItemNo: Code[20]; pVariantCode: Code[10]; pLotNo: Code[50]; pLocationCode: Code[10]): Boolean
    var
        result: Boolean;
    begin
        Rec.SetRange("Item No.", pItemNo);
        Rec.SetRange("Lot No.", pLotNo);
        Rec.SetRange("Variant Code", pVariantCode);
        Rec.SetRange("Location Code", pLocationCode);
        result := not Rec.IsEmpty;
        Rec.Reset();
        exit(result);
    end;

    local procedure SetPageData(pDateFilter: Date)
    var
        ItemT: Record Item;
        DistinctItemLotResEntry: Query DistinctItemLotResEntry;
        ISSDistinctItemLots: Query DistinctItemLotLocations;
        DistinctItemsOnPurchLine: Query "OBF-Dist. Items On Purch. Line";
        DistinctItemLocOnOrder: Query "OBF-Distinct Item Loc On Order";
        NextRowNo: Integer;
    begin
        Rec.DeleteAll();
        this.InventorySetup.Get();
        ISSDistinctItemLots.SetRange(Posting_Date_Filter, 0D, pDateFilter);
        ISSDistinctItemLots.Open();
        while ISSDistinctItemLots.Read() do
            if ISSDistinctItemLots.Item_Tracking_Code <> '' then
                if not this.RecordExists(ISSDistinctItemLots.Item_No, ISSDistinctItemLots.Variant_Code, ISSDistinctItemLots.Lot_No,
                                    ISSDistinctItemLots.Location_Code) then
                    this.AddRecord(ISSDistinctItemLots.Item_No, ISSDistinctItemLots.Variant_Code, ISSDistinctItemLots.Lot_No,
                              ISSDistinctItemLots.Location_Code, true, pDateFilter, NextRowNo);

        DistinctItemLotResEntry.Open();
        while DistinctItemLotResEntry.Read() do
            if DistinctItemLotResEntry.Item_Tracking_Code <> '' then
                if not this.RecordExists(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No,
                                    DistinctItemLotResEntry.Location_Code) then
                    this.AddRecord(DistinctItemLotResEntry.Item_No, DistinctItemLotResEntry.Variant_Code, DistinctItemLotResEntry.Lot_No,
                              DistinctItemLotResEntry.Location_Code, false, pDateFilter, NextRowNo);

        DistinctItemLocOnOrder.Open();
        while DistinctItemLocOnOrder.Read() do
            if this.InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemLocOnOrder.Item_No, ItemT) then
                if not this.RecordExists(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '', DistinctItemLocOnOrder.Location_Code) then
                    this.AddRecord(DistinctItemLocOnOrder.Item_No, DistinctItemLocOnOrder.Variant_Code, '',
                              DistinctItemLocOnOrder.Location_Code, false, pDateFilter, NextRowNo);

        DistinctItemsOnPurchLine.Open();
        while DistinctItemsOnPurchLine.Read() do
            if this.InfoPaneMgmt.CheckItemTrackingCodeNotBlank(DistinctItemsOnPurchLine.Item_No, ItemT) then
                if not this.RecordExists(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '', DistinctItemsOnPurchLine.Location_Code) then
                    this.AddRecord(DistinctItemsOnPurchLine.Item_No, DistinctItemsOnPurchLine.Variant_Code, '',
                              DistinctItemsOnPurchLine.Location_Code, false, pDateFilter, NextRowNo);
    end;
}