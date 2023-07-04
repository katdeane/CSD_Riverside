function CSDandTuningFigs(homedir, file, Data, stimtype)
% CSD and tuning figs

if strcmp(stimtype,'Noise')
    thisunit = 'dB';
    multiple = 1;
elseif strcmp(stimtype,'Tones')
    thisunit = 'kHz';
    multiple = 1;
elseif strcmp(stimtype,'Clicks')
    thisunit = 'Hz';
    multiple = 1;
elseif strcmp(stimtype,'Chirps')
    multiple = 0;
else
    warning('You have to input specific stimtype variable as above')
end

% Parameters for CSD filtering
chan_dist = 50; % distance between channels (µm)
kernel    = 450; % 600 is very smooth, 300 is more accurate, 450 is happy medium
kernelxchannel = kernel./chan_dist; % kernel size in terms of number of channels
hammsiz   = kernelxchannel+(rem(kernelxchannel,2)-1)*-1; % linear extrapolation and running avg
paddsiz   = floor(hammsiz/2)+1;
BL        = 399; % baseline time period


fieldnames = fields(Data);
if multiple == 1
    % set up tuning data
    rmslist = zeros(1,size(Data,2));
    stimlist = [Data.(fieldnames{2})];

    % set up CSD figure
    figure
    CSDfig = tiledlayout('flow');
    title(CSDfig,['CSD ' file(1:5) ' ' file(7:8)])
    xlabel(CSDfig, 'time [ms]')
    ylabel(CSDfig, 'depth [channels]')

    for istim = 1:size(Data,2)

        if isempty(Data(istim).LFP)
            continue
        end

        % CSD
        % preallocate:
        CSD = NaN(size(Data(istim).LFP));

        % loop through trials
        for itri = 1:size(Data(istim).LFP,3)
            curLFP = Data(istim).LFP(:, :, itri);       % current LFP trial
            % curLFP = flipud(curLFP); % it's inverted in the up down
            % orientation
            paddit = padd_linex(curLFP,paddsiz,1);      % create padding
            hammit = filt_Hamm(paddit,hammsiz,1);       % apply hamming filter
            CSD(:,:,itri) = (get_csd(hammit,1,chan_dist,1))*10^3; % make csd
        end

        fullCSD = mean(CSD,3);

        nexttile, imagesc(fullCSD);
        colormap('jet');
        caxis([-0.2 0.2])
        colorbar
        if strcmp(stimtype,'Tones')
            title([num2str(stimlist(istim)/1000) thisunit])
        elseif strcmp(stimtype,'Clicks')
            title([num2str(1000/stimlist(istim)) thisunit])
        else
            title([num2str(stimlist(istim)) thisunit])
        end

        % get average rectified rms value, full column, for first 100 ms after onset
        rmslist(istim) = rms(mean(abs(fullCSD(:,BL + 1:BL + 100)),1));

    end

    figname = ['CSD_' file '_' stimtype '.fig'];
    cd(homedir); cd figures
    savefig(gcf,figname)   % save CSD fig
    close

    figure;
    plot(stimlist,rmslist,'--o')
    title('Tuning Curve')
    xlabel(thisunit)
    ylabel('RMS [mV/mm2]')

    figname = ['Tuning_' file '_' stimtype '.fig'];
    cd(homedir); cd figures
    savefig(gcf,figname)   % save CSD fig
    close
elseif multiple == 0

    % set up CSD figure
    figure
    CSDfig = tiledlayout('flow');
    title(CSDfig,['CSD ' file(1:5) ' ' file(7:8)])
    xlabel(CSDfig, 'time [ms]')
    ylabel(CSDfig, 'depth [channels]')

    % CSD
    % preallocate:
    CSD = NaN(size(Data.LFP));

    % loop through trials
    for itri = 1:size(CSD,3)
        curLFP = Data.LFP(:, :, itri);       % current LFP trial
        % curLFP = flipud(curLFP); % it's inverted in the up down
        % orientation
        paddit = padd_linex(curLFP,paddsiz,1);      % create padding
        hammit = filt_Hamm(paddit,hammsiz,1);       % apply hamming filter
        CSD(:,:,itri) = (get_csd(hammit,1,chan_dist,1))*10^3; % make csd
    end

    fullCSD = mean(CSD,3);

    nexttile, imagesc(fullCSD);
    colormap('jet');
    caxis([-0.2 0.2])
    colorbar

    figname = ['CSD_' file '_' stimtype '.fig'];
    cd(homedir); cd figures
    savefig(gcf,figname)   % save CSD fig
    close

end

