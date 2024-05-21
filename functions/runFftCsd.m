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
            % we're combining response to 70, 80, and 90 dB SPL
            curCSD = cat(3,Data(index).sngtrlCSD{6},Data(index).sngtrlCSD{7},Data(index).sngtrlCSD{8});
            % fft is going to be taken from each trial. The baseline 
            % (0:400 ms, overlapped with other trials),
            % noiseburst (400:500 ms) and post stimulus cortical activity
            % period (500:1000 ms, most activity within 300 ms so this is
            % generous) will be removed. We have 500 ms from each trial that
            % will be spontaneous activity within the context of ongoing noise
            % bursts and within 1 second of a noise burst at least 70 dB
            curCSD = curCSD(:,1001:1500,:);
        else % pup calls and spontaneous data
            index = StimIndex({Data.Condition},Cond,iAn,Condition);
            if isempty(index)
                continue
            end
            % stacked in 2 second blocks
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
            fftcsdRE = (fftcsd ./ sum(sum(fftcsd)))*params.sampleRate; % normalize by sum of full power spectrum

            fftStructAB(count).group        = Group;
            fftStructAB(count).animal       = Aname;
            fftStructAB(count).layer        = params.layers{iLay};

            fftStructRE(count).group        = Group;
            fftStructRE(count).animal       = Aname;
            fftStructRE(count).layer        = params.layers{iLay};

            if matches(Condition,'Spontaneous')
                if size(fftcsd,2) < 60
                    continue
                end
                fftStructAB(count).fft      = {fftcsdAB(:,1:60)}; % limit to my recording min, 2 min
                fftStructRE(count).fft      = {fftcsdRE(:,1:60)}; % limit to my recording min, 2 min
                count = count + 1;
            else
                fftStructAB(count).fft      = {fftcsdAB};
                fftStructRE(count).fft      = {fftcsdRE};
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

savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_AB_FFT.mat'];
save(savename,'fftStructAB')
savename = [params.groups{1} 'v' params.groups{2} '_' Condition '_RE_FFT.mat'];
save(savename,'fftStructRE')