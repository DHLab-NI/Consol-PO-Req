// Page to display Related Sales Order information Posted Purchase Receipt Lines Page

namespace Microsoft.Inventory.SalesOrder;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Customer;

page 50102 "Related Sales Order FactBox"
{
    Caption = 'Back-to-back Sales Order';
    PageType = CardPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = Planning;
                Caption = 'Sales Order No.';
                ToolTip = 'Specifies the Back-to-back Sales Order No.';
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SOPage: Page "Sales Order";
                    SalesOrder: Record "Sales Header";
                begin
                    SalesOrder.SetRange("No.", rec."Document No.");
                    SalesOrder.FindFirst();
                    SOPage.SetRecord(SalesOrder);
                    SOPage.Run();
                end;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Planning;
                Caption = 'Sales Order Line No.';
                ToolTip = 'Specifies the Back-to-back Sales Order Line No.';
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Planning;
                Caption = 'Sell-to Customer No.';
                ToolTip = 'Specfies the Sell-to Customer Account Number';
            }
            field(SellToCustName; SellToCustName)
            {
                ApplicationArea = Planning;
                Caption = 'Sell-to Customer Name';
                ToolTip = 'Specfies the name of the Sell-to Customer';
            }

            group(Shipping)
            {
                Caption = 'Shipping to Customer';
                field(TotalQuantity; Rec.Quantity)
                {
                    ApplicationArea = Planning;
                    Caption = 'Total Order Quantity';
                    ToolTip = 'Specfies the total quantity ordered on this line';
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Planning;
                    Caption = 'Quantity Shipped';
                    ToolTip = 'Specfies the quantity shipped on this line';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Planning;
                    Caption = 'Outstanding Quantity';
                    ToolTip = 'Specfies the quantity outstanding on this line';
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = Planning;
                    Enabled = true;
                    Lookup = true;
                    ToolTip = 'Specifies quantity in stock';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        AdjustInventory: Page "Adjust Inventory";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);

                        AdjustInventory.SetItem(Rec."No.");
                        if AdjustInventory.RunModal() in [ACTION::LookupOK, ACTION::OK] then
                            Rec.Get(Rec."No.");
                        CurrPage.Update()
                    end;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Planning;
                    Caption = 'Requested Delivery Date';
                    ToolTip = 'Specfies the Requested Delivery Date of the item';
                }
                field(OrderShipment; OrderShipment)
                {
                    ApplicationArea = Planning;
                    Caption = 'Order Shipment';
                    ToolTip = 'Specfies whether item can shipped in part or must be complete';
                }
            }
            group(ItemInfo)
            {
                Caption = 'Item Information';
                field(Bin; Bin)
                {
                    ApplicationArea = Planning;
                    Caption = 'Shelf/Bin Location';
                    ToolTip = 'Specfies the Shelf/Bin location of the item on this line';
                }
            }
        }
    }

    actions
    {
    }

    var
        // Variables for additional Customer related information fields
        SellToCustName: Text[100];
        Bin: Code[10];
        OrderShipment: Enum "Sales Header Shipping Advice";
        Inventory: Decimal;


    trigger OnAfterGetRecord()
    var
        SellToCustomer: Record Customer;
        Item: Record Item;
        SalesOrderHeader: Record "Sales Header";
        ItemCard: Record Item;

    begin
        Clear(SellToCustName);
        Clear(Bin);
        Clear(OrderShipment);
        Clear(Inventory);

        // SGH Get Customer information 
        If SellToCustomer.Get(Rec."Sell-to Customer No.") then begin
            SellToCustName := SellToCustomer.Name;
        end;

        // SGH Get Item information 
        If Item.Get(Rec."No.") then begin
            Bin := Item."Shelf No.";
            Item.CalcFields(Inventory, "Qty. on Sales Order");
            Inventory := Item.Inventory;
        end;

        // SGH Get Sales Order Header information 
        if SalesOrderHeader.Get(rec."Document Type", rec."Document No.") then begin
            OrderShipment := SalesOrderHeader."Shipping Advice";
        end;

    end;

}
