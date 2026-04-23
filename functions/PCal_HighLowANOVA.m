function PCal_HighLowANOVA(homedir,Groups,call_high,call_low)

cd(homedir); 

% grp1dat = readtable([Groups{1} '_Pupcall30_AVG_AVRECPeak.csv']);
% grp2dat = readtable([Groups{2} '_Pupcall30_AVG_AVRECPeak.csv']);
grp1dat = readtable([Groups{1} '_Pupcall30_AVRECPeak.csv']);
grp2dat = readtable([Groups{2} '_Pupcall30_AVRECPeak.csv']);

% we have to normalize within the boundaries of high/low and layers
II1dat = grp1dat(matches(grp1dat.Layer, 'II'),:);
IV1dat = grp1dat(matches(grp1dat.Layer, 'IV'),:);
Va1dat = grp1dat(matches(grp1dat.Layer, 'Va'),:);
Vb1dat = grp1dat(matches(grp1dat.Layer, 'Vb'),:);
VI1dat = grp1dat(matches(grp1dat.Layer, 'VI'),:);

II2dat = grp2dat(matches(grp2dat.Layer, 'II'),:);
IV2dat = grp2dat(matches(grp2dat.Layer, 'IV'),:);
Va2dat = grp2dat(matches(grp2dat.Layer, 'Va'),:);
Vb2dat = grp2dat(matches(grp2dat.Layer, 'Vb'),:);
VI2dat = grp2dat(matches(grp2dat.Layer, 'VI'),:);

II1high1 = II1dat(II1dat.OrderofClick == call_high(1),:);
IV1high1 = IV1dat(IV1dat.OrderofClick == call_high(1),:);
Va1high1 = Va1dat(Va1dat.OrderofClick == call_high(1),:);
Vb1high1 = Vb1dat(Vb1dat.OrderofClick == call_high(1),:);
VI1high1 = VI1dat(VI1dat.OrderofClick == call_high(1),:);
II1high2 = II1dat(II1dat.OrderofClick == call_high(2),:);
IV1high2 = IV1dat(IV1dat.OrderofClick == call_high(2),:);
Va1high2 = Va1dat(Va1dat.OrderofClick == call_high(2),:);
Vb1high2 = Vb1dat(Vb1dat.OrderofClick == call_high(2),:);
VI1high2 = VI1dat(VI1dat.OrderofClick == call_high(2),:);
II1high3 = II1dat(II1dat.OrderofClick == call_high(3),:);
IV1high3 = IV1dat(IV1dat.OrderofClick == call_high(3),:);
Va1high3 = Va1dat(Va1dat.OrderofClick == call_high(3),:);
Vb1high3 = Vb1dat(Vb1dat.OrderofClick == call_high(3),:);
VI1high3 = VI1dat(VI1dat.OrderofClick == call_high(3),:);
II1high4 = II1dat(II1dat.OrderofClick == call_high(4),:);
IV1high4 = IV1dat(IV1dat.OrderofClick == call_high(4),:);
Va1high4 = Va1dat(Va1dat.OrderofClick == call_high(4),:);
Vb1high4 = Vb1dat(Vb1dat.OrderofClick == call_high(4),:);
VI1high4 = VI1dat(VI1dat.OrderofClick == call_high(4),:);
II1high5 = II1dat(II1dat.OrderofClick == call_high(5),:);
IV1high5 = IV1dat(IV1dat.OrderofClick == call_high(5),:);
Va1high5 = Va1dat(Va1dat.OrderofClick == call_high(5),:);
Vb1high5 = Vb1dat(Vb1dat.OrderofClick == call_high(5),:);
VI1high5 = VI1dat(VI1dat.OrderofClick == call_high(5),:);

