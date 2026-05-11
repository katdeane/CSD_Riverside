function PermutationTest(homedir,whichtest,params,yespermute)
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
nperms = 500; % 500 when ready
pthresh = 0.05/7; %bonferroni for 6 osci bands and full mat

BL = 399;
% actual intended frequencies commented
theta = (49:54);        %(4:7);
alpha = (44:48);        %(8:12);
beta_low = (39:43);     %(13:18);
beta_high = (34:38);    %(19:30);
gamma_low = (26:33);    %(31:60);
gamma_high = (19:25);   %(61:100);

osciName = {'theta' 'alpha' 'beta_low' 'beta_high' 'gamma_low' 'gamma_high'};
osciRows = {theta alpha beta_low beta_high gamma_low gamma_high};

% for the comparison between, they have different frequency stimuli, so we
% should only directly compared the first stimuli which are matched in time
% if str2double(MouseFreq) > str2double(BatFreq)
%     compTime = 1:1000/str2double(MouseFreq)+200; % comparing BL time also
% else
%     compTime = 1:1000/str2double(BatFreq)+200; % comparing BL time also
% end

%% Load in and concatonate Data
cd (homedir); cd output; cd WToutput
% load('Cone.mat','cone');

for iCond = 1:length(params.condList)
    tic
    disp(['For condition: ' params.condList{iCond}])

    % condition specific info
   [stimList, thisUnit, stimDur, ~, ~,compDur1,compDur2] = ...
    StimVariableCWT(params.condList{iCond},1);
    % timeAxis = BL + stimDur + stimITI; % time axis for visualization
    compTime1 = BL+compDur1+1; % time of onset permutation comparison
    compTime2 = cellfun(@(x) x+BL+1, compDur2, 'UniformOutput',false); % time of permutation comparison

    for iStim = 1:length(stimList)
        disp(['For stimulus: ' num2str(stimList(iStim))])

        % stack first group data
        input = dir([params.groups{1} '*_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '_WT.mat']);
        % initialize table with first input
        load(input(1).name, 'wtTable')
        group1WT = wtTable; clear wtTable
        % start on 2 and add further input to full tables
        for iIn = 2:length(input)
            if contains('MWT16b_NoiseBurst',input(iIn).name) % special case
                continue
            end
            load(input(iIn).name, 'wtTable')
            group1WT = [group1WT; wtTable]; %#ok<AGROW>
        end

        % stack second group data
        input = dir([params.groups{2} '*_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '_WT.mat']);
        % initialize table with first input
        load(input(1).name, 'wtTable')
        group2WT = wtTable; clear wtTable
        % start on 2 and add further input to full tables
        for iIn = 2:length(input)
            if contains('MWT16b_NoiseBurst',input(iIn).name) % special case
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
            if contains(whichtest,'Power')
                % t Threshold

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
            end

            % Mann-Whitney U test and r effect size
            if contains(whichtest,'Phase')
                t_thresh = NaN;
                [obs_stat, effectsize, obs_clusters] = phaseStats(grp1Out, ...
                    grp2Out, grp1size, grp2size);

                % make sure the range is captured
                obs_clusters(19,1) = 1;
                obs_clusters(20,1) = -1; 

                % effect size colormap
                ESmap = [250/255 240/255 240/255
                    230/255 179/255 179/255
                    184/255 61/255 65/255
                    61/255 20/255 22/255];
                % clusters colormap
                statmap = [189/255 64/255 6/255
                    205/255 197/255 180/255
                    5/255 36/255 56/255];
            end

            %% pull out clustermass only at specific time point!
            % - 5.28 hz 189 ms, 40 hz 25 ms

            % all channels
            % check cluster mass for onset
            obs_clustermass1 = sum(sum(obs_clusters(:,compTime1)));
            % check cluster mass for later time window
            obs_clustermass2 = sum(sum(obs_clusters(:,compTime2{1})));

            % for layer specific:
            obs_layer1 = struct;
            obs_layer2 = struct;

            for ispec = 1:length(osciName)
                obs_layer1.(osciName{ispec}) = obs_clusters(osciRows{ispec},compTime1);
                obs_layer2.(osciName{ispec}) = obs_clusters(osciRows{ispec},compTime2{ispec+1});

                % % sum clusters (twice to get final value)
                for i = 1:2
                    obs_layer1.(osciName{ispec}) = sum(obs_layer1.(osciName{ispec}));
                    obs_layer2.(osciName{ispec}) = sum(obs_layer2.(osciName{ispec}));
                end
            end

            cd(homedir); cd figures;
            if exist('CWT','dir') == 7
                cd CWT
            else
                mkdir('CWT'),cd CWT
            end
            %% dif fig
            tiledlayout('vertical')
            grp1Fig = nexttile;
            imagesc(flipud(obs1_mean(19:54,:))) % the cwt function gives us back a yaxis flipped result
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            xline(BL+1,'LineWidth',2,'Color','w') % onset
            xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
            title(params.groups{1})
            colorbar
            clim = get(gca,'clim');

            grp2Fig = nexttile;
            imagesc(flipud(obs2_mean(19:54,:)))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            xline(BL+1,'LineWidth',2,'Color','w') % onset
            xline(BL+stimDur+1,'LineWidth',2,'Color','w') % offset
            title(params.groups{2})
            colorbar
            clim = [clim; get(gca,'clim')]; %#ok<AGROW>

            nexttile
            imagesc(flipud(obs_difmeans(19:54,:)))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})

            xline(compTime1(1),'LineWidth',2,'Color','w') % onset comp
            xline(compTime1(end),'LineWidth',2,'Color','w') % onset comp
            fix_axes = 54:-1:1;

            % later comp
            for ispec = 1:length(osciName)
                if isempty(compTime2{ispec+1})
                    continue
                end
                rectangle('position',[compTime2{ispec+1}(1) find(fix_axes == osciRows{ispec}(end)) ...
                    length(compTime2{ispec+1}) length(osciRows{ispec})],'EdgeColor','w')
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
            savefig([params.groups{1} 'v' params.groups{2} '_Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
            % saveas(gcf, ['Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
            close(h)

            %% t fig

            tiledlayout('vertical');
            nexttile;
            imagesc(flipud(obs_stat(19:54,:)))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            title('statistic')
            colorbar

            statfig = nexttile;
            imagesc(flipud(obs_clusters(19:54,:)))
            set(gca,'Ydir','normal')
            yticks([0 8 16 21 24 26 29 32 35])
            yticklabels({'0','10','20','30','40','50','60','80','100'})
            title('significant')
            colormap(statfig,statmap); colorbar

            ESfig = nexttile;
            imagesc(flipud(effectsize(19:54,:)))
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
            savefig([params.groups{1} 'v' params.groups{2} '_Observed t and p ' ...
                whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
            % saveas(gcf, ['Observed t and p ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
            close(h)

            if yespermute == 1
                %% Permutation Step 3 - do the permute
                [mass_clustermass1,mass_clustermass2,perm_layer1,perm_layer2] = ...
                    dothepermute(whichtest,grp1Out,grp2Out,grp1size,...
                    grp2size,compTime1,compTime2,osciName,osciRows,t_thresh,nperms);


                %% Check Significance of full clustermass

                % In how many instances is the observed clustermass MORE than
                % the permuted clustermasses (obs clustermass sig above chance)
                sig_mass_onset = sum(mass_clustermass1>obs_clustermass1,2);
                pVal_onset     = sig_mass_onset/nperms;
                permMean_onset = mean(mass_clustermass1);
                permSTD_onset  = std(mass_clustermass1);

                sig_mass_post = sum(mass_clustermass2>obs_clustermass2,2);
                pVal_post     = sig_mass_post/nperms;
                permMean_post = mean(mass_clustermass2);
                permSTD_post  = std(mass_clustermass2);

                figure('Name',['Observed cluster vs Permutation ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}]);
                boxplot([mass_clustermass1' mass_clustermass2']); hold on;

                if pVal_onset < 0.007
                    plot(1,obs_clustermass1,'go','LineWidth',4)
                else
                    plot(1,obs_clustermass1,'ro','LineWidth',4)
                end
                if pVal_post < 0.007
                    plot(2,obs_clustermass2,'go','LineWidth',4)
                    if obs_clustermass2 > max(ylim)
                        ylim([min(ylim) obs_clustermass2])
                    end
                else
                    plot(2,obs_clustermass2,'ro','LineWidth',4)
                end

                legend(['p = ' num2str(pVal_onset)],['p = ' num2str(pVal_post)])

                h = gcf;
                h.Renderer = 'Painters';
                set(h, 'PaperType', 'A4');
                set(h, 'PaperOrientation', 'landscape');
                set(h, 'PaperUnits', 'centimeters');
                savefig([params.groups{1} 'v' params.groups{2} '_Full Permutation ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
                close(h)
                save([params.groups{1} 'v' params.groups{2} '_Permutation '...
                    whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) ...
                    thisUnit ' ' params.layers{iLay} '.mat'],...
                    'pVal_onset','permMean_onset','permSTD_onset',...
                    'pVal_post','permMean_post','permSTD_post')

                %% Check Significance of layers' clustermass

                Permfig = tiledlayout('flow');
                    title(Permfig,['Observed cluster vs Permutation ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
                    ylabel(Permfig, 'Permutation distribution')
                    xlabel(Permfig, '1 = onset, 2 = post')

                for ispec = 1:length(osciName)
                    % In how many instances is the observed clustermass MORE than
                    % the permuted clustermasses (obs clustermass sig above chance)
                    sig_mass_onset = sum(perm_layer1.(osciName{ispec})>obs_layer1.(osciName{ispec}),2);
                    pVal_onset = sig_mass_onset/nperms;
                    permMean_onset = mean(perm_layer1.(osciName{ispec}));
                    permSTD_onset = std(perm_layer1.(osciName{ispec}));

                    sig_mass_post = sum(perm_layer2.(osciName{ispec})>obs_layer2.(osciName{ispec}),2);
                    pVal_post = sig_mass_post/nperms;
                    permMean_post = mean(perm_layer2.(osciName{ispec}));
                    permSTD_post = std(perm_layer2.(osciName{ispec}));

                    nexttile
                    boxplot([perm_layer1.(osciName{ispec})' perm_layer2.(osciName{ispec})']); hold on;

                    if pVal_onset < pthresh
                        plot(1,obs_layer1.(osciName{ispec}),'go','LineWidth',4)
                    else
                        plot(1,obs_layer1.(osciName{ispec}),'ro','LineWidth',4)
                    end
                    if pVal_post < pthresh
                        plot(2,obs_layer2.(osciName{ispec}),'go','LineWidth',4)
                        if obs_layer2.(osciName{ispec}) > max(ylim)
                            ylim([min(ylim) obs_layer2.(osciName{ispec})])
                        end
                    else
                        plot(2,obs_layer2.(osciName{ispec}),'ro','LineWidth',4)
                    end

                    legend(['p = ' num2str(pVal_onset)],['p = ' num2str(pVal_post)]) 
                    title(osciName{ispec})

                    save([params.groups{1} 'v' params.groups{2} ' ' osciName{ispec} ...
                        ' permutation ' whichtest ' ' params.condList{iCond} ...
                        ' ' num2str(stimList(iStim)) thisUnit ' ' ...
                        params.layers{iLay} '.mat'],...
                        'pVal_onset','permMean_onset','permSTD_onset',...
                        'pVal_post','permMean_post','permSTD_post')
                end
                h = gcf;
                h.Renderer = 'Painters';
                set(h, 'PaperType', 'A4');
                set(h, 'PaperOrientation', 'landscape');
                set(h, 'PaperUnits', 'centimeters');
                savefig([params.groups{1} 'v' params.groups{2} '_Permutation ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay}])
                close(h)
            end
            clear grp1Lay gr2Lay
        end
        clear group1WT group2WT
        cd (homedir); cd output; cd WToutput
    end % stimulus order
    toc
end % condition
