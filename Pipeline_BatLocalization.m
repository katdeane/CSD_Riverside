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
c_axis = ([-0.4 0.4]); % this sets the default scale for all csds

% set consistently needed variables
Groups = {'BATsL' 'BATsH'};  %'BAT06' 'BAT08' 'BAT09' 'BAT11' 'BAT12' 'BAT13' 'BAT14' 'BAT15' 'BAT17' 'BAT19' 'BAT21'
Condition = {'BBN0' 'BBN3' 'BBNm3'}; 
% Condition = {'NoiseBurst' 'CF' 'Spontaneous' 'TonotopyNSR60' 'TonotopyNSR70' 'ClickTrain' ...
%       'BBN0' 'BBN1' 'BBN2' 'BBN3'  'BBN4' 'BBNm1' 'BBNm2' 'BBNm3'  'BBNm4'}; 

%% Data generation per subject ⊂◉‿◉つ

% per subject CSD Script
% note that this reads automatically what's in groups/
DynamicCSD(homedir, Condition, Groups, c_axis,'Bat')

for iGro = 1:length(Groups)
    for iST = 1:length(Condition)
        disp(['Average CSDs for ' Groups{iGro} ' ' Condition{iST}])
        tic
        AvgCSDfig(homedir, Groups{iGro}, Condition{iST},c_axis,[-50 50],'Bat')
        toc
    end
end

%% Get characteristic and best frequencies
% % for iGro = 1:length(Groups)
% %     function to sort out the CF for each recording location
% %     batCFsorting(homedir,c_axis,Groups{iGro})
% % 
% %     generate a list containing each recording location's CF
% %     batCFlist(homedir,Groups{iGro})
% % end
% % 
% % 60 dB tuning curve - BF for BBNs
% % 
% % 70 dB tuning curve - BF for click trains



%% Get elevation tuning curve

% for iGro = 1:length(Groups)
%     % function to sort and visualize each subjects BBN at different
%     % elevations
%     batBBNsorting(homedir,c_axis,Groups{iGro})
% end
