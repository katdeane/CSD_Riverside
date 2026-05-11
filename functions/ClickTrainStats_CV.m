function ClickTrainStats_CV(homedir,Groups)
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
grp1 = readtable([Groups{1} '_ClickTrain_AVRECPeak.csv']);
grp2 = readtable([Groups{2} '_ClickTrain_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};

% so far, we're only looking at 40 Hz, pull that out
stimfreq = 40;
grp1 = grp1(grp1.ClickFreq == stimfreq,:);
grp2 = grp2(grp2.ClickFreq == stimfreq,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 12],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "PON",...
    "P10", "P20", "P40","P80","RON","R10", "R20", "R40","R80"];

for iLay = 1:length(layers)
    % pull out current layer
    lay1 = grp1(matches(grp1.Layer, layers{iLay}),:);
    lay2 = grp2(matches(grp2.Layer, layers{iLay}),:);

    grp1size = length(unique(lay1.Animal));
    grp1name = unique(lay1.Animal);
    grp2size = length(unique(lay2.Animal));
    grp2name = unique(lay2.Animal);

    stack1PA  = nan(grp1size,stimfreq*2,50); % maximum trials is 50
    stack2PA  = nan(grp2size,stimfreq*2,50);
    stack1RMS = nan(grp1size,stimfreq*2,50); % maximum trials is 50
    stack2RMS = nan(grp2size,stimfreq*2,50);
    % stack groups for pics
    for iSub = 1:grp1size
        % single trial needs to be sorted 
        sub1 = lay1(matches(lay1.Animal,grp1name{iSub}),:);
        for itrial = 1:length(unique(sub1.trial))
            if itrial <= 50 % just in case more than 50 were taken
                stack1PA(iSub,:,itrial) = sub1(sub1.trial == itrial,:).PeakAmp';
                stack1RMS(iSub,:,itrial) = sub1(sub1.trial == itrial,:).RMS';
            end
        end
    end
    for iSub = 1:grp2size
        % single trial needs to be sorted 
        sub2 = lay2(matches(lay2.Animal,grp2name{iSub}),:);
        for itrial = 1:length(unique(sub2.trial))
            if itrial <= 50 % just in case more than 50 were taken
                stack2PA(iSub,:,itrial) = sub2(sub2.trial == itrial,:).PeakAmp';
                stack2RMS(iSub,:,itrial) = sub2(sub2.trial == itrial,:).RMS';
            end
        end
    end

    % find the onset out of the first 3 click response windows (peak)
    avg1stk = squeeze(nanmean(stack1PA,3)); % average over trials
    avg1onpeak = max(avg1stk(:,1:3),[],2);  % find the max for each subject
    avg2stk = squeeze(nanmean(stack2PA,3));
    avg2onpeak = max(avg2stk(:,1:3),[],2);
    
    % calculate coefficient of variance for each subject 
    % stacks are subject x peak response x trial
    stack1PA = nanstd(stack1PA,0,3) ./ nanmean(stack1PA,3);
    stack2PA = nanstd(stack2PA,0,3) ./ nanmean(stack2PA,3);
    stack1RMS = nanstd(stack1RMS,0,3) ./ nanmean(stack1RMS,3);
    stack2RMS = nanstd(stack2RMS,0,3) ./ nanmean(stack2RMS,3);


    % We're going to look at the onset response click and then the response
    % to 10, 20, 40, and 80

    %% let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
       
    % we will take the max peak click determined in averaged data
    onpeak1 = nan(grp1size,1);
    p1_10   = nan(length(onpeak1),1);
    p1_20   = nan(length(onpeak1),1);
    p1_40   = nan(length(onpeak1),1);
    p1_80   = nan(length(onpeak1),1);
    onrms1  = nan(length(onpeak1),1);
    r1_10   = nan(length(onpeak1),1);
    r1_20   = nan(length(onpeak1),1);
    r1_40   = nan(length(onpeak1),1);
    r1_80   = nan(length(onpeak1),1);
    for iSub = 1:grp1size
        onpeak1(iSub) = stack1PA(iSub,avg1stk(iSub,:)==avg1onpeak(iSub));
        p1_10(iSub)   = stack1PA(iSub,10);
        p1_20(iSub)   = stack1PA(iSub,20);
        p1_40(iSub)   = stack1PA(iSub,40);
        p1_80(iSub)   = stack1PA(iSub,80);
        onrms1(iSub) = stack1RMS(iSub,avg1stk(iSub,:)==avg1onpeak(iSub));
        r1_10(iSub)   = stack1RMS(iSub,10);
        r1_20(iSub)   = stack1RMS(iSub,20);
        r1_40(iSub)   = stack1RMS(iSub,40);
        r1_80(iSub)   = stack1RMS(iSub,80);
    end
    onpeak2 = nan(grp2size,1);
    p2_10   = nan(length(onpeak2),1);
    p2_20   = nan(length(onpeak2),1);
    p2_40   = nan(length(onpeak2),1);
    p2_80   = nan(length(onpeak2),1);
    onrms2  = nan(length(onpeak2),1);
    r2_10   = nan(length(onpeak2),1);
    r2_20   = nan(length(onpeak2),1);
    r2_40   = nan(length(onpeak2),1);
    r2_80   = nan(length(onpeak2),1);
    for iSub = 1:grp2size
        onpeak2(iSub) = stack2PA(iSub,avg2stk(iSub,:)==avg2onpeak(iSub));
        p2_10(iSub)   = stack2PA(iSub,10);
        p2_20(iSub)   = stack2PA(iSub,20);
        p2_40(iSub)   = stack2PA(iSub,40);
        p2_80(iSub)   = stack2PA(iSub,80);
        onrms2(iSub)  = stack2RMS(iSub,avg2stk(iSub,:)==avg2onpeak(iSub));
        r2_10(iSub)   = stack2RMS(iSub,10);
        r2_20(iSub)   = stack2RMS(iSub,20);
        r2_40(iSub)   = stack2RMS(iSub,40);
        r2_80(iSub)   = stack2RMS(iSub,80);
    end
    
   xboxPA = [onpeak1; onpeak2; p1_10; p2_10;...
        p1_20; p2_20; p1_40; p2_40; p1_80; p2_80];

    yboxes  = [repmat({'Grp1 1'},grp1size,1);repmat({'Grp2 1'},grp2size,1);
        repmat({'Grp1 10'},grp1size,1);repmat({'Grp2 10'},grp2size,1);
        repmat({'Grp1 20'},grp1size,1);repmat({'Grp2 20'},grp2size,1);
        repmat({'Grp1 40'},grp1size,1);repmat({'Grp2 40'},grp2size,1);
        repmat({'Grp1 80'},grp1size,1);repmat({'Grp2 80'},grp2size,1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²] CV')
    xlabel('Group / Click')
    title('Peaks')

    xboxRMS = [onrms1; onrms2; r1_10; r2_10;...
        r1_20; r2_20; r1_40; r2_40; r1_80; r2_80];

    nexttile
    boxplot(xboxRMS,yboxes,'Notch','on')
    ylabel('Root Mean Square [mV/mm²] CV')
    xlabel('Group / Click')
    title('RMS')

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_ClickTrain_CV']);
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(onpeak1,onpeak2,1,'both'); % right tail: group 1 bigger
    PeakStats.PON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(p1_10,p2_10,1,'both'); % left, group 2 is bigger
    PeakStats.P10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(p1_20,p2_20,1,'both');
    PeakStats.P20(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(p1_40,p2_40,1,'both');
    PeakStats.P40(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(p1_80,p2_80,1,'both');
    PeakStats.P80(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(onrms1,onrms2,1,'both'); % right tail: group 1 bigger
    PeakStats.RON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(r1_10,r2_10,1,'both'); % left, group 2 is bigger
    PeakStats.R10(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(r1_20,r2_20,1,'both');
    PeakStats.R20(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(r1_40,r2_40,1,'both');
    PeakStats.R40(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(r1_80,r2_80,1,'both');
    PeakStats.R80(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_ClickTrain40_CV_Stats.csv']);
cd(homedir)