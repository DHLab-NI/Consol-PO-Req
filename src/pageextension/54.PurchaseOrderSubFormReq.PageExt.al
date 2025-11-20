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
                Editable = false;       // Fisher EDI Mod       
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
                Editable = false;       // Fisher EDI Mod       
            }
        }
        addafter("B2B Sales Order Line No.")
        {
            field("B2B Modified"; Rec."B2B Modified")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Modified';
                Editable = false;
            }
        }
        addafter("B2B Modified")
        {
            field("B2B Modified Description"; Rec."B2B Modified Description")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'B2B Modified Description';
                Editable = true;
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

                    SelectSalesOrderLine(PurchaseLine, Rec."B2B Sales Order No.");
                end;
            }

        }



    }


    local procedure SelectSalesOrderLine(PurchaseLine: Record "Purchase Line"; OriginalLinedSONo: Code[20])
    var
        SalesLine: Record "Sales Line";
        OriginalSalesLine: Record "Sales Line";
        SalesLineSelectionPage: Page "Sales Lines"; // Modify if necessary
    begin

        // Set Original Sales Line filter
        if OriginalLinedSONo <> '' then begin
            OriginalSalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            OriginalSalesLine.SetRange(Type, PurchaseLine.Type);
            OriginalSalesLine.SetRange("No.", PurchaseLine."No.");
            OriginalSalesLine.SetRange("Document No.", OriginalLinedSONo);
            OriginalSalesLine.SetRange("B2B Purch. Order No.", PurchaseLine."Document No.");
            OriginalSalesLine.SetRange("B2B Purch. Order Line No.", PurchaseLine."Line No.");
        end;


        // Apply filters to match the Purchase Line criteria
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, PurchaseLine.Type);
        SalesLine.SetRange("No.", PurchaseLine."No.");
        //SalesLine.SetRange(Quantity, PurchaseLine.Quantity);
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

            // Remove link from original Sales Order Line
            if OriginalLinedSONo <> '' then begin
                if OriginalSalesLine.FindFirst() then begin
                    OriginalSalesLine."B2B Purch. Order No." := '';
                    OriginalSalesLine."B2B Purch. Order Line No." := 0;
                    OriginalSalesLine.Modify();
                end
            end
        end
    end;

}