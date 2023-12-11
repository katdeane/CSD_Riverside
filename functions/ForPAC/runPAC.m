function runPAC(homedir,Group,Condition,whichsig)
% So with this script we'll calculate the PAC. It won't do the Tort et al.
% thing we're used to (MI and so on, with Kulblack-Leibler diverg.).
% Rather, we'll make it a bit rougher on the data by applying what Kikuchi
% et al (from Petkovs lab) did in their Plos Bio paper from 2017. The
% surrogate here is by shuffling across trial, plus accounting from the
% phase clustering that arises from having non-uniform phase distros in
% non-sinusoidal waveforms (see van Driel et al. 2015, from Michael X.
% Cohen's lab).
%
% This is the exact same as the original one, but I'll do the surrogate
% anlysis with parallel computing. We might need a function for that, in
% order to effectively use parfeval, but surely this will run perfectly
%
% Francisco Garcia-Rosales wrote this script on 19.07.01.

dbstop if error

if ~exist('whichsig','var')
    whichsig = 'CSD'; % other option is 'CSD'
end

% group specific info

BL = 400;
% condition specific info
[stimList, ~, stimDur, stimITI, ~] = ...
    StimVariablePAC(Condition,1);
% timeAxis = BL + stimDur + stimITI; % time axis for visualization
timeaxis = 1:BL+stimDur+stimITI; % time of permutation comparison

% global info
fs = 1000;
% subtract mean across trials
trial_mean_sub = 1;
% number of repetitions for surrogate 
numrep_surr = 200; % 500 preferred end value

% f bands used for phase calculation. Phase of low couple to amp of high
fbands_phase = [ 1 3; 3 5; 5 7; 7 9; 9 11; 11 13; 13 15]; % every 2 Hz with a bandwidth of 2 Hz
fbands_amp( :, 1 ) = (25 : 5 : 95); % every 5 Hz with a bandwidth of 10 Hz
fbands_amp( :, 2 ) = (35 : 5 : 105);

% parameters for line smoothing step
params2rmlinesc.tapers = [2 3]; % windows orthogonal to one another and 
% multiplies win to time series, calculate fft of each window
% independant from one another, reduces noise in power calculation.
params2rmlinesc.Fs = fs;
            
% bring in group info
run([Group '.m']) % brings in animals, Layer, Cond, channels

% how many rows could we potentially have?
allocate = length(animals) * numel(stimList) * 32 * size(fbands_phase,1) * size(fbands_amp,1);
% 16 is the most amount of measurements per animal
% 32 is the maximum amount of channels possible

% preallocate a table to carry everything
PAC = table('Size', [allocate 10], ...
        'VariableTypes', {'string', 'string','string',...
        'double','double','double','double','double','double','string'},...
        'VariableNames', {'Group','Animal','StimFreq',...
        'phase_from','phase_to','amp_from','amp_to','MI','zMI','LayerColumn'});
count = 1;

% some things for parallel computing
% poolsize = 4;
% parpool( poolsize );
    
for iAn = 1:length(animals)
    
    load([animals{iAn} '_Data.mat'],'Data');
    Aname = animals{iAn};

    disp(['Running for ' Aname])
    
    % initialize some variables
    Nchannels = size(Data(1).(['sngtrl' whichsig]){1},1);

    for iStim = 1:length(stimList)

        disp(['Stimulus: ' num2str(stimList(iStim))])

        index = StimIndex({Data.Condition},Cond,iAn,Condition);
        
        if isempty(index)
            continue
        end

        curData = Data(index).(['sngtrl' whichsig]){iStim};
        sig_noline = cell(1,Nchannels);

        for ich = 1 : Nchannels % with parallel computing is slightly faster
            % squeeze used to get time x trials (e.g. 3020x50) as
            % specified in chronux toolbox
            sigtemp = squeeze(curData(ich,timeaxis,:));
            sig_noline{ich} = rmlinesmovingwinc(sigtemp, [1 .2], 10, params2rmlinesc, 0.05, 'n');
        end

        Ntrials = size(sig_noline{1},2);

        % phase amp coupling
        for iph = 1:size(fbands_phase, 1)

            freq_phase = fbands_phase(iph,:);

            for iamp = 1:size(fbands_amp, 1)

                freq_amp = fbands_amp(iamp,:);

                % -------- PARALLEL COMPUTING STARTS HERE! ---------- %
                temp_MI_within  = nan(Nchannels,1);
                temp_zMI_within = nan(Nchannels,1);


                parfor ich = 1:Nchannels

                    % Pull in the single trial signal per channel (trial x time)
                    sigAC = sig_noline{ich}';
                    % period of whole stimulus
                    whole = BL:BL+fs;

                    % minimize effect of evoked potential
                    if ( trial_mean_sub )
                        sigAC = sigAC - repmat( nanmean( sigAC ), [size(sigAC, 1), 1] );
                    end

                    % return trial-by-trial gamma amplitude and low-freq phase
                    [gamma_amp_AC, low_ph_AC] = utils_get_phaseamp(sigAC, freq_phase, freq_amp, fs);

                    % now comes the easy part... just calculate the PAC with the vector
                    % mean for the amplitudes relative to the phase of the signal.. only
                    % during the stimulus window, please...
                    % calculates biases and subtracts them
                    MI_raw = get_modulation_index( low_ph_AC( :, whole ), gamma_amp_AC( :, whole ) ); % within this channel

                    % now do the trial shuffling surrogate, it's not so hard
                    MI_surr = nan( 1, numrep_surr ); % should look normally distributed based on numrep_surr

                    for rep = 1 : numrep_surr % this is actually the only change for paralle computing
                        MI_surr( rep ) = get_modulation_index( low_ph_AC( randperm(Ntrials), whole ), ...
                            gamma_amp_AC( :, whole ) ); % within this channel
                    end

                    % save the raw MI values
                    temp_MI_within(ich) = MI_raw;

                    % the corrected value
                    temp_zMI_within(ich) = (MI_raw - mean(MI_surr)) ./ std(MI_surr);
                end % channels

                % make the table rows with the calculated data
                countto    = count + Nchannels - 1;
                grouplist  = repmat(Group,[Nchannels,1]);
                animallist = repmat(Aname,[Nchannels,1]);
                tabfrqlist = repmat(stimList(iStim),[Nchannels,1]);
                phaselist  = repmat(freq_phase,[Nchannels,1]);
                amplist    = repmat(freq_amp,[Nchannels,1]);

                % specifically designate layers
                LII = str2num(Layer.II{iAn}); %#ok<*ST2NM>
                LIV = str2num(Layer.IV{iAn});
                LVa = str2num(Layer.Va{iAn});
                LVb = str2num(Layer.Vb{iAn});
                LVI = str2num(Layer.VI{iAn});
                % lay down the layers based on this animal data
                Layrep = cell(Nchannels,1);
                Layrep(LII) = repmat({'II'},length(LII),1);
                Layrep(LIV) = repmat({'IV'},length(LIV),1);
                Layrep(LVa) = repmat({'Va'},length(LVa),1);
                Layrep(LVb) = repmat({'Vb'},length(LVb),1);
                Layrep(LVI) = repmat({'VI'},length(LVI),1);
                % designate center channels
                centII = floor(mean(LII));
                centIV = floor(mean(LIV));
                centVa = floor(mean(LVa));
                centVb = floor(mean(LVb));
                centVI = floor(mean(LVI));
                % add it in
                Layrep{centII} = 'centerII';
                Layrep{centIV} = 'centerIV';
                Layrep{centVa} = 'centerVa';
                Layrep{centVb} = 'centerVb';
                Layrep{centVI} = 'centerVI';

                PAC.Group(count:countto,1)       = grouplist;
                PAC.Animal(count:countto,1)      = animallist;
                PAC.StimFreq(count:countto,1)    = tabfrqlist;
                PAC.phase_from(count:countto,1)  = phaselist(:,1);
                PAC.phase_to(count:countto,1)    = phaselist(:,2);
                PAC.amp_from(count:countto,1)    = amplist(:,1);
                PAC.amp_to(count:countto,1)      = amplist(:,2);
                PAC.MI(count:countto,1)          = temp_MI_within;
                PAC.zMI(count:countto,1)         = temp_zMI_within;
                PAC.LayerColumn(count:countto,1) = Layrep;

                count = count + Nchannels;

            end % amplitude
        end % phase
    end % stimulus
end % animal

% delete pesky extra rows
toDelete = PAC.phase_from == 0;
PAC(toDelete,:) = [];

cd(homedir); cd output;
if exist('PACoutput','dir') == 7
    cd PACoutput
else
    mkdir('PACoutput'),cd PACoutput
end

% save the table
CSVname = [Group '_' Condition '_' whichsig '_PhaseAmpCoupling.csv'];
writetable(PAC,CSVname)

end % function