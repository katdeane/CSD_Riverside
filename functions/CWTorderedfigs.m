function CWTorderedfigs(homedir, Groups, Condition, c_axisind, c_axiscomp)

% figure order matters here
close all

% set some things straight for naming convention
layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
if contains(Condition,'70') 
    grp1 = 'Old 70';
elseif contains(Condition,'80')
    grp1 = 'Old 80';
end
grp2 = 'Young 70';
% make some decisions for plotting
if contains(Condition,'ClickTrain')
    condname = 'ASSR 40 Hz';
    tidbit = ' 40Hz ';
    thisxlim = [300 2500];
    thisxtick = 400:400:2400;
    thisxtlab = 0:400:2000;
elseif contains(Condition,'gapASSR')
    condname = 'ASSR 9 ms gaps';
    tidbit = ' 9 [ms] gap width ';
    thisxlim = [2550 3000];
    thisxtick = 2650:100:3000;
    thisxtlab = 0:100:400;
elseif contains(Condition,'Chirp')
    condname = Condition(1:end-2);
    tidbit = ' 1 ';
    thisxlim = [300 3400];
    thisxtick = 400:400:3400;
    thisxtlab = 0:400:3000;
elseif contains(Condition,'NoiseBurst')
    condname = 'NoiseBurst';
    tidbit = ' 70dB ';
    thisxlim = [300 900];
    thisxtick = 400:200:900;
    thisxtlab = 0:200:700;
end
count = 1;
cd(homedir); cd figures; cd CWT

figure(1)
targetfig = tiledlayout(5,3); % 5 layers x YNG OLD Y-O
title(targetfig,[condname ' ITPC'])
xlabel(targetfig, 'time [ms]')
ylabel(targetfig, 'layers')

for iLay = 1:length(layers)

    if matches(layers{iLay},'II')
        thislay = 'I';
    else
        thislay = layers{iLay};
    end

    % open the figure and scoop the contents
    openfig([Groups '_Observed Phase ' Condition tidbit layers{iLay} '.fig']);
    pause(1)
    h = gca;

    % young
    handles = imhandles(h.Parent.Children(4));
    data_goal = handles.CData;
    figure(1); nexttile(count)
    imagesc(data_goal,c_axisind)
    set(gca,'Ydir','normal')
    % y tick labels on far left
    yticks([0 8 16 21 24 26 29 32 35])
    yticklabels({'0','10','20','30','40','50','60','80','100'})
    ylabel(thislay)
    % x tick labels on bottom
    xlim(thisxlim)
    xticks(thisxtick)
    xticklabels([])
    if matches(layers{iLay},'II')
        title(grp2)
    elseif matches(layers{iLay},'VI')
        % -400 so 0 is always stim onset
        xticklabels(thisxtlab)
    end
    count = count+1;

    % old
    handles = imhandles(h.Parent.Children(6));
    data_goal = handles.CData;
    figure(1); nexttile(count)
    imagesc(data_goal,c_axisind)
    set(gca,'Ydir','normal')
    % y tick labels on far left
    yticks([0 8 16 21 24 26 29 32 35])
    yticklabels([])
    % x tick labels on bottom
    xlim(thisxlim)
    xticks(thisxtick)
    xticklabels([])
    if matches(layers{iLay},'II')
        title(grp1)
    elseif matches(layers{iLay},'VI')
        % -400 so 0 is always stim onset
        xticklabels(thisxtlab)
    end
    count = count+1;

    % young - old
    handles = imhandles(h.Parent.Children(2));
    data_goal = handles.CData;
    figure(1); nexttile(count)
    imagesc(data_goal,c_axiscomp)
    % replot all of the lines for areas of significance! 
    hold on
    for iline = 1:length(h.Parent.Children(2).Children)-1
        thisx = h.Parent.Children(2).Children(iline).XData;
        thisy = h.Parent.Children(2).Children(iline).YData;
        plot(thisx,thisy,'color','k')
    end
    % y tick labels on far left
    yticks([])
    yticklabels([])
    % x tick labels on bottom
    xlim(thisxlim)
    xticks(thisxtick)
    xticklabels([])
    if matches(layers{iLay},'II')
        title([grp2(1:end-3) ' - ' grp1(1:end-3)])
    elseif matches(layers{iLay},'VI')
        % -400 so 0 is always stim onset
        xticklabels(thisxtlab)
    end
    count = count+1;

    figure(2)
    close
    clear handles data_goal
end

% final asthetics
j = axes(targetfig,'visible','off');
colorbar(j,'Position',[0.93 0.4 0.012 0.2]);  % attach colorbar
clim(j,c_axiscomp); 
k = axes(targetfig,'visible','off');
colorbar(k,'Position',[0.63 0.4 0.012 0.2]);  % attach colorbar
clim(k,c_axisind); 
set(gcf,'Position',[100 100 700 800])

exportgraphics(targetfig,[Groups '_Observed Phase ' Condition tidbit 'all.png'])
close; cd(homedir)