II1low1 = II1dat(II1dat.OrderofClick == call_low(1),:);
IV1low1 = IV1dat(IV1dat.OrderofClick == call_low(1),:);
Va1low1 = Va1dat(Va1dat.OrderofClick == call_low(1),:);
Vb1low1 = Vb1dat(Vb1dat.OrderofClick == call_low(1),:);
VI1low1 = VI1dat(VI1dat.OrderofClick == call_low(1),:);
II1low2 = II1dat(II1dat.OrderofClick == call_low(2),:);
IV1low2 = IV1dat(IV1dat.OrderofClick == call_low(2),:);
Va1low2 = Va1dat(Va1dat.OrderofClick == call_low(2),:);
Vb1low2 = Vb1dat(Vb1dat.OrderofClick == call_low(2),:);
VI1low2 = VI1dat(VI1dat.OrderofClick == call_low(2),:);
II1low3 = II1dat(II1dat.OrderofClick == call_low(3),:);
IV1low3 = IV1dat(IV1dat.OrderofClick == call_low(3),:);
Va1low3 = Va1dat(Va1dat.OrderofClick == call_low(3),:);
Vb1low3 = Vb1dat(Vb1dat.OrderofClick == call_low(3),:);
VI1low3 = VI1dat(VI1dat.OrderofClick == call_low(3),:);
II1low4 = II1dat(II1dat.OrderofClick == call_low(4),:);
IV1low4 = IV1dat(IV1dat.OrderofClick == call_low(4),:);
Va1low4 = Va1dat(Va1dat.OrderofClick == call_low(4),:);
Vb1low4 = Vb1dat(Vb1dat.OrderofClick == call_low(4),:);
VI1low4 = VI1dat(VI1dat.OrderofClick == call_low(4),:);
II1low5 = II1dat(II1dat.OrderofClick == call_low(5),:);
IV1low5 = IV1dat(IV1dat.OrderofClick == call_low(5),:);
Va1low5 = Va1dat(Va1dat.OrderofClick == call_low(5),:);
Vb1low5 = Vb1dat(Vb1dat.OrderofClick == call_low(5),:);
VI1low5 = VI1dat(VI1dat.OrderofClick == call_low(5),:);

II2high1 = II2dat(II2dat.OrderofClick == call_high(1),:);
IV2high1 = IV2dat(IV2dat.OrderofClick == call_high(1),:);
Va2high1 = Va2dat(Va2dat.OrderofClick == call_high(1),:);
Vb2high1 = Vb2dat(Vb2dat.OrderofClick == call_high(1),:);
VI2high1 = VI2dat(VI2dat.OrderofClick == call_high(1),:);
II2high2 = II2dat(II2dat.OrderofClick == call_high(2),:);
IV2high2 = IV2dat(IV2dat.OrderofClick == call_high(2),:);
Va2high2 = Va2dat(Va2dat.OrderofClick == call_high(2),:);
Vb2high2 = Vb2dat(Vb2dat.OrderofClick == call_high(2),:);
VI2high2 = VI2dat(VI2dat.OrderofClick == call_high(2),:);
II2high3 = II2dat(II2dat.OrderofClick == call_high(3),:);
IV2high3 = IV2dat(IV2dat.OrderofClick == call_high(3),:);
Va2high3 = Va2dat(Va2dat.OrderofClick == call_high(3),:);
Vb2high3 = Vb2dat(Vb2dat.OrderofClick == call_high(3),:);
VI2high3 = VI2dat(VI2dat.OrderofClick == call_high(3),:);
II2high4 = II2dat(II2dat.OrderofClick == call_high(4),:);
IV2high4 = IV2dat(IV2dat.OrderofClick == call_high(4),:);
Va2high4 = Va2dat(Va2dat.OrderofClick == call_high(4),:);
Vb2high4 = Vb2dat(Vb2dat.OrderofClick == call_high(4),:);
VI2high4 = VI2dat(VI2dat.OrderofClick == call_high(4),:);
II2high5 = II2dat(II2dat.OrderofClick == call_high(5),:);
IV2high5 = IV2dat(IV2dat.OrderofClick == call_high(5),:);
Va2high5 = Va2dat(Va2dat.OrderofClick == call_high(5),:);
Vb2high5 = Vb2dat(Vb2dat.OrderofClick == call_high(5),:);
VI2high5 = VI2dat(VI2dat.OrderofClick == call_high(5),:);

