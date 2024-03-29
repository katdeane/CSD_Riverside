function runFftCsd(homedir,params,Condition)

% Input:    group name to match *Data.mat in \datastructs, parameters
%           set for CWT analysis, ONLY Spontaneous data used here
% Output:   Runs FFT on spontanous CSD data. figures of
%           layer-wise group FFT -> figures\FFT
%           and eventually stats (TO DO)

% detect data
cd(homedir); cd datastructs;

% Init datastruct to pass out
fftStruct = struct();
count = 1;

% and go
for iGr = 1:length(params.groups)

    Group = params.groups{iGr};
    run([Group '.m']); % brings in animals, channels, Layer, and Cond
    entries = length(animals);

    for iAn = 1:entries
        load([animals{iAn} '_Data.mat'],'Data'); 

        Aname = animals{iAn};

        disp(['Running for ' Aname])

        % pull the data for this subject
        index = StimIndex({Data.Condition},Cond,iAn,Condition);
        if isempty(index)
            continue
        end

        curCSD = Data(index).sngtrlCSD{1};
        % restack the trials (revert to original data)
        stcklen = size(curCSD,2);
        spontCSD = NaN(size(curCSD,1), stcklen*size(curCSD,3));
        for iStack = 1:size(curCSD,3)
            spontCSD(:,(1+((iStack-1)*stcklen)):(stcklen+((iStack-1)*stcklen))) ...
                = curCSD(:,:,iStack);
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
            chanCSD = curCSD(centerChan,:);

            fftcsd = fft(chanCSD);
            fftcsd = abs(fftcsd) .^2 ; % take power
            fftcsd = fftcsd ./ sum(fftcsd);

            fftStruct(count).group        = Group;
            fftStruct(count).animal       = Aname;
            fftStruct(count).layer        = params.layers{iLay};
            if matches(Condition,'Spontaneous')
                fftStruct(count).fft      = {fftcsd(1:120000)}; % limit to my recording min, 2 min
            else
                fftStruct(count).fft      = {fftcsd};
            end
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

savename = [params.groups{1} 'v' params.groups{2} '_FFT.mat'];
save(savename,'fftStruct')