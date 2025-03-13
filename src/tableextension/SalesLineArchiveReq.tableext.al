tableextension 50107 SalesLineArchiveReqExt extends "Sales Line Archive"
{
    fields
    {
        // SGHTEST03 START - use separate fields to avoid auto purchase shipping on SO receipt
        field(50104; "B2B Purch. Order No."; code[20])
        {
            Caption = 'B2B Purch. Order No.';
            ToolTip = 'Specifies the related back-to-back purchase order no.';
            Editable = False;
        }
        field(50105; "B2B Purch. Order Line No."; Integer)
        {
            Caption = 'B2B Purch. Order Line No.';
            ToolTip = 'Specifies the related back-to-back purchase order line no.';
            Editable = False;
        }
        // SGHTEST03 END - use separate fields to avoid auto purchase shipping on SO receipt
    }
}