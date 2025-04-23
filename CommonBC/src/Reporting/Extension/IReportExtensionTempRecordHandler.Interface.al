namespace SilverBay.Common.Reporting.Extension;

/// <summary>
/// Used for making the content of a temporary record accessible outside of its original scope; for example, from a report object for use in a report extension object.
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2382
/// </summary>
interface IReportExtensionTempRecordHandler
{
    /// <summary>
    /// Binds the event subscriber methods in the codeunit to the current codeunit instance for handling the events that they subscribe to.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-eventsubscriberinstance-property and
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/session/session-bindsubscription-method
    /// </summary>
    procedure Bind()

    /// <summary>
    /// Causes a codeunit's global RecordRef variable to refer to the same temp record (RecordRef) supplied by the caller.
    /// </summary>
    /// <param name="RecordRef">A RecordRef variable supplied by the caller.</param>
    procedure CopySharedTable(var RecordRef: RecordRef)

    /// <summary>
    /// Causes a Report Extension's global TempRecord (TempRecordVariant) to refer to the same temp record variable instance used in the base report.
    /// </summary>
    /// <param name="TempRecordVariant">A Variant variable supplied by the caller.</param>
    procedure SetSharedTable(var TempRecordVariant: Variant)

    /// <summary>
    /// Unbinds the event subscriber methods from in the codeunit instance.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-eventsubscriberinstance-property and
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/session/session-unbindsubscription-method
    /// </summary>
    procedure Unbind()
}
