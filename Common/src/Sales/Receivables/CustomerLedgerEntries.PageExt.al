namespace SilverBay.Common.Sales.Receivables;

using Microsoft.Sales.Receivables;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2862
/// Migrated from pageextension 50036 "OBF-Customer Ledger Entries" extends "Customer Ledger Entries"
/// </summary>
pageextension 60107 CustomerLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        // https://odydev.visualstudio.com/ThePlan/_workitems/edit/1675 - Page Cleanup
        modify("External Document No.")
        {
            Visible = true;
        }
    }
}