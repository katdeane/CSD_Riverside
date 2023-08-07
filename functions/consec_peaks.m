function [peakout,latencyout,rmsout] = consec_peaks(datain, stim_freq, dur_stim, BL)
% this function detects peaks, using the peak prominance feature, at a
% single trial level. 

% stim_freq and dur_stim input determine how many detection windows peaks 
% are detected from. e.g. 1, 100 = 1 detection window; 20, 1000 = 20 
% detection windows. BL determines the start time point for detection

% datain should be avrec or layer traces over trials (averagedchan x time x
% trials)

if ~exist('BL','var')
    BL  = 400; % ms before the first stim onset
end
if ~exist('stim_freq','var')
    stim_freq  = 2; % Hz of stim presentation
end
if ~exist('stim_freq','var')
    dur_stim  = 1000; % 1 s of stimulus
end

numreps = ceil(dur_stim / (1000/stim_freq)); % assuming sr 1k

%preallocation of onset detection window containers
peakout    = nan(numreps,size(datain,3));
latencyout = nan(numreps,size(datain,3));
rmsout     = nan(numreps,size(datain,3));
% needed to run detection loop
det_on     = nan(1,round(numreps));
det_off    = nan(1,round(numreps));
det_jump   = round(dur_stim/numreps);
% fill detection window containers
for idet = 1:round(numreps)
    if idet == 1
        det_on(idet) = BL;
    else
        det_on(idet) = det_on(idet-1) + det_jump;
    end

    % this makes a detection window of maximum 100 ms
    if det_jump < 100
        det_off(idet) = det_on(idet) + det_jump - 1; 
    else
        det_off(idet) = det_on(idet) + 99; 
    end
end

%% Take features
for iTrial = 1:size(datain,3)

    % this runs through all sinks for each detection window opportunity
    for iSti = 1:numreps

        % cut the detection window to on and off time set according to number
        % of clicks:
        det_win = datain(1,det_on(iSti):det_off(iSti),iTrial);

        % find peak power and peak latency
        if sum(det_win) == 0 || isnan(sum(det_win)) % no sink detected or no layer data (nan)
            peakout(iSti,iTrial)        = NaN;
            latencyout(iSti,iTrial)     = NaN;
            rmsout(iSti,iTrial)         = NaN;
        else
            [pks, locs, ~, p] = findpeaks(det_win);
            [str, maxInd]=max(p); %which peak is most prominent
            
%           figure; plot(det_win); hold on; plot(locs(maxInd),pks(maxInd),'o');hold off
            
            % Peak Prominence check
            if str < 0.0003 %arbitrary threshold throwing out non-prominent peaks
                peakout(iSti,iTrial)    = NaN;
                latencyout(iSti,iTrial) = NaN;
            elseif isempty(str) % this would mean the data is a straight line
                peakout(iSti,iTrial)    = NaN;
                latencyout(iSti,iTrial) = NaN;
            else % peak is there and strong enough
                peakout(iSti,iTrial)    = pks(maxInd);
                latencyout(iSti,iTrial) = locs(maxInd);
            end
            rmsout(iSti,iTrial)         = rms(det_win(det_win > 0));

        end
    end
end