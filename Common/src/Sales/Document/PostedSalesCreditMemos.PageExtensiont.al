// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2911 - Add "External Document No." field to SB Posted Sales Credit Memos page   

namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.History;
pageextension 60107 PostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Ship-to County";Rec."Ship-to County")
            {
                ApplicationArea = All;
            }
            field("External Document No.";Rec."External Document No.")
            {
                ApplicationArea = All;
            }   
        }

    }
}