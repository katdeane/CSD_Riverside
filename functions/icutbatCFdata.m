function DataOut = icutbatCFdata(StimIn, Data, BL, stimdur, ITI)
% this function takes any type of data input and returns truncated epochs
% sorted by stimulus

%% get the stimulus onsets

threshold = 0.05; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC
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

tones = readmatrix('CFtones2025-11-06_Bat.txt')';
level = readmatrix('CFlevel2025-11-06_Bat.txt')'; %NOTE that from BAT14, dB was shifted down by 20

% this is an issue for gapASSR where I have to manually stop the stimuli
% and I sometimes miss that it's finished until a few stim later.
if length(onsets) > length(tones)
    onsets = onsets(1:length(tones)-1);
end

%% hardware stuff
% RPvdsEx always skips producing the first stim, which in this case is set to 0
% and do we also need to remove that first stim?
if throwoutfirst == 1
    if (length(onsets)+2) > length(tones)
        tones = tones(3:length(onsets)+1);
        level = level(3:length(onsets)+1);
    else
        tones = tones(3:length(onsets)+2);
        level = level(3:length(onsets)+2);
    end
elseif throwoutfirst == 0
    if (length(onsets)+1) > length(tones)
        tones = tones(2:length(onsets));
        level = level(2:length(onsets));
    else
        tones = tones(2:length(onsets)+1);
        level = level(2:length(onsets)+1);
    end
end

levlist = unique(level);
tonlist = unique(tones);

%% finally, pull the data
% cell structure is 4 levels x 7 tones
DataOut = cell(length(levlist),length(tonlist));

% run through levels
for ilev = 1:length(levlist)

    % locations of all of this level
    cuttolev = find(level == levlist(ilev));
    % cut tone data to this
    curtones = tones(cuttolev);

    % run through tones
    for iton = 1:length(tonlist)

        cuttoton = find(curtones == tonlist(iton));
        cutHere = cuttolev(cuttoton); %#ok<*FNDSB> % location list now contains only pairing

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
        end % onsets
        DataOut{ilev,iton} = curData;
    end % tones
end % levels

end



