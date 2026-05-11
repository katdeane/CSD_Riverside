function filteredLfp = LineNoiseNotch(sngtrlLFP)

%% load and visualize original data
% data structure is channel x time x trials (22x1400x50)


%% set up notch filter 

%create variables (replace with true values)
fs = 1000; % Sampling frequency (Kz)
notchFreq = 60; % Hz
bandwidth = 4; %(ex. 59-61 Hz)

norm_notch = notchFreq / (fs/2); % Normalized cutoff frequency
norm_bw    = bandwidth / (fs/2);

% notch filter design
[b, a] = iirnotch(norm_notch, norm_bw);

%% apply filter to the whole signal, array by array

filteredLfp = cell(size(sngtrlLFP,1),size(sngtrlLFP,2));
for isheet = 1:length(filteredLfp)
    thisLfp = nan(size(sngtrlLFP{isheet},1),size(sngtrlLFP{isheet},2),size(sngtrlLFP{isheet},3));
    for ichan = 1:size(thisLfp,1)
        for itrial = 1:size(thisLfp,3)
            thisLfp(ichan,:,itrial) = filtfilt(b, a, sngtrlLFP{isheet}(ichan,:,itrial));
        end
    end
    filteredLfp{isheet} = thisLfp;
end

%% figure out to verify 
% tiledlayout('flow');
% 
% % plot the filter:
% [H, f] = freqz(b, a, 4096, fs);
% 
% nexttile
% plot(f, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
% xline(58, '--r', '58 Hz', 'LabelVerticalAlignment', 'bottom');
% xline(60, '--k', '60 Hz', 'LabelVerticalAlignment', 'bottom');
% xline(62, '--r', '62 Hz', 'LabelVerticalAlignment', 'bottom');
% xlim([0 fs/2]);
% ylim([-60 5]);
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');
% title('Notch Filter Frequency Response — Magnitude');
% grid on;
% 
% nexttile
% plot(f, angle(H) * 180/pi, 'b', 'LineWidth', 1.5);
% xline(60, '--k', '60 Hz');
% xlim([0 fs/2]);
% xlabel('Frequency (Hz)');
% ylabel('Phase (degrees)');
% title('Notch Filter Frequency Response — Phase');
% grid on;
%
% nexttile
% imagesc(nanmean(sngtrlLFP{:},3))
% colormap jet
% nexttile
% imagesc((nanmean(filteredLfp,3)))
% colormap jet
% 
% %% run a fast fourier transform to verify
% 
% % if the data looks basically the same before and after the notch filter
% % (which it should), then we should verify with an fft and by plotting the
% % power spectrum density. 
% 
% % original FFT
% meanOrigSig = nanmean(sngtrlLFP{:},3);
% fftlfp = fft(meanOrigSig(10,:)); %one channel of the filtered csd data (every channel should show the notch)
% fftlfp = squeeze(abs(fftlfp) .^2);% take power
% fftcsdAB = fftlfp ./ (size(sngtrlLFP,2)/2); % normalize by half sampling points
% 
% L = length(fftlfp);
% fftaxis = (fs/L)*(0:L-1);
% 
% nexttile 
% semilogy(fftaxis,fftcsdAB)
% xlim([0 100]) 
% xticks(0:10:100)
% ax = gca;
% ax.XScale = 'log';
% 
% % filtered FFT
% meanFiltSig = nanmean(filteredLfp,3);
% fftlfp = fft(meanFiltSig(10,:)); %one channel of the filtered csd data (every channel should show the notch)
% fftlfp = squeeze(abs(fftlfp) .^2);% take power
% fftcsdAB = fftlfp ./ (size(sngtrlLFP,2)/2); % normalize by half sampling points
% 
% L = length(fftlfp);
% fftaxis = (fs/L)*(0:L-1);
% 
% nexttile 
% semilogy(fftaxis,fftcsdAB)
% xlim([0 100]) 
% xticks(0:10:100)
% ax = gca;
% ax.XScale = 'log';
% 
% close