II2low1 = II2dat(II2dat.OrderofClick == call_low(1),:);
IV2low1 = IV2dat(IV2dat.OrderofClick == call_low(1),:);
Va2low1 = Va2dat(Va2dat.OrderofClick == call_low(1),:);
Vb2low1 = Vb2dat(Vb2dat.OrderofClick == call_low(1),:);
VI2low1 = VI2dat(VI2dat.OrderofClick == call_low(1),:);
II2low2 = II2dat(II2dat.OrderofClick == call_low(2),:);
IV2low2 = IV2dat(IV2dat.OrderofClick == call_low(2),:);
Va2low2 = Va2dat(Va2dat.OrderofClick == call_low(2),:);
Vb2low2 = Vb2dat(Vb2dat.OrderofClick == call_low(2),:);
VI2low2 = VI2dat(VI2dat.OrderofClick == call_low(2),:);
II2low3 = II2dat(II2dat.OrderofClick == call_low(3),:);
IV2low3 = IV2dat(IV2dat.OrderofClick == call_low(3),:);
Va2low3 = Va2dat(Va2dat.OrderofClick == call_low(3),:);
Vb2low3 = Vb2dat(Vb2dat.OrderofClick == call_low(3),:);
VI2low3 = VI2dat(VI2dat.OrderofClick == call_low(3),:);
II2low4 = II2dat(II2dat.OrderofClick == call_low(4),:);
IV2low4 = IV2dat(IV2dat.OrderofClick == call_low(4),:);
Va2low4 = Va2dat(Va2dat.OrderofClick == call_low(4),:);
Vb2low4 = Vb2dat(Vb2dat.OrderofClick == call_low(4),:);
VI2low4 = VI2dat(VI2dat.OrderofClick == call_low(4),:);
II2low5 = II2dat(II2dat.OrderofClick == call_low(5),:);
IV2low5 = IV2dat(IV2dat.OrderofClick == call_low(5),:);
Va2low5 = Va2dat(Va2dat.OrderofClick == call_low(5),:);
Vb2low5 = Vb2dat(Vb2dat.OrderofClick == call_low(5),:);
VI2low5 = VI2dat(VI2dat.OrderofClick == call_low(5),:);

% normalize
II1high1_norm = log(II1high1.PeakAmp) ./ log(nanmean(II1high1.PeakAmp)); 
IV1high1_norm = log(IV1high1.PeakAmp) ./ log(nanmean(IV1high1.PeakAmp)); 
Va1high1_norm = log(Va1high1.PeakAmp) ./ log(nanmean(Va1high1.PeakAmp)); 
Vb1high1_norm = log(Vb1high1.PeakAmp) ./ log(nanmean(Vb1high1.PeakAmp)); 
VI1high1_norm = log(VI1high1.PeakAmp) ./ log(nanmean(VI1high1.PeakAmp)); 
II1high2_norm = log(II1high2.PeakAmp) ./ log(nanmean(II1high2.PeakAmp)); 
IV1high2_norm = log(IV1high2.PeakAmp) ./ log(nanmean(IV1high2.PeakAmp)); 
Va1high2_norm = log(Va1high2.PeakAmp) ./ log(nanmean(Va1high2.PeakAmp)); 
Vb1high2_norm = log(Vb1high2.PeakAmp) ./ log(nanmean(Vb1high2.PeakAmp)); 
VI1high2_norm = log(VI1high2.PeakAmp) ./ log(nanmean(VI1high2.PeakAmp)); 
II1high3_norm = log(II1high3.PeakAmp) ./ log(nanmean(II1high3.PeakAmp)); 
IV1high3_norm = log(IV1high3.PeakAmp) ./ log(nanmean(IV1high3.PeakAmp)); 
Va1high3_norm = log(Va1high3.PeakAmp) ./ log(nanmean(Va1high3.PeakAmp)); 
Vb1high3_norm = log(Vb1high3.PeakAmp) ./ log(nanmean(Vb1high3.PeakAmp)); 
VI1high3_norm = log(VI1high3.PeakAmp) ./ log(nanmean(VI1high3.PeakAmp)); 
II1high4_norm = log(II1high4.PeakAmp) ./ log(nanmean(II1high4.PeakAmp)); 
IV1high4_norm = log(IV1high4.PeakAmp) ./ log(nanmean(IV1high4.PeakAmp)); 
Va1high4_norm = log(Va1high4.PeakAmp) ./ log(nanmean(Va1high4.PeakAmp)); 
Vb1high4_norm = log(Vb1high4.PeakAmp) ./ log(nanmean(Vb1high4.PeakAmp)); 
VI1high4_norm = log(VI1high4.PeakAmp) ./ log(nanmean(VI1high4.PeakAmp)); 
II1high5_norm = log(II1high5.PeakAmp) ./ log(nanmean(II1high5.PeakAmp)); 
IV1high5_norm = log(IV1high5.PeakAmp) ./ log(nanmean(IV1high5.PeakAmp)); 
Va1high5_norm = log(Va1high5.PeakAmp) ./ log(nanmean(Va1high5.PeakAmp)); 
Vb1high5_norm = log(Vb1high5.PeakAmp) ./ log(nanmean(Vb1high5.PeakAmp)); 
VI1high5_norm = log(VI1high5.PeakAmp) ./ log(nanmean(VI1high5.PeakAmp)); 

