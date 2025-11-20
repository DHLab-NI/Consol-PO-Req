tableextension 50102 PurchRecptLineReqExt extends "Purch. Rcpt. Line"
{
    fields
    {
        // SGHTEST03 START - use separate fields to avoid auto sales shipping on PO receipt
        field(50104; "B2B Sales Order No."; code[20])
        {
            Caption = 'B2B Sales Order No.';
            ToolTip = 'Specifies the related back-to-back sales order no.';
            Editable = False;
        }
        field(50105; "B2B Sales Order Line No."; Integer)
        {
            Caption = 'B2B Sales Order Line No.';
            ToolTip = 'Specifies the related back-to-back sales order line no.';
            Editable = False;
        }
        // SGHTEST03 END - use separate fields to avoid auto sales shipping on PO receipt

        field(50106; "O/S Qty. on SO"; Decimal)
        {
            FieldClass = FlowField;

            CalcFormula = lookup("Sales Line"."Outstanding Quantity" where("Document No." = field("B2B Sales Order No."), "Line No." = field("B2B Sales Order Line No.")
            ))

            ;
            Caption = 'O/S Qty. on SO';
            ToolTip = 'Specifies the unshipped outstanding quantity on the related B2B Sales Order Line';
            Editable = false;
        }
        field(50107; "Inventory"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Location Code" = field("Location Code")
                                                                  ));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50108; "Sell-to Customer No."; Code[20])
        {
            FieldClass = FlowField;

            CalcFormula = lookup("Sales Header"."Sell-to Customer No." where("No." = field("B2B Sales Order No."),
                                                            "Document Type" = const("Sales Document Type"::Order)
            ));

            Caption = 'Sell-to Customer No.';
            ToolTip = 'Specifies the Sell-to Customer No. on the related B2B Sales Order';
            Editable = false;
        }
        field(50109; "Shelf No."; Code[10])
        {
            FieldClass = FlowField;

            CalcFormula = lookup(Item."Shelf No." where("No." = field("No.")
            ));

            Caption = 'Shelf No.';
            ToolTip = 'Specifies the Shelf No. on the Item Card';
            Editable = false;
        }
        field(50112; "B2B Modified"; Boolean)
        {
            Caption = 'B2B Modified';
            ToolTip = 'Indicates that the related back-to-back sales order has been modified. See B2B Modified Description for detail';
            Editable = True;
        }
        field(50113; "B2B Modified Description"; Text[255])
        {
            Caption = 'B2B Modified Description';
            ToolTip = 'Specifies changes to related B2B sales order.';
            Editable = True;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        item: Record Item;
}