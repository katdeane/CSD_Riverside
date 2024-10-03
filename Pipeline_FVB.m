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
Groups = {'OLD' 'YNG' 'FOS' 'FON' 'FYS' 'FYN' 'FOM' 'FOF' 'FYM' 'FYF'};
Comps = {{'OLD' 'YNG'} {'FOS' 'FON'} {'FYS' 'FYN'} {'FOM' 'FOF'} {'FYM' 'FYF'}};
Subjects = {'ALL'};
% Condition = {'NoiseBurst70'};
Condition = {'NoiseBurst70' 'NoiseBurst80' 'Spontaneous' 'ClickTrain70' 'ClickTrain80' ...
  'Chirp70' 'Chirp80' 'gapASSR70' 'gapASSR80' 'TreatNoiseBurst1' 'TreatgapASSR70' 'TreatgapASSR80' 'TreatNoiseBurst2'}; 
% 'Tonotop y70' 'Tonotopy80' 'TreatTonotopy'


%% Data generation per subject ⊂◉‿◉つ

c_axis = [-0.2 0.2];

% per subject CSD Script
% artifact correction algorithm is triggered by 'Awake' tag
DynamicCSD_AJ(homedir, Condition, Subjects{:}, c_axis, 'Awake')

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iCon = 1:length(Condition)
    disp(['Single traces for subjects ' Condition{iCon}])
    tic
    Avrec_Layers(homedir, Subjects{:}, Condition{iCon}, 'Awake')
    toc
end

%% Group pics (⌐▨_▨)

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

% disp('Producing group-averaged traces for each group')
% for iGro = 1:length(Groups)
%     for iCon = 1:length(Condition)
%         disp(['Group traces for ' Groups{iGro} ' ' Condition{iCon}])
%         tic 
%         Group_Avrec_Stack(homedir, Groups{iGro}, Condition{iCon},'Awake')
%         toc
%     end
% end

%% Group AVREC and layer traces / average peak detection ʕ ◕ᴥ◕ ʔ

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iCon = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iCon}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iCon},'Awake',Subjects{:})
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
params.condList = {'NoiseBurst70' 'NoiseBurst80' 'ClickTrain70' 'ClickTrain80' ...
  'Chirp70' 'Chirp80' 'gapASSR70' 'gapASSR80' 'TreatNoiseBurst1' 'TreatgapASSR70' ...
  'TreatgapASSR80' 'TreatNoiseBurst2'};  %   

% Only run when data regeneration is needed:
runCwtCsd(homedir,Subjects{:},params,'Awake');

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
% PermutationTest_Area(homedir,'Phase',{'OLD' 'YNG'},params,yespermute,'Awake')
for iCo = 1:length(Comps)
    PermutationTest_Area(homedir,'Phase',params,Comps{iCo},yespermute,'Awake')
end

% create .csv with all of the ITPC means per stim presentation/subject/layer
for iCo = 1:length(Comps)
    for iCon = 1:length(params.condList)
        igetITPCmean(homedir,Comps{iCo},params.condList{iCon},'Phase','Awake')
    end
end 

%% ISPC 

% params.condList = {'NoiseBurst70','ClickTrain70','Chirp70','gapASSR70'}; 
% LaminarPhaseLocking(homedir,'OLD',params)
% LaminarPhaseLocking(homedir,'YNG',params)
% params.condList = {'NoiseBurst80','ClickTrain80','Chirp80','gapASSR80'};
% LaminarPhaseLocking(homedir,'OLD',params)
% % figures
% params.condList = {'NoiseBurst70','ClickTrain70','Chirp70','gapASSR70',...
%     'NoiseBurst80','ClickTrain80','Chirp80','gapASSR80'}; 
% interlamPhaseFig(homedir,{'OLD' 'YNG'},params)

%% Pretty up all the figures for straight .png output

% single group pictures
% currently set up for Noise Burst, possible to adjust for others if
% desired
ncolum = 4;
Group_single_CSD(homedir, 'OLD', 'NoiseBurst70',  c_axis, ncolum)
Group_single_CSD(homedir, 'OLD', 'NoiseBurst80',  c_axis, ncolum)
Group_single_CSD(homedir, 'YNG', 'NoiseBurst70',  c_axis, ncolum)

for iGro = 1:length(Groups)
    for iCond = 1:length(Condition)
        CSDorderedfigs(homedir,Groups{iGro},Condition{iCond},[1 21])
    end
end

CondList = {'NoiseBurst70' 'ClickTrain70' 'Chirp70' 'gapASSR70'};
for iCond = 1:length(CondList)
    TracesOLDvYNGfig(homedir, CondList{iCond})
end

for iCo = 2:length(Comps)
    for iCond = 1:length(Condition)
        Tracesorderedfig(homedir, Comps{iCo}, Condition{iCond})
    end
end

for iCo = 1:length(Comps)
    thisComp = [Comps{iCo}{1} 'v' Comps{iCo}{2}];
    CWTorderedfigs(homedir, thisComp, 'ClickTrain70', '40',  [0 0.6], [-0.2 0.2])
    CWTorderedfigs(homedir, thisComp, 'gapASSR70', '3',      [0 0.4], [-0.15 0.15])
    CWTorderedfigs(homedir, thisComp, 'gapASSR70', '5',      [0 0.4], [-0.15 0.15])
    CWTorderedfigs(homedir, thisComp, 'gapASSR70', '7',      [0 0.4], [-0.15 0.15])
    CWTorderedfigs(homedir, thisComp, 'gapASSR70', '9',      [0 0.4], [-0.15 0.15])
    CWTorderedfigs(homedir, thisComp, 'Chirp70', '0',        [0 0.4], [-0.15 0.15])
    CWTorderedfigs(homedir, thisComp, 'NoiseBurst70', '0',   [0 0.7], [-0.25 0.25])
    CWTorderedfigs(homedir, thisComp, 'TreatNoiseBurst1','0',[0 0.7], [-0.25 0.25])
    CWTorderedfigs(homedir, thisComp, 'TreatgapASSR70', '9', [0 0.7], [-0.25 0.25])
    if iCo == 1 || iCo == 2 || iCo == 4
        CWTorderedfigs(homedir, thisComp, 'ClickTrain80', '40', [0 0.6], [-0.2 0.2])
        CWTorderedfigs(homedir, thisComp, 'gapASSR80', '3',     [0 0.4], [-0.15 0.15])
        CWTorderedfigs(homedir, thisComp, 'gapASSR80', '5',     [0 0.4], [-0.15 0.15])
        CWTorderedfigs(homedir, thisComp, 'gapASSR80', '7',     [0 0.4], [-0.15 0.15])
        CWTorderedfigs(homedir, thisComp, 'gapASSR80', '9',     [0 0.4], [-0.15 0.15])
        CWTorderedfigs(homedir, thisComp, 'Chirp80', '0',       [0 0.4], [-0.15 0.15])
        CWTorderedfigs(homedir, thisComp, 'NoiseBurst80', '0',  [0 0.7], [-0.25 0.25])
        CWTorderedfigs(homedir, thisComp, 'TreatgapASSR80', '9',[0 0.7], [-0.25 0.25])
    end
end