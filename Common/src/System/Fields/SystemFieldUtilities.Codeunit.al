namespace SilverBay.Common.System.Fields;

using System.Security.AccessControl;

/// <summary>
/// Contains procedures for getting additional information based on BC's various system fields.
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2882 - Add Ship-to City to Sales Order List page
/// </summary>
codeunit 60109 SystemFieldUtilities
{
    /// <summary>
    /// Gets the user name associated with a SystemCreatedBy value which is a Guid representing the user who created the record.
    /// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-table-system-fields
    /// </summary>
    /// <param name="UserSecurityID">SystemCreatedBy field value (Guid) from the record from which to get the user name value</param>
    /// <returns>User Name from the User record linked to the SystemCreatedBy param</returns>
    procedure GetUserNameFromSecurityID(UserSecurityID: Guid) Username: Code[50]
    var
        User: Record User;
    begin
        if User.Get(UserSecurityID) then
            Username := User."User Name";
    end;
}