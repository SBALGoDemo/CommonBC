namespace SilverBay.Inventory.Tracking;

using Microsoft.Inventory.Tracking;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
/// </summary>
pageextension 60305 LotNoInformationCard extends "Lot No. Information Card"
{
    layout
    {
        addlast(content)
        {
            group(SBSINVCustomFields)
            {
                Caption = 'Silver Bay Custom Fields';
                field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
                {
                    ApplicationArea = All;
                    Caption = 'Alternate Lot No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Alternate Lot No. field.';
                }
                field(SBSINVLabel; Rec.SBSINVLabel)
                {
                    ApplicationArea = All;
                    Caption = 'Label';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Label field.';
                }
                field(SBSINVVessel; Rec.SBSINVVessel)
                {
                    ApplicationArea = All;
                    Caption = 'Vessel';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vessel field.';
                }
                field(SBSINVContainerNo; Rec.SBSINVContainerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Container No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Container No. field.';
                }
                field(SBSINVProductionDate; Rec.SBSINVProductionDate)
                {
                    ApplicationArea = All;
                    Caption = 'Production Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Production Date field.';
                }
                field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field(SBSINVVendorNo; Rec.SBSINVVendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field(SBSINVVendorName; Rec.SBSINVVendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(SBSINVIsAvailable; Rec.SBSINVIsAvailable)
                {
                    ApplicationArea = All;
                    Caption = 'Is Available';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Is Available field.';
                }
            }
        }
    }
}