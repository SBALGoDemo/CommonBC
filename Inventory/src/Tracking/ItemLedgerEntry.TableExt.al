namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Setup;
using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from tableextension 50067 "ItemLedgerEntry" extends "Item Ledger Entry"
/// </summary>
tableextension 60300 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1319 - Missing Net Weight on Item Ledger and Reservation Entry 
        /// Migrated from field(51001; "OBF-Net Weight"; Decimal)
        /// </summary>
        field(60300; SBSINVNetWeight; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Net Weight for the quantity of of the item ledger entry.';
        }
    }

    // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
    procedure SBSINVUpdateLotNoInfoForItemLedgerEntry()
    var
        LotNoInformation: Record "Lot No. Information";
        InventorySetup: Record "Inventory Setup";
        Vendor: Record Vendor;
    begin
        if Rec."Lot No." = '' then
            exit;
        if Rec."Remaining Quantity" <= 0 then
            exit;
        if not LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := Rec."Item No.";
            LotNoInformation."Variant Code" := Rec."Variant Code";
            LotNoInformation."Lot No." := Rec."Lot No.";
            LotNoInformation.Description := '';
            LotNoInformation.Insert();
        end;
        LotNoInformation.SBSINVExpirationDate := Rec."Expiration Date";
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;
}