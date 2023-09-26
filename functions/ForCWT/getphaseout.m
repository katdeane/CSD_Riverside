function Phase = getphaseout(SpectData)
%Stack the individual animals' data (animal#x54x600)
subjects = unique(SpectData.animal);
Phase = zeros(length(subjects),size(SpectData.scalogram{1},1),size(SpectData.scalogram{1},2));

for iSu = 1:length(subjects)

    subWT = SpectData(contains(SpectData.animal,subjects{iSu}),:);

    % for phase plots/permutations, we have to calculate it per
    % trial and then rectified and average
    holdtrials = zeros(size(subWT.scalogram{1},1),size(subWT.scalogram{1},2));
    for iTrial = 1:size(subWT,1)

        if subWT.scalogram{iTrial}(1,1) == 0
            continue % skip the 0 trial scalograms
        end
        curTrial   = subWT.scalogram{iTrial};
        phasemat   = curTrial./abs(curTrial); % PHASE Calculation per trial
        holdtrials = holdtrials + phasemat;  % add trials together
    end

    % phase is between 0 and 1 so it does not need to be normalized
    Phase(iSu,:,:) = abs(holdtrials / size(subWT,1)); % take the abs mean for this measurement
end