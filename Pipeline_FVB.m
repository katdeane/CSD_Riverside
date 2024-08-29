% Pipeline - FVB Aging and Nicotine Study 

% This is the master script for the FVB young and old / nicotine and saline 
% study run by Anjum Hussain and Data analysis by Katrina Deane at 
% University of California, Riverside in Khaleel Razak's lab in
% the Psychology Department. 

% The overall goal of this study is to characterize A1 laminar differences
% between groups. Natural aging is often accompanied by reduced hearing and
% reduced discrimination of target sounds in noise. Nicotine has been
% explored as a potential treatment to reduce age affects of hearing loss.

%% Get started

clear; clc;

% set working directory; change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
elseif exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside'); 
elseif exist('/Users/anjumhussain/Documents/GitHub/CSD_Riverside','dir')
    cd('/Users/anjumhussain/Documents/GitHub/CSD_Riverside')
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% set consistently needed variables
% F = FVB, O = old, Y = young, N = nicotine, S = saline 
% Groups = {'FirstPass'};
Groups = {'OLD' 'YNG'};
% Condition = {'gapASSR70' 'gapASSR80'};
Condition = {'NoiseBurst70' 'NoiseBurst80' 'Spontaneous' 'ClickTrain70' 'ClickTrain80' ...
   'Chirp70' 'Chirp80' 'gapASSR70' 'gapASSR80' 'Tonotopy70' 'Tonotopy80' };
    %'TreatNoiseBurst1' 'TreatgapASSR70' 'TreatgapASSR80' 'TreatTonotopy' 'TreatNoiseBurst2'


%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% artifact correction algorithm is triggered by 'Awake' tag
DynamicCSD_AJ(homedir, Condition, Groups, [-0.2 0.2], 'Awake')

%% Group pics (⌐▨_▨)
Condition = {'gapASSR70' 'gapASSR80'};
% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iCon = 1:length(Condition)

        disp(['Average CSDs & LFPs for ' Groups{iGro} ' ' Condition{iCon}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iCon},[-0.2 0.2],[-50 50],'Awake')
        toc

    end
end

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iCon = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iCon}])
        tic 
        Avrec_Layers(homedir, Groups{iGro}, Condition{iCon}, 'Awake')
        toc
    end
end

ConditionList = {'gapASSR70'}; %'NoiseBurst70' 'ClickTrain70' 
disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iCon = 1:length(ConditionList)
        disp(['Group traces for ' Groups{iGro} ' ' ConditionList{iCon}])
        tic 
        Group_Avrec_Stack(homedir, Groups{iGro}, ConditionList{iCon},'Awake')
        toc
    end
end

%% Group AVREC and layer traces / average peak detection ʕ ◕ᴥ◕ ʔ

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iCon = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iCon}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iCon},'Awake')
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
params.condList = {'gapASSR80'};
% params.condList = {'NoiseBurst70','ClickTrain70','Chirp70','gapASSR70'};  
% params.groups = {'FOS' 'FON' 'FYS' 'FYN'}; 
params.groups = {'OLD' 'YNG'};

% Only run when data regeneration is needed:
% runCwtCsd(homedir,'FOS',params,'Awake');
% runCwtCsd(homedir,'FON',params,'Awake');
% runCwtCsd(homedir,'FYS',params,'Awake');
% runCwtCsd(homedir,'FYN',params,'Awake');

runCwtCsd(homedir,'OLD',params,'Awake');
runCwtCsd(homedir,'YNG',params,'Awake');

% Just individual inter-trial phase coherence figures
% CWTFigs(homedir,'Phase',params,'OLD','Awake')

% specifying Power: trials are averaged and then power is taken from
% the complex WT output of runCwtCsd function above. Student's t test
% and Cohen'd d effect size are the stats used for observed and
% permutation difference
% specifying Phase: phase is taken per trial. Student's t test and Cohen's
% d effect size are the stats used for observation and permutation 
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
yespermute = 0; % 0 just observed pics, 1 observed pics and perumation test
% if yespermute == 1; parpool(4); end % 4 workers in an 8 core machine with 64 gb ram (16 gb each)
% PermutationTest_Area(homedir,'Phase',params,yespermute,'Awake')
% PermutationTest_Area(homedir,'Phase',params,yespermute,'Awake')

PermutationTest_Area(homedir,'Phase',params,yespermute,'Awake')

% create .csv with all of the ITPC means per stim presentation/subject/layer
for iCon = 1:length(params.condList)
    igetITPCmean(homedir,params.groups,params.condList{iCon},'Phase','Awake')
end
