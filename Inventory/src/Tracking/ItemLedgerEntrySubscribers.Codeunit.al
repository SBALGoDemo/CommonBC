namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620
/// Migrated from codeunit 50051 "OBF-Purchasing Events"
/// </summary>
codeunit 60301 ItemLedgerEntrySubscribers
{
    Access = Internal;
    SingleInstance = true;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
    /// </summary>
    /// <param name="Rec"></param>
    /// <param name="RunTrigger"></param>
    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertItemLedgerEntry(var Rec: Record "Item Ledger Entry"; RunTrigger: Boolean)
    var
        Item: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        Item.Get(Rec."Item No.");
        Rec.SBSINVNetWeight := Rec.Quantity * Item."Net Weight";

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
        Rec.SBSINVSetCustomFieldsFromItemLedgerEntry();

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2964 - Add Lot Related Fields to Item Ledger Entry
        Rec.SBSINVSetCustomFieldsFromLotNoInformation();
    end;

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyItemLedgerEntry(var Rec: Record "Item Ledger Entry"; xRec: Record "Item Ledger Entry")
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if Rec.IsTemporary then
            exit;
        if Rec."Lot No." = '' then
            exit;
        if Rec."Remaining Quantity" = xRec."Remaining Quantity" then
            exit;
        if (Rec."Remaining Quantity" = 0) and (xRec."Remaining Quantity" > 0) then
            if LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then begin
                LotNoInformation.SBSINVIsAvailable := false;
                LotNoInformation.Modify(true);
            end;
    end;
}