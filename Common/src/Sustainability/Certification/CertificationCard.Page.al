namespace SilverBay.Common.Sustainability.Certification;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from page 50043 "OBF-Certification Card"
/// </summary>
page 60108 CertificationCard
{
    Caption = 'Certification Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Certification;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    NotBlank = true;
                }
                field(Name; Rec.Name)
                {
                }
                field("Parent Certification"; Rec."Parent Certification")
                {
                }
                field(Indentation; Rec.Indentation)
                {
                }
                field("Presentation Order"; Rec."Presentation Order")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Enabled = (NOT Rec."Has Children");
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Delete the record.';

                trigger OnAction();
                begin
                    if Confirm(StrSubstNo(DeleteQst, Rec.Code)) then
                        Rec.Delete(true);
                end;
            }
        }
    }

    var
        DeleteQst: Label 'Delete %1?', Comment = '%1 = certification code';
}