function STDaboveBL(homedir, Group, Condition)
%% Averaged CSD and LFP

% This will take the mean activity of the background, pre-stim window of
% 400 ms, and calculate how many standard deviations the subject average
% noise burst response amplitude is above that. All in layer IV and
% specific to awake recording pipelines 

%Input:     datastructs\ *.mat
%Output:    \output\Verification\ *.csv

% variables: Group ('MWT'); Condition ('NoiseBurst')

% baseline activity
BL = 1:400;
% peak amplitude window for noise burst
PW = 400:450;

%% Load in info

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

% initialize table
STDabove = table('Size',[subjects 5],...
    'VariableTypes', {'string','double','double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
STDabove.Properties.VariableNames = ["Subject", "Baseline", "BLstd",...
    "PeakAmp", "STDabove"];

%% now run through and pull data from each animal into containers

for iSub = 1:subjects

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
    CurCSD = nanmean(Data(index).sngtrlCSD{1},3); % just one stim in awake
    CurCSD = CurCSD(str2num(Layer.IV{iSub}),:);
    % peakCSD = CurCSD * -1;         % flip it
                % peakCSD(peakCSD < 0) = NaN;   % nan-source it
                % peakCSD = nanmean(peakCSD,1); % average it (with nans)
                % peakCSD(isnan(peakCSD)) = 0;  % replace nans with 0s for consecutive line

                

    % mean of the baseline/pre-stim 
    BLavg = nanmean(nanmean(CurCSD(:,BL)));
    % std across time, averaged over channels
    BLstd = nanmean(nanstd(CurCSD(:,BL),0,2));
    % peak amp within 100 ms of onset (flip to get sink peak amp)
    peakCSD = CurCSD(:,PW) * -1;
    PWamp = nanmax(nanmean(peakCSD));
    % how many standard deviations above the baseline is the peak amp?
    Z = (PWamp - BLavg)/BLstd;

    STDabove.Subject(iSub)   = animals{iSub};
    STDabove.Baseline (iSub) = BLavg;
    STDabove.BLstd(iSub)     = BLstd;
    STDabove.PeakAmp(iSub)   = PWamp;
    STDabove.STDabove(iSub)  = Z;

    clear index Data
end

cd(homedir); cd output;
if ~exist('Verification','dir')
    mkdir Verification
end
cd Verification;

writetable(DataT,[Groups '_' Condition '_STDabove.csv'])
cd(homedir)
