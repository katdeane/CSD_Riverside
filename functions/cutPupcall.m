function cutPupcall(homedir,call_list)

% for the pup call CSD
cd(homedir); cd figures; 
if ~exist('Pupcall','dir')
    mkdir('Pupcall')
end
cd('Pupcall')

% load pup call
[y,~] = audioread('PupCall25s.wav');
% audio file has fs of 192000. However, the software is slightly
% slowing the stimulus down as it plays it. Therefore, the following fs
% is based on the RPvdsEx playing (this is at max fs in the software)
fs = 194800;
y = y(:,1);
% CSD has a 399 BL and 1 s post stim time window
prebuff  = zeros(round((399/1000)*fs),1);
% postbuff = zeros(1*fs,1);
ymod = vertcat(prebuff,y); %,postbuff
dt   = 1/fs;
t    = 0:dt:(length(ymod)*dt)-dt;

% load call times
load('PupTimes.mat','PupTimes')
PupTimes = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
PupTimes = PupTimes + 0.400; % add the prestimulus time

figure;
tiledlayout('flow');
nexttile

plot(t,ymod,'k'); xlabel('Seconds'); ylabel('PupCall');
ylim([-1 1])
xlim([0.5 26427.5]/1000) % xlim from full length of pupcall csd

exportgraphics(gcf,'Pupcall_full.pdf')

for icall = call_list
    % 50 ms pre, 200 ms post
    xlim([(PupTimes(icall,1)-0.050) (PupTimes(icall,1)+0.200)]); 
    exportgraphics(gcf,['Pupcall_' num2str(icall) '.pdf'])
end


close all
