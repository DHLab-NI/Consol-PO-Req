pageextension 50107 PurchOrderArchiveSubfrmReqExt extends "Purchase Order Archive Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("B2B Sales Order No."; Rec."B2B Sales Order No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Sales Order No.';

                // Open sales order on drilldown
                DrillDown = true;
                trigger OnDrillDown()
                var
                    B2BOrderMatching: Codeunit B2BOrderMatching;

                begin
                    B2BOrderMatching.OpenB2BSalesOrder(Rec."B2B Sales Order No.");
                end;
            }
        }
        addafter("B2B Sales Order No.")
        {
            field("B2B Sales Order Line No."; Rec."B2B Sales Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Sales Order Line No.';
            }
        }
    }

    actions
    {
    }

    var

}