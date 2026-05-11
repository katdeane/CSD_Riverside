% function gapASSRcorr_ITPCmean(homedir,Groups,highcalls,lowcalls)

% Correlate the ITPC means between the gap ASSR at all
% widths with quiet and loud calls and noise bursts

Layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
Bands  = {'Theta_mean' 'Alpha_mean' 'Beta_mean' 'GammaLow_mean' 'GammaHigh_mean'};

% pull in the data first
gap2  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_2_ITPCmean.csv']);
gap4  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_4_ITPCmean.csv']);
gap6  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_6_ITPCmean.csv']);
gap8  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_8_ITPCmean.csv']);
gap10 = readtable([Groups{1} 'and' Groups{2} '_gapASSR_10_ITPCmean.csv']);

NBquiet = readtable([Groups{1} 'and' Groups{2} '_NoiseBurst_20_ITPCmean.csv']);
NBloud  = readtable([Groups{1} 'and' Groups{2} '_NoiseBurst_50_ITPCmean.csv']);

PC = readtable([Groups{1} 'and' Groups{2} '_Pupcall_1_ITPCmean.csv']);

% we'll look at the 5th gap in noise block
gap2  = gap2(gap2.Order_Presentation == 5,:);
gap4  = gap4(gap4.Order_Presentation == 5,:);
gap6  = gap6(gap6.Order_Presentation == 5,:);
gap8  = gap8(gap8.Order_Presentation == 5,:);
gap10 = gap10(gap10.Order_Presentation == 5,:);

% now the quietest and loudest calls
PCquiet = PC(PC.Order_Presentation == lowcalls(1),:);
PCloud  = PC(PC.Order_Presentation == highcalls(end),:);

% we're missing some subjects in gap: PMP04, PMP09, VMP08
% NB and PC subject lists match so we only need one boolean list
sublist = unique(gap2.Subject);
complist = zeros(length(PCloud.Subject),1);
for iSub = 1:length(sublist)
    complist = complist + contains(PCloud.Subject,sublist{iSub});
end

NBquiet = NBquiet(complist>0,:);
NBloud  = NBloud(complist>0,:);
PCquiet = PCquiet(complist>0,:);
PCloud  = PCloud(complist>0,:);

% now we are equal. Yay!

%% Figures and stats

