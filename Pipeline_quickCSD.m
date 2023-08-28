%% Pipeline for LFP Quick Feedback

clear; clc;

if exist('D:\CSD_Riverside','dir')
    cd('D:\CSD_Riverside');
else
       error('add your local repository as shown above')
end 

homedir = pwd;
addpath(genpath(homedir));

%% get some bigger inputs

% prompt stimulus type
stimtype = questdlg('What type of stimulus?', ...
	'Stimulus Type', ...
	'Noise bursts', 'Click Trains', 'Pure tones', 'Noise bursts');

% prompt file name
prompt   = {'File name (-.xdat.json):'};
dlgtitle = 'File Name';
dims     = [1 35];
definput = {'MWT07_01_LFP'}; % replace with current 
file = inputdlg(prompt,dlgtitle,dims,definput);
file = file{1}; % clean it up
file = ['C:\Users\RazakLab\CurateOutput\' file];

%% Get data from .xdat files
 
[StimIn, DataIn] = FileReaderLFP(file);

%% cut data at each stim onset (-200 BL) and sort

if strcmp(stimtype, 'Noise bursts')
   
    DataOut = icutNoisedata(file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Noise')
    
elseif strcmp(stimtype, 'Pure tones')
    
    DataOut = icutTonedata(homedir, file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Tones')
    
elseif strcmp(stimtype, 'Click Trains')

    DataOut = icutClickdata(homedir, file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Clicks')

elseif strcmp(stimtype, 'Chirps')

    DataOut = icutChirpdata(homedir, file, StimIn, DataIn);
    CSDandTuningFigs(homedir, file, DataOut, 'Chirps')

end





