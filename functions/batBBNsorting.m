function batBBNsorting(homedir,cbar,Group)

run([Group '.m'])
elevation = {'m4' 'm3' 'm2' 'm1' '0' '1' '2' '3' '4'};
layer = {'II' 'IV' 'Va' 'Vb' 'VI'};
BL = 99;
stimDur = 50;

for iSub = 1:length(animals)

    Name = animals{iSub};
    display(['Sorting BNN elevations for ' Name])

    %preallocate data bins
    PAdat = NaN(length(elevation),length(layer));
    PLdat = NaN(length(elevation),length(layer));
    Tracedat = NaN(500,length(elevation),length(layer));

    %and figures
    figure(1)
    CSDfig = tiledlayout(1,9); %elevations
    title(CSDfig,[Name ' BBN CSD'])
    xlabel(CSDfig, 'time [ms]')
    ylabel(CSDfig, 'depth [channels]')

    figure(2)
    LAYfig = tiledlayout(5,9); %layers by elevations
    title(LAYfig,[Name ' BBN layer traces'])
    xlabel(LAYfig, 'time [ms]')
    ylabel(LAYfig, 'Sink Stength [mV/mm²]')

    figure(3)
    PAfig = tiledlayout(1,1); %elevation tuning
    title(PAfig,[Name ' BBN Tuning Curves Amp'])
    xlabel(PAfig, 'Elevations')
    ylabel(PAfig, 'Peak Amplitude [mV/mm²]')

    figure(4)
    PAfig = tiledlayout(1,1); %elevation tuning
    title(PAfig,[Name ' BBN Tuning Curves Latency'])
    xlabel(PAfig, 'Elevations')
    ylabel(PAfig, 'Peak Latency [ms]')

    load([Name '_Data.mat'],'Data')

    for ielv = 1:length(elevation)

        thiselv = ['BBN' elevation{ielv}];
        % one output per subject location
        index = StimIndex({Data.Condition},Cond,iSub,thiselv);

        % if no stim of this type for this subject, continue on
        if isempty(index)
            warning([Name ' ' thiselv ' data does not exist'])
            continue
        end
        curCSD = Data(index).sngtrlCSD{:};

        % store the spontaneous baseline to autodetect the final BBN
        spdex = StimIndex({Data.Condition},Cond,iSub,'Spontaneous');
        if isempty(spdex)
            % if no spontaneous, take baseline from the within the ITI
            BaseAVG = mean(mean(nanmean(curDat{end,1}(:,800:1400,:))));
            BaseSTD = mean(mean(nanstd(curDat{end,1}(:,800:1400,:),0,2)));
        else
            Spont = Data(spdex).sngtrlCSD;
            BaseAVG = nanmean(nanmean(nanmean(Spont{:})));
            BaseSTD = mean(mean(nanstd(Spont{:},0,2))); % take std of largest set, then average
        end


        %CSD
        figure(1); nexttile
        imagesc(nanmean(curCSD,3))
        title([elevation{ielv}])
        colormap jet
        clim(cbar)
        xlim([400-BL 600])
        
        count = 0;
        %Layers
        for ilay = 1:length(layer)

            thislay = str2num(Layer.(layer{ilay}){iSub});
            curLay  = curCSD(thislay,:,:);

            traceCSD = curLay * -1;         % flip it
            traceCSD(traceCSD < 0) = NaN;   % nan-source it
            traceCSD = nanmean(traceCSD,1); % average it (with nans)
            traceCSD(isnan(traceCSD)) = 0;  % replace nans with 0s for consecutive line

            % plot them with shaded error bar
            figure(2); nexttile(ielv+count)
            hold on
            shadedErrorBar(1:size(traceCSD,2),nanmean(traceCSD,3),nanstd(traceCSD,0,3),'lineprops','b');
            xlim([400-BL 600])
            title([thiselv '  ' layer{ilay}])
            count = count+9;

            % get the average peak data here and store it
            avgTrace = nanmean(traceCSD,3);
            [peakout,latencyout,~] = consec_peaks(avgTrace, ...
                1, stimDur, BL, 'BBN');

            PAdat(ielv,ilay) = peakout;
            PLdat(ielv,ilay) = latencyout;
            Tracedat(1:800,ielv,ilay) = avgTrace;

        end %layers

    end %elevations

    % data acquired, now we need to build the tuning curves
    figure(3);
    nexttile
    hold on
    for ilay = 1:length(layer)
        tuningcurve = PAdat(:,ilay);
        plot(tuningcurve)
        xticks(1:1:9)
        xticklabels(elevation)
    end
    legend('I', 'II-IV', 'Va', 'Vb', 'VI')

    figure(4);
    nexttile
    hold on
    for ilay = 1:length(layer)
        tuningcurve = PLdat(:,ilay);
        plot(tuningcurve)
        xticks(1:1:9)
        xticklabels(elevation)
    end
    legend('I', 'II-IV', 'Va', 'Vb', 'VI')



    cd(homedir); cd output
    if ~exist('batBBN','dir')
        mkdir('batBBN')
    end
    cd batBBN
    %save figures
    figure(1)
    h = gcf;
    h.Position = [0 0 2500 1200];
    savefig(h,[Name ' BBN CSD'],'compact')
    close(h)

    figure(2);linkaxes;nexttile(1)
    legend('', '60', '', '50', '',  '40', '', '30')
    h = gcf;
    h.Position = [0 0 2500 1200];
    savefig(h,[Name ' BBN layer traces'],'compact')
    close(h)

    figure(3);linkaxes;
    h = gcf;
    h.Position = [100 100 1000 600];
    savefig(h,[Name ' BBN Tuning Curves Amp'],'compact')
    close(h)

    figure(4);linkaxes
    h = gcf;
    h.Position = [100 100 1000 600];
    savefig(h,[Name ' BBN Tuning Curves Latency'],'compact')
    close(h)

    %save averaged data
    save([Name '_BBN'],'PAdat','PLdat','Tracedat','BaseAVG','BaseSTD');

end % subjects

cd(homedir)