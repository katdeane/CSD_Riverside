function PCal_ClickTrainStats5(homedir,Groups)
% ROIs are from the onset of one click to the onset of the next with a
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
grp1sgl = readtable([Groups{1} '_ClickTrain_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_ClickTrain_AVRECPeak.csv']);
% subject averaged data
grp1avg = readtable([Groups{1} '_ClickTrain_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_ClickTrain_AVG_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1sgl.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 

% we're only looking at 5 Hz, pull that out
stimfreq = 5;
grp1sgl = grp1sgl(grp1sgl.ClickFreq == stimfreq,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == stimfreq,:);
grp1avg = grp1avg(grp1avg.ClickFreq == stimfreq,:);
grp2avg = grp2avg(grp2avg.ClickFreq == stimfreq,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 12],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "SON",...
    "S5", "S10", "Srat5", "Srat10", "AON", "A5", "A10", "Arat5", "Arat10"];

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

    avg1stk  = nan(grp1size,stimfreq*2); 
    sgl1stk  = nan(grp1size,stimfreq*2,50); % maximum trials is 50
    avg2stk  = nan(grp2size,stimfreq*2);
    sgl2stk  = nan(grp2size,stimfreq*2,50);
    % stack groups for pics
    for iSub = 1:grp1size
        % groups stacks have subjects numbered as order gone in
        avg1stk(iSub,:) = avg1lay(avg1lay.Animal == iSub,:).PeakAmp';

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
        avg2stk(iSub,:) = avg2lay(avg2lay.Animal == iSub,:).PeakAmp';

        % single trial needs to be sorted 
        sgl2sub = sgl2lay(matches(sgl2lay.Animal,grp2name{iSub}),:);
        for itrial = 1:length(unique(sgl2sub.trial))
            if itrial <= 50 % just in case more than 50 were taken
                sgl2stk(iSub,:,itrial) = sgl2sub(sgl2sub.trial == itrial,:).PeakAmp';
            end
        end
    end
    
    % We're going to look at the onset response click and then the response
    % to 5 and 10

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
    xlabel('Clicks')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Average Peaks')    

    % onset peak
    % nexttile
    % errorbar(nanmean(avg1stk),nanstd(avg1stk)/sqrt(size(avg1stk,2)),'color',color11,'LineWidth',1)
    % hold on 
    % errorbar(nanmean(avg2stk),nanstd(avg1stk)/sqrt(size(avg2stk,2)),'color',color21,'LineWidth',1)
    % xlabel('Clicks')
    % ylabel('Peak Amplitude [mV/mm²]')
    % title('Trial-Average Peaks') 

    avg1onpeak = avg1stk(:,1);
    avg2onpeak = avg2stk(:,1);
    
    xboxPA = [nanmean(avg1onpeak), nanmean(avg2onpeak), nanmean(avg1stk(:,5)), ...
        nanmean(avg2stk(:,5)), nanmean(avg1stk(:,10)), nanmean(avg2stk(:,10))];

    semPA = [nanstd(avg1onpeak)/sqrt(length(avg1onpeak)), ...
        nanstd(avg2onpeak)/sqrt(length(avg2onpeak)), nanstd(avg1stk(:,5))/sqrt(length(avg1stk(:,5))), ...
        nanstd(avg2stk(:,5))/sqrt(length(avg2stk(:,5))), ...
        nanstd(avg1stk(:,10))/sqrt(length(avg1stk(:,10))), nanstd(avg2stk(:,10))/sqrt(length(avg2stk(:,10)))];

    nexttile
    bar(xboxPA)  
    hold on
    errorbar(xboxPA,semPA,'LineStyle', 'none')
    xticklabels({[Groups{1} ' onset'] [Groups{2} ' onset'] [Groups{1} ' 5th']...
        [Groups{2} ' 5th'] [Groups{1} ' 10th'] [Groups{2} ' 10th']})
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Trial-Average Peaks')

    % here we're going to calculate the ratios and store them for stats
    avg1r5  = avg1stk(:,5)./avg1onpeak;
    avg1r10 = avg1stk(:,10)./avg1onpeak;

    avg2r5  = avg2stk(:,5)./avg2onpeak;
    avg2r10 = avg2stk(:,10)./avg2onpeak;
    
    xboxPAratio = [nanmean(avg1r5), nanmean(avg2r5), nanmean(avg1r10), ...
        nanmean(avg2r10)];

    semPAratio = [nanstd(avg1r5)/sqrt(length(avg1r5)), ...
        nanstd(avg2r5)/sqrt(length(avg2r5)), nanstd(avg1r10)/sqrt(length(avg1r10)), ...
        nanstd(avg2r10)/sqrt(length(avg2r10))];

    nexttile
    bar(xboxPAratio)
    hold on
    errorbar(xboxPAratio,semPAratio,'LineStyle','none')
    xticklabels({[Groups{1} ' 5/1'] [Groups{2} ' 5/1'] [Groups{1} ' 10/1'] [Groups{2} ' 10/1']})
    ylabel('Ratio Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Trial-Average Peaks')

    % single trial data

    % we will take the max peak click determined in averaged data
    % we also have to stack the data appropriately
    sgl1onpeak = nan(length(avg1onpeak)*50,1);
    sgl1_5    = nan(length(sgl1onpeak),1);
    sgl1_10   = nan(length(sgl1onpeak),1);
    for iSub = 1:length(avg1onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1onpeak(count:countto) = squeeze(sgl1stk(iSub,avg1stk(iSub,:)==avg1onpeak(iSub),:));
        sgl1_5(count:countto)     = squeeze(sgl1stk(iSub,5,:));
        sgl1_10(count:countto)    = squeeze(sgl1stk(iSub,10,:));
    end
    sgl2onpeak = nan(length(avg2onpeak)*50,1);
    sgl2_5    = nan(length(sgl2onpeak),1);
    sgl2_10   = nan(length(sgl2onpeak),1);
    for iSub = 1:length(avg2onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2onpeak(count:countto) = squeeze(sgl2stk(iSub,avg2stk(iSub,:)==avg2onpeak(iSub),:));
        sgl2_5(count:countto)     = squeeze(sgl2stk(iSub,5,:));
        sgl2_10(count:countto)    = squeeze(sgl2stk(iSub,10,:));
    end

    xboxPA = [nanmean(sgl1onpeak), nanmean(sgl2onpeak), nanmean(sgl1_5), ...
        nanmean(sgl2_5), nanmean(sgl1_10), nanmean(sgl2_10)];

    semPA = [nanstd(sgl1onpeak)/sqrt(length(sgl1onpeak)), ...
        nanstd(sgl2onpeak)/sqrt(length(sgl2onpeak)), nanstd(sgl1_5)/sqrt(length(sgl1_5)), ...
        nanstd(sgl2_5)/sqrt(length(sgl2_5)), nanstd(sgl1_10)/sqrt(length(sgl1_10)), ...
        nanstd(sgl2_10)/sqrt(length(sgl2_10))];

    nexttile
    bar(xboxPA)  
    hold on
    errorbar(xboxPA,semPA,'LineStyle', 'none')
    xticklabels({[Groups{1} ' onset'] [Groups{2} ' onset'] [Groups{1} ' 5th']...
        [Groups{2} ' 5th'] [Groups{1} ' 10th'] [Groups{2} ' 10th']})
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Single Trial Peaks')

    % here we're going to calculate the ratios and store them for stats
    sgl1r5  = sgl1_5./sgl1onpeak;
    sgl1r10 = sgl1_10./sgl1onpeak;

    sgl2r5  = sgl2_5./sgl2onpeak;
    sgl2r10 = sgl2_10./sgl2onpeak;
    
    xboxPAratio = [nanmean(sgl1r5), nanmean(sgl2r5), nanmean(sgl1r10), ...
        nanmean(sgl2r10)];

    semPAratio = [nanstd(sgl1r5)/sqrt(length(sgl1r5)), ...
        nanstd(sgl2r5)/sqrt(length(sgl2r5)), nanstd(sgl1r10)/sqrt(length(sgl1r10)), ...
        nanstd(sgl2r10)/sqrt(length(sgl2r10))];

    nexttile
    bar(xboxPAratio)
    hold on
    errorbar(xboxPAratio,semPAratio,'LineStyle','none')
    xticklabels({[Groups{1} ' 5/1'] [Groups{2} ' 5/1'] [Groups{1} ' 10/1'] [Groups{2} ' 10/1']})
    ylabel('Ratio Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Single Trial Peaks')


    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ClickTrain5']);
    exportgraphics(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ClickTrain5.pdf'])
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1onpeak,sgl2onpeak,1,'both'); % right tail: group 1 bigger
    PeakStats.SON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 5
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_5,sgl2_5,1,'both'); % left, group 2 is bigger
    PeakStats.S5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_10,sgl2_10,1,'both');
    PeakStats.S10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r5,sgl2r5,1,'both'); 
    PeakStats.Srat5(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r10,sgl2r10,1,'both'); 
    PeakStats.Srat10(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];


    % Averaged
    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1onpeak,avg2onpeak,1,'both'); % right tail: group 1 bigger
    PeakStats.AON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 5
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,5),avg2stk(:,5),1,'both'); % left, group 2 is bigger
    PeakStats.A5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,10),avg2stk(:,10),1,'both');
    PeakStats.A10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r5,avg2r5,1,'both'); 
    PeakStats.Arat5(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r10,avg2r10,1,'both'); 
    PeakStats.Arat10(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_ClickTrain5_Stats.csv']);
cd(homedir)