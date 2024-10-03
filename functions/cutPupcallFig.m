function cutPupcallFig(homedir,call_list, click_list)

% for the pup call CSD
Condition = {'Pupcall30 1 ' 'ClickTrain 5 Hz'};
cd(homedir); cd figures; cd PermCSD;

for iCond = 1:length(Condition)
    openfig(['VMPvPMP Observed CSD ' Condition{iCond} '.fig'])
    h = gca;

    if matches(Condition{iCond},'Pupcall30 1 ')
        % standardize clims
        clim(h.Parent.Children(6),[-0.25 0.25]) %top
        clim(h.Parent.Children(4),[-0.25 0.25]) %middle
        clim(h.Parent.Children(2),[-0.25 0.25]) %bottom
        % change colormap for the difference plot
        ax = h.Parent.Children(2);
        colormap(ax,'pink')
        linkaxes

        exportgraphics(h.Parent,['VMPvPMP Observed CSD ' Condition{iCond} ' full.pdf'])

        load('PupTimes.mat','PupTimes')
        PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
        PupTimes = PupTimes + 0.400; % add the prestimulus time
        % sanity check with a pup call CSD figure that includes .wav image
        % callWAV = PupTimes(13,1);
        % xlim([callWAV-0.2 callWAV+0.4])
        PupTimes = PupTimes .* 1000; % match axes for CSD
        for icall = call_list
            xlim([(PupTimes(icall,1)-50) (PupTimes(icall,1)+200)])
            exportgraphics(h.Parent,['VMPvPMP Observed CSD ' Condition{iCond} ' ' num2str(icall) '.pdf'])
        end
    else
        % standardize clims
        clim(h.Parent.Children(6),[-0.25 0.25]) %top
        clim(h.Parent.Children(4),[-0.25 0.25]) %middle
        clim(h.Parent.Children(2),[-0.25 0.25]) %bottom
        ax = h.Parent.Children(2);
        colormap(ax,'pink')
        linkaxes

        exportgraphics(h.Parent,['VMPvPMP Observed CSD ' Condition{iCond} ' full.pdf'])
        for iclick = click_list
            % get our click time point
            xtime = (iclick-1)*(1000/5) + 400;
            xlim([(xtime-50) (xtime+200)])
            exportgraphics(h.Parent,['VMPvPMP Observed CSD ' Condition{iCond} ' ' num2str(iclick) '.pdf'])
        end
    end
end

% for the pup call CWT
Condition = {'Pupcall 1 ' 'ClickTrain 5Hz '};  
Layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
cd(homedir); cd figures; cd CWT;

for iCond = 1:length(Condition)
    for iLay = 1:length(Layers)
        openfig(['VMPvPMP_Observed Phase ' Condition{iCond}  Layers{iLay} '.fig'])
        h = gca;

        if matches(Condition{iCond},'Pupcall 1 ')
            % standardize clims
            clim(h.Parent.Children(6),[0 0.8]) %top
            clim(h.Parent.Children(4),[0 0.8]) %middle
            clim(h.Parent.Children(2),[-0.3 0.3]) %bottom
            ax = h.Parent.Children(2);
            colormap(ax,'pink')
            linkaxes

            exportgraphics(h.Parent,['VMPvPMP_Observed Phase ' Condition{iCond}  Layers{iLay} ' full.pdf'])

            % load('PupTimes.mat','PupTimes')
            % PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
            % PupTimes = PupTimes + 0.400; % add the prestimulus time
            % % sanity check with a pup call CSD figure that includes .wav image
            % % callWAV = PupTimes(13,1);
            % % xlim([callWAV-0.2 callWAV+0.4])
            % PupTimes = PupTimes .* 1000; % match axes for CSD

            for icall = call_list
                xlim([(PupTimes(icall,1)-50) (PupTimes(icall,1)+200)])
                exportgraphics(h.Parent,['VMPvPMP_Observed Phase ' Condition{iCond}  Layers{iLay} ' ' num2str(icall) '.pdf'])
            end
        else
            % standardize clims
            clim(h.Parent.Children(6),[0 0.7]) %top
            clim(h.Parent.Children(4),[0 0.7]) %middle
            clim(h.Parent.Children(2),[-0.3 0.3]) %bottom
            ax = h.Parent.Children(2);
            colormap(ax,'pink')
            linkaxes

            exportgraphics(h.Parent,['VMPvPMP_Observed Phase ' Condition{iCond}  Layers{iLay} ' full.pdf'])

            for iclick = click_list
                % get our click time point
                xtime = (iclick-1)*(1000/5) + 400;
                xlim([(xtime-50) (xtime+200)])
                exportgraphics(h.Parent,['VMPvPMP_Observed Phase ' Condition{iCond}  Layers{iLay} ' ' num2str(iclick) '.pdf'])
            end
        end
    end
end

close all
