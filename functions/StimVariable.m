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
    
elseif matches(Condition{iStimType},'Tonotopy')
    stimList = [1, 2, 4, 8, 16, 24, 32];
    thisUnit = 'kHz';
    stimDur  = 200*sr_mult; % ms
    stimITI  = 1000*sr_mult;
    thisTag  = 'Tonotopy'; 
    
elseif matches(Condition{iStimType},'Spontaneous') || ...
        matches(Condition{iStimType},'postSpont')
    stimList = 1;
    thisUnit = [];
    stimDur  = 1000*sr_mult; % ms
    stimITI  = 1000*sr_mult;
    thisTag  = 'spont'; 
    
elseif matches(Condition{iStimType},'ClickTrain')
    stimList = [20, 30, 40, 50, 60, 70, 80, 90];
    thisUnit = 'dB';
    stimDur  = 2000*sr_mult; % ms
    stimITI  = 2000*sr_mult;
    thisTag  = 'ClickRate';
    
elseif matches(Condition{iStimType},'Chirp')
    stimList = 1;
    thisUnit = [];
    stimDur  = 3000*sr_mult; % ms
    stimITI  = 2000*sr_mult;
    thisTag  = 'single';
    
elseif matches(Condition{iStimType},'gapASSR')
    stimList = [2, 4, 6, 8, 10];
    thisUnit = ' [ms] gap width';
    stimDur  = 2000*sr_mult; % ms
    stimITI  = 2000*sr_mult;
    thisTag  = 'gapASSRRate';

end