%% Characteristic Frequency Pipeline 

% description goes here :) 

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

%% Pull Meta Data

run('CF.m') % adds animals, channels, measurements, and metafile to the workspace

%% Get the tuning curves of each 

for iAn = 1:length(animals)
    meList = measurements{iAn};
    for iMe = 1:length(meList)
        % generate which data file this will be
        fileCSD = [animals{iAn} '_' meList{iMe} '_LFP'];
        disp(['Analyzing animal: ' fileCSD])
        % run CF on CSD data
        CF_CSD(homedir,fileCSD,str2num(channels{iAn}),metafile{iAn})
        % run CF on Spike data
    end
end