function prepDataforStatsAwakeFmr1(homedir)

cd(homedir);cd output 
if ~exist('DataforStatsAwakeFmr1','dir')
    mkdir('DataforStatsAwakeFmr1')
end
cd DataforStatsAwakeFmr1
%% Peak data 

% Click trains - just 5 Hz 
% WT
T = readtable('AWT_ClickTrain_AVRECPeak.csv');
writetable(T,'AWT_5HzClickTrain_SingleTrialPeaks.csv');

% KO
T = readtable('AKO_ClickTrain_AVRECPeak.csv');
writetable(T,'AKO_ClickTrain_SingleTrialPeaks.csv');

% KH
T = readtable('CKH_ClickTrain_AVRECPeak.csv');
writetable(T,'CKH_ClickTrain_SingleTrialPeaks.csv');

% Noisebursts - remove order column; rename dB column
% WT
T = readtable('AWT_NoiseBurst_AVRECPeak.csv');
T = removevars(T,{'OrderofClick'});
T = renamevars(T,'ClickFreq', 'dB');
writetable(T,'AWT_NoiseBurst_SingleTrialPeaks.csv');

% KO
T = readtable('AKO_NoiseBurst_AVRECPeak.csv');
T = removevars(T,{'OrderofClick'});
T = renamevars(T,'ClickFreq', 'dB');
writetable(T,'AKO_NoiseBurst_SingleTrialPeaks.csv');

% KH
T = readtable('CKH_NoiseBurst_AVRECPeak.csv');
T = removevars(T,{'OrderofClick'});
T = renamevars(T,'ClickFreq', 'dB');
writetable(T,'CKH_NoiseBurst_SingleTrialPeaks.csv');


