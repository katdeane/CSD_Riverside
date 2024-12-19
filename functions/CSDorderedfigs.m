function CSDorderedfigs(homedir, Group, Condition,thisylim,whichstudy)

% figure order matters here
close all

if matches(whichstudy,'FVB')
    grpname = fvbgroupname(Group);
else 
    grpname = Group;
end

% set some things straight for naming convention
if contains(Condition,'70')
    dB = '70';
elseif contains(Condition,'80')
    dB = '80';
end

if ~exist('dB','var')
    dB = 'no';
end

% make some decisions for plotting
if contains(Condition,'ClickTrain')
    condname = 'ASSR';
    keeplabel = 1;
    thisxlim = [300 2500];
    thisxtick = 400:400:2400;
    thisxtlab = 0:400:2000;
elseif contains(Condition,'gapASSR')
    condname = 'gap ASSR';
    keeplabel = 1;
    thisxlim = [2550 3000];
    thisxtick = 2650:100:3000;
    thisxtlab = 0:100:400;
elseif contains(Condition,'Chirp')
    condname = 'Chirp';
    keeplabel = 0;
    thisxlim = [300 3400];
    thisxtick = 400:400:3400;
    thisxtlab = 0:400:3000;
elseif contains(Condition,'NoiseBurst')
    condname = 'NoiseBurst';
    keeplabel = 0;
    thisxlim = [300 900];
    thisxtick = 400:200:900;
    thisxtlab = 0:200:700;
elseif contains(Condition,'Spontaneous')
    condname = 'Spontaneous';
    keeplabel = 0;
    thisxlim = [0 2000];
    thisxtick = 0:500:2000;
    thisxtlab = 0:500:2000;
end

cd(homedir); cd figures; cd Average_CSD

% open the figure and scoop the contents
openfig([Group ' Avg CSD to ' Condition '.fig']);
pause(1)
h = gca;

% change the title
if matches(dB,'no')
    h.Parent.Title.String = [grpname ' ' condname ' CSD'];
else
    h.Parent.Title.String = [grpname ' ' condname ' at ' dB 'dB CSD'];
end
% discard the label maybe
if keeplabel == 0
    h.Title.String = []; % this is only done in cases of single images anyway
end


% final asthetics
if keeplabel == 1
    set(gcf,'Position',[100 100 800 800])
    for iAx = 1:size(h.Parent.Children,1)/2
        h.Parent.Children(iAx*2).XLim = thisxlim;
        h.Parent.Children(iAx*2).XTick = thisxtick;
        h.Parent.Children(iAx*2).XTickLabel = thisxtlab;
        h.Parent.Children(iAx*2).YLim = thisylim;
    end
else % this is only done in cases of single images
    h.Title.String = []; 
    xlim(thisxlim)
    xticks(thisxtick)
    xticklabels(thisxtlab)
    ylim(thisylim)
    set(gcf,'Position',[100 100 650 500])
end

exportgraphics(gcf,[Group ' Avg CSD to ' Condition '.png'])
close; cd(homedir)