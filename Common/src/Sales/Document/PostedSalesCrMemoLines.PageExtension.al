// https://odydev.visualstudio.com/ThePlan/_workitems/edit/3006 - Add Posting Date to Posted Lines pages
namespace SilverBay.Common.Sales.Document;
using Microsoft.Sales.History;
pageextension 60108 PostedSalesCrMemoLines extends "Posted Sales Credit Memo Lines"
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