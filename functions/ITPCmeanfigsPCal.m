
function ITPCmeanfigsPCal(homedir)


Condition = {'Pupcall_1' 'ClickTrain_5' 'gapASSR_10'};
layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
bands  = {'Theta' 'Alpha' 'Beta' 'GammaLow' 'GammaHigh'};

for iCond = 1:length(Condition)

    DataT = readtable(['VMPandPMP_' Condition{iCond} '_ITPCmean.csv']);

    % we want to chunk by layer and then by oscillatory frequency
    for iLay = 1:length(layers)

        Datlay = DataT(matches(DataT.Layer, layers{iLay}),:);
        Grp1 = Datlay(matches(Datlay.Group, 'VMP'),:);
        Grp2 = Datlay(matches(Datlay.Group, 'PMP'),:);

        Peakfig = tiledlayout('flow');
        title(Peakfig,[Condition{iCond}(1:end-2) ' layer ' layers{iLay}])
        ylabel(Peakfig, 'ITPCmean'); xlabel(Peakfig,'Presentation')

        for iOsc = 1:length(bands)

            % pull out just the data
            grp1means = Grp1.([bands{iOsc} '_mean']);
            grp2means = Grp2.([bands{iOsc} '_mean']);
            % reshape it to stack, stim presentation x subject
            grp1means = reshape(grp1means,[length(unique(Grp1.Order_Presentation)),...
                length(unique(Grp1.Subject))]);
            grp2means = reshape(grp2means,[length(unique(Grp2.Order_Presentation)),...
                length(unique(Grp2.Subject))]);

            nexttile
            errorbar(mean(grp1means'),(std(grp1means')/sqrt(length(unique(Grp1.Subject)))),...
                'CapSize',1)
            hold on
            errorbar(mean(grp2means'),(std(grp2means')/sqrt(length(unique(Grp2.Subject)))),...
                'CapSize',1)
            legend({'Virgin' 'Father'})
            title([bands{iOsc}])

        end % spectral bands
        linkaxes
        ylim([0 1])
        cd(homedir); cd figures;
        if ~exist('ITPCmeanfig','dir')
            mkdir('ITPCmeanfig')
        end
        cd ITPCmeanfig
        h = gcf;
        savefig(h,['VMPvPMP_' Condition{iCond}(1:end-2) '_L' layers{iLay}]);
        exportgraphics(h,['VMPvPMP_' Condition{iCond}(1:end-2) '_L' layers{iLay} '.pdf'])
        close(h)
    end % layers
end % conditions
cd(homedir)