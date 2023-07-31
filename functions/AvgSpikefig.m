function AvgSpikefig(homedir, Group, stimType)
%% Averaged Heatmap Raster plot 

% The purpose of this script is to provide an averaged CSD for visual
% representation of each analysis group.

%Input:     datastructs\ *.mat
%Output:    \figures\Avg_Raster; figures only for representation of
%           characteristic profile
cd(homedir);
% some presets
sr_mult    = 3;
BL         = 400;
chanlength = 32; % the MAXIMUM amount of channels

%% Load in info
cd datastructs; cd spikedata
input = dir([Group '*.mat']);
entries = length(input);

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals);

% The next part depends on the stimulus
if matches(stimType,'NoiseBurst') || ...
        matches(stimType,'postNoise')
    % non randomized list of dB presentation
    stimList = [20, 30, 40, 50, 60, 70, 80, 90];
    thisunit = 'dB';
    timeaxis = (BL+100+1000)*sr_mult; % BL + stimdur + ITI (ms)
    
elseif matches(stimType,'Tonotopy')
    stimList = [1, 2, 4, 8, 16, 24, 32];
    thisunit = 'kHz';
    timeaxis = (BL+200+1000)*sr_mult; % BL + stimdur + ITI (ms)
    
elseif matches(stimType,'Spontaneous') || ...
        matches(stimType,'postSpont')
    stimList = 1;
    thisunit = [];
    timeaxis = (BL+1000+1000)*sr_mult; % BL + ITI (ms)
    
elseif matches(stimType,'ClickTrain')
    stimList = [20, 30, 40, 50, 60, 70, 80, 90];
    thisunit = 'dB';
    timeaxis = (BL+2000+2000)*sr_mult; % BL + stimdur + ITI (ms)
    
elseif matches(stimType,'Chirp')
    stimList = 1;
    thisunit = [];
    timeaxis = (BL+3000+1000)*sr_mult; % BL + stimdur + ITI (ms)
    
elseif matches(stimType,'gapASSR')
    stimList = [2, 4, 6, 8, 10];
    thisunit = ' [ms] gap width';
    timeaxis = (BL+2000+2000)*sr_mult; % BL + stimdur + ITI (ms)
    
end

% preallocate csd holders as cells for variability
CSDhold = cell(1,length(stimList));
for iStim = 1:length(stimList)
    CSDhold{iStim} = NaN(chanlength,timeaxis,subjects);
end

% now run through and pull data from each animal into those containers
for iEnt = 1:entries
    
    % load the animal data in
    load(input(iEnt).name,'Data');
    
    % we need the index of the last noiseburst or the first of any
    % other stim type
    if matches(stimType,'NoiseBurst')
        index =  length(Cond.(stimType){iEnt});
    else
        anCondList = {Data.Condition};
        for idirtytrick = 1:length(anCondList)
            if exist('index','var')
                continue
            elseif isempty(anCondList{idirtytrick})
                continue
            elseif contains(anCondList{idirtytrick},stimType)
                index = idirtytrick;
            else
                continue
            end
        end
    end
    % if this animal doesn't have a measurement of this type
    if ~exist('index','var')
        continue
    end
    % now that that nasty business is over...
    
    % pull the data
    for iStim = 1:length(stimList)
        
        CurCSD = mean(Data(index).SpikeRaster{1, iStim},3);
        CSDhold{iStim}(1:size(CurCSD,1),1:size(CurCSD,2),iEnt) = CurCSD;
        
    end
    clear index
end


% produce raster figure
heatmapfig = tiledlayout('flow');
title(heatmapfig,[Group ' Avg Raster to ' stimType])
xlabel(heatmapfig, 'time [ms]')
ylabel(heatmapfig, 'depth [channels]')

for istim = 1:length(stimList)
    nexttile
    % plot so higher activity is darker
    raster = nanmean((CSDhold{iStim}*-1),3);
    imagesc(raster(1:27,:))
    title([num2str(stimList(istim)) thisunit])
    colormap('gray')
    
    xlim([0 timeaxis])
    xticks(0:200*sr_mult:timeaxis)
    labellist = xticks ./ sr_mult;
    xticklabels(labellist)
end

colorbar

cd(homedir); cd figures;
if exist('Average_Raster','dir')
    cd Average_Raster;
else
    mkdir Average_Raster, cd Average_Raster;
end

h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h,[Group ' Avg Raster to ' stimType],'compact')
close (h)

cd(homedir)
end