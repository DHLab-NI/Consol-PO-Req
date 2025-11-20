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
        // Check if Qty changed on B2B Sales Order and update B2B PO
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            var
                PurchaseOrderLine: Record "Purchase Line";
                ShouldModifyPurchaseOrderLine: Boolean;
                B2BPOModText: Text;
            begin
                PurchaseOrderLine.Reset();
                ShouldModifyPurchaseOrderLine :=
                    (
                        ("B2B Purch. Order Line No." <> 0) and
                        (PurchaseOrderLine.Get(PurchaseOrderLine."Document Type"::Order, "B2B Purch. Order No.", "B2B Purch. Order Line No.")))
                    ;
                if ShouldModifyPurchaseOrderLine then begin
                    LockTable();
                    PurchaseOrderLine.LockTable();
                    Message('PO %1 Qty. will be flagged as different from B2B SO', PurchaseOrderLine."Document No.");
                    B2BPOModText :=
                        'Qty changed to ' + format(Quantity) +
                        ' on ' + PurchaseOrderLine."B2B Sales Order No.";
                    PurchaseOrderLine."B2B Modified Description" := B2BPOModText;
                    PurchaseOrderLine."B2B Modified" := true;
                    PurchaseOrderLine.Modify();
                end;
            end;
        }

    }

    trigger OnDelete()
    // SGH Delete Sales Order information from related Purchase Order as specified in B2B Purchase Order fields on SO
    var
        PurchaseOrderLine: Record "Purchase Line";
        ShouldModifyPurchaseOrderLine: Boolean;
        B2BPOModText: Text;
    begin
        PurchaseOrderLine.Reset();
        ShouldModifyPurchaseOrderLine :=
            (
                ("B2B Purch. Order Line No." <> 0) and
                (PurchaseOrderLine.Get(PurchaseOrderLine."Document Type"::Order, "B2B Purch. Order No.", "B2B Purch. Order Line No.")))
            ;
        if ShouldModifyPurchaseOrderLine then begin
            LockTable();
            PurchaseOrderLine.LockTable();
            Message('PO %1 will be flagged as unlinked', PurchaseOrderLine."Document No.");
            B2BPOModText :=
                PurchaseOrderLine."B2B Sales Order No." +
                ', line no. ' + format(PurchaseOrderLine."B2B Sales Order Line No.") +
                ' deleted.';
            PurchaseOrderLine."B2B Modified Description" := B2BPOModText;
            PurchaseOrderLine."B2B Modified" := true;
            PurchaseOrderLine."B2B Sales Order No." := '';
            PurchaseOrderLine."B2B Sales Order Line No." := 0;
            PurchaseOrderLine.Modify();
        end;
    end;

}