% loop through layers
for iLay = 1:length(Layers)

    % pull out layer data
    layNB_q = NBquiet(matches(NBquiet.Layer,Layers{iLay}),:);
    layNB_l = NBloud(matches(NBloud.Layer,Layers{iLay}),:);
    layPC_q = PCquiet(matches(PCquiet.Layer,Layers{iLay}),:);
    layPC_l = PCloud(matches(PCloud.Layer,Layers{iLay}),:);

    laygap2  = gap2(matches(gap2.Layer,Layers{iLay}),:);
    laygap4  = gap4(matches(gap4.Layer,Layers{iLay}),:);
    laygap6  = gap6(matches(gap6.Layer,Layers{iLay}),:);
    laygap8  = gap8(matches(gap8.Layer,Layers{iLay}),:);
    laygap10 = gap10(matches(gap10.Layer,Layers{iLay}),:);

    % loop through frequency bands
    for iBand = 1:length(Bands)
        % gapASSR will always put low gamma, and in fact tightly around 40 Hz, into
        % the correlation with other frequency bands

        % figure per layer
        Corrfig = tiledlayout('flow');
        title(Corrfig,['Layer ' Layers{iLay} ' ' Bands{iBand}(1:end-5)])
        xlabel(Corrfig, 'gap ASSR ITPC means')
        ylabel(Corrfig, 'pup or call ITPC means')

        % gap widths v NB quiet
        nexttile
        [r_gap2, p_NBquiet] = corr(laygap2.GammaLow_mean,layNB_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap2.GammaLow_mean,layNB_q.([Bands{iBand}]));
        title(['g2 v NB Q r=' num2str(round(r_gap2,2,'significant'))...
            ' p=' num2str(round(p_NBquiet,2,'significant'))])

        nexttile
        [r_gap4, p_NBquiet] = corr(laygap4.GammaLow_mean,layNB_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap4.GammaLow_mean,layNB_q.([Bands{iBand}]));
        title(['g4 v NB Q r=' num2str(round(r_gap4,2,'significant'))...
            ' p=' num2str(round(p_NBquiet,2,'significant'))])

        nexttile
        [r_gap6, p_NBquiet] = corr(laygap6.GammaLow_mean,layNB_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap6.GammaLow_mean,layNB_q.([Bands{iBand}]));
        title(['g6 v NB Q r=' num2str(round(r_gap6,2,'significant'))...
            ' p=' num2str(round(p_NBquiet,2,'significant'))])

        nexttile
        [r_gap8, p_NBquiet] = corr(laygap8.GammaLow_mean,layNB_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap8.GammaLow_mean,layNB_q.([Bands{iBand}]));
        title(['g8 v NB Q r=' num2str(round(r_gap8,2,'significant'))...
            ' p=' num2str(round(p_NBquiet,2,'significant'))])

        nexttile
        [r_gap10, p_NBquiet] = corr(laygap10.GammaLow_mean,layNB_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap10.GammaLow_mean,layNB_q.([Bands{iBand}]));
        title(['g10 v NB Q r=' num2str(round(r_gap10,2,'significant'))...
            ' p=' num2str(round(p_NBquiet,2,'significant'))])

        % gap widths v NB loud
        nexttile
        [r_gap2, p_NBloud] = corr(laygap2.GammaLow_mean,layNB_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap2.GammaLow_mean,layNB_l.([Bands{iBand}]));
        title(['g2 v NB L r=' num2str(round(r_gap2,2,'significant'))...
            ' p=' num2str(round(p_NBloud,2,'significant'))])

        nexttile
        [r_gap4, p_NBloud] = corr(laygap4.GammaLow_mean,layNB_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap4.GammaLow_mean,layNB_l.([Bands{iBand}]));
        title(['g4 v NB L r=' num2str(round(r_gap4,2,'significant'))...
            ' p=' num2str(round(p_NBloud,2,'significant'))])

        nexttile
        [r_gap6, p_NBloud] = corr(laygap6.GammaLow_mean,layNB_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap6.GammaLow_mean,layNB_l.([Bands{iBand}]));
        title(['g6 v NB L r=' num2str(round(r_gap6,2,'significant'))...
            ' p=' num2str(round(p_NBloud,2,'significant'))])

        nexttile
        [r_gap8, p_NBloud] = corr(laygap8.GammaLow_mean,layNB_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap8.GammaLow_mean,layNB_l.([Bands{iBand}]));
        title(['g8 v NB L r=' num2str(round(r_gap8,2,'significant'))...
            ' p=' num2str(round(p_NBloud,2,'significant'))])

        nexttile
        [r_gap10, p_NBloud] = corr(laygap10.GammaLow_mean,layNB_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap10.GammaLow_mean,layNB_l.([Bands{iBand}]));
        title(['g10 v NB L r=' num2str(round(r_gap10,2,'significant'))...
            ' p=' num2str(round(p_NBloud,2,'significant'))])

        % gap widths v PC quiet
        nexttile
        [r_gap2, p_PCquiet] = corr(laygap2.GammaLow_mean,layPC_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap2.GammaLow_mean,layPC_q.([Bands{iBand}]));
        title(['g2 v PC Q r=' num2str(round(r_gap2,2,'significant'))...
            ' p=' num2str(round(p_PCquiet,2,'significant'))])

        nexttile
        [r_gap4, p_PCquiet] = corr(laygap4.GammaLow_mean,layPC_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap4.GammaLow_mean,layPC_q.([Bands{iBand}]));
        title(['g4 v PC Q r=' num2str(round(r_gap4,2,'significant'))...
            ' p=' num2str(round(p_PCquiet,2,'significant'))])

        nexttile
        [r_gap6, p_PCquiet] = corr(laygap6.GammaLow_mean,layPC_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap6.GammaLow_mean,layPC_q.([Bands{iBand}]));
        title(['g6 v PC Q r=' num2str(round(r_gap6,2,'significant'))...
            ' p=' num2str(round(p_PCquiet,2,'significant'))])

        nexttile
        [r_gap8, p_PCquiet] = corr(laygap8.GammaLow_mean,layPC_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap8.GammaLow_mean,layPC_q.([Bands{iBand}]));
        title(['g8 v PC Q r=' num2str(round(r_gap8,2,'significant'))...
            ' p=' num2str(round(p_PCquiet,2,'significant'))])

        nexttile
        [r_gap10, p_PCquiet] = corr(laygap10.GammaLow_mean,layPC_q.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap10.GammaLow_mean,layPC_q.([Bands{iBand}]));
        title(['g10 v PC Q r=' num2str(round(r_gap10,2,'significant'))...
            ' p=' num2str(round(p_PCquiet,2,'significant'))])

        % gap widths v PC loud
        nexttile
        [r_gap2, p_PCloud] = corr(laygap2.GammaLow_mean,layPC_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap2.GammaLow_mean,layPC_l.([Bands{iBand}]));
        title(['g2 v PC L r=' num2str(round(r_gap2,2,'significant'))...
            ' p=' num2str(round(p_PCloud,2,'significant'))])

        nexttile
        [r_gap4, p_PCloud] = corr(laygap4.GammaLow_mean,layPC_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap4.GammaLow_mean,layPC_l.([Bands{iBand}]));
        title(['g4 v PC L r=' num2str(round(r_gap4,2,'significant'))...
            ' p=' num2str(round(p_PCloud,2,'significant'))])

        nexttile
        [r_gap6, p_PCloud] = corr(laygap6.GammaLow_mean,layPC_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap6.GammaLow_mean,layPC_l.([Bands{iBand}]));
        title(['g6 v PC L r=' num2str(round(r_gap6,2,'significant'))...
            ' p=' num2str(round(p_PCloud,2,'significant'))])

        nexttile
        [r_gap8, p_PCloud] = corr(laygap8.GammaLow_mean,layPC_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap8.GammaLow_mean,layPC_l.([Bands{iBand}]));
        title(['g8 v PC L r=' num2str(round(r_gap8,2,'significant'))...
            ' p=' num2str(round(p_PCloud,2,'significant'))])

        nexttile
        [r_gap10, p_PCloud] = corr(laygap10.GammaLow_mean,layPC_l.([Bands{iBand}]),'Type','Spearman');
        scatter(laygap10.GammaLow_mean,layPC_l.([Bands{iBand}]));
        title(['g10 v PC L r=' num2str(round(r_gap10,2,'significant'))...
            ' p=' num2str(round(p_PCloud,2,'significant'))])

        cd (homedir); cd figures;
        if ~exist('Gapcorr','dir')
            mkdir('Gapcorr');
        end
        cd Gapcorr

        savefig(gcf,[Groups{1} '&' Groups{2} '_' Layers{iLay} '_' Bands{iBand} '_gapCorr'])
    end % bands
end % layers


