pageextension 50102 PurchaseOrderSubformReqExt extends "Purchase Order Subform"
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
                    SOPage: Page "Sales Order";
                    SalesOrder: Record "Sales Header";

                begin
                    SalesOrder.SetRange("No.", rec."B2B Sales Order No.");
                    SalesOrder.FindFirst();
                    SOPage.SetRecord(SalesOrder);
                    SOPage.Run();
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