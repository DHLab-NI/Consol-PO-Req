codeunit 50105 CheckForLinkedB2BPurchOrder

//SGH 12/05/2025
//Checks for linked B2B Purchase Order when modifying the Quantity on a Sales Order line
//Generates an error message of one exists

{

    // SGH 20/22/25 Remove check on related B2B PO before changin Qty. 
    // Replaced with notification in PO Line Description 2 field and B2B Modified field = true
    /*

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateQuantity', '', false, false)]
    local procedure PreventQuantityChange(
        var SalesLine: Record "Sales Line";
        xSalesLine: Record "Sales Line";
        CallingFieldNo: Integer;
        var IsHandled: Boolean)
    var
        ErrorMessage: Text;
    begin
        // Check if "B2B Purchase Order Line No." is not 0
        if SalesLine."B2B Purch. Order Line No." <> 0 then begin
            // Construct the error message with the associated "B2B Purchase Order No."
            ErrorMessage := StrSubstNo(
                'The quantity cannot be changed because the Sales Line is associated with B2B Purchase Order No. %1.',
                SalesLine."B2B Purch. Order No."
            );

            // Raise an error
            Error(ErrorMessage);

            // Set IsHandled to true to skip the standard validation logic
            IsHandled := true;
        end;
    end;
*/

    // SGH 20/22/25 Remove check on related B2B PO before deleting Sales Line. 
    // Replaced with notification in PO Line Description 2 field and B2B Modified field = true
    /*
        [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckAssocPurchOrder', '', false, false)]
        local procedure PreventDeleteLine(
            var SalesLine: Record "Sales Line";
            xSalesLine: Record "Sales Line";
            TheFieldCaption: Text[250];
            var IsHandled: Boolean)
        var
            ErrorMessage: Text;
        begin
            // Check if "B2B Purchase Order Line No." is not 0
            if ((SalesLine."B2B Purch. Order Line No." <> 0) and (TheFieldCaption = '')) then begin // Check B2B exists and line being deleted
                // Construct the error message with the associated "B2B Purchase Order No."
                ErrorMessage := StrSubstNo(
                    'The Sales Line cannot be deleted because it is associated with B2B Purchase Order No. %1.',
                    SalesLine."B2B Purch. Order No."
                );

                // Raise an error
                Error(ErrorMessage);

                // Set IsHandled to true to skip the standard validation logic
                IsHandled := true;
            end;
        end;
    */

}