function SpecialPCals(homedir)
% PMP04 adjusted based on specific data review after
% StrengthxTime function to determine integrity of cortical response.

cd(homedir)
cd datastructs

load('PMP04_Data.mat','Data')

newDat = Data(3).sngtrlLFP{:};
newDat = newDat(:,:,1:24);
Data(3).sngtrlLFP = {newDat};

newDat = Data(3).sngtrlCSD{:};
newDat = newDat(:,:,1:24);
Data(3).sngtrlCSD = {newDat};

newDat = Data(3).sngtrlAvrec{:};
newDat = newDat(:,1:24);
Data(3).sngtrlAvrec = {newDat};

newDat = nanmean(newDat,2)';
Data(3).AVREC = {newDat};

save('PMP04_Data.mat','Data')

clear Data

cd(homedir)