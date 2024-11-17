function igetITPCmeanPCal(homedir,Groups,whichtest)

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

Condition = {'Pupcall_1' 'ClickTrain_5' 'gapASSR_10'};

for iCond = 1:length(Condition)

    if matches(Condition{iCond},'Pupcall_1')
        load('PupTimes.mat','PupTimes')
        PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
        PupTimes = PupTimes + 0.400; % add the prestimulus time
        TimeListOn = PupTimes .* 1000; % match axes for CSD
    elseif matches(Condition{iCond},'ClickTrain_5')
        TimeListOn = 400 + [0 200 400 600 800 1000 1200 1400 1600 1800 2000];
    elseif matches(Condition{iCond},'gapASSR_10')
        TimeListOn = 400 + [250, 750, 1250, 1750, 2250, 2750];
    else
        error('how did you do this?')
    end

    layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
    count = 1;

    % initialize table
    DataT = table('Size',[length(layers)*length(TimeListOn)*length(subList) 9],...
        'VariableTypes', {'string','string','string','double',...
        'double','double','double','double','double'});

    % S = single, A = average, TH = thalamic, CO = cortical, CN = continue
    DataT.Properties.VariableNames = ["Group", "Subject",...
        "Layer", "Order_Presentation", "Theta_mean", "Alpha_mean", "Beta_mean",....
        "GammaLow_mean", "GammaHigh_mean"];

    for iSub = 1:length(subList)

        disp(['Subject ' subList{iSub}])
        input = [subList{iSub} '_' Condition{iCond} '_WT.mat'];
        if ~exist(input,'file')
            continue
        end
        load(input,'wtTable')

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
            for iOn = 1:length(TimeListOn)

                ON = round(TimeListOn(iOn));

                % relevant spectral bands
                if contains(Condition{iCond},'gapASSR') 
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
                DataT.Layer(count)              = layers{iLay};
                DataT.Order_Presentation(count) = iOn;
                count = count + 1;

            end % time window
        end % layer
    end % subject

    cd(homedir); cd output;
    if exist('ITPCmean','dir')
        cd ITPCmean;
    else
        mkdir ITPCmean, cd ITPCmean;
    end
    if length(Groups) == 1
        writetable(DataT,[Groups{1} '_' Condition{iCond} '_ITPCmean.csv'])
    elseif length(Groups) == 2
        writetable(DataT,[Groups{1} 'and' Groups{2} '_' Condition{iCond} '_ITPCmean.csv'])
    end
end
cd(homedir)