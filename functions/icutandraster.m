function DataOut = icutandraster(file, StimIn, Data, checkStimList, BL, stimdur, ITI, thistype)
% this function takes any type of data input and returns truncated epochs
% sorted by stimulus 

if ~exist('thistype','var')
    thistype = 'noise';  % 'stack' or 'single'
end

%% get the stimulus onsets

stim_threshold = 0.09; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC 
location = stim_threshold <= StimIn; % 1 is above, 0 is below 

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

%% Raster data - find MUAs
Data = abs(Data);
rasData = NaN(size(Data,1),size(Data,2));
for ichan = 1:size(rasData,1)
    
    dat_threshold = (std(Data(ichan,1:BL))*3) + mean(Data(ichan,1:BL));
    spikeloc = (dat_threshold <= Data(ichan,:));
    
    % look at each plot to figure things out. Is this good? 
    plot(Data(ichan,1:984666))
    hold on
    dat_threshold_line = dat_threshold * ones(1,984666);
    plot(dat_threshold_line)
    plot(spikeloc(1:984666)*5)
    hold off
    
    rasData(ichan,:) = spikeloc;
end
close
%% timing info 

% stim duration + ITI (ms)
stimITI = stimdur+ITI; % ms

%% stack or source the pseudorandom list

if matches(thistype, 'Tonotopy') || matches(thistype, 'ClickRate') ...
        || matches(thistype, 'gapASSRRate')
    % pre-psuedorandomized tone list for this subject
    stimList = readmatrix([file(1:6) thistype '.txt'])';
    shortlist = unique(stimList);
    shortlist = shortlist(shortlist ~= 0);

    % this should match or something is wrong
    if length(shortlist) ~= length(checkStimList); error('stimlist doesnt match'); end

elseif matches(thistype, 'noise') % noise bursts
    
    stimList = zeros(1,length(checkStimList) * ...
        (ceil((length(onsets)+1)/length(checkStimList))));
    for iextend = 1:ceil((length(stimList)+1)/length(checkStimList))
        stimList(8*iextend-7:8*iextend) = checkStimList;
    end
    shortlist = checkStimList;
    
end

%% hardware stuff
% RPvdsEx always skips producing the first stim, which in this case is set to 0
% and do we also need to remove that first stim?
if throwoutfirst == 1
    stimList = stimList(3:length(onsets)+2);
elseif throwoutfirst == 0
    stimList = stimList(2:length(onsets)+1);
end

%% finally, pull the data
DataOut = cell(1,length(checkStimList));

% now we can cut out the time points around onsets corresponding to
% specific dB
for istim = 1:length(shortlist)
    
    cutHere = find(stimList == shortlist(istim));
    % create container for stacked data, channel x time(ms) x trials
    curData = NaN(size(rasData,1), stimITI + BL + 1, length(cutHere));
    
    for iOn = 1:length(cutHere)
        
        if onsets(cutHere(iOn)) + stimITI > size(rasData,2) % if last ITI cut short
            curData = curData(:,:,1:size(curData,3)-1);
            continue
        end
        
        curData(:,:,iOn) = rasData(:,onsets(cutHere(iOn))-BL:onsets(cutHere(iOn))+stimITI);
        
    end
    
    DataOut{istim} = curData;
    
end



