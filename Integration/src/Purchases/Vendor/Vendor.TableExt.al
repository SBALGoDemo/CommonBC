namespace SilverBay.Integration.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

tableextension 60400 SBSINTVendor extends Vendor
{
    fields
    {
        /// <summary>
        /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2798
        /// </summary>
        field(60400; SBSINTIsCoupaVendor; Boolean)
        {
            Caption = 'Is Coupa Vendor';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the vendor is synchronized as part of integration with the Coupa app.';

            trigger OnValidate()
            var
                ConfirmCoupaVendorChangeQst: Label 'The "Is Coupa Vendor" field is used to control the integration of vendor records between BC and Coupa. Are you sure you want to continue with this change?';
            begin
                if GuiAllowed() then
                    if not Confirm(ConfirmCoupaVendorChangeQst) then begin
                        Rec := xRec;
                        SBSINTIsCoupaVendor := xRec.SBSINTIsCoupaVendor;
                        exit;
                    end;
            end;
        }
    }
}