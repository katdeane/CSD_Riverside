
% for function
Group = 'MWT';
iSub = 1;
subname = 'MWT01';
Condition = 'NoiseBurst';
measurement = '01';
datafile = [subname '_' measurement];

fs = 1000; % Hz

%% load the data
run([Group '.m'])
load([subname '_Data'],'Data')
load([subname '_SpikeData'],'SpikeData')

% get the correct file from both
for iIdx = 1:length({Data.measurement})
    if isempty(Data(iIdx).measurement)
        continue
    end
    match = matches([datafile '_LFP'],Data(iIdx).measurement);
    if match == 1
        break
    end
end
lfpidx = iIdx;

for iIdx = 1:length({SpikeData.measurement})
    if isempty(SpikeData(iIdx).measurement)
        continue
    end
    match = matches([datafile '_Spikes'],SpikeData(iIdx).measurement);
    if match == 1
        break
    end
end
spikeidx = iIdx;

%% 50 trials of 1500 ms at fs = 1000 Hz. Stim onset at 400 ms. 
LFP    = Data(lfpidx).sngtrlLFP;
Spikes = SpikeData(spikeidx).SortedSpikes;

% we're taking out on layer from 70 dB right now
LFP    = LFP{1, 6};
Spikes = Spikes{1,6};

iLay = 1; 

% pull out center channel of layer
L.IV   = str2num(Layer.IV{iSub});
IVchan = L.IV(floor(length(L.IV)/2));

LFPchan = squeeze(LFP(IVchan,:,:));
SPKchan = squeeze(Spikes(IVchan,:,:));

timeaxis = size(LFPchan,1);
%% Visual inspection 

figure;
plot(sum(SPKchan,2)*10)
hold on
plot(mean(LFPchan,2),'Linewidth',2)

title([subname ' ' Condition ' mean(LFP) and sum(spikes) in Layer ' Layer{iLay}])
xlabel('Time [ms]')
ylabel('mV & sum*10')

% fft it (single-sided) (from matlab's fft documentation)
LFPfft = fft(mean(LFPchan,2));
P2 = abs(LFPfft/timeaxis); % P2 is two sided spectrum
P1 = P2(1:timeaxis/2+1); % P1 is one sided spectrum
P1(2:end-1) = 2*P1(2:end-1);

f = fs/timeaxis*(0:(timeaxis/2));
plot(f,P1,"LineWidth",3) 
xlim([0 100])
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

cd(homedir); cd figures
if exist('Spikes_LFP_visualization','dir') == 0
    mkdir('Spikes_LFP_visualization')
end
cd Spikes_LFP_visualization

h = gcf;
savefig(h,[subname ' ' Condition ' mean(LFP) and sum(spikes) in Layer ' Layer{iLay}],'compact')
close (h)

%% Spike Triggered Average
% The spike-triggered average (STA) visualizes the relation between the LFP
% and spiking data. Organize the field activity around the spikes

win = 100; % window to examine around each spike

STA = igetSTA(win,LFPchan,SPKchan,subname,Condition,Layer{iLay});

%% Field Triggered Average
% The field triggered average (FTA) organizes the activity of the spikes 
% around the phase of the field data

% choosing the bandpass window (Wn) is a challenge. Right now, we'll choose
% a window containing the max spectrum energy in the fft of the LFPchan
% data above. We might consider picking a specific band later.
WnCenter = find(P1==max(P1));
Wn = [WnCenter-1 WnCenter+1];

[FTA, phi_axis] = igetFTA(LFPchan,SPKchan,timeaxis,Wn);

%% Spike-Field Coherence

% actually quite stuck on this point

SYY = zeros(timeaxis,1); % Variable to store field spectrum.
SNN = zeros(timeaxis,1); % Variable to store spike spectrum.
SYN = zeros(timeaxis,1); % Variable to store cross spectrum.

ntrials = size(LFPchan,2);

for itri = 1:ntrials                                  
    LFPchanFFT = fft((LFPchan(:,itri)-mean(LFPchan(:,itri))) .* hanning(timeaxis));  % Hanning taper the field,
    SPKchanFFT = fft((SPKchan(:,itri)-mean(SPKchan(:,itri))));                       % but do not taper the spikes.
    SYY = SYY + real( LFPchanFFT .* conj(LFPchanFFT) )/ntrials; % Field spectrum
    SNN = SNN + real( SPKchanFFT .* conj(SPKchanFFT) )/ntrials; % Spike spectrum
    SYN = SYN + ( LFPchanFFT .* conj(SPKchanFFT) )/ntrials;     % Cross spectrum
end
cohr = abs(SYN) ./ sqrt(SYY) ./ sqrt(SNN); % Coherence

% f = rfftfreq(N, dt)                                    % Frequency axis for plotting

PSTHfig = tiledlayout('flow');
title('Spike LFP Coherence')
xlabel('Frequency [Hz]')

nexttile % Plot the spike spectrum.
plot(abs(SNN))
title('Spike Spectrum')
xlim([0, 100])
xlabel('Frequency [Hz]')
ylabel('Power [Hz]')

nexttile         % Plot the field spectrum,
% T = t[-1]
plot(mean(abs(SYY),2))        % with the standard scaling.
xlim([0, 100])
xlabel('Frequency [Hz]')
ylabel('Power [Hz]')
title('Field Spectrum')

nexttile       % Plot the coherence
plot(mean(cohr,2))
xlim([0, 100])
ylim([0, 1])
xlabel('Frequency [Hz]')
ylabel('Coherence');
title('Spike LFP Coherence')

% save fig for review
cd(homedir); cd figures; cd Spikes_LFP_visualization
h = gcf;
savefig(h,[subname ' ' Condition ' Spike LFP Coherence ' Lay],'compact')
close (h)



