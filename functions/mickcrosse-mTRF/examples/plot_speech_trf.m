function plot_speech_trf
%PLOT_SPEECH_TRF  Plot example speech TRF.
%   PLOT_SPEECH_TRF loads an example dataset, estimates and plots a speech
%   TRF and the global field power (GFP) from 2 minutes of 128-channel EEG
%   data as per Lalor and Foxe (2010).
%
%   Example data is loaded from SPEECH_DATA.MAT and consists of the
%   following variables:
%       'stim'      a vector containing the speech spectrogram, obtained by
%                   band-pass filtering the speech signal into 128
%                   logarithmically spaced frequency bands between 100
%                   and 4000Hz, taking the Hilbert transform at each band
%                   and averaging over every 8 neighbouring bands.
%       'resp'      a matrix containing 2 minutes of 128-channel EEG data
%                   filtered between 0.5 and 15 Hertz
%       'fs'        the sample rate of STIM and RESP (128Hz)
%       'factor'    the BioSemi EEG normalization factor for computing the
%                   TRF in microvolts (524.288mV / 2^24bits)
%
%   mTRF-Toolbox https://github.com/mickcrosse/mTRF-Toolbox

%   References:
%      [1] Lalor EC, Foxe JJ (2010) Neural responses to uninterrupted
%          natural speech can be extracted with precise temporal
%          resolution. Eur J Neurosci 31(1):189-193.

%   Authors: Mick Crosse <mickcrosse@gmail.com>
%   Copyright 2014-2020 Lalor Lab, Trinity College Dublin.

% Load data
load('data/speech_data.mat','stim','resp','fs','factor');

% Normalize data
resp = factor*resp;

% Compute broadband envelope
stim = sum(stim,2);

% Model hyperparameters
tmin = -100;
tmax = 400;
lambda = 0.05;

% Compute model weights
model = mTRFtrain(stim,resp,fs,1,tmin,tmax,lambda,'method','Tikhonov',...
    'split',5,'zeropad',0);

% Plot TRF
figure, subplot(2,2,3)
mTRFplot(model,'trf',[],85,[-50,350]);
title('Speech TRF (Fz)')
ylabel('Amplitude (a.u.)')

% Plot GFP
subplot(2,2,4)
mTRFplot(model,'gfp',[],'all',[-50,350]);
title('Global Field Power')