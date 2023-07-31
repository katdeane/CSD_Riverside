% Pipeline - FMR1 Comparison Study 

clear; clc;
% change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
% elseif exist('C:\Users\RazakLab\Documents\CSD_Riverside','dir')
%     cd('C:\Users\RazakLab\Documents\CSD_Riverside')
elseif exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside'); 
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));

% set consistently needed variables
Groups = {'MKO' 'MWT'};
% Condition = {'Tonotopy'};
Condition = {'NoiseBurst' 'Tonotopy' 'Spontaneous' 'ClickTrain' 'Chirp' ...
    'gapASSR' 'postNoise' 'postSpont'};

%% Data generation per subject

% per subject CSD Script
DynamicCSD(homedir, Condition)

% per subject Spike Script
DynamicSpike(homedir, Condition)

%% Group pics 

% generate group averaged CSDs based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Group{iGro} ' ' Condtion{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST})
        toc
    end
end

% generate group averaged spike heatmaps based on stimuli (does not BF sort)
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average Heatmaps for ' Group{iGro} ' ' Condtion{iST}])
        tic
        AvgSpikefig(homedir, Groups{iGro}, Condition{iST})
        toc
    end
end


%% trial-averaged AVREC and layer trace generation / peak detection

disp('Producing trial-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        Avrec_Layers(homedir, Groups{iGro}, Condition{iST})
    end
end

%% Group AVREC and layer traces / average peak detection 

disp('Producing group-averaged traces for each group')
for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        Group_Avrec_Layers(homedir, Groups{iGro}, Condition{iST})
    end
end
