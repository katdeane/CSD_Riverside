function [stimIn, data] = FileReader(file)
% This function produces figures for either tonotopies or noise bursts based
% on the selected file and type. It will also generate an averaged raw data
% file. For full (single trial) data file, run ___tbd____ funtion 

% initalized NeuroNexus conversion function
reader = allegoXDatFileReaderR2019b;

timerange = reader.getAllegoXDatTimeRange(file);
signalStruct = reader.getAllegoXDatAllSigs(file, timerange);

%% fs is 30k, we will downsample to 1k

% sanity check: 
% timeSamples = downsample(signalStruct.timeSamples,30); % seconds
stimIn      = downsample(signalStruct.signals(33,:),30); % microvolts
% allow the user to change how many channels are analyzed
prompt   = {'First Chan:','Last Chan:'};
dlgtitle = 'Channels';
dims     = [1 35];
definput = {'1','32'};
channels = inputdlg(prompt,dlgtitle,dims,definput);
% downsample with that info
data = downsample(signalStruct.signals(str2double(channels{1}):str2double(channels{2}),:)',30)';

