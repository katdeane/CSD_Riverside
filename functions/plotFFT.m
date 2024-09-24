function plotFFT(homedir,params,Condition,type)

if ~exist('type','var')
    type = 'AB'; % absolute or RE relative
end

cd(homedir); cd output;
loadname = [params.groups{1} 'v' params.groups{2} '_' Condition '_' type '_FFT.mat'];
load(loadname,['fftStruct' type])
if matches(type,'AB')
    fftTab = struct2table(fftStructAB);
elseif matches(type,'RE')
    fftTab = struct2table(fftStructRE);
end
clear fftStructAB fftStructRE % kat, just save it as a table in the other script

% for plotting
Fs = 1000; % Sampling frequency
L  = length(fftTab.fft{1}); % Length of signal [ms]
color11 = [15/255 63/255 111/255]; %indigo blue
color12 = [24/255 102/255 180/255]; 
color21 = [115/255 46/255 61/255]; % wine
color22 = [160/255 64/255 85/255]; 

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
    "p_beta","meanko_beta","stdko_beta", "meanwt_beta","stdwt_beta", ...
    "df_beta","Cohensd_beta", "p_gammaL", "meanko_gammaL","stdko_gammaL",...
    "meanwt_gammaL","stdwt_gammaL", "df_gammaL","Cohensd_gammaL",...
    "p_gammaH", "meanko_gammaH", "stdko_gammaH","meanwt_gammaH",...
    "stdwt_gammaH","df_gammaH","Cohensd_gammaH", "p_pool", "meanko_pool",...
    "stdko_pool","meanwt_pool", "stdwt_pool","df_pool","Cohensd_pool"];

