% This function 

reader = allegoXDatFileReaderR2019b;

% change the file type to "All Files"
% pick the file with the ending xdat.json
file = uigetfile;
file = file(1:end-10);

timerange = reader.getAllegoXDatTimeRange(file);

signalStruct = reader.getAllegoXDatAllSigs(file, timerange);

size(signalStruct.signals)
size(signalStruct.timeSamples)

plot(signalStruct.timeSamples(:), signalStruct.signals(33, :))
plot(signalStruct.timeSamples(:), signalStruct.signals(2,:))
