
function PCal_PupcallStatsITPC(homedir,Condition,callList)

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
bands  = {'Theta' 'Alpha' 'Beta' 'GammaLow' 'GammaHigh'};


DataT = readtable(['VMPandPMP_' Condition '_ITPCmean.csv']);


% initiate a huge stats table for the lawls (for the stats)
ITPCstat = table('Size',[(length(layers) * length(bands) * length(callList)) 10],...
    'VariableTypes',...
            {'string','string','double','double','double','double','double',...
            'double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
ITPCstat.Properties.VariableNames = ["Layer", "Osc", "NumberStim",...
    "P", "df", "CD","mean1","sd1","mean2","sd2"];

cnt = 1;

% we want to chunk by layer and then by oscillatory frequency
for iLay = 1:length(layers)

    Datlay = DataT(matches(DataT.Layer, layers{iLay}),:);
    Grp1 = Datlay(matches(Datlay.Group, 'VMP'),:);
    Grp2 = Datlay(matches(Datlay.Group, 'PMP'),:);

    Peakfig = tiledlayout('horizontal');
    title(Peakfig,[Condition(1:end-2) ' layer ' layers{iLay}])
    ylabel(Peakfig, 'ITPCmean'); xlabel(Peakfig,'Call')

    for iOsc = 1:length(bands)

        Xbars  = [];
        Xerror = [];

        % pull out just the data per select calls
        for iCall = callList

            Gp1call = Grp1((Grp1.Order_Presentation==iCall),:);
            Gp2call = Grp2((Grp2.Order_Presentation==iCall),:);
            grp1means = Gp1call.([bands{iOsc} '_mean']);
            grp2means = Gp2call.([bands{iOsc} '_mean']);


            Xbars  = [Xbars nanmean(grp1means) nanmean(grp2means)];
            Xerror = [Xerror nanstd(grp1means)/sqrt(length(grp1means)) ...
                nanstd(grp2means)/sqrt(length(grp2means))];

            % pull the stats and save them
            [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
                ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
                myttest2(grp1means,grp2means,1,'both');
            ITPCstat.Layer(cnt)      = layers{iLay};
            ITPCstat.Osc(cnt)        = bands{iOsc};
            ITPCstat.NumberStim(cnt) = iCall;
            cnt = cnt + 1;

        end
        nexttile
        bar(Xbars)
        hold on
        errorbar(Xbars,Xerror,'CapSize',1,'LineStyle','none')
        title([bands{iOsc}])

    end % spectral bands
    linkaxes
    ylim([0 1])
    set(gcf,'Position',[200 200 1000 250])
    cd(homedir); cd figures;
    if ~exist('ITPCmeanfig','dir')
        mkdir('ITPCmeanfig')
    end
    cd ITPCmeanfig
    h = gcf;
    savefig(h,['VMPvPMP_' Condition(1:end-2) '_L' layers{iLay} '_stats']);
    exportgraphics(h,['VMPvPMP_' Condition(1:end-2) '_L' layers{iLay} '_stats.pdf'])
    close(h)
end % layers

writetable(ITPCstat,['VMPvPMP_' Condition(1:end-2) '_L' layers{iLay} '_stats.csv']);

cd(homedir)