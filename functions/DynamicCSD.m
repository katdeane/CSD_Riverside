function DynamicCSD(homedir, Condition)
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
    BL   = 399; % always a 400ms baseline pre-event 
       
    Indexer = imakeIndexer(Condition,animals,Cond); %#ok<*USENS>
    %%
    
    for iA = 1:length(animals)
        name = animals{iA}; %#ok<*IDISVAR>
        
        for iStimType = 1:length(Condition)
            for iStimCount = 1:length(Cond.(Condition{iStimType}){iA})
                if iStimCount == 1
                    CondIDX = Indexer(2).(Condition{iStimType});
                else
                    CondIDX = Indexer(2).(Condition{iStimType})+iStimCount-1;
                end
                tic
                
                measurement = Cond.(Condition{iStimType}){iA}{iStimCount};
                % all of the above is to indicate which animal and
                % condition is being analyzed
                
                if ~isempty(measurement)
                    file = [name '_' measurement '_LFP'];
                    disp(['Analyzing animal: ' file])
                    
                    [StimIn, DataIn] = FileReaderLFP(file,str2num(channels{iA}));
                   
                    % The next part depends on the stimulus
                    if matches(Condition{iStimType},'NoiseBurst') || ...
                            matches(Condition{iStimType},'postNoise')
                        % non randomized list of dB presentation
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100; % ms
                        sngtrlLFP = icutdata(file, StimIn, DataIn, stimList, ...
                            BL, stimDur, 1000, 'noise');
                        
                    elseif matches(Condition{iStimType},'Tonotopy')
                        stimList = [1, 2, 4, 8, 16, 24, 32];
                        thisunit = 'kHz';
                        stimDur  = 200; % ms
                        sngtrlLFP = icutdata(file, StimIn, DataIn, stimList, ...
                            BL, stimDur, 1000, 'Tonotopy');
                        
                    elseif matches(Condition{iStimType},'Spontaneous') || ...
                            matches(Condition{iStimType},'postSpont')
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100; % ms
                        sngtrlLFP = icutNoisedata(file, StimIn, DataIn, stimList);
                       
                    elseif matches(Condition{iStimType},'ClickTrain')
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100; % ms
                        sngtrlLFP = icutNoisedata(file, StimIn, DataIn, stimList);
                        
                    elseif matches(Condition{iStimType},'Chirp')
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100; % ms
                        sngtrlLFP = icutNoisedata(file, StimIn, DataIn, stimList);
                        
                    elseif matches(Condition{iStimType},'gapASSR')
                        stimList = [20, 30, 40, 50, 60, 70, 80, 90];
                        thisunit = 'dB';
                        stimDur  = 100; % ms
                        sngtrlLFP = icutNoisedata(file, StimIn, DataIn, stimList);
                    end

                    %% All the data from the LFP now (sngtrl = single trial)
                    [sngtrlCSD, AvrecCSD, sngtrlAvrecCSD, AvgRelResCSD,...
                        singtrlRelResCSD] = SingleTrialCSD(sngtrlLFP,BL);
                    
                    %In case needed to delete empty columns to have the 
                    %correct amount of stimuli present: 
                    %AvgCSD = AvgCSD(~cellfun('isempty', AvgCSD')); AvgCSD=AvgCSD(1:length(frqz));
                    
                    % Sink durations
                    L.II = str2num(Layer.II{iA}); 
                    L.IV = str2num(Layer.IV{iA}); 
                    L.Va = str2num(Layer.Va{iA}); 
                    L.Vb = str2num(Layer.Vb{iA}); 
                    L.VI = str2num(Layer.VI{iA}); 
                    Layers = fieldnames(L); 
                    
                    %Generate Sink Boxes
                    [DUR,ONSET,OFFSET,RMS,SINGLE_RMS,PAMP,SINGLE_PAMP,PLAT,SINGLE_PLAT] =...
                        sink_dura(L,sngtrlCSD,BL);
                    
                    toc
                                                         
                    
                    %% Plots 
                    disp('Plotting CSD with sink detections')
                    tic
                    
                    cd (homedir); cd figures;
                    if ~exist(['Single_' input(i1).name(1:end-2)],'dir')
                        mkdir(['Single_' input(i1).name(1:end-2)]);
                    end
                    cd (['Single_' input(i1).name(1:end-2)])
    
                    CSDfig = tiledlayout('flow');
                    title(CSDfig,[file(1:5) ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' CSD'])
                    xlabel(CSDfig, 'time [ms]')
                    ylabel(CSDfig, 'depth [channels]')
                    
                    for istim = 1:length(stimList)
                        nexttile
                        imagesc(mean(sngtrlCSD{istim},3))
                        title([num2str(stimList(istim)) thisunit])
                        colormap jet                       
                        caxis([-0.1 0.1])
                        
                        hold on
                        % Layer II
                        for isink = 1:length(ONSET(istim).II)
                            y =[(max(L.II)+0.5),(max(L.II)+0.5),(min(L.II)-0.5),...
                                (min(L.II)-0.5),(max(L.II)+0.5)];
                            if isempty(y); y = [NaN NaN NaN NaN NaN]; end %in case the upper layer is not there
                            x = [ONSET(istim).II(isink), OFFSET(istim).II(isink),...
                                OFFSET(istim).II(isink), ONSET(istim).II(isink),...
                                ONSET(istim).II(isink)];
                            plot(x,y,'black','LineWidth',2)
                        end
                                                                        
                        % Layer IV
                        for isink = 1:length(ONSET(istim).IV)
                            y =[(max(L.IV)+0.5),(max(L.IV)+0.5),(min(L.IV)-0.5),...
                                (min(L.IV)-0.5),(max(L.IV)+0.5)];
                            x = [ONSET(istim).IV(isink), OFFSET(istim).IV(isink),...
                                OFFSET(istim).IV(isink), ONSET(istim).IV(isink),...
                                ONSET(istim).IV(isink)];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer Va
                        for isink = 1:length(ONSET(istim).Va)
                            y =[(max(L.Va)+0.5),(max(L.Va)+0.5),(min(L.Va)-0.5),...
                                (min(L.Va)-0.5),(max(L.Va)+0.5)];
                            x = [ONSET(istim).Va(isink), OFFSET(istim).Va(isink),...
                                OFFSET(istim).Va(isink), ONSET(istim).Va(isink),...
                                ONSET(istim).Va(isink)];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer Vb
                        for isink = 1:length(ONSET(istim).Vb)
                            y =[(max(L.Vb)+0.5),(max(L.Vb)+0.5),(min(L.Vb)-0.5),...
                                (min(L.Vb)-0.5),(max(L.Vb)+0.5)];
                            x = [ONSET(istim).Vb(isink), OFFSET(istim).Vb(isink),...
                                OFFSET(istim).Vb(isink), ONSET(istim).Vb(isink),...
                                ONSET(istim).Vb(isink)];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer VI
                        for isink = 1:length(ONSET(istim).VI)
                            y =[(max(L.VI)+0.5),(max(L.VI)+0.5),(min(L.VI)-0.5),...
                                (min(L.VI)-0.5),(max(L.VI)+0.5)];
                            x = [ONSET(istim).VI(isink), OFFSET(istim).VI(isink),...
                                OFFSET(istim).VI(isink), ONSET(istim).VI(isink),...
                                ONSET(istim).VI(isink)];
                            plot(x,y,'black','LineWidth',2)
                        end                    
                        
                        hold off
                        
                    end
                    toc
                    
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
                    Data(CondIDX).sngtrlLFP     = sngtrlLFP;
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
                        if 10 > Data(CondIDX).Sinkonset(istim).II(1) < 60
                            IIcurve(istim) = Data(CondIDX).SinkRMS(istim).II(1);
                        else
                            IIcurve(istim) = NaN;
                        end
                        
                        if 10 > Data(CondIDX).Sinkonset(istim).IV(1) < 60
                            IVcurve(istim) = Data(CondIDX).SinkRMS(istim).IV(1);
                        else
                            IVcurve(istim) = NaN;
                        end
                        
                        if 10 > Data(CondIDX).Sinkonset(istim).Va(1) < 60
                            Vacurve(istim) = Data(CondIDX).SinkRMS(istim).Va(1);
                        else
                            Vacurve(istim) = NaN;
                        end
                        
                        if 10 > Data(CondIDX).Sinkonset(istim).Vb(1) < 60
                            Vbcurve(istim) = Data(CondIDX).SinkRMS(istim).Vb(1);
                        else
                            Vbcurve(istim) = NaN;
                        end
                        
                        if 10 > Data(CondIDX).Sinkonset(istim).VI(1) < 60
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
        if ~exist([homedir 'datastructs'],'dir')
            mkdir 'datastructs'
        end
        
        cd 'datastructs'
        save([name '_Data'],'Data');
        clear Data
    end    
end
cd(homedir)
toc