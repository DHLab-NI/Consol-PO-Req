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
            trigger OnValidate()
            //Set Action Message as a flag so that ReqWkshMakePOMod codeunit can sort Req lines by whether Add-to PO No. has been specified
            begin
                if "Add-to Purchase Order No." <> '' then
                    "Action Message" := "Action Message"::" " else
                    "Action Message" := "Action Message"::New;
            end;
        }
    }

    keys
    {
        // SGH key to sort lines by Action Message which is set to " " when Add-to PO No. is specified.
        key(ReqMod; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Order Address Code", "Currency Code", "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Location Code", "Transfer-from Code", "Purchasing Code", "Action Message")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}