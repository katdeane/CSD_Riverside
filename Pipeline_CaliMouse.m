%% Pipeline California Mouse response to pup calls

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
Groups = {'PMP' 'VMP'}; % 'PMP' 'VMP' virgin male pupcall & parent male pupcall
% Condition = {'NoiseBurst'};
Condition = {'NoiseBurst' 'Spontaneous' 'Pupcall30' 'PostNoiseBurst' 'ClickTrain' 'gapASSR' 'Chirp' 'Tonotopy'};
cbar = [-0.3 0.3]; % species specific based on experience, color axis

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
DynamicCSD(homedir, Condition, Groups, cbar, 'Anesthetized')

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Anesthetized')
        toc
    end
end

%% group pics

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST},cbar,[-50 50],'Anesthetized')
        toc
    end
end


% to do: some stackedgroup concatonation not working (spont and gapASSR 6
% ms)

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Group traces for ' Groups{iGro} ' ' Condition{iST}])
        tic 
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Anesthetized')
        toc
    end
end

%% Determine strength of response over EACH trial 

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

%% mTF analysis 

% Input:    group metadata file in /groups and curate converted files in
%           /data that correspond to pup call (30 dB att) measurements
% Output:   Cross validation, trained model, and predicted data figures for
%           each subject. Stat data, error and pearson's r for full
%           multiTRF, low broadband and high broadband TRF models. 
Pipeline_mTRF(homedir,Groups)

%% CWT analysis 

% Output:   Runs CWT analysis using the Wavelet toolbox. 
params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.condList = {'ClickTrain','gapASSR'}; % 'Pupcall', - gives out of memory error for pup call now (7 and 8 subjects)
params.groups = {'PMP','VMP'}; % for permutation test

% Only run when data regeneration is needed:
runCwtCsd(homedir,'PMP',params,'Anesthetized');
runCwtCsd(homedir,'VMP',params,'Anesthetized');

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
if yespermute == 1; parpool(4); end % 4 workers in an 8 core machine with 64 gb ram (16 gb each)
% PermutationTest(homedir,'Power',params,yespermute,'Anesthetized')
% PermutationTest(homedir,'Phase',params,yespermute,'Anesthetized')
PermutationTest_Area(homedir,'Phase',params,{'PMP' 'VMP'},yespermute,'Anesthetized')
delete(gcp('nocreate')) % end this par session


%% Fast fourier transform of the spontaneous data 
runFftCsd(homedir,params,'Pupcall')
plotFFT(homedir,params,'Pupcall')

runFftCsd(homedir,params,'Spontaneous')
plotFFT(homedir,params,'Spontaneous')

%% Interlaminar Phase Coherence
% LaminarPhaseLocking(homedir,params)
% interlamPhaseFig(homedir,params)

%% Subject specific pup call visualization
subject = 'PMP03';

PupcallCSD(homedir,subject,cbar) % having run DynamicCSD
PupcallTraces(homedir,subject) % having run DynamicCSD
PupcallCWT(homedir,subject,params) % having run runCwtCsd

%% Average group pup call visualization

GroupPupcallCSD(homedir,'VMP',cbar,'Anesthetized') % having run DynamicCSD
GroupPupcallTraces(homedir,'VMP','Anesthetized') % having run Avrec_Layers
GroupPupcallCWT(homedir,'VMP',params) % having run runCwtCsd

GroupPupcallCSD(homedir,'PMP',cbar,'Anesthetized') % having run DynamicCSD
GroupPupcallTraces(homedir,'PMP','Anesthetized') % having run Avrec_Layers
GroupPupcallCWT(homedir,'PMP',params) % having run runCwtCsd


