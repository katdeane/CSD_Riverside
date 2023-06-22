function ChirpData = icutChirpdata(homedir, file, StimIn, Data)

threshold = 0.09; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC 
location = threshold <= StimIn; % 1 is above, 0 is below 

% detect when signal crosses ABOVE threshold
% this means if throwoutfirst == 1, the first onset is second stim
crossover = diff(location);
onsets = find(crossover == 1);

% stim duration = 3000 ms (1 s noise, 2 s chirp) + ITI = 2000 ms
stimITI = 5000;
BL = 399; % baseline ms

ChirpData = struct;
curData = NaN(size(Data,1), stimITI + BL + 1, length(onsets));

% now we can cut out the time points around onsets corresponding to
% specific dB
for iOn = 1:length(onsets)

    curData(:,:,iOn) = Data(:,onsets(iOn)-BL:onsets(iOn)+stimITI);

end

ChirpData.filename = file;
ChirpData.LFP      = curData;

% also save it out, no need to run multiple times
cd(homedir); cd output
filename = [file '_Chirp.mat'];
save(filename, 'ChirpData')
cd(homedir)


