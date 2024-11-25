tableextension 50100 ReqLineConsolPOMod extends "Requisition Line"
{
    fields
    {
        // Add changes to table fields here
        // 
        field(50100; "Add-to Purchase Order No."; Code[20])
        {
            Caption = 'Add-to Purchase Order No.';
            TableRelation = "Purchase Header"."No."
                        where("Document Type" = filter(Order),
                        Status = filter(Open),
                        "Buy-from Vendor No." = field("Vendor No."));
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
        myInt: Integer;
}