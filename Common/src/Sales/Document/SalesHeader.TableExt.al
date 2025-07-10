namespace SilverBay.Common.Sales.Document;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2882 - Add Ship-to City to Sales Order List page
/// The tooltip values below were cloned from those specified in MS's base application object page 42 "Sales Order" 
/// Specifying the tooltips for the fields in the Sales Header table extension eliminates the need to specify them in the Sales Order List page extension.
/// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-table-object#add-tooltips-on-table-fields
/// </summary>
tableextension 60106 SalesHeader extends "Sales Header"
{
    fields
    {
        modify("Order Date")
        {
            ToolTip = 'Specifies the date the order was created. The order date is also used to determine the prices and discounts on the document.';
        }
        modify("Ship-to City")
        {
            ToolTip = 'Specifies the city of the customer on the sales document.';
        }
        modify("Ship-to County")
        {
            ToolTip = 'Specifies the state, province or county of the address.';
        }
        modify("Shipping Agent Code")
        {
            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
        }
    }
}