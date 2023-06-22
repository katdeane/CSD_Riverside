%% Pipeline for PSTH Quick Feedback

clear; clc;
if exist('C:\Users\RazakLab\Documents\CSD_Riverside','dir')
    cd('C:\Users\RazakLab\Documents\CSD_Riverside')
elseif exist('E:\CSD_Riverside','dir')
    cd('E:\CSD_Riverside'); % change for your station
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));

%% get some bigger inputs

% prompt stimulus type
stimtype = questdlg('Is this noise or pure tones?', ...
	'Stimulus Type', ...
	'Noise bursts', 'Click Trains', 'Pure tones', 'Noise bursts');

% prompt file name
prompt   = {'File name (-.xdat.json):'};
dlgtitle = 'File Name';
dims     = [1 35];
definput = {'MKO03_01_Spike'}; % replace with current 
file = inputdlg(prompt,dlgtitle,dims,definput);
file = file{1}; % clean it up

%% Get data from .xdat files
 
[StimIn, DataIn] = FileReaderSpike(file);

%%

DataOut = icutSpikeNoisedata(homedir, file, StimIn, DataIn);
% go through cut scripts and make sure you didn't make the same mistake
% with throwing out extra trials :) 

