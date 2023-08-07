function DynamicCSD(homedir, Condition)

%% Dynamic CSD for sinks I_II through VI; incl. single

%   This script takes input from groups/ and data/. It calculates 
%   and stores LFP, CSD, AVREC, Relres, and basic information in a 
%   Data struct per subject (eg MWT01_Data.mat) which is saved in 
%   datastructs/
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
%   icutdata, SingleTrialCSD, sink_dura

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
                
                if exist([name '_' measurement '_LFP.xdat.json'],'file')
                    file = [name '_' measurement '_LFP'];
                    disp(['Analyzing animal: ' file])
                    
                    [StimIn, DataIn] = FileReaderLFP(file,str2num(channels{iA}));

                    % The next part depends on the stimulus; pull the
                    % relevant variables
                    [stimList, thisUnit, stimDur, stimITI, thisTag] = ...
                        StimVariable(Condition{iStimType},1);

                    % and slice the data
                    sngtrlLFP = icutdata(file, StimIn, DataIn, stimList, ...
                        BL, stimDur, stimITI, thisTag);

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
                    [~,~,~,RMS,~,~,~,~,~] =...
                        sink_dura(L,sngtrlCSD,BL);                        
                    
                    %% Plots 
                    disp('Plotting CSD with sink detections')
                    
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
                        title([num2str(stimList(istim)) thisUnit])
                        colormap jet                       
                        caxis([-0.2 0.2])
                    end
                    
                    colorbar
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
                    % sink data removed 08/07/23

                    % BFs
                    Data(CondIDX).BF_II         = BF_II;
                    Data(CondIDX).BF_IV         = BF_IV;
                    Data(CondIDX).BF_Va         = BF_Va;
                    Data(CondIDX).BF_Vb         = BF_Vb;
                    Data(CondIDX).BF_VI         = BF_VI;

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
                    xlabel([Condition{iStimType} ' [' thisUnit ']'])
                    title([file(1:5) ' ' Condition{iStimType}...
                        ' ' num2str(iStimCount) ' Tuning Curve'])
                    
                    hold off
                    h = gcf;
                    savefig(h,[name '_' measurement '_RMS Sink tuning' ],'compact')
                    close (h)
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
    toc
end
cd(homedir)
