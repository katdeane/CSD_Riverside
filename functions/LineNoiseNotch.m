function filteredSignal = LineNoiseNotch(homedir,sngtrlLFP)

keyboard % hi

%% load and visualize original data
% data structure is channel x time x trials (22x1400x50)

tiledlayout('flow');
nexttile
imagesc((nanmean(sngtrlLFP,3)))
colormap jet

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

filteredSignal = filtfilt(notchfilt, sngtrlLFP);

%% figure out to verify 
nexttile
imagesc((nanmean(filteredSignal,3)))
colormap jet

%% run a fast fourier transform to verify

% if the data looks basically the same before and after the notch filter
% (which it should), then we should verify with an fft and by plotting the
% power spectrum density. 

% uncomment to fill in:
% fftlfp = fft(one channel of the filtered csd data (every channel should show the notch));
% fftlfp = % take power
% fftcsdAB = fftlfp ./ (size(sngtrlLFP,2)/2); % normalize by half sampling points

% L = length of fft signal
% fftaxis = (Fs/L)*(0:L-1);

% nexttile 
% semilogy(fftaxis,fftcsd)
% xlim([0 100]) % it's going to be a mirrored weirdness based on Fs, 1-100 is delta through gamma 
% xticks(0:10:100)
% ax = gca;
% ax.XScale = 'log';

