
function PCal_Pupcall_HighLowStatsITPC(homedir,call_high,call_low)

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
bands  = {'Theta' 'Alpha' 'Beta' 'GammaLow' 'GammaHigh'};

DataT = readtable('VMPandPMP_Pupcall_1_ITPCmean.csv');

% initiate a huge stats table for the lawls (for the stats) - 3 comparisons
ITPCstat = table('Size',[(length(layers) * length(bands) * 3) 10],...
    'VariableTypes',...
            {'string','string','string','double','double','double','double',...
            'double','double','double'});

% S = single, A = average, TH = thalamic, CO = cortical, CN = continue
ITPCstat.Properties.VariableNames = ["Layer", "Osc", "Comp",...
    "P", "df", "CD","mean1","sd1","mean2","sd2"];

cnt = 1;

% we want to chunk by layer and then by oscillatory frequency
for iLay = 1:length(layers)

    Datlay = DataT(matches(DataT.Layer, layers{iLay}),:);
    Grp1 = Datlay(matches(Datlay.Group, 'VMP'),:);
    Grp2 = Datlay(matches(Datlay.Group, 'PMP'),:);

    Peakfig = tiledlayout('flow');
    title(Peakfig,['Pupcall layer ' layers{iLay}])
    ylabel(Peakfig, 'ITPCmean'); xlabel(Peakfig,'Call')

    for iOsc = 1:length(bands)

        g1meanshigh  = [];
        g1errorhigh = [];
        g2meanshigh  = [];
        g2errorhigh = [];

        % pull out just the data per select calls
        for iCall = call_high

            Gp1call = Grp1((Grp1.Order_Presentation==iCall),:);
            Gp2call = Grp2((Grp2.Order_Presentation==iCall),:);
            grp1means = Gp1call.([bands{iOsc} '_mean']);
            grp2means = Gp2call.([bands{iOsc} '_mean']);

            g1meanshigh = [g1meanshigh nanmean(grp1means)];
            g1errorhigh = [g1errorhigh nanstd(grp1means)/sqrt(length(grp1means))];
            g2meanshigh = [g2meanshigh nanmean(grp2means)];
            g2errorhigh = [g2errorhigh nanstd(grp2means)/sqrt(length(grp2means))];

        end
        nexttile
        errorbar(g1meanshigh,g1errorhigh,'o-','CapSize',1)
        hold on
        errorbar(g2meanshigh,g2errorhigh,'o-','CapSize',1)
        ylim([0 1])
        title([bands{iOsc} ' high amp'])

        % mean the highest amp calls means
        converge_g1meanshigh = mean(g1meanshigh);
        converge_g1errorhigh = std(g1meanshigh)/sqrt(length(grp1means));
        converge_g2meanshigh = mean(g2meanshigh);
        converge_g2errorhigh = std(g2meanshigh)/sqrt(length(grp2means));

        nexttile
        bar([converge_g1meanshigh converge_g2meanshigh])
        hold on 
        errorbar([converge_g1meanshigh converge_g2meanshigh],...
            [converge_g1errorhigh converge_g2errorhigh],'LineStyle','none')
        ylim([0 1])
        

        g1meanslow  = [];
        g1errorlow = [];
        g2meanslow  = [];
        g2errorlow = [];

        for iCall = call_low

            Gp1call = Grp1((Grp1.Order_Presentation==iCall),:);
            Gp2call = Grp2((Grp2.Order_Presentation==iCall),:);
            grp1means = Gp1call.([bands{iOsc} '_mean']);
            grp2means = Gp2call.([bands{iOsc} '_mean']);

            g1meanslow = [g1meanslow nanmean(grp1means)];
            g1errorlow = [g1errorlow nanstd(grp1means)/sqrt(length(grp1means))];
            g2meanslow = [g2meanslow nanmean(grp2means)];
            g2errorlow = [g2errorlow nanstd(grp2means)/sqrt(length(grp2means))];

        end

        nexttile
        errorbar(g1meanslow,g1errorlow,'o-','CapSize',1)
        hold on
        errorbar(g2meanslow,g2errorlow,'o-','CapSize',1)
        ylim([0 1])
        title([bands{iOsc} ' low amp'])

        % mean the lowest amp calls means, normalize by virgin mean means lol
        converge_g1meanslow = mean(g1meanslow); % /mean(g1meanslow)
        converge_g1errorlow = std(g1meanslow)/sqrt(length(grp1means));
        converge_g2meanslow = mean(g2meanslow);
        converge_g2errorlow = std(g2meanslow)/sqrt(length(grp2means));

        nexttile
        bar([converge_g1meanslow converge_g2meanslow])
        hold on 
        errorbar([converge_g1meanslow converge_g2meanslow],...
            [converge_g1errorlow converge_g2errorlow],'LineStyle','none')
        ylim([0 1])
        
        % now actually get the stats needed:
        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(g1meanshigh',g2meanshigh',1,'both');
        ITPCstat.Layer(cnt)     = layers{iLay};
        ITPCstat.Osc(cnt)       = bands{iOsc};
        ITPCstat.Comp(cnt)      = 'HighAmp';
        cnt = cnt + 1;

        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(g1meanslow',g2meanslow',1,'both');
        ITPCstat.Layer(cnt)     = layers{iLay};
        ITPCstat.Osc(cnt)       = bands{iOsc};
        ITPCstat.Comp(cnt)      = 'LowAmp';
        cnt = cnt + 1;

        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(g2meanslow',g2meanshigh',1,'both');
        ITPCstat.Layer(cnt)     = layers{iLay};
        ITPCstat.Osc(cnt)       = bands{iOsc};
        ITPCstat.Comp(cnt)      = 'HighLowParents';
        cnt = cnt + 1;

    end % spectral bands 
    set(gcf,'Position',[100 100 1000 900])
    cd(homedir); cd figures;
    if ~exist('ITPCmeanfig','dir')
        mkdir('ITPCmeanfig')
    end
    cd ITPCmeanfig
    h = gcf;
    savefig(h,['VMPvPMP_Pupcall_L' layers{iLay} '_HighLowstats']);
    exportgraphics(h,['VMPvPMP_Pupcall_L' layers{iLay} '_HighLowstats.pdf'])
    close(h)
end % layers

writetable(ITPCstat,['VMPvPMP_Pupcall_L' layers{iLay} '_HighLowstats.csv']);

cd(homedir)