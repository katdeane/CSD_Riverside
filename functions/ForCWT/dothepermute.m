function mass_clustermass = dothepermute(whichtest,grp1Out,grp2Out,grp1size,grp2size,...
    compTime,osciName,osciRows,t_thresh,nperms)

mass_clustermass = NaN([1 nperms]);
% put the whole group in one container
contAll = [grp1Out;grp2Out];
perm_layer = struct;

for ispec = 1:length(osciName)
    perm_layer.(osciName{ispec}) = NaN([1 nperms]);
end

for iperm = 1:nperms
    % determine random list order to pull
    order = randperm(grp1size+grp2size);
    % pull based on random list order
    grp1perm = contAll(order(1:grp1size),:,:);
    grp2perm = contAll(order(grp1size+1:end),:,:);

    per1_mean = squeeze(mean(grp1perm,1));
    per1_std = squeeze(std(grp1perm,0,1));

    per2_mean = squeeze(mean(grp2perm,1));
    per2_std = squeeze(std(grp2perm,0,1));

    % Student's t test and cohen's d effect size
    if contains(whichtest,'Power')
        [~, ~, per_clusters] = powerStats(per1_mean, ...
            per2_mean, per1_std, per2_std, grp1size, grp2size, t_thresh);
    end

    % Mann-Whitney U test and z effect size
    if contains(whichtest,'Phase')
        [~, ~, per_clusters] = phaseStats(grp1perm, grp2perm, grp1size, grp2size);
    end

    % check cluster mass for 300 ms from tone onset
    per_clustermass = sum(sum(per_clusters(:,compTime)));
    mass_clustermass(iperm) = per_clustermass;

    % for layer specific: %%%
    % % pull out clusters

    for ispec = 1:length(osciName)
        hold_permlayer = per_clusters(osciRows{ispec},compTime);

        % % sum clusters (twice to get final value)
        for i = 1:2
            hold_permlayer = sum(hold_permlayer);
        end
        perm_layer.(osciName{ispec})(iperm) = hold_permlayer;
    end

end