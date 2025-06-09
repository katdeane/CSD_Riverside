function PCal_NoiseBurstStats(homedir,Groups,whichdB)
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
% subject averaged data
grp1avg = readtable([Groups{1} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_NoiseBurst_AVG_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1sgl.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
BL = 400; 
color11 = [15/255 63/255 111/255]; %indigo blue
% color12 = [24/255 102/255 180/255]; 
% color13 = [40/255 133/255 226/255]; 
color21 = [115/255 46/255 61/255]; % wine
% color22 = [160/255 64/255 85/255]; 
% color23 = [191/255 95/255 115/255]; 

% so far, we're only looking at 70 dB, pull that out
grp1sgl = grp1sgl(grp1sgl.ClickFreq == whichdB,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == whichdB,:);
grp1avg = grp1avg(grp1avg.ClickFreq == whichdB,:);
grp2avg = grp2avg(grp2avg.ClickFreq == whichdB,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 8],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double'});

% S = single, A = average
PeakStats.Properties.VariableNames = ["Layer", "stat", "SPA",...
    "SPL","SRMS", "APA", "APL","ARMS"];

for iLay = 1:length(layers)
    % pull out current layer
    sgl1lay = grp1sgl(matches(grp1sgl.Layer, layers{iLay}),:);
    sgl2lay = grp2sgl(matches(grp2sgl.Layer, layers{iLay}),:);
    avg1lay = grp1avg(matches(grp1avg.Layer, layers{iLay}),:);
    avg2lay = grp2avg(matches(grp2avg.Layer, layers{iLay}),:);

    % let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels, ' num2str(whichdB) ' dB'])
    % single trial data
    % nexttile
    % plot(sgl1lay.PeakLat+BL,sgl1lay.PeakAmp,'o',...
    %     'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    % hold on
    % plot(sgl2lay.PeakLat+BL,sgl2lay.PeakAmp,'o',...
    %     'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    % xlabel('Peak Latency [ms]')
    % ylabel('Peak Amplitude [mV/mm²]')
    % title('Single Trial Peaks')

    % group data for dumb boxplot syntax (why is it like this)
    xboxPA  = [nanmean(sgl1lay.PeakAmp); nanmean(sgl2lay.PeakAmp)];
    % xboxPL  = [sgl1lay.PeakLat; sgl2lay.PeakLat];
    % xboxRMS = [sgl1lay.RMS; sgl2lay.RMS];
    size1 = length(sgl1lay.PeakAmp);
    size2 = length(sgl2lay.PeakAmp);

    semPA = [nanstd(sgl1lay.PeakAmp)/sqrt(size1), ...
        nanstd(sgl2lay.PeakAmp)/sqrt(size2)];
    % semPL = [nanstd(sgl1lay.PeakLat)/sqrt(size1), ...
    %     nanstd(sgl2lay.PeakLat)/sqrt(size2)];
    % semRMS = [nanstd(sgl1lay.RMS)/sqrt(size1), ...
    %     nanstd(sgl2lay.RMS)/sqrt(size2)];
    
    nexttile
    bar(xboxPA)
    hold on
    errorbar(xboxPA,semPA,'LineStyle', 'none')
    xticklabels({Groups{1} Groups{2}})
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Time Window')
    title('Single Trial Peaks')

    % nexttile
    % bar(xboxPL)
    % hold on
    % errorbar(xboxPL,semPL,'LineStyle', 'none')
    % xticks({Groups{1} Groups{2}})
    % ylabel('Peak Latency [ms]')
    % xlabel('Group / Time Window')
    % title('Single Trial Peaks')
    % 
    % nexttile
    % bar(xboxRMS)
    % hold on
    % errorbar(xboxRMS,semRMS,'LineStyle', 'none')
    % xticks({Groups{1} Groups{2}})
    % ylabel('RMS [mV/mm²]')
    % xlabel('Group / Time Window')
    % title('Single Trial RMS')

    % trial-averaged data
    % nexttile
    % plot(avg1lay.PeakLat+BL,avg1lay.PeakAmp,'o',...
    %     'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    % hold on
    % plot(avg2lay.PeakLat+BL,avg2lay.PeakAmp,'o',...
    %     'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    % xlabel('Peak Latency [ms]')
    % ylabel('Peak Amplitude [mV/mm²]')
    % title('Trial-Averaged Peaks')
    % 
    % % group data for dumb boxplot syntax
    % xboxPA  = [avg1lay.PeakAmp; avg2lay.PeakAmp];
    % xboxPL  = [avg1lay.PeakLat; avg2lay.PeakLat];
    % xboxRMS = [avg1lay.RMS; avg2lay.RMS];
    % size1 = length(avg1lay.PeakAmp);
    % size2 = length(avg2lay.PeakAmp);
    % yboxes  = [repmat({'Grp1'},size1,1);repmat({'Grp2'},size2,1)];
    % 
    % nexttile
    % boxplot(xboxPA,yboxes)
    % ylabel('Peak Amplitude [mV/mm²]')
    % xlabel('Group / Time Window')
    % title('Trial-Averaged Peaks')
    % 
    % nexttile
    % boxplot(xboxPL,yboxes)
    % ylabel('Peak Latency [ms]')
    % xlabel('Group / Time Window')
    % title('Trial-Averaged Peaks')
    % 
    % nexttile
    % boxplot(xboxRMS,yboxes)
    % ylabel('RMS [mV/mm²]')
    % xlabel('Group / Time Window')
    % title('Trial-Averaged RMS')

    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_NoiseBurst_' num2str(whichdB)]);
    close(h)

    % no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;
    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.PeakAmp,sgl2lay.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.SPA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.PeakLat,sgl2lay.PeakLat,1,'both'); % tail: different
    PeakStats.SPL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.RMS,sgl2lay.RMS,1,'both'); % right tail: group 1 bigger
    PeakStats.SRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.PeakAmp,avg2lay.PeakAmp,1,'both'); % right tail: group 1 bigger
    PeakStats.APA(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
    % Peak Latency
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.PeakLat,avg2lay.PeakLat,1,'both'); % tail: different
    PeakStats.APL(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.RMS,avg2lay.RMS,1,'both'); % right tail: group 1 bigger
    PeakStats.ARMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_NoiseBurst' num2str(whichdB) '_Stats.csv']);
