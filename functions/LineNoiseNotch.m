%%Line Noise Notch 

clear; clc;

%function sngtrlCSD = LineNoiseNotch(homedir,sngtrlCSD)


%% initially - create fake data
% data structure is channel x time x trials (22x1400x50)

fakedata= randn(22,1400,50);


%% set up notch filter 

%create variables (replace with true values)
Fs = 1000; % Sampling frequency (Kz)
lineNoiseFrequency = 60; % Hz
cutoffFrequency = lineNoiseFrequency / (Fs/2); % Normalized cutoff frequency
bandwidth = 2; %(ex. 59-61 Hz)

% notch filter design
notchfilt = designfilt('bandstopiir', 'FilterOrder', 2, ...
               'HalfPowerFrequency1', lineNoiseFrequency - bandwidth/2, ...
               'HalfPowerFrequency2', lineNoiseFrequency + bandwidth/2, ...
               'DesignMethod', 'butter', 'SampleRate', Fs);

%% apply filter to each channel 

filteredSignal = filtfilt(notchfilt, fakedata);

%% figure out to verify 
imagesc((nanmean(filteredSignal,3)))
colormap jet

