function ClickTrainRatio_3grp(homedir,outfolder,Groups)
% Adaptation Data - the fully adapted response (at 1 second) divided by the
% maximum peak of response (within the first 100 ms). If desired, rate of
% adaptation (tau) could be added.

cd(homedir);

% single trial data
grp1 = readtable([Groups{1} '_ClickTrain_AVRECPeak.csv']);
grp2 = readtable([Groups{2} '_ClickTrain_AVRECPeak.csv']);
grp3 = readtable([Groups{3} '_ClickTrain_AVRECPeak.csv']);

% set some stuff up
layers   = {'All','II','IV','Va','Vb','VI'};
stimlist = unique(grp1.ClickFreq);
grp1name = unique(grp1.Animal);
grp1size = length(grp1name);
grp2name = unique(grp2.Animal);
grp2size = length(grp2name);
grp3name = unique(grp3.Animal);
grp3size = length(grp3name);

% initiate a data table
RatioDat = table('Size',[length(layers)*length(stimlist)*(grp1size+grp2size+grp3size)*50 6],...
    'VariableTypes', {'string','string','string','double','double','double'});

% Name the columns
RatioDat.Properties.VariableNames = ["Group", "Subject", "Layer", "trial",...
    "ClickFreq", "RatioPeak"];
ratcount = 1;

% loop through click rates
for iRate = 1:length(stimlist)

    grp1rate = grp1(grp1.ClickFreq == stimlist(iRate),:);
    grp2rate = grp2(grp2.ClickFreq == stimlist(iRate),:);
    grp3rate = grp3(grp3.ClickFreq == stimlist(iRate),:);

    % loop through layers
    for iLay = 1:length(layers)
       
        % pull out current layer
        grp1lay  = grp1rate(matches(grp1rate.Layer, layers{iLay}),:);
        grp2lay  = grp2rate(matches(grp2rate.Layer, layers{iLay}),:);
        grp3lay  = grp3rate(matches(grp3rate.Layer, layers{iLay}),:);

        grp1stak = nan(grp1size,stimlist(iRate)*2,50); % maximum trials is 50
        grp2stak = nan(grp2size,stimlist(iRate)*2,50);
        grp3stak = nan(grp3size,stimlist(iRate)*2,50);

        % stack groups for pics
        for iSub = 1:grp1size
            % single trial needs to be sorted
            sgl1sub = grp1lay(matches(grp1lay.Animal,grp1name{iSub}),:);
            for itrial = 1:length(unique(sgl1sub.trial))
                if itrial <= 50 % just in case more than 50 were taken
                    grp1stak(iSub,:,itrial) = sgl1sub(sgl1sub.trial == itrial,:).PeakAmp';
                end
            end
        end
        for iSub = 1:grp2size
            % single trial needs to be sorted
            sgl2sub = grp2lay(matches(grp2lay.Animal,grp2name{iSub}),:);
            for itrial = 1:length(unique(sgl2sub.trial))
                if itrial <= 50 % just in case more than 50 were taken
                    grp2stak(iSub,:,itrial) = sgl2sub(sgl2sub.trial == itrial,:).PeakAmp';
                end
            end
        end
        for iSub = 1:grp3size
            % single trial needs to be sorted
            sgl3sub = grp3lay(matches(grp3lay.Animal,grp3name{iSub}),:);
            for itrial = 1:length(unique(sgl3sub.trial))
                if itrial <= 50 % just in case more than 50 were taken
                    grp3stak(iSub,:,itrial) = sgl3sub(sgl3sub.trial == itrial,:).PeakAmp';
                end
            end
        end

        % We're going to find the onset response
        % i.e.: max peak click by subject & by trial

        % find the max peaks within 100 ms
        ISI = 1000/stimlist(iRate); % e.g. 5 Hz = 200 ms
        if ISI >= 100 % 5 or 10 Hz
            grp1onset = grp1stak(:,1,:);
            grp2onset = grp2stak(:,1,:);
            grp3onset = grp3stak(:,1,:);
        else % > 10 Hz
            grp1onset = grp1stak(:,1:floor(100/ISI),:);
            grp1onset = nanmax(grp1onset,[],2);
            grp2onset = grp2stak(:,1:floor(100/ISI),:);
            grp2onset = nanmax(grp2onset,[],2);
            grp3onset = grp3stak(:,1:floor(100/ISI),:);
            grp3onset = nanmax(grp3onset,[],2);
        end

        % here we're going to calculate the ratio of peak response at 1 s
        % first just divide the whole dataset by our onset peak
        grp1ratio = grp1stak./grp1onset; 
        grp2ratio = grp2stak./grp2onset; 
        grp3ratio = grp3stak./grp3onset; 

        % pull the peak response close to 1 s (5 Hz = 5th click)
        grp1dat = grp1ratio(:,stimlist(iRate),:);
        grp2dat = grp2ratio(:,stimlist(iRate),:);
        grp3dat = grp3ratio(:,stimlist(iRate),:);

        % now we just have to stack it back into a table for R stats
        for iSub = 1:grp1size
            % each is 50 trials
            RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(1),50,1);
            RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp1name(iSub),50,1);
            RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
            RatioDat.trial(ratcount:ratcount+49)     = 1:50;
            RatioDat.ClickFreq(ratcount:ratcount+49) = ones(50,1)*stimlist(iRate);
            RatioDat.RatioPeak(ratcount:ratcount+49) = squeeze(grp1dat(iSub,:,:));
            ratcount = ratcount + 50;
        end
        for iSub = 1:grp2size
            % each is 50 trials
            RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(2),50,1);
            RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp2name(iSub),50,1);
            RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
            RatioDat.trial(ratcount:ratcount+49)     = 1:50;
            RatioDat.ClickFreq(ratcount:ratcount+49) = ones(50,1)*stimlist(iRate);
            RatioDat.RatioPeak(ratcount:ratcount+49) = squeeze(grp2dat(iSub,:,:));
            ratcount = ratcount + 50;
        end
        for iSub = 1:grp3size
            % each is 50 trials
            RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(3),50,1);
            RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp3name(iSub),50,1);
            RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
            RatioDat.trial(ratcount:ratcount+49)     = 1:50;
            RatioDat.ClickFreq(ratcount:ratcount+49) = ones(50,1)*stimlist(iRate);
            RatioDat.RatioPeak(ratcount:ratcount+49) = squeeze(grp3dat(iSub,:,:));
            ratcount = ratcount + 50;
        end
       
    end
end
cd(outfolder); cd TracePeaks
writetable(RatioDat,[Groups{1} 'v' Groups{2} 'v' Groups{3} '_ClickTrainAdaptation.csv']);
cd(homedir)