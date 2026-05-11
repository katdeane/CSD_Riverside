function plotFFT_3grp(homedir,params,Condition,type)
% normalizes to the first group listed

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
color1 = [0/255 114/255 189/255]; %twitter blue
color2 = [217/255 83/255 25/255];%spicy paprika
color3 = [237/255 177/255 32/255];  % sunflower gold

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

FFTData = table('Size',[20000 11], 'VariableTypes', {'string','string',...
    'string','string','double','double','double','double','double',...
    'double','double'});
FFTData.Properties.VariableNames = ["Group","Subject","Condition","Layer",...
    "trial","delta","theta","alpha","beta","lowgam","highgam"];
count = 1;

for iLay = 1:length(params.layers)
    
    layTab = fftTab(matches(fftTab.layer,params.layers{iLay}),:);

    % get both groups
    grp1 = layTab.fft(matches(layTab.group,params.groups{1}),:);
    grp2 = layTab.fft(matches(layTab.group,params.groups{2}),:);
    grp3 = layTab.fft(matches(layTab.group,params.groups{3}),:);
    % stack the trials
    grp1 = horzcat(grp1{:}); grp2 = horzcat(grp2{:}); grp3 = horzcat(grp3{:});

    grp1m = nanmean(grp1,2);
    grp2m = nanmean(grp2,2);
    grp3m = nanmean(grp3,2);
    grp1sem = nanstd(grp1,0,2)/sqrt(L); 
    grp2sem = nanstd(grp2,0,2)/sqrt(L);
    grp3sem = nanstd(grp3,0,2)/sqrt(L);

    ratioKHWTm = grp3m ./ grp1m; % ratio mean line for plotting
    ratioKHWT  = grp3 ./ grp1m; % ratio of all KH to mean WT
    ratioKOWTm = grp2m ./ grp1m; % ratio mean line for plotting
    ratioKOWT  = grp2 ./ grp1m; % ratio of all KH to mean WT
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
    semilogy(fftaxis,grp1m,'-','Color',color1)
    hold on
    errorbar(fftaxis,grp1m,grp1sem,'Color',color1,'LineStyle','none','CapSize',3);
    semilogy(fftaxis,grp2m,'-','Color',color2)
    errorbar(fftaxis,grp2m,grp2sem,'Color',color2,'LineStyle','none','CapSize',3);
    semilogy(fftaxis,grp3m,'-','Color',color3)
    errorbar(fftaxis,grp3m,grp3sem,'Color',color3,'LineStyle','none','CapSize',3);
    title(['Layer ' params.layers{iLay}])
    xlim([0 100])
    xticks(0:10:100)
    ax = gca;
    ax.XScale = 'log';
    legend({params.groups{1} '' params.groups{2} '' params.groups{3}})

    nexttile 
    plot(fftaxis,ratioKOWTm,'Color',color2)
    hold on
    plot(fftaxis,ratioKHWTm,'Color',color3)
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)
    yline(1,'LineWidth',2)
    hold off
    ax = gca;
    ax.XScale = 'log';

    %% all stats not present, not doing yet
    % sum data from freq bins to make bar graph so simple so clean
    pool_range = fftaxis(fftaxis < 101); % take everything below 101 Hz
    pool_range = pool_range > 0;
    pool_KHm   = nanmean(ratioKHWT(pool_range,:),1);
    pool_KOm   = nanmean(ratioKOWT(pool_range,:),1);
    pool_WTm   = nanmean(ratioWTWT(pool_range,:),1);
    [p_Pwtkh,p_DFwtkh,p_Cohdwtkh,pwtmean,pwtstd,pkhmean,pkhstd] = ...
        myttest2(pool_WTm',pool_KHm',1,'both');
    [~,~,~,~,~,pwhmean,pwhstd] = ...
        myttest2(pool_WTm',pool_KOm',1,'both');

    gammahigh_range = fftaxis(fftaxis < 101); % cut off over 100
    gammahigh_range = gammahigh_range > 60; % get indices for over 60
    gammahigh_KHm   = nanmean(ratioKHWT(gammahigh_range,:),1);
    gammahigh_KOm   = nanmean(ratioKOWT(gammahigh_range,:),1);
    gammahigh_WTm   = nanmean(ratioWTWT(gammahigh_range,:),1);
    [gh_Pwtkh,gh_DFwtkh,gh_Cohdwtkh,ghwtmean,ghwtstd,ghkhmean,ghkhstd] = ...
        myttest2(gammahigh_WTm',gammahigh_KHm',1,'both');
    [~,~,~,~,~,ghwhmean,ghwhstd] = ...
        myttest2(gammahigh_WTm',gammahigh_KOm',1,'both');

    gammalow_range  = fftaxis(fftaxis < 61); % cut off over 100
    gammalow_range  = gammalow_range > 30; % get indices for over 60
    gammalow_KHm    = nanmean(ratioKHWT(gammalow_range,:),1);
    gammalow_KOm    = nanmean(ratioKOWT(gammalow_range,:),1);
    gammalow_WTm    = nanmean(ratioWTWT(gammalow_range,:),1);
    [gl_Pwtkh,gl_DFwtkh,gl_Cohdwtkh,glwtmean,glwtstd,glkhmean,glkhstd] = ...
        myttest2(gammalow_WTm',gammalow_KHm',1,'both');
    [~,~,~,~,~,glwhmean,glwhstd] = ...
        myttest2(gammalow_WTm',gammalow_KOm',1,'both');

    beta_range  = fftaxis(fftaxis < 31); % cut off over 100
    beta_range  = beta_range > 12; % get indices for over 60
    beta_KHm    = nanmean(ratioKHWT(beta_range,:),1);
    beta_KOm    = nanmean(ratioKOWT(beta_range,:),1);
    beta_WTm    = nanmean(ratioWTWT(beta_range,:),1);
    [b_Pwtkh,b_DFwtkh,b_Cohdwtkh,bwtmean,bwtstd,bkhmean,bkhstd] = ...
        myttest2(beta_WTm',beta_KHm',1,'both');
    [~,~,~,~,~,bwhmean,bwhstd] = ...
        myttest2(beta_WTm',beta_KOm',1,'both');

    alpha_range     = fftaxis(fftaxis < 13); % cut off over 100
    alpha_range     = alpha_range > 7; % get indices for over 60
    alpha_KHm       = nanmean(ratioKHWT(alpha_range,:),1);
    alpha_KOm       = nanmean(ratioKOWT(alpha_range,:),1);
    alpha_WTm       = nanmean(ratioWTWT(alpha_range,:),1);
    [a_Pwtkh,a_DFwtkh,a_Cohdwtkh,awtmean,awtstd,akhmean,akhstd] = ...
        myttest2(alpha_WTm',alpha_KHm',1,'both');
    [~,~,~,~,~,awhmean,awhstd] = ...
        myttest2(alpha_WTm',alpha_KOm',1,'both');

    theta_range     = fftaxis(fftaxis < 8); % cut off over 100
    theta_range     = theta_range > 3; % get indices for over 60
    theta_KHm       = nanmean(ratioKHWT(theta_range,:),1);
    theta_KOm       = nanmean(ratioKOWT(theta_range,:),1);
    theta_WTm       = nanmean(ratioWTWT(theta_range,:),1);
    [t_Pwtkh,t_DFwtkh,t_Cohdwtkh,twtmean,twtstd,tkhmean,tkhstd] = ...
        myttest2(theta_WTm',theta_KHm',1,'both');
    [~,~,~,~,~,twhmean,twhstd] = ...
        myttest2(theta_WTm',theta_KOm',1,'both');

    delta_range     = fftaxis(fftaxis < 4); % cut off over 100
    delta_range     = delta_range > 0; % get indices for over 60
    delta_KHm       = nanmean(ratioKHWT(delta_range,:),1);
    delta_KOm       = nanmean(ratioKOWT(delta_range,:),1);
    delta_WTm       = nanmean(ratioWTWT(delta_range,:),1);
    [d_Pwtkh,d_DFwtkh,d_Cohdwtkh,dwtmean,dwtstd,dkhmean,dkhstd] = ...
        myttest2(delta_WTm',delta_KHm',1,'both');
    [~,~,~,~,~,dwhmean,dwhstd] = ...
        myttest2(delta_WTm',delta_KOm',1,'both');

    % fill the data table
    g1size = length(pool_WTm); g2size = length(pool_KOm); g3size = length(pool_KHm);
    % group 1
    FFTData.Group(count:count+g1size-1)     = repmat(params.groups{1},[g1size,1]);
    FFTData.Condition(count:count+g1size-1) = repmat("Spontaneous",[g1size,1]);
    FFTData.Layer(count:count+g1size-1)     = repmat(params.layers{iLay},[g1size,1]);
    FFTData.trial(count:count+g1size-1)     = repmat((1:60)',[g1size/60,1]);
    FFTData.delta(count:count+g1size-1)     = delta_WTm';
    FFTData.theta(count:count+g1size-1)     = theta_WTm';
    FFTData.alpha(count:count+g1size-1)     = alpha_WTm';
    FFTData.beta(count:count+g1size-1)      = beta_WTm';
    FFTData.lowgam(count:count+g1size-1)    = gammalow_WTm';
    FFTData.highgam(count:count+g1size-1)   = gammahigh_WTm';
    sublist = "0";
    for iSub = 1:(g1size/60)
        sublist = vertcat(sublist, repmat(['WT' num2str(iSub)],[60,1]));
    end
    FFTData.Subject(count:count+g1size-1)   = sublist(2:end);
    count = count+g1size;
    % group 2
    FFTData.Group(count:count+g2size-1)     = repmat(params.groups{2},[g2size,1]);
    FFTData.Condition(count:count+g2size-1) = repmat("Spontaneous",[g2size,1]);
    FFTData.Layer(count:count+g2size-1)     = repmat(params.layers{iLay},[g2size,1]);
    FFTData.trial(count:count+g2size-1)     = repmat((1:60)',[g2size/60,1]);
    FFTData.delta(count:count+g2size-1)     = delta_KOm';
    FFTData.theta(count:count+g2size-1)     = theta_KOm';
    FFTData.alpha(count:count+g2size-1)     = alpha_KOm';
    FFTData.beta(count:count+g2size-1)      = beta_KOm';
    FFTData.lowgam(count:count+g2size-1)    = gammalow_KOm';
    FFTData.highgam(count:count+g2size-1)   = gammahigh_KOm';
    sublist = "0";
    for iSub = 1:(g2size/60)
        sublist = vertcat(sublist, repmat(['KO' num2str(iSub)],[60,1])); %#ok<*AGROW>
    end
    FFTData.Subject(count:count+g2size-1)   = sublist(2:end);
    count = count+g2size;
    % group 3
    FFTData.Group(count:count+g3size-1)     = repmat(params.groups{3},[g3size,1]);
    FFTData.Condition(count:count+g3size-1) = repmat("Spontaneous",[g3size,1]);
    FFTData.Layer(count:count+g3size-1)     = repmat(params.layers{iLay},[g3size,1]);
    FFTData.trial(count:count+g3size-1)     = repmat((1:60)',[g3size/60,1]);
    FFTData.delta(count:count+g3size-1)     = delta_KHm';
    FFTData.theta(count:count+g3size-1)     = theta_KHm';
    FFTData.alpha(count:count+g3size-1)     = alpha_KHm';
    FFTData.beta(count:count+g3size-1)      = beta_KHm';
    FFTData.lowgam(count:count+g3size-1)    = gammalow_KHm';
    FFTData.highgam(count:count+g3size-1)   = gammahigh_KHm';
    sublist = "0";
    for iSub = 1:(g3size/60)
        sublist = vertcat(sublist, repmat(['KH' num2str(iSub)],[60,1]));
    end
    FFTData.Subject(count:count+g3size-1)   = sublist(2:end);
    count = count+g3size;
    
        
    osci_Means = [dwtmean twtmean awtmean bwtmean glwtmean ghwtmean; ...
        dwhmean twhmean awhmean bwhmean glwhmean ghwhmean; ...
        dkhmean tkhmean akhmean bkhmean glkhmean ghkhmean];
    % osci_sems  = [dwtstd/sqrt(d_DFwtkh+2) dwhstd/sqrt(d_DFwtkh+2) dkhstd/sqrt(d_DFwtkh+2) ...
    %     twtstd/sqrt(d_DFwtkh+2) twhstd/sqrt(d_DFwtkh+2) tkhstd/sqrt(d_DFwtkh+2) ...
    %     awtstd/sqrt(d_DFwtkh+2) awhstd/sqrt(d_DFwtkh+2) akhstd/sqrt(d_DFwtkh+2) ...
    %     bwtstd/sqrt(d_DFwtkh+2) bwhstd/sqrt(d_DFwtkh+2) bkhstd/sqrt(d_DFwtkh+2) ...
    %     glwtstd/sqrt(d_DFwtkh+2) glwhstd/sqrt(d_DFwtkh+2) glkhstd/sqrt(d_DFwtkh+2) ...
    %     ghwtstd/sqrt(d_DFwtkh+2) ghwhstd/sqrt(d_DFwtkh+2) ghkhstd/sqrt(d_DFwtkh+2)];

    osci_sems  = [dwtstd/sqrt(d_DFwtkh+2) twtstd/sqrt(d_DFwtkh+2) awtstd/sqrt(d_DFwtkh+2) bwtstd/sqrt(d_DFwtkh+2) glwtstd/sqrt(d_DFwtkh+2) ghwtstd/sqrt(d_DFwtkh+2); ...
        dwhstd/sqrt(d_DFwtkh+2) twhstd/sqrt(d_DFwtkh+2) awhstd/sqrt(d_DFwtkh+2) bwhstd/sqrt(d_DFwtkh+2) glwhstd/sqrt(d_DFwtkh+2) ghwhstd/sqrt(d_DFwtkh+2); ...
        dkhstd/sqrt(d_DFwtkh+2) tkhstd/sqrt(d_DFwtkh+2) akhstd/sqrt(d_DFwtkh+2) bkhstd/sqrt(d_DFwtkh+2) glkhstd/sqrt(d_DFwtkh+2) ghkhstd/sqrt(d_DFwtkh+2)];
    
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
    xticklabels([{'D'} {'T'} {'A'} {'BH'} {'GL'} {'GH'}])
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1} ' means'])
    % ylim([0 2])

    nexttile 
    bar(1,[pwtmean; pwhmean; pkhmean])
    hold on
    errorbar(1,[pwtmean; pwhmean; pkhmean],[dwtstd/sqrt(d_DFwtkh+2); dwhstd/sqrt(d_DFwtkh+2); dkhstd/sqrt(d_DFwtkh+2)],...
        'Color',[0 0 0],'LineStyle','none');
    xticklabels({'pooled'})
    title('pooled means')
    % ylim([0 2])

    % fill the table
    FFTStats.Layer(iLay)     = params.layers{iLay};
    % theta
    FFTStats.p_delta(iLay) = d_Pwtkh; FFTStats.Cohensd_delta(iLay) = d_Cohdwtkh;
    FFTStats.meanko_delta(iLay) = dkhmean; FFTStats.meanwt_delta(iLay) = dwtmean;
    FFTStats.stdko_delta(iLay) = dkhstd; FFTStats.stdwt_delta(iLay) = dwtstd; 
    FFTStats.df_delta(iLay) = d_DFwtkh;
    % theta
    FFTStats.p_theta(iLay) = t_Pwtkh; FFTStats.Cohensd_theta(iLay) = t_Cohdwtkh;
    FFTStats.meanko_theta(iLay) = tkhmean; FFTStats.meanwt_theta(iLay) = twtmean;
    FFTStats.stdko_theta(iLay) = tkhstd; FFTStats.stdwt_theta(iLay) = twtstd; 
    FFTStats.df_theta(iLay) = t_DFwtkh;
    % alpha
    FFTStats.p_alpha(iLay) = a_Pwtkh; FFTStats.Cohensd_alpha(iLay) = a_Cohdwtkh;
    FFTStats.meanko_alpha(iLay) = akhmean; FFTStats.meanwt_alpha(iLay) = awtmean;
    FFTStats.stdko_alpha(iLay) = akhstd; FFTStats.stdwt_alpha(iLay) = awtstd; 
    FFTStats.df_alpha(iLay) = a_DFwtkh;
    % beta
    FFTStats.p_beta(iLay) = b_Pwtkh; FFTStats.Cohensd_beta(iLay) = b_Cohdwtkh;
    FFTStats.meanko_beta(iLay) = bkhmean; FFTStats.meanwt_beta(iLay) = bwtmean;
    FFTStats.stdko_beta(iLay) = bkhstd; FFTStats.stdwt_beta(iLay) = bwtstd; 
    FFTStats.df_beta(iLay) = b_DFwtkh;
    % gamma low
    FFTStats.p_gammaL(iLay) = gl_Pwtkh; FFTStats.Cohensd_gammaL(iLay) = gl_Cohdwtkh;
    FFTStats.meanko_gammaL(iLay) = glkhmean; FFTStats.meanwt_gammaL(iLay) = glwtmean;
    FFTStats.stdko_gammaL(iLay) = glkhstd; FFTStats.stdwt_gammaL(iLay) = glwtstd; 
    FFTStats.df_gammaL(iLay) = gl_DFwtkh;
    % gamma high
    FFTStats.p_gammaH(iLay) = gh_Pwtkh; FFTStats.Cohensd_gammaH(iLay) = gh_Cohdwtkh;
    FFTStats.meanko_gammaH(iLay) = ghkhmean; FFTStats.meanwt_gammaH(iLay) = ghwtmean;
    FFTStats.stdko_gammaH(iLay) = ghkhstd; FFTStats.stdwt_gammaH(iLay) = ghwtstd; 
    FFTStats.df_gammaH(iLay) = gh_DFwtkh;
    % pooled
    FFTStats.p_pool(iLay) = p_Pwtkh; FFTStats.Cohensd_pool(iLay) = p_Cohdwtkh;
    FFTStats.meanko_pool(iLay) = pkhmean; FFTStats.meanwt_pool(iLay) = pwtmean;
    FFTStats.stdko_pool(iLay) = pkhstd; FFTStats.stdwt_pool(iLay) = pwtstd; 
    FFTStats.df_pool(iLay) = p_DFwtkh;
     
end

savename = [params.groups{1} 'v' params.groups{2} 'v' params.groups{3} '_' Condition '_' type '_FFT'];
savefig(gcf,savename)
close

% save tables
writetable(FFTStats,[params.groups{1} 'v' params.groups{2} 'v' params.groups{3} '_' Condition '_' type  '_FFTStats.csv'])

cd(homedir);cd output 
if ~exist('DataforStatsAwakeFmr1','dir')
    mkdir('DataforStatsAwakeFmr1')
end
cd DataforStatsAwakeFmr1
toDelete = FFTData.trial == 0;
FFTData(toDelete,:) = [];
writetable(FFTData,[params.groups{1} 'v' params.groups{2} 'v' params.groups{3} '_' Condition '_' type  '_FFTData.csv'])

cd(homedir)