function ToneData = icutTonedata(homedir, file, StimIn, Data)

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

% stim duration = 200 ms + ITI = 1000 ms
stimITI = 1200;
BL = 399; % baseline ms
% pre-psuedorandomized tone list for this subject
toneList = readmatrix([file(1:6) 'Tonotopy.txt'])';

% get ready to sort, stack the list to match the amount of onsets if needed
while length(toneList) < length(onsets)
    toneList = [toneList toneList];
end

% RPvdsEx always skips producing the first stim, which in this case is set to 0
% and do we also need to remove that first stim?
if throwoutfirst == 1
    toneList = toneList(3:length(onsets)+2);
elseif throwoutfirst == 0
    toneList = toneList(2:length(onsets)+1);
end

shortlist = unique(toneList);
ToneData = struct;

% now we can cut out the time points around onsets corresponding to
% specific dB
for itone = 1:length(shortlist)
    
    cutHere = find(toneList == shortlist(itone));
    % create container for stacked data, channel x time(ms) x trials
    curData = NaN(size(Data,1), stimITI + BL + 1, length(cutHere));
    
    for iOn = 1:length(cutHere)
        
        if onsets(cutHere(iOn)) + stimITI > size(Data,2) % if last ITI cut short
            curData = curData(:,:,1:size(curData,3)-1);
            continue
        end
        
        curData(:,:,iOn) = Data(:,onsets(cutHere(iOn))-BL:onsets(cutHere(iOn))+stimITI);
        
    end
    
    ToneData(itone).filename = file;
    ToneData(itone).tone     = shortlist(itone);
    ToneData(itone).LFP      = curData;
    
end

% also save it out, no need to run multiple times
cd(homedir); cd output
filename = [file '_Tone.mat'];
save(filename, 'ToneData')


