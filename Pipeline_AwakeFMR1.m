% Pipeline - Awake FMR1 Comparison Study ~( °٢° )~

% This is the master script for the awake FMR1 KO and WT study, run by Katrina
% Deane at University of California, Riverside in Khaleel Razak's lab in
% the Psychology Department. 

% The overall goal of this study is to characterize A1 laminar differences
% between groups. FMR1 KOs have auditory hypersensitivity and in vitro it
% was found that their layer 2/3 and 5 were more synchronized in response
% to stimulation in layer 2/3 specifically (Goswami 2019, Neurobiol Dis)

%% Get started

clear; clc;

% set working directory; change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
elseif exist('E:\CSD_Riverside','dir')
    cd('E:\CSD_Riverside'); 
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% output folders now specified for each analysis (to keep my sanity)
figfold = [homedir '\figures\Fmr1Awake'];
outfold = [homedir '\output\Fmr1Awake'];
if ~exist(figfold, 'dir')
    mkdir(figfold); mkdir(outfold);
end

% set consistently needed variables
Groups = {'AWT' 'AKO' 'CKH'};  %'AWT' 'AKO' 'CKH'
% Condition = {'NoiseBurst'};
Condition = {'NoiseBurst' 'Spontaneous' 'ClickTrain' 'Chirp' ...
    'gapASSR' 'postNoiseBurst'};
% resultant CSD color map axis:ar
c_axis = [-0.2 0.2]; 

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, figfold, Condition, Groups, c_axis,'Awake')

% LFP single subject figures
singleLFPfig(homedir, figfold, Groups, Condition,[-50 50],'Awake')

