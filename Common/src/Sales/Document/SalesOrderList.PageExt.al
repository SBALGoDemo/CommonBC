namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2882 - Add Ship-to City to Sales Order List page
/// I also moved other fields from the OrcaBay monolithic extension to this page extension.
/// </summary>
pageextension 60103 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Shipment Date")
        {
            Visible = true;
        }
        movefirst(Control1; "No.")

        addafter("Location Code")
        {
            field(SBSCOMShippingAgentCode; Rec."Shipping Agent Code") 
            { 
                ApplicationArea = All; 
            }
            field(SBSCOMShiptoCity; Rec."Ship-to City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the city of the customer on the sales document.';
            }
            field(SBSCOMShipToCounty; Rec."Ship-to County") 
            { 
                ApplicationArea = All; 
            }
        }

        addafter("Document Date")
        {
            field(SBSCOMOrderDate; Rec."Order Date") 
            { 
                ApplicationArea = All; 
            }
        }

    }
}