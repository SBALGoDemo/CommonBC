namespace SilverBay.Inventory.Security;

using SilverBay.Inventory.Tracking;
using SilverBay.Inventory.System;
using SilverBay.Inventory.Status;

permissionset 60300 SBSINVInventoryAll
{
    Assignable = true;
    Caption = 'Silver Bay Seafoods Inventory - All';
    Permissions = tabledata DistinctItemLot = RIMD,
        tabledata ItemAvailabilityBuffer = RIMD,
        table DistinctItemLot = X,
        table ItemAvailabilityBuffer = X,
        codeunit InfoPaneMgmt = X,
        codeunit ItemLedgerEntrySubscribers = X,
        codeunit SalesHeaderSubscribers = X,
        page DistinctItemLotList = X,
        page InventoryStatusSummaryByDate = X,
        page ItemAvailabilityDrilldown = X,
        page ItemFactbox = X,
        page SalesLines = X,
        query DistinctItemLocationPurchLine = X,
        query DistinctItemLocationResEntry = X,
        query DistinctItemLotLocationILE = X,
        query DistinctItemLotLocResEntry = X;
}