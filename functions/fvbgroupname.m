function grpname = fvbgroupname(Group)

if matches(Group,'OLD')
    grpname = 'Old';
elseif matches(Group,'YNG')
    grpname = 'Young';
elseif matches(Group,'FOS')
    grpname = 'Old Saline';
elseif matches(Group,'FON')
    grpname = 'Old Nicotine';
elseif matches(Group,'FYS')
    grpname = 'Young Saline';
elseif matches(Group,'FYN')
    grpname = 'Young Nicotine';
elseif matches(Group,'FOM')
    grpname = 'Old Male';
elseif matches(Group,'FOF')
    grpname = 'Old Female';
elseif matches(Group,'FYM')
    grpname = 'Young Male';
elseif matches(Group,'FYF')
    grpname = 'Young Female';
elseif matches(Group,'ONF')
    grpname = 'Old Nic Female';
elseif matches(Group,'OSF')
    grpname = 'Old Sal Female';
elseif matches(Group,'ONM')
    grpname = 'Old Nic Male';
elseif matches(Group,'OSM')
    grpname = 'Old Sal Male';
elseif matches(Group,'YNF')
    grpname = 'Young Nic Female';
elseif matches(Group,'YSF')
    grpname = 'Young Sal Female';
elseif matches(Group,'YNM')
    grpname = 'Young Nic Male';
elseif matches(Group,'YSM')
    grpname = 'YOung Sal Male';
end