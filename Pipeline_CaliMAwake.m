% Pipeline - Awake California Mouse Fathers vs Virgins

% notes about study

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
set(0, 'DefaultFigureRenderer', 'painters');
c_axis = ([-0.2 0.2]); % this sets the default scale for all csds

% set consistently needed variables
Groups = {'VMA' 'PMA'};  %'VMA' 'PMA' 
Condition = {'NoiseBurst' 'MaskCall' 'ShortCall'}; %  'MaskCall' 'ShortCall'


%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, [-0.2 0.2],'Awake')

%% Sorted figures for visualization

% single subject CSDs
ncolum = 4;
Group_single_CSD(homedir, 'VMA', 'VMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, 'PMA', 'PMA', 'NoiseBurst',  c_axis, ncolum)
Group_single_CSD(homedir, 'VMA', 'VMA', 'ShortCall',  c_axis, ncolum)
Group_single_CSD(homedir, 'PMA', 'PMA', 'ShortCall',  c_axis, ncolum)


