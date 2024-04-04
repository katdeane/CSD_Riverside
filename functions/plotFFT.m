function plotFFT(homedir,params,Condition)

cd(homedir); cd output; cd FFT
loadname = [params.groups{1} 'v' params.groups{2} '_FFT.mat'];
load(loadname,'fftStruct')
fftTab = struct2table(fftStruct); 
clear fftStruct % kat, just save it as a table in the other script

% for plotting
Fs = 1000; % Sampling frequency
L  = length(fftTab.fft{1}); % Length of signal [ms]

if matches(Condition, 'Pupcall')
    % get rid of the shorter trials subject (VMP02 has 20 trials)
    toDelete = matches(fftTab.animal,'VMP02');
    fftTab(toDelete,:) = [];
end

cd (homedir); cd figures;
if ~exist('FFTfig','dir')
    mkdir('FFTfig');
end
cd FFTfig

FFTfig = tiledlayout('flow');
title(FFTfig,[Condition ' FFT'])
xlabel(FFTfig, 'f (Hz)')
ylabel(FFTfig, 'Power')

% initiate table here
FFTStats = table('Size',[length(params.layers) 51],'VariableTypes',...
    {'string','string','double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double'});

FFTStats.Properties.VariableNames = ["Condition", "Layer", "p_delta",...
    "meanko_delta","stdko_delta","meanwt_delta","stdwt_delta","df_delta",...
    "Cohensd_delta","p_theta", "meanko_theta","stdko_theta","meanwt_theta",...
    "stdwt_theta","df_theta", "Cohensd_theta", "p_alpha","meanko_alpha",...
    "stdko_alpha","meanwt_alpha", "stdwt_alpha","df_alpha","Cohensd_alpha",...
    "p_betaL", "meanko_betaL", "stdko_betaL","meankwt_betaL","stdwt_betaL",...
    "df_betaL","Cohensd_betaL", "p_betaH","meanko_betaH","stdko_betaH",...
    "meanwt_betaH","stdwt_betaH", "df_betaH","Cohensd_betaH", "p_gammaL",...
    "meanko_gammaL","stdko_gammaL", "meanwt_gammaL","stdwt_gammaL",...
    "df_gammaL","Cohensd_gammaL", "p_gammaH", "meanko_gammaH",...
    "stdko_gammaH","meanwt_gammaH","stdwt_gammaH","df_gammaH","Cohensd_gammaH"];

