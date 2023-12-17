function GroupPupcallTraces(homedir,Group)

BL     = 399;
[~, ~, stimDur, stimITI, ~] = StimVariable('Pupcall30',1);
timeaxis = BL + stimDur + stimITI;

% AvrecAll is layers x data x subject
load([Group '_Pupcall30_AvrecAll.mat'],'AvrecAll')

% preaverage trials
AvrecAvg = cellfun(@(x) mean(x,3),AvrecAll,'UniformOutput',false);
% empty rows will not be taken in the stacked data :) 

% pull out layers
AVREC = cat(1,AvrecAvg{1,1,:});
% layers
II = cat(1,AvrecAvg{1,2,:});
IV = cat(1,AvrecAvg{1,3,:});
Va = cat(1,AvrecAvg{1,4,:});
Vb = cat(1,AvrecAvg{1,5,:});
VI = cat(1,AvrecAvg{1,6,:});

% prep the wave file
[y,~] = audioread('PupCall25s.wav');
% audio file has fs of 192000. However, the software is slightly
% slowing the stimulus down as it plays it. Therefore, the following fs
% is based on the RPvdsEx playing (this is at max fs in the software)
fs = 194800;
y = y(:,1);
% CSD has a 399 BL and 1 s post stim time window
prebuff  = zeros(round((BL/1000)*fs),1);
% postbuff = zeros(1*fs,1);
ymod = vertcat(prebuff,y); %,postbuff
dt   = 1/fs;
t    = 0:dt:(length(ymod)*dt)-dt;

% draw!
figure
tiledlayout('vertical')
% AVREC
nexttile
% plot them with shaded error bar
shadedErrorBar(1:size(AVREC,2),mean(AVREC,1),std(AVREC,0,1),'lineprops','b');
% title
title(['Avg response to Pupcall for ' Group])
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('AVREC [mV/mm²]')
ylim([0 max(max(AVREC))])

% next up is the wave file
nexttile
plot(t,ymod,'k'); ylabel('PupCall');
xlim([0 timeaxis/1000])
ylim([-1 1])

% layer II
nexttile
shadedErrorBar(1:size(II,2),mean(II,1),std(II,0,1),'lineprops','b');
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('II [mV/mm²]')
ylim([0 max(max(AVREC))])
% layer IV
nexttile
shadedErrorBar(1:size(IV,2),mean(IV,1),std(IV,0,1),'lineprops','b');
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('IV [mV/mm²]')
ylim([0 max(max(AVREC))])
% layer Va
nexttile
shadedErrorBar(1:size(Va,2),mean(Va,1),std(Va,0,1),'lineprops','b');
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('Va [mV/mm²]')
ylim([0 max(max(AVREC))])
% layer Vb
nexttile
shadedErrorBar(1:size(Vb,2),mean(Vb,1),std(Vb,0,1),'lineprops','b');
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('Vb [mV/mm²]')
ylim([0 max(max(AVREC))])
% layer VI
nexttile
shadedErrorBar(1:size(VI,2),mean(VI,1),std(VI,0,1),'lineprops','b');
% x axis
xlim([0 timeaxis])
xticks([400 5000 10000 15000 20000 25000 25427])
xticklabels({'On','5','10','15','20','','Off'})
% ylabel
ylabel('VI [mV/mm²]')
ylim([0 max(max(AVREC))])

cd(homedir); cd figures
if ~exist('PupcallTraces','dir')
    mkdir('PupcallTraces')
end
cd PupcallTraces

savefig(gcf,[Group '_Full_Call_Traces'])
close

load('PupTimes.mat','PupTimes')
PupTimes    = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
PupTimes    = PupTimes + 0.400; % add the prestimulus time
PupTimesCSD = PupTimes .* 1000; % match axes

% sanity checks
% plot(t,ymod,'k'); xlabel('Seconds'); ylabel('PupCall');
% xlim([0 size(CSD,2)/1000])
% xline(PupTimes(:,1),'b')
% xline(PupTimes(:,2),'r')
%
% imagesc(CSD)
% xline(PupTimes(:,1).*1000,'b')
% xline(PupTimes(:,2).*1000,'r')

% I've looked at all the calls and arbitrarily picked out these few to
% highlight
callList = [1 3 18 21 26 49];

for iCall = callList

    callCSD = PupTimesCSD(iCall,1);
    callWAV = PupTimes(iCall,1);

    % draw!
    figure
    tiledlayout('vertical')
    % AVREC
    nexttile
    % plot them with shaded error bar
    shadedErrorBar(1:size(AVREC,2),mean(AVREC,1),std(AVREC,0,1),'lineprops','b');
    % title
    title(['Avg response to Pupcall for ' Group])
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('AVREC [mV/mm²]')
    ylim([0 max(max(AVREC))])

    % next up is the wave file
    nexttile
    plot(t,ymod,'k'); ylabel('PupCall');
    xlim([callWAV-0.2 callWAV+0.4])
    xticks([callWAV-0.2 callWAV-0.1 callWAV callWAV+0.1 ...
        callWAV+0.2 callWAV+0.3 callWAV+0.4])
    xticklabels({'0', '100','200','300','400','500','600'})
    ylim([-1 1])

    % layer II
    nexttile
    shadedErrorBar(1:size(II,2),mean(II,1),std(II,0,1),'lineprops','b');
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('II [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer IV
    nexttile
    shadedErrorBar(1:size(IV,2),mean(IV,1),std(IV,0,1),'lineprops','b');
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('IV [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer Va
    nexttile
    shadedErrorBar(1:size(Va,2),mean(Va,1),std(Va,0,1),'lineprops','b');
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('Va [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer Vb
    nexttile
    shadedErrorBar(1:size(Vb,2),mean(Vb,1),std(Vb,0,1),'lineprops','b');
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('Vb [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer VI
    nexttile
    shadedErrorBar(1:size(VI,2),mean(VI,1),std(VI,0,1),'lineprops','b');
    % x axis
    xlim([callCSD-200,callCSD+400])
    xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
        callCSD+200 callCSD+300 callCSD+400])
    xticklabels({'0', '100','200','300','400','500','600'})
    % ylabel
    ylabel('VI [mV/mm²]')
    ylim([0 max(max(AVREC))])

    savefig(gcf,[Group '_Call_Traces_' num2str(iCall)])
    close

end

cd(homedir)