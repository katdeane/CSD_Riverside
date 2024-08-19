function [peakout,latencyout,rmsout] = pupcall_peaks(datain, call_list)
% this function detects peaks, using the peak prominance feature, at a
% single trial level. 

% stim_freq and dur_stim input determine how many detection windows peaks 
% are detected from. e.g. 1, 100 = 1 detection window; 20, 1000 = 20 
% detection windows. BL determines the start time point for detection

% datain should be avrec or layer traces over trials (averagedchan x time x
% trials)

if ~exist('call_list','var')
    call_list  = [1,4,9,13,18]; % Hz of stim presentation
end

% load in pre-determined pup calls
load('PupTimes.mat','PupTimes')
PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
PupTimes = PupTimes + 0.400; % add the prestimulus time
% % sanity check with a pup call CSD figure that includes .wav image
% callWAV = PupTimes(13,1); 
% xlim([callWAV-0.2 callWAV+0.4])
PupTimes = PupTimes .* 1000; % match axes for CSD

% detection windows will be from onset to 200 ms after onset (to match
% 5 Hz click windows)
numreps = length(call_list);
det_on     = nan(1,numreps);
for iCall = 1:numreps
    det_on(iCall) = PupTimes(call_list(iCall),1);
end
det_off = det_on + 200;

%preallocation of data containers
peakout    = nan(numreps,size(datain,3));
latencyout = nan(numreps,size(datain,3));
rmsout     = nan(numreps,size(datain,3));

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
            [pks, locs, ~, p] = findpeaks(det_win); % p = prominence
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
            % take RMS regardless
            rmsout(iSti,iTrial)         = rms(det_win(det_win > 0));
        end
    end
end