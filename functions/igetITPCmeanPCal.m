function igetITPCmeanPCal(homedir,outfolder,Group,Condition,whichtest,type)

% each WT table is saved as *subject*_*condition*_*stimPresentation*_WT.mat
% meaning we can call them in whatever order we want to save. Therefore
% we'll work backwards, loop through stim presentation, subject.

% get subject list and variables
run([Group{1} '.m'])
subList = animals;
clear animals

[stimList, ~, ~, ~, ~,~,~,~] = ...
    StimVariableCWT(Condition,1,type);

if matches(Condition,'Pupcall_1')
    load('PupTimes.mat','PupTimes')
    PupTimes = PupTimes(:,1);
    PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
    PupTimes = PupTimes + 0.400; % add the prestimulus time
    TimeListOn = PupTimes .* 1000; % match axes for CSD
elseif matches(Condition,'ShortCall') || matches(Condition,'MaskCall')
    load('ShortPupTimes.mat','ShortPupTimes')
    ShortPupTimes = ShortPupTimes(:,1);
    ShortPupTimes = ShortPupTimes .* 0.9856; % 192000/194800 (fixing fs)
    ShortPupTimes = ShortPupTimes + 0.400; % add the prestimulus time
    TimeListOn = ShortPupTimes .* 1000; % match axes for CSD
elseif matches(Condition,'NoiseBurst2pt5Hz')
    TimeListOn = [400; 800; 1200]; % already adding 400 for BL 
else
    error('Not for this stimulus type')
end

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
count = 1;

% initialize table
DataT = table('Size',[length(layers)*length(TimeListOn)*length(stimList)*length(subList) 10],...
    'VariableTypes', {'string','string','string','string','double',...
    'double','double','double','double','string'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
DataT.Properties.VariableNames = ["Group", "Subject", "Stimulus",...
    "Layer", "Theta_mean", "Alpha_mean", "Beta_mean",....
    "GammaLow_mean", "GammaHigh_mean", "TimeWindow"];

for iStim = 1:length(stimList)

    disp(['Stim Presentation ' num2str(stimList(iStim))])

    for iSub = 1:length(subList)

        disp(['Subject ' subList{iSub}])
        input = [subList{iSub} '_' Condition '_' num2str(stimList(iStim)) '_WT.mat'];
        if ~exist(input,'file')
            continue
        end
        load(input,'wtTable')

        for iLay = 1:length(layers)

            WTLay = wtTable(matches(wtTable.layer, layers{iLay}),:);

            % get phase or power out
            if contains(whichtest, 'Power')
                WTLay = squeeze(getpowerout(WTLay));
            elseif contains(whichtest, 'Phase')
                WTLay = squeeze(getphaseout(WTLay));
            end

            % time window to take the mean of
            for iOn = 1:length(TimeListOn)

                ON = round(TimeListOn(iOn));

                % relevant spectral bands
                if contains(Condition,'gapASSR')
                    % narrowed to specific areas
                    DataT.Theta_mean(count)     = NaN;
                    DataT.Alpha_mean(count)     = NaN;
                    DataT.Beta_mean(count)      = NaN;
                    DataT.GammaLow_mean(count)  = mean(mean(WTLay(30,ON+100:ON+230))); % 40 Hz
                    DataT.GammaHigh_mean(count) = mean(mean(WTLay(22,ON+50:ON+230))); % 80 Hz
                else
                    % theta - high gamma                                                % Hz
                    DataT.Theta_mean(count)     = mean(mean(WTLay(49:54,ON+20:ON+200)));   % (4:7);
                    DataT.Alpha_mean(count)     = mean(mean(WTLay(44:48,ON+20:ON+150)));   % (8:12);
                    DataT.Beta_mean(count)      = mean(mean(WTLay(34:43,ON+10:ON+100)));   % (13:30);
                    DataT.GammaLow_mean(count)  = mean(mean(WTLay(26:33,ON:ON+50)));    % (31:60);
                    DataT.GammaHigh_mean(count) = mean(mean(WTLay(19:25,ON:ON+30)));    % (61:100);
                end

                %
                % take the mean and save metadata
                DataT.Group(count)              = wtTable.group{1};
                DataT.Subject(count)            = subList{iSub};
                DataT.Stimulus(count)           = num2str(stimList(iStim));
                DataT.Layer(count)              = layers{iLay};
                DataT.Order_Presentation(count) = iOn;
                DataT.TimeWindow(count)         = [num2str(ON) ':' num2str(ON+200)];
                count = count + 1;

            end % time window
        end % layer
    end % subject

    if exist([outfolder '\ITPCmean'],'dir')
        cd([outfolder '\ITPCmean']);
    else
        mkdir([outfolder '\ITPCmean']), cd([outfolder '\ITPCmean']);
    end
    writetable(DataT,[Group{1} '_' Condition '_ITPCmean.csv'])

end
cd(homedir)
addpath(genpath(homedir))