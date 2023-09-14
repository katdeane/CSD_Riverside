function plotFFT(homedir,params)

cd(homedir); cd output; cd FFT
load('FFT.mat','fftStruct')
fftTab = struct2table(fftStruct); 
clear fftStruct % kat, just save it as a table in the other script

% for plotting
Fs = 1000;            % Sampling frequency
L = 120000;           % Length of signal [ms]

cd (homedir); cd figures;
if ~exist('FFTfig','dir')
    mkdir('FFTfig');
end
cd FFTfig

FFTfig = tiledlayout('flow');
title(FFTfig,'Spontaneous FFT')
xlabel(FFTfig, 'f (Hz)')
ylabel(FFTfig, 'Power')

for iLay = 1:length(params.layers)
    
    layTab = fftTab(matches(fftTab.layer,params.layers{iLay}),:);

    % get both groups
    grp1 = layTab.fft(matches(layTab.group,params.groups{1}),:);
    grp2 = layTab.fft(matches(layTab.group,params.groups{2}),:);

    % divide KO (grp2) by WT (grp1) 
    ratioWT = mean(grp2,1) ./ mean(grp1,1); 
    ratioWT = imgaussfilt(ratioWT,10);

    % plot
    nexttile 
    plot(Fs/L*(0:L-1),ratioWT,'-')
    title(['Layer ' params.layers{iLay}])
    ylabel("ratio of WT")
    xlim([0 100])
    hold on 
    line('XData', [0 100], 'YData', [1 1])
    hold off

    % sum data from freq bins to make bar graph so simple so clean
    
end

savefig(gcf,'Spontaneous FFT')
close
cd(homedir)