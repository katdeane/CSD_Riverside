function plotFFT_PCal(homedir,params,type,Comparison)

if ~exist('type','var')
    type = 'AB'; % absolute or RE relative
end
if ~exist('Comparison','var')
    Comparison = 'Pupcall'; % or 'ClickTrain
end

cd(homedir); cd output;
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

elseif matches(Comparison,'ClickTrain')
    % Load in ClickTrain FFT
    loadname2 = [params.groups{1} 'v' params.groups{2} '_ClickTrain_' type '_FFT.mat'];
    color11 = [74/255 183/255 255/255]; % light blue
    color12 = [0/255  77/255  125/255]; % dark dark

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

cd (homedir); cd figures;
if ~exist('FFTfig','dir')
    mkdir('FFTfig');
end
cd FFTfig

% initiate table here - doozy!
FFTStats = table('Size',[length(params.layers) 170],'VariableTypes',{'string','string',...
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7 - 42
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7 - 42
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7 - 42
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7
    'double','double','double','double','double','double','double',... % 7 - 42 - 168
    });

FFTStats.Properties.VariableNames = ["Condition", "Layer", ... % 2
    "pss_delta", "meanss1_delta","stdss1_delta","meanss2_delta",...
    "stdss2_delta","dfss_delta","Cohensdss_delta",... % 7
    "pss_theta", "meanss1_theta","stdss1_theta","meanss2_theta",...
    "stdss2_theta","dfss_theta","Cohensdss_theta",... % 7
    "pss_alpha", "meanss1_alpha","stdss1_alpha","meanss2_alpha",...
    "stdss2_alpha","dfss_alpha","Cohensdss_alpha",... % 7
    "pss_beta", "meanss1_beta","stdss1_beta","meanss2_beta",...
    "stdss2_beta","dfss_beta","Cohensdss_beta",... % 7
    "pss_gammaL", "meanss1_gammaL","stdss1_gammaL","meanss2_gammaL",...
    "stdss2_gammaL","dfss_gammaL","Cohensdss_gammaL",... % 7
    "pss_gammaH", "meanss1_gammaH","stdss1_gammaH","meanss2_gammaH",...
    "stdss2_gammaH","dfss_gammaH","Cohensdss_gammaH",... % 7 - 42
    "pps1_delta", "meanps1s_delta","stdps1s_delta","meanps1p_delta",...
    "stdps1p_delta","dfps1_delta","Cohensdps1_delta",... % 7
    "pps1_theta", "meanps1s_theta","stdps1s_theta","meanps1p_theta",...
    "stdps1p_theta","dfps1_theta","Cohensdps1_theta",... % 7
    "pps1_alpha", "meanps1s_alpha","stdps1s_alpha","meanps1p_alpha",...
    "stdps1p_alpha","dfps1_alpha","Cohensdps1_alpha",... % 7
    "pps1_beta", "meanps1s_beta","stdps1s_beta","meanps1p_beta",...
    "stdps1p_beta","dfps1_beta","Cohensdps1_beta",... % 7
    "pps1_gammaL", "meanps1s_gammaL","stdps1s_gammaL","meanps1p_gammaL",...
    "stdps1p_gammaL","dfps1_gammaL","Cohensdps1_gammaL",... % 7
    "pps1_gammaH", "meanps1s_gammaH","stdps1s_gammaH","meanps1p_gammaH",...
    "stdps1p_gammaH","dfps1_gammaH","Cohensdps1_gammaH",... % 7 - 42
    "pps2_delta", "meanps2s_delta","stdps2s_delta","meanps2p_delta",...
    "stdps2p_delta","dfps2_delta","Cohensdps2_delta",... % 7
    "pps2_theta", "meanps2s_theta","stdps2s_theta","meanps2p_theta",...
    "stdps2p_theta","dfps2_theta","Cohensdps2_theta",... % 7
    "pps2_alpha", "meanps2s_alpha","stdps2s_alpha","meanps2p_alpha",...
    "stdps2p_alpha","dfps2_alpha","Cohensdps2_alpha",... % 7
    "pps2_beta", "meanps2s_beta","stdps2s_beta","meanps2p_beta",...
    "stdps2p_beta","dfps2_beta","Cohensdps2_beta",... % 7
    "pps2_gammaL", "meanps2s_gammaL","stdps2s_gammaL","meanps2p_gammaL",...
    "stdps2p_gammaL","dfps2_gammaL","Cohensdps2_gammaL",... % 7
    "pps2_gammaH", "meanps2s_gammaH","stdps2s_gammaH","meanps2p_gammaH",...
    "stdps2p_gammaH","dfps2_gammaH","Cohensdps2_gammaH",... % 7 - 42
    "pps_delta", "meanps1_delta","stdps1_delta","meanps2_delta",...
    "stdps2_delta","dfps_delta","Cohensdps_delta",... % 7
    "pps_theta", "meanps1_theta","stdps1_theta","meanps2_theta",...
    "stdps2_theta","dfps_theta","Cohensdps_theta",... % 7
    "pps_alpha", "meanps1_alpha","stdps1_alpha","meanps2_alpha",...
    "stdps2_alpha","dfps_alpha","Cohensdps_alpha",... % 7
    "pps_beta", "meanps1_beta","stdps1_beta","meanps2_beta",...
    "stdps2_beta","dfps_beta","Cohensdps_beta",... % 7
    "pps_gammaL", "meanps1_gammaL","stdps1_gammaL","meanps2_gammaL",...
    "stdps2_gammaL","dfps_gammaL","Cohensdps_gammaL",... % 7
    "pps_gammaH", "meanps1_gammaH","stdps1_gammaH","meanps2_gammaH",...
    "stdps2_gammaH","dfps_gammaH","Cohensdps_gammaH",... % 7 - 42 - 168
    ];

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
    % stack the trials
    grp1S = horzcat(grp1S{:}); grp2S = horzcat(grp2S{:});
    grp1P = horzcat(grp1P{:}); grp2P = horzcat(grp2P{:});

    if matches(Comparison,'Pupcall')
        % Pupcall data needs to be gaussian filtered because it's too many
        % sampling points (Clicks don't need to be)
        grp1P = imgaussfilt(grp1P,10);
        grp2P = imgaussfilt(grp2P,10);
    end
    % now it needs to be resampled so we can use Spont data to ratio
    grp1P = downsample(grp1P,10);
    grp1P = resample(grp1P,LS,size(grp1P,1));
    grp2P = downsample(grp2P,10);
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
    ax = gca;
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
    [ghss_P,ghss_DF,ghss_Cohd,ghssmean1,ghssstd1,ghssmean2,ghssstd2] = ...
        myttest2(GHS1',GHS2',1,'both');

    GLS1 = mean(grp1S(gammalow_range,:),1);
    GLS2 = mean(grp2S(gammalow_range,:),1);
    [glss_P,glss_DF,glss_Cohd,glssmean1,glssstd1,glssmean2,glssstd2] = ...
        myttest2(GLS1',GLS2',1,'both');

    BS1 = mean(grp1S(beta_range,:),1);
    BS2 = mean(grp2S(beta_range,:),1);
    [bss_P,bss_DF,bss_Cohd,bssmean1,bssstd1,bssmean2,bssstd2] = ...
        myttest2(BS1',BS2',1,'both');

    AS1 = mean(grp1S(alpha_range,:),1);
    AS2 = mean(grp2S(alpha_range,:),1);
    [ass_P,ass_DF,ass_Cohd,assmean1,assstd1,assmean2,assstd2] = ...
        myttest2(AS1',AS2',1,'both');

    TS1 = mean(grp1S(theta_range,:),1);
    TS2 = mean(grp2S(theta_range,:),1);
    [tss_P,tss_DF,tss_Cohd,tssmean1,tssstd1,tssmean2,tssstd2] = ...
        myttest2(TS1',TS2',1,'both');

    DS1 = mean(grp1S(delta_range,:),1);
    DS2 = mean(grp2S(delta_range,:),1);
    [dss_P,dss_DF,dss_Cohd,dssmean1,dssstd1,dssmean2,dssstd2] = ...
        myttest2(DS1',DS2',1,'both');
        
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
    
    % fill the table
    FFTStats.Layer(iLay)     = params.layers{iLay};
    % delta
    FFTStats.pss_delta(iLay) = dss_P; FFTStats.Cohensdss_delta(iLay) = dss_Cohd;
    FFTStats.meanss1_delta(iLay) = dssmean1; FFTStats.meanss2_delta(iLay) = dssmean2;
    FFTStats.stdss1_delta(iLay) = dssstd1; FFTStats.stdss2_delta(iLay) = dssstd2; 
    FFTStats.dfss_delta(iLay) = dss_DF;
    % theta
    FFTStats.pss_theta(iLay) = tss_P; FFTStats.Cohensdss_theta(iLay) = tss_Cohd;
    FFTStats.meanss1_theta(iLay) = tssmean1; FFTStats.meanss2_theta(iLay) = tssmean2;
    FFTStats.stdss1_theta(iLay) = tssstd1; FFTStats.stdss2_theta(iLay) = tssstd2; 
    FFTStats.dfss_theta(iLay) = tss_DF;
    % alpha
    FFTStats.pss_alpha(iLay) = ass_P; FFTStats.Cohensdss_alpha(iLay) = ass_Cohd;
    FFTStats.meanss1_alpha(iLay) = assmean1; FFTStats.meanss2_alpha(iLay) = assmean2;
    FFTStats.stdss1_alpha(iLay) = assstd1; FFTStats.stdss2_alpha(iLay) = assstd2; 
    FFTStats.dfss_alpha(iLay) = ass_DF;
    % beta
    FFTStats.pss_beta(iLay) = bss_P; FFTStats.Cohensdss_beta(iLay) = bss_Cohd;
    FFTStats.meanss1_beta(iLay) = bssmean1; FFTStats.meanss2_beta(iLay) = bssmean2;
    FFTStats.stdss1_beta(iLay) = bssstd1; FFTStats.stdss2_beta(iLay) = bssstd2; 
    FFTStats.dfss_beta(iLay) = bss_DF;
    % gamma low
    FFTStats.pss_gammaL(iLay) = glss_P; FFTStats.Cohensdss_gammaL(iLay) = glss_Cohd;
    FFTStats.meanss1_gammaL(iLay) = glssmean1; FFTStats.meanss2_gammaL(iLay) = glssmean2;
    FFTStats.stdss1_gammaL(iLay) = glssstd1; FFTStats.stdss2_gammaL(iLay) = glssstd2; 
    FFTStats.dfss_gammaL(iLay) = glss_DF;
    % gamma high
    FFTStats.pss_gammaH(iLay) = ghss_P; FFTStats.Cohensdss_gammaH(iLay) = ghss_Cohd;
    FFTStats.meanss1_gammaH(iLay) = ghssmean1; FFTStats.meanss2_gammaH(iLay) = ghssmean2;
    FFTStats.stdss1_gammaH(iLay) = ghssstd1; FFTStats.stdss2_gammaH(iLay) = ghssstd2; 
    FFTStats.dfss_gammaH(iLay) = ghss_DF;

    % difference for each group between pupcall / spont and spont / spont
    GHS1 = mean(ratioSS1(gammahigh_range,:),1);
    GHS2 = mean(ratioSS2(gammahigh_range,:),1);
    GHP1 = mean(ratioPS1(gammahigh_range,:),1);
    GHP2 = mean(ratioPS2(gammahigh_range,:),1);
    % difference group 1
    [ghps1_P,ghps1_DF,ghps1_Cohd,ghps1meanp,ghps1stdp,ghps1means,ghps1stds] = ...
        myttest2(GHP1',GHS1',1,'both');
    % difference group 2
    [ghps2_P,ghps2_DF,ghps2_Cohd,ghps2meanp,ghps2stdp,ghps2means,ghps2stds] = ...
        myttest2(GHP2',GHS2',1,'both');
    
    GLS1 = mean(ratioSS1(gammalow_range,:),1);
    GLS2 = mean(ratioSS2(gammalow_range,:),1);
    GLP1 = mean(ratioPS1(gammalow_range,:),1);
    GLP2 = mean(ratioPS2(gammalow_range,:),1);
    % difference group 1
    [glps1_P,glps1_DF,glps1_Cohd,glps1meanp,glps1stdp,glps1means,glps1stds] = ...
        myttest2(GLP1',GLS1',1,'both');
    % difference group 2
    [glps2_P,glps2_DF,glps2_Cohd,glps2meanp,glps2stdp,glps2means,glps2stds] = ...
        myttest2(GLP2',GLS2',1,'both');

    BS1 = mean(ratioSS1(beta_range,:),1);
    BS2 = mean(ratioSS2(beta_range,:),1);
    BP1 = mean(ratioPS1(beta_range,:),1);
    BP2 = mean(ratioPS2(beta_range,:),1);
    % difference group 1
    [bps1_P,bps1_DF,bps1_Cohd,bps1meanp,bps1stdp,bps1means,bps1stds] = ...
        myttest2(BP1',BS1',1,'both');
    % difference group 2
    [bps2_P,bps2_DF,bps2_Cohd,bps2meanp,bps2stdp,bps2means,bps2stds] = ...
        myttest2(BP2',BS2',1,'both');

    AS1 = mean(ratioSS1(alpha_range,:),1);
    AS2 = mean(ratioSS2(alpha_range,:),1);
    AP1 = mean(ratioPS1(alpha_range,:),1);
    AP2 = mean(ratioPS2(alpha_range,:),1);
    % difference group 1
    [aps1_P,aps1_DF,aps1_Cohd,aps1meanp,aps1stdp,aps1means,aps1stds] = ...
        myttest2(AP1',AS1',1,'both');
    % difference group 2
    [aps2_P,aps2_DF,aps2_Cohd,aps2meanp,aps2stdp,aps2means,aps2stds] = ...
        myttest2(AP2',AS2',1,'both');

    TS1 = mean(ratioSS1(theta_range,:),1);
    TS2 = mean(ratioSS2(theta_range,:),1);
    TP1 = mean(ratioPS1(theta_range,:),1);
    TP2 = mean(ratioPS2(theta_range,:),1);
    % difference group 1
    [tps1_P,tps1_DF,tps1_Cohd,tps1meanp,tps1stdp,tps1means,tps1stds] = ...
        myttest2(TP1',TS1',1,'both');
    % difference group 2
    [tps2_P,tps2_DF,tps2_Cohd,tps2meanp,tps2stdp,tps2means,tps2stds] = ...
        myttest2(TP2',TS2',1,'both');

    DS1 = mean(ratioSS1(delta_range,:),1);
    DS2 = mean(ratioSS2(delta_range,:),1);
    DP1 = mean(ratioPS1(delta_range,:),1);
    DP2 = mean(ratioPS2(delta_range,:),1);
    % difference group 1
    [dps1_P,dps1_DF,dps1_Cohd,dps1meanp,dps1stdp,dps1means,dps1stds] = ...
        myttest2(DP1',DS1',1,'both');
    % difference group 2
    [dps2_P,dps2_DF,dps2_Cohd,dps2meanp,dps2stdp,dps2means,dps2stds] = ...
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
    
    % fill the table
    % delta
    FFTStats.pps1_delta(iLay) = dps1_P; FFTStats.Cohensdps1_delta(iLay) = dps1_Cohd;
    FFTStats.meanps1p_delta(iLay) = dps1meanp; FFTStats.meanps1s_delta(iLay) = dps1means;
    FFTStats.stdps1p_delta(iLay) = dps1stdp; FFTStats.stdps1s_delta(iLay) = dps1stds; 
    FFTStats.dfps1_delta(iLay) = dps1_DF;
    % theta
    FFTStats.pps1_theta(iLay) = tps1_P; FFTStats.Cohensdps1_theta(iLay) = tps1_Cohd;
    FFTStats.meanps1p_theta(iLay) = tps1meanp; FFTStats.meanps1s_theta(iLay) = tps1means;
    FFTStats.stdps1p_theta(iLay) = tps1stdp; FFTStats.stdps1s_theta(iLay) = tps1stds; 
    FFTStats.dfps1_theta(iLay) = tps1_DF;
    % alpha
    FFTStats.pps1_alpha(iLay) = aps1_P; FFTStats.Cohensdps1_alpha(iLay) = aps1_Cohd;
    FFTStats.meanps1p_alpha(iLay) = aps1meanp; FFTStats.meanps1s_alpha(iLay) = aps1means;
    FFTStats.stdps1p_alpha(iLay) = aps1stdp; FFTStats.stdps1s_alpha(iLay) = aps1stds; 
    FFTStats.dfps1_alpha(iLay) = aps1_DF;
    % beta
    FFTStats.pps1_beta(iLay) = bps1_P; FFTStats.Cohensdps1_beta(iLay) = bps1_Cohd;
    FFTStats.meanps1p_beta(iLay) = bps1meanp; FFTStats.meanps1s_beta(iLay) = bps1means;
    FFTStats.stdps1p_beta(iLay) = bps1stdp; FFTStats.stdps1s_beta(iLay) = bps1stds; 
    FFTStats.dfps1_beta(iLay) = bps1_DF;
    % gamma low
    FFTStats.pps1_gammaL(iLay) = glps1_P; FFTStats.Cohensdps1_gammaL(iLay) = glps1_Cohd;
    FFTStats.meanps1p_gammaL(iLay) = glps1meanp; FFTStats.meanps1s_gammaL(iLay) = glps1means;
    FFTStats.stdps1p_gammaL(iLay) = glps1stdp; FFTStats.stdps1s_gammaL(iLay) = glps1stds; 
    FFTStats.dfps1_gammaL(iLay) = glps1_DF;
    % gamma high
    FFTStats.pps1_gammaH(iLay) = ghps1_P; FFTStats.Cohensdps1_gammaH(iLay) = ghps1_Cohd;
    FFTStats.meanps1p_gammaH(iLay) = ghps1meanp; FFTStats.meanps1s_gammaH(iLay) = ghps1means;
    FFTStats.stdps1p_gammaH(iLay) = ghps1stdp; FFTStats.stdps1s_gammaH(iLay) = ghps1stds; 
    FFTStats.dfps1_gammaH(iLay) = ghps1_DF;

    % DELTA AGAIN
    FFTStats.pps2_delta(iLay) = dps2_P; FFTStats.Cohensdps2_delta(iLay) = dps2_Cohd;
    FFTStats.meanps2p_delta(iLay) = dps2meanp; FFTStats.meanps2s_delta(iLay) = dps2means;
    FFTStats.stdps2p_delta(iLay) = dps2stdp; FFTStats.stdps2s_delta(iLay) = dps2stds; 
    FFTStats.dfps2_delta(iLay) = dps2_DF;
    % theta
    FFTStats.pps2_theta(iLay) = tps2_P; FFTStats.Cohensdps2_theta(iLay) = tps2_Cohd;
    FFTStats.meanps2p_theta(iLay) = tps2meanp; FFTStats.meanps2s_theta(iLay) = tps2means;
    FFTStats.stdps2p_theta(iLay) = tps2stdp; FFTStats.stdps2s_theta(iLay) = tps2stds; 
    FFTStats.dfps2_theta(iLay) = tps2_DF;
    % alpha
    FFTStats.pps2_alpha(iLay) = aps2_P; FFTStats.Cohensdps2_alpha(iLay) = aps2_Cohd;
    FFTStats.meanps2p_alpha(iLay) = aps2meanp; FFTStats.meanps2s_alpha(iLay) = aps2means;
    FFTStats.stdps2p_alpha(iLay) = aps2stdp; FFTStats.stdps2s_alpha(iLay) = aps2stds; 
    FFTStats.dfps2_alpha(iLay) = aps2_DF;
    % beta
    FFTStats.pps2_beta(iLay) = bps2_P; FFTStats.Cohensdps2_beta(iLay) = bps2_Cohd;
    FFTStats.meanps2p_beta(iLay) = bps2meanp; FFTStats.meanps2s_beta(iLay) = bps2means;
    FFTStats.stdps2p_beta(iLay) = bps2stdp; FFTStats.stdps2s_beta(iLay) = bps2stds; 
    FFTStats.dfps2_beta(iLay) = bps2_DF;
    % gamma low
    FFTStats.pps2_gammaL(iLay) = glps2_P; FFTStats.Cohensdps2_gammaL(iLay) = glps2_Cohd;
    FFTStats.meanps2p_gammaL(iLay) = glps2meanp; FFTStats.meanps2s_gammaL(iLay) = glps2means;
    FFTStats.stdps2p_gammaL(iLay) = glps2stdp; FFTStats.stdps2s_gammaL(iLay) = glps2stds; 
    FFTStats.dfps2_gammaL(iLay) = glps2_DF;
    % gamma high
    FFTStats.pps2_gammaH(iLay) = ghps2_P; FFTStats.Cohensdps2_gammaH(iLay) = ghps2_Cohd;
    FFTStats.meanps2p_gammaH(iLay) = ghps2meanp; FFTStats.meanps2s_gammaH(iLay) = ghps2means;
    FFTStats.stdps2p_gammaH(iLay) = ghps2stdp; FFTStats.stdps2s_gammaH(iLay) = ghps2stds; 
    FFTStats.dfps2_gammaH(iLay) = ghps2_DF;

    % Finally, difference between groups at pupcall / spont
    [dps_P,dps_DF,dps_Cohd,dpsmean1,dpsstd1,dpsmean2,dpsstd2] = ...
        myttest2(DP1',DP2',1,'both');
    [tps_P,tps_DF,tps_Cohd,tpsmean1,tpsstd1,tpsmean2,tpsstd2] = ...
        myttest2(TP1',TP2',1,'both');
    [aps_P,aps_DF,aps_Cohd,apsmean1,apsstd1,apsmean2,apsstd2] = ...
        myttest2(AP1',AP2',1,'both');
    [bps_P,bps_DF,bps_Cohd,bpsmean1,bpsstd1,bpsmean2,bpsstd2] = ...
        myttest2(BP1',BP2',1,'both');
    [glps_P,glps_DF,glps_Cohd,glpsmean1,glpsstd1,glpsmean2,glpsstd2] = ...
        myttest2(GLP1',GLP2',1,'both');
    [ghps_P,ghps_DF,ghps_Cohd,ghpsmean1,ghpsstd1,ghpsmean2,ghpsstd2] = ...
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

    % fill the table
    % delta
    FFTStats.pps_delta(iLay) = dps_P; FFTStats.Cohensdps_delta(iLay) = dps_Cohd;
    FFTStats.meanps1_delta(iLay) = dpsmean1; FFTStats.meanps2_delta(iLay) = dpsmean2;
    FFTStats.stdps1_delta(iLay) = dpsstd1; FFTStats.stdps2_delta(iLay) = dpsstd2; 
    FFTStats.dfps_delta(iLay) = dps_DF;
    % theta
    FFTStats.pps_theta(iLay) = tps_P; FFTStats.Cohensdps_theta(iLay) = tps_Cohd;
    FFTStats.meanps1_theta(iLay) = tpsmean1; FFTStats.meanps2_theta(iLay) = tpsmean2;
    FFTStats.stdps1_theta(iLay) = tpsstd1; FFTStats.stdps2_theta(iLay) = tpsstd2; 
    FFTStats.dfps_theta(iLay) = tps_DF;
    % alpha
    FFTStats.pps_alpha(iLay) = aps_P; FFTStats.Cohensdps_alpha(iLay) = aps_Cohd;
    FFTStats.meanps1_alpha(iLay) = apsmean1; FFTStats.meanps2_alpha(iLay) = apsmean2;
    FFTStats.stdps1_alpha(iLay) = apsstd1; FFTStats.stdps2_alpha(iLay) = apsstd2; 
    FFTStats.dfps_alpha(iLay) = aps_DF;
    % beta
    FFTStats.pps_beta(iLay) = bps_P; FFTStats.Cohensdps_beta(iLay) = bps_Cohd;
    FFTStats.meanps1_beta(iLay) = bpsmean1; FFTStats.meanps2_beta(iLay) = bpsmean2;
    FFTStats.stdps1_beta(iLay) = bpsstd1; FFTStats.stdps2_beta(iLay) = bpsstd2; 
    FFTStats.dfps_beta(iLay) = bps_DF;
    % gamma low
    FFTStats.pps_gammaL(iLay) = glps_P; FFTStats.Cohensdps_gammaL(iLay) = glps_Cohd;
    FFTStats.meanps1_gammaL(iLay) = glpsmean1; FFTStats.meanps2_gammaL(iLay) = glpsmean2;
    FFTStats.stdps1_gammaL(iLay) = glpsstd1; FFTStats.stdps2_gammaL(iLay) = glpsstd2; 
    FFTStats.dfps_gammaL(iLay) = glps_DF;
    % gamma high
    FFTStats.pps_gammaH(iLay) = ghps_P; FFTStats.Cohensdps_gammaH(iLay) = ghps_Cohd;
    FFTStats.meanps1_gammaH(iLay) = ghpsmean1; FFTStats.meanps2_gammaH(iLay) = ghpsmean2;
    FFTStats.stdps1_gammaH(iLay) = ghpsstd1; FFTStats.stdps2_gammaH(iLay) = ghpsstd2; 
    FFTStats.dfps_gammaH(iLay) = ghps_DF;

end

% save table 
writetable(FFTStats,[params.groups{1} 'v' params.groups{2} '_' type '_' Comparison  '_FFTStats.csv'])

cd(homedir)