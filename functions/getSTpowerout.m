function Power = getpowerout(SpectData)

%Stack the individual animals' data (animal#x54xtimeaxis)
subjects = unique(SpectData.animal);
Power    = zeros(length(subjects),size(SpectData.scalogram{1},1),size(SpectData.scalogram{1},2));

for iSu = 1:length(subjects)
    subWT = SpectData(contains(SpectData.animal,subjects{iSu}),:);
    % for power plots/permutations, we can average before taking the
    % power, it's the same.
    holdtrials = zeros(size(subWT.scalogram{1},1),size(subWT.scalogram{1},2));
    for iTrial = 1:size(subWT,1)

        if subWT.scalogram{iTrial}(1,1) == 0
            continue % skip the 0 trial scalograms
        end

        powermat   = abs(subWT.scalogram{iTrial}) .^ 2; % POWER Calculation - no longer a complex number!

        holdtrials = holdtrials + powermat;

    end
    meantrials = holdtrials / size(subWT,1); % take the mean for this measurement
    

    % Option to normalize power here, divide the whole power mat by it's mean:
    % powermat = powermat / mean(mean(powermat));
    
    % place it in the container 
    
    Power(iSu,:,:) = meantrials;
end

