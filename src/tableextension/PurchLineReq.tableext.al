tableextension 50103 PurchLineReqExt extends "Purchase Line"
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
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnDelete()
    // SGH Delete Purchase Oirder information from related Sales Order as specified in B2B Sales Order fields on PO
    var
        SalesOrderLine: Record "Sales Line";
        ShouldModifySalesOrderLine: Boolean;
    begin
        ShouldModifySalesOrderLine := "B2B Sales Order Line No." <> 0;
        if ShouldModifySalesOrderLine then begin
            LockTable();
            SalesOrderLine.LockTable();
            SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, "B2B Sales Order No.", "B2B Sales Order Line No.");
            SalesOrderLine."Purchase Order No." := '';
            SalesOrderLine."Purch. Order Line No." := 0;
            SalesOrderLine.Modify();
        end;
    end;


    var
        myInt: Integer;
}