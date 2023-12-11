function Avrec_Layers(homedir, Group, Condition)

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
cd datastructs
input = dir([Group '*.mat']);
entries = length(input);
run([Group '.m']); % brings in animals, channels, Layer, and Cond

layers = {'All', 'II', 'IV', 'Va', 'Vb', 'VI'};

% The next part depends on the stimulus, pull the relevant details
[stimList, thisUnit, stimDur, ~, ~] = ...
    StimVariable(Condition,1);
BL = 399;

% set up simple cell sheets to hold all data: avrec of total/layers and
% peaks of pre conditions
AvrecAll = cell(length(stimList),length(layers),entries);
PeakofAvg = cell(1,entries);
PeakData = array2table(zeros(0,9));

% loop through number of Data mats in folder
for i_In = 1:entries
    
    % load the animal data in
    load(input(i_In).name,'Data')
    AnName = input(i_In).name(1:5);
    
    % one output per subject
    index = StimIndex({Data.Condition},Cond,i_In,Condition);
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
        
        h = figure('Name',['Trace_' layers{iLay} '_' AnName],'Position',[10 10 1080 1200]);
        sgtitle([AnName ' ' Condition ' trace of ' layers{iLay} ' channels'])
        hold on % to your hats
        
        for iStim = 1:length(stimList)
            
            % 1 subplot per stimulus
            subplot(length(stimList),1,iStim);
            
            % this data is what we're working with
            curCSD = Data(index).sngtrlCSD{1, iStim};
            
            % take an average of all channels (already averaged across trials)
            if contains(layers{iLay}, 'All')
                % "All" channels takes the AVREC
                % pull out and average rectify each measurement
                recCSD  = abs(curCSD);
                traceCSD  = mean(recCSD,1); % this is the avrec
                
                % plot them with shaded error bar
                shadedErrorBar(1:size(traceCSD,2),mean(traceCSD,3),std(traceCSD,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])
            else
                % Layers take the nan-sourced CSD (also flipped)
                thislay = str2num(Layer.(layers{iLay}){i_In});
                curLay  = curCSD(thislay,:,:);

                traceCSD = curLay * -1;         % flip it
                traceCSD(traceCSD < 0) = NaN;   % nan-source it
                traceCSD = nanmean(traceCSD,1); % average it (with nans)
                traceCSD(isnan(traceCSD)) = 0;  % replace nans with 0s for consecutive line

                % plot them with shaded error bar
                shadedErrorBar(1:size(traceCSD,2),mean(traceCSD,3),std(traceCSD,0,3),'lineprops','b');
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
                title([num2str(stimList(iStim)) ' ' thisUnit])
            end
            
            if contains('All',layers{iLay}) && iStim==6 && contains('NoiseBurst',Condition)
                % only for the avrec 70 dB noiseburst;
                % store the highest peak of each measurement for later correction;
                % correction will be per animal so all layers
                % and frequencies will be corrected by this output
                PeakofAvg(i_In) = {max(max(traceCSD,[],2))};
            end
            
            % peak detection over single trials
            if matches(Condition, 'ClickTrain')
                reprate = stimList(iStim);
                newBL = BL;
            elseif matches (Condition, 'gapASSR')
                reprate = 2; % every 500 ms to detect onset response to gap-noise
                newBL = BL + 250; % adding noise before first gap-noise
            else 
                reprate = 1;
                newBL = BL;
            end
            
            [peakout,latencyout,rmsout] = consec_peaks(traceCSD, ...
                reprate, stimDur, newBL);
            
            parfor iTrial = 1:size(peakout,2)
                for itab = 1:size(peakout,1)
                    CurPeakData = table({Group}, {AnName}, {layers{iLay}}, ...
                        {iTrial}, stimList(iStim), {itab}, peakout(itab,iTrial), ...
                        latencyout(itab,iTrial),rmsout(itab,iTrial));
                    
                    PeakData = [PeakData; CurPeakData]; %#ok<*AGROW>
                    
                end
            end
            
            % and store the it single trial
            AvrecAll{iStim,iLay,i_In} = traceCSD;
            hold off
        end
        
        linkaxes
        savefig(h,[Condition '_Trace_' layers{iLay} '_' AnName],'compact')
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
save([Group '_' Condition '_AvrecAll'],'AvrecAll','PeakofAvg');

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

cd(homedir)
