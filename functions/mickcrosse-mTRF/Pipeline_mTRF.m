%% Pipeline for mTRF

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

%% to loop through later
filename = 'VMP03_06_LFP';
channels = [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3];
subname  = filename(1:5);
Lay.II = 1:2; 
Lay.IV = 3:9;
Lay.Va = 10:12;
Lay.Vb = 13:18; 
Lay.VI = 19:24; 
% layer IV hard coded through right now

%% Notes:

% mTRF = Multivariate Temporal Response Function :) 
% contrast TRF (VESPA) = Lalor 2006 The Vespa: ...
% global field power (GFP) = constitutes a reference-independent measure of 
%   response strength across the entire scalp at each time lag (Lehmann and 
%   Skrandies, 1980; Murray et al., 2008)

% lambda is the regularization (0.05 - 0.1) 

% time lag: 
% In the context of speech for example, s(t) could be a measure of the 
% speech envelope at each moment in time and r(t, n) could be the 
% corresponding EEG response at channel n. The range of time lags over 
% which to calculate w(τ, n) might be that typically used to capture the 
% cortical response components of an ERP, e.g., −100–400 ms. The resulting 
% value of the TRF at −100 ms, would index the relationship between the 
% speech envelope and the neural response 100 ms earlier (obviously this 
% should have an amplitude of zero), whereas the TRF at 100 ms would index 
% how a unit change in the amplitude of the speech envelope would affect 
% the EEG 100 ms later (Lalor et al., 2009).

%% Generate data

[StimIn, DataIn] = FileReaderLFP(filename,channels);

% detect when signal crosses threshold
threshold = 0.09; 
location = threshold <= StimIn; 
crossover = diff(location);
onsets = find(crossover == 1); 
offsets = find(crossover == -1);
% Sanity Check:
% % onsets(2) - offsets(1) = 5012
% % offsets(1) - onsets(1) = 25063
% % onsets(2) - onsets(1)  = 30075

% 500 ms before and after ~2 min of stim presentation
resp = DataIn(:,onsets(1)-500:offsets(3)+500)'; 

%% Generate stim

% spectrostim data comes from generateSpectroStim.m and only needs to be run
% once for this entire process
load('spectrostim.mat','spectrostim','fband')

% string it together for this subject
fullstim = zeros(size(StimIn,2),10);
for istim = 1:length(onsets)
    fullstim(onsets(istim):onsets(istim)+length(spectrostim)-1,:) = spectrostim;
end

fullstim = fullstim(onsets(1)-500:offsets(3)+500,:); 
fs = 1000;

%% Train the models

% % Model hyperparameters
% tmin = -50;
% tmax = 350;
% lambda = 0; % very high - crosse documentation suggests 0.1
% fs = 1000; 
% 
% %% Compute model weights
% % Note, ridge regression is used instead of Tikhonov regularization to
% % avoid cross-channel leakage of the multivariate input features
% 
% % mulitvariate model
% modelm = mTRFtrain(fullstim,resp,fs,1,tmin,tmax,lambda,'method','ridge',...
%     'split',3,'zeropad',0);
% % low frequency broadbanthischan7d model
% stim = sum(fullstim(:,1:3),2);
% % Compute model weights
% model1 = mTRFtrain(stim,resp,fs,1,tmin,tmax,lambda,'method','ridge',...
%     'split',3,'zeropad',0);
% % high frequency broadband model
% stim = sum(fullstim(:,4:7),2);
% % Compute model weights
% model2 = mTRFtrain(stim,resp,fs,1,tmin,tmax,lambda,'method','ridge',...
%     'split',3,'zeropad',0);
% 
% %% Plot Spectral TRF (strf) for channel 7
% 
% thischan = ceil(mean(Lay.IV));
% 
% figure;
% subplot(3,2,1), mTRFplot(modelm,'mtrf','all',thischan,[tmin,tmax]);
% title('Speech STRF (Fz)'), ylabel('Frequency band [Hz]'), xlabel('')
% yticks(1:10)
% yticklabels({[num2str(round(fband(1,1))) '-' num2str(round(fband(end,1)))] ...
%     [num2str(round(fband(1,2))) '-' num2str(round(fband(end,2)))] ...
%     [num2str(round(fband(1,3))) '-' num2str(round(fband(end,3)))] ...
%     [num2str(round(fband(1,4))) '-' num2str(round(fband(end,4)))] ...
%     [num2str(round(fband(1,5))) '-' num2str(round(fband(end,5)))] ...
%     [num2str(round(fband(1,6))) '-' num2str(round(fband(end,6)))] ...
%     [num2str(round(fband(1,7))) '-' num2str(round(fband(end,7)))] ...
%     [num2str(round(fband(1,8))) '-' num2str(round(fband(end,8)))] ...
%     [num2str(round(fband(1,9))) '-' num2str(round(fband(end,9)))] ...
%     [num2str(round(fband(1,10))) '-' num2str(round(fband(end,10)))]})
% 
% % Plot GFP
% subplot(3,2,2), mTRFplot(modelm,'mgfp','all','all',[tmin,tmax]);
% title('Global Field Power'), xlabel('')
% 
% % Plot TRF
% subplot(3,2,3), mTRFplot(model1,'trf','all',thischan,[tmin,tmax]);
% title('Speech TRF 9-18 kHz'), ylabel('Amplitude (a.u.)'), xlabel('')
% 
% % Plot GFP
% subplot(3,2,4), mTRFplot(model1,'gfp','all','all',[tmin,tmax]);
% title('Global Power 7-14 kHz'), xlabel('')
% 
% % Plot TRF
% subplot(3,2,5), mTRFplot(model2,'trf','all',thischan,[tmin,tmax]);
% title('Speech TRF 14-37 kHz'), ylabel('Amplitude (a.u.)')
% 
% % Plot GFP
% subplot(3,2,6), mTRFplot(model2,'gfp','all','all',[tmin,tmax]);
% title('Global Power 18-37 kHz')
% 
% sgtitle('Layer IV')
% cd(homedir);cd figures; cd mTRF
% h = gcf;
% savefig(h,[subname '_ModelTraining_LayerIV_' ])
% close(h)