for iLay = 1:length(params.layers)
    
    layTab = fftTab(matches(fftTab.layer,params.layers{iLay}),:);

    % get both groups
    grp1 = layTab.fft(matches(layTab.group,params.groups{1}),:);
    grp2 = layTab.fft(matches(layTab.group,params.groups{2}),:);
    % stack the trials
    grp1 = horzcat(grp1{:}); grp2 = horzcat(grp2{:});

    grp1m = mean(grp1,2);
    grp2m = mean(grp2,2);
    grp1sem = std(grp1,0,2)/sqrt(L); 
    grp2sem = std(grp2,0,2)/sqrt(L);

    ratioKOWTm = grp2m ./ grp1m; % ratio mean line for plotting
    ratioKOWT  = grp2 ./ grp1m; % ratio of all KO to mean WT
    ratioWTWT  = grp1 ./ grp1m; % ratio of all WT to mean WT
        
    fftaxis = (Fs/L)*(0:L-1);

    % plot
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
    semilogy(fftaxis,grp1m,'-','Color',color11)
    hold on
    errorbar(fftaxis,grp1m,grp1sem,'Color',color12,'LineStyle','none','CapSize',3);
    semilogy(fftaxis,grp2m,'-','Color',color21)
    errorbar(fftaxis,grp2m,grp2sem,'Color',color22,'LineStyle','none','CapSize',3);
    title(['Layer ' params.layers{iLay}])
    xlim([0 100])
    xticks(0:10:100)
    ax = gca;
    ax.XScale = 'log';
    legend({params.groups{1} '' params.groups{2}})

    nexttile 
    plot(fftaxis,ratioKOWTm,'-k')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)
    hold on 
    yline(1,'LineWidth',2)
    hold off
    ax = gca;
    ax.XScale = 'log';

    % sum data from freq bins to make bar graph so simple so clean
    pool_range = fftaxis(fftaxis < 101); % take everything below 101 Hz
    pool_range = pool_range > 0;
    pool_KOm   = mean(ratioKOWT(pool_range,:),1);
    pool_WTm   = mean(ratioWTWT(pool_range,:),1);
    [p_P,p_DF,p_Cohd,pwtmean,pwtstd,pkomean,pkostd] = ...
        myttest2(pool_WTm',pool_KOm',1,'both');

    gammahigh_range = fftaxis(fftaxis < 101); % cut off over 100
    gammahigh_range = gammahigh_range > 60; % get indices for over 60
    gammahigh_KOm   = mean(ratioKOWT(gammahigh_range,:),1);
    gammahigh_WTm   = mean(ratioWTWT(gammahigh_range,:),1);
    [gh_P,gh_DF,gh_Cohd,ghwtmean,ghwtstd,ghkomean,ghkostd] = ...
        myttest2(gammahigh_WTm',gammahigh_KOm',1,'both');

    gammalow_range  = fftaxis(fftaxis < 61); % cut off over 100
    gammalow_range  = gammalow_range > 30; % get indices for over 60
    gammalow_KOm    = mean(ratioKOWT(gammalow_range,:),1);
    gammalow_WTm    = mean(ratioWTWT(gammalow_range,:),1);
    [gl_P,gl_DF,gl_Cohd,glwtmean,glwtstd,glkomean,glkostd] = ...
        myttest2(gammalow_WTm',gammalow_KOm',1,'both');

    beta_range  = fftaxis(fftaxis < 31); % cut off over 100
    beta_range  = beta_range > 12; % get indices for over 60
    beta_KOm    = mean(ratioKOWT(beta_range,:),1);
    beta_WTm    = mean(ratioWTWT(beta_range,:),1);
    [b_P,b_DF,b_Cohd,bwtmean,bwtstd,bkomean,bkostd] = ...
        myttest2(beta_WTm',beta_KOm',1,'both');

    alpha_range     = fftaxis(fftaxis < 13); % cut off over 100
    alpha_range     = alpha_range > 7; % get indices for over 60
    alpha_KOm       = mean(ratioKOWT(alpha_range,:),1);
    alpha_WTm       = mean(ratioWTWT(alpha_range,:),1);
    [a_P,a_DF,a_Cohd,awtmean,awtstd,akomean,akostd] = ...
        myttest2(alpha_WTm',alpha_KOm',1,'both');

    theta_range     = fftaxis(fftaxis < 8); % cut off over 100
    theta_range     = theta_range > 3; % get indices for over 60
    theta_KOm       = mean(ratioKOWT(theta_range,:),1);
    theta_WTm       = mean(ratioWTWT(theta_range,:),1);
    [t_P,t_DF,t_Cohd,twtmean,twtstd,tkomean,tkostd] = ...
        myttest2(theta_WTm',theta_KOm',1,'both');

    delta_range     = fftaxis(fftaxis < 4); % cut off over 100
    delta_range     = delta_range > 0; % get indices for over 60
    delta_KOm       = mean(ratioKOWT(delta_range,:),1);
    delta_WTm       = mean(ratioWTWT(delta_range,:),1);
    [d_P,d_DF,d_Cohd,dwtmean,dwtstd,dkomean,dkostd] = ...
        myttest2(delta_WTm',delta_KOm',1,'both');
        
    osci_Means = [dwtmean dkomean twtmean tkomean awtmean akomean ...
        bwtmean bkomean glwtmean glkomean ghwtmean ghkomean];
    osci_sems  = [dwtstd/sqrt(d_DF+2) dkostd/sqrt(d_DF+2) twtstd/sqrt(d_DF+2) ...
        tkostd/sqrt(d_DF+2) awtstd/sqrt(d_DF+2) akostd/sqrt(d_DF+2) ...
        bwtstd/sqrt(d_DF+2) bkostd/sqrt(d_DF+2) glwtstd/sqrt(d_DF+2) ...
        glkostd/sqrt(d_DF+2) ghwtstd/sqrt(d_DF+2) ghkostd/sqrt(d_DF+2)];
    
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
    % test(1:length(beta_range)) = beta_range;
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
    errorbar(1:length(osci_Means),osci_Means,osci_sems,'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'D'} {num2str(d_P)} {'T'} {num2str(t_P)} {'A'} {num2str(a_P)} ...
        {'BH'} {num2str(b_P)} {'GL'} {num2str(gl_P)} {'GH'} {num2str(gh_P)}])
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1} ' means'])
    ylim([0 2])

    nexttile 
    bar(1:2,[pwtmean pkomean])
    hold on
    errorbar(1:2,[pwtmean pkomean],[dwtstd/sqrt(d_DF+2) dkostd/sqrt(d_DF+2)],...
        'Color',[0 0 0],'LineStyle','none');
    xticklabels([{'p'} {num2str(p_P)}])
    title('pooled means')
    ylim([0 2])

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
    % beta
    FFTStats.p_beta(iLay) = b_P; FFTStats.Cohensd_beta(iLay) = b_Cohd;
    FFTStats.meanko_beta(iLay) = bkomean; FFTStats.meanwt_beta(iLay) = bwtmean;
    FFTStats.stdko_beta(iLay) = bkostd; FFTStats.stdwt_beta(iLay) = bwtstd; 
    FFTStats.df_beta(iLay) = b_DF;
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
    % pooled
    FFTStats.p_pool(iLay) = p_P; FFTStats.Cohensd_pool(iLay) = p_Cohd;
    FFTStats.meanko_pool(iLay) = pkomean; FFTStats.meanwt_pool(iLay) = pwtmean;
    FFTStats.stdko_pool(iLay) = pkostd; FFTStats.stdwt_pool(iLay) = pwtstd; 
    FFTStats.df_pool(iLay) = p_DF;
     
end

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_' type '_FFT'];
savefig(gcf,savename)
close

% save table 
writetable(FFTStats,[params.groups{1} 'v' params.groups{2} '_' Condition '_' type  '_FFTStats.csv'])

cd(homedir)