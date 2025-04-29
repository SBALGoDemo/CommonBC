namespace SilverBay.Integration.TestTools.Configuration;

using System.Security.AccessControl;

codeunit 80401 LibraryGraphMgtEventSubs
{
    Access = Internal;
    SingleInstance = true;

    var
        IdentityManagement: Codeunit "Identity Management";
        SecretText: SecretText;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Graph Mgt", 'OnAfterInitializeWebRequestWithURL', '', false, false)]
    local procedure OnAfterInitializeWebRequestWithURL(var HttpWebRequestMgt: Codeunit System.Integration."Http Web Request Mgt.")
    begin
        if this.SecretText.IsEmpty() then
            this.SecretText := this.IdentityManagement.GetWebServicesKey(UserSecurityId());

        HttpWebRequestMgt.AddBasicAuthentication(UserId(), this.SecretText);
    end;
}