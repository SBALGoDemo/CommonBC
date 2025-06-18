namespace SilverBay.Inventory.StatusSummary.Sales;

using Microsoft.Sales.Document;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620
/// Migrated from codeunit 50050 "OBF-Sales Events"
/// </summary>
codeunit 60300 SalesHeaderSubscribers
{
    Access = Internal;
    SingleInstance = true;

    /// <summary>
    /// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1182 - Rebates
    /// </summary>
    /// <param name="SalesLine"></param>
    /// <param name="TempSalesLine"></param>
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCreateSalesLine', '', false, false)]
    local procedure SetAllocatedQuantityOnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary);
    begin
        SalesLine.SBSINVAllocatedQuantity := TempSalesLine.SBSINVAllocatedQuantity;
        SalesLine.Modify();
    end;
}