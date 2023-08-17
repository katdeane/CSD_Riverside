function runCwtCsd(Group,params,homedir,freqlist)

% Input:    group name to match *Data.mat in \Dynamic_CSD\DATA, parameters
%           set for CWT analysis, home director
% Output:   Runs CWT analysis using the Wavelet toolbox. figures of
%           animal-wise scalograms -> Dynamic_CSD\figs\Spectral_MagPlots
%           and group table output to be formatted to full scalograms.mat 

% group specific info
if contains(Group,'CIC')
    datfolder = 'mouse_output';
    timeaxis  = 1:1201; % bl 200, 1000 tone
elseif contains(Group,'FAFAC')
    datfolder = 'bat_output';
    timeaxis  = 311:1511; % the last 200 of 510 bl, 1000 ms of tone
else
    error('If this is a new group, please work it through the pipeline')
end

cd(homedir); cd(datfolder);

% Generates variables called animals and Layer
if contains(Group,'CIC')
    input = dir('*byFreq.mat');
else
    input = dir('FAFAC*.mat');
end
entries = length(input);

cd(homedir); cd Comparison;
if exist('WToutput','dir') == 7
    cd WToutput
else
    mkdir('WToutput'),cd WToutput
end


for iAn = 1:entries
    tic
    load(input(iAn).name,'Data');
    
    if contains(Group,'CIC')
        Aname = input(iAn).name(1:5);
    else
        Aname = input(iAn).name(1:7);
    end
    disp(['Running for ' Aname])
    
    nummeas = length(Data(1).SngTrl_CSD);
    
    for iFreq = 1:length(freqlist)
        % Init datastruct to pass out
        wtStruct = struct();
        count = 1;
        
        disp(['Stimulus Frequency ' freqlist{iFreq} ' Hz'])
        thisFreq = contains(({Data.ClickFreq}),freqlist{iFreq});
        
        for iMeas = 1:nummeas
            
            disp(['Measurement ' num2str(iMeas)])
            curCSD = Data(thisFreq).SngTrl_CSD{iMeas};
            
           for iLay = 1:length(params.layers)
               
               disp(['Layer ' params.layers{iLay}])
               % For constructing position of recording relative to layer, use ceil() to
               % assign the next number and base all other numbers on that. This
               % means that odd numbers (e.g. 7) will use exact middle (e.g. 4), while
               % even (e.g. 6) returns middle/slightly lower (e.g. 3).
               
               % Format here forces the use of eval to get channel locs
               curChan = Data(thisFreq).(['Lay' params.layers{iLay}]){iMeas};
               if isempty(curChan) % for missing layers
                   continue
               end
               centerChan = curChan(ceil(length(curChan)/2));
               theseChans = curChan-centerChan;
               % Select only center 3 channels
               curChan = curChan(theseChans >=-1 & theseChans <=1);
               
               for itrial = 1:size(curCSD,3)
                   
                   hold_cwts = zeros(54,length(timeaxis));
                   
                   % Repeat over channels
                for iChan = 1:length(curChan)
                    
                    csdChan = squeeze(curCSD(curChan(iChan),timeaxis,itrial));
                    
                    if isnan(sum(csdChan))
                        continue
                    end
                    % Limit the cwt frequency limits
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
                    
                    % to get average of channels: add each and divide after loop
                    hold_cwts = hold_cwts + WT;
                    
                end % channel
                
                WT = hold_cwts/3;
           
                wtStruct(count).scalogram    = WT;
                wtStruct(count).group        = Group;
                wtStruct(count).animal       = Aname;
                wtStruct(count).measurement  = num2str(iMeas);
                wtStruct(count).layer        = params.layers{iLay};
                wtStruct(count).trial        = itrial;
                wtStruct(count).freq         = F;
                                
                count = count + 1;
                clear WT hold_cwts
                
               end % trial
           end % layer
        end % measurement / penetration 
        wtTable = struct2table(wtStruct);
        save([Aname '_' freqlist{iFreq} '_WT.mat'],'wtTable');
    end % frequency, 5 or 40
    toc
end % animal 

        