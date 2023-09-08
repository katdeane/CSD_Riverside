function [stimList, thisUnit, stimDur, stimITI, thisTag] = ...
    StimVariable(Condition,sr_mult)

% for the various scripts that need this information dynamically, this
% function reads the current stim type and produces consistant variable
% data across the pipeline

% sr_mult variable let's us control the sampling rate for CSD and Spike
% output. CSD is consistently set at sr 1000 / sr_mult = 1. Spiking data
% currently set to sr 3000 / sr_mult = 3.

if ~exist('sr_mult','var')
    sr_mult = 1; % 1k sampling rate
end

if matches(Condition,'NoiseBurst') || ...
        matches(Condition,'postNoise')
    stimList = [20, 30, 40, 50, 60, 70, 80, 90];
    thisUnit = 'dB';
    stimDur  = 100*sr_mult; % ms
    stimITI  = 1000*sr_mult;
    thisTag  = 'noise'; 
    
elseif matches(Condition,'Tonotopy')
    stimList = [1, 2, 4, 8, 16, 24, 32];
    thisUnit = 'kHz';
    stimDur  = 200*sr_mult; % ms
    stimITI  = 1000*sr_mult;
    thisTag  = 'Tonotopy'; 
    
elseif matches(Condition,'Spontaneous') || ...
        matches(Condition,'postSpont')
    stimList = 1;
    thisUnit = [];
    stimDur  = 1000*sr_mult; % ms
    stimITI  = 1000*sr_mult;
    thisTag  = 'spont'; 
    
elseif matches(Condition,'ClickTrain')
    stimList = [1, 5, 10, 20, 40, 80, 100, 120];
    thisUnit = 'Hz';
    stimDur  = 2000*sr_mult; % ms
    stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
    thisTag  = 'ClickRate';
    
elseif matches(Condition,'Chirp')
    stimList = 1;
    thisUnit = [];
    stimDur  = 3000*sr_mult; % ms
    stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
    thisTag  = 'single';
    
elseif matches(Condition,'gapASSR')
    % 10 gaps every 25 ms from onset to onset (40 hz)
    % 250 ms noise, 250 ms gap-noise, etc. , 250 noise
    % 10 presentations of gap-noise
    % noiseonset = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000];
    % gaponset = [250, 750, 1250, 1750, 2250, 2750, 3250, 3750, 4250, 4750];
    stimList = [2, 4, 6, 8, 10];
    thisUnit = ' [ms] gap width';
    stimDur  = 3250*sr_mult; % ms
    stimITI  = 500*sr_mult;
    thisTag  = 'gapASSRRate';

end