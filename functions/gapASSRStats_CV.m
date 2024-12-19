function gapASSRStats_CV(homedir,Groups)
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
grp1 = readtable([Groups{1} '_gapASSR_AVRECPeak.csv']);
grp2 = readtable([Groups{2} '_gapASSR_AVRECPeak.csv']);

% set some stuff up
layers = unique(grp1.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color21 = [115/255 46/255 61/255]; % wine

% so far, we're only looking at 10 ms, pull that out
gapwidth = 6;
grp1 = grp1(grp1.ClickFreq == gapwidth,:);
grp2 = grp2(grp2.ClickFreq == gapwidth,:);

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 5],'VariableTypes',...
            {'string','string','double','double','double'});

PeakStats.Properties.VariableNames = ["Layer", "stat", "PA",...
    "PL", "RMS"];

for iLay = 1:length(layers)
    % pull out current layer
    lay1 = grp1(matches(grp1.Layer, layers{iLay}),:);
    lay2 = grp2(matches(grp2.Layer, layers{iLay}),:);

    % we're only taking the last 3 gap-in-noise blocks and combining them
    lay1 =  lay1(lay1.OrderofClick >= 4,:);
    lay2 =  lay2(lay2.OrderofClick >= 4,:);

    grp1size = length(unique(lay1.Animal));
    grp1name = unique(lay1.Animal);
    grp2size = length(unique(lay2.Animal));
    grp2name = unique(lay2.Animal);

    %% let's make a nice figure
    Peakfig = tiledlayout('flow');
    title(Peakfig,[layers{iLay} ' Channels'])

    % single trial data
    % scatter plot
    nexttile
    plot(lay1.PeakLat,lay1.PeakAmp,'o',...
        'MarkerFaceColor',color11,'MarkerEdgeColor','none')
    hold on
    plot(lay2.PeakLat,lay2.PeakAmp,'o',...
        'MarkerFaceColor',color21,'MarkerEdgeColor','none')
    xlim([0 250])
    xlabel('Peak Latency [ms]')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    % calculate coefficient of variance per subject 
    PA1_CV = zeros(grp1size,1);
    PL1_CV = zeros(grp1size,1);
    RMS1_CV = zeros(grp1size,1);
    for iSub = 1:grp1size
        cur = lay1(matches(lay1.Animal,grp1name(iSub)),:);
        PA1_CV(iSub) = nanstd(cur.PeakAmp) / nanmean(cur.PeakAmp);
        PL1_CV(iSub) = nanstd(cur.PeakLat) / nanmean(cur.PeakLat);
        RMS1_CV(iSub) = nanstd(cur.RMS) / nanmean(cur.RMS);
    end
    PA2_CV = zeros(grp2size,1);
    PL2_CV = zeros(grp2size,1);
    RMS2_CV = zeros(grp2size,1);
    for iSub = 1:grp2size
        cur = lay2(matches(lay2.Animal,grp2name(iSub)),:);
        PA2_CV(iSub) = nanstd(cur.PeakAmp) / nanmean(cur.PeakAmp);
        PL2_CV(iSub) = nanstd(cur.PeakLat) / nanmean(cur.PeakLat);
        RMS2_CV(iSub) = nanstd(cur.RMS) / nanmean(cur.RMS);
    end
    
    % set up box plots
    xboxPA  = [PA1_CV; PA2_CV];
    xboxPL  = [PL1_CV; PL2_CV];
    xboxRMS = [RMS1_CV; RMS2_CV];

    yboxes  = [repmat({'Grp1 1'},size(PA1_CV,1),1);repmat({'Grp2 1'},size(PA2_CV,1),1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²] CV')
    xlabel('Group')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxPL,yboxes,'Notch','on')
    ylabel('Peak Latency [ms] CV')
    xlabel('Group')
    title('Single Trial Peaks')

    nexttile
    boxplot(xboxRMS,yboxes,'Notch','on')
    ylabel('RMS [mV/mm²] CV')
    xlabel('Group')
    title('Single Trial RMS')

    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_gapASSR_CV']);
    close(h)

    %% no more stalling, it's stats time
    count = (iLay-1)*length(statfill)+1;
    countto = count + length(statfill)-1;

    PeakStats.Layer(count:countto) = repmat(layers{iLay},length(statfill),1);
    PeakStats.stat(count:countto)  = statfill';

    % Single Peak Amp
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(PA1_CV,PA2_CV,1,'both'); 
    PeakStats.PA(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Single Peak Lat
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(PL1_CV,PL2_CV,1,'both'); 
    PeakStats.PL(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Single RMS
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(RMS1_CV,RMS2_CV,1,'both');
    PeakStats.RMS(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_gapASSR10_CV_Stats.csv']);
cd(homedir)