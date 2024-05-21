function [DUR,ONSET,OFFSET,RMS,SINGLE_RMS,PAMP,SINGLE_SinkPeak,PLAT,SINGLE_PeakLat] = ...
    sink_dura(L,sngtrlCSD,BL)
% This function produces the duration of sinks within pre-specified
% layers (from group scripts eg. KIT.m).

% Step 1: a global baseline from all channels and all CSDs in this
% measurement (as in, the CSD for 1 kHz, 2kHz, ... etc) is created and from
% this, BL mean and std are taken.

% Step 2: we loop through the cortical layers to find the raw CSD for that
% layer and stimulus. We also get the raw single CSD [20 chan:800 ms:50
% trial]. Finally we zero source and gaussian smooth the current CSD as a
% seperate variable, AvgCSD_layer.

% Step 3: from the BL mean&std we generate 2 thresholds. The find threshold
% first creates a list of where the CSD intercepts it. The contain
% threshold determines that the CSD then also crosses this second
% threshold. If that condition is met, sink onset is taken as the find
% threshold intercept point. Adjust std_find to change specific onset and
% offset time sensitivity. Adjust std_contain to change detection 
% sensitivity.

% Step 4: we find all sink onsets and offsets in the current layer using
% the AvgCSD_layer, which is cleaner. We then use those onsets and offsets
% on the raw data to get peak amplitude, peak latency, and root mean square
% for the average and single-trial CSDs. These are handed out of the
% function as seperate structures and later folded into the animal's Data
% struct. 

% The output will be sized equally per animal - NaNs will fill in any space
% where there are no sinks detected.

% Note: this code detects *all* possible sinks, the sink onset time will be
% used in further analysis steps to determine which sinks count, for example
% towards tuning or after stim onset time. 

std_find    = 1;
std_contain = 2;

Order   = {'II','IV','Va','Vb','VI','all_chan'};
PAMP    = struct;
PLAT    = struct;
ONSET   = struct; 
OFFSET  = struct;
DUR     = struct;
RMS     = struct;
SINGLE_SinkPeak = struct;
SINGLE_PeakLat  = struct;
SINGLE_RMS      = struct;

