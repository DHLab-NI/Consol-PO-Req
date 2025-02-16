pageextension 50103 SalesOrderSubformReqExt extends "Sales Order Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("B2B Purch. Order No."; Rec."B2B Purch. Order No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Purch. Order No.';

                // Open purchase order on drilldown
                DrillDown = true;
                trigger OnDrillDown()
                var
                    POPage: Page "Purchase Order";
                    PurchaseOrder: Record "Purchase Header";

                begin
                    PurchaseOrder.SetRange("No.", rec."B2B Purch. Order No.");
                    PurchaseOrder.FindFirst();
                    POPage.SetRecord(PurchaseOrder);
                    POPage.Run();
                end;
            }
        }
        addafter("B2B Purch. Order No.")
        {
            field("B2B Purch. Order Line No."; Rec."B2B Purch. Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Purch. Order Line No.';
            }
        }
    }

    actions
    {
    }

    var

}