II1low1_norm = log(II1low1.PeakAmp) ./ log(nanmean(II1low1.PeakAmp)); 
IV1low1_norm = log(IV1low1.PeakAmp) ./ log(nanmean(IV1low1.PeakAmp)); 
Va1low1_norm = log(Va1low1.PeakAmp) ./ log(nanmean(Va1low1.PeakAmp)); 
Vb1low1_norm = log(Vb1low1.PeakAmp) ./ log(nanmean(Vb1low1.PeakAmp)); 
VI1low1_norm = log(VI1low1.PeakAmp) ./ log(nanmean(VI1low1.PeakAmp)); 
II1low2_norm = log(II1low2.PeakAmp) ./ log(nanmean(II1low2.PeakAmp)); 
IV1low2_norm = log(IV1low2.PeakAmp) ./ log(nanmean(IV1low2.PeakAmp)); 
Va1low2_norm = log(Va1low2.PeakAmp) ./ log(nanmean(Va1low2.PeakAmp)); 
Vb1low2_norm = log(Vb1low2.PeakAmp) ./ log(nanmean(Vb1low2.PeakAmp)); 
VI1low2_norm = log(VI1low2.PeakAmp) ./ log(nanmean(VI1low2.PeakAmp)); 
II1low3_norm = log(II1low3.PeakAmp) ./ log(nanmean(II1low3.PeakAmp)); 
IV1low3_norm = log(IV1low3.PeakAmp) ./ log(nanmean(IV1low3.PeakAmp)); 
Va1low3_norm = log(Va1low3.PeakAmp) ./ log(nanmean(Va1low3.PeakAmp)); 
Vb1low3_norm = log(Vb1low3.PeakAmp) ./ log(nanmean(Vb1low3.PeakAmp)); 
VI1low3_norm = log(VI1low3.PeakAmp) ./ log(nanmean(VI1low3.PeakAmp)); 
II1low4_norm = log(II1low4.PeakAmp) ./ log(nanmean(II1low4.PeakAmp)); 
IV1low4_norm = log(IV1low4.PeakAmp) ./ log(nanmean(IV1low4.PeakAmp)); 
Va1low4_norm = log(Va1low4.PeakAmp) ./ log(nanmean(Va1low4.PeakAmp)); 
Vb1low4_norm = log(Vb1low4.PeakAmp) ./ log(nanmean(Vb1low4.PeakAmp)); 
VI1low4_norm = log(VI1low4.PeakAmp) ./ log(nanmean(VI1low4.PeakAmp)); 
II1low5_norm = log(II1low5.PeakAmp) ./ log(nanmean(II1low5.PeakAmp)); 
IV1low5_norm = log(IV1low5.PeakAmp) ./ log(nanmean(IV1low5.PeakAmp)); 
Va1low5_norm = log(Va1low5.PeakAmp) ./ log(nanmean(Va1low5.PeakAmp)); 
Vb1low5_norm = log(Vb1low5.PeakAmp) ./ log(nanmean(Vb1low5.PeakAmp)); 
VI1low5_norm = log(VI1low5.PeakAmp) ./ log(nanmean(VI1low5.PeakAmp)); 

