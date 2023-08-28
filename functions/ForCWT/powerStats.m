function [obs_t, cohensD, obs_clusters] = powerStats(obs1_mean, obs2_mean, ...
        obs1_std, obs2_std, grpsize1, grpsize2, t_thresh)
    
    obs_t = (obs1_mean - obs2_mean)./...
        sqrt((obs1_std.^2/grpsize1) + (obs2_std.^2/grpsize2));
    
    % cohen's d mat
    S = sqrt((((grpsize1 - 1).*obs1_std.^2)+((grpsize2-1).*obs2_std.^2))/...
        (grpsize1 + grpsize2 - 2));
    cohensD = (obs1_mean-obs2_mean)./S;
    % bin for effect size
    cohensD(cohensD<0.5  & cohensD>-0.5) = 0; % small or very small
    cohensD(cohensD>0.5  & cohensD<0.8)  = 0.5; % medium
    cohensD(cohensD<-0.5 & cohensD>-0.8) = 0.5; % medium
    cohensD(cohensD>0.8  & cohensD<1.2)  = 1; % large
    cohensD(cohensD<-0.8 & cohensD>-1.2) = 1; % large
    cohensD(cohensD>1.2)                 = 1.5; % very large
    cohensD(cohensD<-1.2)                = 1.5; % very large

    % get the full mat clustermass
    obs_clusters = obs_t;
    obs_clusters(t_thresh*-1 < obs_clusters & obs_clusters < t_thresh) = 0;
    obs_clusters(obs_clusters <= t_thresh*-1) = -1;
    obs_clusters(obs_clusters >= t_thresh) = 1;
    
end