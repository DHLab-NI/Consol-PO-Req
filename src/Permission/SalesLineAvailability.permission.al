permissionset 50100 "Sales Availability"
{
    Assignable = true;
    Caption = 'Sales Line Availability (DHLab)';

    Permissions =
        codeunit "Req. Wksh.-Make Order2" = X;
}
