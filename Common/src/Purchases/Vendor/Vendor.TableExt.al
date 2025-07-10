namespace SilverBay.Common.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2922 - Add Bank Info Indicators to Vendor and Vendor Bank Account Pages
/// </summary>
tableextension 60107 Vendor extends Vendor
{
    fields
    {
        field(60100; SBSCOMNoOfBankAccounts; Integer)
        {
            Caption = 'No. of Bank Accounts';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Vendor Bank Account" where("Vendor No." = field("No.")));
            ToolTip = 'Specifies the number of bank account records that have been created for the vendor.';
        }
    }
}