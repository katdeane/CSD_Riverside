function PupcallCSD(homedir,subject,cbar)

cd(homedir);
BL = 399;

%% Load in subject data
load([subject '_Data.mat'],'Data');

% load group info to know how many noisebursts there are
run([subject(1:3) '.m']); % brings in animals, channels, Layer, and Cond
% get subject number
subID = find(matches(subject,animals)); % need to check this when it's more than 1 subject in list
% get pupcall measurement number(s)
pupCondList = Cond(subID).Pupcall{:};

for iMeas = 1:length(pupCondList)
    
    index = find(matches([subject '_' pupCondList{iMeas} '_LFP'],{Data.measurement}));
    CSD = Data(index).sngtrlCSD{:}; %#ok<FNDSB>
    CSD = mean(CSD,3); % trial average it
    
    % plot CSD figure and make it cute
    figure;
    tiledlayout('vertical');
    nexttile
    imagesc(CSD)
    % c axis
    colormap jet 
    clim(cbar)
    colorbar
    % x axis
    xticks([400 5400 10400 15400 20400 25400 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('Depth of Cortex [Channels 50 µm apart]')
    % title
    title(['CSD in response to Pup Call for subject ' subject ' measurement ' pupCondList{iMeas}])
    

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

    nexttile
    plot(t,ymod,'k'); xlabel('Seconds'); ylabel('PupCall');
    xlim([0 size(CSD,2)/1000])
    ylim([-1 1])
    
    cd(homedir); cd figures
    if ~exist('PupcallCSD','dir')
        mkdir('PupcallCSD')
    end
    cd PupcallCSD

    savefig(gcf,[subject '_' pupCondList{iMeas} '_Full_Pup_Call'])
    close

    % Time to get choppy my friend 
    load('PupTimes.mat','PupTimes')
    PupTimes    = PupTimes .* 0.9856; % 192000/194800 (fixing fs)
    PupTimes    = PupTimes + 0.400; % add the prestimulus time
    PupTimesCSD = PupTimes .* 1000; % match axes

    % sanity checks 
    % plot(t,ymod,'k'); xlabel('Seconds'); ylabel('PupCall');
    % xlim([0 size(CSD,2)/1000])
    % xline(PupTimes(:,1),'b')
    % xline(PupTimes(:,2),'r')
    % colormap jet; clim(cbar); colorbar
    % 
    % imagesc(CSD)
    % xline(PupTimes(:,1).*1000,'b')
    % xline(PupTimes(:,2).*1000,'r')

    for iCall = 1:size(PupTimes,1)

        callCSD = PupTimesCSD(iCall,1);
        figure;
        tiledlayout('vertical')
        nexttile
        imagesc(CSD)
        % c axis
        colormap jet
        clim(cbar)
        colorbar
        % x axis
        xlim([callCSD-200,callCSD+400])
        xticks([callCSD-200 callCSD-100 callCSD callCSD+100  ...
            callCSD+200 callCSD+300 callCSD+400])
        xticklabels({'0', '100','200','300','400','500','600'})
        % ylabel
        ylabel('Depth of Cortex [Channels 50 µm apart]')
        % title
        title(['CSD in response to Pup Call ' num2str(iCall) ' — ' ...
            subject ' measurement ' pupCondList{iMeas}])

        callWAV = PupTimes(iCall,1);
        nexttile
        plot(t,ymod,'k'); xlabel('Time [ms]'); ylabel('PupCall');
        xlim([callWAV-0.2 callWAV+0.4])
        xticks([callWAV-0.2 callWAV-0.1 callWAV callWAV+0.1 ...
            callWAV+0.2 callWAV+0.3 callWAV+0.4])
        xticklabels({'0', '100','200','300','400','500','600'})
        ylim([-1 1])

        savefig(gcf,[subject '_' pupCondList{iMeas} '_Pup_Call_' num2str(iCall)])
        close

    end
end
cd(homedir)