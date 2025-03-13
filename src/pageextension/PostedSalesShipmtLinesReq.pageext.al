pageextension 50104 SalesShipmtLinesReq extends "Posted Sales Shipment Lines"
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
            field("B2B Purch. Order No."; Rec."B2B Purch. Order No.")
            {
                ApplicationArea = Planning;
                Caption = 'B2B Purch. Order No.';
                ToolTip = 'Specifies the source Purchase Order Number';

                // Open Purchase order on drilldown
                DrillDown = true;
                trigger OnDrillDown()
                var
                    POPage: Page "Purchase Order";
                    POArchivePage: Page "Purchase Order Archive";
                    PurchOrder: Record "Purchase Header";
                    PurchaseOrderArchive: Record "Purchase Header Archive";

                begin
                    PurchOrder.SetRange("No.", rec."B2B Purch. Order No.");
                    PurchaseOrderArchive.SetRange("No.", rec."B2B Purch. Order No.");
                    If PurchOrder.FindFirst() then begin
                        POPage.SetRecord(PurchOrder);
                        POPage.Run();
                    end else if PurchaseOrderArchive.FindFirst() then begin
                        POArchivePage.SetRecord(PurchaseOrderArchive);
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
                ApplicationArea = Planning;
                Caption = 'B2B Purch. Order Line No.';
                ToolTip = 'Specifies the source Purchase Order Line Number';
            }
        }

        //SGH Copied from Purchase Recpt line page - may not be needed here. No Sales shipment factbox has been created
        /*
                addlast(FactBoxes)
                {
                    part(Control50000; "Related Sales Order FactBox")
                    {
                        ApplicationArea = Planning;
                        SubPageLink = "Document No." = field("B2B Sales Order No."), "Line No." = field("B2B Sales Order Line No.");
                        Visible = true;
                    }
                }
                */
    }

    actions
    {
    }

    var

}