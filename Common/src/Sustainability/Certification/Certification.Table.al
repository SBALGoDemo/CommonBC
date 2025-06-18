namespace SilverBay.Common.Sustainability.Certification;

/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/1669 - Sustainability Certifications
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2620 - Extract and Package Orca Bay Inv. Status by Date page for Deployment to Silver Bay
/// Migrated from table 50024 "OBF-Certification"
/// </summary>
table 60103 Certification
{
    // ObsoleteState = Removed; //TODO: Review this to confirm it is not obsoleted in the current code
    Caption = 'Certification';
    DataClassification = CustomerContent;
    LookupPageId = CertificationList;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the code for the Certification.';
            trigger OnValidate();
            begin
                this.SetIndentation();
            end;
        }
        field(2; "Parent Certification"; Code[20])
        {
            Caption = 'Parent Certification';
            TableRelation = Certification;
            ToolTip = 'Specifies the value of the Parent Certification field.';
            trigger OnValidate();
            begin
                this.SetIndentation();
            end;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
            ToolTip = 'Specifies a description of the Certification.';
        }
        field(9; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Indentation field.';
        }
        field(10; "Presentation Order"; Integer)
        {
            Caption = 'Presentation Order';
            ToolTip = 'Specifies the value of the Presentation Order field.';
        }
        field(11; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
        key(Key2; "Parent Certification")
        {
        }
        key(Key3; "Presentation Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "Has Children" then
            Error(this.DeleteWithChildrenErr);
    end;

    var
        DeleteWithChildrenErr: Label 'You cannot delete this Certification because it has child Certifications.';


    procedure HasChildren(): Boolean;
    var
        Certification: Record Certification;
    begin
        Certification.SetRange("Parent Certification", Code);
        exit(not Certification.IsEmpty)
    end;


    procedure GetStyleText(): Text;
    begin
        if Indentation = 0 then
            exit('Strong');

        if "Has Children" then
            exit('Strong');

        exit('');
    end;

    local procedure SetIndentation();
    begin
        if "Parent Certification" = '' then
            Indentation := 0
        else
            Indentation := 1;
    end;
}