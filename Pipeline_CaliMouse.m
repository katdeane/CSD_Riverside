%% Pipeline California Mouse response to pup calls

clear; clc;

% set working directory; change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
elseif exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside'); 
elseif exist('D:\GitHub\CSD_Riverside', 'dir')
    cd('D:\GitHub\CSD_Riverside');
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% set consistently needed variables
Groups = {'VMP' 'PMP'}; % 'PMP' 'VMP' virgin male pupcall & parent male pupcall
% Condition = {'Pupcall30'};
Condition = {'NoiseBurst' 'Spontaneous' 'Pupcall30' 'PostNoiseBurst' 'ClickTrain' 'gapASSR' 'Chirp'};
cbar = [-0.3 0.3]; % species specific based on experience, color axis

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% something was off with PMP09's pup call measurement and it needed to be
% resampled just a tiny bit. Concerning...
DynamicCSD(homedir, Condition, Groups, cbar, 'Anesthetized')

% special cases if you rerun the DynamicCSD, run this too
% Note that this does not adjust RELRES (if you ever want to use it)
SpecialPCals(homedir)

%% trial-averaged AVREC and layer trace generation / peak detection ┏ʕ •ᴥ•ʔ┛

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Single traces for ' Groups{iGro} ' ' Condition{iST}])
        tic
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST},'Anesthetized')
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
%         StrengthxTime(homedir, Groups{iGro}, Condition{iST},'Anesthetized')
%         toc
%     end
% end

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

%% Peak Stats

PCal_NoiseBurstStats(homedir,Groups,20)
PCal_NoiseBurstStats(homedir,Groups,50)
PCal_NoiseBurstStats(homedir,Groups,70)
PCal_NB_HighLowStats(homedir,Groups,20,50)


PCal_ClickTrainStats5(homedir,Groups)
% PCal_ClickTrainStats40(homedir,Groups)

% careful re-running the stats, all peak amps taken rather than just 5
% targets
PCal_PupcallStats(homedir,Groups,[1,18,29,44,60]) % was [1,4,9,13,18]
PCal_HighLowStats(homedir,Groups,[18,48,45,49,53],[7,30,16,31,57]) % determined by findPupCallRMS.m

%% mTF analysis

% Input:    group metadata file in /groups and curate converted files in
%           /data that correspond to pup call (30 dB att) measurements
% Output:   Cross validation, trained model, and predicted data figures for
%           each subject. Stat data, error and pearson's r for full
%           multiTRF, low broadband and high broadband TRF models. 
% Pipeline_mTRF(homedir,Groups)

%% CSD permutation analysis 
% Condition = {'NoiseBurst' 'Pupcall30' 'ClickTrain'};
for iSti = 1:length(Condition)
    PermutationTest_CSDArea(homedir,Condition{iSti},Groups,1,'Anesthetized')
end

%% CWT analysis 

% Output:   Runs CWT analysis using the Wavelet toolbox. 
params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.groups = {'VMP','PMP'}; % for permutation test
params.condList = {'NoiseBurst'}; % careful, this variable is edited continuously

% run permutation clustermass analysis
yespermute = 1; % 0 just observed pics, 1 observed pics and perumation test

% Only run when data regeneration is needed:
runCwtCsd(homedir,'PMP',params,'Anesthetized');
runCwtCsd(homedir,'VMP',params,'Anesthetized');

% run once to get each subject's background Time Frequency 
TimeFreqBackground(homedir,params,Groups)

% diff = second group - first group
params.condList = {'ClickTrain','gapASSR','NoiseBurst'}; %'ClickTrain','gapASSR'
PermutationTest_Area(homedir,'Phase',params,{'PMP' 'VMP'},yespermute,'Anesthetized') 

params.condList = {'Pupcall'}; % needs to be broken down by layers earlier
PermutationTest_PupcallArea(homedir,'Phase',params,{'PMP' 'VMP'},yespermute,'Anesthetized')

