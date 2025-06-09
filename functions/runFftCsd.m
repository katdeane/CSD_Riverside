function runFftCsd(homedir,params,Condition)

% Input:    group name to match *Data.mat in \datastructs, parameters
%           set for CWT analysis, ONLY Spontaneous data used here
% Output:   Runs FFT on spontanous CSD data. figures of
%           layer-wise group FFT -> figures\FFT
%           and eventually stats (TO DO)

% detect data
cd(homedir); cd datastructs;

% Init datastruct to pass out
fftStructAB = struct(); % absolute (normalized by half sampling points)
fftStructRE = struct(); % relative (normalized by sum of full spectrum)
stcount = 1;

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
            curCSD = Data(index).sngtrlCSD{6};
            % fft is going to be taken from each trial. STP is summed power
            % across stim and background
           
        elseif matches(Condition,'NoiseBurst')
            % pull data for this condition
            index = StimIndex({Data.Condition},Cond,iAn,Condition);
            if isempty(index)
                continue
            end
            % we're going to look through 20-50 dB as that's the main range
            % of pup calls covered 
            % stacked in 1.5 second blocks: 100 ms of NB, 1 second
            % ITI, 400 ms baseline. 
            curCSD = nan(size(Data(index).sngtrlCSD{1},1), size(Data(index).sngtrlCSD{1},2),...
                (size(Data(index).sngtrlCSD{1},3))*4);
            % limit to 50 trials
            for idB = 1:4
                count   = ((idB-1)*50)+1;
                countto = count+49;
                curCSD(:,:,count:countto) = Data(index).sngtrlCSD{idB}(:,:,1:50);
            end
            
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
            curCSD = Data(index).sngtrlCSD{2};
            % we want to focus on clicks, so we'll keep just 200 ms on both
            % sides
            curCSD = curCSD(:,201:2600,:);
        else % pup calls and spontaneous data
            index = StimIndex({Data.Condition},Cond,iAn,Condition);
            if isempty(index)
                continue
            end
            % Spont stacked in 2 second blocks
            % Pupcalls stacked in 25 second blocks
            curCSD = Data(index).sngtrlCSD{1};
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
            chanCSD = curCSD(centerChan,:,:);

            fftcsd = fft(chanCSD);
            fftcsd = squeeze(abs(fftcsd) .^2); % take power
            fftcsdAB = fftcsd ./ (size(curCSD,2)/2); % normalize by half sampling points
            fftcsdRE = (fftcsd ./ nansum(nansum(fftcsd)))*params.sampleRate; % normalize by sum of full power spectrum

            fftStructAB(stcount).group        = Group;
            fftStructAB(stcount).animal       = Aname;
            fftStructAB(stcount).layer        = params.layers{iLay};

            fftStructRE(stcount).group        = Group;
            fftStructRE(stcount).animal       = Aname;
            fftStructRE(stcount).layer        = params.layers{iLay};

            if matches(Condition,'Spontaneous')
                if size(fftcsd,2) < 60
                    continue
                end
                fftStructAB(stcount).fft      = {fftcsdAB(:,1:60)}; % limit to my recording min, 2 min
                fftStructRE(stcount).fft      = {fftcsdRE(:,1:60)}; % limit to my recording min, 2 min
                stcount = stcount + 1;
            else
                fftStructAB(stcount).fft      = {fftcsdAB};
                fftStructRE(stcount).fft      = {fftcsdRE};
                stcount = stcount + 1;
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

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_AB_FFT.mat'];
save(savename,'fftStructAB')
savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_RE_FFT.mat'];
save(savename,'fftStructRE')