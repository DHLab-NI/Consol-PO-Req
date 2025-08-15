tableextension 50104 SalesLineReqExt extends "Sales Line"
{
    fields
    {
        // SGHTEST03 START - use separate fields to avoid auto purchase shipping on SO receipt
        field(50104; "B2B Purch. Order No."; code[20])
        {
            Caption = 'B2B Purch. Order No.';
            ToolTip = 'Specifies the related back-to-back purchase order no.';
            Editable = True;       // Fisher EDI Mod       
        }
        field(50105; "B2B Purch. Order Line No."; Integer)
        {
            Caption = 'B2B Purch. Order Line No.';
            ToolTip = 'Specifies the related back-to-back purchase order line no.';
            Editable = True;       // Fisher EDI Mod       
        }
        // SGHTEST03 END - use separate fields to avoid auto purchase shipping on SO receipt
    }

    // SGH Delete Purchase Order information from related Sales Order as specified in B2B Sales Order fields on PO
    // Code copied from PurchLineReq.TableExt 50103. If needed, you will need to change references to SO: lines to PO lines   
    /*
    trigger OnDelete()
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
*/

}