%% Cross-validation 
% this let's us select the best lamda (i.e. ridge value). We want the
% highest correlation r and lowest error err. This will be tested on the
% first 2 minutes of data. Leave 1 out with the folds (split)

lambda = 0.1:0.1:1.5; % range to test
tmin = 0;
tmax = 200;

statsm = mTRFcrossval(fullstim,resp,fs,1,tmin,tmax,lambda,'method','ridge',...
    'split',5,'zeropad',0,'corr','Pearson');

% mean across trials and channels to avoid overfitting
spearR = mean(mean(statsm.r,3),1);
spearE = mean(mean(statsm.err,3),1);

% find max r / min MSE
spearmax = find(spearR == max(spearR));
targetl  = lambda(spearmax);

% plot them
Statplot = tiledlayout('flow'); 
title(Statplot,'Cross-Validation')

nexttile
plot(spearR,'-o')
xticks(1:length(lambda))
xticklabels(lambda)
xlabel('λ')
ylabel('Pearsons r')

nexttile 
plot(spearE,'-o')
xticklabels(lambda)
xlabel('λ')
ylabel('MSE')

% the pearson's r on each channel at the best lambda
thislambda = squeeze(mean(statsm.r(:,spearmax,:),1));

nexttile
imagesc(thislambda)
colormap bone
colorbar
ylabel('channel')
ylabel(['λ = ' num2str(targetl)])

% now run the model training on the target lambda
tmin = -50;
tmax = 350;

modelm = mTRFtrain(fullstim,resp,fs,1,tmin,tmax,targetl,'method','ridge',...
    'split',3,'zeropad',0);
% low frequency broadbanthischan7d model
stim = sum(fullstim(:,1:3),2);
% Compute model weights
model1 = mTRFtrain(stim,resp,fs,1,tmin,tmax,targetl,'method','ridge',...
    'split',3,'zeropad',0);
% high frequency broadband model
stim = sum(fullstim(:,4:7),2);
% Compute model weights
model2 = mTRFtrain(stim,resp,fs,1,tmin,tmax,targetl,'method','ridge',...
    'split',3,'zeropad',0);

thischan = ceil(mean(Lay.IV));

figure;
subplot(3,2,1), mTRFplot(modelm,'mtrf','all',thischan,[tmin,tmax]);
title('Speech STRF (Fz)'), ylabel('Frequency band [Hz]'), xlabel('')
yticks(1:10)
yticklabels({[num2str(round(fband(1,1))) '-' num2str(round(fband(end,1)))] ...
    [num2str(round(fband(1,2))) '-' num2str(round(fband(end,2)))] ...
    [num2str(round(fband(1,3))) '-' num2str(round(fband(end,3)))] ...
    [num2str(round(fband(1,4))) '-' num2str(round(fband(end,4)))] ...
    [num2str(round(fband(1,5))) '-' num2str(round(fband(end,5)))] ...
    [num2str(round(fband(1,6))) '-' num2str(round(fband(end,6)))] ...
    [num2str(round(fband(1,7))) '-' num2str(round(fband(end,7)))] ...
    [num2str(round(fband(1,8))) '-' num2str(round(fband(end,8)))] ...
    [num2str(round(fband(1,9))) '-' num2str(round(fband(end,9)))] ...
    [num2str(round(fband(1,10))) '-' num2str(round(fband(end,10)))]})

% Plot GFP
subplot(3,2,2), mTRFplot(modelm,'mgfp','all','all',[tmin,tmax]);
title('Global Field Power'), xlabel('')

% Plot TRF
subplot(3,2,3), mTRFplot(model1,'trf','all',thischan,[tmin,tmax]);
title('Speech TRF 7-14 kHz'), ylabel('Amplitude (a.u.)'), xlabel('')

% Plot GFP
subplot(3,2,4), mTRFplot(model1,'gfp','all','all',[tmin,tmax]);
title('Global Power 7-14 kHz'), xlabel('')

% Plot TRF
subplot(3,2,5), mTRFplot(model2,'trf','all',thischan,[tmin,tmax]);
title('Speech TRF 14-37 kHz'), ylabel('Amplitude (a.u.)')

% Plot GFP
subplot(3,2,6), mTRFplot(model2,'gfp','all','all',[tmin,tmax]);
title('Global Power 14-37 kHz')

sgtitle('Layer IV')
cd(homedir);cd figures; cd mTRF
h = gcf;
savefig(h,[subname '_ModelTraining_LayerIV'])
close(h)

%% Time to predict the future

realresp = DataIn(:,onsets(3)-500:offsets(end)+500)';

realstim = zeros(size(StimIn,2),10);
for istim = 1:length(onsets)
    realstim(onsets(istim):onsets(istim)+length(spectrostim)-1,:) = spectrostim;
end
realstim = realstim(onsets(3)-500:offsets(end)+500,:); 

[pred,stats] = mTRFpredict(realstim,realresp,modelm,'split',47,'zeropad',0);

nexttile
plot(mean(pred{1}(1000:2000,:),2))
hold on 
plot(mean(realresp(1000:2000,:),2))
legend({['λ ' num2str(targetl)] 'LFP'})
xlabel('Time [ms]')
ylabel('µV')

h = gcf;
savefig(h,[subname '_ModelPredict'])
close(h)