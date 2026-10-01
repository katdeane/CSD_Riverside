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
        if exist(input,'file')
            load(input, 'wtTable')
            spontdur = 1:2000;
        else 
            input = [animals{iSub} '_NoiseBurst_70_WT.mat'];
            load(input, 'wtTable')
            % if the spont measurement doesn't exist, get the 1:300 ms 
            % before stim onset at 400 ms in NB
            spontdur = 1:300; 
        end
        for iLay = 1:length(params.layers)
            % split out the layer
            layWT = wtTable(matches(wtTable.layer, params.layers{iLay}),:);
            % get the power and phase and average them across the frequency
            % rows
            PowerOut = getpowerout(layWT);
            PhaseOut = getphaseout(layWT);
            BG_Power(:,iSub,iLay) = mean(squeeze(PowerOut(:,:,spontdur)),2);
            BG_Phase(:,iSub,iLay) = mean(squeeze(PhaseOut(:,:,spontdur)),2);

        end % layer
    end % subject
    
    % save the group data
    savename = [Groups{iGro} '_Background.mat'];
    save(savename,'BG_Power','BG_Phase')
end % group
