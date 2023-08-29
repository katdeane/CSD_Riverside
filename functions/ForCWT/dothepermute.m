function [mass_clustermass, perm_layer] = dothepermute(whichtest,grp1Out,grp2Out,grp1size,grp2size,...
    compTime,osciName,osciRows,t_thresh,nperms)

if length(osciName) ~= 6
    warning('Your frequency bands dont match what they should. You should look into that.')
    keyboard 
end

% preallocate
mass_clustermass        = NaN([1 nperms]);
theta_clustermass       = NaN([1 nperms]);
alpha_clustermass       = NaN([1 nperms]);
betalow_clustermass     = NaN([1 nperms]);
betahigh_clustermass    = NaN([1 nperms]);
gammalow_clustermass    = NaN([1 nperms]);
gammahigh_clustermass   = NaN([1 nperms]);

% open the frequency bands back out (avoid overhead global struct use in
% parloop)
theta      = osciRows{1};
alpha      = osciRows{2};
beta_low   = osciRows{3};
beta_high  = osciRows{4};
gamma_low  = osciRows{5};
gamma_high = osciRows{6};

parfor iperm = 1:nperms
    % put the whole group in one container
    contAll = [grp1Out;grp2Out];
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

    % check cluster mass for compTime (BL:stimDur)
    mass_clustermass(iperm)        = sum(sum(per_clusters(:,compTime)));
    theta_clustermass(iperm)       = sum(sum(per_clusters(theta,compTime)));
    alpha_clustermass(iperm)       = sum(sum(per_clusters(alpha,compTime)));
    betalow_clustermass(iperm)     = sum(sum(per_clusters(beta_low,compTime)));
    betahigh_clustermass(iperm)    = sum(sum(per_clusters(beta_high,compTime)));
    gammalow_clustermass(iperm)    = sum(sum(per_clusters(gamma_low,compTime)));
    gammahigh_clustermass(iperm)   = sum(sum(per_clusters(gamma_high,compTime)));

end

% make it an output struct
perm_layer = struct;
perm_layer.(osciName{1}) = theta_clustermass;
perm_layer.(osciName{2}) = alpha_clustermass;
perm_layer.(osciName{3}) = betalow_clustermass;
perm_layer.(osciName{4}) = betahigh_clustermass;
perm_layer.(osciName{5}) = gammalow_clustermass;
perm_layer.(osciName{6}) = gammahigh_clustermass;
