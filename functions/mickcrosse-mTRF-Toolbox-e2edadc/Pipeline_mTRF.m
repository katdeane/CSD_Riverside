%% Pipeline for mTRF

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

fs = 1000; % Hz - each sp is 1 ms
[StimIn, DataIn] = FileReaderLFP('VMP03_06_LFP',[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]);

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
[y,~] = audioread('PupCall25s.wav');
y = y(:,1);
% audio file has fs of 192000. However, the software is slightly
% slowing the stimulus down as it plays it (194800). Therefore, the following fs
% is based on the RPvdsEx playing (this is at max fs in the software)

% band-pass filtering the speech signal into 128 logarithmically spaced 
% frequency bands between 1000 and 80,000Hz
% bandrange = 1000:82697; % Hz
filters = ones(1,129);
for ix = 1:length(filters)
    if ix == 1
        filters(ix) = 1000;
    else
    filters(ix) = round(filters(ix-1) * 1.0351);
    end
end

filtered_stim = ones(length(y),length(filters)-1);
for ix = 1:length(filters)-1
    filtered_stim(:,ix) = bandpass(y,[filters(ix),filters(ix+1)],194800);
end
   
% for the 16 bands then it would be 
% 62788  79938
% 47645  60659
% 36154  46029
% 27435  34928
% 20818  26504
% 15797  20112
% 11987  15265
% 9096.4 11581
% 6902.5 8787.9
% 5237.8 6668.5
% 3974.6 5060.2
% 3016   3839.8
% 2288.6 2913.7
% 1736.7 2211
% 1317.8 1677.8
% 1000   1273.1

% taking the Hilbert transform at each band and averaging over every 8
% neighboring bands
hilbert_stim = abs(hilbert(filtered_stim));
stimbands(:,1) = mean(hilbert_stim(:,1:8),2);
stimbands(:,2) = mean(hilbert_stim(:,9:16),2);
stimbands(:,3) = mean(hilbert_stim(:,17:24),2);
stimbands(:,4) = mean(hilbert_stim(:,25:32),2);
stimbands(:,5) = mean(hilbert_stim(:,33:40),2);
stimbands(:,6) = mean(hilbert_stim(:,41:48),2);
stimbands(:,7) = mean(hilbert_stim(:,49:56),2);
stimbands(:,8) = mean(hilbert_stim(:,57:64),2);
stimbands(:,9) = mean(hilbert_stim(:,65:72),2);
stimbands(:,10) = mean(hilbert_stim(:,73:80),2);
stimbands(:,11) = mean(hilbert_stim(:,81:88),2);
stimbands(:,12) = mean(hilbert_stim(:,89:96),2);
stimbands(:,13) = mean(hilbert_stim(:,97:104),2);
stimbands(:,14) = mean(hilbert_stim(:,105:112),2);
stimbands(:,15) = mean(hilbert_stim(:,113:120),2);
stimbands(:,16) = mean(hilbert_stim(:,121:128),2);

% downsample to 1000 hz of real stim to make it small enough to resample it
ds_amount = 192; % down sampling has to be with whole #s
dsy = downsample(stimbands,ds_amount);
% to go from 25027 to 25063 sampling points
rsy = resample(dsy,10014,10000);
% this applied a FIR filter, which is not perfect. Maybe fix later

% string it together
stim = zeros(size(StimIn,2),16);
for istim = 1:length(onsets)
    stim(onsets(istim):onsets(istim)+length(rsy)-1,:) = rsy;
end
% Sanity check
%plot(crossover(1:200000)); hold on; plot(stim(1:200000))

stim = stim(onsets(1)-500:offsets(3)+500,:); 

%% Pseudocode

% Model hyperparameters
tmin = -100;
tmax = 400;
lambda = 0.05;

% Compute model weights
% Note, ridge regression is used instead of Tikhonov regularization to
% avoid cross-channel leakage of the multivariate input features
model = mTRFtrain(stim,resp,fs,1,tmin,tmax,lambda,'method','ridge',...
    'split',5,'zeropad',0);

% Plot Spectral TRF (strf) for 1 channel 
figure
subplot(2,2,1), mTRFplot(model,'mtrf','all',8,[-50,350]);
title('Speech STRF (Fz)'), ylabel('Frequency band'), xlabel('')

% Plot GFP
subplot(2,2,2), mTRFplot(model,'mgfp','all','all',[-50,350]);
title('Global Field Power'), xlabel('')

model = mTRFtrain(stim,resp,fs,1,tmin,tmax,lambda,'method','Tikhonov',...
    'split',5,'zeropad',0);

% Plot TRF
subplot(2,2,3), mTRFplot(model,'trf','all',8,[-50,350]);
title('Speech TRF (Fz)'), ylabel('Amplitude (a.u.)')

% Plot GFP
subplot(2,2,4), mTRFplot(model,'gfp','all','all',[-50,350]);
title('Global Field Power')
