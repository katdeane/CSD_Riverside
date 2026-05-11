function NoiseBurstStats_3grp(homedir,Groups,whichdB)
% Noiseburst statistics
% collecting from ROIs based on group-averaged AVREC plots where three
% peaks can be distinguished in the WT group from 0-50 ms, 50-100 ms, and
% 100-300 ms after noise onset. Data for 10:10:90 is available. 
% Peak amp, peak latency, and RMS are compared at both single trial and 
% trial-averaged levels. 
% Input:    csv's from ..\output\TracePeaks for single trial and
%           trial-averaged data from running Avrec_Layers and
%           Group_Avrec_Layers respectively. 
% Output:   Figures in ..\figures\PeakPlots: scatter plots of peak amp over
%           latency and boxplots of all three features across time windows.
%           Data in ..\output\TracePeaks as *v*_NoiseBurst_70_Stats.csv

cd(homedir); 

% single trial data
grp1sgl = readtable([Groups{1} '_NoiseBurst_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_NoiseBurst_AVRECPeak.csv']);
grp3sgl = readtable([Groups{3} '_NoiseBurst_AVRECPeak.csv']);
% subject averaged data
grp1avg = readtable([Groups{1} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp3avg = readtable([Groups{3} '_NoiseBurst_AVG_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1sgl.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
BL = 400; 
color11 = [15/255 63/255 111/255]; % indigo 
color12 = [24/255 102/255 180/255]; 
color13 = [40/255 133/255 226/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 
color23 = [191/255 95/255 115/255]; 
color31 = [249/255 152/255 10/255]; % amber 
color32 = [250/255 181/255 76/255]; 
color33 = [251/255 197/255 116/255]; 

% so far, we're only looking at 70 dB, pull that out
grp1sgl = grp1sgl(grp1sgl.ClickFreq == whichdB,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == whichdB,:);
grp3sgl = grp3sgl(grp3sgl.ClickFreq == whichdB,:);
grp1avg = grp1avg(grp1avg.ClickFreq == whichdB,:);
grp2avg = grp2avg(grp2avg.ClickFreq == whichdB,:);
grp3avg = grp3avg(grp3avg.ClickFreq == whichdB,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill)*3 21],'VariableTypes',...
            {'string', 'string','string','double','double','double','double','double',...
            'double','double','double','double','double','double','double',...
            'double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Comp", "Layer", "stat", "STHPA",...
    "SCOPA", "SCNPA", "STHPL","SCOPL","SCNPL","STHRMS","SCORMS","SCNRMS",...
    "ATHPA", "ACOPA", "ACNPA", "ATHPL","ACOPL","ACNPL","ATHRMS","ACORMS","ACNRMS"];

countto = 0;

for iLay = 1:length(layers)
    % pull out current layer
    sgl1lay = grp1sgl(matches(grp1sgl.Layer, layers{iLay}),:);
    sgl2lay = grp2sgl(matches(grp2sgl.Layer, layers{iLay}),:);
    sgl3lay = grp3sgl(matches(grp3sgl.Layer, layers{iLay}),:);
    
    avg1lay = grp1avg(matches(grp1avg.Layer, layers{iLay}),:);
    avg2lay = grp2avg(matches(grp2avg.Layer, layers{iLay}),:);
    avg3lay = grp3avg(matches(grp3avg.Layer, layers{iLay}),:);
    
    % for noiseburst we have 3 time windows for testing
    sgl1thalamic = sgl1lay(sgl1lay.OrderofClick == 1,:); % 0 - 50 ms
    sgl1cortical = sgl1lay(sgl1lay.OrderofClick == 2,:); % 50 - 100 ms
    sgl1continue = sgl1lay(sgl1lay.OrderofClick == 3,:); % 100 - 300 ms
    sgl2thalamic = sgl2lay(sgl2lay.OrderofClick == 1,:); % 0 - 50 ms
    sgl2cortical = sgl2lay(sgl2lay.OrderofClick == 2,:); % 50 - 100 ms
    sgl2continue = sgl2lay(sgl2lay.OrderofClick == 3,:); % 100 - 300 ms
    sgl3thalamic = sgl3lay(sgl3lay.OrderofClick == 1,:); % 0 - 50 ms
    sgl3cortical = sgl3lay(sgl3lay.OrderofClick == 2,:); % 50 - 100 ms
    sgl3continue = sgl3lay(sgl3lay.OrderofClick == 3,:); % 100 - 300 ms

    avg1thalamic = avg1lay(avg1lay.OrderofClick == 1,:); % 0 - 50 ms
    avg1cortical = avg1lay(avg1lay.OrderofClick == 2,:); % 50 - 100 ms
    avg1continue = avg1lay(avg1lay.OrderofClick == 3,:); % 100 - 300 ms
    avg2thalamic = avg2lay(avg2lay.OrderofClick == 1,:); % 0 - 50 ms
    avg2cortical = avg2lay(avg2lay.OrderofClick == 2,:); % 50 - 100 ms
    avg2continue = avg2lay(avg2lay.OrderofClick == 3,:); % 100 - 300 ms
    avg3thalamic = avg3lay(avg3lay.OrderofClick == 1,:); % 0 - 50 ms
    avg3cortical = avg3lay(avg3lay.OrderofClick == 2,:); % 50 - 100 ms
    avg3continue = avg3lay(avg3lay.OrderofClick == 3,:); % 100 - 300 ms

    % let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels, ' num2str(whichdB) ' dB'])
    % single trial data
    nexttile
    plot(sgl1thalamic.PeakLat+BL,sgl1thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(sgl2thalamic.PeakLat+BL,sgl2thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    plot(sgl3thalamic.PeakLat+BL,sgl3thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color31,'MarkerEdgeColor','none')
    plot(sgl1cortical.PeakLat+BL+50,sgl1cortical.PeakAmp,'o',...
        'MarkerFaceColor',color12,'MarkerEdgeColor','none')
    plot(sgl2cortical.PeakLat+BL+50,sgl2cortical.PeakAmp,'o',...
        'MarkerFaceColor',color22,'MarkerEdgeColor','none')
    plot(sgl3cortical.PeakLat+BL+50,sgl3cortical.PeakAmp,'o',...
        'MarkerFaceColor',color32,'MarkerEdgeColor','none')
    plot(sgl1continue.PeakLat+BL+100,sgl1continue.PeakAmp,'o',...
        'MarkerFaceColor',color13,'MarkerEdgeColor','none')
    plot(sgl2continue.PeakLat+BL+100,sgl2continue.PeakAmp,'o',...
        'MarkerFaceColor',color23,'MarkerEdgeColor','none')
    plot(sgl3continue.PeakLat+BL+100,sgl3continue.PeakAmp,'o',...
        'MarkerFaceColor',color33,'MarkerEdgeColor','none')
    xline(450);xline(500)
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    % group data for dumb boxplot syntax (why is it like this)
    xboxPA  = [sgl1thalamic.PeakAmp; sgl2thalamic.PeakAmp; sgl3thalamic.PeakAmp;...
        sgl1cortical.PeakAmp; sgl2cortical.PeakAmp; sgl3cortical.PeakAmp; ...
        sgl1continue.PeakAmp; sgl2continue.PeakAmp; sgl3continue.PeakAmp];
    xboxPL  = [sgl1thalamic.PeakLat; sgl2thalamic.PeakLat; sgl3thalamic.PeakLat; ...
        sgl1cortical.PeakLat; sgl2cortical.PeakLat; sgl3cortical.PeakLat; ...
        sgl1continue.PeakLat; sgl2continue.PeakLat; sgl3continue.PeakLat];
    xboxRMS = [sgl1thalamic.RMS; sgl2thalamic.RMS; sgl3thalamic.RMS;...
        sgl1cortical.RMS; sgl2cortical.RMS; sgl3cortical.RMS; ...
        sgl1continue.RMS; sgl2continue.RMS; sgl3continue.RMS];
    size1 = length(sgl1thalamic.PeakAmp);
    size2 = length(sgl2thalamic.PeakAmp);
    size3 = length(sgl3thalamic.PeakAmp);
    
    yboxes  = [repmat({'Grp1 thalamic'},size1,1);repmat({'Grp2 thalamic'},size2,1);repmat({'Grp3 thalamic'},size3,1);...
        repmat({'Grp1 cortical'},size1,1);repmat({'Grp2 coritcal'},size2,1);repmat({'Grp3 coritcal'},size3,1);...
        repmat({'Grp1 continue'},size1,1);repmat({'Grp2 continue'},size2,1);repmat({'Grp3 continue'},size3,1)];
    
    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Time Window')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxPL,yboxes)
    ylabel('Peak Latency [ms]')
    xlabel('Group / Time Window')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxRMS,yboxes)
    ylabel('RMS [mV/mm²]')
    xlabel('Group / Time Window')
    title('Single Trial RMS')

    % trial-averaged data
    nexttile
    plot(avg1thalamic.PeakLat+BL,avg1thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(avg2thalamic.PeakLat+BL,avg2thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    plot(avg3thalamic.PeakLat+BL,avg3thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color31,'MarkerEdgeColor','none')
    plot(avg1cortical.PeakLat+BL+50,avg1cortical.PeakAmp,'o',...
        'MarkerFaceColor',color12,'MarkerEdgeColor','none')
    plot(avg2cortical.PeakLat+BL+50,avg2cortical.PeakAmp,'o',...
        'MarkerFaceColor',color22,'MarkerEdgeColor','none')
    plot(avg3cortical.PeakLat+BL+50,avg3cortical.PeakAmp,'o',...
        'MarkerFaceColor',color32,'MarkerEdgeColor','none')
    plot(avg1continue.PeakLat+BL+100,avg1continue.PeakAmp,'o',...
        'MarkerFaceColor',color13,'MarkerEdgeColor','none')
    plot(avg2continue.PeakLat+BL+100,avg2continue.PeakAmp,'o',...
        'MarkerFaceColor',color23,'MarkerEdgeColor','none')
    plot(avg3continue.PeakLat+BL+100,avg3continue.PeakAmp,'o',...
        'MarkerFaceColor',color33,'MarkerEdgeColor','none')
    xline(450);xline(500)
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Averaged Peaks')

    % group data for dumb boxplot syntax
    xboxPA  = [avg1thalamic.PeakAmp; avg2thalamic.PeakAmp; avg3thalamic.PeakAmp; ...
        avg1cortical.PeakAmp; avg2cortical.PeakAmp; avg3cortical.PeakAmp; ...
        avg1continue.PeakAmp; avg2continue.PeakAmp; avg3continue.PeakAmp];
    xboxPL  = [avg1thalamic.PeakLat; avg2thalamic.PeakLat; avg3thalamic.PeakLat; ...
        avg1cortical.PeakLat; avg2cortical.PeakLat; avg3cortical.PeakLat; ...
        avg1continue.PeakLat; avg2continue.PeakLat; avg3continue.PeakLat];
    xboxRMS = [avg1thalamic.RMS; avg2thalamic.RMS; avg3thalamic.RMS; ...
        avg1cortical.RMS; avg2cortical.RMS; avg3cortical.RMS; ...
        avg1continue.RMS; avg2continue.RMS; avg3continue.RMS];
    size1 = length(avg1thalamic.PeakAmp);
    size2 = length(avg2thalamic.PeakAmp);
    size3 = length(avg3thalamic.PeakAmp);
    
    yboxes  = [repmat({'Grp1 thalamic'},size1,1);repmat({'Grp2 thalamic'},size2,1);repmat({'Grp3 thalamic'},size3,1);
        repmat({'Grp1 cortical'},size1,1);repmat({'Grp2 coritcal'},size2,1);repmat({'Grp3 coritcal'},size3,1);
        repmat({'Grp1 continue'},size1,1);repmat({'Grp2 continue'},size2,1);repmat({'Grp3 continue'},size3,1)];
    
    nexttile
    boxplot(xboxPA,yboxes)
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Time Window')
    title('Trial-Averaged Peaks')

    nexttile
    boxplot(xboxPL,yboxes)
    ylabel('Peak Latency [ms]')
    xlabel('Group / Time Window')
    title('Trial-Averaged Peaks')

    nexttile
    boxplot(xboxRMS,yboxes)
    ylabel('RMS [mV/mm²]')
    xlabel('Group / Time Window')
    title('Trial-Averaged RMS')

    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_' layers{iLay} '_NoiseBurst_' num2str(whichdB)]);
    close(h)

    % no more stalling, it's stats time
    count = countto+1;
    countto = count + length(statfill)-1;
    PeakStats.Comp(count:countto) = repmat('AWTvAKO',length(statfill),1);
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % AWT V AKO (grp 1 v 2)
    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.PeakAmp,sgl2thalamic.PeakAmp,1,'both'); % both tail: group 1 bigger
    PeakStats.STHPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.PeakAmp,sgl2cortical.PeakAmp,1,'both');
    PeakStats.SCOPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.PeakAmp,sgl2continue.PeakAmp,1,'both');
    PeakStats.SCNPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.PeakLat,sgl2thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.STHPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.PeakLat,sgl2cortical.PeakLat,1,'both');
    PeakStats.SCOPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.PeakLat,sgl2continue.PeakLat,1,'both');
    PeakStats.SCNPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.RMS,sgl2thalamic.RMS,1,'both'); % both tail: group 1 bigger
    PeakStats.STHRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.RMS,sgl2cortical.RMS,1,'both');
    PeakStats.SCORMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.RMS,sgl2continue.RMS,1,'both');
    PeakStats.SCNRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.PeakAmp,avg2thalamic.PeakAmp,1,'both'); % both tail: group 1 bigger
    PeakStats.ATHPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.PeakAmp,avg2cortical.PeakAmp,1,'both');
    PeakStats.ACOPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.PeakAmp,avg2continue.PeakAmp,1,'both');
    PeakStats.ACNPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.PeakLat,avg2thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.ATHPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.PeakLat,avg2cortical.PeakLat,1,'both');
    PeakStats.ACOPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.PeakLat,avg2continue.PeakLat,1,'both');
    PeakStats.ACNPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.RMS,avg2thalamic.RMS,1,'both'); % both tail: group 1 bigger
    PeakStats.ATHRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.RMS,avg2cortical.RMS,1,'both');
    PeakStats.ACORMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.RMS,avg2continue.RMS,1,'both');
    PeakStats.ACNRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    count = countto+1;
    countto = count + length(statfill)-1;
    PeakStats.Comp(count:countto) = repmat('AWTvCKH',length(statfill),1);
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % AWT V CKH (grp 1 v 3)
    % Peak Amp
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1thalamic.PeakAmp,sgl3thalamic.PeakAmp,1,'both'); % both tail: group 1 bigger
    PeakStats.STHPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1cortical.PeakAmp,sgl3cortical.PeakAmp,1,'both');
    PeakStats.SCOPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1continue.PeakAmp,sgl3continue.PeakAmp,1,'both');
    PeakStats.SCNPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    % Peak Latency
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1thalamic.PeakLat,sgl3thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.STHPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1cortical.PeakLat,sgl3cortical.PeakLat,1,'both');
    PeakStats.SCOPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];
    
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1continue.PeakLat,sgl3continue.PeakLat,1,'both');
    PeakStats.SCNPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    % RMS
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1thalamic.RMS,sgl3thalamic.RMS,1,'both'); % both tail: group 1 bigger
    PeakStats.STHRMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1cortical.RMS,sgl3cortical.RMS,1,'both');
    PeakStats.SCORMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(sgl1continue.RMS,sgl3continue.RMS,1,'both');
    PeakStats.SCNRMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    % Averaged
    % Peak Amp
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1thalamic.PeakAmp,avg3thalamic.PeakAmp,1,'both'); % both tail: group 1 bigger
    PeakStats.ATHPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];
    
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1cortical.PeakAmp,avg3cortical.PeakAmp,1,'both');
    PeakStats.ACOPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1continue.PeakAmp,avg3continue.PeakAmp,1,'both');
    PeakStats.ACNPA(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];
    
    % Peak Latency
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1thalamic.PeakLat,avg3thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.ATHPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];
    
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1cortical.PeakLat,avg3cortical.PeakLat,1,'both');
    PeakStats.ACOPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1continue.PeakLat,avg3continue.PeakLat,1,'both');
    PeakStats.ACNPL(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    % RMS
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1thalamic.RMS,avg3thalamic.RMS,1,'both'); % both tail: group 1 bigger
    PeakStats.ATHRMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];
    
    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1cortical.RMS,avg3cortical.RMS,1,'both');
    PeakStats.ACORMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    [P,DF,CD,mean1,mean3,sd1,sd3] = myttest2(avg1continue.RMS,avg3continue.RMS,1,'both');
    PeakStats.ACNRMS(count:countto) = [P;DF;CD;mean1;mean3;sd1;sd3];

    count = countto+1;
    countto = count + length(statfill)-1;
    PeakStats.Comp(count:countto) = repmat('AKOvCKH',length(statfill),1);
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % AKO V CKH (grp 2 v 3)
    % Peak Amp
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2thalamic.PeakAmp,sgl3thalamic.PeakAmp,1,'both'); % both tail: group 1 bigger
    PeakStats.STHPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2cortical.PeakAmp,sgl3cortical.PeakAmp,1,'both');
    PeakStats.SCOPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2continue.PeakAmp,sgl3continue.PeakAmp,1,'both');
    PeakStats.SCNPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    % Peak Latency
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2thalamic.PeakLat,sgl3thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.STHPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2cortical.PeakLat,sgl3cortical.PeakLat,1,'both');
    PeakStats.SCOPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
    
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2continue.PeakLat,sgl3continue.PeakLat,1,'both');
    PeakStats.SCNPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    % RMS
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2thalamic.RMS,sgl3thalamic.RMS,1,'both'); % both tail: group 1 bigger
    PeakStats.STHRMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2cortical.RMS,sgl3cortical.RMS,1,'both');
    PeakStats.SCORMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(sgl2continue.RMS,sgl3continue.RMS,1,'both');
    PeakStats.SCNRMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    % Averaged
    % Peak Amp
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2thalamic.PeakAmp,avg3thalamic.PeakAmp,1,'both'); % both tail: group 2 bigger
    PeakStats.ATHPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
    
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2cortical.PeakAmp,avg3cortical.PeakAmp,1,'both');
    PeakStats.ACOPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2continue.PeakAmp,avg3continue.PeakAmp,1,'both');
    PeakStats.ACNPA(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
    
    % Peak Latency
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2thalamic.PeakLat,avg3thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.ATHPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
    
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2cortical.PeakLat,avg3cortical.PeakLat,1,'both');
    PeakStats.ACOPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2continue.PeakLat,avg3continue.PeakLat,1,'both');
    PeakStats.ACNPL(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    % RMS
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2thalamic.RMS,avg3thalamic.RMS,1,'both'); % both tail: group 2 bigger
    PeakStats.ATHRMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
    
    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2cortical.RMS,avg3cortical.RMS,1,'both');
    PeakStats.ACORMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];

    [P,DF,CD,mean2,mean3,sd2,sd3] = myttest2(avg2continue.RMS,avg3continue.RMS,1,'both');
    PeakStats.ACNRMS(count:countto) = [P;DF;CD;mean2;mean3;sd2;sd3];
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_NoiseBurst' num2str(whichdB) '_Stats.csv']);
