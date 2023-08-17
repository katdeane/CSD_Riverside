function PermutationTest(homedir,BatFreq,MouseFreq,whichtest)
% Input:    Layer to analyze, (possible input: relative to BF)
%           Needs scalogramsfull.mat from Andrew Curran's wavelet analysis
% Output:   Figures for means and observed difference of awake/ketamine
%           comparison; figures for observed t values, clusters, ttest line
%           output; boxplot and significance of permutation test -> Pictures folder

%% standard operations

warning('OFF');
dbstop if error

if ~exist('BatFreq','var') || ~exist('BatFreq','var')
    error('Please specify the frequencies for your group comparison, e.g. BatFreq = "5.28"')
end

if ~exist('whichtest','var') 
    whichtest = 'Power'; % or 'Phase'
end

layers = {'II', 'IV', 'V', 'VI'}; 

cd (homedir); cd Comparison; cd WToutput
load('Cone.mat','cone'); 

nperms = 500;
% pthresh = nperms*(0.05/7); bonferroni for 6 osci bands and full mat

% actual intended frequencies commented
theta = (49:54);        %(4:7);
alpha = (44:48);        %(8:12);
beta_low = (39:43);     %(13:18);
beta_high = (34:38);    %(19:30);
gamma_low = (26:33);    %(31:60);
gamma_high = (19:25);   %(61:100);

osciName = {'theta' 'alpha' 'beta_low' 'beta_high' 'gamma_low' 'gamma_high'};
osciRows = {theta alpha beta_low beta_high gamma_low gamma_high};

% the WT was run on the same time scale for both (limited by the mice)
startTime = -200; % ms 
limit = 1000; % ms
% for the comparison between, they have different frequency stimuli, so we
% should only directly compared the first stimuli which are matched in time
if str2double(MouseFreq) > str2double(BatFreq)
    comptime = 1:1000/str2double(MouseFreq)+200; % comparing BL time also
else
    comptime = 1:1000/str2double(BatFreq)+200; % comparing BL time also
end

%% Load in and concatonate Data
input = dir(['*_' MouseFreq '_WT.mat']);
% initialize table with first input
load(input(1).name, 'wtTable')
MouseWT = wtTable; clear wtTable
% start on 2 and add further input to full tables
for iIn = 2:length(input) 
    load(input(iIn).name, 'wtTable')
    MouseWT = [MouseWT; wtTable];
end

input = dir(['*_' BatFreq '_WT.mat']);
% initialize table with first input
load(input(1).name, 'wtTable')
BatWT = wtTable; clear wtTable
% start on 2 and add further input to full tables
for iIn = 2:length(input)
    load(input(iIn).name, 'wtTable')
    BatWT = [BatWT; wtTable];
end
clear wtTable

% Let's do this Layerwise 
BatWTII = BatWT(matches(BatWT.layer,'II'),:);
BatWTIV = BatWT(matches(BatWT.layer,'IV'),:);
BatWTV  = BatWT(matches(BatWT.layer,'V'),:); 
BatWTVI = BatWT(matches(BatWT.layer,'VI'),:);
clear BatWT

MouseWTII = MouseWT(matches(MouseWT.layer,'II'),:);
MouseWTIV = MouseWT(matches(MouseWT.layer,'IV'),:);
MouseWTV  = MouseWT(matches(MouseWT.layer,'V'),:); 
MouseWTVI = MouseWT(matches(MouseWT.layer,'VI'),:);
clear MouseWT

