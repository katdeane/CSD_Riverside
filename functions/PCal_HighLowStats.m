function PCal_HighLowStats(homedir,Groups,call_high,call_low)
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
grp1sgl = readtable([Groups{1} '_Pupcall30_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_Pupcall30_AVRECPeak.csv']);
grp1avg = readtable([Groups{1} '_Pupcall30_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_Pupcall30_AVG_AVRECPeak.csv']);

% set some stuff up
layers = {'All','II','IV','Va','Vb','VI'};
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 25],'VariableTypes',...
            {'string','string','double','double','double','double','double','double', ...
            'double','double','double','double','double','double','double','double',...
            'double','double','double','double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer","stat","SH1","SH2","SH3","SH4","SH5",...
    "SL1","SL2","SL3","SL4","SL5","SPH","SPL","PHL",...
    "AH1","AH2","AH3","AH4","AH5","AL1","AL2","AL3","AL4","AL5"];

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

    avg1stk  = nan(grp1size,60); % subject x peak
    sgl1stk  = nan(grp1size,60,50); % maximum trials is 50
    avg2stk  = nan(grp2size,60);
    sgl2stk  = nan(grp2size,60,50);
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
    xboxPA = [nanmean(avg1stk(:,call_high(1))), nanmean(avg2stk(:,call_high(1))),...
        nanmean(avg1stk(:,call_high(2))), nanmean(avg2stk(:,call_high(2))),...
        nanmean(avg1stk(:,call_high(3))), nanmean(avg2stk(:,call_high(3))),...
        nanmean(avg1stk(:,call_high(4))), nanmean(avg2stk(:,call_high(4))),...
        nanmean(avg1stk(:,call_high(5))), nanmean(avg2stk(:,call_high(5)))];

    semPA = [nanstd(avg1stk(:,call_high(1)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high(1)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_high(2)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high(2)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_high(3)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high(3)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_high(4)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high(4)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_high(5)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_high(5)))/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_high(1))] [Groups{2} ' ' num2str(call_high(1))]...
        [Groups{1} ' ' num2str(call_high(2))] [Groups{2} ' ' num2str(call_high(2))] ...
        [Groups{1} ' ' num2str(call_high(3))] [Groups{2} ' ' num2str(call_high(3))] ...
        [Groups{1} ' ' num2str(call_high(4))] [Groups{2} ' ' num2str(call_high(4))] ...
        [Groups{1} ' ' num2str(call_high(5))] [Groups{2} ' ' num2str(call_high(5))]})
    title('Trial-Average Peaks')

    % low calls
    xboxPA = [nanmean(avg1stk(:,call_low(1))), nanmean(avg2stk(:,call_low(1))),...
        nanmean(avg1stk(:,call_low(2))), nanmean(avg2stk(:,call_low(2))),...
        nanmean(avg1stk(:,call_low(3))), nanmean(avg2stk(:,call_low(3))),...
        nanmean(avg1stk(:,call_low(4))), nanmean(avg2stk(:,call_low(4))),...
        nanmean(avg1stk(:,call_low(5))), nanmean(avg2stk(:,call_low(5)))];

    semPA = [nanstd(avg1stk(:,call_low(1)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low(1)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_low(2)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low(2)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_low(3)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low(3)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_low(4)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low(4)))/sqrt(grp2size), ...
        nanstd(avg1stk(:,call_low(5)))/sqrt(grp1size), ...
        nanstd(avg2stk(:,call_low(5)))/sqrt(grp2size)];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
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
    sgl1h_2 = nan(length(sgl1h_1),1);
    sgl1h_3 = nan(length(sgl1h_1),1);
    sgl1h_4 = nan(length(sgl1h_1),1);
    sgl1h_5 = nan(length(sgl1h_1),1);
    for iSub = 1:grp1size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1h_1(count:countto) = squeeze(sgl1stk(iSub,call_high(1),:));
        sgl1h_2(count:countto) = squeeze(sgl1stk(iSub,call_high(2),:));
        sgl1h_3(count:countto) = squeeze(sgl1stk(iSub,call_high(3),:));
        sgl1h_4(count:countto) = squeeze(sgl1stk(iSub,call_high(4),:));
        sgl1h_5(count:countto) = squeeze(sgl1stk(iSub,call_high(5),:));
    end
    sgl2h_1 = nan(grp2size*50,1);
    sgl2h_2 = nan(length(sgl2h_1),1);
    sgl2h_3 = nan(length(sgl2h_1),1);
    sgl2h_4 = nan(length(sgl2h_1),1);
    sgl2h_5 = nan(length(sgl2h_1),1);
    for iSub = 1:grp2size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2h_1(count:countto) = squeeze(sgl2stk(iSub,call_high(1),:));
        sgl2h_2(count:countto) = squeeze(sgl2stk(iSub,call_high(2),:));
        sgl2h_3(count:countto) = squeeze(sgl2stk(iSub,call_high(3),:));
        sgl2h_4(count:countto) = squeeze(sgl2stk(iSub,call_high(4),:));
        sgl2h_5(count:countto) = squeeze(sgl2stk(iSub,call_high(5),:));
    end
    
    xboxPA = [nanmean(sgl1h_1), nanmean(sgl2h_1), nanmean(sgl1h_2),...
        nanmean(sgl2h_2), nanmean(sgl1h_3), nanmean(sgl2h_3), nanmean(sgl1h_4),...
        nanmean(sgl2h_4), nanmean(sgl1h_5), nanmean(sgl2h_5)];


    semPA = [nanstd(sgl1h_1)/sqrt(length(sgl1h_1)), ...
        nanstd(sgl2h_1)/sqrt(length(sgl2h_1)), nanstd(sgl1h_2)/sqrt(length(sgl1h_2)),...
        nanstd(sgl2h_2)/sqrt(length(sgl2h_2)), nanstd(sgl1h_3)/sqrt(length(sgl1h_3)),...
        nanstd(sgl2h_3)/sqrt(length(sgl2h_3)),...
        nanstd(sgl1h_4)/sqrt(length(sgl1h_4)), nanstd(sgl2h_4)/sqrt(length(sgl2h_4)),...
        nanstd(sgl1h_5)/sqrt(length(sgl1h_5)),...
        nanstd(sgl2h_5)/sqrt(length(sgl2h_5))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_high(1))] [Groups{2} ' ' num2str(call_high(1))]...
        [Groups{1} ' ' num2str(call_high(2))] [Groups{2} ' ' num2str(call_high(2))] ...
        [Groups{1} ' ' num2str(call_high(3))] [Groups{2} ' ' num2str(call_high(3))] ...
        [Groups{1} ' ' num2str(call_high(4))] [Groups{2} ' ' num2str(call_high(4))] ...
        [Groups{1} ' ' num2str(call_high(5))] [Groups{2} ' ' num2str(call_high(5))]})
    title('Single Trial Peaks')

    % quietest calls
    sgl1l_1 = nan(grp1size*50,1);
    sgl1l_2 = nan(length(sgl1l_1),1);
    sgl1l_3 = nan(length(sgl1l_1),1);
    sgl1l_4 = nan(length(sgl1l_1),1);
    sgl1l_5 = nan(length(sgl1l_1),1);
    for iSub = 1:grp1size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1l_1(count:countto) = squeeze(sgl1stk(iSub,call_low(1),:));
        sgl1l_2(count:countto) = squeeze(sgl1stk(iSub,call_low(2),:));
        sgl1l_3(count:countto) = squeeze(sgl1stk(iSub,call_low(3),:));
        sgl1l_4(count:countto) = squeeze(sgl1stk(iSub,call_low(4),:));
        sgl1l_5(count:countto) = squeeze(sgl1stk(iSub,call_low(5),:));
    end
    sgl2l_1 = nan(grp2size*50,1);
    sgl2l_2 = nan(length(sgl2l_1),1);
    sgl2l_3 = nan(length(sgl2l_1),1);
    sgl2l_4 = nan(length(sgl2l_1),1);
    sgl2l_5 = nan(length(sgl2l_1),1);
    for iSub = 1:grp2size
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2l_1(count:countto) = squeeze(sgl2stk(iSub,call_low(1),:));
        sgl2l_2(count:countto) = squeeze(sgl2stk(iSub,call_low(2),:));
        sgl2l_3(count:countto) = squeeze(sgl2stk(iSub,call_low(3),:));
        sgl2l_4(count:countto) = squeeze(sgl2stk(iSub,call_low(4),:));
        sgl2l_5(count:countto) = squeeze(sgl2stk(iSub,call_low(5),:));
    end
    
    xboxPA = [nanmean(sgl1l_1), nanmean(sgl2l_1), nanmean(sgl1l_2),...
        nanmean(sgl2l_2), nanmean(sgl1l_3), nanmean(sgl2l_3), nanmean(sgl1l_4),...
        nanmean(sgl2l_4), nanmean(sgl1l_5), nanmean(sgl2l_5)];


    semPA = [nanstd(sgl1l_1)/sqrt(length(sgl1l_1)), ...
        nanstd(sgl2l_1)/sqrt(length(sgl2l_1)), nanstd(sgl1l_2)/sqrt(length(sgl1l_2)),...
        nanstd(sgl2l_2)/sqrt(length(sgl2l_2)), nanstd(sgl1l_3)/sqrt(length(sgl1l_3)),...
        nanstd(sgl2l_3)/sqrt(length(sgl2l_3)),...
        nanstd(sgl1l_4)/sqrt(length(sgl1l_4)), nanstd(sgl2l_4)/sqrt(length(sgl2l_4)),...
        nanstd(sgl1l_5)/sqrt(length(sgl1l_5)),...
        nanstd(sgl2l_5)/sqrt(length(sgl2l_5))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Quiet Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
    title('Single Trial Peaks')

    % finally,  let's normalized by the virgin group to pool them also,
    % loud
    sgl1hr_1 = sgl1h_1 ./ nanmean(sgl1h_1); 
    sgl1hr_2 = sgl1h_2 ./ nanmean(sgl1h_2); 
    sgl1hr_3 = sgl1h_3 ./ nanmean(sgl1h_3); 
    sgl1hr_4 = sgl1h_4 ./ nanmean(sgl1h_4); 
    sgl1hr_5 = sgl1h_5 ./ nanmean(sgl1h_5); 

    sgl2hr_1 = sgl2h_1 ./ nanmean(sgl1h_1); 
    sgl2hr_2 = sgl2h_2 ./ nanmean(sgl1h_2); 
    sgl2hr_3 = sgl2h_3 ./ nanmean(sgl1h_3); 
    sgl2hr_4 = sgl2h_4 ./ nanmean(sgl1h_4); 
    sgl2hr_5 = sgl2h_5 ./ nanmean(sgl1h_5); 

    xboxPA = [nanmean(sgl1hr_1), nanmean(sgl2hr_1), nanmean(sgl1hr_2),...
        nanmean(sgl2hr_2), nanmean(sgl1hr_3), nanmean(sgl2hr_3), nanmean(sgl1hr_4),...
        nanmean(sgl2hr_4), nanmean(sgl1hr_5), nanmean(sgl2hr_5)];


    semPA = [nanstd(sgl1hr_1)/sqrt(length(sgl1hr_1)), ...
        nanstd(sgl2hr_1)/sqrt(length(sgl2hr_1)), nanstd(sgl1hr_2)/sqrt(length(sgl1hr_2)),...
        nanstd(sgl2hr_2)/sqrt(length(sgl2hr_2)), nanstd(sgl1hr_3)/sqrt(length(sgl1hr_3)),...
        nanstd(sgl2hr_3)/sqrt(length(sgl2hr_3)),...
        nanstd(sgl1hr_4)/sqrt(length(sgl1hr_4)), nanstd(sgl2hr_4)/sqrt(length(sgl2hr_4)),...
        nanstd(sgl1hr_5)/sqrt(length(sgl1hr_5)),...
        nanstd(sgl2hr_5)/sqrt(length(sgl2hr_5))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
    title('Single Trial Peaks')

    sgl1hr = [sgl1hr_1, sgl1hr_2, sgl1hr_3, sgl1hr_4, sgl1hr_5];
    sgl1hr = nanmean(sgl1hr,2);
    sgl2hr = [sgl2hr_1, sgl2hr_2, sgl2hr_3, sgl2hr_4, sgl2hr_5];
    sgl2hr = nanmean(sgl2hr,2);

    xboxPA = [nanmean(sgl1hr), nanmean(sgl2hr)];

    semPA = [nanstd(sgl1hr)/sqrt(length(sgl1hr)), ...
        nanstd(sgl2hr)/sqrt(length(sgl2hr))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized Pooled PA [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
    title('Single Trial Peaks')

    % quiet
    sgl1lr_1 = sgl1l_1 ./ nanmean(sgl1l_1); 
    sgl1lr_2 = sgl1l_2 ./ nanmean(sgl1l_2); 
    sgl1lr_3 = sgl1l_3 ./ nanmean(sgl1l_3); 
    sgl1lr_4 = sgl1l_4 ./ nanmean(sgl1l_4); 
    sgl1lr_5 = sgl1l_5 ./ nanmean(sgl1l_5); 

    sgl2lr_1 = sgl2l_1 ./ nanmean(sgl1l_1); 
    sgl2lr_2 = sgl2l_2 ./ nanmean(sgl1l_2); 
    sgl2lr_3 = sgl2l_3 ./ nanmean(sgl1l_3); 
    sgl2lr_4 = sgl2l_4 ./ nanmean(sgl1l_4); 
    sgl2lr_5 = sgl2l_5 ./ nanmean(sgl1l_5); 

    xboxPA = [nanmean(sgl1lr_1), nanmean(sgl2lr_1), nanmean(sgl1lr_2),...
        nanmean(sgl2lr_2), nanmean(sgl1lr_3), nanmean(sgl2lr_3), nanmean(sgl1lr_4),...
        nanmean(sgl2lr_4), nanmean(sgl1lr_5), nanmean(sgl2lr_5)];


    semPA = [nanstd(sgl1lr_1)/sqrt(length(sgl1lr_1)), ...
        nanstd(sgl2lr_1)/sqrt(length(sgl2lr_1)), nanstd(sgl1lr_2)/sqrt(length(sgl1lr_2)),...
        nanstd(sgl2lr_2)/sqrt(length(sgl2lr_2)), nanstd(sgl1lr_3)/sqrt(length(sgl1lr_3)),...
        nanstd(sgl2lr_3)/sqrt(length(sgl2lr_3)),...
        nanstd(sgl1lr_4)/sqrt(length(sgl1lr_4)), nanstd(sgl2lr_4)/sqrt(length(sgl2lr_4)),...
        nanstd(sgl1lr_5)/sqrt(length(sgl1lr_5)),...
        nanstd(sgl2lr_5)/sqrt(length(sgl2lr_5))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized PA [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
    title('Single Trial Peaks')

    sgl1lr = [sgl1lr_1, sgl1lr_2, sgl1lr_3, sgl1lr_4, sgl1lr_5];
    sgl1lr = nanmean(sgl1lr,2);
    sgl2lr = [sgl2lr_1, sgl2lr_2, sgl2lr_3, sgl2lr_4, sgl2lr_5];
    sgl2lr = nanmean(sgl2lr,2);

    xboxPA = [nanmean(sgl1lr), nanmean(sgl2lr)];

    semPA = [nanstd(sgl1lr)/sqrt(length(sgl1lr)), ...
        nanstd(sgl2lr)/sqrt(length(sgl2lr))];

    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle','none')
    ylabel('Normalized Pooled PA [mV/mm²]')
    xlabel('Group / Loud Calls')
    xticklabels({[Groups{1} ' ' num2str(call_low(1))] [Groups{2} ' ' num2str(call_low(1))]...
        [Groups{1} ' ' num2str(call_low(2))] [Groups{2} ' ' num2str(call_low(2))] ...
        [Groups{1} ' ' num2str(call_low(3))] [Groups{2} ' ' num2str(call_low(3))] ...
        [Groups{1} ' ' num2str(call_low(4))] [Groups{2} ' ' num2str(call_low(4))] ...
        [Groups{1} ' ' num2str(call_low(5))] [Groups{2} ' ' num2str(call_low(5))]})
    title('Single Trial Peaks')

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_PupCall_HighLow']);
    % exportgraphics(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_PupCall_HighLow.pdf'])
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % S High
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_1,sgl2h_1,1,'both'); % right tail: group 1 bigger
    PeakStats.SH1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 2
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_2,sgl2h_2,1,'both'); % left, group 2 is bigger
    PeakStats.SH2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 3
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_3,sgl2h_3,1,'both');
    PeakStats.SH3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 4 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_4,sgl2h_4,1,'both');
    PeakStats.SH4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 5 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1h_5,sgl2h_5,1,'both');
    PeakStats.SH5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % S Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_1,sgl2l_1,1,'both'); % right tail: group 1 bigger
    PeakStats.SL1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 2
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_2,sgl2l_2,1,'both'); % left, group 2 is bigger
    PeakStats.SL2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 3
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_3,sgl2l_3,1,'both');
    PeakStats.SL3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 4 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_4,sgl2l_4,1,'both');
    PeakStats.SL4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 5 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1l_5,sgl2l_5,1,'both');
    PeakStats.SL5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

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
    % 2
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_high(2)),avg2stk(:,call_high(2)),1,'both'); % left, group 2 is bigger
    PeakStats.AH2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 3
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_high(3)),avg2stk(:,call_high(3)),1,'both');
    PeakStats.AH3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 4 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_high(4)),avg2stk(:,call_high(4)),1,'both');
    PeakStats.AH4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 5
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_high(5)),avg2stk(:,call_high(5)),1,'both');
    PeakStats.AH5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Low
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(1)),avg2stk(:,call_low(1)),1,'both'); % right tail: group 1 bigger
    PeakStats.AL1(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 2
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(2)),avg2stk(:,call_low(2)),1,'both'); % left, group 2 is bigger
    PeakStats.AL2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 3
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(3)),avg2stk(:,call_low(3)),1,'both');
    PeakStats.AL3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 4 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(4)),avg2stk(:,call_low(4)),1,'both');
    PeakStats.AL4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % 5
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,call_low(5)),avg2stk(:,call_low(5)),1,'both');
    PeakStats.AL5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_PupCall_HighLow_Stats.csv']);
cd(homedir)