% Pipeline - Awake California Mouse Fathers vs Virgins

% notes about study

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
c_axis = ([-0.2 0.2]); % this sets the default scale for all csds

% set consistently needed variables
Groups = {'VMA' 'PMA' };  %'VMA' 'PMA' 
Condition = {'NoiseBurst' 'ShortCall' 'Spontaneous' 'MaskCall' 'ShortCall' ...
      'ClickTrain' 'gapASSR' 'NoiseBurst2pt5Hz' 'PostNoiseBurst'};
% Condition = {'NoiseBurst' 'ShortCall' 'Spontaneous' 'MaskCall' 'ShortCall' ...
%     'Tonotopy' 'ClickTrain' 'gapASSR' 'NoiseBurst2pt5Hz' 'PostNoiseBurst'}; 

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, [-0.2 0.2],'Awake')

%% Sorted figures for visualization

% single subject CSDs
ncolum = 4;
Group_single_CSD(homedir, 'VMA', 'VMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, 'PMA', 'PMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, 'VMA', 'VMA', 'ShortCall',  c_axis, ncolum)
Group_single_CSD(homedir, 'PMA', 'PMA', 'ShortCall',  c_axis, ncolum)

%% TO DO: 

% - Bring in the rest of the pipeline
% - high low stats for noiseburst 2.5
% - normalize to last noiseburst measurement
% - get that line noise filter in there

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% group pics

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST},c_axis,[-50 50],'Awake')
        toc
    end
end

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% Peak Stats

PCal_NoiseBurstStats(homedir,Groups,70)
% PCal_NB_HighLowStats(homedir,Groups,20,50)

PCal_ShortcallStats(homedir,Groups,1:10) % was [1,4,9,13,18]
PCal_ShortHighLowStats(homedir,Groups,7,2) % determined by findPupCallRMS.m for full call (original: 18,16)

% PCal_PupcallStats_Latency(homedir,Groups,[1,18,30,44,60])

% exponential model fits over masking levels
callMaskModelFit(homedir)

%% CWT analysis 

% Output:   Runs CWT analysis using the Wavelet toolbox. 
params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.groups = {'VMA','PMA'}; % for permutation test
params.condList = {'NoiseBurst' 'ShortCall' 'Spontaneous' 'MaskCall' ...
      'ClickTrain' 'gapASSR' 'NoiseBurst2pt5Hz' 'PostNoiseBurst'}; % careful, this variable is edited continuously

% run permutation clustermass analysis
yespermute = 1; % 0 just observed pics, 1 observed pics and perumation test

% Only run when data regeneration is needed:
runCwtCsd(homedir,'PMA',params,'Awake');
runCwtCsd(homedir,'VMA',params,'Awake');

% run once to get each subject's background Time Frequency 
TimeFreqBackground(homedir,params,Groups)

% diff = second group - first group
% params.condList = {'NoiseBurst'}; %'ClickTrain','gapASSR'
PermutationTest_Area(homedir,'Phase',params,{'PMA' 'VMA'},yespermute,'Awake') 

% params.condList = {'ShortCall'}; % needs to be broken down by layers earlier
% PermutationTest_PupcallArea(homedir,'Phase',params,{'PMA' 'VMA'},yespermute,'Awake')

% get the ITPC mean across time
% igetITPCmeanPCal(homedir,{'VMA' 'PMA'},'Phase')
% now plot and test it 
% ITPCmeanfigsPCal(homedir)
% stats
% PCal_PupcallStatsITPC(homedir,'Pupcall_1',[1, 18, 30, 44, 60])
% PCal_Pupcall_HighLowStatsITPC(homedir,[18,48,45,49,53],[7,30,16,31,57])
% PCal_PupcallStatsITPC(homedir,'ClickTrain_5',[1, 5, 10])
% PCal_PupcallStatsITPC(homedir,'gapASSR_2',5)
% PCal_PupcallStatsITPC(homedir,'gapASSR_4',5)
% PCal_PupcallStatsITPC(homedir,'gapASSR_6',5)
% PCal_PupcallStatsITPC(homedir,'gapASSR_8',5)
% PCal_PupcallStatsITPC(homedir,'gapASSR_10',5)
% PCal_PupcallStatsITPC(homedir,'NoiseBurst_20',1)
% PCal_PupcallStatsITPC(homedir,'NoiseBurst_50',1)
% PCal_PupcallStatsITPC(homedir,'NoiseBurst_70',1)
% PCal_NoiseBurst_HighLowStatsITPC(homedir,'20','50')

% runFftCsd(homedir,params,'ShortCall')
runFftCsd(homedir,params,'Spontaneous')
% runFftCsd(homedir,params,'NoiseBurst')
% 
% plotFFT_PCal(homedir,params,'AB','ShortCall') % spont compared to pupcalls
% plotFFT_PCal(homedir,params,'AB','NoiseBurst') % spont compared to noisebursts

%% Subject specific pup call visualization
% single subject with pup calls 
subject = 'VMA12';

ShortPupcallCSD(homedir,subject,[-0.2 0.2]) % having run DynamicCSD
PupcallTraces(homedir,subject) % having run DynamicCSD
PupcallCWT(homedir,subject,params) % having run runCwtCsd
