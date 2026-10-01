function ITPC_MaskNorm(homedir,outfold,Groups)
% Normalize every 

% NOTE: this is currently being used for the California mouse awake group
% where the baseline normalized peak data is used (BasePeak)

% NOTE: 50 trials is being enforced in this script but the data is usually
% 42 trials

cd(homedir);

% single trial data
grp1 = readtable([Groups{1} '_MaskCall_ITPCmean.csv']);
grp2 = readtable([Groups{2} '_MaskCall_ITPCmean.csv']);
% set some stuff up
grp1 = rmmissing(grp1); grp2 = rmmissing(grp2);
layers   = {'II','IV','Va','Vb','VI'};
grp1name = unique(grp1.Subject);
grp1size = length(grp1name);
grp2name = unique(grp2.Subject);
grp2size = length(grp2name);

% initiate a data table
RatioDat = table('Size',[size(grp1,1)+size(grp2,1) 10],...
    'VariableTypes', {'string','string','double','string','double','double','double',...
    'double','double','double'});

% Name the columns
RatioDat.Properties.VariableNames = ["Group", "Subject", "Stimulus", "Layer", ...
    "Theta_mean", "Alpha_mean", "Beta_mean", "GammaLow_mean", "GammaHigh_mean", ...
    "Order_Presentation"];
ratcount = 1;

% find the value to normalize to per call in the mask call stimulus
% take the mean of each call in the 0 mask level per layer


