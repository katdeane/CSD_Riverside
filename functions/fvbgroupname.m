function grpname = fvbgroupname(Group)

if matches(Group,'OLD')
    grpname = 'Aged';
elseif matches(Group,'YNG')
    grpname = 'Young';
elseif matches(Group,'FOS')
    grpname = 'Aged Saline';
elseif matches(Group,'FON')
    grpname = 'Aged Nicotine';
elseif matches(Group,'FYS')
    grpname = 'Young Saline';
elseif matches(Group,'FYN')
    grpname = 'Young Nicotine';
elseif matches(Group,'FOM')
    grpname = 'Aged Male';
elseif matches(Group,'FOF')
    grpname = 'Aged Female';
elseif matches(Group,'FYM')
    grpname = 'Young Male';
elseif matches(Group,'FYF')
    grpname = 'Young Female';
end