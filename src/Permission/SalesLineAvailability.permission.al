permissionset 50100 "Purchase Order Req"
{
    Assignable = true;
    Caption = 'Sales Line Availability (DHLab)';

    Permissions =
        codeunit "Req. Wksh.-Make Order2" = X,
        codeunit B2BOrderMatching = X;
    ;
}
