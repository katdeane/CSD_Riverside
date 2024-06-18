function [stimList, thisUnit, stimDur, stimITI, thisTag,compDur1,compDur2] = ...
    StimVariableCWT(Condition,sr_mult,type)

% for the various scripts that need this information dynamically, this
% function reads the current stim type and produces consistant variable
% data across the pipeline

% sr_mult variable let's us control the sampling rate for CSD and Spike
% output. CSD is consistently set at sr 1000 / sr_mult = 1. Spiking data
% currently set to sr 3000 / sr_mult = 3.

if ~exist('sr_mult','var')
    sr_mult = 1; % 1k sampling rate
end

% compare at the onset
compDur1 = 1:100; 

if matches(type, 'Anesthetized')
    if matches(Condition,'NoiseBurst') || ...
            matches(Condition,'postNoise') || ...
            matches(Condition, 'PostNoiseBurst')
        stimList = [20 70];
        thisUnit = 'dB';
        stimDur  = 100*sr_mult; % ms
        stimITI  = 1000*sr_mult;
        thisTag  = 'noise';
        % post processing
        compDur2 = {100:300; 100:300; 100:300; 100:300; 100:300; 100:300; 100:300};

    elseif matches(Condition,'Tonotopy')
        stimList = [1, 2, 4, 8, 16, 24, 32];
        thisUnit = 'kHz';
        stimDur  = 200*sr_mult; % ms
        stimITI  = 1000*sr_mult;
        thisTag  = 'Tonotopy';
        % post processing
        compDur2 = {100:300; 100:300; 100:300; 100:300; 100:300; 100:300; 100:300};

    elseif matches(Condition,'Spontaneous') || ...
            matches(Condition,'postSpont')
        stimList = 1;
        thisUnit = [];
        stimDur  = 1000*sr_mult; % ms
        stimITI  = 1000*sr_mult;
        thisTag  = 'spont';
        compDur2 = 0; % probably don't need

    elseif matches(Condition,'ClickTrain')
        stimList = [1, 5, 10, 20, 40, 80];
        thisUnit = 'Hz';
        stimDur  = 2000*sr_mult; % ms
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
        thisTag  = 'ClickRate';
        % ASSR reached
        compDur2 = {1000:1500; 1000:1500; 1000:1500; ...
            1000:1500; 1000:1500; 1000:1500; 1000:1500};

    elseif matches(Condition,'Chirp')
        stimList = 1;
        thisUnit = [];
        stimDur  = 3000*sr_mult; % ms
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
        thisTag  = 'single';
        compDur2 = {1100:3000; []; []; 1100:1450; 1250:1750; ...
            1500:2350; 1900:3000}; % post processing

    elseif matches(Condition,'gapASSR')
        % 10 gaps every 25 ms from onset to onset (40 hz)
        % 250 ms noise, 250 ms gap-noise, etc. , 250 noise
        % 10 presentations of gap-noise
        % noiseonset = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000];
        % gaponset = [250, 750, 1250, 1750, 2250, 2750, 3250, 3750, 4250, 4750];
        stimList = [2, 10];
        thisUnit = ' [ms] gap width';
        stimDur  = 3250*sr_mult; % ms
        stimITI  = 500*sr_mult;
        thisTag  = 'gapASSRRate';
        % 4th gap in noise block
        compDur2 = {1750:2000; 1750:2000; 1750:2000; ...
            1750:2000; 1750:2000; 1750:2000; 1750:2000};

    elseif contains(Condition,'Pupcall')
        stimList = 1;
        thisUnit = [];
        stimDur  = 25027*sr_mult; % 25.027 s
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 5s
        thisTag  = 'single';
        compDur2 = 0; % DIDN'T CALCULATE

    end
elseif matches(type,'Awake')
    if contains(Condition,'NoiseBurst') 
        stimList = 70;
        thisUnit = 'dB';
        stimDur  = 100*sr_mult; % ms
        stimITI  = 1000*sr_mult; % actual 2 s
        thisTag  = 'single';
        % post processing
        compDur2 = {100:300; 100:300; 100:300; 100:300; 100:300; 100:300; 100:300};

    elseif contains(Condition,'Tonotopy')
        stimList = [2, 4, 8, 16, 24, 32];
        thisUnit = 'kHz';
        stimDur  = 200*sr_mult; % ms
        stimITI  = 1000*sr_mult;
        thisTag  = 'Tonotopy';
        % post processing
        compDur2 = {100:300; 100:300; 100:300; 100:300; 100:300; 100:300; 100:300};

    elseif contains(Condition,'Spontaneous') 
        stimList = 1;
        thisUnit = [];
        stimDur  = 1000*sr_mult; % ms
        stimITI  = 1000*sr_mult;
        thisTag  = 'spont';
        compDur2 = 0; % probably don't need

    elseif contains(Condition,'ClickTrain')
        stimList = [5, 10, 40, 80];
        thisUnit = 'Hz';
        stimDur  = 2000*sr_mult; % ms
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
        thisTag  = 'ClickRate';
        % ASSR reached
        compDur2 = {1000:1500; 1000:1500; 1000:1500; ...
            1000:1500; 1000:1500; 1000:1500; 1000:1500};

    elseif contains(Condition,'Chirp')
        stimList = 1;
        thisUnit = [];
        stimDur  = 3000*sr_mult; % ms
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 2s
        thisTag  = 'single';
        compDur2 = {1100:3000; []; []; 1100:1450; 1250:1750; ...
            1500:2350; 1900:3000}; % post processing

    elseif contains(Condition,'gapASSR') 
        % 10 gaps every 25 ms from onset to onset (40 hz)
        % 250 ms noise, 250 ms gap-noise, etc. , 250 noise
        % 10 presentations of gap-noise
        % noiseonset = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000];
        % gaponset = [250, 750, 1250, 1750, 2250, 2750, 3250, 3750, 4250, 4750];
        stimList = [3, 5, 7, 9];
        thisUnit = ' [ms] gap width';
        stimDur  = 3250*sr_mult; % ms
        stimITI  = 500*sr_mult;
        thisTag  = 'gapASSRRate';
        % 4th gap in noise block
        compDur2 = {1750:2000; 1750:2000; 1750:2000; ...
            1750:2000; 1750:2000; 1750:2000; 1750:2000};

    elseif contains(Condition,'Pupcall')
        stimList = 1;
        thisUnit = [];
        stimDur  = 25027*sr_mult; % 25.027 s
        stimITI  = 1000*sr_mult; % processing 1 s but ITI actually 5s
        thisTag  = 'single';
        compDur2 = 0; % DIDN'T CALCULATE

    end
end