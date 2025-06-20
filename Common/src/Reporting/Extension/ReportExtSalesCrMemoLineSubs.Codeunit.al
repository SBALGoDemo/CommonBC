namespace SilverBay.Common.Reporting.Extension;

using Microsoft.Sales.History;

/// <summary>
/// Provides an interface for making the contents of the TempSalesCrMemoLine record variable in standard report 10073 "Sales Credit Memo NA" accessible in a Report Extension object.
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2382
/// </summary>
codeunit 60102 ReportExtSalesCrMemoLineSubs implements IReportExtensionTempRecordHandler
{
    EventSubscriberInstance = Manual;
    SingleInstance = true;

    var
        TempRecordRef: RecordRef;

    /// <summary>
    /// Binds the event subscriber methods in the codeunit to the current codeunit instance for handling the events that they subscribe to
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-eventsubscriberinstance-property and
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/session/session-bindsubscription-method
    /// </summary>
    procedure Bind()
    begin
        BindSubscription(this);
    end;

    /// <summary>
    /// Causes the codeunit's global TempRecordRef variable to refer to the same temp record variable instance used in the base report
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/recordref/recordref-copy-recordref-boolean-method
    /// </summary>
    /// <param name="RecordRef">A RecordRef variable (which has been initialized in this codeunit's event subscriber) that points to the same instance of the base report's temporary record.</param>
    procedure CopySharedTable(var RecordRef: RecordRef)
    var
        ReportExtTempTableMgt: Codeunit ReportExtTempTableMgt;
    begin
        ReportExtTempTableMgt.CopySharedTable(RecordRef, this.TempRecordRef);
    end;

    /// <summary>
    /// Causes the Report Extensions global TempRecord variable to refer to the same temp record variable instance used in the base report
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/recordref/recordref-settable-table-boolean-method
    /// </summary>
    /// <param name="TempRecordVariant">The Report Extension's new "TempRecord" variable passed as a variant so that it can be pointed to the same instance of the base report's temporary record.</param>
    procedure SetSharedTable(var TempRecordVariant: Variant)
    var
        ReportExtTempTableMgt: Codeunit ReportExtTempTableMgt;
    begin
        ReportExtTempTableMgt.SetSharedTable(TempRecordVariant, this.TempRecordRef);
    end;

    /// <summary>
    /// Unbinds the event subscriber methods from in the codeunit instance.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-eventsubscriberinstance-property and
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/session/session-unbindsubscription-method
    /// </summary>
    procedure Unbind()
    begin
        UnbindSubscription(this);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure CopyTempSalesCrMemoLineOnBeforeInsertEvent(var Rec: Record "Sales Cr.Memo Line"; RunTrigger: Boolean)
    var
        NewRecRef: RecordRef;
    begin
        NewRecRef.GetTable(Rec);
        this.CopySharedTable(NewRecRef);
    end;
}