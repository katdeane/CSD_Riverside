
function PCal_NoiseBurst_HighLowStatsITPC(homedir,low,high)

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
bands  = {'Theta' 'Alpha' 'Beta' 'GammaLow' 'GammaHigh'};

DataTlow = readtable(['VMPandPMP_NoiseBurst_' low '_ITPCmean.csv']);
DataThigh = readtable(['VMPandPMP_NoiseBurst_' high '_ITPCmean.csv']);

% initiate a huge stats table for the lawls (for the stats) - 3 comparisons
ITPCstat = table('Size',[(length(layers) * length(bands) * 3) 10],...
    'VariableTypes',...
            {'string','string','string','double','double','double','double',...
            'double','double','double'});

% S = single, A = average
ITPCstat.Properties.VariableNames = ["Layer", "Osc", "Comp",...
    "P", "df", "CD","mean1","sd1","mean2","sd2"];

cnt = 1;

% we want to chunk by layer and then by oscillatory frequency
for iLay = 1:length(layers)

    Datlaylow = DataTlow(matches(DataTlow.Layer, layers{iLay}),:);
    Grp1l = Datlaylow(matches(Datlaylow.Group, 'VMP'),:);
    Grp2l = Datlaylow(matches(Datlaylow.Group, 'PMP'),:);
    Datlayhigh = DataThigh(matches(DataThigh.Layer, layers{iLay}),:);
    Grp1h = Datlayhigh(matches(Datlayhigh.Group, 'VMP'),:);
    Grp2h = Datlayhigh(matches(Datlayhigh.Group, 'PMP'),:);

    Peakfig = tiledlayout('flow');
    title(Peakfig,['NoiseBurst layer ' layers{iLay}])
    ylabel(Peakfig, 'ITPCmean'); xlabel(Peakfig,'Call')

    for iOsc = 1:length(bands)

        % this spectral band's means for high
        grp1meansh = Grp1h.([bands{iOsc} '_mean']);
        grp2meansh = Grp2h.([bands{iOsc} '_mean']);

        g1meanshigh = nanmean(grp1meansh);
        g1errorhigh = nanstd(grp1meansh)/sqrt(length(grp1meansh));
        g2meanshigh = nanmean(grp2meansh);
        g2errorhigh = nanstd(grp2meansh)/sqrt(length(grp2meansh));

        nexttile
        errorbar(g1meanshigh,g1errorhigh,'o-','CapSize',1)
        hold on
        errorbar(g2meanshigh,g2errorhigh,'o-','CapSize',1)
        ylim([0 1])
        title([bands{iOsc} ' high amp'])

        % normalize to virgins
        g1meanshighnorm = grp1meansh / g1meanshigh;
        g2meanshighnorm = grp2meansh / g1meanshigh;

        nexttile
        bar([mean(g1meanshighnorm) mean(g2meanshighnorm)])
        hold on 
        errorbar([mean(g1meanshighnorm) mean(g2meanshighnorm)],...
            [g1errorhigh g2errorhigh],'LineStyle','none')
        ylim([0 2])
       
        % this spectral band's means for low
        grp1meansl = Grp1l.([bands{iOsc} '_mean']);
        grp2meansl = Grp2l.([bands{iOsc} '_mean']);

        g1meanslow = nanmean(grp1meansl);
        g1errorlow = nanstd(grp1meansl)/sqrt(length(grp1meansl));
        g2meanslow = nanmean(grp2meansl);
        g2errorlow = nanstd(grp2meansl)/sqrt(length(grp2meansl));

        nexttile
        errorbar(g1meanslow,g1errorlow,'o-','CapSize',1)
        hold on
        errorbar(g2meanslow,g2errorlow,'o-','CapSize',1)
        ylim([0 1])
        title([bands{iOsc} ' low amp'])

        % normalize to virgins
        g1meanslownorm = grp1meansl / g1meanslow;
        g2meanslownorm = grp2meansl / g1meanslow;

        nexttile
        bar([mean(g1meanslownorm) mean(g2meanslownorm)])
        hold on 
        errorbar([mean(g1meanslownorm) mean(g2meanslownorm)],...
            [g1errorlow g2errorlow],'LineStyle','none')
        ylim([0 2])
        
        % now actually get the stats needed:
        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(grp1meansh,grp2meansh,1,'both');
        ITPCstat.Layer(cnt)     = layers{iLay};
        ITPCstat.Osc(cnt)       = bands{iOsc};
        ITPCstat.Comp(cnt)      = 'HighAmp';
        cnt = cnt + 1;

        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(grp1meansl,grp2meansl,1,'both');
        ITPCstat.Layer(cnt)     = layers{iLay};
        ITPCstat.Osc(cnt)       = bands{iOsc};
        ITPCstat.Comp(cnt)      = 'LowAmp';
        cnt = cnt + 1;

        [ITPCstat.P(cnt),ITPCstat.df(cnt),ITPCstat.CD(cnt),ITPCstat.mean1(cnt),...
            ITPCstat.sd1(cnt),ITPCstat.mean2(cnt),ITPCstat.sd2(cnt)] = ...
            myttest2(g2meanslownorm,g2meanshighnorm,1,'both');
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
    savefig(h,['VMPvPMP_NoiseBurst_L' layers{iLay} '_HighLowstats_Norm']);
    exportgraphics(h,['VMPvPMP_NoiseBurst_L' layers{iLay} '_HighLowstats_Norm.pdf'])
    close(h)
end % layers

writetable(ITPCstat,['VMPvPMP_NoiseBurst_L' layers{iLay} '_HighLowstats_Norm.csv']);

cd(homedir)