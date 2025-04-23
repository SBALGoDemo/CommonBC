namespace SilverBay.Common.Reporting.Extension;

/// <summary>
/// Design of this object is related to: https://alguidelines.dev/docs/patterns/facade-pattern/
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2382
/// </summary>
codeunit 60101 ReportExtTempTableMgtImpl
{
    Access = Internal;

    procedure CopySharedTable(var RecordRef: RecordRef; var TempRecordRef: RecordRef)
    begin
        if RecordRef.IsTemporary and (TempRecordRef.Number = 0) then begin
            TempRecordRef.Open(RecordRef.RecordId.TableNo(), true);
            TempRecordRef.Copy(RecordRef, true);
        end
    end;

    procedure SetSharedTable(var TempRecordVariant: Variant; var TempRecordRef: RecordRef)
    begin
        TempRecordRef.SetTable(TempRecordVariant, true);
    end;
}