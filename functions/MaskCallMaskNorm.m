function MaskCallMaskNorm(homedir,outfold,Groups)
% Normalize every 

% NOTE: this is currently being used for the California mouse awake group
% where the baseline normalized peak data is used (BasePeak)

% NOTE: 50 trials is being enforced in this script but the data is usually
% 42 trials

cd(homedir);

% single trial data
grp1 = readtable([Groups{1} '_MaskCall_AVRECPeak.csv']);
grp2 = readtable([Groups{2} '_MaskCall_AVRECPeak.csv']);
% set some stuff up
layers   = {'All','II','IV','Va','Vb','VI'};
% stimlist = unique(grp1.ClickFreq); % mask levels 0 - 3
grp1name = unique(grp1.Animal);
grp1size = length(grp1name);
grp2name = unique(grp2.Animal);
grp2size = length(grp2name);

% initiate a data table
RatioDat = table('Size',[size(grp1,1)+size(grp2,1) 7],...
    'VariableTypes', {'string','string','string','double','double','double','double'});

% Name the columns
RatioDat.Properties.VariableNames = ["Group", "Subject", "Layer", "trial",...
    "OrderofCall", "SoundLevel", "MaskNormPeak"];
ratcount = 1;

% find the value to normalize to per call in the mask call stimulus
% take the mean of each call in the 0 mask level per layer


