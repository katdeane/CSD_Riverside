function PCal_ShortHighLowStats(homedir,Groups,call_high,call_low)
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
grp1sgl = readtable([Groups{1} '_ShortCall_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_ShortCall_AVRECPeak.csv']);
grp1avg = readtable([Groups{1} '_ShortCall_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_ShortCall_AVG_AVRECPeak.csv']);

% set some stuff up
layers = {'All','II','IV','Va','Vb','VI'};
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [110/255 64/255 85/255]; 

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 9],'VariableTypes',...
            {'string','string','double','double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer","stat","SH1","SL1","SPH","SPL","PHL",...
    "AH1","AL1"];

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

    avg1stk  = nan(grp1size,10); % subject x peak
    sgl1stk  = nan(grp1size,10,50); % maximum trials is 50
    avg2stk  = nan(grp2size,10);
    sgl2stk  = nan(grp2size,10,50);
    % stack groups for pics
    for iSub = 1:grp1size
        % groups stacks have subjects numbered as order gone in
        avg1stk(iSub,:) = avg1lay(matches(avg1lay.Animal,grp1name{iSub}),:).PeakAmp';

        % single trial needs to be sorted 
        sgl1sub = sgl1lay(matches(sgl1lay.Animal,grp1name{iSub}),:);
        for itrial = 1:length(unique(sgl1sub.trial))
            if itrial <= 50 % just in case more than 50 were taken
                sgl1stk(iSub,:,itrial) = sgl1sub(sgl1sub.trial == itrial,:).PeakAmp';
            end
        end
    end
    for iSub = 1:grp2size
        % groups stacks have subjects numbered as order gone in
        avg2stk(iSub,:) = avg2lay(matches(avg2lay.Animal,grp2name{iSub}),:).PeakAmp';

        % single trial needs to be sorted 
        sgl2sub = sgl2lay(matches(sgl2lay.Animal,grp2name{iSub}),:);
        for itrial = 1:length(unique(sgl2sub.trial))
            if itrial <= 50 % just in case more than 50 were taken
                sgl2stk(iSub,:,itrial) = sgl2sub(sgl2sub.trial == itrial,:).PeakAmp';
            end
        end
    end
    
    %% let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
    
    % Average data
    nexttile
    plot(avg1stk','color',color12)
    hold on
    plot(avg2stk','color',color22)
    plot(nanmean(avg1stk,1),'color',color11,'LineWidth',4)
    plot(nanmean(avg2stk,1),'color',color21,'LineWidth',4)
    xticks(sort(call_high))
    xlabel('Calls')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Average Peaks')

    % high calls
    xboxPA = [nanmean(avg1stk(:,call_high)), nanmean(avg2stk(:,call_high))];

    semPA = [nanstd(avg1stk(:,call_high))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high))/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_high)] [Groups{2} ' ' num2str(call_high)]})
    title('Trial-Average Peaks')

    % low calls
    xboxPA = [nanmean(avg1stk(:,call_low)), nanmean(avg2stk(:,call_low))];

    semPA = [nanstd(avg1stk(:,call_low))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low))/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low)] [Groups{2} ' ' num2str(call_low)]})
    title('Trial-Average Peaks')
    
    % single trial data
    nexttile 
    shadedErrorBar(1:size(sgl1stk,2),nanmean(nanmean(sgl1stk,3),1),nanstd(nanmean(sgl1stk,3),0,1),'lineprops','b')
    hold on 
    shadedErrorBar(1:size(sgl2stk,2),nanmean(nanmean(sgl2stk,3),1),nanstd(nanmean(sgl2stk,3),0,1),'lineprops','r')    
    xticks(sort([call_high call_low]))
    xlabel('Calls')
    ylabel('PeakAmp [mV/mm²] mean and std')
    title('Single Trial Peaks')

    % loudest calls
    sgl1h_1 = nan(grp1size*50,1);
    for iSub = 1:grp1size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1h_1(count:countto) = squeeze(sgl1stk(iSub,call_high,:));
    end
    sgl2h_1 = nan(grp2size*50,1);
    for iSub = 1:grp2size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2h_1(count:countto) = squeeze(sgl2stk(iSub,call_high,:));
    end
    
    xboxPA = [nanmean(sgl1h_1), nanmean(sgl2h_1)];


    semPA = [nanstd(sgl1h_1)/sqrt(length(sgl1h_1)), ...
        nanstd(sgl2h_1)/sqrt(length(sgl2h_1))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_high(1))] [Groups{2} ' ' num2str(call_high(1))]})
    title('Single Trial Peaks')

    % quietest calls
    sgl1l_1 = nan(grp1size*50,1);
    for iSub = 1:grp1size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1l_1(count:countto) = squeeze(sgl1stk(iSub,call_low,:));
    end
    sgl2l_1 = nan(grp2size*50,1);
    for iSub = 1:grp2size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2l_1(count:countto) = squeeze(sgl2stk(iSub,call_low,:));
    end
    
    xboxPA = [nanmean(sgl1l_1), nanmean(sgl2l_1)];

    semPA = [nanstd(sgl1l_1)/sqrt(length(sgl1l_1)), ...
        nanstd(sgl2l_1)/sqrt(length(sgl2l_1))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low)] [Groups{2} ' ' num2str(call_low)]})
    title('Single Trial Peaks')

    % finally,  let's normalized by the virgin group to pool them also,
    % loud
    sgl1hr = sgl1h_1 ./ nanmean(sgl1h_1); 
    sgl2hr = sgl2h_1 ./ nanmean(sgl1h_1); 

    xboxPA = [nanmean(sgl1hr), nanmean(sgl2hr)];

    semPA = [nanstd(sgl1hr)/sqrt(length(sgl1hr)), ...
        nanstd(sgl2hr)/sqrt(length(sgl2hr))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_high)] [Groups{2} ' ' num2str(call_high)]})
    title('Single Trial Peaks')

    % quiet
    sgl1lr = sgl1l_1 ./ nanmean(sgl1l_1); 
    sgl2lr = sgl2l_1 ./ nanmean(sgl1l_1); 

    xboxPA = [nanmean(sgl1lr), nanmean(sgl2lr)];

    semPA = [nanstd(sgl1lr)/sqrt(length(sgl1lr)), ...
        nanstd(sgl2lr)/sqrt(length(sgl2lr))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Quiet Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low)] [Groups{2} ' ' num2str(call_low)]})
    title('Single Trial Peaks')

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ShortCall_HighLow']);
    % exportgraphics(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ShortCall_HighLow.pdf'])
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % S High
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_1,sgl2h_1,1,'both'); % right tail: group 1 bigger
    PeakStats.SH1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % S Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_1,sgl2l_1,1,'both'); % right tail: group 1 bigger
    PeakStats.SL1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % S High normalized to average virgin group and then pooled
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1hr,sgl2hr,1,'both'); % right tail: group 1 bigger
    PeakStats.SPH(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % S Low normalized to average virgin group and then pooled
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lr,sgl2lr,1,'both'); % right tail: group 1 bigger
    PeakStats.SPL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Normalized High vs Low Parent group
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl2hr,sgl2lr,1,'both'); % right tail: group 1 bigger
    PeakStats.PHL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % High
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_high(1)),avg2stk(:,call_high(1)),1,'both'); % right tail: group 1 bigger
    PeakStats.AH1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(1)),avg2stk(:,call_low(1)),1,'both'); % right tail: group 1 bigger
    PeakStats.AL1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_ShortCall_HighLow_Stats.csv']);
cd(homedir)