function NoiseData = icutSpikeNoisedata(homedir, file, StimIn, DataIn)

threshold = 0.09; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC 
location = threshold <= StimIn; % 1 is above, 0 is below 
% do we need to throw out the first trial in this case? 
if location(1) == 1 % analog input already high
    throwoutfirst = 1;
else
    throwoutfirst = 0;
end
% detect when signal crosses ABOVE threshold
% this means if throwoutfirst == 1, the first onset is second stim
crossover = diff(location);
onsets = find(crossover == 1);

% sampling rate preserved for spiking data = 3000 points/second
sr = 3000;
% stim duration = 0.1 s + ITI = 1 s
stimITI = 1.1*sr; 
BL = 0.399*sr; % baseline (s)
% non randomized list of dB presentation
dBList = [20, 30, 40, 50, 60, 70, 80, 90];

% get ready to sort, stack the list to match the amount of onsets
dBListExtend = zeros(1,length(dBList) * (ceil((length(onsets)+1)/length(dBList))));
for iextend = 1:ceil((length(dBListExtend)+1)/length(dBList))
    dBListExtend(8*iextend-7:8*iextend) = dBList;
end

% do we need to remove that first stim?
if throwoutfirst == 1
    dBListExtend = dBListExtend(3:length(onsets)+2);
elseif throwoutfirst == 0
    % even if we don't need to throw out first, RPvdsEx doesn't play the
    % first stim in the list, so we skip to the second
    dBListExtend = dBListExtend(2:length(onsets)+1);
end

NoiseData = struct;

% now we can cut out the time points around onsets corresponding to
% specific dB
for idB = 1:length(dBList)
    
    cutHere = find(dBListExtend == dBList(idB));
    % create container for stacked data, channel x time(ms) x trials
    curData = NaN(size(DataIn,1), stimITI + BL + 1, length(cutHere));
    
    for iOn = 1:length(cutHere)
        
        if onsets(cutHere(iOn)) + stimITI > size(DataIn,2) % if last ITI cut short
            curData = curData(:,:,1:size(curData,3)-1);
            continue
        end
        
        curData(:,:,iOn) = DataIn(:,onsets(cutHere(iOn))-BL:onsets(cutHere(iOn))+stimITI);
        
    end
    
    NoiseData(idB).filename = file;
    NoiseData(idB).dB       = dBList(idB);
    NoiseData(idB).LFP      = curData;
    
end



