function plotFFT_PCal(homedir,figfolder,outfolder,params,type,Comparison)

if ~exist('type','var')
    type = 'AB'; % absolute or RE relative
end
if ~exist('Comparison','var')
    Comparison = 'Pupcall'; % or 'ClickTrain
end

% Load in Spontaneous FFT
loadnameS = [params.groups{1} 'v' params.groups{2} '_Spontaneous_' type '_FFT.mat'];
load(loadnameS,['fftStruct' type])
if matches(type,'AB')
    fftTabS = struct2table(fftStructAB);
elseif matches(type,'RE')
    fftTabS = struct2table(fftStructRE);
end

if matches(Comparison, 'Pupcall')
    % Load in Pupcall FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_Pupcall_' type '_FFT.mat'];
    color11 = [255/255 175/255 105/255]; % light orange
    color12 = [224/255 115/255 0/255]; % dark orange

elseif matches(Comparison, 'ShortCall')
    % Load in Pupcall FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_ShortCall_' type '_FFT.mat'];
    color11 = [255/255 175/255 105/255]; % light orange
    color12 = [224/255 115/255 0/255]; % dark orange

elseif matches(Comparison,'ClickTrain')
    % Load in ClickTrain FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_ClickTrain_' type '_FFT.mat'];
    color11 = [74/255 183/255 255/255]; % light blue
    color12 = [0/255  77/255  125/255]; % dark dark

elseif matches(Comparison,'NoiseBurst')
    % Load in ClickTrain FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_NoiseBurst_' type '_FFT.mat'];
    color11 = [74/255 183/255 255/255]; % light blue
    color12 = [0/255  77/255  125/255]; % dark dark

elseif matches(Comparison, 'MaskCall')
    % Load in Pupcall FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_MaskCall_' type '_FFT.mat'];
    color11 = [255/255 175/255 105/255]; % light orange
    color12 = [224/255 115/255 0/255]; % dark orange

end
load(loadname2,['fftStruct' type])
if matches(type,'AB')
    fftTabP = struct2table(fftStructAB);
elseif matches(type,'RE')
    fftTabP = struct2table(fftStructRE);
end
clear fftStructAB fftStructRE % kat, just save it as a table in the other script :P

% for plotting
Fs = 1000; % Sampling frequency
LS  = length(fftTabS.fft{1}); % Length of signal [ms]


% color12 = [24/255 102/255 180/255]; 

color21 = [87/255 255/255 210/255]; % light teal
color22 = [0/255  209/255 153/255]; % dark teal

if exist([figfolder '\FFTfig'],'dir')
    cd([figfolder '\FFTfig']);
else
    mkdir([figfolder '\FFTfig']), cd([figfolder '\FFTfig']);
end

% initiate table here 
FFTData = table('Size',[20000 11], 'VariableTypes', {'string','string',...
    'string','string','double','double','double','double','double',...
    'double','double'});
FFTData.Properties.VariableNames = ["Group","Subject","Condition","Layer",...
    "trial","delta","theta","alpha","beta","lowgam","highgam"];
count = 1;

