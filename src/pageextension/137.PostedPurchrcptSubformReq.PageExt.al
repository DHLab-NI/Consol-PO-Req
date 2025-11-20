pageextension 50105 PostedPurchrcptSubformReqExt extends "Posted Purchase Rcpt. Subform"
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
        addafter("B2B Sales Order Line No.")
        {
            field("B2B Modified"; Rec."B2B Modified")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Modified';
            }
        }
        addafter("B2B Modified")
        {
            field("B2B Modified Description"; Rec."B2B Modified Description")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Modified Description';
            }
        }
    }

    actions
    {
    }

    var

}