% loop through layers
for iLay = 1:length(layers)

    % pull out current layer
    grp1lay  = grp1(matches(grp1.Layer, layers{iLay}),:);
    grp2lay  = grp2(matches(grp2.Layer, layers{iLay}),:);

    % pull the 0 level out
    grp1_0level = grp1lay(grp1lay.ClickFreq == 0,:);
    grp2_0level = grp2lay(grp2lay.ClickFreq == 0,:);
    grp1_1level = grp1lay(grp1lay.ClickFreq == 1,:);
    grp2_1level = grp2lay(grp2lay.ClickFreq == 1,:);
    grp1_2level = grp1lay(grp1lay.ClickFreq == 2,:);
    grp2_2level = grp2lay(grp2lay.ClickFreq == 2,:);
    grp1_3level = grp1lay(grp1lay.ClickFreq == 3,:);
    grp2_3level = grp2lay(grp2lay.ClickFreq == 3,:);

    grp1_0stak = nan(grp1size,10,50); % 10 repetitions, maximum trials is 50
    grp2_0stak = nan(grp2size,10,50);
    grp1_1stak = nan(grp1size,10,50); 
    grp2_1stak = nan(grp2size,10,50);
    grp1_2stak = nan(grp1size,10,50); 
    grp2_2stak = nan(grp2size,10,50);
    grp1_3stak = nan(grp1size,10,50); 
    grp2_3stak = nan(grp2size,10,50);

    % stack groups for pics
    for iSub = 1:grp1size
        % single trial needs to be sorted
        sgl1_0sub = grp1_0level(matches(grp1_0level.Animal,grp1name{iSub}),:);
        sgl1_1sub = grp1_1level(matches(grp1_1level.Animal,grp1name{iSub}),:);
        sgl1_2sub = grp1_2level(matches(grp1_2level.Animal,grp1name{iSub}),:);
        sgl1_3sub = grp1_3level(matches(grp1_3level.Animal,grp1name{iSub}),:);
        for itrial = 1:length(unique(sgl1_0sub.trial))
            if itrial <= 50 % just in case more than 50 were taken
                grp1_0stak(iSub,:,itrial) = sgl1_0sub(sgl1_0sub.trial == itrial,:).BasePeak';
                grp1_1stak(iSub,:,itrial) = sgl1_1sub(sgl1_1sub.trial == itrial,:).BasePeak';
                grp1_2stak(iSub,:,itrial) = sgl1_2sub(sgl1_2sub.trial == itrial,:).BasePeak';
                grp1_3stak(iSub,:,itrial) = sgl1_3sub(sgl1_3sub.trial == itrial,:).BasePeak';
            end
        end
    end
    for iSub = 1:grp2size
        % single trial needs to be sorted
        sgl2_0sub = grp2_0level(matches(grp2_0level.Animal,grp2name{iSub}),:);
        sgl2_1sub = grp2_1level(matches(grp2_1level.Animal,grp2name{iSub}),:);
        sgl2_2sub = grp2_2level(matches(grp2_2level.Animal,grp2name{iSub}),:);
        sgl2_3sub = grp2_3level(matches(grp2_3level.Animal,grp2name{iSub}),:);
        for itrial = 1:length(unique(sgl2_0sub.trial))
            if itrial <= 50 % just in case more than 50 were taken
                grp2_0stak(iSub,:,itrial) = sgl2_0sub(sgl2_0sub.trial == itrial,:).BasePeak';
                grp2_1stak(iSub,:,itrial) = sgl2_1sub(sgl2_1sub.trial == itrial,:).BasePeak';
                grp2_2stak(iSub,:,itrial) = sgl2_2sub(sgl2_2sub.trial == itrial,:).BasePeak';
                grp2_3stak(iSub,:,itrial) = sgl2_3sub(sgl2_3sub.trial == itrial,:).BasePeak';
            end
        end
    end

    % mean the 0 level stim across trials (sub x call) from (sub x call x trial)
    mean1_0level = mean(grp1_0stak,3);
    mean2_0level = mean(grp2_0stak,3);

    % divide each trial per subject per call by trial-mean over levels
    grp1_0dat = grp1_0stak./mean1_0level;
    grp2_0dat = grp2_0stak./mean2_0level;
    grp1_1dat = grp1_1stak./mean1_0level;
    grp2_1dat = grp2_1stak./mean2_0level;
    grp1_2dat = grp1_2stak./mean1_0level;
    grp2_2dat = grp2_2stak./mean2_0level;
    grp1_3dat = grp1_3stak./mean1_0level;
    grp2_3dat = grp2_3stak./mean2_0level;

    % this data is now normalized by subject to it's mean response per call
    % over trials

    % now we just have to stack it back into a table for R stats
    % unfortunately we're carrying all calls through, so x 10
    % we also have to stack the levels back in
    grp1list = {grp1_0dat grp1_1dat grp1_2dat grp1_3dat};
    grp2list = {grp2_0dat grp2_1dat grp2_2dat grp2_3dat};
    for iLevel = 1:4
        for iSub = 1:grp1size
            for iCall = 1:10
                % each is 50 trials
                RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(1),50,1);
                RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp1name(iSub),50,1);
                RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
                RatioDat.trial(ratcount:ratcount+49)     = 1:50;
                RatioDat.SoundLevel(ratcount:ratcount+49)    = ones(50,1)*iLevel-1;
                RatioDat.MaskNormPeak(ratcount:ratcount+49) = squeeze(grp1list{iLevel}(iSub,iCall,:));
                RatioDat.OrderofCall(ratcount:ratcount+49) = ones(50,1)*iCall;
                ratcount = ratcount + 50;
            end
        end
        for iSub = 1:grp2size
            for iCall = 1:10
                % each is 50 trials
                RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(2),50,1);
                RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp2name(iSub),50,1);
                RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
                RatioDat.trial(ratcount:ratcount+49)     = 1:50;
                RatioDat.SoundLevel(ratcount:ratcount+49)    = ones(50,1)*iLevel-1;
                RatioDat.MaskNormPeak(ratcount:ratcount+49) = squeeze(grp2list{iLevel}(iSub,iCall,:));
                RatioDat.OrderofCall(ratcount:ratcount+49) = ones(50,1)*iCall;
                ratcount = ratcount + 50;
            end
        end
    end

end
cd(outfold); cd TracePeaks
writetable(RatioDat,[Groups{1} 'v' Groups{2} '_MaskCallNormalization.csv']);
cd(homedir)