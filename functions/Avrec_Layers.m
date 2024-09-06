function Avrec_Layers(homedir, Group, Condition, type)

% This script takes *.mat files out of the datastructs/ folder.It then plots the
% Avrecs for each animal over the specified stimulus Condition
%
%Input:     ..\datastructs\[Group * '_Data.mat']
%
%Output:    Figures of in "Single_Avrec" are for all stim types.
%           Data out as *.mat files for each type of measurement in
%           "Group_Avrec". mat files contain sorted AVREC
%           data and the first peak amp detected for each subject's last
%           noise condition at 70 db SPL.These are for
%           normalization and averaging in group scripts (next step)
%
%   Peak detection is only at onset except in the case of ClickTrain, where
%   it matches the stimList, and of gapASSR where it's alligned to each
%   onset of gap-interrupted-noise (aka gap-noise).
%
%   Peak detection is already single trial here

cd(homedir)

%% Load in
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

layers = {'All', 'II', 'IV', 'Va', 'Vb', 'VI'};
BL = 399;

% set up simple cell sheets to hold all data: avrec of total/layers and
% peaks of pre conditions
PeakData = array2table(zeros(0,9));

% loop through number of Data mats in folder
for iSub = 1:subjects

    % The next part depends on the stimulus, pull the relevant details
    if matches(animals(iSub),'FOS01') % hopefully the only exception :D
        [stimList, thisUnit, stimDur, ~, ~] = ...
            StimVariable(Condition,1,'Awake1');
    else
        [stimList, thisUnit, stimDur, ~, ~] = ...
            StimVariable(Condition,1,type);
    end

    if matches(Group, 'MWT') && matches(Condition, 'NoiseBurst') ...
            && matches(animals{iSub},'MWT16b')
        continue % special case, two noiseburst from same subject due to
        % probe movement - don't count both for group
    end

    % load the animal data in
    load([animals{iSub} '_Data.mat'],'Data');
    AnName = animals{iSub};

    % one output per subject
    index = StimIndex({Data.Condition},Cond,iSub,Condition);
    % if no stim of this type for this subject, continue on
    if isempty(index)
        continue
    end

    cd(homedir); cd figures;
    if exist('Single_Avrec','dir')
        cd Single_Avrec;
    else
        mkdir Single_Avrec, cd Single_Avrec;
    end

    % loop through the avrec and layer traces
    for iLay = 1:length(layers)

        figure(1)
        CSDfig = tiledlayout('flow');
        title(CSDfig,[AnName ' ' Condition ' CSD trace of ' layers{iLay} ' channels'])
        xlabel(CSDfig, 'time [ms]')
        ylabel(CSDfig, 'depth [channels]')

        figure(2)
        LFPfig = tiledlayout('flow');
        title(LFPfig,[AnName ' ' Condition ' LFP trace of ' layers{iLay} ' channels'])
        xlabel(LFPfig, 'time [ms]')
        ylabel(LFPfig, 'depth [channels]')

        for iStim = 1:length(stimList)

            % this data is what we're working with
            curCSD = Data(index).sngtrlCSD{1, iStim};
            curLFP = Data(index).sngtrlLFP{1, iStim};

            % take an average of all channels (already averaged across trials)
            if contains(layers{iLay}, 'All')
                % "All" channels takes the AVREC
                % pull out and average rectify each measurement
                recCSD  = abs(curCSD);
                traceCSD  = nanmean(recCSD,1); % this is the avrec

                % plot them with shaded error bar
                figure(1); nexttile
                shadedErrorBar(1:size(traceCSD,2),nanmean(traceCSD,3),nanstd(traceCSD,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])

                recLFP    = abs(curLFP);
                traceLFP  = nanmean(recLFP,1); % this is the avrec

                % plot them with shaded error bar
                figure(2); nexttile
                shadedErrorBar(1:size(traceLFP,2),nanmean(traceLFP,3),nanstd(traceLFP,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])
            else
                % Layers take the nan-sourced CSD (also flipped)
                thislay = str2num(Layer.(layers{iLay}){iSub});
                curLay  = curCSD(thislay,:,:);

                traceCSD = curLay * -1;         % flip it
                traceCSD(traceCSD < 0) = NaN;   % nan-source it
                traceCSD = nanmean(traceCSD,1); % average it (with nans)
                traceCSD(isnan(traceCSD)) = 0;  % replace nans with 0s for consecutive line

                % plot them with shaded error bar
                figure(1); nexttile
                shadedErrorBar(1:size(traceCSD,2),nanmean(traceCSD,3),nanstd(traceCSD,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])

                % Layers take the nan-sourced LFP (also flipped)
                curLay  = curLFP(thislay,:,:);

                traceLFP = curLay * -1;         % flip it
                traceLFP(traceLFP < 0) = NaN;   % nan-source it
                traceLFP = nanmean(traceLFP,1); % average it (with nans)
                traceLFP(isnan(traceLFP)) = 0;  % replace nans with 0s for consecutive line

                % plot them with shaded error bar
                figure(2); nexttile
                shadedErrorBar(1:size(traceLFP,2),nanmean(traceLFP,3),nanstd(traceLFP,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])
            end

            if contains('All',layers{iLay}) && iStim==6 && contains('NoiseBurst',Condition)
                % only for the avrec 70 dB noiseburst;
                % store the highest peak of each measurement for later correction;
                % correction will be per animal so all layers
                % and frequencies will be corrected by this output
                PeakofAvgCSD(iSub) = {max(max(traceCSD,[],2))};
                PeakofAvgLFP(iSub) = {max(max(traceLFP,[],2))};
            elseif contains('All',layers{iLay}) && iStim == 1
                % in every other case, just take the first stim 
                PeakofAvgCSD(iSub) = {max(max(traceCSD,[],2))};
                PeakofAvgLFP(iSub) = {max(max(traceLFP,[],2))};
            end

            % peak detection over single trials
            if matches(Condition, 'ClickTrain')
                reprate = stimList(iStim);
            else
                reprate = 1;
            end

            % includes condition specific detection windows, pupcall will
            % take certain pre-selected windows at determined call times
            if matches(Condition, 'Pupcall30')
                [peakout,latencyout,rmsout] = pupcall_peaks(traceCSD, ...
                    [1,15,29,44,60]); % pup call order ; was [1, 4, 9, 13, 18]
            else
                [peakout,latencyout,rmsout] = consec_peaks(traceCSD, ...
                    reprate, stimDur, BL, Condition);
            end

            parfor iTrial = 1:size(peakout,2) 
                for itab = 1:size(peakout,1)

                    CurPeakData = table({Group}, {AnName}, {layers{iLay}}, ...
                        {iTrial}, stimList(iStim), {itab}, peakout(itab,iTrial), ...
                        latencyout(itab,iTrial),rmsout(itab,iTrial));

                    PeakData = [PeakData; CurPeakData]; %#ok<*AGROW>

                end
            end

            % and store the it single trial
            AvrecCSDAll{iStim,iLay,iSub} = traceCSD;
            AvrecLFPAll{iStim,iLay,iSub} = traceLFP;
            hold off
        end

        figure(1); linkaxes
        h = gcf;
        savefig(h,[Condition '_CSDTrace_' layers{iLay} '_' AnName],'compact')
        % saveas(h,[Condition '_CSDTrace_' layers{iLay} '_' AnName '.png'])
        close (h)

        figure(2); linkaxes
        h = gcf;
        savefig(h,[Condition '_LFPTrace_' layers{iLay} '_' AnName],'compact')
        close (h)
    end

    cd(homedir);
end

% save it out
cd(homedir); cd figures;
if exist('Group_Avrec','dir')
    cd Group_Avrec;
else
    mkdir Group_Avrec, cd Group_Avrec;
end
if exist('AvrecCSDAll','var')
    save([Group '_' Condition '_AvrecCSDAll'],'AvrecCSDAll','PeakofAvgCSD');
    save([Group '_' Condition '_AvrecLFPAll'],'AvrecLFPAll','PeakofAvgLFP');

    % save out collected peaks too
    % give the table variable names after everything is collected
    PeakData.Properties.VariableNames = {'Group','Animal','Layer','trial',...
        'ClickFreq','OrderofClick','PeakAmp','PeakLat','RMS'};

    % save the table in the main folder - needs to be moved to the Julia folder
    % for stats
    cd(homedir); cd output;
    if exist('TracePeaks','dir')
        cd TracePeaks;
    else
        mkdir TracePeaks, cd TracePeaks;
    end
    writetable(PeakData,[Group '_' Condition '_AVRECPeak.csv'])
end
cd(homedir)
