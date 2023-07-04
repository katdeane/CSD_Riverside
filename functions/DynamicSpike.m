function DynamicSpike(homedir, Condition)

%% Dynamic CSD for sinks I_II through VI; incl. single

%   This script takes input from the groups and data folders. It calculates
%   and stores CSD, sinks, AVREC, LFP, Relres, and basic information in a
%   Data struct per animal (eg MWT01_Data.mat) which is saved in the DATA
%   folder.
%
%   The sinks list is (II, IV, Va, Vb, VI)
%   IMPORTANT: DO NOT change sink list here. If you need another set of
%   sinks then create a SEPARATE and UNIQUELY NAMED script.

%   calls functions: imakeIndexer.m

cd(homedir); cd groups;

%% Load in
input = dir('*.m');
entries = length(input);
cd(homedir)

for i1 = 1:entries

    run(input(i1).name); % brings in animals, channels, Layer, and Cond

    %% Display conditions to verify correct list
    disp(Condition)

    %% Condition and Indexer
    Data = struct;
    BL   = 400; % always a 400ms baseline pre-event

    Indexer = imakeIndexer(Condition,animals,Cond); %#ok<*USENS>
    %%

    for iA = 1:length(animals)
        tic
        name = animals{iA}; %#ok<*IDISVAR>

        for iStimType = 1:length(Condition)
            for iStimCount = 1:length(Cond.(Condition{iStimType}){iA})
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

                    [StimIn, DataIn] = FileReaderSpike(file,str2num(channels{iA}));
                    sr_mult = 3; % sampling rate 3000, multiply by this to get [ms]

                    % The next part depends on the stimulus
                    if matches(Condition{iStimType},'NoiseBurst') || ...
                            matches(Condition{iStimType},'postNoise')
                        % non randomized list of dB presentation
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100*sr_mult; % ms
                        %                         sngtrldat = icutdata(file, StimIn, DataIn, stimList, ...
                        %                             (BL*sr_mult)-1, stimDur, 1000*sr_mult, 'noise');

                    elseif matches(Condition{iStimType},'Tonotopy')
                        stimList = [1, 2, 4, 8, 16, 24, 32];
                        thisunit = 'kHz';
                        stimDur  = 200*sr_mult; % ms
                        sngtrldat = icutandraster(file, StimIn, DataIn, stimList, ...
                            (BL*sr_mult)-1, stimDur, 1000*sr_mult, 'Tonotopy');

                    elseif matches(Condition{iStimType},'Spontaneous') || ...
                            matches(Condition{iStimType},'postSpont')
                        stimList = 1;
                        thisunit = [];
                        stimDur  = 1000*sr_mult; % ms
                        %                         sngtrldat = icutsinglestimdata(StimIn, DataIn, ...
                        %                             (BL*sr_mult)-1, stimDur, 1000*sr_mult, 'spont');

                    elseif matches(Condition{iStimType},'ClickTrain')
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 2000*sr_mult; % ms
                        %                         sngtrldat = icutdata(file, StimIn, DataIn, stimList, ...
                        %                             (BL*sr_mult)-1, stimDur, 2000*sr_mult, 'ClickRate');
                        %
                    elseif matches(Condition{iStimType},'Chirp')
                        stimList = 1;
                        thisunit = [];
                        stimDur  = 3000*sr_mult; % ms
                        %                         sngtrldat = icutsinglestimdata(StimIn, DataIn, ...
                        %                             (BL*sr_mult)-1, stimDur, 2000*sr_mult, 'single');

                    elseif matches(Condition{iStimType},'gapASSR')
                        stimList = [2, 4, 6, 8, 10];
                        thisunit = 'gap width [ms]';
                        stimDur  = 2000*sr_mult; % ms
                        %                         sngtrldat = icutdata(file, StimIn, DataIn, stimList, ...
                        %                             (BL*sr_mult)-1, stimDur, 2000*sr_mult, 'gapASSRRate');
                    end

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

                    Rasterfig = tiledlayout('flow');
                    title(Rasterfig,[file(1:5) ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' PSTH'])
                    xlabel(Rasterfig, 'time [ms]')
                    %                     ylabel(Rasterfig, 'depth [channels]')

                    for istim = 1:length(stimList)

                        % figure of psth's for all and layers per stim
                        trlsum = sum(sngtrldat{istim},3);
                        % raster summing all channels
                        chansum = sum(trlsum,1);
                        % rasters summing layer channels
                        IIsum = sum(trlsum(L.II,:),1);
                        IVsum = sum(trlsum(L.IV,:),1);
                        Vasum = sum(trlsum(L.Va,:),1);
                        Vbsum = sum(trlsum(L.Vb,:),1);
                        VIsum = sum(trlsum(L.VI,:),1);

                        % this is absurd, make seperate figures for each
                        % layer? or for each stim? (5 layer figs or 6 to 8
                        % stim figs. Probably layer then, also more consistant)
                        nexttile
                        bar(chansum,30,'histc')
                        nexttile
                        plot(IIsum)
                        nexttile
                        plot(IVsum)
                        nexttile
                        plot(Vasum)
                        nexttile
                        plot(Vbsum)
                        nexttile
                        plot(VIsum)          

                    end

                    h = gcf;
                    savefig(h,[name '_' measurement '_CSD' ],'compact')
                    close (h)

                    % determine BF of each layer from 1st sink's rms
                    clear BF_II BF_IV BF_Va BF_Vb BF_VI
                    for ilay = 1:length(Layers)

                        RMSlist = nan(1,length(RMS));
                        for istim = 1:length(RMS)
                            RMSlist(istim) = nanmax(RMS(istim).(Layers{ilay}));
                        end

                        BF = find(RMSlist == nanmax(RMSlist));

                        if contains(Layers{ilay},'II')
                            BF_II = stimList(BF);
                        elseif contains(Layers{ilay},'IV')
                            BF_IV = stimList(BF);
                        elseif contains(Layers{ilay},'VI')
                            BF_VI = stimList(BF);
                        elseif matches(Layers{ilay},'Va')
                            BF_Va = stimList(BF);
                        elseif matches(Layers{ilay},'Vb')
                            BF_Vb = stimList(BF);
                        end

                    end

                    %% Save and Quit
                    % identifiers and basic info
                    Data(CondIDX).measurement   = file;
                    Data(CondIDX).Condition     = [Condition{iStimType} '_' num2str(iStimCount)];
                    Data(CondIDX).BL            = BL;
                    Data(CondIDX).stimDur       = stimDur;
                    Data(CondIDX).StimList      = stimList;
                    % sink data
                    Data(CondIDX).BF_II         = BF_II;
                    Data(CondIDX).BF_IV         = BF_IV;
                    Data(CondIDX).BF_Va         = BF_Va;
                    Data(CondIDX).BF_Vb         = BF_Vb;
                    Data(CondIDX).BF_VI         = BF_VI;
                    Data(CondIDX).SinkPeakAmp   = PAMP;
                    Data(CondIDX).SglSinkPkAmp  = SINGLE_PAMP;
                    Data(CondIDX).SinkPeakLate  = PLAT;
                    Data(CondIDX).SglSinkPkLat  = SINGLE_PLAT;
                    Data(CondIDX).SinkDur       = DUR;
                    Data(CondIDX).Sinkonset     = ONSET;
                    Data(CondIDX).Sinkoffset    = OFFSET;
                    Data(CondIDX).SinkRMS       = RMS;
                    Data(CondIDX).SingleSinkRMS = SINGLE_RMS;
                    % CSD data
                    Data(CondIDX).sngtrlLFP     = sngtrldat;
                    Data(CondIDX).sngtrlCSD     = sngtrlCSD;
                    Data(CondIDX).AVREC         = AvrecCSD;
                    Data(CondIDX).sngtrlAvrec   = sngtrlAvrecCSD;
                    Data(CondIDX).RELRES        = AvgRelResCSD;
                    Data(CondIDX).singtrlRelRes = singtrlRelResCSD;

                    %% Visualize early tuning (onset between 0:65 ms)
                    IIcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    IVcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    Vacurve = nan(1,length(Data(CondIDX).SinkRMS));
                    Vbcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    VIcurve = nan(1,length(Data(CondIDX).SinkRMS));

                    for istim = 1:length(Data(CondIDX).SinkRMS)
                        if (410 < Data(CondIDX).Sinkonset(istim).II(1)) && ...
                                (Data(CondIDX).Sinkonset(istim).II(1) < 460)
                            IIcurve(istim) = Data(CondIDX).SinkRMS(istim).II(1);
                        else
                            IIcurve(istim) = NaN;
                        end

                        if (410 < Data(CondIDX).Sinkonset(istim).IV(1)) && ...
                                (Data(CondIDX).Sinkonset(istim).IV(1) < 460)
                            IVcurve(istim) = Data(CondIDX).SinkRMS(istim).IV(1);
                        else
                            IVcurve(istim) = NaN;
                        end

                        if (410 < Data(CondIDX).Sinkonset(istim).Va(1)) && ...
                                (Data(CondIDX).Sinkonset(istim).Va(1) < 460)
                            Vacurve(istim) = Data(CondIDX).SinkRMS(istim).Va(1);
                        else
                            Vacurve(istim) = NaN;
                        end

                        if (410 < Data(CondIDX).Sinkonset(istim).Vb(1)) && ...
                                (Data(CondIDX).Sinkonset(istim).Vb(1) < 460)
                            Vbcurve(istim) = Data(CondIDX).SinkRMS(istim).Vb(1);
                        else
                            Vbcurve(istim) = NaN;
                        end

                        if (410 < Data(CondIDX).Sinkonset(istim).VI(1)) && ...
                                (Data(CondIDX).Sinkonset(istim).VI(1) < 460)
                            VIcurve(istim) = Data(CondIDX).SinkRMS(istim).VI(1);
                        else
                            VIcurve(istim) = NaN;
                        end
                    end

                    figure
                    plot(IIcurve,'LineWidth',2),...
                        hold on,...
                        plot(IVcurve,'LineWidth',2),...
                        plot(Vacurve,'LineWidth',2),...
                        plot(Vbcurve,'LineWidth',2),...
                        plot(VIcurve,'LineWidth',2),...
                        legend('II', 'IV', 'Va', 'Vb', 'VI')
                    xticklabels(stimList)
                    ylabel('RMS [mV/mm²]')
                    xlabel([Condition{iStimType} ' [' thisunit ']'])
                    title([file(1:5) ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' Tuning Curve'])

                    hold off
                    h = gcf;
                    savefig(h,[name '_' measurement '_RMS Sink tuning' ],'compact')
                    close (h)
                end
            end
        end
        cd(homedir);
        %         if ~exist([homedir 'datastructs'],'dir')
        %             mkdir 'datastructs'
        %         end
        cd 'datastructs'
        save([name '_Data'],'Data');
        clear Data
        cd(homedir)
        toc
    end

end
cd(homedir)
