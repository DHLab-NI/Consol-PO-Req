pageextension 50110 PurchaseLinesReqExt extends "Purchase Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("O/S Days"; OSDays)
            {
                ApplicationArea = All;
                Caption = 'O/S Days';
                Visible = true;
            }
        }

        addafter("O/S Days")
        {
            field("B2B Sales Order No."; Rec."B2B Sales Order No.")
            {
                ApplicationArea = All;
                Caption = 'B2B Sales Order No.';
                DrillDown = true;
                trigger OnDrillDown()
                var
                    B2BOrderMatching: Codeunit B2BOrderMatching;

                begin
                    B2BOrderMatching.OpenB2BSalesOrder(Rec."B2B Sales Order No.");
                end;
            }
        }

        addafter("B2B Sales Order No.")
        {
            field("B2B Sales Order Line No."; Rec."B2B Sales Order Line No.")
            {
                ApplicationArea = All;
                Caption = 'B2B Sales Order Line No.';
                Visible = false;
            }
        }

        addafter("B2B Sales Order Line No.")
        {
            field("B2B Sell-to Customer No."; B2BSellToCustomerNo)
            {
                ApplicationArea = All;
                Caption = 'B2B Sell-to Customer No.';
                Visible = true;
            }
        }

    }

    actions
    {
    }

    var
        B2BSellToCustomerNo: Code[20];
        SalesHeader: Record "Sales Header";
        OSDays: Integer;
        PurchaseHeader: Record "Purchase Header";
        HeaderDocumentDate: Date;

    trigger OnAfterGetRecord()
    begin
        B2BSellToCustomerNo := '';
        OSDays := 0;
        HeaderDocumentDate := 0D;
        if Rec."B2B Sales Order No." <> '' then begin
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."B2B Sales Order No.") then
                B2BSellToCustomerNo := SalesHeader."Sell-to Customer No.";
        end;
        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            HeaderDocumentDate := PurchaseHeader."Document Date";
        if HeaderDocumentDate <> 0D then
            OSDays := Today - HeaderDocumentDate;
    end;
}