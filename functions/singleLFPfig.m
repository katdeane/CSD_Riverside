function singleLFPfig(homedir, Groups, Condition,cbar)

%% Dynamic CSD for sinks I_II through VI; incl. single

%   reads data (e.g. MWT01_Data.mat) from datastructs\ to produce
%   corresponding single subject LFPs
%
%   cbar variable sets caxis, flexible for different species
%
%   Data is from Neuronexus: Allego and Curate, should have *_LFP.xdat.json,
%   *_LFP_data.xdat, and *_LFP_timestamp.xdat per subject (eg MWT01_01).
%
%   Condition should be a string matching a condition saved in the group
%   metadata file (eg MWT.m), such as 'NoiseBurst'

%% Load in
cd(homedir)

for iGro = 1:length(Groups)

    run([Groups{iGro} '.m']); % brings in animals, channels, Layer, and Cond

    %% Condition and Indexer
    BL   = 399; % always a 400ms baseline pre-event

    %%

    for iSub = 1:length(animals)

        name = animals{iSub}; %#ok<*IDISVAR>
        disp(['Subject ' name])
        tic
        load([name '_Data.mat'],'Data')

        for iCond = 1:length(Condition)

            disp([Condition{iCond}])
            index = StimIndex({Data.Condition},Cond,iSub,Condition{iCond});
            if isempty(index)
                continue
            end

            % The next part depends on the stimulus, pull the relevant details
            [stimList, thisUnit, stimDur, ~, ~] = ...
                StimVariable(Condition{iCond},1);

            %% Plot

            cd (homedir); cd figures;
            if ~exist(['Single_' name(1:3)],'dir')
                mkdir(['Single_' name(1:3)]);
            end
            cd (['Single_' name(1:3)])

            LFPfig = tiledlayout('flow');
            title(LFPfig,[name ' ' Condition{iCond}...
                ' LFP'])
            xlabel(LFPfig, 'time [ms]')
            ylabel(LFPfig, 'depth [channels]')

            sngtrlLFP = Data(index).sngtrlLFP;

            for istim = 1:length(stimList)
                nexttile
                imagesc(mean(sngtrlLFP{istim},3))
                title([num2str(stimList(istim)) thisUnit])
                % colormap jet
                clim(cbar)
                xline(BL+1,'LineWidth',2) % onset
                xline(BL+stimDur+1,'LineWidth',2) % offset
            end

            colorbar
            h = gcf;
            savefig(h,[name '_' Condition{iCond} '_LFP' ],'compact')
            close (h)
            toc
        end
    end
end
cd(homedir)
