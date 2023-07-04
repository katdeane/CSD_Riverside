function [stimIn, data] = FileReaderSpike(file,channels)
% This converts the data from allego/curate and downsamples it by 30. That
% results in sr = 1000 (1000 sp in 1 second / each sp is 1 ms)
% initalized NeuroNexus conversion function
reader = allegoXDatFileReaderR2019b;

timerange = reader.getAllegoXDatTimeRange(file);
signalStruct = reader.getAllegoXDatAllSigs(file, timerange);

%% fs is 30k, we will downsample to 3k

% sanity check: 
% timeSamples = downsample(signalStruct.timeSamples,30); % seconds
stimIn = downsample(signalStruct.signals(33,:),10); % microvolts
data   = downsample(signalStruct.signals(channels(1):channels(2),:)',10)';

