% Pipeline - FMR1 Comparison Study ~( °٢° )~

% This is the master script for the FMR1 KO and WT study, run by Katrina
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
elseif exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside'); 
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% set consistently needed variables
Groups = {'MWT'}; %'MKO' 
% Condition = {'ClickTrain'};
Condition = {'NoiseBurst' 'Tonotopy' 'Spontaneous' 'ClickTrain' 'Chirp' ...
    'gapASSR' 'postNoise' 'postSpont'};

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
DynamicCSD(homedir, Condition, [-0.2 0.2])

% per subject Spike Script
% DynamicSpike(homedir, Condition)

%% Group pics (⌐▨_▨)

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST})
        toc
    end
end

% generate group averaged spike heatmaps based on stimuli (does not BF sort)
% for iGro = 1:length(Groups)
%     for iST = 1:length(Condition)
%         disp(['Average Heatmaps for ' Groups{iGro} ' ' Condition{iST}])
%         tic
%         AvgSpikefig(homedir, Groups{iGro}, Condition{iST})
%         toc
%     end
% end


%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST})
        toc
    end
end

%% Group AVREC and layer traces / average peak detection ʕ ◕ᴥ◕ ʔ

% to do: some stackedgroup concatonation not working (spont and gapASSR 6
% ms)

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iST})
        toc
    end
end

%% Determine strength of response over EACH trial 

% this is specifically to explore temporal dynamics over recording day and
% uses single trial peak detection CSVs created by Avrec_Layers.m

disp('Determining cortical strength over time')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['For ' Groups{iGro} ' ' Condition{iST}])
        tic 
        StrengthxTime(homedir, Groups{iGro}, Condition{iST})
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
params.condList = {'NoiseBurst','ClickTrain','Chirp','gapASSR'}; % subset
params.groups = {'MWT','MKO'}; % for permutation test

% Only run when data regeneration is needed:
runCwtCsd(homedir,'MWT',params);
% runCwtCsd(homedir,'MKO',params);

% specifying Power: trials are averaged and then power is taken from
% the complex WT output of runCwtCsd function above. Student's t test
% and Cohen'd d effect size are the stats used for observed and
% permutation difference
% specifying Phase: phase is taken per trial. mwu test and r effect
% size are the stats used
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
yespermute = 0; % 0 just observed pics, 1 observed pics and perumation test
parpool(4) % 4 workers in an 8 core machine with 64 gb ram (16 gb each)
PermutationTest(homedir,'Power',params,yespermute)
PermutationTest(homedir,'Phase',params,yespermute)
delete(gcp('nocreate')) % end this par session

%% Fast fourier transform of the spontaneous data 
runFftCsd(homedir,params)
plotFFT(homedir,params)

%% Interlaminar Phase Coherence
LaminarPhaseLocking(homedir,params)
interlamPhaseFig(homedir,params)

%% Phase amplitude coupling

% % it's been a while
Groups = {'MWT','MWT'}; %'MKO' 
Condition = {'NoiseBurst' 'Spontaneous' 'ClickTrain' 'Chirp' 'gapASSR'};

% based on code from Francisco Garcia-Rosales from https://doi.org/10.1111/ejn.14986
disp('CSD Phase Amplitude Coupling Analysis')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Phase Amp coupling for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        runPAC(homedir, Groups{iGro}, Condition{iST}, 'CSD')
        toc
    end
end

% save all of the visual data output and some data files
for iST = 1:length(Condition)
    disp(['Phase Amp coupling figures for ' Condition{iST}])
    tic
    visualize_PAC(homedir,Groups, Condition{iST}, 'CSD')
    toc
end



% run a permutation test and save the output results (no figures)
permtest_PAC(homedir,'CSD')
