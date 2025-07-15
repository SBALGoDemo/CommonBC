namespace SilverBay.Common.Reporting.Customer;

using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;

/// <summary>
/// Silver Bay's extension of the Standard Statement report.
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2862
/// </summary>
reportextension 60100 StandardStatement extends "Standard Statement"
{
    dataset
    {
        add(integer)
        {
            column(SBSCOMExternalDocumentNo_CustLedgEntryCaption; CustomerPOTxt)
            {
            }
        }
        modify(DtldCustLedgEntries)
        {
            trigger OnAfterAfterGetRecord()
            begin
                ExternalDocumentNo := '';
                CustLedgEntry.Reset();
                CustLedgEntry.SetLoadFields("External Document No.");
                if CustLedgEntry.Get(DtldCustLedgEntries."Cust. Ledger Entry No.") then
                    ExternalDocumentNo := CustLedgEntry."External Document No.";
            end;
        }
        add(DtldCustLedgEntries)
        {
            column(SBSCOMExternalDocumentNo_DtldCustLedgEntries; ExternalDocumentNo)
            {
            }
        }
        add(OverdueVisible)
        {
            column(SBSCOMExternalDocumentNo_CustLedgEntry2Caption; CustomerPOTxt)
            {
            }
        }
        add(CustLedgEntry2)
        {
            column(SBSCOMExternalDocumentNo_CustLedgEntry2; "External Document No.")
            {
            }
        }
    }

    rendering
    {
        layout(SBSCOMStandardStatement)
        {
            Type = Word;
            LayoutFile = './src/Reporting/Customer/Layout/SBSCOMStandardStatement.docx';
            Caption = 'Silver Bay''s / Orca Bay''s Standard Customer Statement (Word)';
            Summary = 'The Standard Customer Statement (Word) provides a basic layout.';
        }
    }

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ExternalDocumentNo: Code[35];
        CustomerPOTxt: label 'Customer PO';
}