pageextension 50101 PurchRcptLinesReq extends "Posted Purchase Receipt Lines"
{
    layout
    {
        modify(Control1900383207)
        {
            Visible = true;
        }

        modify(Control1905767507)
        {
            Visible = true;
        }


        addlast(FactBoxes)
        {
            part(Control50000; "Related Sales Order FactBox")
            {
                ApplicationArea = Planning;
                SubPageLink = "Document No." = field("Sales Order No."), "Line No." = field("Sales Order Line No.");
                Visible = true;
            }
        }
    }

    actions
    {
    }

    var

}