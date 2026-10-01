function prepDataforStatsPMPVMP(homedir)

cd(homedir);cd output 
if ~exist('DataforStatsPMPVMP','dir')
    mkdir('DataforStatsPMPVMP')
end
cd DataforStatsPMPVMP
%% Peak data 

% Click trains - just 5 Hz 
% PMP
T = readtable('PMP_ClickTrain_AVRECPeak.csv');
T = T(T.ClickFreq == 5,:);
T = addagecolumn(T);
writetable(T,'PMP_5HzClickTrain_SingleTrialPeaks.csv');

% VMP
T = readtable('VMP_ClickTrain_AVRECPeak.csv');
T = T(T.ClickFreq == 5,:);
T = addagecolumn(T);
writetable(T,'VMP_5HzClickTrain_SingleTrialPeaks.csv');

% Noisebursts - just 20, 50, and 70 dB; remove order column; rename dB column
% PMP
T = readtable('PMP_NoiseBurst_AVRECPeak.csv');
toDelete = T.ClickFreq == 30;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 40;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 60;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 80;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 90;
T(toDelete,:) = [];
T = removevars(T,{'OrderofClick'});
T = renamevars(T,'ClickFreq', 'dB');
T = addagecolumn(T);
writetable(T,'PMP_NoiseBurst_SingleTrialPeaks.csv');

% VMP
T = readtable('VMP_NoiseBurst_AVRECPeak.csv');
toDelete = T.ClickFreq == 30;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 40;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 60;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 80;
T(toDelete,:) = [];
toDelete = T.ClickFreq == 90;
T(toDelete,:) = [];
T = removevars(T,{'OrderofClick'});
T = renamevars(T,'ClickFreq', 'dB');
T = addagecolumn(T);
writetable(T,'VMP_NoiseBurst_SingleTrialPeaks.csv');

% Pupcall - just rename to OrderofCall and remove ClickFreq column
% PMP
T = readtable('PMP_PupCall30_AVRECPeak.csv');
T = removevars(T,{'ClickFreq'});
T = renamevars(T,'OrderofClick', 'OrderofCall');
T = addagecolumn(T);
writetable(T,'PMP_PupCall_SingleTrialPeaks.csv');

% VMP
T = readtable('VMP_PupCall30_AVRECPeak.csv');
T = removevars(T,{'ClickFreq'});
T = renamevars(T,'OrderofClick', 'OrderofCall');
T = addagecolumn(T);
writetable(T,'VMP_PupCall_SingleTrialPeaks.csv');

%% FFT

T = readtable('VMPvPMP_AB_Pupcall_FFTData.csv');
Tremove = matches(T.Condition,'Pupcall');
T(Tremove,:) = [];
T = addagecolumn(T);
writetable(T,'VMPvPMP_AB_Spontaneous_FFTData.csv');