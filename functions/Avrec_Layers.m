function Avrec_Layers(homedir, Group, Condition)

% This script takes *.mat files out of the datastructs/ folder.It then plots the 
% Avrecs for each animal over the specified stimulus Condition

%Input:     ..\datastructs\[Group * '_Data.mat'] 

%Output:    Figures of in "Single_Avrec" are for Click, Amp modulation, and
%           Spontaneous measurements. Data out as *.mat files for each type 
%           of measurement in "Group_Avrec". mat files contain sorted AVREC 
%           data and the first peak amp detected for each AVREC. These are for
%           normalization and averaging in group scripts (next step)

% NOTE:     full list of frequency for click and amp stim: [2,5,10,20,40].
%           However, only 5 and 10 are being run here. Update variable:
%           freqlist to pull out the extra data

%% standard operations
dbstop if error

% Change directory to your working folder
if ~exist('homedir','var')
    if exist('E:\csd_interspecies','dir') == 7
        cd('E:\csd_interspecies');
    end
    homedir = pwd;
    addpath(genpath(homedir));
end

% set some species specific paths and data:
if contains(Group,'CIC')
    datfolder   = 'mouse_output';
    grouptype   = 'Mouse';
    freqlist    = {'2Hz' '5Hz' '10Hz' '20Hz' '40Hz'};
    BL          = 200;
    timelimit   = 1377;
    if ~exist('mouse_figures','dir')
        mkdir('mouse_figures')
    end
    figfolder   = 'mouse_figures';
    loadtext = '*byFreq.mat';
elseif contains(Group,'FAFAC')
    datfolder   = 'bat_output';
    grouptype   = 'Bat';
    freqlist    = {'2Hz' '5.28Hz' '8.57Hz' '22.63Hz' '36.76Hz'};
    BL          = 510;
    timelimit   = 3020;
    if ~exist('bat_figures','dir')
        mkdir('bat_figures')
    end
    figfolder   = 'bat_figures';
    loadtext = 'FAFAC*.mat';
else
    error('If this is a new group, please work it through the pipeline')
end
cd(homedir),cd(datfolder);

%% Load in
input = dir(loadtext);
entries = length(input);
layers = {'All', 'II', 'IV', 'V', 'VI'};

% set up simple cell sheets to hold all data: avrec of total/layers and
% peaks of pre conditions
AvrecAll = cell(length(freqlist),length(layers),entries);
PeakofAvg = cell(1,entries);
PeakData = array2table(zeros(0,9));

