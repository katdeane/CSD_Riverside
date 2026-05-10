% Pipeline - Developmental FMR1 Comparison Study ~( °٢° )~

% This is the master script for the ___, run by ____
%  at University of California, Riverside in Khaleel Razak's lab in
% the Psychology Department. 

% The overall goal of this study is ____

%% Get started

clear; clc;

% set working directory; change for your station
if exist('F:\CSD_Riverside','dir')
    cd('F:\CSD_Riverside'); 
elseif exist('E:\CSD_Riverside','dir')
    cd('E:\CSD_Riverside'); 
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');

% set consistently needed variables
Groups = {};  %'AWT'
% Condition = {'NoiseBurst'};
% Condition = {'NoiseBurst' 'ClickTrain'};
Condition = {'NoiseBurst' 'Spontaneous' 'ClickTrain' 'Chirp' ...
    'gapASSR' 'postNoiseBurst'};


%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, [-0.2 0.2],'Awake')