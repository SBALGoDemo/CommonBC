// namespace SilverBay.Common.System.Fields;

// using System.Security.AccessControl;
// using System.TestLibraries.Utilities;

// codeunit 80102 UTSystemFieldUtilities
// {
//     Subtype = Test;

//     trigger OnRun()
//     begin
//         //[FEATURE] UT SystemFieldMgmt
//     end;

//     var
//         Assert: Codeunit "Library Assert";
//         SystemFieldUtilities: Codeunit SystemFieldUtilities;
//         WrongFieldValueErr: Label 'Incorrect field value for %1.', Comment = '%1=FieldCaption of the field being tested';

//     [Test]
//     procedure TestGetUserNameFromSystemCreatedBy()
//     var
//         User: Record User;
//     begin
//         //[SCENARIO #0001] User Name associated with a given SystemCreatedBy value is retrieved correctly

//         // [GIVEN] a SystemCreatedBy value
//         User.FindFirst();

//         //[THEN] procedure returns the expected user name
//         this.Assert.AreEqual(User."User Name", this.SystemFieldUtilities.GetUserNameFromSecurityID(User."User Security ID"), StrSubstNo(this.WrongFieldValueErr, User.FieldCaption("User Name")));
//         this.Assert.AreEqual('', this.SystemFieldUtilities.GetUserNameFromSecurityID(CreateGuid()), StrSubstNo(this.WrongFieldValueErr, User.FieldCaption("User Name")));
//     end;
// }