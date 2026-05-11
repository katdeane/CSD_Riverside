function PCal_NP_HighLowANOVA(homedir,Groups, high, low)



cd(homedir); 

% averaged trial data
% grp1dat = readtable([Groups{1} '_NoiseBurst_AVG_AVRECPeak.csv']);
% grp2dat = readtable([Groups{2} '_NoiseBurst_AVG_AVRECPeak.csv']);
grp1dat = readtable([Groups{1} '_NoiseBurst_AVRECPeak.csv']);
grp2dat = readtable([Groups{2} '_NoiseBurst_AVRECPeak.csv']);

% we have to normalize within the boundaries of high/low and layers
avg1high = grp1dat(grp1dat.ClickFreq == high,:);
avg2high = grp2dat(grp2dat.ClickFreq == high,:);

avg1low = grp1dat(grp1dat.ClickFreq == low,:);
avg2low = grp2dat(grp2dat.ClickFreq == low,:);

II1high = avg1high(matches(avg1high.Layer, 'II'),:);
IV1high = avg1high(matches(avg1high.Layer, 'IV'),:);
Va1high = avg1high(matches(avg1high.Layer, 'Va'),:);
Vb1high = avg1high(matches(avg1high.Layer, 'Vb'),:);
VI1high = avg1high(matches(avg1high.Layer, 'VI'),:);

II2high = avg2high(matches(avg2high.Layer, 'II'),:);
IV2high = avg2high(matches(avg2high.Layer, 'IV'),:);
Va2high = avg2high(matches(avg2high.Layer, 'Va'),:);
Vb2high = avg2high(matches(avg2high.Layer, 'Vb'),:);
VI2high = avg2high(matches(avg2high.Layer, 'VI'),:);

II1low = avg1low(matches(avg1low.Layer, 'II'),:);
IV1low = avg1low(matches(avg1low.Layer, 'IV'),:);
Va1low = avg1low(matches(avg1low.Layer, 'Va'),:);
Vb1low = avg1low(matches(avg1low.Layer, 'Vb'),:);
VI1low = avg1low(matches(avg1low.Layer, 'VI'),:);

II2low = avg2low(matches(avg2low.Layer, 'II'),:);
IV2low = avg2low(matches(avg2low.Layer, 'IV'),:);
Va2low = avg2low(matches(avg2low.Layer, 'Va'),:);
Vb2low = avg2low(matches(avg2low.Layer, 'Vb'),:);
VI2low = avg2low(matches(avg2low.Layer, 'VI'),:);

% take the natural log of everything
% normalize by the mean of the first group
II1high_norm = log(II1high.PeakAmp) ./ nanmean(log(II1high.PeakAmp));
IV1high_norm = log(IV1high.PeakAmp) ./ nanmean(log(IV1high.PeakAmp));
Va1high_norm = log(Va1high.PeakAmp) ./ nanmean(log(Va1high.PeakAmp));
Vb1high_norm = log(Vb1high.PeakAmp) ./ nanmean(log(Vb1high.PeakAmp));
VI1high_norm = log(VI1high.PeakAmp) ./ nanmean(log(VI1high.PeakAmp));

II2high_norm = log(II2high.PeakAmp) ./ nanmean(log(II1high.PeakAmp));
IV2high_norm = log(IV2high.PeakAmp) ./ nanmean(log(IV1high.PeakAmp));
Va2high_norm = log(Va2high.PeakAmp) ./ nanmean(log(Va1high.PeakAmp));
Vb2high_norm = log(Vb2high.PeakAmp) ./ nanmean(log(Vb1high.PeakAmp));
VI2high_norm = log(VI2high.PeakAmp) ./ nanmean(log(VI1high.PeakAmp));

II1low_norm = log(II1low.PeakAmp) ./ nanmean(log(II1low.PeakAmp));
IV1low_norm = log(IV1low.PeakAmp) ./ nanmean(log(IV1low.PeakAmp));
Va1low_norm = log(Va1low.PeakAmp) ./ nanmean(log(Va1low.PeakAmp));
Vb1low_norm = log(Vb1low.PeakAmp) ./ nanmean(log(Vb1low.PeakAmp));
VI1low_norm = log(VI1low.PeakAmp) ./ nanmean(log(VI1low.PeakAmp));

II2low_norm = log(II2low.PeakAmp) ./ nanmean(log(II1low.PeakAmp));
IV2low_norm = log(IV2low.PeakAmp) ./ nanmean(log(IV1low.PeakAmp));
Va2low_norm = log(Va2low.PeakAmp) ./ nanmean(log(Va1low.PeakAmp));
Vb2low_norm = log(Vb2low.PeakAmp) ./ nanmean(log(Vb1low.PeakAmp));
VI2low_norm = log(VI2low.PeakAmp) ./ nanmean(log(VI1low.PeakAmp));

% stack data back up
y = vertcat(II1high_norm, IV1high_norm, Va1high_norm, Vb1high_norm, VI1high_norm,...
    II2high_norm, IV2high_norm, Va2high_norm, Vb2high_norm, VI2high_norm,...
    II1low_norm, IV1low_norm, Va1low_norm, Vb1low_norm, VI1low_norm,...
    II2low_norm, IV2low_norm, Va2low_norm, Vb2low_norm, VI2low_norm);
Group = vertcat(II1high.Group,IV1high.Group,Va1high.Group,Vb1high.Group,VI1high.Group,...
    II2high.Group,IV2high.Group,Va2high.Group,Vb2high.Group,VI2high.Group,...
    II1low.Group,IV1low.Group,Va1low.Group,Vb1low.Group,VI1low.Group,...
    II2low.Group,IV2low.Group,Va2low.Group,Vb2low.Group,VI2low.Group);
Condition = vertcat(II1high.ClickFreq,IV1high.ClickFreq,Va1high.ClickFreq,Vb1high.ClickFreq,VI1high.ClickFreq,...
    II2high.ClickFreq,IV2high.ClickFreq,Va2high.ClickFreq,Vb2high.ClickFreq,VI2high.ClickFreq,...
    II1low.ClickFreq,IV1low.ClickFreq,Va1low.ClickFreq,Vb1low.ClickFreq,VI1low.ClickFreq,...
    II2low.ClickFreq,IV2low.ClickFreq,Va2low.ClickFreq,Vb2low.ClickFreq,VI2low.ClickFreq);
Layer = vertcat(II1high.Layer,IV1high.Layer,Va1high.Layer,Vb1high.Layer,VI1high.Layer,...
    II2high.Layer,IV2high.Layer,Va2high.Layer,Vb2high.Layer,VI2high.Layer,...
    II1low.Layer,IV1low.Layer,Va1low.Layer,Vb1low.Layer,VI1low.Layer,...
    II2low.Layer,IV2low.Layer,Va2low.Layer,Vb2low.Layer,VI2low.Layer);

% Set up anova. Factors: group, layer, click-freq
p = anovan(y,{Group Condition Layer},'model','full','varnames',{'Group','Condition','Layer'});

save('ANOVA_NB_HighLow_Sgl_log.mat','p')
