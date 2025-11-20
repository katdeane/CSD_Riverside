function callMaskModelFit(homedir)
% exponential decay fits
% the goal here is to have each call stacked across noise mask levels (e.g.
% call 5 in 0, 1, 2, 3 mask) across animals. Then perform an exponential
% decay fit across mask levels for the group. The fit is non linear least
% squares.

% first pull data - use average data
pTab = readtable('PMA_MaskCall_AVG_AVRECPeak.csv');
vTab = readtable('VMA_MaskCall_AVG_AVRECPeak.csv');

% set some parameters for plotting
x = 1:4; % x axis
smooth_x = min(x):0.1:max(x);
colorStrongB = [15/255 63/255 111/255]; %indigo dye
colorWeakB   = [134/255 161/255 188/255];
colorStrongR = [115/255 46/255 61/255]; % wine
colorWeakR   = [163/255 133/255 140/255]; % Mountbatten pink


sublistp = unique(pTab.Animal);
grpsizep = length(sublistp);
sublistv = unique(vTab.Animal);
grpsizev = length(sublistv);

% loop through layers
layers = {'II' 'IV' 'Va' 'Vb' 'VI'};
for iLay = 1:length(layers)

    playTab = pTab(matches(pTab.Layer, layers{iLay}),:);
    vlayTab = vTab(matches(vTab.Layer, layers{iLay}),:);

    % set up figure
    Maskfig = tiledlayout('flow');
    title(Maskfig,[layers{iLay} ' Exp Decay Fits'])

    % loop through calls
    for iCall = 1:10

        pcallTab = playTab(playTab.OrderofClick == iCall,:);
        vcallTab = vlayTab(vlayTab.OrderofClick == iCall,:);

        nexttile
        hold on

        % loop through subjects, a fit across masking conditions for each
        % fathers
        for iSub = 1:grpsizep

            % pull out the data
            subTab = pcallTab(matches(pcallTab.Animal, sublistp{iSub}),:);
            suby   = subTab.PeakAmp';

            % model on this data
            submod = lsqnonlin(@(p) ( suby -  p(1)*(1+exp((x-p(2))/p(3))) ),[min(suby) 0.1 -1] );
            plot(smooth_x,submod(1)*(1+exp((smooth_x-submod(2))/submod(3))),'Color',colorWeakB)
        end

        %virgins
        for iSub = 1:grpsizev

            % pull out the data
            subTab = vcallTab(matches(vcallTab.Animal, sublistv{iSub}),:);
            suby   = subTab.PeakAmp';

            % model on this data
            submod = lsqnonlin(@(p) ( suby -  p(1)*(1+exp((x-p(2))/p(3))) ),[min(suby) 0.1 -1] );
            plot(smooth_x,submod(1)*(1+exp((smooth_x-submod(2))/submod(3))),'Color',colorWeakR)
        end

        % get data for each condition
        pzero  = mean(pcallTab.PeakAmp(pcallTab.ClickFreq == 0));
        plvl1  = mean(pcallTab.PeakAmp(pcallTab.ClickFreq == 1));
        plvl2  = mean(pcallTab.PeakAmp(pcallTab.ClickFreq == 2));
        plvl3  = mean(pcallTab.PeakAmp(pcallTab.ClickFreq == 3));

        vzero  = mean(vcallTab.PeakAmp(vcallTab.ClickFreq == 0));
        vlvl1  = mean(vcallTab.PeakAmp(vcallTab.ClickFreq == 1));
        vlvl2  = mean(vcallTab.PeakAmp(vcallTab.ClickFreq == 2));
        vlvl3  = mean(vcallTab.PeakAmp(vcallTab.ClickFreq == 3));

        % build model fit
        py = [pzero plvl1 plvl2 plvl3];
        vy = [vzero vlvl1 vlvl2 vlvl3];

        pmod = lsqnonlin(@(p) ( py -  p(1)*(1+exp((x-p(2))/p(3))) ),[min(py) 0.1 -1] );
        plot(smooth_x,pmod(1)*(1+exp((smooth_x-pmod(2))/pmod(3))),'Color',colorStrongB,'LineWidth',4)

        vmod = lsqnonlin(@(p) ( vy -  p(1)*(1+exp((x-p(2))/p(3))) ),[min(vy) 0.1 -1] );
        plot(smooth_x,vmod(1)*(1+exp((smooth_x-vmod(2))/vmod(3))),'Color',colorStrongR,'LineWidth',4)

        scatter(x,py,'filled','MarkerEdgeColor',colorStrongB,'MarkerFaceColor',colorStrongB)
        scatter(x,vy,'filled','MarkerEdgeColor',colorStrongR,'MarkerFaceColor',colorStrongR)


        legend({'' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' ...
            ['Fathers saturation=' num2str(pmod(1)) ',2=' num2str(pmod(2)) ',rate constant=' num2str(pmod(3))]...
            ['Virgins saturation=' num2str(vmod(1)) ',2=' num2str(vmod(2)) ',rate constant=' num2str(vmod(3))]})

        % ylim([0 2])
        xticks(1:1:4)
        xticklabels(0:1:3)
        ylabel('Peak Amplitude [mV/mm²]')
        xlabel('Mask level')
        title(['Call ' num2str(iCall)])
    end

    %save figures
    cd(homedir);cd figures;
    if ~exist('fits','dir')
        mkdir('fits')
    end
    cd fits

    h = gcf;
    savefig(h,['MaskFits_' layers{iLay}]);
    close(h)
end
cd(homedir)