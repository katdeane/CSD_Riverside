function collectPermStats(homedir,params)

cd(homedir); cd figures; cd CWT
osciName = {'theta' 'alpha' 'beta_low' 'beta_high' 'gamma_low' 'gamma_high'};

% look at all data
input = dir('*.mat');
% make sure it's only data for this study
input = input(contains({input.name},params.groups{1}),:);

for iCond = 1:length(params.condList)

    % get data out for this condition
    thisCond = input(contains({input.name},params.condList{iCond}),:);

    % condition specific info
    [stimList, ~, ~, ~, ~,~,~] = ...
        StimVariableCWT(params.condList{iCond},1);

    for iStim = 1:length(stimList)

        thisStim = thisCond(contains({thisCond.name},num2str(stimList(iStim))),:);

        % initiate table here
        PermStats = table('Size',[size(thisStim,1) 11],'VariableTypes',...
            {'string','string','string','double','string','double','double',...
            'double','double','double','double'});

        PermStats.Properties.VariableNames = ["Oscillation", "Type", "Condition",...
            "Stimulus", "Layer", "p_onset","Mean_onset","STD_onset","p_post",...
            "Mean_post","STD_post"];

        for iTab = 1:size(thisStim,1)

            filename = thisStim(iTab).name;
            % load the data
            load(filename, 'pVal_onset','pVal_post','permMean_onset',...
                'permMean_post','permSTD_onset','permSTD_post')

            % pop it in the table
            PermStats.p_onset(iTab)     = pVal_onset;
            PermStats.Mean_onset(iTab)  = permMean_onset;
            PermStats.STD_onset(iTab)   = permSTD_onset;
            PermStats.p_post(iTab)      = pVal_post;
            PermStats.Mean_post(iTab)   = permMean_post;
            PermStats.STD_post(iTab)    = permSTD_post;
            PermStats.Condition(iTab)   = params.condList{iCond};
            PermStats.Stimulus(iTab)    = stimList(iStim);

            % which oscillation (or is it the full set)
            for iOsci = 1:length(osciName)
                if contains(filename,osciName{iOsci})
                    PermStats.Oscillation(iTab) = osciName{iOsci};
                end
            end
            if ismissing(PermStats.Oscillation(iTab))
                PermStats.Oscillation(iTab) = 'Full';
            end
            % which type, phase or power
            if contains(filename, 'Phase')
                PermStats.Type(iTab) = 'Phase';
            else
                PermStats.Type(iTab) = 'Power';
            end
            % which layer (no "all" layers condition)
            for iLay = 1:length(params.layers)
                if contains(filename,params.layers{iLay})
                    PermStats.Layer(iTab) = params.layers{iLay};
                end
            end

        end % files

        cd(homedir); cd output; cd CWTPermStats
        % save the table
        writetable(PermStats,[filename(1:7) '_' params.condList{iCond} '_' num2str(stimList(iStim))...
            '_PermStats.csv'])

    end % stim list
end % conditions
