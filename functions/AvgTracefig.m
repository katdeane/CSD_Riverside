function AvgTracefig(homedir, Group, Condition)
%% Averaged CSD

% The purpose of this script is to provide an averaged group CSD for visual
% representation of each group for each stimulus type

%Input:     datastructs\ *.mat
%Output:    \figures\Average_CSD; figures only for representation of
%           characteristic profile

cd(homedir);

% some presets
BL         = 400;
chanlength = 32; % the MAXIMUM amount of channels

%% Load in info
cd datastructs

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

% The next part depends on the stimulus, pull the relevant details
[stimList, thisUnit, stimDur, stimITI, ~] = ...
    StimVariable(Condition,1);

% put the time axis together with the above info
timeaxis = BL + stimDur + stimITI;

% preallocate csd holders as cells for variability
CSDhold = cell(1,length(stimList));
for iStim = 1:length(stimList)
    CSDhold{iStim} = NaN(chanlength,timeaxis,subjects);
end

%% now run through and pull data from each animal into containers

for iSub = 1:length(animals)
    
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

        CurCSD = mean(Data(index).sngtrlCSD{1, iStim},3);
        CSDhold{iStim}(1:size(CurCSD,1),1:size(CurCSD,2),iSub) = CurCSD;
        
    end
    clear index
end


%% produce CSD figure
cd(homedir); cd figures;
if exist('Average_CSD','dir')
    cd Average_CSD;
else
    mkdir Average_CSD, cd Average_CSD;
end

for iStim = 1:length(stimList)
    figure('units','normalized','outerposition',[0 0 1 1])
    title([Group ' Avg CSD Traces to ' Condition ' ' num2str(stimList(iStim)) thisUnit])
    xlabel('time [ms]')
    ylabel('depth [channels]')
    image = nanmean(CSDhold{iStim},3);
    image = image(~isnan(image(:,1)),:); % remove nan rows
    image = image(:,(BL - 100):(BL + stimDur + 200));
    s = stackedplot(image');

    ax = findobj(s.NodeChildren, 'Type','Axes');
    linkaxes(ax)

    h = gcf;
    set(h, 'PaperType', 'A4');
    set(h, 'PaperOrientation', 'landscape');
    set(h, 'PaperUnits', 'centimeters');
    savefig(h,[Group ' Avg CSD Traces to ' Condition ' ' num2str(stimList(iStim)) thisUnit],'compact')
    close (h)

end

cd(homedir)
end