// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2942 - Add Custom Fields to Lot No. Information Table
pageextension 60305 LotNoInformationCardExt extends "Lot No. Information Card"
{
    layout
    {
        addlast(content)
        {
            group(SBSINV_CustomFields)
            {
                Caption = 'Silver Bay Custom Fields';
                field(SBSINVAlternateLotNo; Rec.SBSINVAlternateLotNo)
                {
                    ApplicationArea = All;
                    Caption = 'Alternate Lot No.';
                    Editable = false;
                }
                field(SBSINVLabel; Rec.SBSINVLabel)
                {
                    ApplicationArea = All;
                    Caption = 'Label';
                    Editable = false;
                }
                field(SBSINVVessel; Rec.SBSINVVessel)
                {
                    ApplicationArea = All;
                    Caption = 'Vessel';
                    Editable = false;
                }
                field(SBSINVContainerNo; Rec.SBSINVContainerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Container No.';
                    Editable = false;
                }
                field(SBSINVProductionDate; Rec.SBSINVProductionDate)
                {
                    ApplicationArea = All;
                    Caption = 'Production Date';
                    Editable = false;
                }
                field(SBSINVExpirationDate; Rec.SBSINVExpirationDate)
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                    Editable = false;
                }
                field(SBSINVVendorNo; Rec.SBSINVVendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    Editable = false;
                }
                field(SBSINVVendorName; Rec.SBSINVVendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(SBSINVIsAvailable; Rec.SBSINVIsAvailable)
                {
                    ApplicationArea = All;
                    Caption = 'Is Available';
                    Editable = false;
                }
            }
        }
    }
}