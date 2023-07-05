function AvgCSDfig(homedir, Group, Stimtype)
%% Averaged CSD

% The purpose of this script is to provide an averaged CSD for visual
% representation of each analysis group.

%Input:     datastructs\ *.mat
%Output:    \figures\AvgCSDs; figures only for representation of
%           characteristic profile
cd(homedir);

%% Load in info
cd datastructs
input = dir([Group '*.mat']);
entries = length(input);


% preallocate csd holders
CSD2hz  = NaN(chanlength,timeaxis,subjects);
CSD5hz  = CSD2hz;
CSD10hz = CSD2hz;
CSD20hz = CSD2hz;
CSD40hz = CSD2hz;

% count variables to keep our insertions orderly:
count = 1;

for iEnt = 1:entries
    
    % load the animal data in
    load(input(iEnt).name,'Data')
    
    index = strcmp({Data.ClickFreq}, freqlist{1})==1;
    thisFreq = Data(index).CSD;
    CurCSD2  = preAvgCSD(thisFreq,timeaxis); % func averages all measurements in the cell array        

    index = strcmp({Data.ClickFreq}, freqlist{2})==1;
    thisFreq = Data(index).CSD;
    CurCSD5  = preAvgCSD(thisFreq,timeaxis);

    index = strcmp({Data.ClickFreq}, freqlist{3})==1;
    thisFreq = Data(index).CSD;
    CurCSD10 = preAvgCSD(thisFreq,timeaxis); 

    index = strcmp({Data.ClickFreq}, freqlist{4})==1;
    thisFreq = Data(index).CSD;
    CurCSD20 = preAvgCSD(thisFreq,timeaxis);

    index = strcmp({Data.ClickFreq}, freqlist{5})==1;
    thisFreq = Data(index).CSD;
    CurCSD40 = preAvgCSD(thisFreq,timeaxis);

    % add the current data to the preallocated containers
    CSD2hz(1:size(CurCSD2,1),1:size(CurCSD2,2),count)    = CurCSD2;
    CSD5hz(1:size(CurCSD5,1),1:size(CurCSD5,2),count)    = CurCSD5;
    CSD10hz(1:size(CurCSD10,1),1:size(CurCSD10,2),count) = CurCSD10;
    CSD20hz(1:size(CurCSD20,1),1:size(CurCSD20,2),count) = CurCSD20;
    CSD40hz(1:size(CurCSD40,1),1:size(CurCSD40,2),count) = CurCSD40;
    count = count + 1;
end

CSD2hz = nanmean(CSD2hz,3);
CSD5hz = nanmean(CSD5hz,3);
CSD10hz = nanmean(CSD10hz,3);
CSD20hz = nanmean(CSD20hz,3);
CSD40hz = nanmean(CSD40hz,3);

% produce CSD figure
figure('Name',[grouptype ' Average CSD'])

subplot(231)
imagesc(CSD2hz)
caxis([-0.0005 0.0005])
colormap('jet')
title([freqlist{1} ' Click'])

subplot(232)
imagesc(CSD5hz)
caxis([-0.0005 0.0005])
colormap('jet')
title([freqlist{2} ' Click'])

subplot(233)
imagesc(CSD10hz)
caxis([-0.0005 0.0005])
colormap('jet')
title([freqlist{3} ' Click'])

subplot(234)
imagesc(CSD20hz)
caxis([-0.0005 0.0005])
colormap('jet')
title([freqlist{4} ' Click'])

subplot(235)
imagesc(CSD40hz)
caxis([-0.0005 0.0005])
colormap('jet')
title([freqlist{5} ' Click'])
colorbar

sgtitle([grouptype ' Average CSD'])

cd(homedir)
if exist([figfolder '\Average_CSD'],'dir')
    cd(figfolder), cd Average_CSD;
else
    cd(figfolder), mkdir Average_CSD, cd Average_CSD;
end

h = gcf;
set(h, 'PaperType', 'A4');
set(h, 'PaperOrientation', 'landscape');
set(h, 'PaperUnits', 'centimeters');
savefig(h,[grouptype ' Average CSD'],'compact')
close (h)

cd(homedir)
end