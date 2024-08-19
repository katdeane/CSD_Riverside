function NoiseBurstStats_CV(homedir,Groups)
% Noiseburst statistics
% collecting from ROIs based on group-averaged AVREC plots where three
% peaks can be distinguished in the WT group from 0-50 ms, 50-100 ms, and
% 100-300 ms after noise onset. Currently only being run on 70 dB SPL noise
% but data for 10:10:90 is available. Peak amp, peak latency, and RMS are
% compared at both single trial and trial-averaged levels. 
% Input:    csv's from ..\output\TracePeaks for single trial and
%           trial-averaged data from running Avrec_Layers and
%           Group_Avrec_Layers respectively. 
% Output:   Figures in ..\figures\PeakPlots: scatter plots of peak amp over
%           latency and boxplots of all three features across time windows.
%           Data in ..\output\TracePeaks as *v*_NoiseBurst_70_Stats.csv

cd(homedir); 

% single trial data
grp1 = readtable([Groups{1} '_NoiseBurst_AVRECPeak.csv']);
grp2 = readtable([Groups{2} '_NoiseBurst_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
BL = 400; 
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color13 = [40/255 133/255 226/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 
color23 = [191/255 95/255 115/255]; 

% so far, we're only looking at 70 dB, pull that out
grp1 = grp1(grp1.ClickFreq == 70,:);
grp2 = grp2(grp2.ClickFreq == 70,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 11],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "THPA",...
    "COPA", "CNPA", "THPL","COPL","CNPL","THRMS","CORMS","CNRMS"];

for iLay = 1:length(layers)
    % pull out current layer
    lay1 = grp1(matches(grp1.Layer, layers{iLay}),:);
    lay2 = grp2(matches(grp2.Layer, layers{iLay}),:);
    
    % for noiseburst we have 3 time windows for testing
    thalamic1 = lay1(lay1.OrderofClick == 1,:); % 0 - 50 ms
    cortical1 = lay1(lay1.OrderofClick == 2,:); % 50 - 100 ms
    continue1 = lay1(lay1.OrderofClick == 3,:); % 100 - 300 ms
    thalamic2 = lay2(lay2.OrderofClick == 1,:); % 0 - 50 ms
    cortical2 = lay2(lay2.OrderofClick == 2,:); % 50 - 100 ms
    continue2 = lay2(lay2.OrderofClick == 3,:); % 100 - 300 ms

    % let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
    % single trial data
    nexttile
    plot(thalamic1.PeakLat+BL,thalamic1.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(thalamic2.PeakLat+BL,thalamic2.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    plot(cortical1.PeakLat+BL+50,cortical1.PeakAmp,'o',...
        'MarkerFaceColor',color12,'MarkerEdgeColor','none')
    plot(cortical2.PeakLat+BL+50,cortical2.PeakAmp,'o',...
        'MarkerFaceColor',color22,'MarkerEdgeColor','none')
    plot(continue1.PeakLat+BL+100,continue1.PeakAmp,'o',...
        'MarkerFaceColor',color13,'MarkerEdgeColor','none')
    plot(continue2.PeakLat+BL+100,continue2.PeakAmp,'o',...
        'MarkerFaceColor',color23,'MarkerEdgeColor','none')
    xline(450);xline(500)
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    % calculate coefficient of variance for each subject
    grp1subs = unique(thalamic1.Animal);
    THPA1_CV = zeros(length(grp1subs),1);
    THPL1_CV = zeros(length(grp1subs),1);
    THRMS1_CV = zeros(length(grp1subs),1);
    COPA1_CV = zeros(length(grp1subs),1);
    COPL1_CV = zeros(length(grp1subs),1);
    CORMS1_CV = zeros(length(grp1subs),1);
    CNPA1_CV = zeros(length(grp1subs),1);
    CNPL1_CV = zeros(length(grp1subs),1);
    CNRMS1_CV = zeros(length(grp1subs),1);

    for iSub = 1:length(grp1subs)
        curth = thalamic1(matches(thalamic1.Animal,grp1subs(iSub)),:);
        THPA1_CV(iSub) = nanstd(curth.PeakAmp) / nanmean(curth.PeakAmp);
        THPL1_CV(iSub) = nanstd(curth.PeakLat) / nanmean(curth.PeakLat);
        THRMS1_CV(iSub) = nanstd(curth.RMS) / nanmean(curth.RMS);

        curco = cortical1(matches(cortical1.Animal,grp1subs(iSub)),:);
        COPA1_CV(iSub) = nanstd(curco.PeakAmp) / nanmean(curco.PeakAmp);
        COPL1_CV(iSub) = nanstd(curco.PeakLat) / nanmean(curco.PeakLat);
        CORMS1_CV(iSub) = nanstd(curco.RMS) / nanmean(curco.RMS);

        curcn = continue1(matches(continue1.Animal,grp1subs(iSub)),:);
        CNPA1_CV(iSub) = nanstd(curcn.PeakAmp) / nanmean(curcn.PeakAmp);
        CNPL1_CV(iSub) = nanstd(curcn.PeakLat) / nanmean(curcn.PeakLat);
        CNRMS1_CV(iSub) = nanstd(curcn.RMS) / nanmean(curcn.RMS);
    end
    
    grp2subs = unique(thalamic2.Animal);
    THPA2_CV = zeros(length(grp2subs),1);
    THPL2_CV = zeros(length(grp2subs),1);
    THRMS2_CV = zeros(length(grp2subs),1);
    COPA2_CV = zeros(length(grp2subs),1);
    COPL2_CV = zeros(length(grp2subs),1);
    CORMS2_CV = zeros(length(grp2subs),1);
    CNPA2_CV = zeros(length(grp2subs),1);
    CNPL2_CV = zeros(length(grp2subs),1);
    CNRMS2_CV = zeros(length(grp2subs),1);

    for iSub = 1:length(grp2subs)
        curth = thalamic2(matches(thalamic2.Animal,grp2subs(iSub)),:);
        THPA2_CV(iSub) = nanstd(curth.PeakAmp) / nanmean(curth.PeakAmp);
        THPL2_CV(iSub) = nanstd(curth.PeakLat) / nanmean(curth.PeakLat);
        THRMS2_CV(iSub) = nanstd(curth.RMS) / nanmean(curth.RMS);

        curco = cortical2(matches(cortical2.Animal,grp2subs(iSub)),:);
        COPA2_CV(iSub) = nanstd(curco.PeakAmp) / nanmean(curco.PeakAmp);
        COPL2_CV(iSub) = nanstd(curco.PeakLat) / nanmean(curco.PeakLat);
        CORMS2_CV(iSub) = nanstd(curco.RMS) / nanmean(curco.RMS);

        curcn = continue2(matches(continue2.Animal,grp2subs(iSub)),:);
        CNPA2_CV(iSub) = nanstd(curcn.PeakAmp) / nanmean(curcn.PeakAmp);
        CNPL2_CV(iSub) = nanstd(curcn.PeakLat) / nanmean(curcn.PeakLat);
        CNRMS2_CV(iSub) = nanstd(curcn.RMS) / nanmean(curcn.RMS);
    end

    % box plot the CVs 
    xboxPA  = [THPA1_CV; THPA2_CV; COPA1_CV; COPA2_CV; CNPA1_CV; CNPA2_CV];
    xboxPL  = [THPL1_CV; THPL2_CV; COPL1_CV; COPL2_CV; CNPL1_CV; CNPL2_CV];
    xboxRMS = [THRMS1_CV; THRMS2_CV; CORMS1_CV; CORMS2_CV; CNRMS1_CV; CNRMS2_CV];
    size1 = length(THPA1_CV);
    size2 = length(THPA2_CV);
    yboxes  = [repmat({'Grp1 thalamic'},size1,1);repmat({'Grp2 thalamic'},size2,1);
        repmat({'Grp1 cortical'},size1,1);repmat({'Grp2 coritcal'},size2,1);
        repmat({'Grp1 continue'},size1,1);repmat({'Grp2 continue'},size2,1)];
    
    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²] CV')
    xlabel('Group / Time Window')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxPL,yboxes,'Notch','on')
    ylabel('Peak Latency [ms] CV')
    xlabel('Group / Time Window')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxRMS,yboxes,'Notch','on')
    ylabel('RMS [mV/mm²]')
    xlabel('Group / Time Window')
    title('Single Trial RMS')

    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_NoiseBurst_CV']);
    close(h)

    % no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(THPA1_CV,THPA2_CV,1,'both'); % right tail: group 1 bigger
    PeakStats.THPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(COPA1_CV,COPA2_CV,1,'both');
    PeakStats.COPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(CNPA1_CV,CNPA2_CV,1,'both');
    PeakStats.CNPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(THPL1_CV,THPL2_CV,1,'both'); % tail: different
    PeakStats.THPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(COPL1_CV,COPL2_CV,1,'both');
    PeakStats.COPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(CNPL1_CV,CNPL2_CV,1,'both');
    PeakStats.CNPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(THRMS1_CV,THRMS2_CV,1,'both'); % right tail: group 1 bigger
    PeakStats.THRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(CORMS1_CV,CORMS2_CV,1,'both');
    PeakStats.CORMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(CNRMS1_CV,CNRMS2_CV,1,'both');
    PeakStats.CNRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_NoiseBurst70_CV_Stats.csv']);
