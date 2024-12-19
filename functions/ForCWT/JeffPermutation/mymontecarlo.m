%% Monte Carlo Function for use with parfor
function [perm_stat, ClustSizesPOSmc, ClustSizesNEGmc] = mymontecarlo(AllData,grp1size,grp2size)

% create order for permutation this round
randorder = randperm(size(AllData,1));
% preallocate 
bothgroupsize = grp1size+grp2size;
rowsN = size(AllData,2);
columnN = size(AllData,3);
randGroup1 = zeros(grp1size,rowsN,columnN);
randGroup2 = zeros(grp2size,rowsN,columnN);

% fill groups with randomized subjects
for m = 1:bothgroupsize
    if m <= grp1size
        randGroup1(m,:,:) = AllData(randorder(m),:,:);
    elseif m > grp1size
        randGroup2(m-grp1size,:,:) = AllData(randorder(m),:,:);
    end
end

% t test
t_thresh = NaN; % don't need it here
perm1_mean = squeeze(mean(randGroup1,1)); % (54 x 4000)
perm1_std = squeeze(std(randGroup1,0,1));
perm2_mean = squeeze(mean(randGroup2,1));
perm2_std = squeeze(std(randGroup2,0,1));
[perm_stat, ~, ~] = powerStats(perm1_mean, ...
    perm2_mean, perm1_std, perm2_std, grp1size, grp2size, t_thresh);

% find the tails of the distributions 
dF = bothgroupsize-2;
TsigPOSmc = tcdf(perm_stat,dF)>=0.975;
TsigNEGmc = tcdf(perm_stat,dF)<=0.975;
[~,LsigPOSmc,NsigPOSmc] = bwboundaries(TsigPOSmc);
[~,LsigNEGmc,NsigNEGmc] = bwboundaries(TsigNEGmc);
ClustSizesPOSmc = zeros(NsigPOSmc,1);
ClustSizesNEGmc = zeros(NsigNEGmc,1);

for isig = 1:NsigPOSmc
    ClustSizesPOSmc(isig) = sum(sum(LsigPOSmc == isig));
end
for isig = 1:NsigNEGmc
    ClustSizesNEGmc(isig) = sum(sum(LsigNEGmc == isig));
end

ClustSizesPOSmc = sum(ClustSizesPOSmc);
ClustSizesNEGmc = sum(ClustSizesNEGmc);

