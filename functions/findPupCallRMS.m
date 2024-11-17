 
% load wave
[y,~] = audioread('PupCall25s.wav');
% audio file has fs of 192000. However, the software is slightly
% slowing the stimulus down as it plays it. Therefore, the following fs
% is based on the RPvdsEx playing (this is at max fs in the software)
fs  = 194800;
y   = y(:,1);
t   = 0:dt:(length(y)*dt)-dt;

% figure
% nexttile
% plot(t,y,'k'); xlabel('PupCall');
% xlim([0 26])
% ylim([-1 1])

% load pup calls
load('PupTimes.mat','PupTimes')
PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)

% store the amp or rms
figure
rmss = zeros(length(PupTimes),1);
for iAm = 1:length(PupTimes)  
    thiscall = y(round(PupTimes(iAm,1)*fs):round(PupTimes(iAm,2)*fs));
    thistime = t(round(PupTimes(iAm,1)*fs):round(PupTimes(iAm,2)*fs));

    callplot = y(round((PupTimes(iAm,1)-0.05)*fs):round((PupTimes(iAm,1)+0.2)*fs));
    timeplot = t(round((PupTimes(iAm,1)-0.05)*fs):round((PupTimes(iAm,1)+0.2)*fs));
    nexttile
    plot(timeplot,callplot,'k'); ylabel(num2str(iAm));
    ylim([-1 1])
    rmss(iAm) = rms(thiscall);
end

% find the 5 highest and lowest
rmssort = sort(rmss);

rmshigh = zeros(5,1);
rmslow  = zeros(5,1);
for iAm = 1:5 % highs
    rmshigh(iAm) = find(rmss == rmssort(end-(iAm-1)));
    rmslow(iAm) = find(rmss == rmssort(10+iAm));
    % skips due to no response: 51 35 38 29 23 54 21 55 56 39
end

figure
for iAm = 1:length(rmshigh)  
    callplot = y(round((PupTimes(rmshigh(iAm),1)-0.05)*fs):round((PupTimes(rmshigh(iAm),1)+0.2)*fs));
    timeplot = t(round((PupTimes(rmshigh(iAm),1)-0.05)*fs):round((PupTimes(rmshigh(iAm),1)+0.2)*fs));
    nexttile
    plot(timeplot,callplot,'k'); xlabel(num2str(rmslow(iAm)));
    ylim([-1 1])
end

figure
for iAm = 1:length(rmslow)  
    callplot = y(round((PupTimes(rmslow(iAm),1)-0.05)*fs):round((PupTimes(rmslow(iAm),1)+0.2)*fs));
    timeplot = t(round((PupTimes(rmslow(iAm),1)-0.05)*fs):round((PupTimes(rmslow(iAm),1)+0.2)*fs));
    nexttile
    plot(timeplot,callplot,'k'); xlabel(num2str(rmslow(iAm)));
    ylim([-1 1])
end





