namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;
using SilverBay.Common.System.Fields;

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
        addlast(Control1)
        {
            field(SBSCOMCreatedByUser; SystemFieldUtilities.GetUserNameFromSecurityID(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Caption = 'Created by User';
                ToolTip = 'Specifies the User Name of the user who originally created the order record.';
            }
        }
    }

    var
        SystemFieldUtilities: Codeunit SystemFieldUtilities;
}