delete(gcp('nocreate')) % end this par session

% get the ITPC mean across time
igetITPCmeanPCal(homedir,{'VMP' 'PMP'},'Phase')
% now plot and test it 
ITPCmeanfigsPCal(homedir)
% stats
PCal_PupcallStatsITPC(homedir,'Pupcall_1',[1, 18, 30, 44, 60])
PCal_Pupcall_HighLowStatsITPC(homedir,[18,48,45,49,53],[7,30,16,31,57])
PCal_PupcallStatsITPC(homedir,'ClickTrain_5',[1, 5, 10])
PCal_PupcallStatsITPC(homedir,'gapASSR_2',5)
PCal_PupcallStatsITPC(homedir,'gapASSR_4',5)
PCal_PupcallStatsITPC(homedir,'gapASSR_6',5)
PCal_PupcallStatsITPC(homedir,'gapASSR_8',5)
PCal_PupcallStatsITPC(homedir,'gapASSR_10',5)
PCal_PupcallStatsITPC(homedir,'NoiseBurst_20',1)
PCal_PupcallStatsITPC(homedir,'NoiseBurst_50',1)
PCal_PupcallStatsITPC(homedir,'NoiseBurst_70',1)
PCal_NoiseBurst_HighLowStatsITPC(homedir,'20','50')

% correlate gap ASSR results with loud and quiet calls and noise
gapASSRcorr_ITPCmean(homedir,Groups,[18,48,45,49,53],[7,30,16,31,57])

%% Fast fourier transform of the spontaneous data 
runFftCsd(homedir,params,'Pupcall')
% plotFFT(homedir,params,'Pupcall','AB')
% plotFFT(homedir,params,'Pupcall','RE')

runFftCsd(homedir,params,'Spontaneous')
% plotFFT(homedir,params,'Spontaneous','AB')
% plotFFT(homedir,params,'Spontaneous','RE')

runFftCsd(homedir,params,'ClickTrain')
runFftCsd(homedir,params,'NoiseBurst')

plotFFT_PCal(homedir,params,'AB','Pupcall') % spont compared to pupcalls
plotFFT_PCal(homedir,params,'AB','ClickTrain') % spont compared to clicks (CURRENTLY 5 HZ)
plotFFT_PCal(homedir,params,'AB','NoiseBurst') % spont compared to noisebursts
% plotFFT_PCal(homedir,params,'RE')

% Analysis of covariance to determine if age or group is predictor
% AnCoVaFFT_PCal(homedir,params,'AB','ClickTrain')
% AnCoVaFFT_PCal(homedir,params,'AB','Pupcall')

%% Correlate age with FFT data
agecorr_FFT(homedir,Groups,'Spontaneous','AB')

%% Subject specific pup call visualization
subject = 'PMP09';

PupcallCSD(homedir,subject,cbar) % having run DynamicCSD
PupcallTraces(homedir,subject) % having run DynamicCSD
PupcallCWT(homedir,subject,params) % having run runCwtCsd

%% Average group pup call visualization

% GroupPupcallCSD(homedir,'VMP',cbar,'Anesthetized') % having run DynamicCSD
GroupPupcallTraces(homedir,'VMP','Anesthetized',[1, 18, 30, 44, 60]) % having run Avrec_Layers
% GroupPupcallCWT(homedir,'VMP',params) % having run runCwtCsd

% GroupPupcallCSD(homedir,'PMP',cbar,'Anesthetized') % having run DynamicCSD
GroupPupcallTraces(homedir,'PMP','Anesthetized',[1, 18, 30, 44, 60]) % having run Avrec_Layers
% GroupPupcallCWT(homedir,'PMP',params) % having run runCwtCsd

cutPupcallFig(homedir,[1, 18, 30, 44, 60], [1 5 10])
cutPupcall(homedir,[1, 18, 30, 44, 60])
% get the high and low figs
cutPupcallFig(homedir,[18,48,45,49,53,7,30,16,31,57],[])
