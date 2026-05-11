function TimeFreqBackground(homedir,params,Groups)
% getting the spontaneous background
cd (homedir); cd output; cd WToutput

% run through groups, subjects, and layers
for iGro = 1:length(Groups)
    run([Groups{iGro} '.m']); % generates variables: animals
    clear channels Cond Layer
    % make a group container for saving out = 54 x subject x layers. The 54
    % are our frequency channels, we'll average over the 2 s time window
    % after phase and power are calculated on 50 trials
    BG_Power = zeros(54,length(animals),length(params.layers));
    BG_Phase = zeros(54,length(animals),length(params.layers));

    for iSub = 1:length(animals)
        input = [animals{iSub} '_Spontaneous_1_WT.mat'];
        load(input, 'wtTable')
        for iLay = 1:length(params.layers)
            % split out the layer
            layWT = wtTable(matches(wtTable.layer, params.layers{iLay}),:);
            % get the power and phase and average them across the frequency
            % rows
            PowerOut = getpowerout(layWT);
            PhaseOut = getphaseout(layWT);
            BG_Power(:,iSub,iLay) = mean(squeeze(PowerOut),2);
            BG_Phase(:,iSub,iLay) = mean(squeeze(PhaseOut),2);

        end % layer
    end % subject
    
    % save the group data
    savename = [Groups{iGro} '_Background.mat'];
    save(savename,'BG_Power','BG_Phase')
end % group
