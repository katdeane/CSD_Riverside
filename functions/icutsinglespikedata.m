function DataOut = icutsinglespikedata(StimIn, Data, BL, stimdur, ITI, thistype)

%% Raster data - find MUAs
Data = abs(Data);
rasData = NaN(size(Data,1),size(Data,2));
for ichan = 1:size(rasData,1)
    
    dat_threshold = (std(Data(ichan,1:BL))*3) + mean(Data(ichan,1:BL));
    spikeloc = (dat_threshold <= Data(ichan,:));
    
    % look at each plot to figure things out. Is this good? 
%     plot(Data(ichan,1:10000))
%     hold on
%     dat_threshold_line = dat_threshold * ones(1,984666);
%     plot(dat_threshold_line)
%     plot(spikeloc(1:984666)*5)
%     hold off
    
    rasData(ichan,:) = spikeloc;
end
close

%% timing info 

% stim duration + ITI (ms)
stimITI = stimdur+ITI; % ms

%% cut and stack
if matches(thistype, 'spont')

    % truncate data in 2 second intervals, no space between (can be
    % restacked)
    onsets = 1:stimITI:size(rasData,2);
    % cut off end if it doesn't reach the right amount of time
    onsets = onsets(1:floor(size(rasData,2)/stimITI));

    curData = NaN(size(rasData,1), stimITI, length(onsets));

    % now we can cut out the time points around onsets corresponding to
    % specific dB
    for iOn = 1:length(onsets)

        curData(:,:,iOn) = rasData(:,onsets(iOn):onsets(iOn)+stimITI-1);

    end

    % this format lets it run through the rest of the script without
    % changes
    DataOut{1} = curData;

elseif matches(thistype, 'single')

    threshold = 0.09; %microvolts, constant input of at least 0.1 through analog channel from RZ6 to XDAC
    location = threshold <= StimIn; % 1 is above, 0 is below

    % detect when signal crosses ABOVE threshold
    % this means if throwoutfirst == 1, the first onset is second stim
    crossover = diff(location);
    onsets = find(crossover == 1);

    curData = NaN(size(rasData,1), stimITI + BL + 1, length(onsets));

    % now we can cut out the time points around onsets corresponding to
    % specific dB
    for iOn = 1:length(onsets)

        curData(:,:,iOn) = rasData(:,onsets(iOn)-BL:onsets(iOn)+stimITI);

    end

    DataOut{1} = curData;

end




