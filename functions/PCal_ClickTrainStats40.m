function PCal_ClickTrainStats40(homedir,Groups)
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
%           Data in ..\output\TracePeaks as *v*_ClickTrain_40_Stats.csv

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

% so far, we're only looking at 40 Hz, pull that out
stimfreq = 40;
grp1sgl = grp1sgl(grp1sgl.ClickFreq == stimfreq,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == stimfreq,:);
grp1avg = grp1avg(grp1avg.ClickFreq == stimfreq,:);
grp2avg = grp2avg(grp2avg.ClickFreq == stimfreq,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 20],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double','double','double','double',...
            'double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "SON",...
    "S10", "S20", "S40","S80","Srat10","Srat20","Srat40","Srat80",...
    "AON", "A10", "A20", "A40","A80","Arat10","Arat20","Arat40","Arat80"];

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
    % to 10, 20, 40, and 80

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

    nexttile 
    shadedErrorBar(1:size(avg1stk,2),nanmean(avg1stk,1),nanstd(avg1stk,0,1),'lineprops','b')
    hold on 
    shadedErrorBar(1:size(avg2stk,2),nanmean(avg2stk,1),nanstd(avg2stk,0,1),'lineprops','r')    
    xlabel('Clicks')
    ylabel('PeakAmp [mV/mm²] mean and std')
    title('Trial-Average Peaks')


    % some have max peak at 1st or 2nd click, so check first 3
    avg1onpeak = max(avg1stk(:,1:3),[],2);
    avg2onpeak = max(avg2stk(:,1:3),[],2);
    
    xboxPA = [avg1onpeak; avg2onpeak; avg1stk(:,10); avg2stk(:,10);...
        avg1stk(:,20); avg2stk(:,20); avg1stk(:,40); avg2stk(:,40);...
        avg1stk(:,80); avg2stk(:,80);];

    yboxes  = [repmat({'Grp1 1'},grp1size,1);repmat({'Grp2 1'},grp2size,1);
        repmat({'Grp1 10'},grp1size,1);repmat({'Grp2 10'},grp2size,1);
        repmat({'Grp1 20'},grp1size,1);repmat({'Grp2 20'},grp2size,1);
        repmat({'Grp1 40'},grp1size,1);repmat({'Grp2 40'},grp2size,1);
        repmat({'Grp1 80'},grp1size,1);repmat({'Grp2 80'},grp2size,1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Trial-Average Peaks')

    % here we're going to calculate the ratios and store them for stats
    avg1r10 = avg1stk(:,10)./avg1onpeak;
    avg1r20 = avg1stk(:,20)./avg1onpeak;
    avg1r40 = avg1stk(:,40)./avg1onpeak;
    avg1r80 = avg1stk(:,80)./avg1onpeak;

    avg2r10 = avg2stk(:,10)./avg2onpeak;
    avg2r20 = avg2stk(:,20)./avg2onpeak;
    avg2r40 = avg2stk(:,40)./avg2onpeak;
    avg2r80 = avg2stk(:,80)./avg2onpeak;
    
    xboxPAratio = [avg1r10; avg2r10; avg1r20; avg2r20;...
        avg1r40; avg2r40; avg1r80; avg2r80];

    yboxesratio  = [repmat({'Grp1 10/1'},grp1size,1);repmat({'Grp2 10/1'},grp2size,1);
        repmat({'Grp1 20/1'},grp1size,1);repmat({'Grp2 20/1'},grp2size,1);
        repmat({'Grp1 40/1'},grp1size,1);repmat({'Grp2 40/1'},grp2size,1);
        repmat({'Grp1 80/1'},grp1size,1);repmat({'Grp2 80/1'},grp2size,1)];

    nexttile
    boxplot(xboxPAratio,yboxesratio,'Notch','on')
    ylabel('Ratio Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Trial-Average Peaks')

    % single trial data
    nexttile 
    hold on 
    for itrial = 1:50
        plot(sgl1stk(:,:,itrial)','color',color12)
        plot(sgl2stk(:,:,itrial)','color',color22)
    end
    plot(nanmean(nanmean(sgl1stk,1),3),'color',color11,'LineWidth',4)
    plot(nanmean(nanmean(sgl2stk,1),3),'color',color21,'LineWidth',4)
    xlabel('Clicks')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    nexttile 
    shadedErrorBar(1:size(sgl1stk,2),nanmean(nanmean(sgl1stk,3),1),nanstd(nanmean(sgl1stk,3),0,1),'lineprops','b')
    hold on 
    shadedErrorBar(1:size(sgl2stk,2),nanmean(nanmean(sgl2stk,3),1),nanstd(nanmean(sgl2stk,3),0,1),'lineprops','r')    
    xlabel('Clicks')
    ylabel('PeakAmp [mV/mm²] mean and std')
    title('Single Trial Peaks')

    % we will take the max peak click determined in averaged data
    % we also have to stack the data appropriately
    sgl1onpeak = nan(length(avg1onpeak)*50,1);
    sgl1_10    = nan(length(sgl1onpeak),1);
    sgl1_20    = nan(length(sgl1onpeak),1);
    sgl1_40    = nan(length(sgl1onpeak),1);
    sgl1_80    = nan(length(sgl1onpeak),1);
    for iSub = 1:length(avg1onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1onpeak(count:countto) = squeeze(sgl1stk(iSub,avg1stk(iSub,:)==avg1onpeak(iSub),:));
        sgl1_10(count:countto)    = squeeze(sgl1stk(iSub,10,:));
        sgl1_20(count:countto)    = squeeze(sgl1stk(iSub,20,:));
        sgl1_40(count:countto)    = squeeze(sgl1stk(iSub,40,:));
        sgl1_80(count:countto)    = squeeze(sgl1stk(iSub,80,:));
    end
    sgl2onpeak = nan(length(avg2onpeak)*50,1);
    sgl2_10    = nan(length(sgl2onpeak),1);
    sgl2_20    = nan(length(sgl2onpeak),1);
    sgl2_40    = nan(length(sgl2onpeak),1);
    sgl2_80    = nan(length(sgl2onpeak),1);
    for iSub = 1:length(avg2onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2onpeak(count:countto) = squeeze(sgl2stk(iSub,avg2stk(iSub,:)==avg2onpeak(iSub),:));
        sgl2_10(count:countto)    = squeeze(sgl2stk(iSub,10,:));
        sgl2_20(count:countto)    = squeeze(sgl2stk(iSub,20,:));
        sgl2_40(count:countto)    = squeeze(sgl2stk(iSub,40,:));
        sgl2_80(count:countto)    = squeeze(sgl2stk(iSub,80,:));
    end
    
   xboxPA = [sgl1onpeak; sgl2onpeak; sgl1_10; sgl2_10;...
        sgl1_20; sgl2_20; sgl1_40; sgl2_40; sgl1_80; sgl2_80];

    yboxes  = [repmat({'Grp1 1'},grp1size*50,1);repmat({'Grp2 1'},grp2size*50,1);
        repmat({'Grp1 10'},grp1size*50,1);repmat({'Grp2 10'},grp2size*50,1);
        repmat({'Grp1 20'},grp1size*50,1);repmat({'Grp2 20'},grp2size*50,1);
        repmat({'Grp1 40'},grp1size*50,1);repmat({'Grp2 40'},grp2size*50,1);
        repmat({'Grp1 80'},grp1size*50,1);repmat({'Grp2 80'},grp2size*50,1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on','Symbol','')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Click')
    title('Single Trial Peaks')

    % here we're going to calculate the ratios and store them for stats
    sgl1r10 = sgl1_10./sgl1onpeak;
    sgl1r20 = sgl1_20./sgl1onpeak;
    sgl1r40 = sgl1_40./sgl1onpeak;
    sgl1r80 = sgl1_80./sgl1onpeak;

    sgl2r10 = sgl2_10./sgl2onpeak;
    sgl2r20 = sgl2_20./sgl2onpeak;
    sgl2r40 = sgl2_40./sgl2onpeak;
    sgl2r80 = sgl2_80./sgl2onpeak;
    
    xboxPAratio = [sgl1r10; sgl2r10; sgl1r20; sgl2r20;...
        sgl1r40; sgl2r40; sgl1r80; sgl2r80];

    yboxesratio  = [repmat({'Grp1 10/1'},grp1size*50,1);repmat({'Grp2 10/1'},grp2size*50,1);
        repmat({'Grp1 20/1'},grp1size*50,1);repmat({'Grp2 20/1'},grp2size*50,1);
        repmat({'Grp1 40/1'},grp1size*50,1);repmat({'Grp2 40/1'},grp2size*50,1);
        repmat({'Grp1 80/1'},grp1size*50,1);repmat({'Grp2 80/1'},grp2size*50,1)];

    nexttile
    boxplot(xboxPAratio,yboxesratio,'Notch','on','Symbol','')
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
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ClickTrain40']);
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1onpeak,sgl2onpeak,1,'both'); % right tail: group 1 bigger
    PeakStats.SON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_10,sgl2_10,1,'both'); % left, group 2 is bigger
    PeakStats.S10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_20,sgl2_20,1,'both');
    PeakStats.S20(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_40,sgl2_40,1,'both');
    PeakStats.S40(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_80,sgl2_80,1,'both');
    PeakStats.S80(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r10,sgl2r10,1,'both'); 
    PeakStats.Srat10(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r20,sgl2r20,1,'both'); 
    PeakStats.Srat20(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r40,sgl2r40,1,'both'); 
    PeakStats.Srat40(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r80,sgl2r80,1,'both'); 
    PeakStats.Srat80(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1onpeak,avg2onpeak,1,'both'); % right tail: group 1 bigger
    PeakStats.AON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,10),avg2stk(:,10),1,'both'); % left, group 2 is bigger
    PeakStats.A10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,20),avg2stk(:,20),1,'both');
    PeakStats.A20(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,40),avg2stk(:,40),1,'both');
    PeakStats.A40(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,80),avg2stk(:,80),1,'both');
    PeakStats.A80(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r10,avg2r10,1,'both'); 
    PeakStats.Arat10(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r20,avg2r20,1,'both'); 
    PeakStats.Arat20(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r40,avg2r40,1,'both'); 
    PeakStats.Arat40(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r80,avg2r80,1,'both'); 
    PeakStats.Arat80(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_ClickTrain40_Stats.csv']);
cd(homedir)