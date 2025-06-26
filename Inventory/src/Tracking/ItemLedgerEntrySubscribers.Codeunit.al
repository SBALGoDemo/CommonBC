namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

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
    end;
}