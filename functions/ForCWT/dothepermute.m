function [mass_clustermass1,mass_clustermass2, perm_layer1,perm_layer2] = ...
    dothepermute(whichtest,grp1Out,grp2Out,grp1size,grp2size,...
    compTime1,compTime2,osciName,osciRows,t_thresh,nperms)

if length(osciName) ~= 6
    warning('Your frequency bands dont match what they should. You should look into that.')
    keyboard 
end

% preallocate
mass_clustermass1        = NaN([1 nperms]);
theta_clustermass1       = NaN([1 nperms]);
alpha_clustermass1       = NaN([1 nperms]);
betalow_clustermass1     = NaN([1 nperms]);
betahigh_clustermass1    = NaN([1 nperms]);
gammalow_clustermass1    = NaN([1 nperms]);
gammahigh_clustermass1   = NaN([1 nperms]);

mass_clustermass2        = NaN([1 nperms]);
theta_clustermass2       = NaN([1 nperms]);
alpha_clustermass2       = NaN([1 nperms]);
betalow_clustermass2     = NaN([1 nperms]);
betahigh_clustermass2    = NaN([1 nperms]);
gammalow_clustermass2    = NaN([1 nperms]);
gammahigh_clustermass2   = NaN([1 nperms]);

% open the frequency bands back out (avoid overhead global struct use in
% parloop)
theta      = osciRows{1};
alpha      = osciRows{2};
beta_low   = osciRows{3};
beta_high  = osciRows{4};
gamma_low  = osciRows{5};
gamma_high = osciRows{6};

compTime2_1 = compTime2{1}; % all
compTime2_2 = compTime2{2}; % theta
compTime2_3 = compTime2{3}; % ...
compTime2_4 = compTime2{4};
compTime2_5 = compTime2{5};
compTime2_6 = compTime2{6};
compTime2_7 = compTime2{7};

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
    mass_clustermass1(iperm)        = sum(sum(per_clusters(:,compTime1)));
    theta_clustermass1(iperm)       = sum(sum(per_clusters(theta,compTime1)));
    alpha_clustermass1(iperm)       = sum(sum(per_clusters(alpha,compTime1)));
    betalow_clustermass1(iperm)     = sum(sum(per_clusters(beta_low,compTime1)));
    betahigh_clustermass1(iperm)    = sum(sum(per_clusters(beta_high,compTime1)));
    gammalow_clustermass1(iperm)    = sum(sum(per_clusters(gamma_low,compTime1)));
    gammahigh_clustermass1(iperm)   = sum(sum(per_clusters(gamma_high,compTime1)));

    mass_clustermass2(iperm)        = sum(sum(per_clusters(:,compTime2_1)));
    theta_clustermass2(iperm)       = sum(sum(per_clusters(theta,compTime2_2)));
    alpha_clustermass2(iperm)       = sum(sum(per_clusters(alpha,compTime2_3)));
    betalow_clustermass2(iperm)     = sum(sum(per_clusters(beta_low,compTime2_4)));
    betahigh_clustermass2(iperm)    = sum(sum(per_clusters(beta_high,compTime2_5)));
    gammalow_clustermass2(iperm)    = sum(sum(per_clusters(gamma_low,compTime2_6)));
    gammahigh_clustermass2(iperm)   = sum(sum(per_clusters(gamma_high,compTime2_7)));

end

% make it an output struct
perm_layer1 = struct;
perm_layer1.(osciName{1}) = theta_clustermass1;
perm_layer1.(osciName{2}) = alpha_clustermass1;
perm_layer1.(osciName{3}) = betalow_clustermass1;
perm_layer1.(osciName{4}) = betahigh_clustermass1;
perm_layer1.(osciName{5}) = gammalow_clustermass1;
perm_layer1.(osciName{6}) = gammahigh_clustermass1;

perm_layer2 = struct;
perm_layer2.(osciName{1}) = theta_clustermass2;
perm_layer2.(osciName{2}) = alpha_clustermass2;
perm_layer2.(osciName{3}) = betalow_clustermass2;
perm_layer2.(osciName{4}) = betahigh_clustermass2;
perm_layer2.(osciName{5}) = gammalow_clustermass2;
perm_layer2.(osciName{6}) = gammahigh_clustermass2;
