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
                    SOPage: Page "Sales Order";
                    SOArchivePage: Page "Sales Order Archive";
                    SalesOrder: Record "Sales Header";
                    SalesOrderArchive: Record "Sales Header Archive";

                begin
                    SalesOrder.SetRange("No.", rec."B2B Sales Order No.");
                    If SalesOrder.FindFirst() then begin
                        SOPage.SetRecord(SalesOrder);
                        SOPage.Run();
                    end else if SalesOrderArchive.FindFirst() then begin
                        SalesOrderArchive.SetRange("No.", rec."B2B Sales Order No.");
                        SOArchivePage.SetRecord(SalesOrder);
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