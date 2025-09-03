// https://odydev.visualstudio.com/ThePlan/_workitems/edit/3006 - Add Posting Date to Posted Lines pages
namespace SilverBay.Common.Sales.Document;
using Microsoft.Sales.History;
pageextension 60109 PostedSalesInvoiceLines extends "Posted Sales Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field(SBSCOMPostingDate; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
    }
}