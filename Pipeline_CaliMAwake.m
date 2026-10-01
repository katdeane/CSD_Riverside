% Pipeline - Awake California Mouse Fathers vs Virgins

% notes about study

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
c_axis = ([-0.2 0.2]); % this sets the default scale for all csds

% output folders now specified for each analysis (to keep my sanity)
figfold = [homedir '\figures\CaliAwake'];
outfold = [homedir '\output\CaliAwake'];
if ~exist(figfold, 'dir')
    mkdir(figfold); mkdir(outfold);
end

% set consistently needed variables
Groups = {'VMA' 'PMA'};  %'VMA' 'PMA' 
% Condition = {'MaskCall'};
Condition = {'NoiseBurst' 'ShortCall' 'Spontaneous' 'MaskCall'  ...
    'Tonotopy' 'ClickTrain' 'gapASSR' 'NoiseBurst2pt5Hz'}; 

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, figfold, Condition, Groups, [-0.2 0.2],'Awake')

%% Sorted figures for visualization

% single subject CSDs
ncolum = 4;
Group_single_CSD(homedir, figfold, 'VMA', 'VMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, figfold, 'PMA', 'PMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, figfold, 'VMA', 'VMA', 'PostNoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, figfold, 'PMA', 'PMA', 'PostNoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, figfold, 'VMA', 'VMA', 'ShortCall',  c_axis, ncolum)
Group_single_CSD(homedir, figfold, 'PMA', 'PMA', 'ShortCall',  c_axis, ncolum)


%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic
        Avrec_Layers(homedir, figfold, outfold, Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

% normalization of traces: 
disp('Running Normalization of Peak Data and Traces')
for iST = 1:length(Condition)
    if matches(Condition{iST},'Spontaneous')
        continue
    end
    disp(Condition{iST})
    Norm_AvrecDat(homedir, figfold, outfold, Groups, Condition{iST})
end

%% group pics

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, figfold, Groups{iGro}, Condition{iST},c_axis,[-50 50],'Awake')
        toc
    end
end

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir,figfold,outfold,Groups{iGro}, Condition{iST},'Awake')
        toc
    end
end

%% Peak Stats

% peak stats in R now
% generate tables where responses are normalized to the peak / first
% response
ClickTrainRatio(homedir,outfold,Groups)
NB2pt5HzRatio(homedir,outfold,Groups)
MaskCallRatio(homedir,outfold,Groups)
ShortCallRatio(homedir,outfold,Groups)

% generate table where responses to mask levels 1-3 are normalized by mask
% level 0
MaskCallMaskNorm(homedir,outfold,Groups)

% exponential model fits over masking levels
callMaskModelFit_NoNorm(homedir,outfold)
callMaskModelFit_NoiseNorm(homedir,outfold)
callMaskModelFit_BaseNorm(homedir,outfold)

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
params.condList = {'NoiseBurst' 'ShortCall' 'MaskCall' ...
      'ClickTrain' 'gapASSR' 'NoiseBurst2pt5Hz' 'PostNoiseBurst'};
PermutationTest_Area(homedir,figfold,'Phase',params,{'PMA' 'VMA'},yespermute,'Awake') 

% params.condList = {'ShortCall'}; % needs to be broken down by layers earlier
% PermutationTest_PupcallArea(homedir,'Phase',params,{'PMA' 'VMA'},yespermute,'Awake')

% get the ITPC mean across time
for iGro = 1:length(Groups)
        igetITPCmean(homedir,outfold,Groups(iGro),'NoiseBurst','Phase','Awake')
        igetITPCmean(homedir,outfold,Groups(iGro),'Spontaneous','Phase','Awake')
        igetITPCmean(homedir,outfold,Groups(iGro),'ClickTrain','Phase','Awake')
        igetITPCmean(homedir,outfold,Groups(iGro),'gapASSR','Phase','Awake')

        igetITPCmeanPCal(homedir,outfold,Groups(iGro),'ShortCall','Phase','Awake')
        igetITPCmeanPCal(homedir,outfold,Groups(iGro),'MaskCall','Phase','Awake')
        igetITPCmeanPCal(homedir,outfold,Groups(iGro),'NoiseBurst2pt5Hz','Phase','Awake')
end 

ITPC_MaskNorm(homedir,outfold,Groups)
% igetITPCmeanPCal(homedir,outfold,{'VMA' 'PMA'},'Phase')
% now plot and test it 
% ITPCmeanfigsPCal(homedir)
% stats

% plot difference ITPC difference figs
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'gapASSR', '3',          [0 3.5], [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'gapASSR', '5',          [0 3.5], [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'gapASSR', '7',          [0 3.5], [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'gapASSR', '9',          [0 3.5], [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'ClickTrain', '5',       [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'NoiseBurst', '0',       [0 6],   [-2 2],    'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'ShortCall', '0',        [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'MaskCall', '0',         [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'MaskCall', '1',         [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'MaskCall', '2',         [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'MaskCall', '3',         [0 5],   [-1.5 1.5],'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'NoiseBurst2pt5Hz','70', [0 6],   [-2 2],    'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'NoiseBurst2pt5Hz','50', [0 6],   [-2 2],    'PCal')
CWTorderedfigs(homedir, figfold, 'PMAvVMA', 'NoiseBurst2pt5Hz','20', [0 6],   [-2 2],    'PCal')

%% FFT 
runFftCsd(homedir,outfold,params,'ShortCall','Awake') 
runFftCsd(homedir,outfold,params,'Spontaneous','Awake')
runFftCsd(homedir,outfold,params,'ClickTrain','Awake') % just 5 Hz trains
runFftCsd(homedir,outfold,params,'NoiseBurst','Awake')
runFftCsd(homedir,outfold,params,'MaskCall','Awake') % just 0 mask level
% 
plotFFT_PCal(homedir,figfold,outfold,params,'AB','ShortCall') 
plotFFT_PCal(homedir,figfold,outfold,params,'AB','MaskCall') 
plotFFT_PCal(homedir,figfold,outfold,params,'AB','NoiseBurst') 
plotFFT_PCal(homedir,figfold,outfold,params,'AB','ClickTrain') 

%% Subject specific pup call visualization
% single subject with pup calls 
subject = 'VMA12';

ShortPupcallCSD(homedir,subject,[-0.2 0.2]) % having run DynamicCSD
PupcallTraces(homedir,subject) % having run DynamicCSD
PupcallCWT(homedir,subject,params) % having run runCwtCsd
