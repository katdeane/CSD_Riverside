function Pipeline_mTRF(homedir,Groups)

%% Notes:

% Groups = {'PMP' 'VMP'}
% layer IV currently hard-coded through. May loop through later

% mTRF = Multivariate Temporal Response Function :)
% contrast TRF (VESPA) = Lalor 2006 The Vespa: ...
% global field power (GFP) = constitutes a reference-independent measure of
%   response strength across the entire scalp at each time lag (Lehmann and
%   Skrandies, 1980; Murray et al., 2008)

% lambda is the regularization (0.05 - 1)

% time lag:
% In the context of speech for example, s(t) could be a measure of the
% speech envelope at each moment in time and r(t, n) could be the
% corresponding EEG response at channel n. The range of time lags over
% which to calculate w(τ, n) might be that typically used to capture the
% cortical response components of an ERP, e.g., −100–400 ms. The resulting
% value of the TRF at −100 ms, would index the relationship between the
% speech envelope and the neural response 100 ms earlier (obviously this
% should have an amplitude of zero), whereas the TRF at 100 ms would index
% how a unit change in the amplitude of the speech envelope would affect
% the EEG 100 ms later (Lalor et al., 2009).

% spectrostim data comes from generateSpectroStim.m and only needs to be run
% once for this entire process
load('spectrostim.mat','spectrostim','fband')

