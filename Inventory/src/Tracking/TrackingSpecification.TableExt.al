// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
tableextension 60304 "Tracking Specification Ext" extends "Tracking Specification"
{
    fields
    {

        field(51020; SBSINVCountryOfOriginCode; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("Item No.")));
            fieldClass = Flowfield;
            Editable = false;
        }

        field(54001; SBSINVNewProductionDate; Date)
        {
            Caption = 'New Production Date';
        }
    }
}