tableextension 50106 SalesInvLineReqExt extends "Sales Invoice Line"
{
    fields
    {
        field(50104; "B2B Purch. Order No."; code[20])
        {
            Caption = 'B2B Purch. Order No.';
            ToolTip = 'Specifies the related back-to-back Purchase order no.';
            Editable = False;
        }
        field(50105; "B2B Purch. Order Line No."; Integer)
        {
            Caption = 'B2B Purch. Order Line No.';
            ToolTip = 'Specifies the related back-to-back Purchase order line no.';
            Editable = False;
        }

    }

    keys
    {
        // SGH Sort lines by posting date to find last sales line - copied from purchase Inv line - may not be needed
        key(keyReq; Type, "No.", "Variant Code", "Posting Date")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    // Get purchase lines for item ** SGH didn't work in itemfactbox.page
    /*    procedure GetPurchaseLines(ItemNo: Code[20]): Record "Purch. Inv. Line"

        var
            ItemPurchInvLines: Record "Purch. Inv. Line";

        begin
            Clear(ItemPurchInvLines);
            ItemPurchInvLines.SetCurrentKey(Type, "No.", "Variant Code", "Posting Date");
            ItemPurchInvLines.SetRange("No.", ItemNo);
            ItemPurchInvLines.SetFilter(Quantity, '>0');
            exit(ItemPurchInvLines);
        end;
    */

    var
        dasdasd: Record "Sales Line";

}
