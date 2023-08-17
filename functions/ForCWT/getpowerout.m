function Power = getpowerout(SpectData)
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

                holdtrials = holdtrials + supersubWT.scalogram{iTrial};

            end
             meantrials = holdtrials / size(supersubWT,1); % take the mean for this measurement
             powermat   = abs(meantrials) .^ 2; % POWER Calculation - no longer a complex number!
             % bats and mice have hugely different scales of activity (bats
             % are way stronger. Therefore we need to normalize per
             % measurement/penetration. Divide the whole power mat by it's
             % maximum.
             holdmeas(iMeas,:,:) = powermat / mean(mean(powermat));
        end
        if iAn == 1
            Power = holdmeas;
        else
            Power = [Power;holdmeas];
        end
    end
end