% loop through number of Data mats in folder
for i_In = 1:entries
    
    % load the animal data in
    load(input(i_In).name,'Data')
    if contains(grouptype,'Mouse')
        AnName = input(i_In).name(1:5);
    else
        AnName = input(i_In).name(1:7);
    end
        
    cd(homedir)
    if exist([figfolder '\Single_Avrec'],'dir')
        cd(figfolder), cd Single_Avrec;
    else
        cd(figfolder), mkdir Single_Avrec, cd Single_Avrec;
    end
    
    % loop through the avrec and layer traces
    for iLay = 1:length(layers)

        h = figure('Name',['Trace_' layers{iLay} '_' AnName],'Position',[10 10 1080 1200]);
        sgtitle([AnName ' trace of ' layers{iLay} ' channels'])
        hold on % to your hats
        
        for iStim = 1:length(freqlist)

            % get correct stim out of consistant order in data
            ThisStim = strcmp({Data.ClickFreq}, freqlist{iStim})==1;

            % 1 subplot per stimulus
            subplot(length(freqlist),1,iStim);

            % take an average of all channels (already averaged across trials)
            if contains(layers{iLay}, 'All')
                % "All" channels takes the AVREC
                % pull out and average rectify each measurement
                thisfreq  = Data(ThisStim).CSD;
                thisfreq  = cellfun(@abs, thisfreq, 'UniformOutput', false);
                thisfreq  = cellfun(@mean, thisfreq, 'UniformOutput', false);
                % vercat them doesn't work when lengths aren't consistent
                NumMeas   = length(thisfreq);
                allchan = NaN(NumMeas,timelimit);
                for iMeas = 1:NumMeas
                    % length(Data(ThisStim).CSD),time
                    allchan(iMeas,:) = thisfreq{1,iMeas}(1:timelimit);
                end
                % cut the time axis if it's too long for the species
                allchan = allchan(:,1:timelimit);
                % plot them with shaded error bar
                shadedErrorBar(1:timelimit,nanmean(allchan,1),nanstd(allchan),'lineprops','b');
                title([freqlist{iStim} ' Click'])
            else
                % Layers take the nan-sourced CSD (also flipped)
                thisfreq  = Data(ThisStim).CSD;
                thislay   = Data(1).(['Lay' layers{iLay}]); 
                NumMeas   = length(thisfreq);
                allchan = NaN(NumMeas,timelimit);
                for iMeas = 1:NumMeas
                    if isempty(thislay{iMeas})
                        continue % no layer data for this measurement/layer
                    end
                    % take the layer based on which measurement it is -
                    % relevant for bat data w/ seperate penetrations
                    thischan = thisfreq{iMeas}(thislay{iMeas},1:timelimit);
                    thischan = thischan * -1;         % flip it
                    thischan(thischan < 0) = NaN;     % nan-source it
                    thischan = nanmean(thischan,1);   % average it (with nans)
                    thischan(isnan(thischan)) = 0;    % replace nans with 0s for consecutive line
                    allchan(iMeas,:) = thischan;
                end
                % cut the time axis if it's too long for the species
                allchan = allchan(:,1:timelimit);
                % plot them with shaded error bar
                shadedErrorBar(1:timelimit,nanmean(allchan,1),nanstd(allchan),'lineprops','b');
                title([freqlist{iStim} ' Click'])
            end

            if contains('All',layers{iLay}) && contains('2Hz',freqlist{iStim})
                % only for the avrec 2 hz;
                % store the peak of each measurement for later correction; 
                % correction will be per animal/measurement so all layers
                % and frequencies will be corrected by this output
                PeakofAvg(i_In) = {max(allchan,[],2)};
            end

            % pull out consecutive peak data
            [peakout,latencyout,rmsout] = consec_peaks(allchan, ...
                str2double(freqlist{iStim}(1:end-2)), BL);

            for iMeas = 1:size(peakout,1)
                for itab = 1:size(peakout,2)
                    CurPeakData = table({AnName(1:end-2)}, {AnName}, {layers{iLay}}, ...
                        {iMeas}, freqlist(iStim), {itab}, peakout(iMeas,itab), ...
                        latencyout(iMeas,itab),rmsout(iMeas,itab));
                    
                    PeakData = [PeakData; CurPeakData];
                    
                end
            end

            % and store the lot
            AvrecAll{iStim,iLay,i_In} = allchan;
            hold off
        end

        savefig(h,['Trace_' layers{iLay} '_' AnName],'compact')
        close (h)
    end

    cd(homedir); 
end

% give the table variable names after everything is collected
PeakData.Properties.VariableNames = {'Group','Animal','Layer','Measurement',...
    'ClickFreq','OrderofClick','PeakAmp','PeakLat','RMS'};
                    
% save it out
cd(homedir)
if exist([figfolder '\Group_Avrec'],'dir')
    cd(figfolder), cd Group_Avrec;
else
    cd(figfolder), mkdir Group_Avrec, cd Group_Avrec;
end
save([grouptype '_AvrecAll'],'AvrecAll','PeakofAvg');

% save the table in the main folder - needs to be moved to the Julia folder
% for stats
cd(homedir); cd(datfolder)
writetable(PeakData,'AVRECPeak.csv')
cd(homedir)