II2high1_norm = log(II2high1.PeakAmp) ./ log(nanmean(II1high1.PeakAmp)); 
IV2high1_norm = log(IV2high1.PeakAmp) ./ log(nanmean(IV1high1.PeakAmp)); 
Va2high1_norm = log(Va2high1.PeakAmp) ./ log(nanmean(Va1high1.PeakAmp)); 
Vb2high1_norm = log(Vb2high1.PeakAmp) ./ log(nanmean(Vb1high1.PeakAmp)); 
VI2high1_norm = log(VI2high1.PeakAmp) ./ log(nanmean(VI1high1.PeakAmp)); 
II2high2_norm = log(II2high2.PeakAmp) ./ log(nanmean(II1high2.PeakAmp)); 
IV2high2_norm = log(IV2high2.PeakAmp) ./ log(nanmean(IV1high2.PeakAmp)); 
Va2high2_norm = log(Va2high2.PeakAmp) ./ log(nanmean(Va1high2.PeakAmp)); 
Vb2high2_norm = log(Vb2high2.PeakAmp) ./ log(nanmean(Vb1high2.PeakAmp)); 
VI2high2_norm = log(VI2high2.PeakAmp) ./ log(nanmean(VI1high2.PeakAmp)); 
II2high3_norm = log(II2high3.PeakAmp) ./ log(nanmean(II1high3.PeakAmp)); 
IV2high3_norm = log(IV2high3.PeakAmp) ./ log(nanmean(IV1high3.PeakAmp)); 
Va2high3_norm = log(Va2high3.PeakAmp) ./ log(nanmean(Va1high3.PeakAmp)); 
Vb2high3_norm = log(Vb2high3.PeakAmp) ./ log(nanmean(Vb1high3.PeakAmp)); 
VI2high3_norm = log(VI2high3.PeakAmp) ./ log(nanmean(VI1high3.PeakAmp)); 
II2high4_norm = log(II2high4.PeakAmp) ./ log(nanmean(II1high4.PeakAmp)); 
IV2high4_norm = log(IV2high4.PeakAmp) ./ log(nanmean(IV1high4.PeakAmp)); 
Va2high4_norm = log(Va2high4.PeakAmp) ./ log(nanmean(Va1high4.PeakAmp)); 
Vb2high4_norm = log(Vb2high4.PeakAmp) ./ log(nanmean(Vb1high4.PeakAmp)); 
VI2high4_norm = log(VI2high4.PeakAmp) ./ log(nanmean(VI1high4.PeakAmp)); 
II2high5_norm = log(II2high5.PeakAmp) ./ log(nanmean(II1high5.PeakAmp)); 
IV2high5_norm = log(IV2high5.PeakAmp) ./ log(nanmean(IV1high5.PeakAmp)); 
Va2high5_norm = log(Va2high5.PeakAmp) ./ log(nanmean(Va1high5.PeakAmp)); 
Vb2high5_norm = log(Vb2high5.PeakAmp) ./ log(nanmean(Vb1high5.PeakAmp)); 
VI2high5_norm = log(VI2high5.PeakAmp) ./ log(nanmean(VI1high5.PeakAmp)); 