% loop through layers
for iLay = 1:length(layers)

    % pull out current layer
    grp1lay  = grp1(matches(grp1.Layer, layers{iLay}),:);
    grp2lay  = grp2(matches(grp2.Layer, layers{iLay}),:);

    % pull the 0 level out
    grp1_0level = grp1lay(grp1lay.Stimulus == 0,:);
    grp2_0level = grp2lay(grp2lay.Stimulus == 0,:);
    grp1_1level = grp1lay(grp1lay.Stimulus == 1,:);
    grp2_1level = grp2lay(grp2lay.Stimulus == 1,:);
    grp1_2level = grp1lay(grp1lay.Stimulus == 2,:);
    grp2_2level = grp2lay(grp2lay.Stimulus == 2,:);
    grp1_3level = grp1lay(grp1lay.Stimulus == 3,:);
    grp2_3level = grp2lay(grp2lay.Stimulus == 3,:);

    % this is already set up nicely to get (subject x call)
    % so already divide each level by the 0th level

    grp1_div   = reshape(grp1_0level.Theta_mean,10,grp1size)';
    grp2_div   = reshape(grp2_0level.Theta_mean,10,grp2size)';
    grp1_0_th  = reshape(grp1_0level.Theta_mean,10,grp1size)'./grp1_div;
    grp2_0_th  = reshape(grp2_0level.Theta_mean,10,grp2size)'./grp2_div;
    grp1_1_th  = reshape(grp1_1level.Theta_mean,10,grp1size)'./grp1_div;
    grp2_1_th  = reshape(grp2_1level.Theta_mean,10,grp2size)'./grp2_div;
    grp1_2_th  = reshape(grp1_2level.Theta_mean,10,grp1size)'./grp1_div;
    grp2_2_th  = reshape(grp2_2level.Theta_mean,10,grp2size)'./grp2_div;
    grp1_3_th  = reshape(grp1_3level.Theta_mean,10,grp1size)'./grp1_div;
    grp2_3_th  = reshape(grp2_3level.Theta_mean,10,grp2size)'./grp2_div;

    grp1_div   = reshape(grp1_0level.Alpha_mean,10,grp1size)';
    grp2_div   = reshape(grp2_0level.Alpha_mean,10,grp2size)';
    grp1_0_al  = reshape(grp1_0level.Alpha_mean,10,grp1size)'./grp1_div;
    grp2_0_al  = reshape(grp2_0level.Alpha_mean,10,grp2size)'./grp2_div;
    grp1_1_al  = reshape(grp1_1level.Alpha_mean,10,grp1size)'./grp1_div;
    grp2_1_al  = reshape(grp2_1level.Alpha_mean,10,grp2size)'./grp2_div;
    grp1_2_al  = reshape(grp1_2level.Alpha_mean,10,grp1size)'./grp1_div;
    grp2_2_al  = reshape(grp2_2level.Alpha_mean,10,grp2size)'./grp2_div;
    grp1_3_al  = reshape(grp1_3level.Alpha_mean,10,grp1size)'./grp1_div;
    grp2_3_al  = reshape(grp2_3level.Alpha_mean,10,grp2size)'./grp2_div;

    grp1_div   = reshape(grp1_0level.Beta_mean,10,grp1size)';
    grp2_div   = reshape(grp2_0level.Beta_mean,10,grp2size)';
    grp1_0_be  = reshape(grp1_0level.Beta_mean,10,grp1size)'./grp1_div;
    grp2_0_be  = reshape(grp2_0level.Beta_mean,10,grp2size)'./grp2_div;
    grp1_1_be  = reshape(grp1_1level.Beta_mean,10,grp1size)'./grp1_div;
    grp2_1_be  = reshape(grp2_1level.Beta_mean,10,grp2size)'./grp2_div;
    grp1_2_be  = reshape(grp1_2level.Beta_mean,10,grp1size)'./grp1_div;
    grp2_2_be  = reshape(grp2_2level.Beta_mean,10,grp2size)'./grp2_div;
    grp1_3_be  = reshape(grp1_3level.Beta_mean,10,grp1size)'./grp1_div;
    grp2_3_be  = reshape(grp2_3level.Beta_mean,10,grp2size)'./grp2_div;

    grp1_div   = reshape(grp1_0level.GammaLow_mean,10,grp1size)';
    grp2_div   = reshape(grp2_0level.GammaLow_mean,10,grp2size)';
    grp1_0_gl  = reshape(grp1_0level.GammaLow_mean,10,grp1size)'./grp1_div;
    grp2_0_gl  = reshape(grp2_0level.GammaLow_mean,10,grp2size)'./grp2_div;
    grp1_1_gl  = reshape(grp1_1level.GammaLow_mean,10,grp1size)'./grp1_div;
    grp2_1_gl  = reshape(grp2_1level.GammaLow_mean,10,grp2size)'./grp2_div;
    grp1_2_gl  = reshape(grp1_2level.GammaLow_mean,10,grp1size)'./grp1_div;
    grp2_2_gl  = reshape(grp2_2level.GammaLow_mean,10,grp2size)'./grp2_div;
    grp1_3_gl  = reshape(grp1_3level.GammaLow_mean,10,grp1size)'./grp1_div;
    grp2_3_gl  = reshape(grp2_3level.GammaLow_mean,10,grp2size)'./grp2_div;

    grp1_div   = reshape(grp1_0level.GammaHigh_mean,10,grp1size)';
    grp2_div   = reshape(grp2_0level.GammaHigh_mean,10,grp2size)';
    grp1_0_gh  = reshape(grp1_0level.GammaHigh_mean,10,grp1size)'./grp1_div;
    grp2_0_gh  = reshape(grp2_0level.GammaHigh_mean,10,grp2size)'./grp2_div;
    grp1_1_gh  = reshape(grp1_1level.GammaHigh_mean,10,grp1size)'./grp1_div;
    grp2_1_gh  = reshape(grp2_1level.GammaHigh_mean,10,grp2size)'./grp2_div;
    grp1_2_gh  = reshape(grp1_2level.GammaHigh_mean,10,grp1size)'./grp1_div;
    grp2_2_gh  = reshape(grp2_2level.GammaHigh_mean,10,grp2size)'./grp2_div;
    grp1_3_gh  = reshape(grp1_3level.GammaHigh_mean,10,grp1size)'./grp1_div;
    grp2_3_gh  = reshape(grp2_3level.GammaHigh_mean,10,grp2size)'./grp2_div;

    % this data is now normalized by subject to it's response per call at
    % the 0th level

    % now we just have to stack it back into a table for R stats
    % unfortunately we're carrying all calls through, so x 10
    % we also have to stack the levels back in
    grp1_th = {grp1_0_th, grp1_1_th, grp1_2_th, grp1_3_th};
    grp2_th = {grp2_0_th, grp2_1_th, grp2_2_th, grp2_3_th};
    grp1_al = {grp1_0_al, grp1_1_al, grp1_2_al, grp1_3_al};
    grp2_al = {grp2_0_al, grp2_1_al, grp2_2_al, grp2_3_al};
    grp1_be = {grp1_0_be, grp1_1_be, grp1_2_be, grp1_3_be};
    grp2_be = {grp2_0_be, grp2_1_be, grp2_2_be, grp2_3_be};
    grp1_gl = {grp1_0_gl, grp1_1_gl, grp1_2_gl, grp1_3_gl};
    grp2_gl = {grp2_0_gl, grp2_1_gl, grp2_2_gl, grp2_3_gl};
    grp1_gh = {grp1_0_gh, grp1_1_gh, grp1_2_gh, grp1_3_gh};
    grp2_gh = {grp2_0_gh, grp2_1_gh, grp2_2_gh, grp2_3_gh};
    for iLevel = 1:4
        for iSub = 1:grp1size
            for iCall = 1:10
                RatioDat.Group(ratcount)              = Groups(1);
                RatioDat.Subject(ratcount)            = grp1name(iSub);
                RatioDat.Stimulus(ratcount)           = iLevel-1;
                RatioDat.Layer(ratcount)              = layers(iLay);
                RatioDat.Order_Presentation(ratcount) = iCall;

                RatioDat.Theta_mean(ratcount)     = grp1_th{iLevel}(iSub,iCall);
                RatioDat.Alpha_mean(ratcount)     = grp1_al{iLevel}(iSub,iCall);
                RatioDat.Beta_mean(ratcount)      = grp1_be{iLevel}(iSub,iCall);
                RatioDat.GammaLow_mean(ratcount)  = grp1_gl{iLevel}(iSub,iCall);
                RatioDat.GammaHigh_mean(ratcount) = grp1_gh{iLevel}(iSub,iCall);
                
                ratcount = ratcount + 1;
            end
        end
        for iSub = 1:grp2size
            for iCall = 1:10
                RatioDat.Group(ratcount)              = Groups(2);
                RatioDat.Subject(ratcount)            = grp2name(iSub);
                RatioDat.Stimulus(ratcount)           = iLevel-1;
                RatioDat.Layer(ratcount)              = layers(iLay);
                RatioDat.Order_Presentation(ratcount) = iCall;

                RatioDat.Theta_mean(ratcount)     = grp2_th{iLevel}(iSub,iCall);
                RatioDat.Alpha_mean(ratcount)     = grp2_al{iLevel}(iSub,iCall);
                RatioDat.Beta_mean(ratcount)      = grp2_be{iLevel}(iSub,iCall);
                RatioDat.GammaLow_mean(ratcount)  = grp2_gl{iLevel}(iSub,iCall);
                RatioDat.GammaHigh_mean(ratcount) = grp2_gh{iLevel}(iSub,iCall);
                
                ratcount = ratcount + 1;
            end
        end
    end

end
cd(outfold); cd ITPCmean
writetable(RatioDat,[Groups{1} 'v' Groups{2} '_MaskCallNormalization_ITPC.csv']);
cd(homedir)