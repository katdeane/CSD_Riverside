function AvgCSDfig(homedir, Group, stimType)
%% Averaged CSD

% The purpose of this script is to provide an averaged CSD for visual
% representation of each analysis group.

%Input:     datastructs\ *.mat
%Output:    \figures\Average_CSD; figures only for representation of
%           characteristic profile

cd(homedir);

% some presets
BL         = 400;
chanlength = 32; % the MAXIMUM amount of channels

%% Load in info
cd datastructs
input = dir([Group '*.mat']);
entries = length(input);

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals);

% The next part depends on the stimulus, pull the relevant details
[stimList, thisUnit, stimDur, stimITI, ~] = ...
    StimVariable(stimType,1);

% put the time axis together with the above info
timeaxis = BL + stimDur + stimITI;

% preallocate csd holders as cells for variability
CSDhold = cell(1,length(stimList));
for iStim = 1:length(stimList)
    CSDhold{iStim} = NaN(chanlength,timeaxis,subjects);
end

%% now run through and pull data from each animal into containers

for iEnt = 1:entries
    
    % load the animal data in
    load(input(iEnt).name,'Data');
    
    % we need the index of the last noiseburst or the first of any
    % other stim type
    index = StimIndex(Cond,iEnt,stimType);
    
    % if this animal doesn't have a measurement of this type
    if ~exist('index','var')
        continue
    end
    
    % pull the data
    for iStim = 1:length(stimList)
        
        CurCSD = mean(Data(index).sngtrlCSD{1, iStim},3);
        CSDhold{iStim}(1:size(CurCSD,1),1:size(CurCSD,2),iEnt) = CurCSD;
        
    end
    clear index
end


%% produce CSD figure
CSDfig = tiledlayout('flow');
title(CSDfig,[Group ' Avg CSD to ' stimType])
xlabel(CSDfig, 'time [ms]')
ylabel(CSDfig, 'depth [channels]')

for iStim = 1:length(stimList)
    nexttile
    image = nanmean(CSDhold{iStim},3);
    imagesc(image(1:27,:)) % after 27, all rows NaN in MKO group
    title([num2str(stimList(iStim)) thisUnit])
    caxis([-0.1 0.1])
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
savefig(h,[Group ' Avg CSD to ' stimType],'compact')
close (h)

cd(homedir)
end