%% Group pics (⌐▨_▨)

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)

        disp(['Average CSDs & LFPs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, figfold, Groups{iGro}, Condition{iST},c_axis,[-50 50],'Awake')
        toc

    end
end

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Avrec_Layers(homedir, figfold, outfold, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% Group AVREC and layer traces / average peak detection ʕ ◕ᴥ◕ ʔ

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir, figfold, outfold, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% Peak and RMS statistics - this will be deleted when the figure output from R is good to go

% NoiseBurstStats_3grp(homedir,Groups,70)
% ClickTrainStats_3grp(homedir,Groups)
% gapASSRStats_3grp(homedir,Groups)

% t tests between subject-wise coefficients of variance
% NoiseBurstStats_CV(homedir,Groups,70)
% ClickTrainStats_CV(homedir,Groups)
% gapASSRStats_CV(homedir,Groups)

%% Determine strength of response over EACH trial - only as needed

% this is specifically to explore temporal dynamics over recording day and
% uses single trial peak detection CSVs created by Avrec_Layers.m
% 
% disp('Determining cortical strength over time')
% for iGro = 1:length(Groups)
%     for iST = 1:length(Condition)
%         disp(['For ' Groups{iGro} ' ' Condition{iST}])
%         tic 
%         StrengthxTime(homedir, Groups{iGro}, Condition{iST})
%         toc
%     end
% end

%% SPECTRAL ANALYSIS %%

%% CWT analysis 

% Output:   Runs CWT analysis using the Wavelet toolbox. 
params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.condList = {'NoiseBurst' 'ClickTrain','gapASSR' 'Chirp'}; % subset 
params.groups = {'AWT','AKO','CKH'}; % for permutation test

% Only run when data regeneration is needed:
runCwtCsd(homedir,'AWT',params,'Awake');
runCwtCsd(homedir,'AKO',params,'Awake');
runCwtCsd(homedir,'CKH',params,'Awake');

% specifying Power: trials are averaged and then power is taken from
% the complex WT output of runCwtCsd function above. 
% specifying Phase: phase is taken per trial and inter-trial phase
% coherence is calculated 
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
yespermute = 1; % 0 just observed pics, 1 observed pics and perumation test
PermutationTest_Area(homedir,figfold,'Phase',params,{'AWT','AKO'},yespermute,'Awake')
PermutationTest_Area(homedir,figfold,'Phase',params,{'AWT','CKH'},yespermute,'Awake')
PermutationTest_Area(homedir,figfold,'Phase',params,{'CKH','AKO'},yespermute,'Awake')

% create .csv with all of the ITPC means per stim presentation/subject/layer
for iGro = 1:length(Groups)
    for iCon = 1:length(params.condList)
        igetITPCmean(homedir,outfold,Groups{iGro},params.condList{iCon},'Phase','Awake')
    end
end 

%% Fast fourier transform of the spontaneous data 
runFftCsd(homedir,params,'Spontaneous')
plotFFT_3grp(homedir,figfold,outfold,params,'Spontaneous','RE')

% for the LFP side
% runFftLfp(homedir,params,'Spontaneous')
% plotFFTLfp(homedir,params,'Spontaneous','RE')

%% Interlaminar Phase Coherence
% LaminarPhaseLocking(homedir,'AKO',params)
% interlamPhaseFig(homedir,'AKO',params)
% 
% LaminarPhaseLocking(homedir,'AWT',params)
% interlamPhaseFig(homedir,'AWT',params)
% 
% LaminarPhaseLocking(homedir,'CKH',params)
% interlamPhaseFig(homedir,'CKH',params)

%% Pretty up some figures

ncolum = 4;
Group_single_CSD(homedir,figfold, 'AWT', 'AWT', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir,figfold, 'AKO', 'AKO', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir,figfold, 'CKH', 'CKH', 'NoiseBurst',  c_axis, ncolum)

ncolum = 4;
Group_single_CSD(homedir,figfold, 'AWT', 'AWT', 'Spontaneous',  c_axis, ncolum)
Group_single_CSD(homedir,figfold, 'AKO', 'AKO', 'Spontaneous',  c_axis, ncolum)
Group_single_CSD(homedir,figfold, 'CKH', 'CKH', 'Spontaneous',  c_axis, ncolum)

CWTFigs(homedir,figfold,'Phase',params,'AWT','Awake')
CWTFigs(homedir,figfold,'Phase',params,'AKO','Awake')
CWTFigs(homedir,figfold,'Phase',params,'CKH','Awake')

Group_single_CWT(homedir,figfold, 'AWT', 'NoiseBurst',  [0 0.7])
Group_single_CWT(homedir,figfold, 'AWT', 'ClickTrain',  [0 0.7])
Group_single_CWT(homedir,figfold, 'AKO', 'NoiseBurst',  [0 0.7])
Group_single_CWT(homedir,figfold, 'AKO', 'ClickTrain',  [0 0.7])
Group_single_CWT(homedir,figfold, 'CKH', 'NoiseBurst',  [0 0.7])
Group_single_CWT(homedir,figfold, 'CKH', 'ClickTrain',  [0 0.7])

for iGro = 1:length(Groups)
    for iCond = 1:length(Condition)
        CSDorderedfigs(homedir,figfold,Groups{iGro},Condition{iCond},[1 21],'FMR1')
    end
end

for iCond = 1:length(Condition)
    Tracesorderedfig_3grp(homedir, figfold, Groups, Condition{iCond},'FMR1')
end

Tracesorderedfig_3grp_zoomed(homedir,figfold,Groups,'FMR1')

% run a permutation test and save the output results (no figures)
% permtest_PAC(homedir,'CSD')
CWTorderedfigs(homedir, 'AWTvAKO', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'ClickTrain', '5',   [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'FMR1')
CWTorderedfigs(homedir, 'AWTvAKO', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'FMR1')

CWTorderedfigs(homedir, 'AWTvCKH', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'ClickTrain', '5',   [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'FMR1')
CWTorderedfigs(homedir, 'AWTvCKH', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'FMR1')

CWTorderedfigs(homedir, 'CKHvAKO', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'ClickTrain', '5',   [0 0.6], [-0.2 0.2],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'FMR1')
CWTorderedfigs(homedir, 'CKHvAKO', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'FMR1')

%% StatsoutforR - project specific
prepDataforStatsAwakeFmr1(homedir,outfold)


%% %% %% ADDITIONALLY %% %% %%
% I'd like to get some quantification on the urethane anesthetized vs awake
% data for the Fmr1 groups, KO and WT. 

Groups = {'AWT' 'AKO' 'MWT' 'MKO'}; % a for awake, m for anesthetized
M_Groups = {'MWT' 'MKO'};
Condition = {'NoiseBurst' 'Spontaneous' 'ClickTrain'};

% get all the data for just these anesthetized groups
DynamicCSD(homedir, figfold, Condition, M_Groups, c_axis,'Awake')
for iGro = 1:length(M_Groups)
    for iST = 1:length(Condition)
        AvgCSDfig(homedir, figfold, M_Groups{iGro}, Condition{iST},c_axis,[-50 50],'Awake')
        Avrec_Layers(homedir, figfold, outfold, M_Groups{iGro}, Condition{iST},'Awake')
        Group_Avrec_Layers(homedir, figfold, outfold, M_Groups{iGro}, Condition{iST},'Awake')
    end
end

params.condList = {'NoiseBurst' 'ClickTrain'}; % subset 
params.groups = {'AWT' 'AKO' 'MWT' 'MKO'}; % for permutation test

runCwtCsd(homedir,'MWT',params,'Awake');
runCwtCsd(homedir,'MKO',params,'Awake');
runFftCsd(homedir,params,'Spontaneous')

yespermute = 1; % 0 just observed pics, 1 observed pics and perumation test
PermutationTest_Area(homedir,figfold,'Phase',params,{'AWT','MWT'},yespermute,'Awake')
PermutationTest_Area(homedir,figfold,'Phase',params,{'AKO','MKO'},yespermute,'Awake')

% create .csv with all of the ITPC means per stim presentation/subject/layer
for iGro = 1:length(M_Groups)
    for iCon = 1:length(params.condList)
        igetITPCmean(homedir,outfold,M_Groups{iGro},params.condList{iCon},'Phase','Awake')
    end
end 

plotFFT_4grp(homedir,params,'Spontaneous','RE')