% loop through layers here
%Stack the individual animals' data (animal#x54x600)
for iLay = 1:length(layers)
    % split out the one you want and get the power or phase mats
    if contains(whichtest, 'Power')
        if matches(layers{iLay},'II')
            BatOut   = getpowerout(BatWTII);
            MouseOut = getpowerout(MouseWTII);
        elseif matches(layers{iLay},'IV')
            BatOut   = getpowerout(BatWTIV);
            MouseOut = getpowerout(MouseWTIV);
        elseif matches(layers{iLay},'V')
            BatOut   = getpowerout(BatWTV);
            MouseOut = getpowerout(MouseWTV);
        elseif matches(layers{iLay},'VI')
            BatOut   = getpowerout(BatWTVI);
            MouseOut = getpowerout(MouseWTVI);
        end
    elseif contains(whichtest, 'Phase')
        if matches(layers{iLay},'II')
            BatOut   = getphaseout(BatWTII);
            MouseOut = getphaseout(MouseWTII);
        elseif matches(layers{iLay},'IV')
            BatOut   = getphaseout(BatWTIV);
            MouseOut = getphaseout(MouseWTIV);
        elseif matches(layers{iLay},'V')
            BatOut   = getphaseout(BatWTV);
            MouseOut = getphaseout(MouseWTV);
        elseif matches(layers{iLay},'VI')
            BatOut   = getphaseout(BatWTVI);
            MouseOut = getphaseout(MouseWTVI);
        end
    end
    
    grpsizeB = size(BatOut,1);
    grpsizeM = size(MouseOut,1);

    %% Permutation Step 1 - Observed Differences

    obs1_mean = squeeze(nanmean(BatOut,1));
    obs1_std = squeeze(nanstd(BatOut,0,1));

    obs2_mean = squeeze(nanmean(MouseOut,1));
    obs2_std = squeeze(nanstd(MouseOut,0,1));

    obs_difmeans = obs1_mean - obs2_mean;

    %% Permutation Step 2 - t test or mwu test 
    %find the t values along all data points for each frequency bin

    % Student's t test and cohen's d effect size
    if contains(whichtest,'Power')
        % t Threshold
        t_thresh = 1.99; % df ~80 (actual 66-72) = two tailed: 1.99, one tailed: 1.664
        % Check this link: http://www.ttable.org/
    
        [obs_stat, effectsize, obs_clusters] = powerStats(obs1_mean, ...
            obs2_mean, obs1_std, obs2_std, grpsizeB, grpsizeM, t_thresh);
        
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
        [obs_stat, effectsize, obs_clusters] = phaseStats(BatOut, MouseOut);
        
        % effect size colormap
        ESmap = [250/255 240/255 240/255
            230/255 179/255 179/255
            184/255 61/255 65/255
            61/255 20/255 22/255];
        % clusters colormap (This is 2 because I know we won't get negative
        % values!)
        statmap = [205/255 197/255 180/255
            5/255 36/255 56/255];
    end
    
    %% pull out clustermass only at specific time point! 
    % - 5.28 hz 189 ms, 40 hz 25 ms
    
    % check cluster mass for 300 ms from tone onset
    obs_clustermass = nansum(nansum(obs_clusters(:,comptime)));

    % for layer specific: 
    obs_layer = struct;

    for ispec = 1:length(osciName)
        obs_layer.(osciName{ispec}) = obs_clusters(osciRows{ispec},comptime);

        % % sum clusters (twice to get final value)
        for i = 1:2
            obs_layer.(osciName{ispec}) = nansum(obs_layer.(osciName{ispec}));
        end
    end

    cd(homedir); cd Comparison; cd figures;
    if exist('CWT','dir') == 7
        cd CWT
    else
        mkdir('CWT'),cd CWT
    end
    %% dif fig
    [X,Y]=meshgrid(cone,startTime:limit);
    figure('Name','Observed Difference Values BF'); %,'Position',[-1070 500 1065 400]
    BatFig = subplot(131);
    surf(Y,X,obs1_mean','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Bat')
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colorbar
    clim = get(gca,'clim');

    MouseFig = subplot(132);
    surf(Y,X,obs2_mean','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Mouse')
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colorbar
    %clim = get(gca,'clim');
    clim = [clim; get(gca,'clim')]; %#ok<AGROW>

    diffFig = subplot(133);
    surf(Y,X,obs_difmeans','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Observed Diff')
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colorbar;
    clim = [clim; get(gca,'clim')]; %#ok<AGROW>

    newC = [min(clim(:)) max(clim(:))];

    % scale clims the same
    set(MouseFig,'Clim',newC);colorbar;
    set(BatFig,'Clim',newC);colorbar;
    set(diffFig,'Clim',newC);colorbar;

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig(['Observed Difference ' whichtest ' ' layers{iLay} ' ' MouseFreq])
    saveas(gcf, ['Observed Difference ' whichtest ' ' layers{iLay} ' ' MouseFreq '.pdf'])
    close(h)
    
    %% t fig 

    figure('Name','Observed t Values BF'); 
    subplot(131);
    surf(Y,X,obs_stat','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Stats Mat')
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colorbar

    statfig = subplot(132);
    surf(Y,X,obs_clusters','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Clusters where p>0.05')
    colormap(statfig,statmap)
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colorbar
        
    ESfig = subplot(133);
    surf(Y,X,effectsize','EdgeColor','None'); view(2);
    set(gca,'YScale','log'); title('Effect Size')
    yticks([0 10 20 30 40 50 60 80 100 200 300 500])
    colormap(ESfig,ESmap)
    colorbar

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig(['Observed t and p ' whichtest ' '  layers{iLay} ' ' MouseFreq ])
    saveas(gcf, ['Observed t and p ' whichtest ' '  layers{iLay} ' ' MouseFreq  '.pdf'])
    close(h)

    %% Permutation Step 3 - do the permute
    mass_clustermass = NaN([1 nperms]);
    % put the whole group in one container
    contAll = [BatOut;MouseOut];
    perm_layer = struct;

    for ispec = 1:length(osciName)
        perm_layer.(osciName{ispec}) = NaN([1 nperms]);
    end

    for iperm = 1:nperms
        % determine random list order to pull
        order = randperm(grpsizeB+grpsizeM);
        % pull based on random list order
        Grp1Out = contAll(order(1:grpsizeB),:,:);
        Grp2Out = contAll(order(grpsizeB+1:end),:,:);

        per1_mean = squeeze(nanmean(Grp1Out,1));
        per1_std = squeeze(nanstd(Grp1Out,0,1));

        per2_mean = squeeze(nanmean(Grp2Out,1));
        per2_std = squeeze(nanstd(Grp2Out,0,1));

        % Student's t test and cohen's d effect size
        if contains(whichtest,'Power')
            [~, ~, per_clusters] = powerStats(per1_mean, ...
                per2_mean, per1_std, per2_std, grpsizeB, grpsizeM, t_thresh);
        end

        % Mann-Whitney U test and z effect size
        if contains(whichtest,'Phase')
            [~, ~, per_clusters] = phaseStats(Grp1Out, Grp2Out);
        end
    
        % check cluster mass for 300 ms from tone onset
        per_clustermass = nansum(nansum(per_clusters(:,comptime)));
        mass_clustermass(iperm) = per_clustermass;

        % for layer specific: %%%
        % % pull out clusters

        for ispec = 1:length(osciName)
            hold_permlayer = per_clusters(osciRows{ispec},comptime);

            % % sum clusters (twice to get final value)
            for i = 1:2
                hold_permlayer = nansum(hold_permlayer);
            end
            perm_layer.(osciName{ispec})(iperm) = hold_permlayer;
        end

    end

    %% Check Significance of full clustermass

    % In how many instances is the observed clustermass MORE than
    % the permuted clustermasses (obs clustermass sig above chance)
    sig_mass = sum(mass_clustermass>obs_clustermass,2); 
    pVal = sig_mass/nperms;
    permMean = mean(mass_clustermass);
    permSTD = std(mass_clustermass);

    figure('Name',['Observed cluster vs Permutation ' layers{iLay}]); 
    boxplot(mass_clustermass); hold on;

    if pVal < 0.007
        plot(1,obs_clustermass,'go','LineWidth',4)
        legend('p<0.007')
    else
        plot(1,obs_clustermass,'ro','LineWidth',4)
        legend('ns')
    end

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig(['Full Permutation ' layers{iLay} ' ' MouseFreq])
    saveas(gcf, ['Full Permutation ' whichtest ' ' layers{iLay} ' ' MouseFreq '.pdf'])
    close(h)
    save(['Permutation ' whichtest ' ' layers{iLay} ' ' MouseFreq '.mat'],'pVal','permMean','permSTD')

    %% Check Significance of layers' clustermass

    for ispec = 1:length(osciName)
    % In how many instances is the observed clustermass MORE than
    % the permuted clustermasses (obs clustermass sig above chance)
    sig_mass = sum(perm_layer.(osciName{ispec})>obs_layer.(osciName{ispec}),2); 
    pVal = sig_mass/nperms;
    permMean = mean(perm_layer.(osciName{ispec}));
    permSTD = std(perm_layer.(osciName{ispec}));

    figure('Name',['Observed cluster vs Permutation ' layers{iLay} ' ' osciName{ispec}]); 
    boxplot(perm_layer.(osciName{ispec})); hold on;

    if pVal < 0.007
        plot(1,obs_layer.(osciName{ispec}),'go','LineWidth',4)
        legend('p<0.007')
    else
        plot(1,obs_layer.(osciName{ispec}),'ro','LineWidth',4)
        legend('ns')
    end

    h = gcf;
    h.Renderer = 'Painters';
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig(['Permutation ' whichtest ' ' layers{iLay} ' ' osciName{ispec} ' ' MouseFreq])
    saveas(gcf, ['Permutation ' whichtest ' ' layers{iLay} ' ' osciName{ispec} ' ' MouseFreq '.pdf'])
    close(h)
    save(['Permutation ' whichtest ' ' layers{iLay} ' ' osciName{ispec} ' ' MouseFreq '.mat'],'pVal','permMean','permSTD')

    end

end
