function [stimIn, data] = FileReaderLFP(file,channels)
% This converts the data from allego/curate and downsamples it by 30. That
% results in sr = 1000 (1000 sp in 1 second / each sp is 1 ms)
% initalized NeuroNexus conversion function
reader = allegoXDatFileReaderR2019b;

timerange = reader.getAllegoXDatTimeRange(file);
signalStruct = reader.getAllegoXDatAllSigs(file, timerange);

%% fs is 30k, we will downsample to 1k

% sanity check: 
% timeSamples = downsample(signalStruct.timeSamples,30); % seconds
stimIn      = downsample(signalStruct.signals(33,:),30); % microvolts
if exist('channels','var')
    % take the channels input variable
    data = downsample(signalStruct.signals(channels(1):channels(2),:)',30)';
else % or
    % allow the user to change how many channels are analyzed
    prompt   = {'First Chan:','Last Chan:'};
    dlgtitle = 'Channels';
    dims     = [1 35];
    definput = {'1','32'};
    channels = inputdlg(prompt,dlgtitle,dims,definput);
    % downsample with that info it's 30k sr, I want 1k
    data = downsample(signalStruct.signals(str2double(channels{1}):str2double(channels{2}),:)',30)';
end

