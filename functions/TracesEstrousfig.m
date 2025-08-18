function TracesEstrousfig(homedir, Condition)

% figure order matters here
close all

y7color = [255/255 120/255 0/255];
o7color = [51/255  241/255 255/255];
o8color = [46/255  50/255  186/255];

% set some things straight for naming convention
layers = {'All' 'II' 'IV' 'Va' 'Vb' 'VI'};

% make some decisions for plotting
if contains(Condition,'ClickTrain')
    condname  = 'ASSR';
    thisxlim  = [300 2500];
    thisxtick = 400:400:2400;
    thisxtlab = 0:400:2000;
    thischild = [3 4];
    thisstim  = {'40 Hz' '10 Hz'};
elseif contains(Condition,'gapASSR')
    condname  = 'gap ASSR';
    thisxlim  = [2550 3000];
    thisxtick = 2650:100:3000;
    thisxtlab = 0:100:400;
    thischild = [1 2 3 4];
    thisstim  = {'9 ms' '7 ms' '5 ms' '3 ms'};
elseif contains(Condition,'Chirp')
    condname  = Condition(1:end-2);
    thisxlim  = [300 3400];
    thisxtick = 400:400:3400;
    thisxtlab = 0:400:3000;
    thischild = 1;
    thisstim  = {'1'};
elseif contains(Condition,'NoiseBurst')
    condname  = 'NoiseBurst';
    thisxlim  = [300 900];
    thisxtick = 400:200:900;
    thisxtlab = 0:200:700;
    thischild = 1;
    thisstim  = {'1'};
end
cd(homedir); cd figures; cd Group_Avrec

for iStim = 1:length(thisstim)
    figure(1)
    targetfig = tiledlayout(length(layers),1); % 5 layers
    if length(thisstim) > 1
        title(targetfig,[condname ' ' thisstim{iStim} ' Traces'])
    else
        title(targetfig,[condname ' Traces'])
    end
    xlabel(targetfig, 'time [ms]')
    ylabel(targetfig, 'layers')

    for iLay = 1:length(layers)

        if matches(layers{iLay},'II')
            thislay = 'I';
        elseif matches(layers{iLay},'All')
            thislay = 'AVREC';
        else
            thislay = layers{iLay};
        end

        % open the figure and scoop the contents
        % DIE
        openfig(['DIE_CSDTraces_' Condition '_' layers{iLay} '.fig']);
        pause(1)
        h = gca;

        patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
        patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
        liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

        figure(1); nexttile(iLay)
        patch(patchx,patchy,y7color,'facealpha',0.2,'edgecolor','none')
        hold on
        plot(liney,'Color',y7color,'LineWidth',2)

        figure(2)
        close

        % PRO
        openfig(['PRO_CSDTraces_' Condition '_' layers{iLay} '.fig']);
        pause(1)
        h = gca;

        patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
        patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
        liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

        figure(1); nexttile(iLay)
        patch(patchx,patchy,o7color,'facealpha',0.2,'edgecolor','none')
        plot(liney,'Color',o7color,'LineWidth',2)

        figure(2)
        close

        % Male
        openfig(['FYM_CSDTraces_' Condition '_' layers{iLay} '.fig']);
        pause(1)
        h = gca;

        patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
        patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
        liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

        figure(1); nexttile(iLay)
        patch(patchx,patchy,o8color,'facealpha',0.2,'edgecolor','none')
        plot(liney,'Color',o8color,'LineWidth',2)

        % x tick labels on bottom
        xlim(thisxlim)
        xticks(thisxtick)
        xticklabels([])
        if matches(layers{iLay},'All')
            legend('', 'Diestrus', '', 'Prosestrus', '', 'Male')
        elseif matches(layers{iLay},'VI')
            % -400 so 0 is always stim onset
            xticklabels(thisxtlab)
        end
        ylabel(thislay)

        figure(2)
        close
    end

    % final asthetics
    set(gcf,'Position',[100 100 600 700])

    exportgraphics(targetfig,['Estrous_TrioTraces_' Condition(1:end-2) '_' thisstim{iStim} '.png'])
    close;
end
cd(homedir)