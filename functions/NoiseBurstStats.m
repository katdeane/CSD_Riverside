function NoiseBurstStats(homedir,Groups)
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
grp1sgl = readtable([Groups{1} '_NoiseBurst_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_NoiseBurst_AVRECPeak.csv']);
% subject averaged data
grp1avg = readtable([Groups{1} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_NoiseBurst_AVG_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1sgl.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
BL = 400; 
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color13 = [40/255 133/255 226/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 
color23 = [191/255 95/255 115/255]; 

% so far, we're only looking at 70 dB, pull that out
grp1sgl = grp1sgl(grp1sgl.ClickFreq == 70,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == 70,:);
grp1avg = grp1avg(grp1avg.ClickFreq == 70,:);
grp2avg = grp2avg(grp2avg.ClickFreq == 70,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 20],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double','double','double','double',...
            'double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "STHPA",...
    "SCOPA", "SCNPA", "STHPL","SCOPL","SCNPL","STHRMS","SCORMS","SCNRMS",...
    "ATHPA", "ACOPA", "ACNPA", "ATHPL","ACOPL","ACNPL","ATHRMS","ACORMS","ACNRMS"];

for iLay = 1:length(layers)
    % pull out current layer
    sgl1lay = grp1sgl(matches(grp1sgl.Layer, layers{iLay}),:);
    sgl2lay = grp2sgl(matches(grp2sgl.Layer, layers{iLay}),:);
    avg1lay = grp1avg(matches(grp1avg.Layer, layers{iLay}),:);
    avg2lay = grp2avg(matches(grp2avg.Layer, layers{iLay}),:);
    
    % for noiseburst we have 3 time windows for testing
    sgl1thalamic = sgl1lay(sgl1lay.OrderofClick == 1,:); % 0 - 50 ms
    sgl1cortical = sgl1lay(sgl1lay.OrderofClick == 2,:); % 50 - 100 ms
    sgl1continue = sgl1lay(sgl1lay.OrderofClick == 3,:); % 100 - 300 ms
    sgl2thalamic = sgl2lay(sgl2lay.OrderofClick == 1,:); % 0 - 50 ms
    sgl2cortical = sgl2lay(sgl2lay.OrderofClick == 2,:); % 50 - 100 ms
    sgl2continue = sgl2lay(sgl2lay.OrderofClick == 3,:); % 100 - 300 ms

    avg1thalamic = avg1lay(avg1lay.OrderofClick == 1,:); % 0 - 50 ms
    avg1cortical = avg1lay(avg1lay.OrderofClick == 2,:); % 50 - 100 ms
    avg1continue = avg1lay(avg1lay.OrderofClick == 3,:); % 100 - 300 ms
    avg2thalamic = avg2lay(avg2lay.OrderofClick == 1,:); % 0 - 50 ms
    avg2cortical = avg2lay(avg2lay.OrderofClick == 2,:); % 50 - 100 ms
    avg2continue = avg2lay(avg2lay.OrderofClick == 3,:); % 100 - 300 ms

    % let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
    % single trial data
    nexttile
    plot(sgl1thalamic.PeakLat+BL,sgl1thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(sgl2thalamic.PeakLat+BL,sgl2thalamic.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    plot(sgl1cortical.PeakLat+BL+50,sgl1cortical.PeakAmp,'o',...
        'MarkerFaceColor',color12,'MarkerEdgeColor','none')
    plot(sgl2cortical.PeakLat+BL+50,sgl2cortical.PeakAmp,'o',...
        'MarkerFaceColor',color22,'MarkerEdgeColor','none')
    plot(sgl1continue.PeakLat+BL+100,sgl1continue.PeakAmp,'o',...
        'MarkerFaceColor',color13,'MarkerEdgeColor','none')
    plot(sgl2continue.PeakLat+BL+100,sgl2continue.PeakAmp,'o',...
        'MarkerFaceColor',color23,'MarkerEdgeColor','none')
    xline(450);xline(500)
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    % group data for dumb boxplot syntax (why is it like this)
    xboxPA  = [sgl1thalamic.PeakAmp; sgl2thalamic.PeakAmp; sgl1cortical.PeakAmp;...
        sgl2cortical.PeakAmp; sgl1continue.PeakAmp; sgl2continue.PeakAmp];
    xboxPL  = [sgl1thalamic.PeakLat; sgl2thalamic.PeakLat; sgl1cortical.PeakLat;...
        sgl2cortical.PeakLat; sgl1continue.PeakLat; sgl2continue.PeakLat];
    xboxRMS = [sgl1thalamic.RMS; sgl2thalamic.RMS; sgl1cortical.RMS;...
        sgl2cortical.RMS; sgl1continue.RMS; sgl2continue.RMS];
    size1 = length(sgl1thalamic.PeakAmp);
    size2 = length(sgl2thalamic.PeakAmp);
    yboxes  = [repmat({'Grp1 thalamic'},size1,1);repmat({'Grp2 thalamic'},size2,1);
        repmat({'Grp1 cortical'},size1,1);repmat({'Grp2 coritcal'},size2,1);
        repmat({'Grp1 continue'},size1,1);repmat({'Grp2 continue'},size2,1)];
    
    nexttile
    boxplot(xboxPA,yboxes)
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
    plot(avg1cortical.PeakLat+BL+50,avg1cortical.PeakAmp,'o',...
        'MarkerFaceColor',color12,'MarkerEdgeColor','none')
    plot(avg2cortical.PeakLat+BL+50,avg2cortical.PeakAmp,'o',...
        'MarkerFaceColor',color22,'MarkerEdgeColor','none')
    plot(avg1continue.PeakLat+BL+100,avg1continue.PeakAmp,'o',...
        'MarkerFaceColor',color13,'MarkerEdgeColor','none')
    plot(avg2continue.PeakLat+BL+100,avg2continue.PeakAmp,'o',...
        'MarkerFaceColor',color23,'MarkerEdgeColor','none')
    xline(450);xline(500)
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Averaged Peaks')

    % group data for dumb boxplot syntax
    xboxPA  = [avg1thalamic.PeakAmp; avg2thalamic.PeakAmp; avg1cortical.PeakAmp;...
        avg2cortical.PeakAmp; avg1continue.PeakAmp; avg2continue.PeakAmp];
    xboxPL  = [avg1thalamic.PeakLat; avg2thalamic.PeakLat; avg1cortical.PeakLat;...
        avg2cortical.PeakLat; avg1continue.PeakLat; avg2continue.PeakLat];
    xboxRMS = [avg1thalamic.RMS; avg2thalamic.RMS; avg1cortical.RMS;...
        avg2cortical.RMS; avg1continue.RMS; avg2continue.RMS];
    size1 = length(avg1thalamic.PeakAmp);
    size2 = length(avg2thalamic.PeakAmp);
    yboxes  = [repmat({'Grp1 thalamic'},size1,1);repmat({'Grp2 thalamic'},size2,1);
        repmat({'Grp1 cortical'},size1,1);repmat({'Grp2 coritcal'},size2,1);
        repmat({'Grp1 continue'},size1,1);repmat({'Grp2 continue'},size2,1)];
    
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
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_NoiseBurst']);
    close(h)

    % no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.PeakAmp,sgl2thalamic.PeakAmp,1,'right'); % right tail: group 1 bigger
    PeakStats.STHPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.PeakAmp,sgl2cortical.PeakAmp,1,'right');
    PeakStats.SCOPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.PeakAmp,sgl2continue.PeakAmp,1,'right');
    PeakStats.SCNPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.PeakLat,sgl2thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.STHPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.PeakLat,sgl2cortical.PeakLat,1,'both');
    PeakStats.SCOPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.PeakLat,sgl2continue.PeakLat,1,'both');
    PeakStats.SCNPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1thalamic.RMS,sgl2thalamic.RMS,1,'right'); % right tail: group 1 bigger
    PeakStats.STHRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1cortical.RMS,sgl2cortical.RMS,1,'right');
    PeakStats.SCORMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1continue.RMS,sgl2continue.RMS,1,'right');
    PeakStats.SCNRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.PeakAmp,avg2thalamic.PeakAmp,1,'right'); % right tail: group 1 bigger
    PeakStats.ATHPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.PeakAmp,avg2cortical.PeakAmp,1,'right');
    PeakStats.ACOPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.PeakAmp,avg2continue.PeakAmp,1,'right');
    PeakStats.ACNPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.PeakLat,avg2thalamic.PeakLat,1,'both'); % tail: different
    PeakStats.ATHPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.PeakLat,avg2cortical.PeakLat,1,'both');
    PeakStats.ACOPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.PeakLat,avg2continue.PeakLat,1,'both');
    PeakStats.ACNPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1thalamic.RMS,avg2thalamic.RMS,1,'right'); % right tail: group 1 bigger
    PeakStats.ATHRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1cortical.RMS,avg2cortical.RMS,1,'right');
    PeakStats.ACORMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1continue.RMS,avg2continue.RMS,1,'right');
    PeakStats.ACNRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_NoiseBurst70_Stats.csv']);
