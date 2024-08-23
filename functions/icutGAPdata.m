function DataOut = icutGAPdata(file, StimIn, Data, checkStimList, BL, stimdur, ITI, thistype)
% this function takes any type of data input and returns truncated epochs
% sorted by stimulus. Gap data is dealt with differently because the
% RPvdsEx software does a terrible and odd blip for the first stimulus,
% only sometimes. We need to make a set of rules for consistently finding
% which recordings this happens on so that the stimulus presentation is
% scrambled upon application


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

% the first stim is marked by a down peak around 300 ms after onset. It's
% very consistent but the resting channel value is variable. We have then a
% dynamic lower threshold to check for the down peak after the stim onset
% time

% plot(StimIn(1:9000));
% ylim([-0.1 0.1])
% xline(onsets(1))
if (onsets(1)-3770) > 0

    firstsuspect = onsets(1)-3770;

    % take the mean and std of the 40 seconds around the stim 
    meansus = mean(StimIn(firstsuspect-20:firstsuspect+20));
    stdsus  = std(StimIn(firstsuspect-20:firstsuspect+20));
    
    % set the threshold for 10*std below mean (very little variability)
    lowthreshold = meansus-(stdsus*15); %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC 
    lowlocation = lowthreshold >= StimIn(firstsuspect:firstsuspect+500); % 0 is above, 1 is below 
    lowcrossover = diff(lowlocation);
    
    % xline(firstsuspect)
    % yline(meansus)
    % yline(meansus-stdsus)
    % yline(lowthreshold,'LineWidth',2)

    if ~isempty(find(lowcrossover == 1,1))
        onsets = [firstsuspect onsets];
    end

end

%% timing info 

% stim duration + ITI (ms)
stimITI = stimdur+ITI; % ms

%% stack or source the pseudorandom list

% pre-psuedorandomized tone list for this subject
stimList = readmatrix([file(1:6) thistype '.txt'])';
shortlist = unique(stimList(2:end)); % first row is unread

% this should match or something is wrong
if length(shortlist) ~= length(checkStimList); error('stimlist doesnt match'); end

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



