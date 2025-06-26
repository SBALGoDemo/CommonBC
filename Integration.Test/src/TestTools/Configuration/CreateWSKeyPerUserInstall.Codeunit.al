namespace SilverBay.Integration.TestTools.Configuration;

using System.Security.AccessControl;

codeunit 80403 CreateWSKeyPerUserInstall
{
    Access = Internal;
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        this.SetWebServicesKeyPerUser();
    end;

    local procedure SetWebServicesKeyPerUser()
    var
        User: Record User;
        IdentityManagement: Codeunit "Identity Management";
    begin
        User.SetLoadFields("User Security ID");
        if User.FindSet() then
            repeat
                if IdentityManagement.GetWebServicesKey(User."User Security ID") = '' then
                    IdentityManagement.CreateWebServicesKeyNoExpiry(User."User Security ID");
            until User.Next() = 0;
    end;
}