function gapASSRStats(homedir,Groups)
% ROIs are full gap in noise blocks and we will look at each subjects last
% 3 out six gap in noise blocks (3 blocks x 50 trials x 10 subjects).
% Currently being run only on 10 ms gap width. 
% Compared at both single trial and trial-averaged levels. 
% Input:    csv's from ..\output\TracePeaks for single trial and
%           trial-averaged data from running Avrec_Layers and
%           Group_Avrec_Layers respectively. 
% Output:   Figures in ..\figures\PeakPlots: scatter plots of peak amp over
%           latency and boxplots of those plus RMS.
%           Data in ..\output\TracePeaks as *v*_gapASSR_10_Stats.csv

cd(homedir); 

% single trial data
grp1sgl = readtable([Groups{1} '_gapASSR_AVRECPeak.csv']);
grp2sgl = readtable([Groups{2} '_gapASSR_AVRECPeak.csv']);
% subject averaged data
grp1avg = readtable([Groups{1} '_gapASSR_AVG_AVRECPeak.csv']);
grp2avg = readtable([Groups{2} '_gapASSR_AVG_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1sgl.Layer);
BL = 400;
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 

% so far, we're only looking at 40 Hz, pull that out
gapwidth = 10;
grp1sgl = grp1sgl(grp1sgl.ClickFreq == gapwidth,:);
grp2sgl = grp2sgl(grp2sgl.ClickFreq == gapwidth,:);
grp1avg = grp1avg(grp1avg.ClickFreq == gapwidth,:);
grp2avg = grp2avg(grp2avg.ClickFreq == gapwidth,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 8],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "SPA",...
    "SPL", "SRMS", "APA","APL","ARMS"];

for iLay = 1:length(layers)
    % pull out current layer
    sgl1lay = grp1sgl(matches(grp1sgl.Layer, layers{iLay}),:);
    sgl2lay = grp2sgl(matches(grp2sgl.Layer, layers{iLay}),:);
    avg1lay = grp1avg(matches(grp1avg.Layer, layers{iLay}),:);
    avg2lay = grp2avg(matches(grp2avg.Layer, layers{iLay}),:);

    % we're only taking the last 3 gap-in-noise blocks and combining them
    avg1lay =  avg1lay(avg1lay.OrderofClick >= 4,:);
    avg2lay =  avg2lay(avg2lay.OrderofClick >= 4,:);
    sgl1lay =  sgl1lay(sgl1lay.OrderofClick >= 4,:);
    sgl2lay =  sgl2lay(sgl2lay.OrderofClick >= 4,:);

    grp1size = length(unique(avg1lay.Animal));
    grp2size = length(unique(avg2lay.Animal));

    %% let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])
    
    % Average data
    % scatter plot 
    nexttile
    plot(avg1lay.PeakLat,avg1lay.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(avg2lay.PeakLat,avg2lay.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    xlim([0,250])
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Average Peaks')

    % set up box plots
    xboxPA  = [avg1lay.PeakAmp; avg2lay.PeakAmp];
    xboxPL  = [avg1lay.PeakLat; avg2lay.PeakLat];
    xboxRMS = [avg1lay.RMS; avg2lay.RMS];

    yboxes  = [repmat({'Grp1 1'},grp1size*3,1);repmat({'Grp2 1'},grp2size*3,1)];

    nexttile
    boxplot(xboxPA,yboxes)
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group')
    title('Trial-Average Peaks')

    nexttile
    boxplot(xboxPL,yboxes)
    ylabel('Peak Latency [ms]')
    xlabel('Group')
    title('Trial-Average Peaks')

    nexttile
    boxplot(xboxRMS,yboxes)
    ylabel('RMS [mV/mm²]')
    xlabel('Group')
    title('Trial-Average RMS')

    % single trial data
    % scatter plot
    nexttile
    plot(sgl1lay.PeakLat,sgl1lay.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(sgl2lay.PeakLat,sgl2lay.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    xlim([0 250])
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')
    
    % set up box plots
    xboxPA  = [sgl1lay.PeakAmp; sgl2lay.PeakAmp];
    xboxPL  = [sgl1lay.PeakLat; sgl2lay.PeakLat];
    xboxRMS = [sgl1lay.RMS; sgl2lay.RMS];

    yboxes  = [repmat({'Grp1 1'},size(xboxPA,1)/2,1);repmat({'Grp2 1'},size(xboxPA,1)/2,1)];

    nexttile
    boxplot(xboxPA,yboxes)
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxPL,yboxes)
    ylabel('Peak Latency [ms]')
    xlabel('Group')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxRMS,yboxes)
    ylabel('RMS [mV/mm²]')
    xlabel('Group')
    title('Single Trial RMS')

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_gapASSR']);
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Single Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.PeakAmp,sgl2lay.PeakAmp,1,'both'); 
    PeakStats.SPA(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Single Peak Lat
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.PeakLat,sgl2lay.PeakLat,1,'both'); 
    PeakStats.SPL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Single RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1lay.RMS,sgl2lay.RMS,1,'both');
    PeakStats.SRMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Average Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.PeakAmp,avg2lay.PeakAmp,1,'both');
    PeakStats.APA(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Average Peak Lat
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.PeakLat,avg2lay.PeakLat,1,'both');
    PeakStats.APL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Average RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1lay.RMS,avg2lay.RMS,1,'both');
    PeakStats.ARMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_gapASSR10_Stats.csv']);
cd(homedir)