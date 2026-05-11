function [peakout,latencyout,rmsout,onsetout,offsetout] = ...
    consec_peaks_longNB(datain, BL)
% this function detects peaks, using the peak prominance feature, at a
% single trial level.

% stim_freq and dur_stim input determine how many detection windows peaks
% are detected from. e.g. 1, 100 = 1 detection window; 20, 1000 = 20
% detection windows. BL determines the start time point for detection

% datain should be avrec or layer traces over trials (averagedchan x time x
% trials)

if ~exist('BL','var')
    BL  = 399; % ms before the first stim onset
end

% detection windows and thresholds
det_on   = 1 + BL; %
det_off  = 101 + BL; % 100 ms window
std_find = 1; % 1 standard deviation above baseline to detect onset-offset

% get this trace threshold, averaged over trials
dataBL     = nanmean(squeeze(datain(:,1:BL,:)),2);
std_BL     = nanstd(dataBL,0,'all');
mean_BL    = nanmean(dataBL,'all');
std_Thresh = mean_BL + (std_BL*std_find);

%preallocation of data containers
peakout    = nan(1,size(datain,3));
latencyout = peakout;
rmsout     = peakout;
onsetout   = peakout;
offsetout  = peakout;

%% Take features
for iTrial = 1:size(datain,3)

    % cut the data to the detection window onset, but leave a lot of
    % trail-off so that offsets can be determined (super generous, we only
    % want the first onset/offset though)
    det_win = datain(1,det_on:det_off+150,iTrial);
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

    % cut the data to the detection window so that peak prominance and onset is
    % relegated with boundaries
    det_win = datain(1,det_on:det_off,iTrial);

    % find peak power and peak latency
    if sum(det_win) == 0 || isnan(sum(det_win)) % no sink detected or no layer data (nan)
        peakout(iTrial)        = NaN;
        latencyout(iTrial)     = NaN;
        rmsout(iTrial)         = NaN;
        onsetout               = NaN;
        offsetout              = NaN;
    else
        [pks, locs, ~, p] = findpeaks(det_win); % p = prominence
        [str, maxInd]=max(p); %which peak is most prominent

        % Peak Prominence check
        if str < 0.0003 %arbitrary threshold throwing out non-prominent peaks
            peakout(iTrial)    = NaN;
            latencyout(iTrial) = NaN;
            onsetout           = NaN;
            offsetout          = NaN;
        elseif isempty(str) % this would mean the data is a straight line
            peakout(iTrial)    = NaN;
            latencyout(iTrial) = NaN;
            onsetout           = NaN;
            offsetout          = NaN;
        else % peak is there and strong enough
            peakout(iTrial)    = pks(maxInd);
            latencyout(iTrial) = locs(maxInd);
            % take onset and offset around prominent peak
            if sum(onsets < (det_off-det_on)) == 0 ...% no threshold crosses in the window
                || latencyout(iTrial) < onsets(1) ...% threshold cross only after peak
                || latencyout(iTrial) > offsets(end) % threshold cross only before peak
                onsetout(iTrial)  = NaN;
                offsetout(iTrial) = NaN;
            else
                onsets            = onsets(onsets <= latencyout(iTrial));
                offsets           = offsets(offsets >= latencyout(iTrial));
                if latencyout(iTrial) < 5 % we made the first 5 BL 
                    onsets = latencyout(iTrial);
                end
                onsetout(iTrial)  = onsets(end);
                offsetout(iTrial) = offsets(1);
            end
        end
        % take RMS regardless
        rmsout(iTrial)         = rms(det_win(det_win > 0));
    end
end