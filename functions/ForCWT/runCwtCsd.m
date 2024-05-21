function runCwtCsd(homedir,Group,params,type)

% Input:    group name to match *Data.mat in \datastructs, parameters
%           set for CWT analysis
% Output:   Runs CWT analysis using the Wavelet toolbox. figures of
%           animal-wise scalograms -> figures\Spectral_MagPlots
%           and group table output to be formatted to full scalograms.mat 
% Note:     I'm setting a hard cap at 50 trials 

% set some variables
BL = 399;

% load group info to know how many noisebursts there are
run([Group '.m']); % brings in animals, channels, Layer, and Cond
subjects = length(animals); %#ok<*USENS>

cd(homedir); cd output;
if exist('WToutput','dir') == 7
    cd WToutput
else
    mkdir('WToutput'),cd WToutput
end

% and go
for iAn = 1:subjects
    tic
    % load the animal data in
    load([animals{iAn} '_Data.mat'],'Data');
    Aname = animals{iAn};

    disp(['Running for ' Aname])
    
    for iCond = 1:length(params.condList)
        
        disp(['Condition: ' params.condList{iCond}])

        % % Init datastruct to pass out
        % wtStruct = struct();
        % correction = 0;
        
        % pull the variables and index for this condition
        [stimList, thisUnit, stimDur, stimITI, ~] = ...
            StimVariable(params.condList{iCond},1,type);
        timeAxis = BL + stimDur + stimITI; 
        index = StimIndex({Data.Condition},Cond,iAn,params.condList{iCond});
        
        if isempty(index)
            continue
        end

        for iStim = 1:length(stimList)
           
            % Init datastruct to pass out
            wtStruct = struct();
            correction = 0;

            disp(['For ' num2str(stimList(iStim)) ' ' thisUnit])
            curCSD = Data(index).sngtrlCSD{iStim};
            
           for iLay = 1:length(params.layers)
               
               disp(['Layer ' params.layers{iLay}])
               % For constructing position of recording relative to layer, use ceil() to
               % assign the next number and base all other numbers on that. This
               % means that odd numbers (e.g. 7) will use exact middle (e.g. 4), while
               % even (e.g. 6) returns middle/slightly lower (e.g. 3).
               curLay = str2num(Layer.(params.layers{iLay}){iAn});
               if isempty(curLay) % for missing layers
                   continue
               end
               centerChan = curLay(ceil(length(curLay)/2));
               
               for iTrial = 1:50

                   if iTrial > size(curCSD,3)
                       % need a way to account for less than 50 trials so
                       % it doesn't save an empty row and change doubles to
                       % cells in the table
                       correction = correction + 1;
                       continue
                   end

                   % current working data 
                   csdChan = squeeze(curCSD(centerChan,1:timeAxis,iTrial));

                   % nan chunks are very small, we're going to allow them
                   % through as zeros instead of rejecting the trial
                   csdChan(isnan(csdChan)) = 0;
                   % if isnan(sum(csdChan))
                   %     continue
                   % end
                   % Set the cwt frequency limits
                   params.frequencyLimits(1) = max(params.frequencyLimits(1),...
                       cwtfreqbounds(numel(csdChan),params.sampleRate,...
                       'TimeBandWidth',params.timeBandWidth));

                   [WT,F] = cwt(csdChan,params.sampleRate, ...
                       'VoicesPerOctave',params.voicesPerOctave, ...
                       'TimeBandWidth',params.timeBandWidth, ...
                       'FrequencyLimits',params.frequencyLimits);

                   if ~exist('cone','var')
                       cone = F;
                       save('Cone.mat','cone');
                   end

                   count = iTrial + (iLay-1)*50  - correction;
                   wtStruct(count).scalogram    = WT;
                   wtStruct(count).group        = Group;
                   wtStruct(count).animal       = Aname;
                   wtStruct(count).condition    = params.condList{iCond};
                   wtStruct(count).stim         = stimList(iStim);
                   wtStruct(count).layer        = params.layers{iLay};
                   wtStruct(count).trial        = iTrial;
                   wtStruct(count).freq         = F;

                   clear WT 

               end % trial
           end % layer

           wtTable = struct2table(wtStruct);
           save([Aname '_' params.condList{iCond} '_' num2str(stimList(iStim)) '_WT.mat'],'wtTable');
        end % stimulus
        % wtTable = struct2table(wtStruct);
        % save([Aname '_' params.condList{iCond} '_WT.mat'],'wtTable');
    end % condition
    toc
end % animal 

        