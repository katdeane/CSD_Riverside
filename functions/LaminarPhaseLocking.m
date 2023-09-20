
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

params.sampleRate = 1000; % Hz
params.frequencyLimits = [5 params.sampleRate/2]; % Hz
params.voicesPerOctave = 8;
params.timeBandWidth = 54;
params.layers = {'II','IV','Va','Vb','VI'}; 
params.condList = {'NoiseBurst','ClickTrain','Chirp','gapASSR'}; % subset
params.groups = {'MWT','MKO'};

% function start

BL = 399;
% actual intended frequencies commented
theta = (49:54);        %(4:7);
alpha = (44:48);        %(8:12);
beta_low = (39:43);     %(13:18);
beta_high = (34:38);    %(19:30);
gamma_low = (26:33);    %(31:60);
gamma_high = (19:25);   %(61:100);

osciName = {'theta' 'alpha' 'beta_low' 'beta_high' 'gamma_low' 'gamma_high'};
osciRows = {theta alpha beta_low beta_high gamma_low gamma_high};



cd (homedir); cd output; cd WToutput
iCond = 1; %forloop

[stimList, thisUnit, stimDur, ~, ~] = ...
    StimVariable(params.condList{iCond},1);
% timeAxis = BL + stimDur + stimITI; % time axis for visualization
compTime = BL:BL+stimDur; % time of permutation comparison

iStim = 1; % forloop

input = dir([params.groups{1} '*_' params.condList{iCond}...
    '_' num2str(stimList(iStim)) '_WT.mat']);
% initialize table with first input
load(input(1).name, 'wtTable')
% group1WT = wtTable; clear wtTable
% % start on 2 and add further input to full tables
% for iIn = 2:length(input)
%     load(input(iIn).name, 'wtTable')
%     group1WT = [group1WT; wtTable]; %#ok<AGROW>
% end


% look at first trial scalogram of layers
LayIIall = wtTable(matches(wtTable.layer, 'II'),:);
LayIItrl = LayIIall((LayIIall.trial == 1),1).scalogram{:};

LayIVall = wtTable(matches(wtTable.layer, 'IV'),:);
LayIVtrl = LayIVall((LayIVall.trial == 1),1).scalogram{:};

% calculate interlaminar phase coherence
LIIph = LayIItrl./abs(LayIItrl);
LIVph = LayIVtrl./abs(LayIVtrl);

Phaseco = LIIph + LIVph;
Phaseco =  abs(Phaseco / 2); % this is the SAME calculation as intertrial phase coherence

% sanity check
Phasefig = tiledlayout('flow');

nexttile
imagesc(flipud(Phaseco(19:54,:))) 
set(gca,'Ydir','normal')
yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
yticklabels({'0','10','20','30','40','50','60','80','100'})
colorbar

nexttile
gammahightrace = mean(Phaseco(gamma_high,:),1);
plot(gammahightrace);
hold on 
gammalowtrace  = mean(Phaseco(gamma_low,:),1);
plot(gammalowtrace)
betahightrace = mean(Phaseco(beta_high,:),1);
plot(betahightrace);
betalowtrace = mean(Phaseco(beta_low,:),1);
plot(betalowtrace);
alphatrace = mean(Phaseco(alpha,:),1);
plot(alphatrace);
thetatrace = mean(Phaseco(theta,:),1);
plot(thetatrace);
legend('High Gamma', 'Low Gamma', 'High Beta', 'Low Beta','Alpha','Theta')


