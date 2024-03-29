function Group_Avrec_Layers(homedir,Group,Condition)

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
[stimList, thisUnit, stimDur, stimITI, ~] = StimVariable(Condition,1);
timeaxis = BL + stimDur + stimITI;


%% Choose Type

yesnorm = 1;            % 1 = normalize to highest Pre peak; 0 = don't

cd(homedir), cd figures, cd Group_Avrec

load([Group '_' Condition '_AvrecAll.mat'],'AvrecAll','PeakofAvg')
% avrecall  = stimulus x layer x subject {1 x time x trial}
% peakofavg = 1 per subject 

%% To Norm or not to Norm

% normalize to the peak of avrec activity during 70 dB noiseburst
Subject = 0;
if yesnorm == 1
    for iAn = 1:length(PeakofAvg)
        if isempty(PeakofAvg{iAn}) % skip empty ones
            continue
        end
        Subject = Subject + 1; % yes this isn't great, sorry
        for iStim = 1:size(AvrecAll,1)
            for iLay = 1:size(AvrecAll,2)
                % normalize each animal's measuremnt to their 2Hz peak
                % of activity of the Avrec. 
                toNormto = PeakofAvg{iAn};
                AvrecAll{iStim,iLay,Subject} = AvrecAll{iStim,iLay,iAn} ./ toNormto;
            end
        end
    end
end

% preaverage trials
AvrecAvg = cellfun(@(x) mean(x,3),AvrecAll,'UniformOutput',false);

%% generate figures


for iLay = 1:length(layers)

    figure('Name',[Group '_Traces_' Condition layers{iLay}], 'Position',[5 45 900 800]); 
    sgtitle([Group ' traces for ' layers{iLay} ' channels'])
    hold on
    for iStim = 1:length(stimList)
        subplot(length(stimList),1,iStim);
        title([num2str(stimList(iStim)) ' ' thisUnit])

        stackgroup = cat(1,AvrecAvg{iStim,iLay,:});
        
        shadedErrorBar(1:size(stackgroup,2),mean(stackgroup),std(stackgroup),'lineProps', '-b')
        xticks(0:200:timeaxis)
    end

    h = gcf;
    if yesnorm == 1
        savename = ['Norm ' Group '_Traces_' Condition '_' layers{iLay}];
    else
        savename = [Group '_Traces_' Condition '_' layers{iLay}];
    end
    savefig(h,savename,'compact')
    close (h)
end

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


