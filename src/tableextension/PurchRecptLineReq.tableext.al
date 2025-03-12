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

        field(50106; "Qty. Shipped on SO"; Decimal)
        {
            FieldClass = FlowField;

            CalcFormula = lookup("Sales Line"."Quantity Shipped" where("Document No." = field("B2B Sales Order No."), "Line No." = field("B2B Sales Order Line No.")
            ))

            ;
            Caption = 'Qty. Shipped on SO';
            ToolTip = 'Specifies the quantity shipped on the related B2B Sales Order';
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