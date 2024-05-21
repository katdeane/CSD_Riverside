function PermutationTest_Area(homedir,whichtest,params,Groups,yespermute,type)
% Input:    Layer to analyze, (possible input: relative to BF)
%           Needs scalogramsfull.mat from Andrew Curran's wavelet analysis
% specifying Power: trials are averaged and then power is taken from
%           the complex WT output of runCwtCsd function above. Student's t
%           test and Cohen'd d effect size are the stats used for observed
%           and permutation difference
% specifying Phase: phase is taken per trial. mwu test and r effect
%           size are the stats used
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
%% standard operations

if ~exist('whichtest','var')
    whichtest = 'Power'; % or 'Phase'
end

disp(['Observed ' whichtest ' and maybe permutations'])

% number of permutations
nperms = 1000; % 500 when ready
pthresh = 0.05; 

BL = 399;

%% Load in and concatonate Data
cd (homedir); cd output; cd WToutput
% load('Cone.mat','cone');

for iCond = 1:length(params.condList)
    tic
    disp(['For condition: ' params.condList{iCond}])

    % condition specific info
    % if matches(animals(iSub),'FOS01') 
    %     [stimList, thisUnit, stimDur, ~, ~,~,~] = ...
    %         StimVariableCWT(params.condList{iCond},1,'Awake1');
    % else
        [stimList, thisUnit, stimDur, ~, ~,~,~] = ...
            StimVariableCWT(params.condList{iCond},1,type);
    % end
    % timeAxis = BL + stimDur + stimITI; % time axis for visualization
    % compTime1 = BL+compDur1+1; % time of onset permutation comparison
    % compTime2 = cellfun(@(x) x+BL+1, compDur2, 'UniformOutput',false); % time of permutation comparison

    for iStim = 1:length(stimList)
        disp(['For stimulus: ' num2str(stimList(iStim))])

        % stack first group data
        input = dir([Groups{1} '*_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '_WT.mat']);
        % initialize table with first input
        load(input(1).name, 'wtTable')
        group1WT = wtTable; clear wtTable
        % start on 2 and add further input to full tables
        for iIn = 2:length(input)
            if contains(input(iIn).name,'MWT16b_NoiseBurst') % special case
                continue
            end
            load(input(iIn).name, 'wtTable')
            group1WT = [group1WT; wtTable]; %#ok<AGROW>
        end

        % stack second group data
        input = dir([Groups{2} '*_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '_WT.mat']);
        % initialize table with first input
        load(input(1).name, 'wtTable')
        group2WT = wtTable; clear wtTable
        % start on 2 and add further input to full tables
        for iIn = 2:length(input)
            if contains(input(iIn).name,'MWT16b_NoiseBurst') % special case
                continue
            end
            load(input(iIn).name, 'wtTable')
            group2WT = [group2WT; wtTable]; %#ok<AGROW>
        end
        clear wtTable

        % loop through layers here
        %Stack the individual animals' data (animal#x54x600)
        for iLay = 1:length(params.layers)
            % split out the one you want and get the power or phase mats
            grp1Lay = group1WT(matches(group1WT.layer, params.layers{iLay}),:);
            grp2Lay = group2WT(matches(group2WT.layer, params.layers{iLay}),:);

            if contains(whichtest, 'Power')

                grp1Out = getpowerout(grp1Lay);
                grp2Out = getpowerout(grp2Lay);

            elseif contains(whichtest, 'Phase')

                grp1Out = getphaseout(grp1Lay);
                grp2Out = getphaseout(grp2Lay);

            end

            % relevant spectral bands: theta - high gamma
            grp1Out = grp1Out(:,19:54,:);
            grp2Out = grp2Out(:,19:54,:);

            grp1size = size(grp1Out,1);
            grp2size = size(grp2Out,1);

            %% Permutation Step 1 - Observed Differences

            obs1_mean = squeeze(mean(grp1Out,1));
            obs1_std = squeeze(std(grp1Out,0,1));

            obs2_mean = squeeze(mean(grp2Out,1));
            obs2_std = squeeze(std(grp2Out,0,1));

            obs_difmeans = obs1_mean - obs2_mean;

            %% Permutation Step 2 - t test or mwu test
            %find the t values along all data points for each frequency bin

            % Student's t test and cohen's d effect size
            [t_thresh, ~] = givetThresh(grp1size, grp2size);
            % Check this link to verify: http://www.ttable.org/

            [obs_stat, effectsize, obs_clusters] = powerStats(obs1_mean, ...
                obs2_mean, obs1_std, obs2_std, grp1size, grp2size, t_thresh);

            % effect size colormap
            ESmap = [250/255 240/255 240/255
                230/255 179/255 179/255
                209/255 117/255 120/255
                184/255 61/255 65/255
                122/255 41/255 44/255
                61/255 20/255 22/255];
            % clusters colormap
            statmap = [189/255 64/255 6/255
                205/255 197/255 180/255
                5/255 36/255 56/255];


            % posclust = obs_clusters;
            % posclust(obs_clusters(19:54,:)<0) = 0;
            % [B,~] = bwboundaries(posclust);

            cd(homedir); cd figures;
            if exist('CWT','dir') == 7
                cd CWT
            else
                mkdir('CWT'),cd CWT
            end

            if yespermute == 1
                %% Permutation Step 3 - do the permute

                % Jeff's:
                disp('monte');
                % Monte Carlo permutation: Tperm,POS and NEG ClusterSizes

                % stack groups together
                AllData = cat(1,grp1Out,grp2Out); % (19 x 54 x 4000)

                % permute
                perm_stat = zeros(nperms,size(AllData,2),size(AllData,3));
                ClustSizePOSperm = zeros(nperms,1);

                for iperm = 1:nperms
                    [perm_stat(iperm,:,:),ClustSizePOSperm(iperm)] =...
                        mymontecarlo(AllData,grp1size,grp2size);
                end

                % Find significant clusters in real group
                % Kat: this is checking at which points on the matrix, the t statistic is
                % higher at a level significantly above chance, not looking at clusters
                POSpval = zeros(size(AllData,2),size(AllData,3));
                for icol = 1:size(AllData,3)
                    for irow = 1:size(AllData,2)
                        POSpval(irow,icol) = sum(perm_stat(:,irow,icol) > obs_stat(irow,icol))/nperms;
                    end
                end

                % get the boundaries for when our pthreshold is satisfied based on the t
                % statistic comparison above
                [BsigPOSchan,LsigPOSchan,~] = bwboundaries(POSpval<pthresh);
                
                % sanity check
                % imagesc(POSpval<pthresh); hold on
                % for k = 1:length(BsigPOSchan)
                %     boundary = BsigPOSchan{k};
                %     plot(boundary(:,2),boundary(:,1),'w','Linewidth',2)
                % end

                % get value that is the 97.5 percentile of this distribution of overall
                % areas
                sigPOSsizeChan = prctile(ClustSizePOSperm,100-(pthresh*100));

                % Verify if the overall area where p < pthresh is larger
                % than the 97.5 percentile of the perm distribution
                if sum(sum(LsigPOSchan)) > sigPOSsizeChan
                    isSig = true; % leaving this in here for readability
                    thiscolor = 'w'; % significant results will have white line
                else
                    isSig = false;
                    thiscolor = 'k'; % non significant will be black
                end

            end
            clear grp1Lay gr2Lay

            %% dif fig
            tiledlayout('vertical')
            grp1Fig = nexttile;
            imagesc(flipud(obs1_mean)) % the cwt function gives us back a yaxis flipped result
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            xline(BL+1,'LineWidth',2,'Color','w') % onset
            xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
            title(Groups{1})
            colorbar
            clim = get(gca,'clim');

            grp2Fig = nexttile;
            imagesc(flipud(obs2_mean))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            xline(BL+1,'LineWidth',2,'Color','w') % onset
            xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
            title(Groups{2})
            colorbar
            clim = [clim; get(gca,'clim')]; %#ok<AGROW>

            nexttile
            imagesc(obs_difmeans)
            % just trust the axes from above
            if yespermute == 1
                hold on % plot areas of significance p < 0.05
                for k = 1:length(BsigPOSchan)
                    boundary = BsigPOSchan{k};
                    % only keep boundaries that are larger than 3x3  
                    if length(unique(boundary(:,2))) > 3 && ...
                            length(unique(boundary(:,1))) > 3
                        plot(boundary(:,2),boundary(:,1),thiscolor,'Linewidth',2)
                    end
                end
            end
            title('Difference')
            colorbar

            newC = [min(clim(:)) max(clim(:))];

            % scale clims the same
            set(grp2Fig,'Clim',newC); colorbar
            set(grp1Fig,'Clim',newC); colorbar

            h = gcf;
            h.Renderer = 'Painters';
            set(h, 'PaperType', 'A4');
            set(h, 'PaperOrientation', 'landscape');
            set(h, 'PaperUnits', 'centimeters');
            savefig([Groups{1} 'v' Groups{2} '_Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
            % saveas(gcf, ['Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
            close(h)

            %% t fig

            tiledlayout('vertical');
            nexttile;
            imagesc(flipud(obs_stat))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            title('statistic')
            colorbar

            statfig = nexttile;
            imagesc(flipud(obs_clusters))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            title('significant')
            colormap(statfig,statmap); colorbar

            ESfig = nexttile;
            imagesc(flipud(effectsize))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            title('effect size')
            colormap(ESfig,ESmap); colorbar

            h = gcf;
            h.Renderer = 'Painters';
            set(h, 'PaperType', 'A4');
            set(h, 'PaperOrientation', 'landscape');
            set(h, 'PaperUnits', 'centimeters');
            savefig([Groups{1} 'v' Groups{2} '_Observed t and p ' ...
                whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
            % saveas(gcf, ['Observed t and p ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
            close(h)

        end
        clear group1WT group2WT
        cd (homedir); cd output; cd WToutput
    end % stimulus order
    toc
end % condition
