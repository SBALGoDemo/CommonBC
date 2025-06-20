namespace SilverBay.Common.Reporting.Extension;

/// <summary>
/// Exposes functionality for making the content of a temporary record accessible outside of its original scope; for example,
/// from a report object for use in a report extension object.
/// Design of this object is related to: https://alguidelines.dev/docs/patterns/facade-pattern/
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2382
/// </summary>
codeunit 60100 ReportExtTempTableMgt
{
    Access = Public;

    /// <summary>
    /// Causes the TempRecordRef variable to refer to the same temp record instance represented by the RecordRef variable.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/recordref/recordref-copy-recordref-boolean-method
    /// </summary>
    /// <param name="RecordRef">A RecordRef variable where a call to IsTemporary() would return "true".</param>
    /// <param name="TempRecordRef">A RecordRef variable where a call to IsTemporary() would return "true".</param>
    procedure CopySharedTable(var RecordRef: RecordRef; var TempRecordRef: RecordRef)
    var
        ReportExtTempTableMgtImpl: Codeunit ReportExtTempTableMgtImpl;
    begin
        ReportExtTempTableMgtImpl.CopySharedTable(RecordRef, TempRecordRef);
    end;

    /// <summary>
    /// Causes the TempRecordRef variable to refer to the same temp record instance represented by the TempRecordVariant variable.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/recordref/recordref-settable-table-boolean-method
    /// </summary>
    /// <param name="TempRecordVariant">A Variant variable where a call to IsRecord() would return "true" and the contained record was temporary.</param>
    /// <param name="TempRecordRef">A RecordRef variable where a call to IsTemporary() would return "true".</param>
    procedure SetSharedTable(var TempRecordVariant: Variant; var TempRecordRef: RecordRef)
    var
        ReportExtTempTableMgtImpl: Codeunit ReportExtTempTableMgtImpl;
    begin
        ReportExtTempTableMgtImpl.SetSharedTable(TempRecordVariant, TempRecordRef);
    end;
}