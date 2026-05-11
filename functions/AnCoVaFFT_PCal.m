function AnCoVaFFT_PCal(homedir,params,type,Comparison)

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
    % get group names/ages for ANCOVA
    grp1NameS = layTabS.animal(matches(layTabS.group,params.groups{1}),:);
    grp2NameS = layTabS.animal(matches(layTabS.group,params.groups{2}),:);
    grp1AgeS  = genAgeList(grp1NameS,size(grp1S{1},2));
    grp2AgeS  = genAgeList(grp2NameS,size(grp2S{1},2));

    grp1NameP = layTabP.animal(matches(layTabP.group,params.groups{1}),:);
    grp2NameP = layTabP.animal(matches(layTabP.group,params.groups{2}),:);
    % trials not consistent :') 
    numtrials1 = NaN(1,length(grp1NameP));
    for iSub = 1:length(grp1NameP)
        numtrials1(iSub) = size(grp1P{iSub},2);
    end
    grp1AgeP  = genAgeList(grp1NameP,numtrials1);
    numtrials2 = NaN(1,length(grp2NameP));
    for iSub = 1:length(grp2NameP)
        numtrials2(iSub) = size(grp2P{iSub},2);
    end
    grp2AgeP  = genAgeList(grp2NameP,numtrials2);

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

    groupS = [ones(1,length(grp1AgeS)) ones(1,length(grp2AgeS))*2];
    groupP = [ones(1,length(grp1AgeP)) ones(1,length(grp2AgeP))*2];

    % baseline difference: difference between groups during rest
    GHS1 = mean(grp1S(gammahigh_range,:),1);
    GHS2 = mean(grp2S(gammahigh_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[GHS1 GHS2],groupS);
    [ghss_P,ghss_DF,ghss_Cohd,ghssmean1,ghssstd1,ghssmean2,ghssstd2] = ...
        myttest2(GHS1',GHS2',1,'both');

    GLS1 = mean(grp1S(gammalow_range,:),1);
    GLS2 = mean(grp2S(gammalow_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[GLS1 GLS2],groupS);
    [glss_P,glss_DF,glss_Cohd,glssmean1,glssstd1,glssmean2,glssstd2] = ...
        myttest2(GLS1',GLS2',1,'both');

    BS1 = mean(grp1S(beta_range,:),1);
    BS2 = mean(grp2S(beta_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[BS1 BS2],groupS);
    [bss_P,bss_DF,bss_Cohd,bssmean1,bssstd1,bssmean2,bssstd2] = ...
        myttest2(BS1',BS2',1,'both');

    AS1 = mean(grp1S(alpha_range,:),1);
    AS2 = mean(grp2S(alpha_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[AS1 AS2],groupS);
    [ass_P,ass_DF,ass_Cohd,assmean1,assstd1,assmean2,assstd2] = ...
        myttest2(AS1',AS2',1,'both');

    TS1 = mean(grp1S(theta_range,:),1);
    TS2 = mean(grp2S(theta_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[TS1 TS2],groupS);
    [tss_P,tss_DF,tss_Cohd,tssmean1,tssstd1,tssmean2,tssstd2] = ...
        myttest2(TS1',TS2',1,'both');

    DS1 = mean(grp1S(delta_range,:),1);
    DS2 = mean(grp2S(delta_range,:),1);

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeS grp2AgeS],[DS1 DS2],groupS);
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
    
    % difference for each group between pupcall / spont and spont / spont
    GHP1 = mean(ratioPS1(gammahigh_range,:),1);
    GHP2 = mean(ratioPS2(gammahigh_range,:),1);
    
    GLP1 = mean(ratioPS1(gammalow_range,:),1);
    GLP2 = mean(ratioPS2(gammalow_range,:),1);

    BP1 = mean(ratioPS1(beta_range,:),1);
    BP2 = mean(ratioPS2(beta_range,:),1);

    AP1 = mean(ratioPS1(alpha_range,:),1);
    AP2 = mean(ratioPS2(alpha_range,:),1);

    TP1 = mean(ratioPS1(theta_range,:),1);
    TP2 = mean(ratioPS2(theta_range,:),1);

    DP1 = mean(ratioPS1(delta_range,:),1);
    DP2 = mean(ratioPS2(delta_range,:),1);   

    % Finally, difference between groups at pupcall / spont
    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[DP1 DP2],groupP);
    [dps_P,dps_DF,dps_Cohd,dpsmean1,dpsstd1,dpsmean2,dpsstd2] = ...
        myttest2(DP1',DP2',1,'both');

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[TP1 TP2],groupP);
    [tps_P,tps_DF,tps_Cohd,tpsmean1,tpsstd1,tpsmean2,tpsstd2] = ...
        myttest2(TP1',TP2',1,'both');

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[AP1 AP2],groupP);
    [aps_P,aps_DF,aps_Cohd,apsmean1,apsstd1,apsmean2,apsstd2] = ...
        myttest2(AP1',AP2',1,'both');

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[BP1 BP2],groupP);
    [bps_P,bps_DF,bps_Cohd,bpsmean1,bpsstd1,bpsmean2,bpsstd2] = ...
        myttest2(BP1',BP2',1,'both');

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[GLP1 GLP2],groupP);
    [glps_P,glps_DF,glps_Cohd,glpsmean1,glpsstd1,glpsmean2,glpsstd2] = ...
        myttest2(GLP1',GLP2',1,'both');

    [gh_h,gh_AN,gh_CO,gh_Stats] = aoctool([grp1AgeP grp2AgeP],[GHP1 GHP2],groupP);
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
end

cd(homedir)