function plotFFT_NoiseBurstSpont(homedir,params)

cd(homedir); 
loadname = [params.groups{1} 'v' params.groups{2} '_NoiseBurstSpont_FFT.mat'];
load(loadname,'fftStruct')
fftTab = struct2table(fftStruct); 
clear fftStruct % kat, just save it as a table in the other script

% for plotting
Fs = 1000; % Sampling frequency
L  = length(fftTab.fft{1}); % Length of signal [ms]

cd (homedir); cd figures;
if ~exist('FFTfig','dir')
    mkdir('FFTfig');
end
cd FFTfig

FFTfig = tiledlayout('flow');
title(FFTfig,'NoiseBurstSpont FFT')
xlabel(FFTfig, 'f (Hz)')
ylabel(FFTfig, 'Power')

% initiate table here
FFTStats = table('Size',[length(params.layers) 50],'VariableTypes',...
    {'string','double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double','double',...
    'double','double','double','double'});

FFTStats.Properties.VariableNames = ["Layer", "p_delta",...
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
    
    % gaussian filter isn't needed because this time window is much less
    % condensed
    % grp1g   = imgaussfilt(grp1m,10);
    % grp2g   = imgaussfilt(grp2m,10);
    % ratioKOWTm = imgaussfilt(ratioKOWTm,10);
    % ratioKOWT  = imgaussfilt(ratioKOWT,10);
    % ratioWTWT  = imgaussfilt(ratioWTWT,10);
    
    fftaxis = (Fs/L)*(0:L-1);

    % plot
    % sanity plot (why is the variability so low except in high gamma for
    % the WT group?) 
    % nexttile; hold on
    % for ip = 1:size(ratioWTWT,1)
    %     plot(fftaxis,ratioWTWT(ip,:))
    % end
    % xlim([0 100])
    % xticks(0:10:100)
    % 
    % nexttile; hold on
    % for ip = 1:size(ratioKOWT,1)
    %     plot(fftaxis,ratioKOWT(ip,:))
    % end
    % xlim([0 100])
    % xticks(0:10:100)

    nexttile 
    semilogy(fftaxis,grp1m,'-')
    hold on 
    semilogy(fftaxis,grp2m,'-')
    title(['Layer ' params.layers{iLay}])
    xlim([0 100])
    xticks(0:10:100)
    legend({params.groups{1} params.groups{2}})

    nexttile 
    plot(fftaxis,ratioKOWTm,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/mean' params.groups{1}])
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
    [gh_P,gh_DF,gh_Cohd,ghwtmean,ghwtstd,ghkomean,ghkostd] = ...
        myttest2(gammahigh_WTm,gammahigh_KOm,1,'both');

    gammalow_range  = fftaxis(fftaxis < 61); % cut off over 100
    gammalow_range  = gammalow_range > 30; % get indices for over 60
    gammalow_KOm    = mean(ratioKOWT(:,gammalow_range),2);
    gammalow_WTm    = mean(ratioWTWT(:,gammalow_range),2);
    [gl_P,gl_DF,gl_Cohd,glwtmean,glwtstd,glkomean,glkostd] = ...
        myttest2(gammalow_WTm,gammalow_KOm,1,'both');

    betahigh_range  = fftaxis(fftaxis < 31); % cut off over 100
    betahigh_range  = betahigh_range > 18; % get indices for over 60
    betahigh_KOm    = mean(ratioKOWT(:,betahigh_range),2);
    betahigh_WTm    = mean(ratioWTWT(:,betahigh_range),2);
    [bh_P,bh_DF,bh_Cohd,bhwtmean,bhwtstd,bhkomean,bhkostd] = ...
        myttest2(betahigh_WTm,betahigh_KOm,1,'both');

    betalow_range   = fftaxis(fftaxis < 19); % cut off over 100
    betalow_range   = betalow_range > 12; % get indices for over 60
    betalow_KOm     = mean(ratioKOWT(:,betalow_range),2);
    betalow_WTm     = mean(ratioWTWT(:,betalow_range),2);
    [bl_P,bl_DF,bl_Cohd,blwtmean,blwtstd,blkomean,blkostd] = ...
        myttest2(betalow_WTm,betalow_KOm,1,'both');

    alpha_range     = fftaxis(fftaxis < 13); % cut off over 100
    alpha_range     = alpha_range > 7; % get indices for over 60
    alpha_KOm       = mean(ratioKOWT(:,alpha_range),2);
    alpha_WTm       = mean(ratioWTWT(:,alpha_range),2);
    [a_P,a_DF,a_Cohd,awtmean,awtstd,akomean,akostd] = ...
        myttest2(alpha_WTm,alpha_KOm,1,'both');

    theta_range     = fftaxis(fftaxis < 8); % cut off over 100
    theta_range     = theta_range > 3; % get indices for over 60
    theta_KOm       = mean(ratioKOWT(:,theta_range),2);
    theta_WTm       = mean(ratioWTWT(:,theta_range),2);
    [t_P,t_DF,t_Cohd,twtmean,twtstd,tkomean,tkostd] = ...
        myttest2(theta_WTm,theta_KOm,1,'both');

    delta_range     = fftaxis(fftaxis < 4); % cut off over 100
    delta_range     = delta_range > 0; % get indices for over 60
    delta_KOm       = mean(ratioKOWT(:,delta_range),2);
    delta_WTm       = mean(ratioWTWT(:,delta_range),2);
    [d_P,d_DF,d_Cohd,dwtmean,dwtstd,dkomean,dkostd] = ...
        myttest2(delta_WTm,delta_KOm,1,'both');
        
    osci_Means = [dwtmean dkomean twtmean tkomean awtmean akomean blwtmean ...
        blkomean bhwtmean bhkomean glwtmean glkomean ghwtmean ghkomean];
    osci_stds  = [dwtstd dkostd twtstd tkostd awtstd akostd blwtstd blkostd...
        bhwtstd bhkostd glwtstd glkostd ghwtstd ghkostd];
    
    % sanity check on bands
    % hold on
    % test = zeros(1,length(fftaxis));
    % test(1:length(delta_range)) = delta_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(theta_range)) = theta_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(alpha_range)) = alpha_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(betalow_range)) = betalow_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(betahigh_range)) = betahigh_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(gammalow_range)) = gammalow_range;
    % plot(fftaxis,test)
    % test = zeros(1,length(fftaxis));
    % test(1:length(gammahigh_range)) = gammahigh_range;
    % plot(fftaxis,test)

    % bar plot of binned frequency means and std error bars
    nexttile 
    bar(1:length(osci_Means),osci_Means)
    hold on
    errorbar(1:length(osci_Means),osci_Means,osci_stds,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(d_P)} {'T'} {num2str(t_P)} {'A'} {num2str(a_P)} {'BL'} {num2str(bl_P)}...
        {'BH'} {num2str(bh_P)} {'GL'} {num2str(gl_P)} {'GH'} {num2str(gh_P)}])
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1} ' means'])

    % fill the table
    FFTStats.Layer(iLay)     = params.layers{iLay};
    % theta
    FFTStats.p_delta(iLay) = d_P; FFTStats.Cohensd_delta(iLay) = d_Cohd;
    FFTStats.meanko_delta(iLay) = dkomean; FFTStats.meanwt_delta(iLay) = dwtmean;
    FFTStats.stdko_delta(iLay) = dkostd; FFTStats.stdwt_delta(iLay) = dwtstd; 
    FFTStats.df_delta(iLay) = d_DF;
    % theta
    FFTStats.p_theta(iLay) = t_P; FFTStats.Cohensd_theta(iLay) = t_Cohd;
    FFTStats.meanko_theta(iLay) = tkomean; FFTStats.meanwt_theta(iLay) = twtmean;
    FFTStats.stdko_theta(iLay) = tkostd; FFTStats.stdwt_theta(iLay) = twtstd; 
    FFTStats.df_theta(iLay) = t_DF;
    % alpha
    FFTStats.p_alpha(iLay) = a_P; FFTStats.Cohensd_alpha(iLay) = a_Cohd;
    FFTStats.meanko_alpha(iLay) = akomean; FFTStats.meanwt_alpha(iLay) = awtmean;
    FFTStats.stdko_alpha(iLay) = akostd; FFTStats.stdwt_alpha(iLay) = awtstd; 
    FFTStats.df_alpha(iLay) = a_DF;
    % beta low
    FFTStats.p_betaL(iLay) = bl_P; FFTStats.Cohensd_betaL(iLay) = bl_Cohd;
    FFTStats.meanko_betaL(iLay) = blkomean; FFTStats.meanwt_betaL(iLay) = blwtmean;
    FFTStats.stdko_betaL(iLay) = blkostd; FFTStats.stdwt_betaL(iLay) = blwtstd; 
    FFTStats.df_betaL(iLay) = bl_DF;
    % beta high
    FFTStats.p_betaH(iLay) = bh_P; FFTStats.Cohensd_betaH(iLay) = bh_Cohd;
    FFTStats.meanko_betaH(iLay) = bhkomean; FFTStats.meanwt_betaH(iLay) = bhwtmean;
    FFTStats.stdko_betaH(iLay) = bhkostd; FFTStats.stdwt_betaH(iLay) = bhwtstd; 
    FFTStats.df_betaH(iLay) = bh_DF;
    % gamma low
    FFTStats.p_gammaL(iLay) = gl_P; FFTStats.Cohensd_gammaL(iLay) = gl_Cohd;
    FFTStats.meanko_gammaL(iLay) = glkomean; FFTStats.meanwt_gammaL(iLay) = glwtmean;
    FFTStats.stdko_gammaL(iLay) = glkostd; FFTStats.stdwt_gammaL(iLay) = glwtstd; 
    FFTStats.df_gammaL(iLay) = gl_DF;
    % gamma high
    FFTStats.p_gammaH(iLay) = gh_P; FFTStats.Cohensd_gammaH(iLay) = gh_Cohd;
    FFTStats.meanko_gammaH(iLay) = ghkomean; FFTStats.meanwt_gammaH(iLay) = ghwtmean;
    FFTStats.stdko_gammaH(iLay) = ghkostd; FFTStats.stdwt_gammaH(iLay) = ghwtstd; 
    FFTStats.df_gammaH(iLay) = gh_DF;
     
end

savename = [params.groups{1} 'v' params.groups{2} '_NoiseBurstSpont_FFT'];
savefig(gcf,savename)
close

% save table 
writetable(FFTStats,[params.groups{1} 'v' params.groups{2} '_NoiseBurstSpont_FFTStats.csv'])

cd(homedir)