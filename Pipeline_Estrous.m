% Pipeline - Estrous Comparison Study ~( °٢° )~

% A little description here :D

%% Get started

clear; clc;

% set working directory; change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
elseif exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside'); 
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% set consistently needed variables
Groups = {'DIE' 'PRO' 'FYM'}; % FVB young male
Condition = {'NoiseBurst' 'Spontaneous' 'ClickTrain' 'Chirp' 'gapASSR'}; 

Groups = {'FYM'}; % FVB young male
Condition = {'ClickTrain'}; 
%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, [-0.2 0.2],'Awake')

% per subject Spike Script
% DynamicSpike(homedir, Condition)

% LFP single subject figures
singleLFPfig(homedir, Groups, Condition,[-50 50],'Awake')

%% Group pics (⌐▨_▨)

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)

        disp(['Average CSDs & LFPs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST},[-0.2 0.2],[-50 50],'Awake')
        toc

    end
end

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% Group AVREC and layer traces / average peak detection ʕ ◕ᴥ◕ ʔ

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 3:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end


%% SPECTRAL ANALYSIS %%

%% CWT analysis 

% Output:   Runs CWT analysis using the Wavelet toolbox. 
params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.condList = {'NoiseBurst','ClickTrain','Chirp','gapASSR'}; % subset 'NoiseBurst','ClickTrain','Chirp',
params.groups = {'DIE','PRO','FYM'};

% Only run when data regeneration is needed:
runCwtCsd(homedir,'DIE',params,'Awake');
runCwtCsd(homedir,'PRO',params,'Awake');
runCwtCsd(homedir,'FYM',params,'Awake');

% specifying Power: trials are averaged and then power is taken from
% the complex WT output of runCwtCsd function above. Student's t test
% and Cohen'd d effect size are the stats used for observed and
% permutation difference
% specifying Phase: phase is taken per trial. mwu test and r effect
% size are the stats used
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
yespermute = 1; % 0 just observed pics, 1 observed pics and perumation test
PermutationTest_Area(homedir,'Phase',params,{'DIE','PRO'},yespermute,'Awake')
PermutationTest_Area(homedir,'Phase',params,{'DIE','FYM'},yespermute,'Awake')
PermutationTest_Area(homedir,'Phase',params,{'PRO','FYM'},yespermute,'Awake')

params.condList = {'NoiseBurst'}; 
PermutationTest_Area(homedir,'Power',params,{'DIE','PRO'},yespermute,'Awake')

%% Fast fourier transform of the spontaneous data 
runFftCsd(homedir,params,'Spontaneous')
plotFFT(homedir,params,'Spontaneous','AB')
plotFFT(homedir,params,'Spontaneous','RE')

%% Pretty up some figures

ncolum = 4;
Group_single_CSD(homedir, 'DIE','DIE', 'NoiseBurst',  [-0.2 0.2], ncolum)
Group_single_CSD(homedir, 'PRO','PRO', 'NoiseBurst',  [-0.2 0.2], ncolum)
Group_single_CSD(homedir, 'FYM','FYM', 'NoiseBurst',  [-0.2 0.2], ncolum)

% Group_single_LFP(homedir, 'DIE','DIE', 'NoiseBurst',  [-50 50], ncolum)
% Group_single_LFP(homedir, 'PRO','PRO', 'NoiseBurst',  [-50 50], ncolum)


for iGro = 1:length(Groups)
    for iCond = 1:length(Condition)
        CSDorderedfigs(homedir,Groups{iGro},Condition{iCond},[1 21],'EST')
    end
end

Condition = {'NoiseBurst' 'ClickTrain' 'Chirp' 'gapASSR'}; 
for iCond = 1:length(Condition)
    TracesEstrousfig(homedir, Condition{iCond})
end

% run a permutation test and save the output results (no figures)
% permtest_PAC(homedir,'CSD')
CWTorderedfigs(homedir, 'DIEvPRO', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvPRO', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'EST')

CWTorderedfigs(homedir, 'DIEvFYM', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'DIEvFYM', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'EST')

CWTorderedfigs(homedir, 'PROvFYM', 'gapASSR', '3',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'gapASSR', '5',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'gapASSR', '7',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'gapASSR', '9',      [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'ClickTrain', '40',  [0 0.6], [-0.2 0.2],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'Chirp', '0',        [0 0.4], [-0.15 0.15],'EST')
CWTorderedfigs(homedir, 'PROvFYM', 'NoiseBurst', '0',   [0 0.7], [-0.25 0.25],'EST')


