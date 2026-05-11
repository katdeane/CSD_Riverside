function agecorr_FFT(homedir,Groups,Condition,type)

if ~exist('type','var')
    type = 'AB'; % absolute or RE relative
end

% HARD CODING TIME, SORRY
Ages = {'VMP02' 'VMP03' 'VMP04' 'VMP05' 'VMP06' 'VMP07' 'VMP08' ...
    'PMP01' 'PMP02' 'PMP03' 'PMP04' 'PMP05' 'PMP06' 'PMP07' 'PMP08' 'PMP09';...
    '4.1'	'4.4'	'4.5'	'4.5'	'6.3'	'7.1'	'5.9' ...
    '7.1'	'7.0' 	'6.9'	'5.7'	'6.0'	'6.1'	'6.0'	'6.1' 	'6.6'};
Layers = {'II' 'IV' 'Va' 'Vb' 'VI'};

cd(homedir); cd output;
loadname = [Groups{1} 'v' Groups{2} '_' Condition '_' type '_FFT.mat'];
load(loadname,['fftStruct' type])
if matches(type,'AB')
    fftTab = struct2table(fftStructAB);
elseif matches(type,'RE')
    fftTab = struct2table(fftStructRE);
end
clear fftStructAB fftStructRE % kat, just save it as a table in the other script

allsubjects = unique(fftTab.animal); % subject list
numsubjects = length(allsubjects); % total number
Fs = 1000; % Sampling frequency
L  = length(fftTab.fft{1}); % Length of signal [ms]
fftaxis = (Fs/L)*(0:L-1);

if matches(Condition, 'Pupcall')
    % get rid of the shorter trials subject (VMP02 has 20 trials)
    toDelete = matches(fftTab.animal,'VMP02');
    fftTab(toDelete,:) = [];
end

cd (homedir); cd figures;
if ~exist('FFT_agecorr','dir')
    mkdir('FFT_agecorr');
end
cd FFT_agecorr

%% First build the table
FFTData = table('Size',[numsubjects*length(Layers) 10],'VariableTypes',...
    {'string','string','double','double','double','double','double',...
    'double','double','double'});

FFTData.Properties.VariableNames = ["Subject", "Layer", "Age", "delta", "theta",...
    "alpha","beta","low_gamma","high_gamma","pooled"];

count = 1;

for iSub = 1:numsubjects
    % pull each subject
    subTab = fftTab(matches(fftTab.animal,allsubjects{iSub}),:);
    for iLay = 1:length(Layers)
        % pull each layer (now we should be down to one fft)
        layDat = subTab(matches(subTab.layer,Layers{iLay}),'fft');
        layDat = layDat.fft{1};

        % get frequency band ranges out
        pool_range         = fftaxis(fftaxis < 101); % take everything below 101 Hz
        pool_range         = pool_range > 0;
        FFTData.pooled(count)     = nanmean(nanmean(layDat(pool_range,:),1));

        gammahigh_range    = fftaxis(fftaxis < 101); % cut off over 100
        gammahigh_range    = gammahigh_range > 60; % get indices for over 60
        FFTData.high_gamma(count) = nanmean(nanmean(layDat(gammahigh_range,:),1));

        gammalow_range     = fftaxis(fftaxis < 61); % cut off over 100
        gammalow_range     = gammalow_range > 30; % get indices for over 60
        FFTData.low_gamma(count)  = nanmean(nanmean(layDat(gammalow_range,:),1));

        beta_range         = fftaxis(fftaxis < 31); % cut off over 100
        beta_range         = beta_range > 12; % get indices for over 60
        FFTData.beta(count)       = nanmean(nanmean(layDat(beta_range,:),1));

        alpha_range        = fftaxis(fftaxis < 13); % cut off over 100
        alpha_range        = alpha_range > 7; % get indices for over 60
        FFTData.alpha(count)     = nanmean(nanmean(layDat(alpha_range,:),1));

        theta_range        = fftaxis(fftaxis < 8); % cut off over 100
        theta_range        = theta_range > 3; % get indices for over 60
        FFTData.theta(count)      = nanmean(nanmean(layDat(theta_range,:),1));

        delta_range        = fftaxis(fftaxis < 4); % cut off over 100
        delta_range        = delta_range > 0; % get indices for over 60
        FFTData.delta(count)      = nanmean(nanmean(layDat(delta_range,:),1));

        FFTData.Subject(count) = allsubjects{iSub};
        FFTData.Layer(count)   = Layers{iLay};
        FFTData.Age(count)     = str2num(Ages{2,matches(Ages(1,:),allsubjects{iSub})});
        count = count + 1; % I can do it better, I just don't feel like it
    end % layers
