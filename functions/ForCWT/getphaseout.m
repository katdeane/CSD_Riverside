 function Phase = getphaseout(SpectData)
    %Stack the individual animals' data (animal#x54x600)
    animals = unique(SpectData.animal);
    for iAn = 1:length(animals)
        subWT = SpectData(contains(SpectData.animal,animals{iAn}),:);
        measurements = unique(subWT.measurement);
        holdmeas = zeros(length(measurements),size(subWT.scalogram{1},1),size(subWT.scalogram{1},2));
        for iMeas = 1:length(measurements)
            supersubWT = subWT(matches(subWT.measurement,measurements{iMeas}),:);
            % for power plots/permutations, we can average before taking the
            % power, it's the same. But the measurement trials need to be
            % averaged before the group can be averaged either way
            holdtrials = zeros(size(supersubWT.scalogram{1},1),size(supersubWT.scalogram{1},2));
            for iTrial = 1:size(supersubWT,1)

                if supersubWT.scalogram{iTrial}(1,1) == 0
                    continue % skip the 0 trial scalograms
                end
                curTrial = supersubWT.scalogram{iTrial};
                phasemat  = curTrial./abs(curTrial); % PHASE Calculation per trial
                holdtrials = holdtrials + phasemat;

            end
             holdmeas(iMeas,:,:) = abs(holdtrials / size(supersubWT,1)); % take the abs mean for this measurement
             % phase is between 0 and 1 so it does not need to be normalized
        end
        if iAn == 1
            Phase = holdmeas;
        else
            Phase = [Phase;holdmeas];
        end
    end
end