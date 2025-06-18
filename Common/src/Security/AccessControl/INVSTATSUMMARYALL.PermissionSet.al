// namespace SilverBay.Common.Security.AccessControl;

// using SilverBay.Common.Inventory.Item;
// // using SilverBay.Common.Sales.Document;
// using SilverBay.Common.Inventory.Tracking;
// using SilverBay.Common.Inventory.Availability;
// using SilverBay.Common.Inventory.Status;

// permissionset 60100 INVSTATSUMMARYALL
// {
//     Assignable = true;
//     Caption = 'Inventory Status Summary - All';
//     Permissions = tabledata DistinctItemLot = RIMD,
//         tabledata ItemAvailabilityBuffer = RIMD,
//         table DistinctItemLot = X,
//         table ItemAvailabilityBuffer = X,
//         codeunit InfoPaneMgmt = X,
//         page DistinctItemLotList = X,
//         page InventoryStatusSummaryByDate = X,
//         page "Item Factbox" = X,
//         page ItemAvailabilityDrilldown = X,
//         // page SalesLines = X,
//         query DistinctItemLocationPurchLine = X,
//         query DistinctItemLocationResEntry = X,
//         query DistinctItemLotLocationILE = X,
//         query DistinctItemLotLocResEntry = X;
// }