TRFStats = readtable('TRFstats.csv');

PStats = TRFStats(contains(TRFStats.Subject,'PMP'),:);
PStats = PStats.Mean_r_multi;
VStats = TRFStats(contains(TRFStats.Subject,'VMP'),:);
VStats = VStats.Mean_r_multi;

[h,p,ci,stats] = ttest2(VStats,PStats);