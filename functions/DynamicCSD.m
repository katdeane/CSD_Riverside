function DynamicCSD(homedir, Condition)
%% Dynamic CSD for sinks I_II through VI; incl. single

%   This script takes input from the groups and data folders. It calculates 
%   and stores CSD, sinks, AVREC, LFP, Relres, and basic information in a 
%   Data struct per animal (eg MWT01_Data.mat) which is saved in the DATA 
%   folder. 
% 
%   The sinks list takes into account the smaller mouse cortex compared to
%   gerbils. (I_II, IV, V, VI)
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
                    LFPOut = icutNoisedata(homedir, file, StimIn, DataIn);
                    % Need to combine this with next thing to get out all of the extra data    
                    CSDandTuningFigs(file, LFPOut, 'Noise')
                    
                    %% CSD full

                    %note: channel order is given twice because the whole
                    %CSD needs to be checked now (and not any one layer)
                    [SingleRec_preAVREC,Rec_preAVREC,AvgFP, SingleTrialFP, AvgCSD,...
                        SingleTrialCSD, AvgRecCSD, SingleTrialAvgRecCSD,...
                        SingleTrialRelResCSD, AvgRelResCSD,AvgAbsResCSD,...
                        SingleTrialAbsResCSD, LayerRelRes, AvgLayerRelRes] =...
                        SingleTrialCSD_full(SWEEP, str2num(channels{iA}),1:length(str2num(channels{iA})),BL);
                    
                    %In case needed to delete empty columns to have the 
                    %correct amount of stimuli present: 
                    %AvgCSD = AvgCSD(~cellfun('isempty', AvgCSD')); AvgCSD=AvgCSD(1:length(frqz));
                    
                    % Sink durations
                    L.I_II = str2num(Layer.I_II{iA}); 
                    L.IV = str2num(Layer.IV{iA}); 
                    L.V = str2num(Layer.V{iA}); 
                    L.VI = str2num(Layer.VI{iA}); 
                    Layers = fieldnames(L); 
                    
                    %Generate Sink Boxes
                    [DUR,ONSET,OFFSET,RMS,SINGLE_RMS,PAMP,SINGLE_PAMP,PLAT,SINGLE_PLAT] =...
                        sink_dura_Crypt(L,AvgCSD,SingleTrialCSD,BL);
                    
                    toc
                                                         
                    
                    %% Plots 
                    cd (homedir); cd figures;
                    mkdir(['Single_' input(i1).name(1:end-2)]);
    
                    figure('Name',[name ' ' measurement ': ' Condition{iStimType}])
                    tic
                    disp('Plotting CSD with sink detections')
                    for istim = 1:length(AvgCSD)
                        subplot(2,round(length(AvgCSD)/2),istim)
                        imagesc(AvgCSD{istim})
                        if istim == 1
                            title ([name ' ' measurement ': ' Condition{iStimType} ' ' num2str(istim) ' ' num2str(frqz(istim)) ' Hz'])
                        else
                            title ([num2str(frqz(istim)) ' Hz'])
                        end
                        
                        colormap (jet)                        
                        clim([-0.0005 0.0005])
                        
                        hold on
                        % Layer I_II
                        for isink = 1:length(ONSET(istim).I_II)
                            y =[(max(L.I_II)+0.5),(max(L.I_II)+0.5),(min(L.I_II)-0.5),...
                                (min(L.I_II)-0.5),(max(L.I_II)+0.5)];
                            if isempty(y); y = [NaN NaN NaN NaN NaN]; end %in case the upper layer is not there
                            x = [ONSET(istim).I_II(isink)+BL, OFFSET(istim).I_II(isink)+BL,...
                                OFFSET(istim).I_II(isink)+BL, ONSET(istim).I_II(isink)+BL,...
                                ONSET(istim).I_II(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                                                                        
                        % Layer IV
                        for isink = 1:length(ONSET(istim).IV)
                            y =[(max(L.IV)+0.5),(max(L.IV)+0.5),(min(L.IV)-0.5),...
                                (min(L.IV)-0.5),(max(L.IV)+0.5)];
                            x = [ONSET(istim).IV(isink)+BL, OFFSET(istim).IV(isink)+BL,...
                                OFFSET(istim).IV(isink)+BL, ONSET(istim).IV(isink)+BL,...
                                ONSET(istim).IV(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer V
                        for isink = 1:length(ONSET(istim).V)
                            y =[(max(L.V)+0.5),(max(L.V)+0.5),(min(L.V)-0.5),...
                                (min(L.V)-0.5),(max(L.V)+0.5)];
                            x = [ONSET(istim).V(isink)+BL, OFFSET(istim).V(isink)+BL,...
                                OFFSET(istim).V(isink)+BL, ONSET(istim).V(isink)+BL,...
                                ONSET(istim).V(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end
                        
                        % Layer VI
                        for isink = 1:length(ONSET(istim).VI)
                            y =[(max(L.VI)+0.5),(max(L.VI)+0.5),(min(L.VI)-0.5),...
                                (min(L.VI)-0.5),(max(L.VI)+0.5)];
                            x = [ONSET(istim).VI(isink)+BL, OFFSET(istim).VI(isink)+BL,...
                                OFFSET(istim).VI(isink)+BL, ONSET(istim).VI(isink)+BL,...
                                ONSET(istim).VI(isink)+BL];
                            plot(x,y,'black','LineWidth',2)
                        end                    
                        
                        hold off
                        
                    end
                    toc
                    
                    cd([homedir '\figs\']); mkdir(['Single_' input(i1).name(1:end-2)]);
                    cd(['Single_' input(i1).name(1:end-2)])
                    h = gcf;
                    set(h, 'PaperType', 'A4');
                    set(h, 'PaperOrientation', 'landscape');
                    set(h, 'PaperUnits', 'centimeters');
                    savefig(h,[name '_' measurement '_CSDs' ],'compact')
                    close (h)

                    % determine BF of each layer from 1st sink's rms
                    clear BF_II BF_IV BF_V BF_VI
                    for ilay = 1:length(Layers)
                        
                        RMSlist = nan(1,length(RMS));
                        for istim = 1:length(RMS)
                            if frqz(istim) == 0 || isinf(frqz(istim))
                                continue
                            end
                            RMSlist(istim) = RMS(istim).(Layers{ilay})(1);
                        end
                        
                        BF = find(RMSlist == nanmax(RMSlist));

                        if contains(Layers{ilay},'II')
                            BF_II = frqz(BF);
                        elseif contains(Layers{ilay},'IV')
                            BF_IV = frqz(BF);
                        elseif contains(Layers{ilay},'VI')
                            BF_VI = frqz(BF);
                        else 
                            BF_V = frqz(BF);
                        end
                        
                    end

                    %% Save and Quit
                    Data(CondIDX).measurement   = [name '_' measurement];
                    Data(CondIDX).Condition     = [Condition{iStimType} '_' num2str(iStimCount)];
                    Data(CondIDX).BL            = BL;
                    Data(CondIDX).StimDur       = tone;
                    Data(CondIDX).Frqz          = frqz';
                    Data(CondIDX).BF_II         = BF_II;
                    Data(CondIDX).BF_IV         = BF_IV;
                    Data(CondIDX).BF_V          = BF_V;
                    Data(CondIDX).BF_VI         = BF_VI;
                    Data(CondIDX).Bandwidth     = bandwidth;
                    Data(CondIDX).Tuningwidth   = tuningwidth;
                    Data(CondIDX).SinkPeakAmp   = PAMP;
                    Data(CondIDX).SglSinkPkAmp  = SINGLE_PAMP;
                    Data(CondIDX).SinkPeakLate  = PLAT;
                    Data(CondIDX).SglSinkPkLat  = SINGLE_PLAT;
                    Data(CondIDX).SinkDur       = DUR;
                    Data(CondIDX).Sinkonset     = ONSET;
                    Data(CondIDX).Sinkoffset    = OFFSET;
                    Data(CondIDX).SinkRMS       = RMS;
                    Data(CondIDX).SingleSinkRMS = SINGLE_RMS;
                    Data(CondIDX).SglTrl_LFP    = SingleTrialFP;
                    Data(CondIDX).LFP           = AvgFP;
                    Data(CondIDX).SglTrl_CSD    = SingleTrialCSD;
                    Data(CondIDX).CSD           = AvgCSD;
                    Data(CondIDX).LayerRelRes   = AvgLayerRelRes;
                    Data(CondIDX).SingleRecCSD  = SingleRec_preAVREC;
                    Data(CondIDX).LayerRecCSD   = Rec_preAVREC;
                    Data(CondIDX).AVREC_raw     = AvgRecCSD;
                    Data(CondIDX).SglTrl_AVRraw = SingleTrialAvgRecCSD;
                    Data(CondIDX).SglTrl_Relraw = SingleTrialRelResCSD;
                    Data(CondIDX).SglTrl_Absraw = SingleTrialAbsResCSD;
                    Data(CondIDX).RELRES_raw    = AvgRelResCSD;
                    Data(CondIDX).ABSRES_raw    = AvgAbsResCSD;
                    
                    %% Visualize early tuning (onset between 0:65 ms)
                    IIcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    IVcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    Vcurve  = nan(1,length(Data(CondIDX).SinkRMS));
                    VIcurve = nan(1,length(Data(CondIDX).SinkRMS));
                    
                    for istim = 1:length(Data(CondIDX).SinkRMS)
                        if 0 > Data(CondIDX).Sinkonset(istim).I_II(1) < 60
                            IIcurve(istim) = Data(CondIDX).SinkRMS(istim).I_II(1);
                        else
                            IIcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).IV(1) < 60
                            IVcurve(istim) = Data(CondIDX).SinkRMS(istim).IV(1);
                        else
                            IVcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).V(1) < 60
                            Vcurve(istim) = Data(CondIDX).SinkRMS(istim).V(1);
                        else
                            Vcurve(istim) = NaN;
                        end
                        
                        if 0 > Data(CondIDX).Sinkonset(istim).VI(1) < 60
                            VIcurve(istim) = Data(CondIDX).SinkRMS(istim).VI(1);
                        else
                            VIcurve(istim) = NaN;
                        end
                    end
                    
                    figure('Name',[name ' ' measurement ': ' Condition{iStimType} ' ' num2str(iStimCount)]);
                    plot(IIcurve,'LineWidth',2),...
                        hold on,...
                        plot(IVcurve,'LineWidth',2),...
                        plot(Vcurve,'LineWidth',2),...
                        plot(VIcurve,'LineWidth',2),...
                        legend('II', 'IV', 'V', 'VI')
                    xticklabels(frqz)
                    hold off
                    h = gcf;
                    set(h, 'PaperType', 'A4');
                    set(h, 'PaperOrientation', 'landscape');
                    set(h, 'PaperUnits', 'centimeters');
                    savefig(h,[name '_' measurement '_RMS Sink tuning' ],'compact')
                    close (h)
                end
            end
        end
        
        if ~exist([homedir 'DATA'],'dir')
            cd(homedir); mkdir 'DATA'
        end
        
        cd ([homedir '/DATA'])
        save([name '_Data'],'Data');
        clear Data
    end    
end
cd(homedir)
toc