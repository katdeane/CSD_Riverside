function [peakout,latencyout,rmsout] = pupcall_peaks(datain, call_list,BL)
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

std_find = 1; % 1 standard deviation above baseline to detect onset-offset

% get this trace threshold, averaged over trials
dataBL     = nanmean(squeeze(datain(:,1:BL,:)),2);
std_BL     = nanstd(dataBL,0,'all');
mean_BL    = nanmean(dataBL,'all');
std_Thresh = mean_BL + (std_BL*std_find);

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
latencyout = peakout;
rmsout     = peakout;
onsetout   = peakout;
offsetout  = peakout;

%% Take features
for iTrial = 1:size(datain,3)

    % this runs through all sinks for each detection window opportunity
    for iSti = 1:numreps

        % cut the detection window to on and off time set according to number
        % of clicks:
        det_win = datain(1,det_on(iSti):det_off(iSti),iTrial);
        det_win(1:5) = mean_BL; % in the rare case the spont activity starts high
        det_win(end-5:end) = mean_BL; % in the rare case the spont activity doesn't fully reset

        %% Onset detection

        %find intercept points in ZERO SOURCE CSD
        location = std_Thresh <= det_win; % 1 is above, 0 is below
        % detect when signal crosses
        crossover   = diff(location);
        onsets      = find(crossover == 1); %ABOVE threshold
        offsets     = find(crossover == -1); %BELOW threshold

        % sanity check plot
        % figure
        % plot(det_win)
        % hold on
        % yline(std_Thresh)
        % for ion  = 1:length(onsets); plot(onsets(ion),std_Thresh,'o'); end
        % for ioff = 1:length(offsets); plot(offsets(ioff),std_Thresh,'d'); end
        % hold off

        %% Peak prominence detection

        % find peak power and peak latency
        if sum(det_win) == 0 || isnan(sum(det_win)) % no sink detected or no layer data (nan)
            peakout(iSti,iTrial)        = NaN;
            latencyout(iSti,iTrial)     = NaN;
            rmsout(iSti,iTrial)         = NaN;
            onsetout(iSti,iTrial)       = NaN;
            onsetout(iSti,iTrial)       = NaN;
        else
            [pks, locs, ~, p] = findpeaks(det_win); % p = prominence
            [str, maxInd]=max(p); %which peak is most prominent

            %           figure; plot(det_win); hold on; plot(locs(maxInd),pks(maxInd),'o');hold off

            % Peak Prominence check
            if str < 0.0003 %arbitrary threshold throwing out non-prominent peaks
                peakout(iSti,iTrial)    = NaN;
                latencyout(iSti,iTrial) = NaN;
                onsetout(iSti,iTrial)   = NaN;
                onsetout(iSti,iTrial)   = NaN;
            elseif isempty(str) % this would mean the data is a straight line
                peakout(iSti,iTrial)    = NaN;
                latencyout(iSti,iTrial) = NaN;
                onsetout(iSti,iTrial)   = NaN;
                onsetout(iSti,iTrial)   = NaN;
            else % peak is there and strong enough
                peakout(iSti,iTrial)    = pks(maxInd);
                latencyout(iSti,iTrial) = locs(maxInd);
                % take onset and offset around prominent peak
                if sum(onsets < (det_off(iSti)-det_on(iSti))) == 0 ...% no threshold crosses in the window
                        || latencyout(iSti,iTrial) < onsets(1) ...% threshold cross only after peak
                        || latencyout(iSti,iTrial) > offsets(end) % threshold cross only before peak
                    onsetout(iSti,iTrial)  = NaN;
                    offsetout(iSti,iTrial) = NaN;
                else
                    onsets            = onsets(onsets <= latencyout(iSti,iTrial));
                    offsets           = offsets(offsets >= latencyout(iSti,iTrial));
                    if latencyout(iSti,iTrial) < 5 % we made the first 5 BL
                        onsets = latencyout(iSti,iTrial);
                    end
                    onsetout(iSti,iTrial)  = onsets(end);
                    offsetout(iSti,iTrial) = offsets(1);
                end
            end
            % take RMS regardless
            rmsout(iSti,iTrial)         = rms(det_win(det_win > 0));
        end
    end
end