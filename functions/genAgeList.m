function agelist = genAgeList(grpName,numtrials)

% hard set from the data
ages = [122, 131 136 135 190 177 212 211 208 171 180 184 180 183 199];
subjects = {'VMP02' 'VMP03' 'VMP04' 'VMP05' 'VMP06' 'VMP08' 'PMP01' 'PMP02'...
    'PMP03' 'PMP04' 'PMP05' 'PMP06' 'PMP07' 'PMP08' 'PMP09'};

% match specific age to subject and repmat by trials
if length(numtrials) > 1
    % make a container
    agelist = NaN(1,sum(numtrials));
    count = 1; % sorry dynamacism
    for iSub = 1:length(grpName)
        thisage = ages(matches(subjects,grpName{iSub}));

        agelist(count:count+numtrials(iSub)-1) = repmat(thisage,1,numtrials(iSub));
        count = count + numtrials(iSub);
    end

else
    % make a container
    agelist = NaN(1,length(grpName)*numtrials);
    for iSub = 1:length(grpName)
        thisage = ages(matches(subjects,grpName{iSub}));

        thiscount = (iSub-1)*numtrials+1;
        agelist(thiscount:thiscount+numtrials-1) = repmat(thisage,1,numtrials);
    end
end