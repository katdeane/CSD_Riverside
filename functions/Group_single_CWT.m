function Group_single_CWT(homedir, figfolder, Group, Condition, c_axis)

% set some parameters 
if contains(Condition,'NoiseBurst')
    thisxlim = [300 900];
    addon = '70';
elseif matches(Condition, 'Spontaneous')
    thisxlim = [1 2000];
elseif matches(Condition,'ShortCall')
    thisxlim = [300 4400];
elseif matches(Condition,'ClickTrain')
    thisxlim = [300 2300];
    addon = '40';
else
    error('assign this condition xlim please, line 9')
end

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
layername = {'I' 'II-IV' 'Va' 'Vb' 'VI'};

% figure order matters here
close all

run([Group '.m'])
subjects = length(animals);
ncolumn = subjects;
nrows = 5; 

cd(figfolder); cd Single_CWT

figure(1)
targetfig = tiledlayout(nrows,ncolumn);
title(targetfig,['Individual ' Group ' ' Condition(1:end-2) ...
    ' ' Condition(end-1:end) ' ITPC'])
xlabel(targetfig, 'time [ms]')
ylabel(targetfig, 'freq [Hz]')
colormap('default')

for iL = 1:length(layers)
    for iA = 1:subjects

        name = animals{iA}; %#ok<*IDISVAR>

        % open the figure and scoop the contents
        openfig(['Phase ' name ' ' Condition ' ' addon ' ' layers{iL} '.fig']);
        pause(1)
        handles = imhandles(gca);
        data_goal = handles.CData;


        figure(1); nexttile
        imagesc(data_goal,c_axis)
        if iL == 1
            title(name)
        end
        xlim(thisxlim)
        xticks(     [400 600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000 4200 4400])
        xticklabels([0   200 400 600  800  1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000])
        set(gca,'Ydir','normal')
        % y tick labels on far left
        yticks([0 8 16 21 24 26 29 32 35])
        yticklabels({'0','10','20','30','40','50','60','80','100'})
        if iA == 1
            ylabel(layername{iL})
        end

        figure(2)
        close
        clear handles data_goal
    end
end

% final asthetics
h = axes(targetfig,'visible','off');
colorbar(h,'Position',[0.93 0.33 0.012 0.33]);  % attach colorbar to h
clim(h,c_axis); 
set(gcf,'Position',[100 100 1500 1050])

exportgraphics(targetfig,['Single_' Group '_' Condition '_CSDs.pdf'])
exportgraphics(targetfig,['Single_' Group '_' Condition '_CSDs.png'])
close; cd(homedir)