namespace DHLab.Inventory.Requisition;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Requisition;
using Microsoft.Inventory.Location;

report 50103 "Replenish Inventory"
{
    Caption = 'Replenish Inventory';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where(Type = const(Inventory), "Maximum Inventory" = filter(> 0));
            RequestFilterFields = "No.", "Vendor No.";

            trigger OnAfterGetRecord()
            var
                AvailableQty: Decimal;
                POQty: Decimal;
                ItemRec: Record Item;
            begin
                // Set location filter for calculations
                ItemRec.Copy(Item);
                ItemRec.SetRange("Location Filter", LocationCode);
                ItemRec.CalcFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");

                // Calculate AvailableQty = Inventory + O/S Qty on PO - O/S Qty on SO
                AvailableQty := ItemRec.Inventory + ItemRec."Qty. on Purch. Order" - ItemRec."Qty. on Sales Order";

                // Skip if AvailableQty > Reorder Point
                if AvailableQty > Item."Reorder Point" then
                    CurrReport.Skip();

                // Calculate POQty = Maximum Inventory - AvailableQty
                POQty := Item."Maximum Inventory" - AvailableQty;

                // Add line to Req. Worksheet
                InsertReqWorksheetLine(Item, LocationCode, POQty);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Location Code';
                        ToolTip = 'Specifies the location code for inventory calculations and replenishment.';
                        TableRelation = Location;
                        NotBlank = true;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if LocationCode = '' then
            Error('Location Code must be specified.');

        // Initialize worksheet setup like the working report
        ReqWkshTmpl.Get(ReqLine."Worksheet Template Name");
        ReqWkshName.Get(ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name");
        ReqLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
        ReqLine.LockTable();
        if ReqLine.FindLast() then begin
            ReqLine.Init();
            LineNo := ReqLine."Line No.";
        end;
    end;

    var
        LocationCode: Code[10];
        ReqLine: Record "Requisition Line";
        LineNo: Integer;
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";

    procedure SetReqWorksheetLine(var NewReqLine: Record "Requisition Line")
    begin
        ReqLine.Copy(NewReqLine);
    end;

    local procedure InsertReqWorksheetLine(ItemRec: Record Item; LocCode: Code[10]; Quantity: Decimal)
    begin
        if Quantity <= 0 then
            exit;

        LineNo := LineNo + 10000;
        Clear(ReqLine);
        ReqLine.Init();
        ReqLine."Worksheet Template Name" := ReqWkshName."Worksheet Template Name";
        ReqLine."Journal Batch Name" := ReqWkshName.Name;
        ReqLine."Line No." := LineNo;
        ReqLine.Validate(Type, ReqLine.Type::Item);
        ReqLine.Validate("No.", ItemRec."No.");
        ReqLine.Validate("Location Code", LocCode);
        ReqLine.Validate(Quantity, Quantity);
        ReqLine."Action Message" := "Action Message Type"::New;
        ReqLine.Insert();
    end;
}


