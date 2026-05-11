function PCal_Pupcall_HighLowStatsITPC_ANOVA(homedir,call_high,call_low)

cd(homedir)

DataT = readtable('VMPandPMP_Pupcall_1_ITPCmean.csv');


% we're going to do this on the non-normalized data, so no need to break up
% the table, just to stack

DataThigh1 = DataT(DataT.Order_Presentation == call_high(1),:);
DataThigh2 = DataT(DataT.Order_Presentation == call_high(2),:);
DataThigh3 = DataT(DataT.Order_Presentation == call_high(3),:);
DataThigh4 = DataT(DataT.Order_Presentation == call_high(4),:);
DataThigh5 = DataT(DataT.Order_Presentation == call_high(5),:);

DataThigh = vertcat(DataThigh1,DataThigh2,DataThigh3,DataThigh4,DataThigh5);

DataTlow1 = DataT(DataT.Order_Presentation == call_low(1),:);
DataTlow2 = DataT(DataT.Order_Presentation == call_low(2),:);
DataTlow3 = DataT(DataT.Order_Presentation == call_low(3),:);
DataTlow4 = DataT(DataT.Order_Presentation == call_low(4),:);
DataTlow5 = DataT(DataT.Order_Presentation == call_low(5),:);

DataTlow = vertcat(DataTlow1,DataTlow2,DataTlow3,DataTlow4,DataTlow5);

y = vertcat(DataThigh.Theta_mean, DataThigh.Alpha_mean,...
    DataThigh.Beta_mean, DataThigh.GammaLow_mean, DataThigh.GammaHigh_mean,...
    DataTlow.Theta_mean, DataTlow.Alpha_mean,...
    DataTlow.Beta_mean, DataTlow.GammaLow_mean, DataTlow.GammaHigh_mean);

Group = vertcat(DataThigh.Group, DataThigh.Group,...
    DataThigh.Group, DataThigh.Group, DataThigh.Group,...
    DataTlow.Group, DataTlow.Group,...
    DataTlow.Group, DataTlow.Group, DataTlow.Group);

Condition = vertcat(repmat("high",350,1), repmat("high",350,1),...
    repmat("high",350,1), repmat("high",350,1), repmat("high",350,1),...
    repmat("low",350,1), repmat("low",350,1),...
    repmat("low",350,1), repmat("low",350,1), repmat("low",350,1));

Layer = vertcat(DataThigh.Layer, DataThigh.Layer,...
    DataThigh.Layer, DataThigh.Layer, DataThigh.Layer,...
    DataTlow.Layer, DataTlow.Layer,...
    DataTlow.Layer, DataTlow.Layer, DataTlow.Layer);

Freq = vertcat(repmat("theta",350,1), repmat("alpha",350,1),...
    repmat("beta",350,1), repmat("low gam",350,1), repmat("high gam",350,1),...
    repmat("theta",350,1), repmat("alpha",350,1),...
    repmat("beta",350,1), repmat("low gam",350,1), repmat("high gam",350,1));




% Set up anova. Factors: group, layer, click-freq
[p, tbl] = anovan(y,{Group Condition Layer Freq},'model','full','varnames',{'Group','Condition','Layer','Freq'});

save('ANOVA_PC_HighLow_ITPC.mat','p')