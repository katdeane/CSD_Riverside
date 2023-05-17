%% Pipeline for LFP Quick Feedback

clear; clc;
cd('E:\Riverside'); % change for your station
homedir = pwd; 
addpath(genpath(homedir));

%% Get data from .xdat files
 
Data = FileReader;

reader = allegoXDatFileReaderR2019b;

datasource = 'FMT01_04_LFP';

timerange = reader.getAllegoXDatTimeRange(datasource);

signalStruct = reader.getAllegoXDatAllSigs(datasource, timerange);

size(signalStruct.signals)
size(signalStruct.timeSamples)

plot(signalStruct.timeSamples(:), signalStruct.signals(33, :))
plot(signalStruct.timeSamples(:), signalStruct.signals(2,:))

% with current folder set to ~/radix/data, list available files
% >> dir
% 
% . 
% ..
% import_test_xdat__uid1003-10-43-13.xdat.json      
% import_test_xdat__uid1003-10-43-13_data.xdat      
% import_test_xdat__uid1003-10-43-13_timestamp.xdat 
% 
% create the reader
% >> reader = allegoXDatFileReader
% 
% reader = 
% 
%   struct with fields:
% 
%       getAllegoXDatAllSigs: @getAllegoXDatAllSigs
%       getAllegoXDatPriSigs: @getAllegoXDatPriSigs
%       getAllegoXDatAuxSigs: @getAllegoXDatAuxSigs
%       getAllegoXDatDinSigs: @getAllegoXDatDinSigs
%      getAllegoXDatDoutSigs: @getAllegoXDatDoutSigs
%     getAllegoXDatTimeRange: @getAllegoXDatTimeRange
% 
% choose the file to import. Just use the base name, not the extension or the '_data' or '_timestamp' portions
% >> datasource = 'import_test_xdat__uid1003-10-43-13'
% 
% datasource =
% 
%     'import_test_xdat__uid1003-10-43-13'
% 
% view the time range of the file
% >> reader.getAllegoXDatTimeRange(datasource)
% 
% ans =
% 
%     1.9565    7.1424
% 
% import all the signals with timestamps from 2 through 6 seconds
% >> signalStruct = reader.getAllegoXDatAllSigs(datasource, [2 6])
% 
% signalStruct = 
% 
%   struct with fields:
% 
%         signals: [134Ã—120000 single]
%      timeStamps: [1Ã—120000 int64]
%     timeSamples: [1Ã—120000 double]
% 
% plot a subset of the data
% >> plot(signalStruct.timeSamples(1:100), signalStruct.signals(1:10, 1:100))
% 
% import all the signals with all the timestamps
% >> signalStruct = reader.getAllegoXDatAllSigs(datasource, [-1 -1]);