for iLay = 1:length(params.layers)

    FFTfig = tiledlayout('flow');
    title(FFTfig,['PCal FFT ' params.layers{iLay} ' '  type])
    xlabel(FFTfig, 'f (Hz)')
    ylabel(FFTfig, 'Power')

    % pull out layer data
    layTabS = fftTabS(matches(fftTabS.layer,params.layers{iLay}),:);
    layTabP = fftTabP(matches(fftTabP.layer,params.layers{iLay}),:);

    % get both groups
    grp1S = layTabS.fft(matches(layTabS.group,params.groups{1}),:);
    grp2S = layTabS.fft(matches(layTabS.group,params.groups{2}),:);
    grp1P = layTabP.fft(matches(layTabP.group,params.groups{1}),:);
    grp2P = layTabP.fft(matches(layTabP.group,params.groups{2}),:);
    trialsize = size(grp1P{1},2);
    % stack the trials
    if matches(Comparison,'NoiseBurst') && trialsize > 75
        % noiseburst has too many trials, we want the spread of 20 - 50 dB
        % but we want to pare it down. Randomly take 60 from the 200 trials
        % but keep it the same every time
        rng(42) % create seed for repeatable random set
        p = randperm(200,60);
        grpsize = size(grp1P);
        for iSub = 1:grpsize
            thisSub = grp1P{iSub}(:,p);
            if iSub == 1
                tmpgrp1p = thisSub;
            else
            tmpgrp1p = horzcat(tmpgrp1p, thisSub);
            end
        end
        grpsize = size(grp2P);
        for iSub = 1:grpsize
            thisSub = grp2P{iSub}(:,p);
            if iSub == 1
                tmpgrp2p = thisSub;
            else
            tmpgrp2p = horzcat(tmpgrp2p, thisSub);
            end
        end
        grp1P = tmpgrp1p; grp2P = tmpgrp2p; % not my cleanest work
    else
        grp1P = horzcat(grp1P{:}); grp2P = horzcat(grp2P{:});
    end
    grp1S = horzcat(grp1S{:}); grp2S = horzcat(grp2S{:});

    if matches(Comparison,'Pupcall')
        % Pupcall data needs to be gaussian filtered because it's too many
        % sampling points (Clicks don't need to be)
        grp1P = imgaussfilt(grp1P,10);
        grp2P = imgaussfilt(grp2P,10);
        grp1P = downsample(grp1P,10);
        grp2P = downsample(grp2P,10);
    end
    % now it needs to be resampled so we can use Spont data to ratio
    grp1P = resample(grp1P,LS,size(grp1P,1));
    grp2P = resample(grp2P,LS,size(grp2P,1));
    % that felt good :)

    % means and sems
    grp1mS = mean(grp1S,2);
    grp2mS = mean(grp2S,2);
    grp1semS = std(grp1S,0,2)/sqrt(LS); 
    grp2semS = std(grp2S,0,2)/sqrt(LS);
    grp1mP = mean(grp1P,2);
    grp2mP = mean(grp2P,2);
    grp1semP = std(grp1P,0,2)/sqrt(LS); % length of signal now matches
    grp2semP = std(grp2P,0,2)/sqrt(LS);

    % we need ratio of Pupcalls / Spont in same group
    ratioPSm1 = grp1mP ./ grp1mS; % ratio mean line for plotting
    ratioPSm2 = grp2mP ./ grp2mS; % ratio mean line for plotting
    ratioPS1  = grp1P ./ grp1mS; % ratio of all pupcalls to mean spont
    ratioPS2  = grp2P ./ grp2mS; % ratio of all pupcalls to mean spont
    ratioSS1  = grp1S ./ grp1mS; % ratio of all pupcalls to mean spont
    ratioSS2  = grp2S ./ grp2mS; % ratio of all pupcalls to mean spont
        
    fftaxis = (Fs/LS)*(0:LS-1);

    nexttile
    plot(fftaxis,grp1mS,'-','Color',color21)
    hold on
    errorbar(fftaxis,grp1mS,grp1semS,'Color',color21,'LineStyle','none','CapSize',3);
    semilogy(fftaxis,grp2mS,'-','Color',color22)
    errorbar(fftaxis,grp2mS,grp2semS,'Color',color22,'LineStyle','none','CapSize',3);
    semilogy(fftaxis,grp1mP,'-','Color',color11)
    errorbar(fftaxis,grp1mP,grp1semP,'Color',color11,'LineStyle','none','CapSize',3);
    plot(fftaxis,grp2mP,'-','Color',color12)
    errorbar(fftaxis,grp2mP,grp2semP,'Color',color12,'LineStyle','none','CapSize',3);
    title(['Layer ' params.layers{iLay} ' ' type])
    xlim([0 100])
    xticks(0:10:100)
    ax = gca;
    % ax.XScale = 'log';
    ax.YScale = 'log';
    ylim([0.01 1000])
    legend({[params.groups{1} ' resting'] '' [params.groups{2} ' resting']...
        '' [params.groups{1} ' ' Comparison] '' [params.groups{2} ' ' Comparison]})

    nexttile 
    semilogy(fftaxis,ratioPSm1,'-b')
    hold on 
    semilogy(fftaxis,ratioPSm2,'-r')
    title(['Layer ' params.layers{iLay} ' ' Comparison ' / Resting'])
    xlim([0 100])
    xticks(0:10:100)
    line('XData', [0 100], 'YData', [1 1])
    % ax = gca;
    % ax.XScale = 'log';
    ylim([0.1 100])
    legend({params.groups{1} params.groups{2}})

    % for stats... 
    % we want difference between pupcall ratio & spont ratio per group. We want
    % difference between groups at pupcall ratio. We want difference
    % between groups at raw spont.

    % that gives us: baseline difference and ratiod difference listening to pups 

    % sum data from freq bins to make bar graph 
    % first set bin ranges based on field
    gammahigh_range = fftaxis(fftaxis < 101); % cut off over 100
    gammahigh_range = gammahigh_range >= 60; % get indices for over 60
    gammalow_range  = fftaxis(fftaxis < 61);
    gammalow_range  = gammalow_range >= 30; 
    beta_range      = fftaxis(fftaxis < 31); 
    beta_range      = beta_range >= 12;
    alpha_range     = fftaxis(fftaxis < 13); 
    alpha_range     = alpha_range > 7; 
    theta_range     = fftaxis(fftaxis < 8); 
    theta_range     = theta_range > 3; 
    delta_range     = fftaxis(fftaxis < 4); 
    delta_range     = delta_range >= 0; 

    % baseline difference: difference between groups during rest
    GHS1 = mean(grp1S(gammahigh_range,:),1);
    GHS2 = mean(grp2S(gammahigh_range,:),1);
    % [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool(ages,)

    [ghss_P,~,~,ghssmean1,ghssstd1,ghssmean2,ghssstd2] = ...
        myttest2(GHS1',GHS2',1,'both');

    GLS1 = mean(grp1S(gammalow_range,:),1);
    GLS2 = mean(grp2S(gammalow_range,:),1);
    [glss_P,~,~,glssmean1,glssstd1,glssmean2,glssstd2] = ...
        myttest2(GLS1',GLS2',1,'both');

    BS1 = mean(grp1S(beta_range,:),1);
    BS2 = mean(grp2S(beta_range,:),1);
    [bss_P,~,~,bssmean1,bssstd1,bssmean2,bssstd2] = ...
        myttest2(BS1',BS2',1,'both');

    AS1 = mean(grp1S(alpha_range,:),1);
    AS2 = mean(grp2S(alpha_range,:),1);
    [ass_P,~,~,assmean1,assstd1,assmean2,assstd2] = ...
        myttest2(AS1',AS2',1,'both');

    TS1 = mean(grp1S(theta_range,:),1);
    TS2 = mean(grp2S(theta_range,:),1);
    [tss_P,~,~,tssmean1,tssstd1,tssmean2,tssstd2] = ...
        myttest2(TS1',TS2',1,'both');

    DS1 = mean(grp1S(delta_range,:),1);
    DS2 = mean(grp2S(delta_range,:),1);
    [dss_P,dss_DF,~,dssmean1,dssstd1,dssmean2,dssstd2] = ...
        myttest2(DS1',DS2',1,'both');

    % fill the data table
    g1size = length(GHS1); g2size = length(GHS2);
    % group 1
    FFTData.Group(count:count+g1size-1)     = repmat(params.groups{1},[g1size,1]);
    FFTData.Condition(count:count+g1size-1) = repmat("Spontaneous",[g1size,1]);
    FFTData.Layer(count:count+g1size-1)     = repmat(params.layers{iLay},[g1size,1]);
    FFTData.trial(count:count+g1size-1)     = repmat((1:60)',[g1size/60,1]);
    FFTData.delta(count:count+g1size-1)     = DS1';
    FFTData.theta(count:count+g1size-1)     = TS1';
    FFTData.alpha(count:count+g1size-1)     = AS1';
    FFTData.beta(count:count+g1size-1)      = BS1';
    FFTData.lowgam(count:count+g1size-1)    = GLS1';
    FFTData.highgam(count:count+g1size-1)   = GHS1';
    sublist = "0";
    for iSub = 1:(g1size/60)
        sublist = vertcat(sublist, repmat(['VM' num2str(iSub)],[60,1]));
    end
    FFTData.Subject(count:count+g1size-1)   = sublist(2:end);
    count = count+g1size;
    % group 2
    FFTData.Group(count:count+g2size-1)     = repmat(params.groups{2},[g2size,1]);
    FFTData.Condition(count:count+g2size-1) = repmat("Spontaneous",[g2size,1]);
    FFTData.Layer(count:count+g2size-1)     = repmat(params.layers{iLay},[g2size,1]);
    FFTData.trial(count:count+g2size-1)     = repmat((1:60)',[g2size/60,1]);
    FFTData.delta(count:count+g2size-1)     = DS2';
    FFTData.theta(count:count+g2size-1)     = TS2';
    FFTData.alpha(count:count+g2size-1)     = AS2';
    FFTData.beta(count:count+g2size-1)      = BS2';
    FFTData.lowgam(count:count+g2size-1)    = GLS2';
    FFTData.highgam(count:count+g2size-1)   = GHS2';
    sublist = "0";
    for iSub = 1:(g2size/60)
        sublist = vertcat(sublist, repmat(['PM' num2str(iSub)],[60,1]));
    end
    FFTData.Subject(count:count+g2size-1)   = sublist(2:end);
    count = count+g2size;
        
    S_Means = [dssmean1 dssmean2 tssmean1 tssmean2 assmean1 assmean2 ...
        bssmean1 bssmean2 glssmean1 glssmean2 ghssmean1 ghssmean2];
    S_sems  = [dssstd1/sqrt(dss_DF+2) dssstd2/sqrt(dss_DF+2) tssstd1/sqrt(dss_DF+2)...
        tssstd2/sqrt(dss_DF+2) assstd1/sqrt(dss_DF+2) assstd2/sqrt(dss_DF+2) ...
        bssstd1/sqrt(dss_DF+2) bssstd2/sqrt(dss_DF+2) glssstd1/sqrt(dss_DF+2) ...
        glssstd2/sqrt(dss_DF+2) ghssstd1/sqrt(dss_DF+2) ghssstd2/sqrt(dss_DF+2)];
    
    % bar plot of binned frequency means and std error bars
    nexttile 
    bar(1:length(S_Means),S_Means)
    hold on
    errorbar(1:length(S_Means),S_Means,S_sems,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(dss_P)} {'T'} {num2str(tss_P)} {'A'} {num2str(ass_P)} ...
        {'B'} {num2str(bss_P)} {'GL'} {num2str(glss_P)} {'GH'} {num2str(ghss_P)}])
    title(['L ' params.layers{iLay} ' ' params.groups{2} ' vs ' params.groups{1} ' Resting'])
    
    % difference for each group between pupcall / spont and spont / spont
    GHS1 = mean(ratioSS1(gammahigh_range,:),1);
    GHS2 = mean(ratioSS2(gammahigh_range,:),1);
    GHP1 = mean(ratioPS1(gammahigh_range,:),1);
    GHP2 = mean(ratioPS2(gammahigh_range,:),1);
    % difference group 1
    [ghps1_P,~,~,ghps1meanp,ghps1stdp,ghps1means,ghps1stds] = ...
        myttest2(GHP1',GHS1',1,'both');
    % difference group 2
    [ghps2_P,~,~,ghps2meanp,ghps2stdp,ghps2means,ghps2stds] = ...
        myttest2(GHP2',GHS2',1,'both');
    
    GLS1 = mean(ratioSS1(gammalow_range,:),1);
    GLS2 = mean(ratioSS2(gammalow_range,:),1);
    GLP1 = mean(ratioPS1(gammalow_range,:),1);
    GLP2 = mean(ratioPS2(gammalow_range,:),1);
    % difference group 1
    [glps1_P,~,~,glps1meanp,glps1stdp,glps1means,glps1stds] = ...
        myttest2(GLP1',GLS1',1,'both');
    % difference group 2
    [glps2_P,~,~,glps2meanp,glps2stdp,glps2means,glps2stds] = ...
        myttest2(GLP2',GLS2',1,'both');

    BS1 = mean(ratioSS1(beta_range,:),1);
    BS2 = mean(ratioSS2(beta_range,:),1);
    BP1 = mean(ratioPS1(beta_range,:),1);
    BP2 = mean(ratioPS2(beta_range,:),1);
    % difference group 1
    [bps1_P,~,~,bps1meanp,bps1stdp,bps1means,bps1stds] = ...
        myttest2(BP1',BS1',1,'both');
    % difference group 2
    [bps2_P,~,~,bps2meanp,bps2stdp,bps2means,bps2stds] = ...
        myttest2(BP2',BS2',1,'both');

    AS1 = mean(ratioSS1(alpha_range,:),1);
    AS2 = mean(ratioSS2(alpha_range,:),1);
    AP1 = mean(ratioPS1(alpha_range,:),1);
    AP2 = mean(ratioPS2(alpha_range,:),1);
    % difference group 1
    [aps1_P,~,~,aps1meanp,aps1stdp,aps1means,aps1stds] = ...
        myttest2(AP1',AS1',1,'both');
    % difference group 2
    [aps2_P,~,~,aps2meanp,aps2stdp,aps2means,aps2stds] = ...
        myttest2(AP2',AS2',1,'both');

    TS1 = mean(ratioSS1(theta_range,:),1);
    TS2 = mean(ratioSS2(theta_range,:),1);
    TP1 = mean(ratioPS1(theta_range,:),1);
    TP2 = mean(ratioPS2(theta_range,:),1);
    % difference group 1
    [tps1_P,~,~,tps1meanp,tps1stdp,tps1means,tps1stds] = ...
        myttest2(TP1',TS1',1,'both');
    % difference group 2
    [tps2_P,~,~,tps2meanp,tps2stdp,tps2means,tps2stds] = ...
        myttest2(TP2',TS2',1,'both');

    DS1 = mean(ratioSS1(delta_range,:),1);
    DS2 = mean(ratioSS2(delta_range,:),1);
    DP1 = mean(ratioPS1(delta_range,:),1);
    DP2 = mean(ratioPS2(delta_range,:),1);
    % difference group 1
    [dps1_P,dps1_DF,~,dps1meanp,dps1stdp,dps1means,dps1stds] = ...
        myttest2(DP1',DS1',1,'both');
    % difference group 2
    [dps2_P,dps2_DF,~,dps2meanp,dps2stdp,dps2means,dps2stds] = ...
        myttest2(DP2',DS2',1,'both');
        
    Means1 = [dps1means dps1meanp tps1means tps1meanp aps1means aps1meanp ...
        bps1means bps1meanp glps1means glps1meanp ghps1means ghps1meanp];
    sems1  = [dps1stds/sqrt(dps1_DF+2) dps1stdp/sqrt(dps1_DF+2) tps1stds/sqrt(dps1_DF+2) ...
        tps1stdp/sqrt(dps1_DF+2) aps1stds/sqrt(dps1_DF+2) aps1stdp/sqrt(dps1_DF+2) ...
        bps1stds/sqrt(dps1_DF+2) bps1stdp/sqrt(dps1_DF+2) glps1stds/sqrt(dps1_DF+2) ...
        glps1stdp/sqrt(dps1_DF+2) ghps1stds/sqrt(dps1_DF+2) ghps1stdp/sqrt(dps1_DF+2)];

    Means2 = [dps2means dps2meanp tps2means tps2meanp aps2means aps2meanp ...
        bps2means bps2meanp glps2means glps2meanp ghps2means ghps2meanp];
    sems2  = [dps2stds/sqrt(dps2_DF+2) dps2stdp/sqrt(dps2_DF+2) tps2stds/sqrt(dps2_DF+2) ...
        tps2stdp/sqrt(dps2_DF+2) aps2stds/sqrt(dps2_DF+2) aps2stdp/sqrt(dps2_DF+2) ...
        bps2stds/sqrt(dps2_DF+2) bps2stdp/sqrt(dps2_DF+2) glps2stds/sqrt(dps2_DF+2) ...
        glps2stdp/sqrt(dps2_DF+2) ghps2stds/sqrt(dps2_DF+2) ghps2stdp/sqrt(dps2_DF+2)];
    
    % bar plot of binned frequency means and std error bars
    nexttile 
    bar(1:length(Means1),Means1)
    hold on
    errorbar(1:length(Means1),Means1,sems1,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(dps1_P)} {'T'} {num2str(tps1_P)} {'A'} {num2str(aps1_P)} ...
        {'B'} {num2str(bps1_P)} {'GL'} {num2str(glps1_P)} {'GH'} {num2str(ghps1_P)}])
    title(['L ' params.layers{iLay} ' ' params.groups{1} ' ' Comparison '/ Resting'])

    nexttile 
    bar(1:length(Means2),Means2)
    hold on
    errorbar(1:length(Means2),Means2,sems2,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(dps2_P)} {'T'} {num2str(tps2_P)} {'A'} {num2str(aps2_P)} ...
        {'B'} {num2str(bps2_P)} {'GL'} {num2str(glps2_P)} {'GH'} {num2str(ghps2_P)}])
    title(['L ' params.layers{iLay} ' ' params.groups{2} ' ' Comparison '/ Resting'])
    
    % Finally, difference between groups at pupcall / spont
    % fill the data table
    g1size = length(GHP1); g2size = length(GHP2);
    % group 1
    FFTData.Group(count:count+g1size-1)     = repmat(params.groups{1},[g1size,1]);
    FFTData.Condition(count:count+g1size-1) = repmat(Comparison,[g1size,1]);
    FFTData.Layer(count:count+g1size-1)     = repmat(params.layers{iLay},[g1size,1]);
    if sum(contains(params.groups,'VMP'))==1
        FFTData.trial(count:count+g1size-1) = vertcat((1:20)', repmat((1:50)',[(g1size-20)/50,1])); % altered for VMP02 having 20
    else
        FFTData.trial(count:count+g1size-1) = repmat((1:trialsize)',[(g1size)/trialsize,1]);
    end
    FFTData.delta(count:count+g1size-1)     = DP1';
    FFTData.theta(count:count+g1size-1)     = TP1';
    FFTData.alpha(count:count+g1size-1)     = AP1';
    FFTData.beta(count:count+g1size-1)      = BP1';
    FFTData.lowgam(count:count+g1size-1)    = GLP1';
    FFTData.highgam(count:count+g1size-1)   = GHP1';
    sublist = "0";
    if contains(params.groups{1},'VMP')
        sublist = vertcat(sublist, repmat('VM1',[trialsize,1]));
        for iSub = 2:6
            sublist = vertcat(sublist, repmat(['VM' num2str(iSub)],[50,1]));
        end
    else
        for iSub = 1:(g1size/trialsize)
            sublist = vertcat(sublist, repmat(['VM' num2str(iSub)],[trialsize,1]));
        end
    end
    FFTData.Subject(count:count+g1size-1)   = sublist(2:end);
    count = count+g1size;
    % group 2
    FFTData.Group(count:count+g2size-1)     = repmat(params.groups{2},[g2size,1]);
    FFTData.Condition(count:count+g2size-1) = repmat(Comparison,[g2size,1]);
    FFTData.Layer(count:count+g2size-1)     = repmat(params.layers{iLay},[g2size,1]);
    if sum(contains(params.groups,'PMP'))==1
        vertcat((1:50)',(1:50)',(1:50)',(1:24)',(1:50)',(1:50)',(1:50)',(1:50)'); 
    else
        try % such bad coding - accounting for 1 missed trial in the click trains
            FFTData.trial(count:count+g2size-1)     = repmat((1:trialsize)',[(g2size)/trialsize,1]); 
        catch
            FFTData.trial(count:count+g2size-1)     = vertcat((1:49)', repmat((1:50)',[(g2size-49)/50,1]));
        end
    end
    FFTData.delta(count:count+g2size-1)     = DP2';
    FFTData.theta(count:count+g2size-1)     = TP2';
    FFTData.alpha(count:count+g2size-1)     = AP2';
    FFTData.beta(count:count+g2size-1)      = BP2';
    FFTData.lowgam(count:count+g2size-1)    = GLP2';
    FFTData.highgam(count:count+g2size-1)   = GHP2';
    sublist = "0";
    if contains(params.groups{2},'PMP')
        for iSub = 1:3
            sublist = vertcat(sublist, repmat(['PM' num2str(iSub)],[50,1]));
        end
        sublist = vertcat(sublist, repmat('PM4',[24,1]));
        for iSub = 5:8
            sublist = vertcat(sublist, repmat(['PM' num2str(iSub)],[50,1]));
        end
    else
        for iSub = 1:(g2size/trialsize)
            sublist = vertcat(sublist, repmat(['PM' num2str(iSub)],[trialsize,1]));
        end
    end
    try
        FFTData.Subject(count:count+g2size-1)   = sublist(2:end);
    catch
        sublist = vertcat(sublist, repmat(['PM' '10'],[trialsize-1,1]));
        FFTData.Subject(count:count+g2size-1)   = sublist(2:end);
    end
    count = count+g2size;

    [dps_P,dps_DF,~,dpsmean1,dpsstd1,dpsmean2,dpsstd2] = ...
        myttest2(DP1',DP2',1,'both');
    [tps_P,~,~,tpsmean1,tpsstd1,tpsmean2,tpsstd2] = ...
        myttest2(TP1',TP2',1,'both');
    [aps_P,~,~,apsmean1,apsstd1,apsmean2,apsstd2] = ...
        myttest2(AP1',AP2',1,'both');
    [bps_P,~,~,bpsmean1,bpsstd1,bpsmean2,bpsstd2] = ...
        myttest2(BP1',BP2',1,'both');
    [glps_P,~,~,glpsmean1,glpsstd1,glpsmean2,glpsstd2] = ...
        myttest2(GLP1',GLP2',1,'both');
    [ghps_P,~,~,ghpsmean1,ghpsstd1,ghpsmean2,ghpsstd2] = ...
        myttest2(GHP1',GHP2',1,'both');

    PS_Means = [dpsmean1 dpsmean2 tpsmean1 tpsmean2 apsmean1 apsmean2 ...
        bpsmean1 bpsmean2 glpsmean1 glpsmean2 ghpsmean1 ghpsmean2];
    PS_sems  = [dpsstd1/sqrt(dps_DF+2) dpsstd2/sqrt(dps_DF+2) tpsstd1/sqrt(dps_DF+2) ...
        tpsstd2/sqrt(dps_DF+2) apsstd1/sqrt(dps_DF+2) apsstd2/sqrt(dps_DF+2) ...
        bpsstd1/sqrt(dps_DF+2) bpsstd2/sqrt(dps_DF+2) glpsstd1/sqrt(dps_DF+2) ...
        glpsstd2/sqrt(dps_DF+2) ghpsstd1/sqrt(dps_DF+2) ghpsstd2/sqrt(dps_DF+2)];
    
    % bar plot of binned frequency means and std error bars
    nexttile 
    bar(1:length(PS_Means),PS_Means)
    hold on
    errorbar(1:length(PS_Means),PS_Means,PS_sems,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(dps_P)} {'T'} {num2str(tps_P)} {'A'} {num2str(aps_P)} ...
        {'B'} {num2str(bps_P)} {'GL'} {num2str(glps_P)} {'GH'} {num2str(ghps_P)}])
    title(['L ' params.layers{iLay} ' ' params.groups{1} ' vs ' params.groups{2} ' ' Comparison '/Resting'])
     
    savename = [params.groups{1} 'v' params.groups{2} '_' params.layers{iLay} '_' type '_' Comparison '_FFT'];
    savefig(gcf,savename)
    close

end

% save table 

if exist([outfolder '\FFT'],'dir')
    cd([outfolder '\FFT']);
else
    mkdir([outfolder '\FFT']), cd([outfolder '\FFT']);
end

toDelete = FFTData.trial == 0;
FFTData(toDelete,:) = [];
writetable(FFTData,[params.groups{1} 'v' params.groups{2} '_' type '_' Comparison  '_FFTData.csv'])

cd(homedir)
addpath(genpath(homedir))