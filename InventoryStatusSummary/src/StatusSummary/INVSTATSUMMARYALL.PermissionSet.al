namespace SilverBay.Inventory.StatusSummary;

permissionset 60300 INVSTATSUMMARYALL
{
    Assignable = true;
    Caption = 'Inventory Status Summary - All';
    Permissions = tabledata DistinctItemLot = RIMD,
        tabledata ItemAvailabilityBuffer = RIMD,
        table DistinctItemLot = X,
        table ItemAvailabilityBuffer = X,
        codeunit InfoPaneMgmt = X,
        page "Distinct Item Lot List" = X,
        page InventoryStatusSummaryByDate = X,
        page "Item Factbox" = X,
        page ItemAvailabilityDrilldown = X,
        page SalesLines = X,
        query DistinctItemLocationPurchLine = X,
        query DistinctItemLocationResEntry = X,
        query DistinctItemLotLocationILE = X,
        query DistinctItemLotLocResEntry = X;
}