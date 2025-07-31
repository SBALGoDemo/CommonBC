pageextension 60321 PurchSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            group(SBSINV_CustomFields)
            {
                Caption = 'Silver Bay Custom Fields';
                field(SBSINVEnableSetExpDate; Rec.SBSINVEnableSetExpDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to enable setting the expiration date based on the production date.';
                }
            }
        }
    }
}