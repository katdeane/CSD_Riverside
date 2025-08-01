function Group_single_CSD(homedir, Group, folder, Condition, c_axis, ncolumn)

% set some parameters 
if contains(Condition,'NoiseBurst')
    thisxlim = [300 900];
elseif matches(Condition,'ShortCall')
    thisxlim = [300 4400];
else
    error('assign this condition xlim please, line 9')
end

% figure order matters here
close all

run([Group '.m'])
subjects = length(animals);
nrows = ceil(subjects/ncolumn); % four columns

cd(homedir); cd figures; cd(['Single_' folder])

figure(1)
targetfig = tiledlayout(nrows,ncolumn);
title(targetfig,['Individual ' Group ' ' Condition(1:end-2) ...
    ' ' Condition(end-1:end) ' dB CSDs'])
xlabel(targetfig, 'time [ms]')
ylabel(targetfig, 'depth [channels]')
colormap jet

for iA = 1:subjects

    name = animals{iA}; %#ok<*IDISVAR>
    % this will ALWAYS take just the LAST measurment for the subject if
    % there are multiple
    measurement = Cond.(Condition){iA}{end};
    if isempty(measurement)
        continue
    end

    % open the figure and scoop the contents
    openfig([name '_' measurement '_CSD.fig']);
    pause(1)
    handles = imhandles(gca);
    data_goal = handles.CData;
 

    figure(1); nexttile(iA)
    imagesc(data_goal,c_axis)
    title(name)
    xlim(thisxlim)
    xticks(     [400 600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000 4200 4400])
    xticklabels([0   200 400 600  800  1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000])
    yticks([5 10 15 20]) % just to keep it consistent
     
    figure(2)
    close
    clear handles data_goal
end

% final asthetics
h = axes(targetfig,'visible','off');
colorbar(h,'Position',[0.93 0.33 0.012 0.33]);  % attach colorbar to h
clim(h,c_axis); 
set(gcf,'Position',[100 100 850 550])

exportgraphics(targetfig,['Single_' Group '_' Condition '_CSDs.pdf'])
exportgraphics(targetfig,['Single_' Group '_' Condition '_CSDs.png'])
close; cd(homedir)