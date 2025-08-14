namespace SilverBay.Inventory.Tracking;

using Microsoft.Foundation.Address;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;


/// <summary>
/// https://odydev.visualstudio.com/ThePlan/_workitems/edit/2854 - Migrate Item Tracking Lines page enhancements to Silver Bay
/// </summary>

tableextension 60304 TrackingSpecification extends "Tracking Specification"
{
    fields
    {
        field(60310; SBSINVNewProductionDate; Date)
        {
            Caption = 'New Production Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the new production date of the lot.';
        }
        field(60330; SBSINVCountryOfOriginCode; Code[10])
        {
            CalcFormula = lookup(Item."Country/Region of Origin Code" where("No." = field("Item No.")));
            Caption = 'Country/Region of Origin Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
            ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
        }
    }
}