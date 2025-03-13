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


        addafter("Unit of Measure Code")
        {
            field("B2B Sales Order No."; Rec."B2B Sales Order No.")
            {
                ApplicationArea = Planning;
                Caption = 'B2B Sales Order No.';
                ToolTip = 'Specifies the source Sales Order Number';

                // Open sales order on drilldown
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SOPage: Page "Sales Order";
                    SOArchivePage: Page "Sales Order Archive";
                    SalesOrder: Record "Sales Header";
                    SalesOrderArchive: Record "Sales Header Archive";

                begin
                    SalesOrder.SetRange("No.", rec."B2B Sales Order No.");
                    SalesOrderArchive.SetRange("No.", rec."B2B Sales Order No.");
                    If SalesOrder.FindFirst() then begin
                        SOPage.SetRecord(SalesOrder);
                        SOPage.Run();
                    end else if SalesOrderArchive.FindFirst() then begin
                        SOArchivePage.SetRecord(SalesOrderArchive);
                        SOArchivePage.Run();
                    end else
                        Message('Sales order %1 not found', rec."B2B Sales Order No.");
                end;
            }
        }
        addafter("B2B Sales Order No.")
        {
            field("B2B Sales Order Line No."; Rec."B2B Sales Order Line No.")
            {
                ApplicationArea = Planning;
                Caption = 'B2B Sales Order Line No.';
                ToolTip = 'Specifies the source Sales Order Line Number';
            }
        }

        addafter(Quantity)
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = Planning;
                Caption = 'Inventory';
                ToolTip = 'Specifies the quantity on hand at receiving location';
            }
            field("O/S Qty. on SO"; Rec."O/S Qty. on SO")
            {
                ApplicationArea = Planning;
                Caption = 'O/S Qty. on SO';
                ToolTip = 'Specifies the unshipped outstanding quantity on the related B2B Sales Order Line';
            }
        }


        addlast(FactBoxes)
        {
            part(Control50000; "Related Sales Order FactBox")
            {
                ApplicationArea = Planning;
                SubPageLink = "Document No." = field("B2B Sales Order No."), "Line No." = field("B2B Sales Order Line No.");
                Visible = true;
            }
        }
    }

    actions
    {
    }

    var

}