end % subjects

save([Groups{1} '&' Groups{2} '_' Condition '_' type '_ageCorr.mat'],'FFTData')

%% Now we can correlate

Corrfig = tiledlayout('flow');
title(Corrfig,'Age correlations')
xlabel(Corrfig, 'Age')
ylabel(Corrfig, 'FFT Power')

% find error
for iLay = 1:length(Layers)

    layTab = FFTData(matches(FFTData.Layer,Layers{iLay}),:);

    % age can be correlated with each average FFT frequency band value
    agelist = layTab.Age; %skew -.8 kurt -1
    poolist = layTab.pooled; %skew 2.2 kurt -0.9
    gahlist = layTab.high_gamma; %skew 5 kurt 7
    gallist = layTab.low_gamma; %skew 4 kurt 4.6
    betlist = layTab.beta; %skew 1.2 kurt 0.1
    alplist = layTab.alpha; %skew 4.1 kurt 4.9
    thelist = layTab.theta; %skew 3.7 kurt 3.7
    dellist = layTab.delta; %skew 2.6 kurt 0.9

    % check that all are within -2 - 2 for normal dist
    % [rskew,rkust] = ratios(gahlist)

    nexttile
    [r_pool, p_pool] = corr(agelist,poolist,'Type','Spearman');
    scatter(agelist,poolist);
    title([Layers{iLay} ' pooled r=' num2str(round(r_pool,2,'significant'))...
        ' p=' num2str(round(p_pool,2,'significant'))])

    nexttile
    [r_highg, p_highg] = corr(agelist,gahlist);
    scatter(agelist,gahlist);
    title([Layers{iLay} ' high gamma r=' num2str(round(r_highg,2,'significant'))...
        ' p=' num2str(round(p_highg,2,'significant'))])

    nexttile
    [r_lowg, p_lowg] = corr(agelist,gallist);
    scatter(agelist,gallist);
    title([Layers{iLay} ' low gamma r=' num2str(round(r_lowg,2,'significant'))...
        ' p=' num2str(round(p_lowg,2,'significant'))])

    nexttile
    [r_beta, p_beta] = corr(agelist,betlist);
    scatter(agelist,betlist);
    title([Layers{iLay} ' beta r=' num2str(round(r_beta,2,'significant'))...
        ' p=' num2str(round(p_beta,2,'significant'))])

    nexttile
    [r_alph, p_alph] = corr(agelist,alplist);
    scatter(agelist,alplist);
    title([Layers{iLay} ' alpha r=' num2str(round(r_alph,2,'significant'))...
        ' p=' num2str(round(p_alph,2,'significant'))])

    nexttile
    [r_thet, p_thet] = corr(agelist,thelist);
    scatter(agelist,thelist);
    title([Layers{iLay} ' theta r=' num2str(round(r_thet,2,'significant'))...
        ' p=' num2str(round(p_thet,2,'significant'))])

    nexttile
    [r_delt, p_delt] = corr(agelist,dellist);
    scatter(agelist,dellist);
    title([Layers{iLay} ' delta r=' num2str(round(r_delt,2,'significant'))...
        ' p=' num2str(round(p_delt,2,'significant'))])


end % layer

savefig(gcf,[Groups{1} '&' Groups{2} '_' Condition '_' type '_ageCorr'])