for istim = 1:length(sngtrlCSD)
    
    AvgCSD = mean(sngtrlCSD{istim},3);
    
    %create std and mean line from BL
    std_BL = std(AvgCSD(:,1:BL),0,'all'); 
    mean_BL = mean(AvgCSD(:,1:BL),'all'); 
    
    for iOrder = 1:length(Order)
        
        %to take correct channels for layers pre-set in group .m's
        if strcmp(Order{iOrder}, 'all_chan')
            Chan = (1:size(AvgCSD,1)); % all layers/channels
        else
            Chan = L.(Order{iOrder});
        end
        
        %current stimulus avgcsd only in the current layer
        rawCSD = (nanmean(AvgCSD(Chan,:)))*-1; %to calculate parameters from raw signal
        rawCSD_single = (nanmean(sngtrlCSD{istim}(Chan,:,:))) *-1;
        
        %zero all source info and shape the data for sink detection
        holdAvgCSD = AvgCSD(Chan,:);
        holdAvgCSD(holdAvgCSD(:,:)>=0) = 0; %equates all positive values (denoting sources) to zero
        zeroCSD_layer = (nanmean(holdAvgCSD))*-1; %flips negative values to positive
        
        g = gausswin(10); %generates a gausswin distribution of 15 points from 1
        g = g/sum(g); %turns it into a percentage distribution
        AvgCSD_layer = conv(zeroCSD_layer, g, 'same'); %normalizes CSD to distribution
        AvgCSD_layer(:,end) = mean_BL - std_BL; %so that it definitely has an end
        
        %define thresholds for signal detection
        thresh_find = (mean_BL + (std_BL*std_find)); %*T
        thresh_contain = (mean_BL+(std_BL*std_contain)); %*T
        
        
        %% Averaged CSD
        
        AvgCSD_layer(:,1:BL) = mean_BL - std_BL; %so that the first point is counted as an actual intercept
        % in the case of artifact correction where part of the signal is
        % NaN, replace with 0s for continuous correction
        AvgCSD_layer(isnan(AvgCSD_layer)) = 0; 

        %find intercept points in ZERO SOURCE CSD
        location = thresh_find <= AvgCSD_layer; % 1 is above, 0 is below 
        % detect when signal crosses 
        crossover   = diff(location);
        onsets      = find(crossover == 1); %ABOVE threshold
        offsets     = find(crossover == -1); %BELOW threshold
        
        % sanity check plot
        % T = ones(1,length(AvgCSD_layer));
        % plot(AvgCSD_layer) 
        % hold on
        % plot(thresh_find*T)
        % plot(thresh_contain*T)
        % for ion  = 1:length(onsets); plot(onsets(ion),thresh_find,'o'); end
        % for ioff = 1:length(offsets); plot(offsets(ioff),thresh_find,'d'); end
        % hold off
        
        rmslist = NaN(1,length(onsets));
        pamplist = NaN(1,length(onsets));
        platlist = NaN(1,length(onsets));
        for iCross = 1:length(onsets)-1
            %if the first point less than the onset level and if there's a peak following it, calculate rms
            if (nanmax(AvgCSD_layer(:,onsets(iCross):offsets(iCross)))) > thresh_contain
                % if the sink is wide enough at the base 
                if (offsets(iCross)-onsets(iCross)) > 30
                    % take actual rms and peak from RAW CSD
                    rmslist(iCross)  = rms(rawCSD(:,onsets(iCross):onsets(iCross+1)),'omitnan');
                    pamplist(iCross) = nanmax(rawCSD(:,onsets(iCross):onsets(iCross+1)));
                    platlist(iCross) = find(rawCSD(:,onsets(iCross):onsets(iCross+1)) == pamplist(iCross));
                end
            end
        end
        
        if sum(~isnan(rmslist)) == 0 % if no detected sinks:
            LayerSinkON   = NaN;
            LayerSinkOFF  = NaN;
            LayerSinkDUR  = NaN;
            LayerSinkRMS  = NaN;
            LayerSinkPAMP = NaN;
            LayerSinkPLAT = NaN;
            
        else % if at least one detected sink:
            
            % Based on gausian and zero source data:
            clear boolist; boolist(~isnan(rmslist)) = 1; % boolian of sinks
            LayerSinkON   = onsets(boolist==1);
            LayerSinkOFF  = offsets(boolist == 1);
            LayerSinkDUR  = LayerSinkOFF - LayerSinkON;
            
            % Based on raw data:
            LayerSinkRMS  = rmslist(~isnan(rmslist));
            LayerSinkPAMP = pamplist(~isnan(pamplist));
            LayerSinkPLAT = platlist(~isnan(platlist)) + LayerSinkON;
            
        end
        
        PAMP(istim).(Order{iOrder})   = LayerSinkPAMP;
        PLAT(istim).(Order{iOrder})   = LayerSinkPLAT;
        ONSET(istim).(Order{iOrder})  = LayerSinkON;
        OFFSET(istim).(Order{iOrder}) = LayerSinkOFF;
        DUR(istim).(Order{iOrder})    = LayerSinkDUR;
        RMS(istim).(Order{iOrder})    = LayerSinkRMS;
        
        %% Single Trial CSD (using onset-offset of average)
        
        if sum(~isnan(LayerSinkRMS)) == 0
            SINGLE_SinkPeak(istim).(Order{iOrder})= nan(50,1);
            SINGLE_PeakLat(istim).(Order{iOrder})= nan(50,1);
            SINGLE_RMS(istim).(Order{iOrder})= nan(50,1);
            continue % skip and go to next loop
        end
        
        for itrial = 1:size(rawCSD_single,3)
            curRun = rawCSD_single(:,:,itrial);
            for isink = 1:length(LayerSinkRMS)
               
                % timing of onset/offset for each sink is drawn from averaged data 
                sinktime = round(LayerSinkON(isink):LayerSinkOFF(isink));
                % RMS, peak lat, and peak amp is take from RAW single trial data
                sinkRun = curRun(sinktime);
                                
                SINGLE_RMS(istim).(Order{iOrder})(itrial,isink)= rms(sinkRun);
                SINGLE_SinkPeak(istim).(Order{iOrder})(itrial,isink)= max(sinkRun);
                if isnan(max(sinkRun)) || length(sinktime) == 2 
                    %if there's no max, if the state is default 2, or if
                    %there's more than two times it hits the max value: NaN
                    SINGLE_PeakLat(istim).(Order{iOrder})(itrial,isink)= NaN;
                else
                    %given the case allowed that it may reach max value twice, take the first max
                    SINGLE_PeakLat(istim).(Order{iOrder})(itrial,isink)= find(sinkRun == max(sinkRun),1) + LayerSinkON(isink);
                end
            end
        end

    end
end