function Norm_AvrecDat(homedir, figfolder, outfolder, Groups, Condition)
% Data here will be normalized to the first Noise Burst in the awake
% condition, and to the first Noise Burst at 70 dB in the Anesthetized
% Condition. All data is saved out of the Avrec_Layers.m script: Norm

% a second normalization condition will be to the trial-averaged baseline
% (1:400 ms) of each stimulus: Base

%% open all of the data we'll need
for iGro = 1:length(Groups)
    % normalize everything to the NB condition
    load([Groups{iGro} '_NoiseBurst_NormTo.mat'],'PeakofAvgCSD');

    % get the traces out for Group Avrec Stacking the normalized data
    load([Groups{iGro} '_' Condition '_AvrecCSDAll.mat'],'AvrecCSDAll');
    NormAvrecCSDAll = AvrecCSDAll;
    BaseAvrecCSDAll = AvrecCSDAll;
    % stim x layer x subject

    % open the detected peaks from single trials
    AvrecPeak = readtable([Groups{iGro} '_' Condition '_AVRECPeak.csv']);

    % list of subjects:
    sublist = unique(AvrecPeak.Animal); % if this is NOT nummerically ordered, pull from group metadata!!!!
    run([Groups{iGro} '.m']); clear channels Cond Layer % brings in animal list
    theseSub = find(matches(animals,sublist)); % this matches the correct peak amp
                                               % to avreccsdall data

    % Add normalized data to table
    newTabCol = zeros(height(AvrecPeak), 1);
    AvrecPeak.("NormPeak") = newTabCol;
    AvrecPeak.("BasePeak") = newTabCol;

    % var to move through new column
    countstart = 1;
    subcount   = 1;

    %% run it
    % loop through subjects to normalize by peak of NB
    for iSub = theseSub
        
        thisNormTo = PeakofAvgCSD{iSub};

        % traces
        for iStim = 1:size(NormAvrecCSDAll,1)
            for iLay = 1:size(NormAvrecCSDAll,2)
                % noise burst normalization
                NormAvrecCSDAll{iStim,iLay,iSub} = NormAvrecCSDAll{iStim,iLay,iSub} ./ thisNormTo;
            end
        end

        % single trial detected peaks;
        % find the rows associated with this subject, we are stacking
        % numerically so we can just add on top, no need to try and determine
        % exact rows (table is subject-ordered)
        countend   = countstart+sum(matches(AvrecPeak.Animal, sublist{subcount}))-1;
        AvrecPeak.NormPeak(countstart:countend) = AvrecPeak.PeakAmp(countstart:countend) ./ thisNormTo;
        countstart = countend+1;
        subcount   = subcount+1;
    end % subject

    countstart = 1;
    subcount   = 1;
    % loop through subjects to normalize by baseline - this had to be
    % seperate because empty data was being stored in the traces but not
    % the peak output
    for iSub = theseSub
        Baselist = 0;
        % traces
        for iStim = 1:size(NormAvrecCSDAll,1)
            for iLay = 1:size(NormAvrecCSDAll,2)
                % baseline normalization
                thistrace = BaseAvrecCSDAll{iStim,iLay,iSub};
                if isempty(thistrace)
                    continue
                end
                thisBaseto = nanmean(nanmean(squeeze(thistrace(:,1:400,:))));
                BaseAvrecCSDAll{iStim,iLay,iSub} = BaseAvrecCSDAll{iStim,iLay,iSub} ./ thisBaseto;
                % stack for the single trial peak detection normalization
                if matches(Condition,'ShortCall') || matches(Condition,'MaskCall')
                    addtolist = repmat(thisBaseto, (size(thistrace,3)*10),1);
                elseif matches(Condition,'ClickTrain')
                    [stimList, ~, ~, ~, ~] = StimVariable(Condition,1,'Awake');
                    addtolist = repmat(thisBaseto, (size(thistrace,3)*(stimList(iStim)*2)),1);
                elseif matches(Condition,'NoiseBurst2pt5Hz')
                    addtolist = repmat(thisBaseto, (size(thistrace,3)*3),1);
                elseif matches(Condition,'gapASSR')
                    addtolist = repmat(thisBaseto, (size(thistrace,3)*6),1);
                else
                    addtolist = repmat(thisBaseto, size(thistrace,3),1);
                end
                Baselist = vertcat(Baselist, addtolist);
            end
        end

        if sum(Baselist) == 0 % empty data
            continue
        end
        % single trial detected peaks;
        % find the rows associated with this subject, we are stacking
        % numerically so we can just add on top, no need to try and determine
        % exact rows (table is subject-ordered)
        countend   = countstart+sum(matches(AvrecPeak.Animal, sublist{subcount}))-1;
        AvrecPeak.BasePeak(countstart:countend) = AvrecPeak.PeakAmp(countstart:countend) ./ Baselist(2:end);
        countstart = countend+1;
        subcount   = subcount+1;
    end % subject

    % save it out

    % write second files out
    cd([figfolder '\Group_Avrec']);
    save([Groups{iGro} '_' Condition '_NORMAvrecCSDAll'],'NormAvrecCSDAll');

    % REWRITE with new column, no changes to other variables
    cd([outfolder '\TracePeaks']);
    writetable(AvrecPeak,[Groups{iGro} '_' Condition '_AVRECPeak.csv'])

end % group


cd(homedir)