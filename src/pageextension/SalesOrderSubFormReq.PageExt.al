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
                    POArchivePage: Page "Purchase Order Archive";
                    PurchOrder: Record "Purchase Header";
                    PurchaseOrderArchive: Record "Purchase Header Archive";

                begin
                    PurchOrder.SetRange("No.", rec."B2B Purch. Order No.");
                    If PurchOrder.FindFirst() then begin
                        POPage.SetRecord(PurchOrder);
                        POPage.Run();
                    end else if PurchaseOrderArchive.FindFirst() then begin
                        PurchaseOrderArchive.SetRange("No.", rec."B2B Purch. Order No.");
                        POArchivePage.SetRecord(PurchOrder);
                        POArchivePage.Run();
                    end else
                        Message('Sales order %1 not found', rec."B2B Purch. Order No.");
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