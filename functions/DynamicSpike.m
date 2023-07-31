function DynamicSpike(homedir, Condition)

%% Dynamic CSD for sinks I_II through VI; incl. single

%   This script takes input from the groups and data folders. It calculates
%   and stores CSD, sinks, AVREC, LFP, Relres, and basic information in a
%   Data struct per animal (eg MWT01_Data.mat) which is saved in the DATA
%   folder.
%
%   The layer list is (II, IV, Va, Vb, VI)
%   IMPORTANT: DO NOT change sink list here. If you need another set of
%   sinks then create a SEPARATE and UNIQUELY NAMED script.

%   calls functions: imakeIndexer.m

cd(homedir); cd groups;

%% Load in
input = dir('*.m');
entries = length(input);
cd(homedir)

for i1 = 2:entries

    run(input(i1).name); % brings in animals, channels, Layer, and Cond

    %% Display conditions to verify correct list
    disp(Condition)

    %% Condition and Indexer
    Data = struct;
    BL   = 400; % always a 400ms baseline pre-event

    Indexer = imakeIndexer(Condition,animals,Cond); %#ok<*USENS>
    %%

    for iA = 2:length(animals)
        tic
        name = animals{iA}; %#ok<*IDISVAR>

        for iStimType = 1:length(Condition)
            for iStimCount = 4:length(Cond.(Condition{iStimType}){iA})
                if iStimCount == 1
                    CondIDX = Indexer(2).(Condition{iStimType});
                else
                    CondIDX = Indexer(2).(Condition{iStimType})+iStimCount-1;
                end

                measurement = Cond.(Condition{iStimType}){iA}{iStimCount};
                % all of the above is to indicate which animal and
                % condition is being analyzed

                if exist([name '_' measurement '_Spike.xdat.json'],'file')
                    file = [name '_' measurement '_Spike'];
                    disp(['Analyzing animal: ' file])

                    tic
                    [StimIn, DataIn] = FileReaderSpike(file,str2num(channels{iA}));
                    toc
                    sr_mult = 3; % sampling rate 3000, multiply by this to get [ms]
                    
                    % The next part depends on the stimulus; pull the
                    % relevant variables
                    [stimList, thisUnit, stimDur, stimITI, thisTag] = ...
                        StimVariable(Condition{iStimType},sr_mult);
                    
                    % and slice the data
                    sngtrldat = icutandraster(file, StimIn, DataIn, stimList, ...
                        (BL*sr_mult)-1, stimDur, stimITI, thisTag);
                    
                    clear DataIn StimIn % these are too big to keep around

                    % Layers
                    L.II = str2num(Layer.II{iA});
                    L.IV = str2num(Layer.IV{iA});
                    L.Va = str2num(Layer.Va{iA});
                    L.Vb = str2num(Layer.Vb{iA});
                    L.VI = str2num(Layer.VI{iA});
                    Layers = fieldnames(L);


                    %% Plots
                    disp('Plotting PSTHs')

                    cd (homedir); cd figures;
                    if ~exist(['SingleSpike_' input(i1).name(1:end-2)],'dir')
                        mkdir(['SingleSpike_' input(i1).name(1:end-2)]);
                    end
                    cd (['SingleSpike_' input(i1).name(1:end-2)])

                    for iLay = 1:length(Layers)+1

                        PSTHfig = tiledlayout('flow');
                        if iLay == length(Layers)+1
                            title(PSTHfig,[file(1:5) ' ' Condition{iStimType}...
                                ' ' num2str(iStimCount) ' PSTH All Channels'])
                        else
                            title(PSTHfig,[file(1:5) ' ' Condition{iStimType}...
                            ' ' num2str(iStimCount) ' PSTH Layer ' Layers{iLay}])
                        end
                        xlabel(PSTHfig, 'time [ms]')
                        ylabel(PSTHfig, 'spike count / spike rate [s]')

                        for istim = 1:length(stimList)

                            % figure of psth's for all and layers per stim
                            trlsum   = sum(sngtrldat{istim},3);

                            if iLay == length(Layers)+1
                                % raster summing all channels or layer channels
                                layersum  = sum(trlsum,1);
                            else
                                % raster summing all channels or layer channels
                                layersum  = sum(trlsum(L.(Layers{iLay}),:),1);
                            end

                            % get spiking rate per second 
                            spikerate = sum(layersum) / ((length(layersum)/sr_mult)/1000);
                            %adjust your raster by spiking rate
                            adjlaysum = layersum ./ spikerate;

                            % now add the tile
                            nexttile
                            bar(adjlaysum,30,'histc')
                            title([num2str(stimList(istim)) thisUnit])
                            xlim([0 length(layersum)])
                            xticks(0:200*sr_mult:length(layersum))
                            labellist = xticks ./ sr_mult;
                            xticklabels(labellist)

                        end

                        h = gcf;
                        if iLay == length(Layers)+1
                             savefig(h,[name '_' measurement '_PSTH_AllChan'],'compact')
                        else
                            savefig(h,[name '_' measurement '_PSTH_Lay' Layers{iLay}],'compact')
                        end
                        close (h)
                    end

                    heatmapfig = tiledlayout('flow');
                    title(heatmapfig,[file(1:5) ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' Heatmap'])
                    xlabel(heatmapfig, 'time [ms]')
                    ylabel(heatmapfig, 'depth [channels]')
                    
                    for istim = 1:length(stimList)
                        nexttile
                        % plot so higher activity is darker 
                        imagesc((sum(sngtrldat{istim},3))*-1)
                        title([num2str(stimList(istim)) thisUnit])          
                        colormap('gray')
                        
                        xlim([0 length(layersum)])
                        xticks(0:200*sr_mult:length(layersum))
                        labellist = xticks ./ sr_mult;
                        xticklabels(labellist)
                        
                    end
                    
                    colorbar

                    h = gcf;
                    savefig(h,[name '_' measurement '_Heatmap' ],'compact')
                    close (h)
                 
                    %% Save and Quit
                    % identifiers and basic info
                    Data(CondIDX).measurement   = file;
                    Data(CondIDX).Condition     = [Condition{iStimType} '_' num2str(iStimCount)];
                    Data(CondIDX).BL            = BL;
                    Data(CondIDX).stimDur       = stimDur;
                    Data(CondIDX).StimList      = stimList;

                    % CSD data
                    Data(CondIDX).SpikeRaster   = sngtrldat;

                end
            end
        end
        cd(homedir);
        % make these folders if you don't 
        cd datastructs; cd spikedata
        save([name '_SpikeData'],'Data');
        clear Data
        cd(homedir)
        toc
    end

end
cd(homedir)
