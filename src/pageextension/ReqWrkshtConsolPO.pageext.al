pageextension 50100 ReqWorksheetExt extends "Req. Worksheet"
{
    layout
    {
        // Hide the existing Item Replenishment FactBox
        modify(Control1903326807)
        {
            Visible = false;
        }

        // Add the custom Item Requisition FactBox
        addlast(FactBoxes)
        {
            part(ItemRequisitionFactBox; "Item Requisition FactBox")
            {
                ApplicationArea = Planning;
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
        }

        // Hide Original Quantity column
        modify("Original Quantity")
        {
            Visible = false;
        }

        // Hide Original Due Date column
        modify("Original Due Date")
        {
            Visible = false;
        }

        // Show Sell-to (Sales/Cust Account)
        modify("Sell-to Customer No.")
        {
            Visible = true;
        }

        // NEW AND REORDER COLUMNS
        moveafter("No."; Description)
        moveafter(Description; "Location Code")
        moveafter("Location Code"; Quantity)
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Vendor No.")

        addafter("Vendor No.")
        {
            field("Back-to-back Order"; Rec."Back-to-back Order")
            {
                ApplicationArea = Planning;
                Visible = true;
            }
        }

        // Field used to bypass new PO and add line to existing PO
        addafter("Back-to-back Order")
        {
            field("Add-to Purchase Order No."; Rec."Add-to Purchase Order No.")
            {
                ApplicationArea = Planning;
                Visible = true;
                Lookup = true;
            }
        }

        moveafter("Add-to Purchase Order No."; "Direct Unit Cost")

        addafter("Direct Unit Cost")
        {
            field("Sales Order Price"; Rec."Sales Order Price")
            {
                ApplicationArea = Planning;
                Visible = true;
            }
        }
        addafter("Sales Order Price")
        {
            field("Sales Order Currency"; Rec."Sales Order Currency")
            {
                ApplicationArea = Planning;
                Visible = true;
                Editable = false;
            }
        }

        addafter("Sales Order Currency")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = Planning;
                Caption = 'Sales Order No.';
                Visible = true;
                ToolTip = 'Specifies the source Sales Order Number';
                Lookup = false;
                // Open sales order on drilldown
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SOPage: Page "Sales Order";
                    SalesOrder: Record "Sales Header";
                begin
                    SalesOrder.SetRange("No.", rec."Sales Order No.");
                    SalesOrder.FindFirst();
                    SOPage.SetRecord(SalesOrder);
                    SOPage.Run();
                end;
            }
        }
        addafter("Sales Order No.")
        {
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = Planning;
                Caption = 'Sales Order Line No.';
                Visible = true;
                ToolTip = 'Specifies the source Sales Order Line Number';
            }
        }
        moveafter("Sales Order Line No."; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; Type)
        moveafter(Type; "Action Message")
        moveafter("Action Message"; "Accept Action Message")
        moveafter("Accept Action Message"; "Price Calculation Method")

        //Specify position of freeze column
        modify(Control1)
        {
            FreezeColumn = "Description";
        }
    }

    actions
    {
        // Define a new action under the Home menu
        addafter("Special Order")
        {
            group("DHLab")

            {
                action("GetSalesOrders")
                {
                    ApplicationArea = Planning;
                    Caption = 'Get Sales Orders';
                    Ellipsis = true;
                    Image = Order;
                    ToolTip = 'Copy sales lines from Released Sales Orders to the requisition worksheet.';

                    trigger OnAction()
                    begin
                        GetSalesOrder.SetReqWkshLine(Rec, 0); // 1= Special Order, 0 = not special order?
                        GetSalesOrder.RunModal();
                        Clear(GetSalesOrder);
                    end;
                }

                action(CreatePurchaseOrders)
                {
                    ApplicationArea = Planning;
                    Caption = 'Create Purchase Orders';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';

                    trigger OnAction()
                    begin
                        CarryOutActionMsg();
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        addafter("Category_Process")
        {
            group(Category_DHLab)
            {
                Caption = 'DHLab', Comment = 'Create purchase orders from open sales lines';
                actionref("Get Sales Orders"; GetSalesOrders)
                {
                }
                actionref("Create Purchase Orders"; CreatePurchaseOrders)
                {
                }
            }
        }
    }

    var
        GetSalesOrder: Report "Get Sales Orders2";

    local procedure CarryOutActionMsg()
    var
        CarryOutActionMsgReq: Report "Carry Out Action Msg. - Req.2";
        IsHandled: Boolean;
    begin
        CarryOutActionMsgReq.SetReqWkshLine(Rec);
        CarryOutActionMsgReq.RunModal();
        CarryOutActionMsgReq.GetReqWkshLine(Rec);
    end;


}