namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;

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
            ToolTip = 'Specifies the Net Weight for the quantity of the item ledger entry.';
        }
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2964 - Add Lot Related Fields to Item Ledger Entry
        /// </summary>
        field(60302; SBSINVOriginalLotNo; Code[50])
        {
            Caption = 'Original Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the original lot number of the item ledger entry.';
        }
        field(60303; SBSINVAlternateLotNo; Code[50])
        {
            Caption = 'Alternate Lot No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the alternate lot number of the item ledger entry.';
        }
        field(60304; SBSINVLabel; Text[50])
        {
            Caption = 'Label';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the label value of the item ledger entry.';
        }
        field(60310; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the vessel of the item ledger entry.';
        }
        field(60311; SBSINVContainerNo; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the container number of the item ledger entry.';
        }
        field(60312; SBSINVProductionDate; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the production date of the item ledger entry.';
        }
    }

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2964 - Add Lot Related Fields to Item Ledger Entry
    /// Copies custom field values from the Lot No. Information record (if it exists) to the Item Ledger Entry.
    /// </summary>
    internal procedure SBSINVSetCustomFieldsFromLotNoInformation()
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if this.GetLotNoInformation(LotNoInformation) then begin
            Rec.SBSINVOriginalLotNo := LotNoInformation.SBSINVOriginalLotNo;
            Rec.SBSINVAlternateLotNo := LotNoInformation.SBSINVAlternateLotNo;
            Rec.SBSINVLabel := LotNoInformation.SBSINVLabel;
            Rec.SBSINVVessel := LotNoInformation.SBSINVVessel;
            Rec.SBSINVContainerNo := LotNoInformation.SBSINVContainerNo;
            Rec.SBSINVProductionDate := LotNoInformation.SBSINVProductionDate;
        end;
    end;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
    /// Copies custom field values from the Item Ledger Entry record to the Lot No. Information record.    
    /// </summary>
    internal procedure SBSINVSetCustomFieldsFromItemLedgerEntry()
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if Rec."Lot No." = '' then
            exit;
        if Rec."Remaining Quantity" <= 0 then
            exit;

        if not this.GetLotNoInformation(LotNoInformation) then
            LotNoInformation.SBSINVCreateLotNoInformation('', Rec."Item No.", Rec."Variant Code", Rec."Lot No.");

        LotNoInformation.SBSINVExpirationDate := Rec."Expiration Date";
        LotNoInformation.SBSINVIsAvailable := true;
        LotNoInformation.Modify();
    end;

    /// <summary>
    /// Gets the Lot No. Information record for the current Item Ledger Entry if it exists.
    /// </summary>
    /// <param name="LotNoInformation"></param>
    /// <returns></returns>
    internal procedure GetLotNoInformation(var LotNoInformation: Record "Lot No. Information"): Boolean
    begin
        exit(LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No."));
    end;
}