for iLay = 1:length(params.layers)
    
    layTab = fftTab(matches(fftTab.layer,params.layers{iLay}),:);

    % get both groups
    grp1 = layTab.fft(matches(layTab.group,params.groups{1}),:);
    grp2 = layTab.fft(matches(layTab.group,params.groups{2}),:);
    grp1 = vertcat(grp1{:}); grp2 = vertcat(grp2{:});

    grp1m = mean(grp1,1);
    grp2m = mean(grp2,1);

    ratioKOWTm = grp2m ./ grp1m; % ratio mean line for plotting
    ratioKOWT  = grp2 ./ grp1m; % ratio of all KO to mean WT
    ratioWTWT  = grp1 ./ grp1m; % ratio of all WT to mean WT
    
    % gaussian filter for visualization
    grp1g   = imgaussfilt(grp1m,10);
    grp2g   = imgaussfilt(grp2m,10);
    ratioKOWTm = imgaussfilt(ratioKOWTm,10);
    
    fftaxis = (Fs/L)*(0:L-1);

    % plot
    nexttile 
    plot(fftaxis,grp1g,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)

    nexttile 
    plot(fftaxis,grp2g,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2}])
    xlim([0 100])
    xticks(0:10:100)

    nexttile 
    plot(fftaxis,ratioKOWTm,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)
    hold on 
    line('XData', [0 100], 'YData', [1 1])
    hold off

    % sum data from freq bins to make bar graph so simple so clean
    gammahigh_range = fftaxis(fftaxis < 101); % cut off over 100
    gammahigh_range = gammahigh_range > 60; % get indices for over 60
    gammahigh_KOm   = mean(ratioKOWT(:,gammahigh_range),2);
    gammahigh_WTm   = mean(ratioWTWT(:,gammahigh_range),2);
    [~,gh_P,~,gh_S] = ttest2(gammahigh_KOm,gammahigh_WTm,'tail','right');
    [gh_Cohd, ghkomean, ghwtmean, ghkostd, ghwtstd] = igetCohensd(gammahigh_KOm,gammahigh_WTm);

    gammalow_range  = fftaxis(fftaxis < 61); % cut off over 100
    gammalow_range  = gammalow_range > 30; % get indices for over 60
    gammalow_KOm    = mean(ratioKOWT(:,gammalow_range));
    gammalow_WTm    = mean(ratioWTWT(:,gammalow_range));
    [~,gl_P,~,gl_S] = ttest2(gammalow_KOm,gammalow_WTm,'tail','right');
    [gl_Cohd, glkomean, glwtmean, glkostd, glwtstd] = igetCohensd(gammalow_KOm,gammalow_WTm);

    betahigh_range  = fftaxis(fftaxis < 31); % cut off over 100
    betahigh_range  = betahigh_range > 18; % get indices for over 60
    betahigh_KOm    = mean(ratioKOWT(:,betahigh_range));
    betahigh_WTm    = mean(ratioWTWT(:,betahigh_range));
    [~,bh_P,~,bh_S] = ttest2(betahigh_KOm,betahigh_WTm,'tail','right');
    [bh_Cohd, bhkomean, bhwtmean, bhkostd, bhwtstd] = igetCohensd(betahigh_KOm,betahigh_WTm);

    betalow_range   = fftaxis(fftaxis < 19); % cut off over 100
    betalow_range   = betalow_range > 12; % get indices for over 60
    betalow_KOm     = mean(ratioKOWT(:,betalow_range));
    betalow_WTm     = mean(ratioWTWT(:,betalow_range));
    [~,bl_P,~,bl_S] = ttest2(betalow_KOm,betalow_WTm,'tail','right');
    [bl_Cohd, blkomean, blwtmean, blkostd, blwtstd] = igetCohensd(betalow_KOm,betalow_WTm);

    alpha_range     = fftaxis(fftaxis < 13); % cut off over 100
    alpha_range     = alpha_range > 7; % get indices for over 60
    alpha_KOm       = mean(ratioKOWT(:,alpha_range));
    alpha_WTm       = mean(ratioWTWT(:,alpha_range));
    [~,a_P,~,a_S]   = ttest2(alpha_KOm,alpha_WTm,'tail','right');
    [a_Cohd, akomean, awtmean, akostd, awtstd] = igetCohensd(alpha_KOm,alpha_WTm);

    theta_range     = fftaxis(fftaxis < 8); % cut off over 100
    theta_range     = theta_range > 3; % get indices for over 60
    theta_KOm       = mean(ratioKOWT(:,theta_range));
    theta_WTm       = mean(ratioWTWT(:,theta_range));
    [~,t_P,~,t_S]   = ttest2(theta_KOm,theta_WTm,'tail','right');
    [t_Cohd, tkomean, twtmean, tkostd, twtstd] = igetCohensd(theta_KOm,theta_WTm);

    delta_range     = fftaxis(fftaxis < 4); % cut off over 100
    delta_range     = delta_range > 0; % get indices for over 60
    delta_KOm       = mean(ratioKOWT(:,delta_range));
    delta_WTm       = mean(ratioWTWT(:,delta_range));
    [~,d_P,~,d_S]   = ttest2(delta_KOm,delta_WTm,'tail','right');
    [d_Cohd, dkomean, dwtmean, dkostd, dwtstd] = igetCohensd(delta_KOm,delta_WTm);
        
    osci_Means = [dwtmean dkomean twtmean tkomean awtmean akomean blwtmean ...
        blkomean bhwtmean bhkomean glwtmean glkomean ghwtmean ghkomean];
    osci_stds  = [dwtstd dkostd twtstd tkostd awtstd akostd blwtstd blkostd...
        bhwtstd bhkostd glwtstd glkostd ghwtstd ghkostd];
    
    % sanity check
    hold on
    test = zeros(1,length(fftaxis));
    test(1:length(delta_range)) = delta_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(theta_range)) = theta_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(alpha_range)) = alpha_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(betalow_range)) = betalow_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(betahigh_range)) = betahigh_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(gammalow_range)) = gammalow_range;
    plot(fftaxis,test)
    test = zeros(1,length(fftaxis));
    test(1:length(gammahigh_range)) = gammahigh_range;
    plot(fftaxis,test)

    % bar plot of binned frequency means and std error bars
    nexttile 
    bar(1:length(osci_Means),osci_Means)
    hold on
    errorbar(1:length(osci_Means),osci_Means,osci_stds,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(d_P)} {'T'} {num2str(t_P)} {'A'} {num2str(a_P)} {'BL'} {num2str(bl_P)}...
        {'BH'} {num2str(bh_P)} {'GL'} {num2str(gl_P)} {'GH'} {num2str(gh_P)}])
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1} ' means'])

    % fill the table
    FFTStats.Condition(iLay) = Condition; 
    FFTStats.Layer(iLay)     = params.layers{iLay};
    % theta
    FFTStats.p_delta(iLay) = d_P; FFTStats.Cohensd_delta(iLay) = d_Cohd;
    FFTStats.meanko_delta(iLay) = dkomean; FFTStats.meanwt_delta(iLay) = dwtmean;
    FFTStats.stdko_delta(iLay) = dkostd; FFTStats.stdwt_delta(iLay) = dwtstd; 
    FFTStats.df_delta(iLay) = d_S.df;
    % theta
    FFTStats.p_theta(iLay) = t_P; FFTStats.Cohensd_theta(iLay) = t_Cohd;
    FFTStats.meanko_theta(iLay) = tkomean; FFTStats.meanwt_theta(iLay) = twtmean;
    FFTStats.stdko_theta(iLay) = tkostd; FFTStats.stdwt_theta(iLay) = twtstd; 
    FFTStats.df_theta(iLay) = t_S.df;
    % alpha
    FFTStats.p_alpha(iLay) = a_P; FFTStats.Cohensd_alpha(iLay) = a_Cohd;
    FFTStats.meanko_alpha(iLay) = akomean; FFTStats.meanwt_alpha(iLay) = awtmean;
    FFTStats.stdko_alpha(iLay) = akostd; FFTStats.stdwt_alpha(iLay) = awtstd; 
    FFTStats.df_alpha(iLay) = a_S.df;
    % beta low
    FFTStats.p_betaL(iLay) = bl_P; FFTStats.Cohensd_betaL(iLay) = bl_Cohd;
    FFTStats.meanko_betaL(iLay) = blkomean; FFTStats.meanwt_betaL(iLay) = blwtmean;
    FFTStats.stdko_betaL(iLay) = blkostd; FFTStats.stdwt_betaL(iLay) = blwtstd; 
    FFTStats.df_betaL(iLay) = bl_S.df;
    % beta high
    FFTStats.p_betaH(iLay) = bh_P; FFTStats.Cohensd_betaH(iLay) = bh_Cohd;
    FFTStats.meanko_betaH(iLay) = bhkomean; FFTStats.meanwt_betaH(iLay) = bhwtmean;
    FFTStats.stdko_betaH(iLay) = bhkostd; FFTStats.stdwt_betaH(iLay) = bhwtstd; 
    FFTStats.df_betaH(iLay) = bh_S.df;
    % gamma low
    FFTStats.p_gammaL(iLay) = gl_P; FFTStats.Cohensd_gammaL(iLay) = gl_Cohd;
    FFTStats.meanko_gammaL(iLay) = glkomean; FFTStats.meanwt_gammaL(iLay) = glwtmean;
    FFTStats.stdko_gammaL(iLay) = glkostd; FFTStats.stdwt_gammaL(iLay) = glwtstd; 
    FFTStats.df_gammaL(iLay) = gl_S.df;
    % gamma high
    FFTStats.p_gammaH(iLay) = gh_P; FFTStats.Cohensd_gammaH(iLay) = gh_Cohd;
    FFTStats.meanko_gammaH(iLay) = ghkomean; FFTStats.meanwt_gammaH(iLay) = ghwtmean;
    FFTStats.stdko_gammaH(iLay) = ghkostd; FFTStats.stdwt_gammaH(iLay) = ghwtstd; 
    FFTStats.df_gammaH(iLay) = gh_S.df;
     
end

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_FFT'];
savefig(gcf,savename)
close

% save table 
writetable(FFTStats,[params.groups{1} 'v' params.groups{2} '_' Condition '_FFTStats.csv'])

cd(homedir)