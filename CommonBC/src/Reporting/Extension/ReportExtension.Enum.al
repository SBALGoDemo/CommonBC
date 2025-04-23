namespace SilverBay.Common.Reporting.Extension;

/// <summary>
/// The reports Silver Bay has extended where access to a base report's temporary record variable is needed.
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2382
/// </summary>
enum 60100 ReportExtension implements IReportExtensionTempRecordHandler
{
    Extensible = false;

    /// <summary>
    /// Standard report 10073 (Sales Credit Memo NA)
    /// </summary>
    value(10073; "Sales Credit Memo NA")
    {
        Caption = 'Sales Credit Memo NA';
        Implementation = IReportExtensionTempRecordHandler = ReportExtSalesCrMemoLineSubs;
    }
}