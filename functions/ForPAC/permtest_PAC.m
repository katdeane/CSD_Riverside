function permtest_PAC(homedir, whichsig)
% This function takes the calculated tmatrix from visualize_PAC.m and
% performs the same test again nperm amount of times. It compares the
% observed value of the sum of clustermap points in two regions of interest
% against the created permutation distribution and gives a p value output
% showing where on the distribution it falls. 

% Input:    \Comparison\PACoutput\*Hz_Lay*.mat 
%           & \*_output\*_PhaseAmpCoupling.csv
% Output:   \Comparison\PACoutput\*Hz_Lay*_permstats.mat

% NOTE: This is currently being run only with the center channel for each
% layer and not all channels in the layer together as is the visualize_PAC.m 

% NOTE: there is no dynamic input other than the home directory, this
% will take the data generated earlier in the bat vs mouse pipeline and no
% other at the moment.

% load all the data in together
BatT      = readtable(['FAFAC_' whichsig '_PhaseAmpCoupling.csv']);
MouseT    = readtable(['CIC_' whichsig '_PhaseAmpCoupling.csv']);

% stimfreq list
Batfreq   = unique(BatT.StimFreq);
Mousefreq = unique(MouseT.StimFreq);
% layer list
laylist   = {'II' 'IV' 'V' 'VI'};

% get unique phases and amps and number of each
phases    = unique([BatT.phase_from]);
amps      = unique([BatT.amp_from]);
Nph       = numel(phases);
Namp      = numel(amps);

% permute features
nperm   = 1000;
ROI_DHG = {1:8,1:3};  % phase of delta, amp of high gamma
ROI_TLG = {9:15,2:4}; % phase of theta, amp of low gamma

for iFr = 1:length(Mousefreq)
    
    BatHz   = BatT(BatT.StimFreq     == Batfreq(iFr),:);
    MouseHz = MouseT(MouseT.StimFreq == Mousefreq(iFr),:);
    
    for iLay = 1:length(laylist)
        %% Observed values 
        
        % load current target observed significance results
        curOBS = [num2str(Mousefreq(iFr)) 'Hz_Lay' laylist{iLay} '_' whichsig '.mat'];
        load(curOBS,'tmatrix','t_thresh')
        % convert it to a clustermap
        clusters = abs(tmatrix);
        clusters(clusters < t_thresh) = NaN;
        clusters(clusters >= t_thresh) = 1;
        % take your regions of interest
        obsDHG = nansum(nansum(clusters(ROI_DHG{1},ROI_DHG{2})));
        obsTLG = nansum(nansum(clusters(ROI_TLG{1},ROI_TLG{2})));
          
        %% Permute
        
        MouseCh = MouseHz(contains(MouseHz.CenterChan, ['center' laylist{iLay}]),:);
        BatCh   = BatHz(contains(BatHz.CenterChan, ['center' laylist{iLay}]),:);
        % concatonate both groups
        AllCh   = vertcat(MouseCh, BatCh); 
        
        Grp1meas = size(MouseCh,1)/Namp/Nph;
        Grp2meas = size(BatCh,1)/Namp/Nph;
        permDHG = NaN([1 nperm]);
        permTLG = NaN([1 nperm]);
        
        for iperm = 1:nperm
            order = randperm(size(AllCh,1)/Namp/Nph);

            % Group 1

            % preallocate PAC matrix
            Grp1PAC = NaN(Namp, Nph, Grp1meas);
            Grp2PAC = NaN(Namp, Nph, Grp2meas);

            for iamp = 1:Namp

                AMP = AllCh(AllCh.amp_from == amps(iamp),:);

                for iph = 1:Nph

                    PH = AMP(AMP.phase_from == phases(iph),:);
                    % pull out for the groups based on the permute order
                    set1 = order(1:Grp1meas);
                    set2 = order(Grp1meas+1:Grp1meas+Grp2meas);
                    Grp1PAC(iamp, iph, :) = PH.zMI(set1);
                    Grp2PAC(iamp, iph, :) = PH.zMI(set2);

                end
            end

            % Student's t test
            % mean and std
            Grp1Avg = flip(nanmean(Grp1PAC,3),1);
            Grp2Avg = flip(nanmean(Grp2PAC,3),1);
            Grp1STD = flip(nanstd(Grp1PAC,0,3),1); % 0 = don't normalize
            Grp2STD   = flip(nanstd(Grp2PAC,0,3),1);
            % run a matrix t-test
            permtmatrix = (Grp1Avg - Grp2Avg)./...
                sqrt((Grp1STD.^2/Grp1meas) + (Grp2STD.^2/Grp2meas));

            permclusters = abs(permtmatrix);
            permclusters(permclusters < t_thresh) = NaN;
            permclusters(permclusters >= t_thresh) = 1;

            permDHG(iperm) = nansum(nansum(permclusters(ROI_DHG{1},ROI_DHG{2})));
            permTLG(iperm) = nansum(nansum(permclusters(ROI_TLG{1},ROI_TLG{2})));

        end

        %compare how many instances the sum of the permutation is greater than observed
        sigDHG   = sum(permDHG > obsDHG,2); 
        p_DHG    = sigDHG/nperm;
        mean_DHG = mean(permDHG);
        std_DHG  = std(permDHG);
        
        sigTLG   = sum(permTLG > obsTLG,2); 
        p_TLG    = sigTLG/nperm;
        mean_TLG = mean(permTLG);
        std_TLG  = std(permTLG);
        
        cd(homedir); cd Comparison; cd PACoutput % should exist already
        Savename = [num2str(Batfreq(iFr)) 'Hz_Lay' laylist{iLay} '_' whichsig '_permstats'];
        save([Savename '.mat'],'sigDHG','p_DHG','mean_DHG','std_DHG',...
            'sigTLG','p_TLG','mean_TLG','std_TLG')
    end
end
end