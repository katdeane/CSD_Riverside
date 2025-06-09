% function genBF(homedir, Group, Condition, type)

% this code assumes 6 tones in the tuning curve
cd(homedir)
Group = 'MWT';
Condition = 'Tonotopy';
type = 'Anesthetized';
BL = 400;
cbar_csd = [-0.2 0.2];

whichlayer = 'IV';

%% Load in
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

layers = {'All', 'II', 'IV', 'Va', 'Vb', 'VI'};
TonoDat = struct;

for iSub = 1:subjects

    % The next part depends on the stimulus, pull the relevant details
    if matches(animals(iSub),'FOS01') % the only exception :D
        [stimList, thisUnit, stimDur, stimITI, ~] = ...
            StimVariable(Condition,1,'Awake1');
    else
        [stimList, thisUnit, stimDur, stimITI, ~] = ...
            StimVariable(Condition,1,type);
    end
    timeaxis = BL + stimDur + stimITI;

    load([animals{iSub} '_Data.mat'],'Data');
    AnName = animals{iSub};

    % one output per subject
    index = StimIndex({Data.Condition},Cond,iSub,Condition);
    % if no stim of this type for this subject, continue on
    if isempty(index)
        continue
    end

    peakAmp = nan(1,length(stimList));
    for istim = 1:length(stimList)
        % check first lat within 50 ms
        thislat = Data(index).sinkPeakLat(istim).(whichlayer)(1);
        thislat = thislat(1);

        if thislat < BL + 50
            peakAmp(istim) = Data(index).sinkPeakAmp(istim).(whichlayer)(1);
        else
            peakAmp(istim) = NaN;
        end
    end

    % of those, which is the highest peak amp
    BF = find(peakAmp==max(peakAmp));
    % 8 freq max, 15 total spaces (1 center, 7 on each side)
    % fill the columns so that the center is now always 8
    newCSDs = cell(1,15);
    if ~isempty(BF)
        newCSDs(9-BF:9-BF+7) = Data.sngtrlCSD;
    end

    % sort data into new struct
    TonoDat(iSub).Group     = Group;
    TonoDat(iSub).Subject   = AnName;
    TonoDat(iSub).StimList  = Data(index).StimList;
    TonoDat(iSub).BF        = Data(index).StimList(BF);
    TonoDat(iSub).sngtrlCSD = newCSDs;
end

%% average csd's
CSDhold = cell(1,11);
for iStim = 1:11
    CSDhold{iStim} = NaN(32,timeaxis,subjects);
end

for iSub = 1:length(animals)
    for iStim = 1:11

        CurCSD = nanmean(TonoDat(iSub).sngtrlCSD{1, iStim},3);

        if ~isempty(CurCSD)
            CSDhold{iStim}(1:size(CurCSD,1),1:size(CurCSD,2),iSub) = CurCSD;
        end

    end
end

CSDfig = tiledlayout('flow');
title(CSDfig,[Group ' Avg CSD to ' Condition])
xlabel(CSDfig, 'time [ms]')
ylabel(CSDfig, 'depth [channels]')

labellist = {'-5' '-4' '-3' '-2' '-1' 'BF' '+1' '+2' '+3' '+4' '+5'};
for iStim = 1:11
    nexttile
    image = nanmean(CSDhold{iStim},3);
    imagesc(image(1:20,:)) % for b6 mice
    title(labellist{iStim})
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
savefig(h,['Real ' Group ' Avg CSD to ' Condition],'compact')
close (h)

% make tuning curves
