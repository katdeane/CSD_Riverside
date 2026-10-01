function MaskCallRatio(homedir,outfold,Groups)
% Adaptation Data - the following response divided by the
% response to the first call. 

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
stimlist = unique(grp1.ClickFreq); % mask levels 0 - 3
grp1name = unique(grp1.Animal);
grp1size = length(grp1name);
grp2name = unique(grp2.Animal);
grp2size = length(grp2name);

% initiate a data table
RatioDat = table('Size',[length(layers)*length(stimlist)*(grp1size+grp2size)*500 7],...
    'VariableTypes', {'string','string','string','double','double','double','double'});

% Name the columns
RatioDat.Properties.VariableNames = ["Group", "Subject", "Layer", "trial",...
    "OrderofCall", "SoundLevel", "RatioPeak"];
ratcount = 1;

% loop through click rates
for ilevel = 1:length(stimlist)

    grp1level = grp1(grp1.ClickFreq == stimlist(ilevel),:);
    grp2level = grp2(grp2.ClickFreq == stimlist(ilevel),:);

    % loop through layers
    for iLay = 1:length(layers)
       
        % pull out current layer
        grp1lay  = grp1level(matches(grp1level.Layer, layers{iLay}),:);
        grp2lay  = grp2level(matches(grp2level.Layer, layers{iLay}),:);

        grp1stak = nan(grp1size,10,50); % 10 repetitions, maximum trials is 50
        grp2stak = nan(grp2size,10,50);

        % stack groups for pics
        for iSub = 1:grp1size
            % single trial needs to be sorted
            sgl1sub = grp1lay(matches(grp1lay.Animal,grp1name{iSub}),:);
            for itrial = 1:length(unique(sgl1sub.trial))
                if itrial <= 50 % just in case more than 50 were taken
                    grp1stak(iSub,:,itrial) = sgl1sub(sgl1sub.trial == itrial,:).BasePeak';
                end
            end
        end
        for iSub = 1:grp2size
            % single trial needs to be sorted
            sgl2sub = grp2lay(matches(grp2lay.Animal,grp2name{iSub}),:);
            for itrial = 1:length(unique(sgl2sub.trial))
                if itrial <= 50 % just in case more than 50 were taken
                    grp2stak(iSub,:,itrial) = sgl2sub(sgl2sub.trial == itrial,:).BasePeak';
                end
            end
        end

        % Divide the responses by the 1st peak response
        grp1dat = grp1stak./grp1stak(:,1,:);
        grp2dat = grp2stak./grp2stak(:,1,:);

        % now we just have to stack it back into a table for R stats
        % unfortunately we're carrying all calls through, so x 10
        for iSub = 1:grp1size
            for iCall = 1:10
                % each is 50 trials
                RatioDat.Group(ratcount:ratcount+49)     = repmat(Groups(1),50,1);
                RatioDat.Subject(ratcount:ratcount+49)   = repmat(grp1name(iSub),50,1);
                RatioDat.Layer(ratcount:ratcount+49)     = repmat(layers(iLay),50,1);
                RatioDat.trial(ratcount:ratcount+49)     = 1:50;
                RatioDat.SoundLevel(ratcount:ratcount+49)  = ones(50,1)*stimlist(ilevel);
                RatioDat.RatioPeak(ratcount:ratcount+49)   = squeeze(grp1dat(iSub,iCall,:));
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
                RatioDat.SoundLevel(ratcount:ratcount+49)  = ones(50,1)*stimlist(ilevel);
                RatioDat.RatioPeak(ratcount:ratcount+49)   = squeeze(grp2dat(iSub,iCall,:));
                RatioDat.OrderofCall(ratcount:ratcount+49) = ones(50,1)*iCall;
                ratcount = ratcount + 50;
            end
        end
       
    end
end
cd(outfold); cd TracePeaks
writetable(RatioDat,[Groups{1} 'v' Groups{2} '_MaskCallAdaptation.csv']);
cd(homedir)