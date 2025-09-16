// Page copied from system page 9090 "Item Replenishment FactBox" and modified

namespace DHLab.Inventory.Item;

using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Manufacturing.Routing;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.History;
using Microsoft.Inventory.Item;

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
                // SGH WIP Display Last purchase details

                // New calculated fields
                field("Last Purchase Price (FCY)"; LastPurchasePrice)
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Shows the last purchase price of the item in the purchase currency.';
                }
                field("Purchase Currency"; PurchaseCurrency)
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the currency code used for purchasing the item.';
                }
                field("Date of Last Purchase"; LastPurchaseDate)
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the date of the last purchase of the item.';
                }
                field("Last Purchase Inv No."; LastPurchaseInvoice)
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the Invoice No. of the last purchase of the item.';
                    // Open Posted Purchase Invoice on drilldown
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        PInvPage: Page "Posted Purchase Invoice";
                        PInvRec: Record "Purch. Inv. Header";
                    begin
                        PInvRec.SetRange("No.", LastPurchaseInvoice);
                        PInvRec.FindFirst();
                        PInvPage.SetRecord(PInvRec);
                        PInvPage.Run();
                    end;
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
                field("Maximum Inventory"; Rec."Maximum Inventory")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the maximum inventory for the item';
                }
                field("Reorder Point"; Rec."Reorder Point")
                {
                    ApplicationArea = Planning;
                    Lookup = false;
                    ToolTip = 'Specifies the reorder point for the item';
                }
            }
        }
    }

    actions
    {
    }

    // SGH Variables for last purchase information
    var
        LastPurchasePrice: Decimal;
        PurchaseCurrency: Code[10];
        LastPurchaseDate: Date;
        LastPurchaseInvoice: Code[20];

    trigger OnAfterGetRecord()
    begin
        //Rec.SETRANGE("Location Filter", Rec."Location Filter");
        Rec.CalcFields(Inventory, "Qty. on Sales Order");
        //SGH Get last purchase details for item
        FindLastPurchaseDetails;
    end;

    // SGH Procedure for last purchase information

    local procedure FindLastPurchaseDetails()
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        ItemVendor: Record Vendor;
    begin
        Clear(LastPurchasePrice);
        Clear(PurchaseCurrency);
        Clear(LastPurchaseDate);
        Clear(LastPurchaseInvoice);
        Clear(PurchInvLine);
        Clear(ItemVendor);

        // Set default purchase currency
        if ItemVendor.get(rec."Vendor No.") then PurchaseCurrency := ItemVendor."Currency Code";

        // Find all purchase invoice lines for the item
        PurchInvLine.SetCurrentKey(Type, "No.", "Variant Code", "Posting Date");
        PurchInvLine.SetRange("No.", Rec."No.");
        PurchInvLine.SetFilter(Quantity, '>0');

        if PurchInvLine.FindLast() then begin
            if PurchInvHeader.Get(PurchInvLine."Document No.") then begin
                LastPurchasePrice := (PurchInvLine."Line Amount" / PurchInvLine.Quantity);
                PurchaseCurrency := PurchInvHeader."Currency Code";
                LastPurchaseDate := PurchInvHeader."Posting Date";
                LastPurchaseInvoice := PurchInvLine."Document No.";
            end;
        end;
    end;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card", Rec);
    end;

}
