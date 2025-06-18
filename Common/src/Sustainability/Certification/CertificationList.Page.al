namespace SilverBay.Common.Sustainability.Certification;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from page 50044 "OBF-Certification List"
/// /// </summary>
page 60107 CertificationList
{
    // Caption = 'Certification List';
    Caption = 'Temp Common Cert List'; //TODO: Revert this caption following testing
    CardPageID = CertificationCard;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Certification;
    SourceTableView = SORTING("Presentation Order");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Code";
                ShowAsTree = true;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    trigger OnValidate();
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parent Certification"; Rec."Parent Certification")
                {
                    Visible = false;
                }
                field(Indentation; Rec.Indentation)
                {
                    Visible = false;
                }
                field("Presentation Order"; Rec."Presentation Order")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnAfterGetRecord();
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    var
        StyleTxt: Text;
}