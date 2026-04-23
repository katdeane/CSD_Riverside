function batCFsorting(homedir,cbar,Group)

run([Group '.m'])
level = {'60' '50' '40' '30'};
tones = {'5' '10' '15' '20' '25' '30' '35'};
layer = {'II' 'IV' 'Va' 'Vb' 'VI'};
BL = 399;
stimDur = 50;

for iSub = 1:length(animals)

    Name = animals{iSub};
    display(['Sorting CF for ' Name])

    %preallocate data bins
    PAdat = NaN(length(level),length(tones),length(layer));
    PLdat = NaN(length(level),length(tones),length(layer));
    Tracedat = NaN(1400,length(level),length(tones),length(layer));

    %and figures
    figure(1)
    CSDfig = tiledlayout(4,7); %levels by tones
    title(CSDfig,[Name ' CF CSD'])
    xlabel(CSDfig, 'time [ms]')
    ylabel(CSDfig, 'depth [channels]')

    figure(2)
    LAYfig = tiledlayout(7,5); %layers by tones (tones in each figure)
    title(LAYfig,[Name ' CF layer traces'])
    xlabel(LAYfig, 'time [ms]')
    ylabel(LAYfig, 'Sink Stength [mV/mm²]')

    figure(3)
    PAfig = tiledlayout(1,4); %levels (tones in each figure)
    title(PAfig,[Name ' CF Tuning Curves Amp'])
    xlabel(PAfig, 'Tone Frequency [kHz]')
    ylabel(PAfig, 'Peak Amplitude [mV/mm²]')

    figure(4)
    PAfig = tiledlayout(1,4); %levels (tones in each figure)
    title(PAfig,[Name ' CF Tuning Curves Latency'])
    xlabel(PAfig, 'Tone Frequency [kHz]')
    ylabel(PAfig, 'Peak Latency [ms]')

    figure(5)
    HMfig = tiledlayout(1,5); %layers, 1 heatmap each
    title(HMfig,[Name ' Response Heat Map'])
    xlabel(HMfig, 'Tone Frequency [kHz]')
    ylabel(HMfig, 'Levels [dB SPL]')

    load([Name '_Data.mat'],'Data')
    % one output per subject location
    index = StimIndex({Data.Condition},Cond,iSub,'CF');

    % if no stim of this type for this subject, continue on
    if isempty(index)
        warning([Name ' CF data does not exist'])
        continue
    end
    curDat = Data(index).sngtrlCSD;

    % store the spontaneous baseline to autodetect the final CF
    spdex = StimIndex({Data.Condition},Cond,iSub,'Spontaneous');
    if isempty(spdex)
        % if no spontaneous, take baseline from the second half of CF
        % measurement lowest db, lowest freq
        BaseAVG = mean(mean(nanmean(curDat{end,1}(:,800:1400,:))));
        BaseSTD = mean(mean(nanstd(curDat{end,1}(:,800:1400,:),0,2)));
    else
        Spont = Data(spdex).sngtrlCSD;
        BaseAVG = nanmean(nanmean(nanmean(Spont{:})));
        BaseSTD = mean(mean(nanstd(Spont{:},0,2))); % take std of largest set, then average
    end

    for ilev = 1:length(level)
        count = 1;
        for iton = 1:length(tones)

            %CSD
            curCSD = curDat{ilev,iton};
            
            figure(1); nexttile
            imagesc(nanmean(curCSD,3))
            title([tones{iton} ' kHz ' level{ilev} ' dB'])
            colormap jet
            clim(cbar)
            xlim([400 500])
            
            %Layers
            for ilay = 1:length(layer)
                
                thislay = str2num(Layer.(layer{ilay}){iSub});
                curLay  = curCSD(thislay,:,:);

                traceCSD = curLay * -1;         % flip it
                traceCSD(traceCSD < 0) = NaN;   % nan-source it
                traceCSD = nanmean(traceCSD,1); % average it (with nans)
                traceCSD(isnan(traceCSD)) = 0;  % replace nans with 0s for consecutive line

                % plot them with shaded error bar
                if ilev == 1
                    color = 'k';
                elseif ilev == 2
                    color = 'b';
                elseif ilev == 3
                    color = 'r';
                else 
                    color = 'm';
                end
                figure(2); nexttile(count)
                hold on
                shadedErrorBar(1:size(traceCSD,2),nanmean(traceCSD,3),nanstd(traceCSD,0,3),'lineprops',color);
                xlim([400 500])
                title([tones{iton} ' kHz ' layer{ilay}])
                count = count+1;

                % get the average peak data here and store it 
                avgTrace = nanmean(traceCSD,3);
                [peakout,latencyout,~] = consec_peaks(avgTrace, ...
                    1, stimDur, BL, 'CL');

                PAdat(ilev,iton,ilay) = peakout;
                PLdat(ilev,iton,ilay) = latencyout;
                Tracedat(1:1400,ilev,iton,ilay) = avgTrace;

            end %layers
            
        end %tone frequencies
    end %levels
    
    % data acquired, now we need to build the tuning curves
    figure(3); 
    for ilev = 1:length(level)
        nexttile(ilev)
        hold on
        for ilay = 1:length(layer)
            tuningcurve = PAdat(ilev,1:7,ilay);
            plot(tuningcurve)
            xticks(1:1:7)
            xticklabels(tones)
            title(level{ilev})
        end
        legend('I', 'II-IV', 'Va', 'Vb', 'VI')
    end

    figure(4); 
    for ilev = 1:length(level)
        nexttile(ilev)
        hold on
        for ilay = 1:length(layer)
            tuningcurve = PLdat(ilev,1:7,ilay);
            plot(tuningcurve)
            xticks(1:1:7)
            xticklabels(tones)
            title(level{ilev})
        end
        legend('I', 'II-IV', 'Va', 'Vb', 'VI')
    end

    figure(5)
    for ilay = 1:length(layer)
        nexttile
        heatmapdat = PAdat(:,:,ilay);
        heatmap(heatmapdat,'GridVisible','off','Colormap',parula);
        clim([0 0.5])
        title(layer{ilay})
    end

    cd(homedir); cd output
    if ~exist('batCF','dir')
        mkdir('batCF')
    end
    cd batCF
    %save figures
    figure(1)
    h = gcf;
    h.Position = [0 0 2500 1200];
    savefig(h,[Name ' CF CSD'],'compact')
    close(h)

    figure(2);linkaxes;nexttile(1)
    legend('', '60', '', '50', '',  '40', '', '30')
    h = gcf;
    h.Position = [0 0 2500 1200];
    savefig(h,[Name ' CF layer traces'],'compact')
    close(h)

    figure(3);linkaxes;
    h = gcf;
    h.Position = [100 100 1000 600];
    savefig(h,[Name ' CF Tuning Curves Amp'],'compact')
    close(h)

    figure(4);linkaxes
    h = gcf;
    h.Position = [100 100 1000 600];
    savefig(h,[Name ' CF Tuning Curves Latency'],'compact')
    close(h)

    figure(5);
    h = gcf;
    h.Position = [100 100 1000 600];
    savefig(h,[Name ' Heatmaps'],'compact')
    close(h)
    
    %save averaged data
    save([Name '_CF'],'PAdat','PLdat','Tracedat','BaseAVG','BaseSTD');

end % subjects

cd(homedir)