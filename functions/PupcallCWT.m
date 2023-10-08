function PupcallCWT(homedir,subject,params)

cd(homedir);
BL = 399;

%% Load in subject data
load([subject '_Pupcall_1_WT.mat'],'wtTable');

cd(homedir); cd figures
if ~exist('PupcallCWT','dir')
    mkdir('PupcallCWT')
end
cd PupcallCWT

% run through layers
for iLay = 1:length(params.layers)

    % take out just this layer
    wtLay = wtTable(matches(wtTable.layer, params.layers{iLay}),:);

    % set up wave image
    [y,fs] = audioread('PupCall25s.wav');
    y = y(:,1);
    % CSD has a 399 BL and 1 s post stim time window
    prebuff = zeros((BL/1000)*fs,1);
    postbuff = zeros(1*fs,1);
    ymod = vertcat(prebuff,y,postbuff);
    dt = 1/fs;
    t = 0:dt:(length(ymod)*dt)-dt;

    % power and phase coherence for this layer 
    Power = squeeze(getpowerout(wtLay));
    Phase = squeeze(getphaseout(wtLay));

    % plot Power figure and make it cute
    figure;
    tiledlayout('vertical')
    nexttile
    imagesc(flipud(Power(19:54,:))) % the cwt function gives us back a yaxis flipped result
    % y axis
    set(gca,'Ydir','normal')
    yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
    yticklabels({'0','10','20','30','40','50','60','80','100'})
    ylabel('Frequency [Hz]')
    % c axis
    colorbar
    % x axis
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % title
    title(['Power to Pup Call for subject ' subject ' ' params.layers{iLay}])

    % plot Phase
    nexttile
    imagesc(flipud(Phase(19:54,:))) % the cwt function gives us back a yaxis flipped result
    % y axis
    set(gca,'Ydir','normal')
    yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
    yticklabels({'0','10','20','30','40','50','60','80','100'})
    ylabel('Frequency [Hz]')
    % c axis
    colorbar
    clim([0 1])
    % x axis
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % title
    title(['Power to Pup Call for subject ' subject ' ' params.layers{iLay}])

    % plot the pup call
    nexttile
    plot(t,ymod,'k'); xlabel('Time [s]'); ylabel('PupCall');
    xlim([0 size(Power,2)/1000])
    ylim([-1 1])

    savefig(gcf,[subject '_' params.layers{iLay} '_Full_Pup_Call'])
    close

    % Time to get choppy my friend 
    load('PupTimes.mat','PupTimes')
    PupTimes    = PupTimes + 0.399;
    PupTimesCWT = PupTimes .* 1000;

    % sanity checks 
    % plot(t,ymod,'k'); xlabel('Seconds'); ylabel('PupCall');
    % xlim([0 size(CSD,2)/1000])
    % xline(PupTimes(:,1),'b')
    % xline(PupTimes(:,2),'r')
    %
    % imagesc(CSD)
    % xline(PupTimes(:,1).*1000,'b')
    % xline(PupTimes(:,2).*1000,'r')

    for iCall = 1:size(PupTimes,1)

        callCSD = PupTimesCWT(iCall,1);
        callWAV = PupTimes(iCall,1);

        figure;
        tiledlayout('vertical')
        nexttile
        imagesc(flipud(Power(19:54,:))) % the cwt function gives us back a yaxis flipped result
        % y axis
        set(gca,'Ydir','normal')
        yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
        yticklabels({'0','10','20','30','40','50','60','80','100'})
        ylabel('Frequency [Hz]')
        % c axis
        colorbar
        % x axis
        % x axis
        xlim([callCSD-200,callCSD+400])
        xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
            callCSD+200 callCSD+300 callCSD+400])
        xticklabels({'0', '100','200','300','400','500','600'})
        % title
        title(['Power to Pup Call for subject ' subject ' ' params.layers{iLay}])

        % plot Phase
        nexttile
        imagesc(flipud(Phase(19:54,:))) % the cwt function gives us back a yaxis flipped result
        % y axis
        set(gca,'Ydir','normal')
        yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
        yticklabels({'0','10','20','30','40','50','60','80','100'})
        ylabel('Frequency [Hz]')
        % c axis
        colorbar
        clim([0 1])
        % x axis
        xlim([callCSD-200,callCSD+400])
        xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
            callCSD+200 callCSD+300 callCSD+400])
        xticklabels({'0', '100','200','300','400','500','600'})
        % title
        title(['Power to Pup Call for subject ' subject ' ' params.layers{iLay}])

        % plot the pup call
        nexttile
        plot(t,ymod,'k'); xlabel('Time [ms]'); ylabel('PupCall');
        xlim([callWAV-0.2 callWAV+0.4])
        xticks([callWAV-0.2 callWAV-0.1 callWAV callWAV+0.1 ...
            callWAV+0.2 callWAV+0.3 callWAV+0.4])
        xticklabels({'0', '100','200','300','400','500','600'})
        ylim([-1 1])

        savefig(gcf,[subject '_' params.layers{iLay} '_Pup_Call_' num2str(iCall)])
        close

    end
end
cd(homedir)