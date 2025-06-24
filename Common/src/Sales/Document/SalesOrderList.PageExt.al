namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2882 - Add Ship-to City to Sales Order List page
/// </summary>
pageextension 60103 SalesOrderList extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            /// <summary>
            /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2882 - Add Ship-to City to Sales Order List page
            /// </summary>
            field(SBSCOMShiptoCity; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the customer on the sales document.';
            }
        }
    }
}