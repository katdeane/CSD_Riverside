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
Groups = {'BAT'};  
Condition = {'CF'}; 
% Condition = {'NoiseBurst' 'CF' 'Spontaneous' 'TonotopyNSR' 'ClickTrain' ...
%       'BBN0' 'BBN1' 'BBN2' 'BBN3'  'BBN4' 'BBNm1' 'BBNm2' 'BBNm3'  'BBNm4'}; 

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, c_axis,'Bat')