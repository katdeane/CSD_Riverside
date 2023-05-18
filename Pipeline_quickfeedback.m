%% Pipeline for LFP Quick Feedback

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
	'Noise bursts','Pure tones','Pure Tones');

% prompt file name
prompt   = {'File name (-.xdat.json):'};
dlgtitle = 'File Name';
dims     = [1 35];
definput = {'test_01_LFP'};
file = inputdlg(prompt,dlgtitle,dims,definput);
file = file{1}; % clean it up

%% Get data from .xdat files
 
[StimIn, DataIn] = FileReader(file);

%% cut data at each stim onset (-200 BL) and sort

if strcmp(stimtype, 'Noise bursts')
   
    DataOut = icutNoisedata(homedir, file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Noise')
    
elseif strcmp(stimtype, 'Pure tones')
    
    DataOut = icutTonedata(homedir, file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Tones')
    
end





