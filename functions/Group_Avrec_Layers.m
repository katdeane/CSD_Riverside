function Group_Avrec_Layers(homedir,Group,Condition,type,Subjects)

% This script takes *.mat files out of the figures\Group_Avrec folder which is
% generated by the Avrec_Layers.m script. MAKE SURE you run the previous
% Avrec script on the current group.m and datastructs\*_DATA.mat so that things match
% up. This script is dynamic in group size but will need tweaking if a
% group is added.

%Input:     ..\Figures\Group_Avrec -> *AvrecAll.mat
%Output:    ..\Figures\Group_Avrec -> figures of full and layer-wise Avrecs
%           pre laser and post laser, including standard deviation

% Normalization of the layer to the highest peak of the average trace of
%   measurements can be toggled (yesnorm)

% set some species specific variables:
BL     = 399;
layers = {'All', 'II', 'IV', 'Va', 'Vb', 'VI'};
[stimList, thisUnit, stimDur, stimITI, ~] = StimVariable(Condition,1,type);
timeaxis = BL + stimDur + stimITI;

% get subject list to account for a few different ways this script is
% currently being used (there is surely a better way)
run([Group '.m'])
subjects = animals; clear animals channels Cond Layer
if exist('Subjects','var') % do we have a grand list? if yes then...
    run([Subjects '.m'])
    fullList = animals; clear animals channels Cond Layer
    % fill the list with indexes for correct subjects
    subList   = zeros(1,length(subjects));
    for isub = 1:length(subjects)
        for ifill = 1:length(fullList)
            if matches(fullList{ifill},subjects{isub})
                subList(isub) = ifill;
            end
        end
    end
    FileName = Subjects;
else
    subList = 1:length(subjects);
    FileName = Group;
end

% chirp 70 FYN10_02 is withheld so it never filled the 40th row
if matches(subjects{end},'FYN10') && matches(Condition,'Chirp70')
    subList = subList(1:end-1);
elseif matches(subjects{end},'TWT10') && matches(Condition,'gapASSR')
    subList = subList(1:end-1);
end

%% Choose Type

yesnorm = 0;            % 1 = normalize to highest Pre peak; 0 = don't

cd(homedir), cd figures, cd Group_Avrec

