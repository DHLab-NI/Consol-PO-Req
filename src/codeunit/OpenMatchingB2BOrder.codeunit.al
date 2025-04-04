codeunit 50106 "B2BOrderMatching"
{
    Procedure "OpenB2BSalesOrder"(var SalesOrderNo: Code[20])
    var
        SOPage: Page "Sales Order";
        SOArchivePage: Page "Sales Order Archive";
        SalesOrder: Record "Sales Header";
        SalesOrderArchive: Record "Sales Header Archive";

    begin
        SalesOrder.SetRange("No.", SalesOrderNo);
        SalesOrderArchive.SetRange("No.", SalesOrderNo);
        SalesOrderArchive.SetAscending("Version No.", false);

        If SalesOrder.FindFirst() then begin
            SOPage.SetRecord(SalesOrder);
            SOPage.Run();
        end else if SalesOrderArchive.FindFirst() then begin
            SOArchivePage.SetRecord(SalesOrderArchive);
            SOArchivePage.Run();
        end else
            Message('Sales order %1 not found', SalesOrderNo);
    end;

    Procedure "OpenB2BPurchaseOrder"(var PurchaseOrderNo: Code[20])
    var
        POPage: Page "Purchase Order";
        POArchivePage: Page "Purchase Order Archive";
        PurchOrder: Record "Purchase Header";
        PurchaseOrderArchive: Record "Purchase Header Archive";

    begin
        PurchOrder.SetRange("No.", PurchaseOrderNo);
        PurchaseOrderArchive.SetRange("No.", PurchaseOrderNo);
        PurchaseOrderArchive.SetAscending("Version No.", false);

        If PurchOrder.FindFirst() then begin
            POPage.SetRecord(PurchOrder);
            POPage.Run();
        end else if PurchaseOrderArchive.FindFirst() then begin
            POArchivePage.SetRecord(PurchaseOrderArchive);
            POArchivePage.Run();
        end else
            Message('Sales order %1 not found', PurchaseOrderNo);
    end;

}
