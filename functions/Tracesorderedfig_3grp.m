function Tracesorderedfig_3grp(homedir, Groups, Condition,whichstudy)

% figure order matters here
close all

if matches(whichstudy,'FVB')
    grp1 = fvbgroupname(Groups{1});
    grp2 = fvbgroupname(Groups{2});
    grp3 = fvbgroupname(Groups{3});
else
    grp1 = Groups{1};
    grp2 = Groups{2};
    grp3 = Groups{3};
end

color1 = [0/255 114/255 189/255]; %twitter blue
color2 = [217/255 83/255 25/255];%spicy paprika
color3 = [237/255 177/255 32/255];  % sunflower gold

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
    thisxlim  = [350 600];
    thisxtick = 400:100:600;
    thisxtlab = 0:100:200;
    thischild = 1;
    thisstim  = {'1'};
elseif contains(Condition,'Spontaneous')
    condname  = 'Spontaneous';
    thisxlim  = [0 2000];
    thisxtick = 0:500:2000;
    thisxtlab = 0:500:2000;
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

        file1 = [Groups{1} '_CSDTraces_' Condition '_' layers{iLay} '.fig'];
        file2 = [Groups{2} '_CSDTraces_' Condition '_' layers{iLay} '.fig'];
        file3 = [Groups{3} '_CSDTraces_' Condition '_' layers{iLay} '.fig'];
        if exist(file1,'file') && exist(file2,'file')
            % open the figure and scoop the contents
            % group 1
            openfig(file1);
            pause(1)
            h = gca;

            patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
            patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
            liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

            figure(1); nexttile(iLay)
            patch(patchx,patchy,color1,'facealpha',0.2,'edgecolor','none')
            hold on
            plot(liney,'Color',color1,'LineWidth',2)

            figure(2)
            close

            % group 2
            openfig(file2);
            pause(1)
            h = gca;

            patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
            patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
            liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

            figure(1); nexttile(iLay)
            patch(patchx,patchy,color2,'facealpha',0.2,'edgecolor','none')
            plot(liney,'Color',color2,'LineWidth',2)

            % group 3
            openfig(file3);
            pause(1)
            h = gca;

            patchx = h.Parent.Children(thischild(iStim)).Children(2).XData;
            patchy = h.Parent.Children(thischild(iStim)).Children(2).YData;
            liney = h.Parent.Children(thischild(iStim)).Children(1).YData;

            figure(1); nexttile(iLay)
            patch(patchx,patchy,color3,'facealpha',0.2,'edgecolor','none')
            plot(liney,'Color',color3,'LineWidth',2)

            % x tick labels on bottom
            xlim(thisxlim)
            xticks(thisxtick)
            xticklabels([])
            if matches(layers{iLay},'All')
                legend('', grp1, '', grp2, '', grp3)
            elseif matches(layers{iLay},'VI')
                % -400 so 0 is always stim onset
                xticklabels(thisxtlab)
            end
            ylabel(thislay)

            figure(2)
            close
        end

    end

    % final asthetics
    set(gcf,'Position',[100 100 600 700])
    linkaxes

    % savefig(targetfig,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_Traces_' Condition '_' thisstim{iStim}],'compact')
    exportgraphics(targetfig,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_Traces_' Condition '_' thisstim{iStim} '.pdf'])
    exportgraphics(targetfig,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_Traces_' Condition '_' thisstim{iStim} '.png'])
    close;

end
cd(homedir)