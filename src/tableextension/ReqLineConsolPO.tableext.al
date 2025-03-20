tableextension 50100 ReqLineConsolPOMod extends "Requisition Line"
{
    fields
    {
        // Add changes to table fields here
        // 
        field(50100; "Add-to Purchase Order No."; Code[20])
        {
            Caption = 'Add-to Purchase Order No.';
            ToolTip = 'Choose an existing Open Purchase Order to add this line to';
            TableRelation = "Purchase Header"."No."
                        where("Document Type" = filter(Order),
                        Status = filter(Open),
                        "Buy-from Vendor No." = field("Vendor No."));
            trigger OnValidate()
            //Set Action Message as a flag so that ReqWkshMakePOMod codeunit can sort Req lines by whether Add-to PO No. has been specified
            begin
                if "Add-to Purchase Order No." <> '' then begin
                    "Action Message" := "Action Message"::" ";
                    // SGH 19-03-25 remove this functionality (not working properly)
                    //                    "Back-to-back Order" := false;
                end else
                    "Action Message" := "Action Message"::New;
            end;
        }
        // SGH 19-03-25 remove this functionality (not working properly) - *** CANNOT DELETE FIELD - "Removing fields is not allowed" ***
        field(50101; "Back-to-back Order"; Boolean)
        {
            Caption = 'New Back-to-back Order';
            ToolTip = 'Create a separate purchase order for this line item';
            InitValue = true;
            trigger OnValidate()
            //Set Action Message as a flag so that ReqWkshMakePOMod codeunit can sort Req lines by whether Back-to-back order has been specified
            begin
                if "Back-to-back Order" then begin
                    "Action Message" := "Action Message"::" ";
                    "Add-to Purchase Order No." := '';
                end else
                    "Action Message" := "Action Message"::New;
            end;
        }

        field(50102; "Sales Order Price"; Decimal)
        {
            Caption = 'Sales Order Price';
            ToolTip = 'Net selling price to customer per Sales Order';
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Editable = False;
        }
        field(50103; "Sales Order Currency"; code[10])
        {
            Caption = 'Sales Order Currency';
            ToolTip = 'Specifies the currency of the Sales Order Price';
            Editable = False;
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