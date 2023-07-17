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

%% Data generation per subject

% Condition = {'Tonotopy'};
Condition = {'NoiseBurst' 'Tonotopy' 'Spontaneous' 'ClickTrain' 'Chirp' ...
    'gapASSR' 'postNoise' 'postSpont'};

% subject CSD Script
DynamicCSD(homedir, Condition)

% subject Spike Script
DynamicSpike(homedir, Condition)