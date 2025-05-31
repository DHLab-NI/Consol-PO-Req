pageextension 50109 ReqSalesLinesExt extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("B2B Purch. Order No."; Rec."B2B Purch. Order No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }
        addafter("B2B Purch. Order No.")
        {
            field("B2B Purch. Order Line No."; Rec."B2B Purch. Order No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    var

}

