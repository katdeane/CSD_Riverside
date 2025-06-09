function PCal_NB_HighLowStats(homedir,Groups,high,low)
% ROIs are from the onset of one pupcall to the onset of the next with a
% maximum of 100 ms time windows (for lower freq click trains). Currently
% 40 Hz click trains are being analyzed on the onset peak response (highest
% out of first 3 click time windows), 10th, 20th, 40th, and 80th peak
% amplitude and the ratio of each of those to the first click. 
% Compared at both single trial and trial-averaged levels. 
% Input:    csv's from ..\output\TracePeaks for single trial and
%           trial-averaged data from running Avrec_Layers and
%           Group_Avrec_Layers respectively. 
% Output:   Figures in ..\figures\PeakPlots: traces of peak amp over
%           clicks and boxplots of peak amplitudes across clicks.
%           Data in ..\output\TracePeaks as *v*_ClickTrain_5_Stats.csv

cd(homedir); 

% single trial data
grp1sgl = readtable([Groups{1} '_NoiseBurst_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_NoiseBurst_AVRECPeak.csv']);
grp1avg = readtable([Groups{1} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_NoiseBurst_AVG_AVRECPeak.csv']);

% set some stuff up
layers = {'All','II','IV','Va','Vb','VI'};
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 7],'VariableTypes',...
            {'string','string','double','double','double','double','double'});

% S = single, A = average
PeakStats.Properties.VariableNames = ["Layer","stat","SH",...
    "SL","SHL","AH","AL"];

