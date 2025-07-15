// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;
using Microsoft.Purchases.Vendor;
tableextension 60305 SBSINVLotNoInformation extends "Lot No. Information"
{
    fields
    {
        field(60300; "SBSINVOriginalLotNo"; Code[20])
        {
            Caption = 'Original Lot No.';
            Editable = false;
        }
        field(60305; SBSINVAlternateLotNo; Code[20])
        {
            Caption = 'Alternate Lot No.';
        }
        field(60310; SBSINVLabel; Text[50])
        {
            Caption = 'Label';
        }
        field(60315; "SBSINVVendorNo"; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(60320; "SBSINVVendorName"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(60325; SBSINVVessel; Text[50])
        {
            Caption = 'Vessel';
            Editable = false;
        }
        field(60330; "SBSINVContainerNo"; Code[20])
        {
            Caption = 'Container No.';
        }
        field(60340; "SBSINVProductionDate"; Date)
        {
            Caption = 'Production Date';
        }
        field(60345; "SBSINVExpirationDate"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(60350; "SBSINVIsAvailable"; Boolean)
        {
            Caption = 'Is Available';
            Editable = false;
        }
    }
}