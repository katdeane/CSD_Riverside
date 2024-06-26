function Group_Avrec_Layers(homedir,Group,Condition,type)

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


%% Choose Type

yesnorm = 0;            % 1 = normalize to highest Pre peak; 0 = don't

cd(homedir), cd figures, cd Group_Avrec

load([Group '_' Condition '_AvrecCSDAll.mat'],'AvrecCSDAll','PeakofAvgCSD')
load([Group '_' Condition '_AvrecLFPAll.mat'],'AvrecLFPAll','PeakofAvgLFP')
% avrecall  = stimulus x layer x subject {1 x time x trial}
% peakofavg = 1 per subject

%% To Norm or not to Norm

% normalize to the peak of avrec activity during 70 dB noiseburst or first
% peak of first stimulus (if not noiseburst)
Subject = 0;
if yesnorm == 1
    for iAn = 1:length(PeakofAvgCSD)
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
    for iAn = 1:length(PeakofAvgLFP)
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
AvrecCSDAvg = cellfun(@(x) mean(x,3),AvrecCSDAll,'UniformOutput',false);
AvrecLFPAvg = cellfun(@(x) mean(x,3),AvrecLFPAll,'UniformOutput',false);

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
        if matches(Condition, 'ClickTrain')
            reprate = stimList(iStim);
        else
            reprate = 1;
        end
        for iSub = 1:size(stackgroup,1)
            [peakout,latencyout,rmsout] = consec_peaks(stackgroup(iSub,:), ...
                reprate, stimDur, BL, Condition);

            for itab = 1:size(peakout,1)
                CurPeakData = table({Group}, {iSub}, {layers{iLay}}, ...
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