II2low1_norm = log(II2low1.PeakAmp) ./ log(nanmean(II1low1.PeakAmp)); 
IV2low1_norm = log(IV2low1.PeakAmp) ./ log(nanmean(IV1low1.PeakAmp)); 
Va2low1_norm = log(Va2low1.PeakAmp) ./ log(nanmean(Va1low1.PeakAmp)); 
Vb2low1_norm = log(Vb2low1.PeakAmp) ./ log(nanmean(Vb1low1.PeakAmp)); 
VI2low1_norm = log(VI2low1.PeakAmp) ./ log(nanmean(VI1low1.PeakAmp)); 
II2low2_norm = log(II2low2.PeakAmp) ./ log(nanmean(II1low2.PeakAmp)); 
IV2low2_norm = log(IV2low2.PeakAmp) ./ log(nanmean(IV1low2.PeakAmp)); 
Va2low2_norm = log(Va2low2.PeakAmp) ./ log(nanmean(Va1low2.PeakAmp)); 
Vb2low2_norm = log(Vb2low2.PeakAmp) ./ log(nanmean(Vb1low2.PeakAmp)); 
VI2low2_norm = log(VI2low2.PeakAmp) ./ log(nanmean(VI1low2.PeakAmp)); 
II2low3_norm = log(II2low3.PeakAmp) ./ log(nanmean(II1low3.PeakAmp)); 
IV2low3_norm = log(IV2low3.PeakAmp) ./ log(nanmean(IV1low3.PeakAmp)); 
Va2low3_norm = log(Va2low3.PeakAmp) ./ log(nanmean(Va1low3.PeakAmp)); 
Vb2low3_norm = log(Vb2low3.PeakAmp) ./ log(nanmean(Vb1low3.PeakAmp)); 
VI2low3_norm = log(VI2low3.PeakAmp) ./ log(nanmean(VI1low3.PeakAmp)); 
II2low4_norm = log(II2low4.PeakAmp) ./ log(nanmean(II1low4.PeakAmp)); 
IV2low4_norm = log(IV2low4.PeakAmp) ./ log(nanmean(IV1low4.PeakAmp)); 
Va2low4_norm = log(Va2low4.PeakAmp) ./ log(nanmean(Va1low4.PeakAmp)); 
Vb2low4_norm = log(Vb2low4.PeakAmp) ./ log(nanmean(Vb1low4.PeakAmp)); 
VI2low4_norm = log(VI2low4.PeakAmp) ./ log(nanmean(VI1low4.PeakAmp)); 
II2low5_norm = log(II2low5.PeakAmp) ./ log(nanmean(II1low5.PeakAmp)); 
IV2low5_norm = log(IV2low5.PeakAmp) ./ log(nanmean(IV1low5.PeakAmp)); 
Va2low5_norm = log(Va2low5.PeakAmp) ./ log(nanmean(Va1low5.PeakAmp)); 
Vb2low5_norm = log(Vb2low5.PeakAmp) ./ log(nanmean(Vb1low5.PeakAmp)); 
VI2low5_norm = log(VI2low5.PeakAmp) ./ log(nanmean(VI1low5.PeakAmp)); 

% pool the normalized data
II1high_norm = [II1high1_norm, II1high2_norm, II1high3_norm, II1high4_norm, II1high5_norm];
II1high_norm = nanmean(II1high_norm,2);
IV1high_norm = [IV1high1_norm, IV1high2_norm, IV1high3_norm, IV1high4_norm, IV1high5_norm];
IV1high_norm = nanmean(IV1high_norm,2);
Va1high_norm = [Va1high1_norm, Va1high2_norm, Va1high3_norm, Va1high4_norm, Va1high5_norm];
Va1high_norm = nanmean(Va1high_norm,2);
Vb1high_norm = [Vb1high1_norm, Vb1high2_norm, Vb1high3_norm, Vb1high4_norm, Vb1high5_norm];
Vb1high_norm = nanmean(Vb1high_norm,2);
VI1high_norm = [VI1high1_norm, VI1high2_norm, VI1high3_norm, VI1high4_norm, VI1high5_norm];
VI1high_norm = nanmean(VI1high_norm,2);

II1low_norm = [II1low1_norm, II1low2_norm, II1low3_norm, II1low4_norm, II1low5_norm];
II1low_norm = nanmean(II1low_norm,2);
IV1low_norm = [IV1low1_norm, IV1low2_norm, IV1low3_norm, IV1low4_norm, IV1low5_norm];
IV1low_norm = nanmean(IV1low_norm,2);
Va1low_norm = [Va1low1_norm, Va1low2_norm, Va1low3_norm, Va1low4_norm, Va1low5_norm];
Va1low_norm = nanmean(Va1low_norm,2);
Vb1low_norm = [Vb1low1_norm, Vb1low2_norm, Vb1low3_norm, Vb1low4_norm, Vb1low5_norm];
Vb1low_norm = nanmean(Vb1low_norm,2);
VI1low_norm = [VI1low1_norm, VI1low2_norm, VI1low3_norm, VI1low4_norm, VI1low5_norm];
VI1low_norm = nanmean(VI1low_norm,2);

