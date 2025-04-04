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

        addfirst("F&unctions")
        {
            action("LinkB2BSO")
            {
                ApplicationArea = All;
                Caption = 'Link B2B Sales Order';
                Image = Link;
                ToolTip = 'Link a Back-to-back purchase order to the selected line';

                //                VISIBILITY?
                //                Promoted = true;
                //                PromotedCategory = Process;
                //                PromotedIsBig = true;
                //                PromotedOnly = true;

                trigger OnAction()
                var
                    PurchaseLine: Record "Purchase Line";
                //                    SalesLine: Record "Sales Line";
                begin
                    PurchaseLine := Rec;
                    CurrPage.SetSelectionFilter(PurchaseLine);
                    if PurchaseLine.IsEmpty() then
                        Error('No Purchase Line selected.');

                    SelectSalesOrderLine(PurchaseLine);
                end;
            }

        }



    }


    local procedure SelectSalesOrderLine(PurchaseLine: Record "Purchase Line")
    var
        SalesLine: Record "Sales Line";
        SalesLineSelectionPage: Page "Sales Lines"; // Modify if necessary
    begin
        // Apply filters to match the Purchase Line criteria
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, PurchaseLine.Type);
        SalesLine.SetRange("No.", PurchaseLine."No.");
        SalesLine.SetRange(Quantity, PurchaseLine.Quantity);
        SalesLine.SetRange("B2B Purch. Order Line No.", 0);


        if Page.RunModal(0, SalesLine) = Action::LookupOK then begin
            // Update Sales Line
            SalesLine."B2B Purch. Order No." := PurchaseLine."Document No.";
            SalesLine."B2B Purch. Order Line No." := PurchaseLine."Line No.";
            SalesLine.Modify();

            // Update Purchase Line
            PurchaseLine."B2B Sales Order No." := SalesLine."Document No.";
            PurchaseLine."B2B Sales Order Line No." := SalesLine."Line No.";
            PurchaseLine.Modify();
        end;
    end;

}