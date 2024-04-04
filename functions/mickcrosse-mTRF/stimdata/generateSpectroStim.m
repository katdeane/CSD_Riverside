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

[audio,fs] = audioread('PupCall25s.wav');
audio = audio(:,1);
% audio file has fs of 192000. However, the software is slightly
% slowing the stimulus down as it plays it (194800). Therefore, the following fs
% is based on the RPvdsEx playing (this is at max fs in the software)

% band-pass filtering the speech signal into 128 logarithmically spaced 
% frequency bands between 7000 and 82,000Hz

range = [7000 75000];
numFilts = 80;
gammaFiltBank = gammatoneFilterBank(range,numFilts,fs);
spectro = gammaFiltBank(audio);

% fvtool(gammaFiltBank)
% % taking the Hilbert transform at each band and averaging over every 8
% % neighboring bands
hilbert_stim = abs(hilbert(spectro)); % abs to take it from complex to magnitude value
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
% stimbands(:,11) = mean(hilbert_stim(:,81:88),2);
% stimbands(:,12) = mean(hilbert_stim(:,89:96),2);
% stimbands(:,13) = mean(hilbert_stim(:,97:104),2);
% stimbands(:,14) = mean(hilbert_stim(:,105:112),2);
% stimbands(:,15) = mean(hilbert_stim(:,113:120),2);
% stimbands(:,16) = mean(hilbert_stim(:,121:128),2);

% downsample to 1000 hz of real stim to make it small enough to resample it
ds_amount = 192; % down sampling has to be with whole #s
dsy = downsample(stimbands,ds_amount);
% to go from 25027 to 25063 sampling points
spectrostim = resample(dsy,10014,10000);
% this applied a FIR filter, which is not perfect. Maybe fix later

% get which frequencies are covered in which band
fc = getCenterFrequencies(gammaFiltBank);
fband(:,1) = fc(1:8);
fband(:,2) = fc(9:16);
fband(:,3) = fc(17:24);
fband(:,4) = fc(25:32);
fband(:,5) = fc(33:40);
fband(:,6) = fc(41:48);
fband(:,7) = fc(49:56);
fband(:,8) = fc(57:64);
fband(:,9) = fc(65:72);
fband(:,10) = fc(73:80);

cd(homedir); cd functions; cd mickcrosse-mTRF; cd stimdata
save('spectrostim.mat','spectrostim','fband')
cd(homedir)