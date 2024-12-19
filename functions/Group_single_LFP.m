function Group_single_LFP(homedir, Group, folder, Condition, c_axis, ncolumn)

% figure order matters here
close all

run([Group '.m'])
subjects = length(animals);
nrows = ceil(subjects/ncolumn); % four columns

cd(homedir); cd figures; cd(['Single_' folder])

figure(1)
targetfig = tiledlayout(nrows,ncolumn);
title(targetfig,['Individual ' Group ' ' Condition(1:end-2) ...
    ' ' Condition(end-1:end) ' dB LFPs'])
xlabel(targetfig, 'time [ms]')
ylabel(targetfig, 'depth [channels]')
colormap jet

for iA = 1:subjects

    name = animals{iA}; %#ok<*IDISVAR>
    figname = [name '_' Condition '_LFP.fig'];
    
    if ~exist(figname,'file')
        continue
    end

    % open the figure and scoop the contents
    openfig([name '_' Condition '_LFP.fig']);
    pause(1)
    handles = imhandles(gca);
    data_goal = handles.CData;
 

    figure(1); nexttile(iA)
    imagesc(data_goal,c_axis)
    title(name)
    xlim([300 900])
    xticks(     [400 600 800 1000 1200 1400 2400])
    xticklabels([0   200 400 600  800  1000 2000])
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

exportgraphics(targetfig,['Single_' Group '_' Condition '_LFPs.png'])
close; cd(homedir)