function runFftLfp(homedir,params,Condition)

% Input:    group name to match *Data.mat in \datastructs, parameters
%           set for CWT analysis, ONLY Spontaneous data used here
% Output:   Runs FFT on spontanous LFP data. figures of
%           layer-wise group FFT -> figures\FFT
%           and eventually stats (TO DO)

% detect data
cd(homedir); cd datastructs;

% Init datastruct to pass out
fftStructLFPAB = struct(); % absolute (normalized by half sampling points)
fftStructLFPRE = struct(); % relative (normalized by sum of full spectrum)
count = 1;

% and go
for iGr = 1:length(params.groups)

    Group = params.groups{iGr};
    run([Group '.m']); % brings in animals, channels, Layer, and Cond
    entries = length(animals); %#ok<*USENS>

    for iAn = 1:entries
        load([animals{iAn} '_Data.mat'],'Data'); 
 
        Aname = animals{iAn};

        disp(['Running for ' Aname])

        if matches(Condition, 'NoiseBurstSpont')
            % pull the data for this subject
            index = StimIndex({Data.Condition},Cond,iAn,'NoiseBurst');
            if isempty(index)
                continue
            end
            % we're taking just the response to 70 dB
            curLFP = Data(index).sngtrlLFP{6};
            % fft is going to be taken from each trial. STP is summed power
            % across stim and background
           
        elseif matches(Condition,'ClickTrain')
            % pull data for this condition
            index = StimIndex({Data.Condition},Cond,iAn,Condition);
            if isempty(index)
                continue
            end
            % we're going to look at the 5 Hz condition only, which is the
            % closest approximate to pup call rate
            % stacked in 3.4 second blocks: 2 seconds of clicks, 1 second
            % ITI, 400 ms baseline. 
            curLFP = Data(index).sngtrlLFP{5};
            % we want to focus on clicks, so we'll keep just 200 ms on both
            % sides
            curLFP = curLFP(:,201:2600,:);
        else % pup calls and spontaneous data
            index = StimIndex({Data.Condition},Cond,iAn,Condition);
            if isempty(index)
                continue
            end
            % Spont stacked in 2 second blocks
            % Pupcalls stacked in 25 second blocks
            curLFP = Data(index).sngtrlLFP{1};
        end

        % pull out layers
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
            chanLFP = curLFP(centerChan,:,:);

            fftLFP = fft(chanLFP);
            fftLFP = squeeze(abs(fftLFP) .^2); % take power
            fftLFPAB = fftLFP ./ (size(curLFP,2)/2); % normalize by half sampling points
            fftLFPRE = (fftLFP ./ sum(sum(fftLFP)))*params.sampleRate; % normalize by sum of full power spectrum

            fftStructLFPAB(count).group        = Group;
            fftStructLFPAB(count).animal       = Aname;
            fftStructLFPAB(count).layer        = params.layers{iLay};

            fftStructLFPRE(count).group        = Group;
            fftStructLFPRE(count).animal       = Aname;
            fftStructLFPRE(count).layer        = params.layers{iLay};

            if matches(Condition,'Spontaneous')
                if size(fftLFP,2) < 60
                    continue
                end
                fftStructLFPAB(count).fft      = {fftLFPAB(:,1:60)}; % limit to my recording min, 2 min
                fftStructLFPRE(count).fft      = {fftLFPRE(:,1:60)}; % limit to my recording min, 2 min
                count = count + 1;
            else
                fftStructLFPAB(count).fft      = {fftLFPAB};
                fftStructLFPRE(count).fft      = {fftLFPRE};
                count = count + 1;
            end
            
        end % layer
    end % animal
end % group

cd(homedir);cd output
if exist('FFT','dir')
    cd FFT
else
    mkdir('FFT'); cd FFT
end

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_AB_FFTLFP.mat'];
save(savename,'fftStructLFPAB')
savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_RE_FFTLFP.mat'];
save(savename,'fftStructLFPRE')