for iLay = 1:length(layers)
    % pull out current layer
    sgl1lay = grp1sgl(matches(grp1sgl.Layer, layers{iLay}),:);
    sgl2lay = grp2sgl(matches(grp2sgl.Layer, layers{iLay}),:);
    avg1lay = grp1avg(matches(grp1avg.Layer, layers{iLay}),:);
    avg2lay = grp2avg(matches(grp2avg.Layer, layers{iLay}),:);

    grp1size = length(unique(avg1lay.Animal));
    grp1name = unique(sgl1lay.Animal);
    grp2size = length(unique(avg2lay.Animal));
    grp2name = unique(sgl2lay.Animal);

    % avg1stk  = nan(grp1size); % subject x peak
    % sgl1stk  = nan(grp1size,50); % maximum trials is 50
    % avg2stk  = nan(grp2size);
    % sgl2stk  = nan(grp2size,50);
    % stack groups for pics
    sgl1high = sgl1lay(sgl1lay.ClickFreq == high,:);
    sgl2high = sgl2lay(sgl2lay.ClickFreq == high,:);
    avg1high = avg1lay(avg1lay.ClickFreq == high,:);
    avg2high = avg2lay(avg2lay.ClickFreq == high,:);

    sgl1low = sgl1lay(sgl1lay.ClickFreq == low,:);
    sgl2low = sgl2lay(sgl2lay.ClickFreq == low,:);
    avg1low = avg1lay(avg1lay.ClickFreq == low,:);
    avg2low = avg2lay(avg2lay.ClickFreq == low,:);
    % 
    % for iSub = 1:grp1size
    %     % groups stacks have subjects numbered as order gone in
    %     avg1stk(iSub,:) = avg1lay(matches(avg1lay.Animal,grp1name{iSub}),:).PeakAmp';
    % 
    %     % single trial needs to be sorted 
    %     sgl1sub = sgl1lay(matches(sgl1lay.Animal,grp1name{iSub}),:);
    %     for itrial = 1:length(unique(sgl1sub.trial))
    %         if itrial <= 50 % just in case more than 50 were taken
    %             sgl1stk(iSub,:,itrial) = sgl1sub(sgl1sub.trial == itrial,:).PeakAmp';
    %         end
    %     end
    % end
    % for iSub = 1:grp2size
    %     % groups stacks have subjects numbered as order gone in
    %     avg2stk(iSub,:) = avg2lay(matches(avg2lay.Animal,grp2name{iSub}),:).PeakAmp';
    % 
    %     % single trial needs to be sorted 
    %     sgl2sub = sgl2lay(matches(sgl2lay.Animal,grp2name{iSub}),:);
    %     for itrial = 1:length(unique(sgl2sub.trial))
    %         if itrial <= 50 % just in case more than 50 were taken
    %             sgl2stk(iSub,:,itrial) = sgl2sub(sgl2sub.trial == itrial,:).PeakAmp';
    %         end
    %     end
    % end
    
    %% let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
    
    % Average data
    
    % high calls
    xboxPA = [nanmean(avg1high.PeakAmp), nanmean(avg2high.PeakAmp)];

    semPA = [nanstd(avg1high.PeakAmp)/sqrt(grp1size), ...
        nanstd(avg2high.PeakAmp)/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud NB')
    xticklabels({Groups{1} Groups{2}})
    title('Trial-Average Peaks')

    % low calls
    xboxPA = [nanmean(avg1low.PeakAmp), nanmean(avg2low.PeakAmp)];

    semPA = [nanstd(avg1low.PeakAmp)/sqrt(grp1size), ...
        nanstd(avg2low.PeakAmp)/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet NB')
    xticklabels({Groups{1} Groups{2}})
    title('Trial-Average Peaks')
    
    % single trial data

    % loudest calls    
    xboxPA = [nanmean(sgl1high.PeakAmp), nanmean(sgl2high.PeakAmp)];

    semPA = [nanstd(sgl1high.PeakAmp)/sqrt(grp1size), ...
        nanstd(sgl2high.PeakAmp)/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud NB')
    xticklabels({Groups{1} Groups{2}})
    title('Single Trial Peaks')

    % quietest calls
    xboxPA = [nanmean(sgl1low.PeakAmp), nanmean(sgl2low.PeakAmp)];

    semPA = [nanstd(sgl1low.PeakAmp)/sqrt(grp1size), ...
        nanstd(sgl2low.PeakAmp)/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet NB')
    xticklabels({Groups{1} Groups{2}})
    title('Single Trial Peaks')

    % finally,  let's normalized by the virgin group and pool them also
    
    % loud
    sgl1high_norm = sgl1high.PeakAmp ./ nanmean(sgl1high.PeakAmp);  
    sgl2high_norm = sgl2high.PeakAmp ./ nanmean(sgl1high.PeakAmp);

    xboxPA = [nanmean(sgl1high_norm), nanmean(sgl2high_norm)];

    semPA = [nanstd(sgl1high_norm)/sqrt(length(sgl1high_norm)), ...
        nanstd(sgl2high_norm)/sqrt(length(sgl2high_norm))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Loud NB')
    xticklabels({Groups{1} Groups{2}})
    title('Single Trial Peaks')
    ylim([0 3])

    % quiet
    sgl1low_norm = sgl1low.PeakAmp ./ nanmean(sgl1low.PeakAmp);  
    sgl2low_norm = sgl2low.PeakAmp ./ nanmean(sgl1low.PeakAmp);

    xboxPA = [nanmean(sgl1low_norm), nanmean(sgl2low_norm)];

    semPA = [nanstd(sgl1low_norm)/sqrt(length(sgl1low_norm)), ...
        nanstd(sgl2low_norm)/sqrt(length(sgl2low_norm))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Quiet NB')
    xticklabels({Groups{1} Groups{2}})
    title('Single Trial Peaks')
    ylim([0 3])

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_NB_HighLow']);
    % exportgraphics(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_NoiseBurst_HighLow.pdf'])
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % S High
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1high.PeakAmp,sgl2high.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.SH(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % S Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1low.PeakAmp,sgl2low.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.SL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Normalized High vs Low Parent group
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl2high_norm,sgl2low_norm,1,'both'); % right tail: group 1 bigger
    PeakStats.SHL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % High
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1high.PeakAmp,avg2high.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.AH(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1low.PeakAmp,avg2low.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.AL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_NoiseBurst_HighLow_Stats.csv']);
cd(homedir)