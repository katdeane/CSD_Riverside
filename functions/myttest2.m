% it's a t test 2 but with cohen's d, means, stds :3
function [P,DF,CD,mean1,sd1,mean2,sd2] = myttest2(grp1,grp2,dim,tail,vartype)

if ~exist('dim','var')
    dim = 1;
end
if ~exist('tail','var')
    tail = 'both'; 
end
if ~exist('vartype','var')
    vartype = 'equal';
end

% the stuff matlab gives us for free
[~,P,~,Stats] = ttest2(grp1,grp2,'dim',dim,'tail',tail,'vartype',vartype);
DF = Stats.df;
% 
grp1size = length(grp1);
grp2size = length(grp2);

% Permutation Step 1 - Observed Differences

mean1 = nanmean(grp1);
sd1   = nanstd(grp1,0);

mean2 = nanmean(grp2);
sd2   = nanstd(grp2,0);

% Cohen's d
S = sqrt((((grp1size - 1).*sd1.^2)+((grp2size-1).*sd2.^2))/...
        (grp1size + grp2size - 2));
CD = (mean1-mean2)./S;