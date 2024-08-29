function igetITPCmean(homedir,Groups,Condition,whichtest,type)

% each WT table is saved as *subject*_*condition*_*stimPresentation*_WT.mat
% meaning we can call them in whatever order we want to save. Therefore
% we'll work backwards, loop through stim presentation, subject.

% get subject list and variables
if length(Groups) == 1
    run([Groups{1} '.m'])
    subList = animals;
    clear animals
elseif length(Groups) == 2
    run([Groups{1} '.m'])
    grp1sub = animals;
    clear animals
    run([Groups{2} '.m'])
    subList = [grp1sub animals];
    clear animals grp1sub
end


[stimList, ~, ~, ~, ~,~,~,ITPCwin] = ...
    StimVariableCWT(Condition,1,type);

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
BL = 399;
count = 1;

% initialize table
DataT = table('Size',[length(layers)*length(stimList)*length(subList) 10],...
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
        input = [subList{iSub} '_' Condition ...
            '_' num2str(stimList(iStim)) '_WT.mat'];
        if ~exist(input,'file')
            continue
        end
        load(input,'wtTable')

        group = wtTable.group{1};

        for iLay = 1:length(layers)

            disp(['Layer ' layers{iLay}])

            WTLay = wtTable(matches(wtTable.layer, layers{iLay}),:);

            % get phase or power out
            if contains(whichtest, 'Power')
                WTLay = squeeze(getpowerout(WTLay));
            elseif contains(whichtest, 'Phase')
                WTLay = squeeze(getphaseout(WTLay));
            end

            % time window to take the mean of
            if contains(Condition,'gapASSR') % every other 250 ms for JUST gap in noise blocks
                onset = ITPCwin{:}(1:500:end);
                offset = ITPCwin{:}(251:500:end);
                window = NaN;
                for ion = 1:length(onset)
                    window = [window onset(ion):offset(ion)]; %#ok<*AGROW>
                end
                window = window(~isnan(window));  
                WTLay = WTLay(:,(BL+window));
            else
                WTLay = WTLay(:,(BL+ITPCwin{:}));
            end

            % relevant spectral bands
            if contains(Condition,'gapASSR') || (contains(Condition,'Click') && stimList(iStim) >= 40)
                % narrowed to specific areas
                DataT.Theta_mean(count)     = NaN;
                DataT.Alpha_mean(count)     = NaN;
                DataT.Beta_mean(count)      = NaN;
                DataT.GammaLow_mean(count)  = mean(mean(WTLay(29:31,:))); % ~40 Hz
                DataT.GammaHigh_mean(count) = mean(mean(WTLay(21:23,:))); % ~80 Hz
            else
                % theta - high gamma                                        % Hz
                DataT.Theta_mean(count)     = mean(mean(WTLay(49:54,:)));    % (4:7);
                DataT.Alpha_mean(count)     = mean(mean(WTLay(44:48,:)));   % (8:12);
                DataT.Beta_mean(count)      = mean(mean(WTLay(34:43,:)));   % (13:18);
                DataT.GammaLow_mean(count)  = mean(mean(WTLay(26:33,:)));   % (31:60);
                DataT.GammaHigh_mean(count) = mean(mean(WTLay(19:25,:)));   % (61:100);
            end

            % 
            
            % take the mean and save metadata
            DataT.Group(count)      = group;
            DataT.Subject(count)    = subList{iSub};
            DataT.Stimulus(count)   = num2str(stimList(iStim));
            DataT.Layer(count)      = layers{iLay};
            DataT.TimeWindow(count) = [num2str(ITPCwin{:}(1)) ':' num2str(ITPCwin{:}(end))];

            count = count + 1;

        end % layer
    end % subject
end % stimulus presentation

cd(homedir); cd output;
if exist('ITPCmean','dir')
    cd ITPCmean;
else
    mkdir ITPCmean, cd ITPCmean;
end
if length(Groups) == 1
    writetable(DataT,[Groups{1} '_' Condition '_ITPCmean.csv'])
elseif length(Groups) == 2
    writetable(DataT,[Groups{1} 'and' Groups{2} '_' Condition '_ITPCmean.csv'])
end
cd(homedir)