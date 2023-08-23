function DataOut = icutCFdata(StimIn, Data, levelList, toneList, BL, stimDur, stimITI, metafile)
% this function takes any type of data input and returns truncated epochs
% sorted by stimulus 

%% get the stimulus onsets

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

%% timing info 

% stim duration + ITI (ms)
stimITI = stimDur+stimITI; % ms

%% stack or source the pseudorandom list

% pre-psuedorandomized tone list for this subject
allLevels = readmatrix(['CFlevel' metafile])';
allTones  = readmatrix(['CFtones' metafile])';


%% hardware stuff
% RPvdsEx always skips producing the first stim, which in this case is set to 0
% and do we also need to remove that first stim? Also, match to length of
% onset here in case it's shorter
if throwoutfirst == 1
    allLevels = allLevels(3:length(onsets)+2);
    allTones  = allTones(3:length(onsets)+2);
elseif throwoutfirst == 0
    allLevels = allLevels(2:length(onsets)+1);
    allTones  = allTones(2:length(onsets)+1);
end

% all in a table for easy cutting
stimTab = [onsets',allLevels',allTones'];

%% finally, pull the data
% for interpretation later, this is set up to be tone frequencies by sound
% levels (DataOut(1,1) is tone 1, level 1, DataOut(1,2) is tone 2 level 1))
DataOut = cell(length(levelList),length(toneList));

% now we can cut out the time points around onsets corresponding to
% specific dB
for itone = 1:length(toneList)

    toneTab = stimTab(stimTab(:,3) == toneList(itone), :);

    for ilevel = 1:length(levelList)

        onsetList = toneTab(toneTab(:,2) == levelList(ilevel), 1);

        % create container for stacked data, channel x time(ms) x trials
        curData = NaN(size(Data,1), stimITI + BL + 1, length(onsetList));

        for iOn = 1:length(onsetList)

            curData(:,:,iOn) = Data(:,onsetList(iOn)-BL:onsetList(iOn)+stimITI);

        end

        DataOut{ilevel,itone} = curData;

    end

end

