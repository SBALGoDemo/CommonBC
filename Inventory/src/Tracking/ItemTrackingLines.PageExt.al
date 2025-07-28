// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
pageextension 60304 ItemTrackingLinesExt extends "Item Tracking Lines"
{
    layout
    {
        modify("Serial No.")
        {
            Visible = false;
        }

        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/2946 - Add Subform to Item Tracking Lines page
        addbefore(Control1)
        {
            part(LotAllocationSubpage; "Lot Allocation Subpage")
            {
                ApplicationArea = All;
            }
        }

        addlast(Control1)
        {
            field(SBSINVAlternateLotNo; LotNoInformation.SBSINVAlternateLotNo)
            {
                Caption = 'Alternate Lot No.';
                Editable = false;
                ApplicationArea = All;
            }

            field(SBSINVVessel; LotNoInformation.SBSINVVessel)
            {
                Caption = 'Vessel';
                Editable = false;
                ApplicationArea = All;
            }

            field(SBSINVLabel; LotNoInformation.SBSINVLabel)
            {
                Caption = 'Label';
                Editable = false;
                ApplicationArea = All;
            }
            field(VendorNo; LotNoInformation.SBSINVVendorNo)
            {
                Caption = 'Vendor No.';
                Editable = false;
                ApplicationArea = All;
            }
            field(VendorName; LotNoInformation.SBSINVVendorName)
            {
                Caption = 'Vendor Name';
                Editable = false;
                ApplicationArea = All;
            }
            field("Country of Origin Code"; Rec.SBSINVCountryOfOriginCode)
            {
                Caption = 'Country of Origin Code';
                Editable = false;
                ApplicationArea = All;
            }
            field(SBSINVContainerNo; LotNoInformation.SBSINVContainerNo)
            {
                Caption = 'Container No.';
                Editable = false;
                ApplicationArea = All;
            }

            field("Production Date"; LotNoInformation.SBSINVProductionDate)
            {
                Caption = 'Production Date';
                Editable = false;
                ApplicationArea = All;
            }
            field("New Production Date"; Rec.SBSINVNewProductionDate)
            {
                ApplicationArea = ItemTracking;
                Editable = NewExpirationDateEditable;
                ToolTip = 'Specifies a new Production date.';
                Visible = NewExpirationDateVisible;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if not LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            LotNoInformation.Init();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.LotAllocationSubpage.page.SetPageDataForItemVariant(Rec."Item No.", Rec."Variant Code", Rec."Location Code");
    end;

    var
        LotNoInformation: Record "Lot No. Information";
}