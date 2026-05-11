% compare group backgrounds

% load all the data
load('VMP_Background.mat')
VMPPhase = BG_Phase;
VMPPower = BG_Power;

load('PMP_Background.mat')
PMPPhase = BG_Phase;
PMPPower = BG_Power;

% get that frequency axis' shit together
xtks = [1 7 15 25 30 36];
xtklabels = [100 60 30 12 7 4];
layers = {'I' 'II-IV' 'Va' 'Vb' 'VI'};

% show everything
figure
tiledlayout('flow')

for iLay = 1:5
nexttile
VPhmean = mean(VMPPhase(19:54,:,iLay),2);
VPhstd = std(VMPPhase(19:54,:,iLay),0,2);
errorbar(VPhmean,VPhstd,'o')
hold on
PPhmean = mean(PMPPhase(19:54,:,iLay),2);
PPhstd = std(PMPPhase(19:54,:,iLay),0,2);
errorbar(PPhmean,PPhstd,'o')
title(['Layer ' layers{iLay}])
legend('Virgins','Fathers')
xticks(xtks)
xticklabels(xtklabels)
xlabel('Frequency [Hz]')
ylabel('ITPC')

nexttile
VPomean = mean(VMPPower(19:54,:,iLay),2);
VPostd = std(VMPPower(19:54,:,iLay),0,2);
errorbar(VPomean,VPostd,'o')
hold on
PPomean = mean(PMPPower(19:54,:,iLay),2);
PPostd = std(PMPPower(19:54,:,iLay),0,2);
errorbar(PPomean,PPostd,'o')
title(['Layer ' layers{iLay}])
legend('Virgins','Fathers')
xticks(xtks)
xticklabels(xtklabels)
xlabel('Frequency [Hz]')
ylabel('STP')
end

savefig(gcf,'VirginvFatherBackgrounds.fig')
