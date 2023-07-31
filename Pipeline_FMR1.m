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

% subject CSD Script
DynamicCSD(homedir, Condition)

% subject Spike Script
DynamicSpike(homedir, Condition)

%% Group pics 

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST})
    end
end


for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        AvgSpikefig(homedir, Groups{iGro}, Condition{iST})
    end
end