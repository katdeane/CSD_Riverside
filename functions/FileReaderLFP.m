function [stimIn, data] = FileReaderLFP(file,channels,type)
% This converts the data from allego/curate, assuming it has already been 
% downsampled by 30. 
% sr = 1000 (1000 sp in 1 second / each sp is 1 ms)

if ~exist('type','var')
    type = 'Anesthetized'; % no artifact correction
end
% initalized NeuroNexus conversion function
reader = allegoXDatFileReaderR2019b;

timerange = reader.getAllegoXDatTimeRange(file);
signalStruct = reader.getAllegoXDatAllSigs(file, timerange);

% sanity check: 
% timeSamples = signalStruct.timeSamples; % seconds

% stimulus-in channel: 
stimIn = signalStruct.signals(33,:); % microvolts

% data channels:
if exist('channels','var')
    % take the channels input variable
    data = signalStruct.signals(channels,:);
else % or
    % allow the user to change how many channels are analyzed
    prompt   = {'First Chan:','Last Chan:'};
    dlgtitle = 'Channels';
    dims     = [1 35];
    definput = {'1','32'};
    channels = inputdlg(prompt,dlgtitle,dims,definput);
    data = signalStruct.signals(str2double(channels{1}):str2double(channels{2}),:);
end

% tiledlayout('flow')
% nexttile
% imagesc(data)
% % artifact correction on all awake data
% if matches(type,'Awake')
%     % threshold = 3 standard deviations
%     % duration  = 3 seconds of data above threshold
%     data = icorrectartifacts(data,3,3);
% end
% 
% nexttile
% imagesc(data)
% close