II2high_norm = [II2high1_norm, II2high2_norm, II2high3_norm, II2high4_norm, II2high5_norm];
II2high_norm = nanmean(II2high_norm,2);
IV2high_norm = [IV2high1_norm, IV2high2_norm, IV2high3_norm, IV2high4_norm, IV2high5_norm];
IV2high_norm = nanmean(IV2high_norm,2);
Va2high_norm = [Va2high1_norm, Va2high2_norm, Va2high3_norm, Va2high4_norm, Va2high5_norm];
Va2high_norm = nanmean(Va2high_norm,2);
Vb2high_norm = [Vb2high1_norm, Vb2high2_norm, Vb2high3_norm, Vb2high4_norm, Vb2high5_norm];
Vb2high_norm = nanmean(Vb2high_norm,2);
VI2high_norm = [VI2high1_norm, VI2high2_norm, VI2high3_norm, VI2high4_norm, VI2high5_norm];
VI2high_norm = nanmean(VI2high_norm,2);

II2low_norm = [II2low1_norm, II2low2_norm, II2low3_norm, II2low4_norm, II2low5_norm];
II2low_norm = nanmean(II2low_norm,2);
IV2low_norm = [IV2low1_norm, IV2low2_norm, IV2low3_norm, IV2low4_norm, IV2low5_norm];
IV2low_norm = nanmean(IV2low_norm,2);
Va2low_norm = [Va2low1_norm, Va2low2_norm, Va2low3_norm, Va2low4_norm, Va2low5_norm];
Va2low_norm = nanmean(Va2low_norm,2);
Vb2low_norm = [Vb2low1_norm, Vb2low2_norm, Vb2low3_norm, Vb2low4_norm, Vb2low5_norm];
Vb2low_norm = nanmean(Vb2low_norm,2);
VI2low_norm = [VI2low1_norm, VI2low2_norm, VI2low3_norm, VI2low4_norm, VI2low5_norm];
VI2low_norm = nanmean(VI2low_norm,2);

% stack data back up

% high is 2, low is 1 in Condition
grp1high = ones(length(II1high_norm),1)*2;
grp1low  = ones(length(II1low_norm),1);
grp2high = ones(length(II2high_norm),1)*2;
grp2low  = ones(length(II2low_norm),1);

y = vertcat(II1high_norm, IV1high_norm, Va1high_norm, Vb1high_norm, VI1high_norm,...
    II2high_norm, IV2high_norm, Va2high_norm, Vb2high_norm, VI2high_norm,...
    II1low_norm, IV1low_norm, Va1low_norm, Vb1low_norm, VI1low_norm,...
    II2low_norm, IV2low_norm, Va2low_norm, Vb2low_norm, VI2low_norm);
Group = vertcat(II1high1.Group,IV1high1.Group,Va1high1.Group,Vb1high1.Group,VI1high1.Group,...
    II2high1.Group,IV2high1.Group,Va2high1.Group,Vb2high1.Group,VI2high1.Group,...
    II1low1.Group,IV1low1.Group,Va1low1.Group,Vb1low1.Group,VI1low1.Group,...
    II2low1.Group,IV2low1.Group,Va2low1.Group,Vb2low1.Group,VI2low1.Group);
Condition = vertcat(grp1high,grp1high,grp1high,grp1high,grp1high,...
    grp2high,grp2high,grp2high,grp2high,grp2high,...
    grp1low,grp1low,grp1low,grp1low,grp1low,...
    grp2low,grp2low,grp2low,grp2low,grp2low);
Layer = vertcat(II1high1.Layer,IV1high1.Layer,Va1high1.Layer,Vb1high1.Layer,VI1high1.Layer,...
    II2high1.Layer,IV2high1.Layer,Va2high1.Layer,Vb2high1.Layer,VI2high1.Layer,...
    II1low1.Layer,IV1low1.Layer,Va1low1.Layer,Vb1low1.Layer,VI1low1.Layer,...
    II2low1.Layer,IV2low1.Layer,Va2low1.Layer,Vb2low1.Layer,VI2low1.Layer);

% Set up anova. Factors: group, layer, click-freq
[p, tbl] = anovan(y,{Group Condition Layer},'model','interaction','varnames',{'Group','Condition','Layer'});

save('ANOVA_PC_HighLow_Sgl_log.mat','p')