for iGr = 1:length(Groups)

    run([Groups{iGr} '.m']) % brings in animals, channels, Layer, Cond

    for iSub = 1:length(animals) %#ok<*USENS>

        % subject specific data
        subname  = animals{iSub};
        thisfile = Cond.Pupcall30{iSub}{1};

        if isempty(thisfile)
            continue
        end

        filename = [subname '_' thisfile '_LFP'];
        subchan  = str2num(channels{iSub});

        Lay.II = str2num(Layer.II{iSub});
        Lay.IV = str2num(Layer.IV{iSub});
        Lay.Va = str2num(Layer.Va{iSub});
        Lay.Vb = str2num(Layer.Vb{iSub});
        Lay.VI = str2num(Layer.VI{iSub});

        disp(['For ' filename])

        %% Pull data and cut out a training set (first 3 stim trials)

        [StimIn, DataIn] = FileReaderLFP(filename,subchan);

        % scale data to be in range with Stim
        DataIn = DataIn / 100;

        % detect when signal crosses threshold
        threshold = 0.09;
        location  = threshold <= StimIn;
        crossover = diff(location);
        onsets    = find(crossover == 1);
        offsets   = find(crossover == -1);
        % Sanity Check:
        % % onsets(2) - offsets(1) = 5012
        % % offsets(1) - onsets(1) = 25063
        % % onsets(2) - onsets(1)  = 30075

        % 500 ms before and after ~2 min of stim presentation
        trainresp = DataIn(:,onsets(1)-500:offsets(3)+500)';

        %% size stim per subject and cut to same length as training data

        % string it together for this subject
        trainstim = zeros(size(StimIn,2),10);
        for istim = 1:length(onsets)
            trainstim(onsets(istim):onsets(istim)+length(spectrostim)-1,:) = spectrostim;
        end

        trainstim = trainstim(onsets(1)-500:offsets(3)+500,:);
        fs = 1000;

        %% Cross-validation
        % this let's us select the best lamda (i.e. ridge value). We want the
        % highest correlation r and lowest error err. This will be tested on the
        % first 2 minutes of data. Leave 1 out with the folds (split)

        disp('Cross validating to select λ')
        lambda = 0.1:0.1:1.5; % range to test
        % narrowly on stim response relavent time 
        tmin   = 0;
        tmax   = 200;

        statsm = mTRFcrossval(trainstim,trainresp,fs,1,tmin,tmax,lambda,'method','ridge',...
            'split',5,'zeropad',0,'corr','Pearson');

        % mean across trials and channels to avoid overfitting
        pearR = mean(mean(statsm.r,3),1);
        pearE = mean(mean(statsm.err,3),1);

        % find max r / min MSE
        pearmax = find(pearR == max(pearR));
        targetl = lambda(pearmax);

        % plot them
        Statplot = tiledlayout('flow');
        title(Statplot,'Cross-Validation')

        nexttile
        plot(pearR,'-o')
        xticks(1:length(lambda))
        xticklabels(lambda)
        xlabel('λ')
        ylabel('Pearsons r')

        nexttile
        plot(pearE,'-o')
        xticklabels(lambda)
        xlabel('λ')
        ylabel('MSE')

        % the pearson's r on each channel at the best lambda
        thislambda = squeeze(mean(statsm.r(:,pearmax,:),1));

        nexttile
        imagesc(thislambda)
        colormap bone
        colorbar
        ylabel('channel')
        xlabel(['λ = ' num2str(targetl)])

        sgtitle('Layer IV')
        cd(homedir);cd figures; cd mTRF
        h = gcf;
        savefig(h,[subname '_ModelCrossVal'])
        close(h)

        %% Train model with target lambda

        disp('Training the model')
        % get a wider scope for the actual model
        tmin = -50;
        tmax = 400;

        modelm = mTRFtrain(trainstim,trainresp,fs,1,tmin,tmax,targetl,'method','ridge',...
            'split',3,'zeropad',0);
        % low frequency broadband model
        stim = sum(trainstim(:,1:3),2);
        % Compute model weights
        model1 = mTRFtrain(stim,trainresp,fs,1,tmin,tmax,targetl,'method','ridge',...
            'split',3,'zeropad',0);
        % high frequency broadband model
        stim = sum(trainstim(:,4:7),2);
        % Compute model weights
        model2 = mTRFtrain(stim,trainresp,fs,1,tmin,tmax,targetl,'method','ridge',...
            'split',3,'zeropad',0);

        % take center channel of layer IV
        thischan = ceil(mean(Lay.IV));

        % Plot TRF 
        figure;
        subplot(3,2,1), mTRFplot(modelm,'mtrf','all',thischan,[tmin,tmax]);
        title('Speech STRF (Fz)'), ylabel('Frequency band [Hz]'), xlabel('')
        yticks(1:10)
        yticklabels({[num2str(round(fband(1,1))) '-' num2str(round(fband(end,1)))] ...
            [num2str(round(fband(1,2))) '-' num2str(round(fband(end,2)))] ...
            [num2str(round(fband(1,3))) '-' num2str(round(fband(end,3)))] ...
            [num2str(round(fband(1,4))) '-' num2str(round(fband(end,4)))] ...
            [num2str(round(fband(1,5))) '-' num2str(round(fband(end,5)))] ...
            [num2str(round(fband(1,6))) '-' num2str(round(fband(end,6)))] ...
            [num2str(round(fband(1,7))) '-' num2str(round(fband(end,7)))] ...
            [num2str(round(fband(1,8))) '-' num2str(round(fband(end,8)))] ...
            [num2str(round(fband(1,9))) '-' num2str(round(fband(end,9)))] ...
            [num2str(round(fband(1,10))) '-' num2str(round(fband(end,10)))]})

        % Plot GFP
        subplot(3,2,2), mTRFplot(modelm,'mgfp','all','all',[tmin,tmax]);
        title('Global Field Power'), xlabel('')

        % Plot TRF
        subplot(3,2,3), mTRFplot(model1,'trf','all',thischan,[tmin,tmax]);
        title('Speech TRF 7-14 kHz'), ylabel('Amplitude (a.u.)'), xlabel('')

        % Plot GFP
        subplot(3,2,4), mTRFplot(model1,'gfp','all','all',[tmin,tmax]);
        title('Global Power 7-14 kHz'), xlabel('')

        % Plot TRF
        subplot(3,2,5), mTRFplot(model2,'trf','all',thischan,[tmin,tmax]);
        title('Speech TRF 14-37 kHz'), ylabel('Amplitude (a.u.)')

        % Plot GFP
        subplot(3,2,6), mTRFplot(model2,'gfp','all','all',[tmin,tmax]);
        title('Global Power 14-37 kHz')

        sgtitle('Layer IV')
        cd(homedir);cd figures; cd mTRF
        h = gcf;
        savefig(h,[subname '_ModelTraining_LayerIV'])
        close(h)

        %% Time to predict the future

        disp('Predicting')
        % now the last 47 trials for testing the prediction of the model
        % (20 trials for VMP02, so 17)
        realresp = DataIn(:,onsets(3)-500:offsets(end)+500)';

        realstim = zeros(size(StimIn,2),10);
        for istim = 1:length(onsets)
            realstim(onsets(istim):onsets(istim)+length(spectrostim)-1,:) = spectrostim;
        end
        realstim = realstim(onsets(3)-500:offsets(end)+500,:);

        split = length(onsets) - 3;
        
        % model made from full spectrum (multi)
        [predm,statsm] = mTRFpredict(realstim,realresp,modelm,'split',split,'zeropad',0);
        % low broadband stim
        flatstim = sum(realstim(:,1:3),2);
        % model on fundemental
        [pred1,stats1] = mTRFpredict(flatstim,realresp,model1,'split',split,'zeropad',0);
        % low broadband stim
        flatstim = sum(realstim(:,4:7),2);
        % model on harmonics
        [pred2,stats2] = mTRFpredict(flatstim,realresp,model2,'split',split,'zeropad',0);

        % stack the splits back together
        fullpredm   = vertcat(predm{:});
        scaledpredm = fullpredm*10; % just for visualization, err and r are unaffected
        fullpred1   = vertcat(pred1{:});
        scaledpred1 = fullpred1*10; % just for visualization, err and r are unaffected
        fullpred2   = vertcat(pred2{:});
        scaledpred2 = fullpred2*10; % just for visualization, err and r are unaffected

        % average the r and error across splits
        errm  = mean(statsm.err,1)';
        rcorm = mean(statsm.r,1)';
        err1  = mean(stats1.err,1)';
        rcor1 = mean(stats1.r,1)';
        err2  = mean(stats2.err,1)';
        rcor2 = mean(stats2.r,1)';

        % plot a window of the predicted and real data 
        % plot multi results
        nexttile
        plot(mean(scaledpredm(1000:2000,:),2))
        hold on
        plot(mean(realresp(1000:2000,:),2))
        legend({['λ ' num2str(targetl)] 'LFP'})
        xlabel('Time [ms]')
        ylabel('µV')

        nexttile
        imagesc(errm)
        colorbar
        ylabel('channel')
        xlabel('Error')

        nexttile
        imagesc(rcorm)
        colorbar
        ylabel('channel')
        xlabel('Error')

        % plot fundemental Hz results
        nexttile
        plot(mean(scaledpred1(1000:2000,:),2))
        hold on
        plot(mean(realresp(1000:2000,:),2))
        legend({['λ ' num2str(targetl)] 'LFP'})
        xlabel('Time [ms]')
        ylabel('µV')

        nexttile
        imagesc(err1)
        colorbar
        ylabel('channel')
        xlabel('Error')

        nexttile
        imagesc(rcor1)
        colorbar
        ylabel('channel')
        xlabel('r')

        % plot harmonic Hz results
        nexttile
        plot(mean(scaledpred2(1000:2000,:),2))
        hold on
        plot(mean(realresp(1000:2000,:),2))
        legend({['λ ' num2str(targetl)] 'LFP'})
        xlabel('Time [ms]')
        ylabel('µV')

        nexttile
        imagesc(err2)
        colorbar
        ylabel('channel')
        xlabel('r')

        nexttile
        imagesc(rcor2)
        colorbar
        ylabel('channel')
        xlabel('r')

        h = gcf;
        savefig(h,[subname '_ModelPredict'])
        close(h)

        % time to save stuff for stats outputs
        meanerrm = mean(errm);
        meanrm   = mean(rcorm);
        meanerr1 = mean(err1);
        meanr1   = mean(rcor1);
        meanerr2 = mean(err2);
        meanr2   = mean(rcor2);

        save([subname 'Statblock.mat'],'meanerrm','errm','meanrm','rcorm','targetl',...
            'meanerr1','err1','meanr1','rcor1','meanerr2','err2','meanr2','rcor2')

    end % subject
end % group

collectTRFStats
p = runTRFttest;
save('TRFp.m','p')
cd(homedir)
