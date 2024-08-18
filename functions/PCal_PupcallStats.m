function PCal_PupcallStats(homedir,Groups,call_list)
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
layers = unique(grp1sgl.Layer);
statfill = {'p' 'df' 'CD' 'mean1' 'mean2' 'sd1' 'sd2'};
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 

% initiate a huge stats table for the lawls (for the stats)
PeakStats = table('Size',[length(layers)*length(statfill) 20],'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double','double','double','double','double',...
            'double','double','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
PeakStats.Properties.VariableNames = ["Layer", "stat", "SON",...
    "S2", "S3", "S4","S5","Srat2","Srat3","Srat4","Srat5",...
    "AON", "A2", "A3", "A4","A5","Arat2","Arat3","Arat4","Arat5"];

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

    avg1stk  = nan(grp1size,length(call_list)); % subject x peak
    sgl1stk  = nan(grp1size,length(call_list),50); % maximum trials is 50
    avg2stk  = nan(grp2size,length(call_list));
    sgl2stk  = nan(grp2size,length(call_list),50);
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
    xlabel('Calls')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Trial-Average Peaks')

    nexttile 
    shadedErrorBar(1:size(avg1stk,2),nanmean(avg1stk,1),nanstd(avg1stk,0,1),'lineprops','b')
    hold on 
    shadedErrorBar(1:size(avg2stk,2),nanmean(avg2stk,1),nanstd(avg2stk,0,1),'lineprops','r')    
    xlabel('Callss')
    ylabel('PeakAmp [mV/mm²] mean and std')
    title('Trial-Average Peaks')


    % onset peak
    avg1onpeak = avg1stk(:,1);
    avg2onpeak = avg2stk(:,1);
    
    xboxPA = [avg1onpeak; avg2onpeak; avg1stk(:,2); avg2stk(:,2);...
        avg1stk(:,3); avg2stk(:,3); avg1stk(:,4); avg2stk(:,4);...
        avg1stk(:,5); avg2stk(:,5);];

    yboxes  = [repmat({'Grp1 1'},grp1size,1);repmat({'Grp2 1'},grp2size,1);
        repmat({'Grp1 2'},grp1size,1);repmat({'Grp2 2'},grp2size,1);
        repmat({'Grp1 3'},grp1size,1);repmat({'Grp2 3'},grp2size,1);
        repmat({'Grp1 4'},grp1size,1);repmat({'Grp2 4'},grp2size,1);
        repmat({'Grp1 5'},grp1size,1);repmat({'Grp2 5'},grp2size,1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Calls')
    title('Trial-Average Peaks')

    % here we're going to calculate the ratios and store them for stats
    avg1r2 = avg1stk(:,2)./avg1onpeak;
    avg1r3 = avg1stk(:,3)./avg1onpeak;
    avg1r4 = avg1stk(:,4)./avg1onpeak;
    avg1r5 = avg1stk(:,5)./avg1onpeak;

    avg2r2 = avg2stk(:,2)./avg2onpeak;
    avg2r3 = avg2stk(:,3)./avg2onpeak;
    avg2r4 = avg2stk(:,4)./avg2onpeak;
    avg2r5 = avg2stk(:,5)./avg2onpeak;
    
    xboxPAratio = [avg1r2; avg2r2; avg1r3; avg2r3;...
        avg1r4; avg2r4; avg1r5; avg2r5];

    yboxesratio  = [repmat({'Grp1 2/1'},grp1size,1);repmat({'Grp2 2/1'},grp2size,1);
        repmat({'Grp1 3/1'},grp1size,1);repmat({'Grp2 3/1'},grp2size,1);
        repmat({'Grp1 4/1'},grp1size,1);repmat({'Grp2 4/1'},grp2size,1);
        repmat({'Grp1 5/1'},grp1size,1);repmat({'Grp2 5/1'},grp2size,1)];

    nexttile
    boxplot(xboxPAratio,yboxesratio,'Notch','on')
    ylabel('Ratio Peak Amplitude [mV/mm²]')
    xlabel('Group / Call')
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
    xlabel('Calls')
    ylabel('Peak Amplitude [mV/mm²]')
    title('Single Trial Peaks')

    nexttile 
    shadedErrorBar(1:size(sgl1stk,2),nanmean(nanmean(sgl1stk,3),1),nanstd(nanmean(sgl1stk,3),0,1),'lineprops','b')
    hold on 
    shadedErrorBar(1:size(sgl2stk,2),nanmean(nanmean(sgl2stk,3),1),nanstd(nanmean(sgl2stk,3),0,1),'lineprops','r')    
    xlabel('Calls')
    ylabel('PeakAmp [mV/mm²] mean and std')
    title('Single Trial Peaks')

    % we will take the max peak call determined in averaged data
    % we also have to stack the data appropriately
    sgl1onpeak = nan(length(avg1onpeak)*50,1);
    sgl1_2    = nan(length(sgl1onpeak),1);
    sgl1_3    = nan(length(sgl1onpeak),1);
    sgl1_4    = nan(length(sgl1onpeak),1);
    sgl1_5    = nan(length(sgl1onpeak),1);
    for iSub = 1:length(avg1onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl1onpeak(count:countto) = squeeze(sgl1stk(iSub,avg1stk(iSub,:)==avg1onpeak(iSub),:));
        sgl1_2(count:countto)    = squeeze(sgl1stk(iSub,2,:));
        sgl1_3(count:countto)    = squeeze(sgl1stk(iSub,3,:));
        sgl1_4(count:countto)    = squeeze(sgl1stk(iSub,4,:));
        sgl1_5(count:countto)    = squeeze(sgl1stk(iSub,5,:));
    end
    sgl2onpeak = nan(length(avg2onpeak)*50,1);
    sgl2_2    = nan(length(sgl2onpeak),1);
    sgl2_3    = nan(length(sgl2onpeak),1);
    sgl2_4    = nan(length(sgl2onpeak),1);
    sgl2_5    = nan(length(sgl2onpeak),1);
    for iSub = 1:length(avg2onpeak)
        count = ((iSub-1)*50)+1;
        countto = count+49;
        sgl2onpeak(count:countto) = squeeze(sgl2stk(iSub,avg2stk(iSub,:)==avg2onpeak(iSub),:));
        sgl2_2(count:countto)    = squeeze(sgl2stk(iSub,2,:));
        sgl2_3(count:countto)    = squeeze(sgl2stk(iSub,3,:));
        sgl2_4(count:countto)    = squeeze(sgl2stk(iSub,4,:));
        sgl2_5(count:countto)    = squeeze(sgl2stk(iSub,5,:));
    end
    
   xboxPA = [sgl1onpeak; sgl2onpeak; sgl1_2; sgl2_2;...
        sgl1_3; sgl2_3; sgl1_4; sgl2_4; sgl1_5; sgl2_5];

    yboxes  = [repmat({'Grp1 1'},grp1size*50,1);repmat({'Grp2 1'},grp2size*50,1);
        repmat({'Grp1 2'},grp1size*50,1);repmat({'Grp2 2'},grp2size*50,1);
        repmat({'Grp1 3'},grp1size*50,1);repmat({'Grp2 3'},grp2size*50,1);
        repmat({'Grp1 4'},grp1size*50,1);repmat({'Grp2 4'},grp2size*50,1);
        repmat({'Grp1 5'},grp1size*50,1);repmat({'Grp2 5'},grp2size*50,1)];

    nexttile
    boxplot(xboxPA,yboxes,'Notch','on','Symbol','')
    ylabel('Peak Amplitude [mV/mm²]')
    xlabel('Group / Call')
    title('Single Trial Peaks')

    % here we're going to calculate the ratios and store them for stats
    sgl1r2 = sgl1_2./sgl1onpeak;
    sgl1r3 = sgl1_3./sgl1onpeak;
    sgl1r4 = sgl1_4./sgl1onpeak;
    sgl1r5 = sgl1_5./sgl1onpeak;

    sgl2r2 = sgl2_2./sgl2onpeak;
    sgl2r3 = sgl2_3./sgl2onpeak;
    sgl2r4 = sgl2_4./sgl2onpeak;
    sgl2r5 = sgl2_5./sgl2onpeak;
    
    xboxPAratio = [sgl1r2; sgl2r2; sgl1r3; sgl2r3;...
        sgl1r4; sgl2r4; sgl1r5; sgl2r5];

    yboxesratio  = [repmat({'Grp1 2/1'},grp1size*50,1);repmat({'Grp2 2/1'},grp2size*50,1);
        repmat({'Grp1 3/1'},grp1size*50,1);repmat({'Grp2 3/1'},grp2size*50,1);
        repmat({'Grp1 4/1'},grp1size*50,1);repmat({'Grp2 4/1'},grp2size*50,1);
        repmat({'Grp1 5/1'},grp1size*50,1);repmat({'Grp2 5/1'},grp2size*50,1)];

    nexttile
    boxplot(xboxPAratio,yboxesratio,'Notch','on','Symbol','')
    ylabel('Ratio Peak Amplitude [mV/mm²]')
    xlabel('Group / Call')
    title('Single Trial Peaks')


    % save figure
    cd(homedir); cd figures; 
    if ~exist('PeakPlots','dir')
        mkdir('PeakPlots')
    end
    cd PeakPlots
    h = gcf;
    savefig(h,[Groups{1} 'v' Groups{2} '_' layers{iLay} '_PupCall']);
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
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_2,sgl2_2,1,'both'); % left, group 2 is bigger
    PeakStats.S2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_3,sgl2_3,1,'both');
    PeakStats.S3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_4,sgl2_4,1,'both');
    PeakStats.S4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(sgl1_5,sgl2_5,1,'both');
    PeakStats.S5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r2,sgl2r2,1,'both'); 
    PeakStats.Srat2(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r3,sgl2r3,1,'both'); 
    PeakStats.Srat3(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r4,sgl2r4,1,'both'); 
    PeakStats.Srat4(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(sgl1r5,sgl2r5,1,'both'); 
    PeakStats.Srat5(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Averaged
    % Peak Onset
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1onpeak,avg2onpeak,1,'both'); % right tail: group 1 bigger
    PeakStats.AON(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 10
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,2),avg2stk(:,2),1,'both'); % left, group 2 is bigger
    PeakStats.A2(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 20 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,3),avg2stk(:,3),1,'both');
    PeakStats.A3(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 40 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,4),avg2stk(:,4),1,'both');
    PeakStats.A4(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];
    % Peak 80 
    [P,DF,CD,mean1,mean2,sd1,sd2] = myttest2(avg1stk(:,5),avg2stk(:,5),1,'both');
    PeakStats.A5(count:countto)  = [P;DF;CD;mean1;mean2;sd1;sd2];

    % Peak Ratio to onset
    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r2,avg2r2,1,'both'); 
    PeakStats.Arat2(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r3,avg2r3,1,'both'); 
    PeakStats.Arat3(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r4,avg2r4,1,'both'); 
    PeakStats.Arat4(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];

    [P,DF,CD,mean1,mean2,sd1,sd2]   = myttest2(avg1r5,avg2r5,1,'both'); 
    PeakStats.Arat5(count:countto) = [P;DF;CD;mean1;mean2;sd1;sd2];
    
end

cd(homedir); cd output; cd TracePeaks
writetable(PeakStats,[Groups{1} 'v' Groups{2} '_PupCall_Stats.csv']);
cd(homedir)