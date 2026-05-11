function AvgCSDfig(homedir, Group, Condition, cbar_csd, cbar_lfp, type)
%% Averaged CSD and LFP

% The purpose of this script is to provide an averaged group CSD for visual
% representation of each group for each stimulus type

%Input:     datastructs\ *.mat
%Output:    \figures\Average_CSD or _LFP; figures only for representation of
%           characteristic profile

% variables: Group ('MWT'); Condition ('NoiseBurst')

% some presets
BL         = 400;
chanlength = 32; % the MAXIMUM amount of channels

%% Load in info

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

% The next part depends on the stimulus, pull the relevant details
[stimList, thisUnit, stimDur, stimITI, ~] = ...
    StimVariable(Condition,1,type);

% put the time axis together with the above info
timeaxis = BL + stimDur + stimITI;

% preallocate holders as cells for variability
CSDhold = cell(1,length(stimList));
for iStim = 1:length(stimList)
    CSDhold{iStim} = NaN(chanlength,timeaxis,subjects);
end

LFPhold = cell(1,length(stimList));
for iStim = 1:length(stimList)
    LFPhold{iStim} = NaN(chanlength,timeaxis,subjects);
end

%% now run through and pull data from each animal into containers

for iSub = 1:length(animals)

    if matches(Group, 'MWT') && matches(Condition, 'NoiseBurst') ...
            && matches(animals{iSub},'MWT16b')
        continue % special case, two noiseburst from same subject due to 
                 % probe movement - don't count both for group
    end
    
    % load the animal data in
    load([animals{iSub} '_Data.mat'],'Data');
    
    % we need the index of the last noiseburst or the first of any
    % other stim type
    index = StimIndex({Data.Condition},Cond,iSub,Condition);
    
    % if this animal doesn't have a measurement of this type
    if isempty(index)
        continue
    end
    
    % pull the data
    for iStim = 1:length(stimList)

        CurCSD = nanmean(Data(index).sngtrlCSD{1, iStim},3);
        CSDhold{iStim}(1:size(CurCSD,1),1:size(CurCSD,2),iSub) = CurCSD;

        CurLFP = nanmean(Data(index).sngtrlLFP{1, iStim},3);
        LFPhold{iStim}(1:size(CurLFP,1),1:size(CurLFP,2),iSub) = CurLFP;
    end
    clear index Data
end

%% produce CSD and LFP figure
% CSD
CSDfig = tiledlayout('flow');
title(CSDfig,[Group ' Avg CSD to ' Condition])
xlabel(CSDfig, 'time [ms]')
ylabel(CSDfig, 'depth [channels]')

for iStim = 1:length(stimList)
    nexttile
    image = nanmean(CSDhold{iStim},3);
    imagesc(image(1:25,:)) % for b6 mice
    title([num2str(stimList(iStim)) thisUnit])
    clim(cbar_csd)
    colormap('jet')
    colorbar
end

cd(homedir); cd figures;
if exist('Average_CSD','dir')
    cd Average_CSD;
else
    mkdir Average_CSD, cd Average_CSD;
end

h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h,[Group ' Avg CSD to ' Condition],'compact')
close (h)

%LFP 
LFPfig = tiledlayout('flow');
title(LFPfig,[Group ' Avg LFP to ' Condition])
xlabel(LFPfig, 'time [ms]')
ylabel(LFPfig, 'depth [channels]')

for iStim = 1:length(stimList)
    nexttile
    image = nanmean(LFPhold{iStim},3);
    imagesc(image(1:25,:)) % for b6 mice
    title([num2str(stimList(iStim)) thisUnit])
    clim(cbar_lfp)
    colormap('jet')
    colorbar
end

cd(homedir); cd figures;
if exist('Average_LFP','dir')
    cd Average_LFP;
else
    mkdir Average_LFP, cd Average_LFP;
end

h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h,[Group ' Avg LFP to ' Condition],'compact')
close (h)

cd(homedir)
end