%% Pipeline California Mouse response to pup calls

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

% set consistently needed variables
Groups = {'VMP'}; % 'PMP' % virgin male pupcall & paired male pupcall
% Condition = {'NoiseBurst'};
Condition = {'NoiseBurst' 'Pupcall'};

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
DynamicCSD(homedir, Condition)

% per subject Spike Script
% DynamicSpike(homedir, Condition)

