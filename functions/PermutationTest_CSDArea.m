function PermutationTest_CSDArea(homedir,Condition,Groups,yespermute,type)
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

disp(['Permute ' Condition ' CSDs'])

% number of permutations
nperms = 1000; % 500 when ready
pthresh = 0.05;

BL = 400;

%% Load in and concatonate Data
cd (homedir)

tic

[stimList, thisUnit, stimDur, stimITI, ~] = ...
    StimVariable(Condition,1,type);
timeaxis = BL + stimDur + stimITI;

run([Groups{1} '.m']); % brings in animals, channels, Cond, Layer
g1SubList = animals; clear animals
g1Cond    = Cond; clear Cond
run([Groups{2} '.m']);
g2SubList = animals; clear animals
g2Cond    = Cond; clear Cond channels Layer

for iStim = 1:length(stimList)
    
    disp(['For stimulus: ' num2str(stimList(iStim))])

    % preallocation
    g1CSD = NaN(1,25,timeaxis);
    g2CSD = NaN(1,25,timeaxis);
    % stack first group data
    for iSub = 1:length(g1SubList)
        load([g1SubList{iSub} '_Data.mat'], 'Data')
        index = StimIndex({Data.Condition},g1Cond,iSub,Condition);
        % if this animal doesn't have a measurement of this type, skip
        if isempty(index); continue; end
        % we're taking 25 channels as our size of the average. There are a
        % few subjects that fall below that, which need a NaN buffer
        curCSD = nanmean(Data(index).sngtrlCSD{iStim},3); % subject average
        if size(curCSD,1) < 25
            g1CSD(iSub,1:size(curCSD,1),:) = curCSD;
        else
            g1CSD(iSub,:,:) = curCSD(1:25,:);
        end
    end

    for iSub = 1:length(g2SubList)
        load([g2SubList{iSub} '_Data.mat'], 'Data')
        index = StimIndex({Data.Condition},g2Cond,iSub,Condition);
        % if this animal doesn't have a measurement of this type, skip
        if isempty(index); continue; end
        % we're taking 25 channels as our size of the average. There are a
        % few subjects that fall below that, which need a NaN buffer
        curCSD = nanmean(Data(index).sngtrlCSD{iStim},3); % subject average
        if size(curCSD,1) < 25
            g2CSD(iSub,1:size(curCSD,1),:) = curCSD;
        else
            g2CSD(iSub,:,:) = curCSD(1:25,:);
        end
    end
    clear Data

    %Stack the individual animals' data (animal#x54x600)
    % split out the one you want and get the power or phase mats

    grp1size = size(g1CSD,1);
    grp2size = size(g2CSD,1);

    %% Permutation Step 1 - Observed Differences

    obs1_mean = squeeze(mean(g1CSD,1));
    obs1_std = squeeze(std(g1CSD,0,1));

    obs2_mean = squeeze(mean(g2CSD,1));
    obs2_std = squeeze(std(g2CSD,0,1));

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
    if exist('PermCSD','dir') == 7
        cd PermCSD
    else
        mkdir('PermCSD'),cd PermCSD
    end

    if yespermute == 1
        %% Permutation Step 3 - do the permute

        % Jeff's:
        % Monte Carlo permutation: Tperm,POS and NEG ClusterSizes

        % stack groups together
        AllData = cat(1,g1CSD,g2CSD); % (19 x 54 x 4000)

        % permute
        perm_stat = zeros(nperms,size(AllData,2),size(AllData,3));
        ClustSizePOSperm = zeros(nperms,1);
        ClustSizeNEGperm = zeros(nperms,1);

        for iperm = 1:nperms
            [perm_stat(iperm,:,:),ClustSizePOSperm(iperm),ClustSizeNEGperm(iperm)] =...
                mymontecarlo(AllData,grp1size,grp2size);
        end

        % Find significant clusters in real group
        % Kat: this is checking at which points on the matrix, the t statistic is
        % higher at a level significantly above chance, not looking at clusters
        POSpval = zeros(size(AllData,2),size(AllData,3));
        NEGpval = zeros(size(AllData,2),size(AllData,3));
        for icol = 1:size(AllData,3)
            for irow = 1:size(AllData,2)
                POSpval(irow,icol) = sum(perm_stat(:,irow,icol) > obs_stat(irow,icol))/nperms;
                NEGpval(irow,icol) = sum(perm_stat(:,irow,icol) < obs_stat(irow,icol))/nperms;
            end
        end

        % get the boundaries for when our pthreshold is satisfied based on the t
        % statistic comparison above
        [BsigPOSchan,LsigPOSchan,~] = bwboundaries(POSpval<pthresh);
        [BsigNEGchan,LsigNEGchan,~] = bwboundaries(NEGpval<pthresh);

        % sanity check
        % imagesc(POSpval<pthresh); hold on
        % for k = 1:length(BsigPOSchan)
        %     boundary = BsigPOSchan{k};
        %     plot(boundary(:,2),boundary(:,1),'w','Linewidth',2)
        % end

        % get value that is the 97.5 percentile of this distribution of overall
        % areas
        sigPOSsizeChan = prctile(ClustSizePOSperm,100-(pthresh*100));
        sigNEGsizeChan = prctile(ClustSizeNEGperm,100-(pthresh*100));

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
    nexttile;
    imagesc(obs1_mean)
    xline(BL+1,'LineWidth',2,'Color','w') % onset
    xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
    title(Groups{1})
    clim([-0.3 0.3])
    colormap jet
    colorbar

    nexttile;
    imagesc(obs2_mean)
    xline(BL+1,'LineWidth',2,'Color','w') % onset
    xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
    title(Groups{2})
    clim([-0.3 0.3])
    colormap jet
    colorbar

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
        for k = 1:length(BsigNEGchan)
            boundary = BsigNEGchan{k};
            % only keep boundaries that are larger than 3x3
            if length(unique(boundary(:,2))) > 3 && ...
                    length(unique(boundary(:,1))) > 3
                plot(boundary(:,2),boundary(:,1),thiscolor,'Linewidth',2)
            end
        end
    end
    title('Difference')
    colormap jet
    colorbar

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig([Groups{1} 'v' Groups{2} ' Observed CSD ' Condition ' ' num2str(stimList(iStim))  ' ' thisUnit])
    % saveas(gcf, ['Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
    close(h)

    %% t fig

    tiledlayout('vertical');
    nexttile;
    imagesc(obs_stat)
    title('statistic')
    colorbar

    statfig = nexttile;
    imagesc(obs_clusters)
    title('significant')
    colormap(statfig,statmap); colorbar

    ESfig = nexttile;
    imagesc(effectsize)
    title('effect size')
    colormap(ESfig,ESmap); colorbar

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig([Groups{1} 'v' Groups{2} '_Observed CSD t and p ' ...
        Condition ' ' num2str(stimList(iStim)) ' ' thisUnit])
    % saveas(gcf, ['Observed t and p ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
    close(h)

end % stimulus order
toc

