// Page copied from system page 9090 "Item Replenishment FactBox" and modified

namespace Microsoft.Inventory.Item;

using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.Routing;
using Microsoft.Purchases.Vendor;

page 50101 "Item Requisition FactBox"
{
    Caption = 'Item Details - Replenishment';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Planning;
                Caption = 'Item No.';
                ToolTip = 'Specifies the number of the item.';

                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Planning;
                ToolTip = 'Item description';
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the code of the vendor from whom this item is supplied by default.';

                    trigger OnDrillDown()
                    var
                        Vendor: Record Vendor;
                    begin
                        if Rec."Vendor No." <> '' then
                            Vendor.SetRange("No.", Rec."Vendor No.");
                        Page.Run(Page::"Vendor Card", Vendor);
                    end;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                }
            }

            // SGH Add new Group re Availability (flowfields)

            group(Availability)
            {
                Caption = 'Availability (all locations)';
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Planning;
                    Enabled = true;
                    Lookup = true;
                    ToolTip = 'Specifies quantity in stock';
                    //                    AssistEdit = true;
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
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the quantity on Sales Order';
                }

                field("Qty. on Purchase Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the quantity on Purchase Order';
                }
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card", Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        //Rec.SETRANGE("Location Filter", Rec."Location Filter");
        Rec.CalcFields(Inventory, "Qty. on Sales Order");
    end;
}
