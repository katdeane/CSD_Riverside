function [obs_stat, effectsize, obs_clusters] = phaseStats(BatOut, MouseOut)

% data coming in is shaped like : measurement x spectral frequency x time
% the mwwtest only takes vectors as input so we'll pull out measurement
% vectors at each time and frequency point

%% Mann Whitney U Test (ranksum)

% initialize containers for each result point
obs_stat     = zeros(size(BatOut,2),size(BatOut,3));
effectsize   = zeros(size(BatOut,2),size(BatOut,3)); % spect freq x time
obs_clusters = zeros(size(BatOut,2),size(BatOut,3));

% this test works on vectors. so we're doing it pointwise. Awyis.
for timepoint = 1:size(BatOut,3)
    for freqpoint = 1:size(BatOut,2)
        
        % take out the point of interest
        pointB = BatOut(:,freqpoint,timepoint)';
        pointM = MouseOut(:,freqpoint,timepoint)';
        
        % two-tailed test (stats.p(2)) like with the ttest2 used in power plots, the
        % samples are large enough to use method 'normal approximation'
        stats = mwwtest(pointB,pointM);
        obs_stat(freqpoint,timepoint) = stats.Z;
        
        if stats.p(2) <= 0.05
            if stats.Z < 0
                sigtest = -1;
            elseif stats.Z > 0
                sigtest = 1;
            end
        else
            sigtest = 0;
        end
        obs_clusters(freqpoint,timepoint) = sigtest;
        
        % effect size of mwwtest is r = abs(z/sqrt(n1+n2)) / 0.1 is small, 0.3 is
        % medium, 0.5 is large
        Esize = abs(stats.Z/sqrt(size(BatOut,1)+size(MouseOut,1)));
        if Esize < 0.1
            ESout = 0;
        elseif Esize >= 0.1 && Esize < 0.3
            ESout = 1;
        elseif Esize >= 0.3 && Esize < 0.5
            ESout = 2;
        elseif Esize >= 0.5
            ESout = 3;
        end
        effectsize(freqpoint,timepoint) = ESout;
    end
end


end