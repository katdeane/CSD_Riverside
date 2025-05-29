function DataOut = icutdata(file, StimIn, Data, checkStimList, BL, stimdur, ITI, thistype)
% this function takes any type of data input and returns truncated epochs
% sorted by stimulus 

if ~exist('thistype','var')
    thistype = 'noise';  % 'stack' or 'single'
end

%% get the stimulus onsets

threshold = 0.01; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC 
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

%% timing info 

% stim duration + ITI (ms)
stimITI = stimdur+ITI; % ms

%% stack or source the pseudorandom list

if matches(thistype, 'Tonotopy') || matches(thistype, 'ClickRate') ...
        || matches(thistype, 'gapASSRRate')
    % pre-psuedorandomized tone list for this subject
    stimList = readmatrix([file(1:6) thistype '.txt'])';
    shortlist = unique(stimList(2:end)); % first row is unread

    % click list is of duration between clicks so 8.33 = 120 Hz
    % we want 1 hz (1000) first:
    if matches(thistype, 'ClickRate')
        shortlist =  sort(shortlist,"descend");
    end

    % this should match or something is wrong
    if length(shortlist) ~= length(checkStimList); error('stimlist doesnt match'); end

elseif matches(thistype, 'Mask')

    stimList = readmatrix('Masks4.txt')';
    shortlist = unique(stimList(2:end)); % first row is unread

elseif matches(thistype, 'noise') % noise bursts
    
    stimList = zeros(1,length(checkStimList) * ...
        (ceil((length(onsets)+1)/length(checkStimList))));
    for iextend = 1:ceil((length(stimList)+1)/length(checkStimList))
        stimList(8*iextend-7:8*iextend) = checkStimList;
    end
    shortlist = checkStimList;
    
end

% this is an issue for gapASSR where I have to manually stop the stimuli
% and I sometimes miss that it's finished until a few stim later. 
if length(onsets) > length(stimList)
    onsets = onsets(1:length(stimList)-1);
end

%% hardware stuff
% RPvdsEx always skips producing the first stim, which in this case is set to 0
% and do we also need to remove that first stim?
if throwoutfirst == 1
    if (length(onsets)+2) > length(stimList)
        stimList = stimList(3:length(onsets)+1);
    else
        stimList = stimList(3:length(onsets)+2);
    end
elseif throwoutfirst == 0
    if (length(onsets)+1) > length(stimList)
        stimList = stimList(2:length(onsets));
    else
        stimList = stimList(2:length(onsets)+1);
    end
end

%% finally, pull the data
DataOut = cell(1,length(checkStimList));

% now we can cut out the time points around onsets corresponding to
% specific dB
for istim = 1:length(shortlist)
    
    cutHere = find(stimList == shortlist(istim));
    % create container for stacked data, channel x time(ms) x trials
    curData = NaN(size(Data,1), stimITI + BL + 1, length(cutHere));
    
    for iOn = 1:length(cutHere)
        
        if onsets(cutHere(iOn)) + stimITI > size(Data,2) % if last ITI cut short
            curData = curData(:,:,1:size(curData,3)-1);
            continue
        end
        
        if (onsets(cutHere(iOn)) - BL) < 0 % first stim too fast! no BL (fastest fingers in the west)
            fakeBL = zeros(size(Data,1),((onsets(cutHere(iOn)) - BL)*-1)+1);
            data   = Data(:,1:onsets(cutHere(iOn))+stimITI);
            curData(:,:,iOn) = horzcat(fakeBL,data);
            clear data fakeBL
            continue
        end
        
        curData(:,:,iOn) = Data(:,onsets(cutHere(iOn))-BL:onsets(cutHere(iOn))+stimITI);
        
    end
    
    DataOut{istim} = curData;
    
end



