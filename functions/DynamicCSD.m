function DynamicCSD(homedir, Condition, Groups, cbar, type)

%% Dynamic CSD for sinks I_II through VI; incl. single

%   This script takes input from groups/ and data/. It calculates 
%   and stores LFP, CSD, AVREC, Relres, and basic information in a 
%   Data struct per subject (eg MWT01_Data.mat) which is saved in 
%   datastructs/
%  
%   cbar variable sets caxis, flexible for different species
%
%   Data is from Neuronexus: Allego and Curate, should have *_LFP.xdat.json,
%   *_LFP_data.xdat, and *_LFP_timestamp.xdat per subject (eg MWT01_01). 
% 
%   Condition should be a string matching a condition saved in the group
%   metadata file (eg MWT.m), such as 'NoiseBurst'
% 
%   The sinks list is (II, IV, Va, Vb, VI)
%   IMPORTANT: DO NOT change sink list here. If you need another set of
%   sinks then create a SEPARATE and UNIQUELY NAMED script.
%
%   calls homebrew functions: imakeIndexer, FileReaderLFP, StimVariable, 
%   icutdata, icutsinglestimdata, SingleTrialCSD, sink_dura


%% Load in
cd(homedir)

for iGro = 1:length(Groups)    
    
    run([Groups{iGro} '.m']); % brings in animals, channels, Layer, and Cond
    
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
                
                measurement = Cond.(Condition{iStimType}){iA}{iStimCount};
                % all of the above is to indicate which animal and
                % condition is being analyzed
                
                if exist([name(1:5) '_' measurement '_LFP.xdat.json'],'file')
                    file = [name(1:5) '_' measurement '_LFP'];
                    disp(['Analyzing animal: ' file])
                    tic
                    
                    if matches(file,'PMP09_05_LFP')
                        [StimIn, DataIn] = FileReaderLFPresamp(file,str2num(channels{iA}),type);
                    else
                        [StimIn, DataIn] = FileReaderLFP(file,str2num(channels{iA}),type);
                    end

                    % The next part depends on the stimulus; pull the
                    % relevant variables
                    if matches(animals(iA),'FOS01')
                        [stimList, thisUnit, stimDur, stimITI, thisTag] = ...
                            StimVariable(Condition{iStimType},1,'Awake1');
                    else
                        [stimList, thisUnit, stimDur, stimITI, thisTag] = ...
                            StimVariable(Condition{iStimType},1,type);
                    end

                    % and slice the data
                    if matches(thisTag,'single') || matches(thisTag,'spont')
                        sngtrlLFP = icutsinglestimdata(StimIn, DataIn, BL, ...
                            stimDur, stimITI, thisTag);
                    elseif matches(thisTag,'gapASSRRate') 
                        sngtrlLFP = icutGAPdata(file, StimIn, DataIn, stimList, ...
                            BL, stimDur, stimITI, thisTag);
                    else
                        sngtrlLFP = icutdata(file, StimIn, DataIn, stimList, ...
                            BL, stimDur, stimITI, thisTag);
                    end

                    clear DataIn StimIn % these are too big to keep around
                    
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
                    [DUR,ONSET,OFFSET,RMS,SINGLE_RMS,PAMP,SINGLE_SinkPeak,PLAT,SINGLE_PeakLat] =...
                        sink_dura(L,sngtrlCSD,BL);                        
                    
                    %% Plots 
                    disp('Plotting CSD with sink detections')
                    
                    cd (homedir); cd figures;
                    if ~exist(['Single_' Groups{iGro}],'dir')
                        mkdir(['Single_' Groups{iGro}]);
                    end
                    cd (['Single_' Groups{iGro}])
    
                    CSDfig = tiledlayout('flow');
                    title(CSDfig,[name ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' CSD'])
                    xlabel(CSDfig, 'time [ms]')
                    ylabel(CSDfig, 'depth [channels]')
                    
                    for istim = 1:length(stimList)
                        nexttile
                        imagesc(nanmean(sngtrlCSD{istim},3))
                        title([num2str(stimList(istim)) thisUnit])
                        colormap jet                       
                        caxis(cbar)
                        xline(BL+1,'LineWidth',2) % onset
                        xline(BL+stimDur+1,'LineWidth',2) % offset
                        yline(L.II(end)); yline(L.IV(end)); 
                        yline(L.Va(end)); yline(L.Vb(end));
                        if L.VI(end) > size(sngtrlCSD,1)
                            yline(L.VI(end));
                        end
                    end
                    
                    colorbar
                    h = gcf;
                    savefig(h,[name '_' measurement '_CSD' ],'compact')
                    % saveas(h,[name '_' measurement '_CSD.png' ])
                    % close (h)

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
                    % % sink data
                    Data(CondIDX).sinkdur       = DUR;
                    Data(CondIDX).sinkonset     = ONSET;
                    Data(CondIDX).sinkoffset    = OFFSET;
                    Data(CondIDX).sinkRMS       = RMS;
                    Data(CondIDX).sinkSGLRMS    = SINGLE_RMS;
                    Data(CondIDX).sinkPeakAmp   = PAMP;
                    Data(CondIDX).sinkSGLPAMP   = SINGLE_SinkPeak;
                    Data(CondIDX).sinkPeakLat   = PLAT;
                    Data(CondIDX).sinkSGLPLAT   = SINGLE_PeakLat;
                    % % BFs
                    Data(CondIDX).BF_II         = BF_II;
                    Data(CondIDX).BF_IV         = BF_IV;
                    Data(CondIDX).BF_Va         = BF_Va;
                    Data(CondIDX).BF_Vb         = BF_Vb;
                    Data(CondIDX).BF_VI         = BF_VI;
                    % 
                    % % CSD data
                    Data(CondIDX).sngtrlLFP     = sngtrlLFP;
                    Data(CondIDX).sngtrlCSD     = sngtrlCSD;
                    Data(CondIDX).AVREC         = AvrecCSD;
                    Data(CondIDX).sngtrlAvrec   = sngtrlAvrecCSD;
                    Data(CondIDX).RELRES        = AvgRelResCSD;
                    Data(CondIDX).singtrlRelRes = singtrlRelResCSD;
                                        
                    toc
                end
            end
        end

        if exist('Data','var')
            cd(homedir);
            cd datastructs
            save([name '_Data'],'Data');
            clear Data
            cd(homedir)
        end
    end

end
cd(homedir)
