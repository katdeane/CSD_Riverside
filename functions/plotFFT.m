function plotFFT(homedir,params,Condition)

cd(homedir); cd output; cd FFT
loadname = [params.groups{1} 'v' params.groups{2} '_FFT.mat'];
load(loadname,'fftStruct')
fftTab = struct2table(fftStruct); 
clear fftStruct % kat, just save it as a table in the other script

% for plotting
Fs = 1000; % Sampling frequency
try % sorry
    L  = length(fftTab.fft{1}); % Length of signal [ms]
catch
    L  = size(fftTab.fft,2); % Length of signal [ms]
end

if matches(Condition, 'Pupcall')
    % get rid of the shorter trials subject (VMP02 has 20 trials)
    toDelete = matches(fftTab.animal,'VMP02');
    fftTab(toDelete,:) = [];
end

cd (homedir); cd figures;
if ~exist('FFTfig','dir')
    mkdir('FFTfig');
end
cd FFTfig

FFTfig = tiledlayout('flow');
title(FFTfig,[Condition ' FFT'])
xlabel(FFTfig, 'f (Hz)')
ylabel(FFTfig, 'Power')

for iLay = 1:length(params.layers)
    
    layTab = fftTab(matches(fftTab.layer,params.layers{iLay}),:);

    % get both groups
    grp1 = layTab.fft(matches(layTab.group,params.groups{1}),:);
    grp2 = layTab.fft(matches(layTab.group,params.groups{2}),:);

    % divide KO (grp2) by WT (grp1) 
    try
        grp1m   = mean(vertcat(grp1{:}),1);
        grp2m   = mean(vertcat(grp2{:}),1);
    catch
        grp1m   = mean(grp1,1);
        grp2m   = mean(grp2,1);
    end

    ratioWT = grp2m ./ grp1m; 
    

    % gaussian filter for visualization
    grp1g   = imgaussfilt(grp1m,10);
    grp2g   = imgaussfilt(grp2m,10);
    ratioWT = imgaussfilt(ratioWT,10);
    
    % plot
    nexttile 
    plot(Fs/L*(0:L-1),grp1g,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)

    nexttile 
    plot(Fs/L*(0:L-1),grp2g,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2}])
    xlim([0 100])
    xticks(0:10:100)

    nexttile 
    plot(Fs/L*(0:L-1),ratioWT,'-')
    title(['Layer ' params.layers{iLay} ' ' params.groups{2} '/' params.groups{1}])
    xlim([0 100])
    xticks(0:10:100)
    hold on 
    line('XData', [0 100], 'YData', [1 1])
    hold off

    % sum data from freq bins to make bar graph so simple so clean
    
end

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_FFT'];
savefig(gcf,savename)
close
cd(homedir)