% if no data or if it's an 80 dB measurement on young FVB mice, skip
if exist([FileName '_' Condition '_AvrecCSDAll.mat'],'file')
    if contains(Condition,'80') && contains(Group,'Y')
        disp('skipping')
    else
        load([FileName '_' Condition '_AvrecCSDAll.mat'],'AvrecCSDAll','PeakofAvgCSD')
        load([FileName '_' Condition '_AvrecLFPAll.mat'],'AvrecLFPAll','PeakofAvgLFP')

        % now get the correct subjects out if there was a grand list
        AvrecCSDAll = AvrecCSDAll(:,:,subList);
        AvrecLFPAll = AvrecLFPAll(:,:,subList);

        % avrecall  = stimulus x layer x subject {1 x time x trial}
        % peakofavg = 1 per subject

        %% To Norm or not to Norm

        % normalize to the peak of avrec activity during 70 dB noiseburst or first
        % peak of first stimulus (if not noiseburst)
        Subject = 0;
        if yesnorm == 1
            for iAn = 1:length(subjects)
                if isempty(PeakofAvgCSD{iAn}) % skip empty ones
                    continue
                end
                Subject = Subject + 1; % yes this isn't great, sorry
                for iStim = 1:size(AvrecCSDAll,1)
                    for iLay = 1:size(AvrecCSDAll,2)
                        % normalize each animal's measuremnt to their 2Hz peak
                        % of activity of the Avrec.
                        toNormto = PeakofAvgCSD{iAn};
                        AvrecCSDAll{iStim,iLay,Subject} = AvrecCSDAll{iStim,iLay,iAn} ./ toNormto;
                    end
                end
            end
            for iAn = 1:length(subjects)
                if isempty(PeakofAvgLFP{iAn}) % skip empty ones
                    continue
                end
                Subject = Subject + 1; % yes this isn't great, sorry
                for iStim = 1:size(AvrecLFPAll,1)
                    for iLay = 1:size(AvrecLFPAll,2)
                        % normalize each animal's measuremnt to their 2Hz peak
                        % of activity of the Avrec.
                        toNormto = PeakofAvgLFP{iAn};
                        AvrecLFPAll{iStim,iLay,Subject} = AvrecLFPAll{iStim,iLay,iAn} ./ toNormto;
                    end
                end
            end
        end

        % preaverage trials
        AvrecCSDAvg = cellfun(@(x) nanmean(x,3),AvrecCSDAll,'UniformOutput',false);
        AvrecLFPAvg = cellfun(@(x) nanmean(x,3),AvrecLFPAll,'UniformOutput',false);

        %% generate figures and detect average peaks

        AvgPeakData = array2table(zeros(0,8));

        for iLay = 1:length(layers)

            figure(1)
            CSDfig = tiledlayout('flow');
            title(CSDfig,[Group ' ' Condition ' CSD trace of ' layers{iLay} ' channels'])
            xlabel(CSDfig, 'time [ms]')
            ylabel(CSDfig, 'depth [channels]')

            figure(2)
            LFPfig = tiledlayout('flow');
            title(LFPfig,[Group ' ' Condition ' LFP trace of ' layers{iLay} ' channels'])
            xlabel(LFPfig, 'time [ms]')
            ylabel(LFPfig, 'depth [channels]')

            for iStim = 1:length(stimList)
                % CSD
                figure(1); nexttile
                title([num2str(stimList(iStim)) ' ' thisUnit])
                stackgroup = cat(1,AvrecCSDAvg{iStim,iLay,:});
                shadedErrorBar(1:size(stackgroup,2),mean(stackgroup),std(stackgroup),'lineProps', '-b')
                xticks(0:200:timeaxis)

                % peak detection
                if contains(Condition, 'ClickTrain')
                    reprate = stimList(iStim);
                else
                    reprate = 1;
                end
                for iSub = 1:size(stackgroup,1)
                    if matches(Condition, 'Pupcall30')
                        [peakout,latencyout,rmsout] = pupcall_peaks(stackgroup(iSub,:), ...
                            1:60); % pup call order
                    elseif (contains(Group,'VM') || contains(Group,'PM')) && ...
                            matches(Condition, 'NoiseBurst')
                        [peakout,latencyout,rmsout] = consec_peaks_longNB(stackgroup(iSub,:), BL);
                    else
                        [peakout,latencyout,rmsout] = consec_peaks(stackgroup(iSub,:), ...
                            reprate, stimDur, BL, Condition);
                    end

                    for itab = 1:size(peakout,1)
                        CurPeakData = table({Group}, subjects(iSub), {layers{iLay}}, ...
                            stimList(iStim), {itab}, peakout(itab), ...
                            latencyout(itab), rmsout(itab));

                        AvgPeakData = [AvgPeakData; CurPeakData]; %#ok<*AGROW>
                    end
                end

                % LFP
                figure(2); nexttile
                title([num2str(stimList(iStim)) ' ' thisUnit])
                stackgroup = cat(1,AvrecLFPAvg{iStim,iLay,:});
                shadedErrorBar(1:size(stackgroup,2),mean(stackgroup),std(stackgroup),'lineProps', '-b')
                xticks(0:200:timeaxis)
            end

            if yesnorm == 1
                savenamecsd = ['Norm ' Group '_CSDTraces_' Condition '_' layers{iLay}];
                savenamelfp = ['Norm ' Group '_LFPTraces_' Condition '_' layers{iLay}];
            else
                savenamecsd = [Group '_CSDTraces_' Condition '_' layers{iLay}];
                savenamelfp = [Group '_LFPTraces_' Condition '_' layers{iLay}];
            end
            figure(1); linkaxes; h = gcf;
            savefig(h,savenamecsd,'compact')
            close (h)
            figure(2); linkaxes; h = gcf;
            savefig(h,savenamelfp,'compact')
            close (h)
        end

        AvgPeakData.Properties.VariableNames = {'Group','Animal','Layer',...
            'ClickFreq','OrderofClick','PeakAmp','PeakLat','RMS'};

        % save the table in the main folder - needs to be moved to the Julia folder
        % for stats
        cd(homedir); cd output;
        if exist('TracePeaks','dir')
            cd TracePeaks;
        else
            mkdir TracePeaks, cd TracePeaks;
        end
        writetable(AvgPeakData,[Group '_' Condition '_AVG_AVRECPeak.csv'])

    end
end
cd(homedir)

%% Normalized Avrec peak detection
% Normalization is happening on the trace before peak detection. The trace
% is normalized to the maximum point of the average trace for each
% frequency / layer / subject. That would take an average of 13 traces for
% the CIC group for example, find the max of the signal, and divid all 13
% by that maximum

% TO DO - write this up for stats, still from legacy code

% if yesnorm == 1
%     PeakData = array2table(zeros(0,9));
%     % Avrec { stimulus frequency , layer , subject }
%     run([Group '.m']) % run group for animal names
%     % loop through the avrec and layer traces
%     for iLay = 1:length(layers)
%         % loop through stimulus frequencies
%         for iStim = 1:length(freqlist)
%             for iAn = 1:size(AvrecAll,3)
%
%                 thisMeas = AvrecAll{iStim,iLay,iAn};
%                 % pull out consecutive peak data
%                 [peakout,latencyout,rmsout] = consec_peaks(thisMeas, ...
%                     str2double(freqlist{iStim}(1:end-2)), BL);
%
%                 for iMeas = 1:size(peakout,1)
%                     for itab = 1:size(peakout,2)
%                         CurPeakData = table({animals{iAn}(1:end-2)}, animals(iAn), {layers{iLay}}, ...
%                             {iMeas}, freqlist(iStim), {itab}, peakout(iMeas,itab), ...
%                             latencyout(iMeas,itab),rmsout(iMeas,itab) );
%
%                         PeakData = [PeakData; CurPeakData];
%                     end
%                 end % measurement
%                 % got it for this Avrec entry here
%             end % subject
%         end % stimulus frequency
%     end % layer
%     PeakData.Properties.VariableNames = {'Group','Animal','Layer','Measurement',...
%         'ClickFreq','OrderofClick','PeakAmp','PeakLat','RMS'};
%
%     cd(homedir); cd(datfolder)
%     writetable(PeakData,'normAVRECPeak.csv')
% end
cd(homedir)


