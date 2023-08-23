function CF_CSD(homedir,file,chanList,metafile)

% some standardized choices selected ahead of time for CF recording
levelList = [60,50,40,30,20,10];
toneList  = [2000,4000,8000,16000,24000,32000];
BL        = 399;
stimDur   = 200;
stimITI   = 800;

[StimIn, DataIn] = FileReaderLFP(file,chanList);

% out in sngtrlLFP(levels,tones)
sngtrlLFP = icutCFdata(StimIn, DataIn, levelList, toneList, ...
    BL, stimDur, stimITI, metafile);

clear DataIn StimIn % these are too big to keep around

% out in sngtrlCSD(levels,tones)
[sngtrlCSD] = cfCSDgen(sngtrlLFP,BL);

%% Plotting CSDs
disp('Plotting CSD')

cd (homedir); cd figures;
if ~exist(['CF_' file(1:5)],'dir')
    mkdir(['CF_' file(1:5)]);
end
cd (['CF_' file(1:5)])

CSDfig = tiledlayout(size(sngtrlCSD,1),size(sngtrlCSD,2));
title(CSDfig,[file(1:5) ' CSDs ' ...
    file(7:8)])
xlabel(CSDfig, 'time [ms]')
ylabel(CSDfig, 'depth [channels]')

for iA = 1:size(sngtrlCSD,1)
    for iB = 1:size(sngtrlCSD,2)
        nexttile
        imagesc(mean(sngtrlCSD{iA,iB},3))
        title([num2str(toneList(iB)/1000) ' kHz ' num2str((90-levelList(iA))) ' dB'])
        colormap jet
        caxis([-0.2 0.2])
    end
end

colorbar
h = gcf;
savefig(h,[file(1:8) 'CF_CSD' ],'compact')
close (h)

%% tuning curves 

peakdata = NaN(size(sngtrlCSD,1),size(sngtrlCSD,2));
for iA = 1:size(sngtrlCSD,1)
    for iB = 1:size(sngtrlCSD,2)
        
        % get the peak of the avrec 
        avrec = mean(mean(abs(sngtrlCSD{iA,iB}),3),1);
        peakdata(iA,iB) = max(avrec(BL:BL+100));

    end
end

[row,col] = find(peakdata == max(max(peakdata)));

tuningfig = tiledlayout('flow');
title(tuningfig,[file(1:5) ' tuning curves ' ...
    file(7:8) ' CF is ' num2str(toneList(col)) ' Hz ' num2str(levelList(row))])
xlabel(tuningfig, 'time [ms]')
ylabel(tuningfig, 'Peak [mm/mV²]')

for iA = 1:size(peakdata,1)
    nexttile
    plot(peakdata(iA,:))
    title([num2str((90-levelList(iA))) ' dB'])
    xticks(1:1:length(toneList))
    xticklabels(toneList)
    linkaxes
end




