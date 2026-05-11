function [sngtrlCSD, AvrecCSD, sngtrlAvrecCSD,...
    AvgRelResCSD, singtrlRelResCSD] = SingleTrialCSD(sngtrlLFP,BL)

% This function filters the raw LFP signal to calculate CSD, AVREC, & RelRes,
% at a single trial level, and in some cases trial-averaged

%% Parameters for CSD filtering
chan_dist = 50; % distance between channels (µm)
kernel    = 450; % 600 is very smooth, 300 is more accurate, 450 is happy medium
kernelxchannel = kernel./chan_dist; % kernel size in terms of number of channels
hammsiz   = kernelxchannel+(rem(kernelxchannel,2)-1)*-1; % linear extrapolation and running avg
paddsiz   = floor(hammsiz/2)+1;

% check other inputs (give the standard BL if not provided)
if ~exist('sngtrlLFP','var')
    error('Excuse me, where is the data?')
end
if ~exist('n_SamplesPreevent','var')
    BL = 399; % baseline or "samples pre-event"
end

% preallocate your outputs
sngtrlCSD       = cell(size(sngtrlLFP,1),size(sngtrlLFP,2));
AvrecCSD        = sngtrlCSD;
sngtrlAvrecCSD  = sngtrlCSD;
AvgRelResCSD    = sngtrlCSD;
singtrlRelResCSD= sngtrlCSD;

%% Generate output
% variable to look through list of LFPs
for irow = 1:size(sngtrlLFP,1)
    for icol = 1:length(sngtrlLFP)

        % channel x time (ms) x trial
        curLFP = sngtrlLFP{irow,icol};

        for itrial = 1:size(curLFP,3)

            curtrial = curLFP(:,:,itrial);
            % correct the baseline based on the baseline
            basecorrtrial = base_corr(curtrial,BL,2);

            % CSD

            paddit = padd_linex(basecorrtrial,paddsiz,1);      % create padding
            hammit = filt_Hamm(paddit,hammsiz,1);       % apply hamming filter
            curCSDtrial = (get_csd(hammit,1,chan_dist,1))*10^3; % make csd
            sngtrlCSD{irow,icol}(:,:,itrial) = curCSDtrial;
            % AvgRecCSD and RelResCSD
            Outputs = get_Harding(curCSDtrial,1);
            % outputs var1 = absolute residual, var2 = average absolute
            % residuals, var3 = relative residuals, var4 = average rectified,
            % var5 = channel-wise relative residuals, var6 = contribution of
            % channels to relative residuals (it's an old script...)

            sngtrlAvrecCSD{irow,icol}(:,itrial)   = Outputs.var4';
            singtrlRelResCSD{irow,icol}(:,itrial) = Outputs.var3';

        end

        AvrecCSD{irow,icol}(:)     = mean(sngtrlAvrecCSD{irow,icol},2);
        AvgRelResCSD{irow,icol}(:) =  mean(singtrlRelResCSD{irow,icol},2);

    end
end

