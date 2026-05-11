function runFft_NoiseBurstSpont(homedir,params)

% Input:    group name to match *Data.mat in \datastructs, parameters
%           set for CWT analysis, ONLY Spontaneous data used here
% Output:   Runs FFT on spontanous CSD data. figures of
%           layer-wise group FFT -> figures\FFT
%           and eventually stats (TO DO)

% detect data
cd(homedir); 

% Init datastruct to pass out
fftStruct = struct();
count = 1;

% and go
for iGr = 1:length(params.groups)

    Group = params.groups{iGr};
    run([Group '.m']); % brings in animals, channels, Layer, and Cond
    entries = length(animals); %#ok<*USENS>

    for iAn = 1:entries

        if matches(animals{iAn},'MWT16b')
            continue
        end
        load([animals{iAn} '_Data.mat'],'Data'); 

        Aname = animals{iAn};

        disp(['Running for ' Aname])

        % pull the data for this subject
        index = StimIndex({Data.Condition},Cond,iAn,'NoiseBurst');
        if isempty(index)
            continue
        end
    
        % we're combining response to 70, 80, and 90 dB SPL
        curCSD = cat(3,Data(index).sngtrlCSD{6},Data(index).sngtrlCSD{7},Data(index).sngtrlCSD{8});
        
        % because there are noisebursts, we can't have continous data, so
        % fft is going to be taken from each trial and then averaged across
        % trials. The baseline (0:400 ms, overlapped with other trials), 
        % noiseburst (400:500 ms) and post stimulus cortical activity 
        % period (500:1000 ms, most activity within 300 ms so this is 
        % generous) will be removed. We have 500 ms from each trial that
        % will be spontaneous activity within the context of ongoing noise
        % bursts and within 1 second of a noise burst at least 70 dB
        curCSD = curCSD(:,1001:1500,:);

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
            fftcsd = fftcsd ./ (size(curCSD,2)/2); % normalize by half sampling points

            fftStruct(count).group  = Group;
            fftStruct(count).animal = Aname;
            fftStruct(count).layer  = params.layers{iLay};
            fftStruct(count).fft    = {fftcsd};

            count = count + 1;
            
        end % layer
    end % animal
end % group

cd(homedir);cd output
if exist('FFT','dir')
    cd FFT
else
    mkdir('FFT'); cd FFT
end

savename = [params.groups{1} 'v' params.groups{2} '_NoiseBurstSpont_FFT.mat'];
save(savename,'fftStruct')