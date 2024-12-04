function PupcallTraces(homedir,subject)

cd(homedir);
BL = 399;

%% Load in subject data
load([subject '_Data.mat'],'Data');

% load group info to know how many noisebursts there are
run([subject(1:3) '.m']); % brings in animals, channels, Layer, and Cond
% get subject number
subID = find(matches(subject,animals)); % need to check this when it's more than 1 subject in list
% get pupcall measurement number(s)
pupCondList = Cond(subID).Pupcall30{:};

for iMeas = 1:length(pupCondList)
    
    index = find(strcmp({Data.measurement},[subject '_' pupCondList{iMeas} '_LFP']));
    CSD = Data(index).sngtrlCSD{:}; %#ok<FNDSB>
    % Get the traces ready
    % pull out and average rectify each measurement
    recCSD  = abs(CSD);
    AVREC   = mean(recCSD,1); 
    % layers
    IItrace = CSD((str2num(Layer(subID).II{:})),:,:);
    IItrace = IItrace * -1;         % flip it
    IItrace(IItrace < 0) = NaN;   % nan-source it
    IItrace = nanmean(IItrace,1); % average it (with nans)
    IItrace(isnan(IItrace)) = 0;  % replace nans with 0s for consecutive line
    IVtrace = CSD((str2num(Layer(subID).IV{:})),:,:);
    IVtrace = IVtrace * -1;         % flip it
    IVtrace(IVtrace < 0) = NaN;   % nan-source it
    IVtrace = nanmean(IVtrace,1); % average it (with nans)
    IVtrace(isnan(IVtrace)) = 0;  % replace nans with 0s for consecutive line
    Vatrace = CSD((str2num(Layer(subID).Va{:})),:,:);
    Vatrace = Vatrace * -1;         % flip it
    Vatrace(Vatrace < 0) = NaN;   % nan-source it
    Vatrace = nanmean(Vatrace,1); % average it (with nans)
    Vatrace(isnan(Vatrace)) = 0;  % replace nans with 0s for consecutive line
    Vbtrace = CSD((str2num(Layer(subID).Vb{:})),:,:);
    Vbtrace = Vbtrace * -1;         % flip it
    Vbtrace(Vbtrace < 0) = NaN;   % nan-source it
    Vbtrace = nanmean(Vbtrace,1); % average it (with nans)
    Vbtrace(isnan(Vbtrace)) = 0;  % replace nans with 0s for consecutive line
    VItrace = CSD((str2num(Layer(subID).VI{:})),:,:);
    VItrace = VItrace * -1;         % flip it
    VItrace(VItrace < 0) = NaN;   % nan-source it
    VItrace = nanmean(VItrace,1); % average it (with nans)
    VItrace(isnan(VItrace)) = 0;  % replace nans with 0s for consecutive line

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
    shadedErrorBar(1:size(AVREC,2),mean(AVREC,3),std(AVREC,0,3),'lineprops','b');
    % title
    title(['Response to Pupcall for subject ' subject ' measurement ' pupCondList{iMeas}])
    % x axis
    xlim([0 size(CSD,2)])
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('AVREC [mV/mm²]')
    ylim([0 max(max(AVREC))])
    
    % next up is the wave file
    nexttile
    plot(t,ymod,'k'); ylabel('PupCall');
    xlim([0 size(CSD,2)/1000])
    ylim([-1 1])
    
    % layer II
    nexttile
    shadedErrorBar(1:size(IItrace,2),mean(IItrace,3),std(IItrace,0,3),'lineprops','b');
    % x axis
    xlim([0 size(CSD,2)])
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('II [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer IV
    nexttile
    shadedErrorBar(1:size(IVtrace,2),mean(IVtrace,3),std(IVtrace,0,3),'lineprops','b');
    % x axis
    xlim([0 size(CSD,2)])
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('IV [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer Va
    nexttile
    shadedErrorBar(1:size(Vatrace,2),mean(Vatrace,3),std(Vatrace,0,3),'lineprops','b');
    % x axis
    xlim([0 size(CSD,2)])
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('Va [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer Vb
    nexttile
    shadedErrorBar(1:size(Vbtrace,2),mean(Vbtrace,3),std(Vbtrace,0,3),'lineprops','b');
    % x axis
    xlim([0 size(CSD,2)])
    xticks([400 5000 10000 15000 20000 25000 25427])
    xticklabels({'On','5','10','15','20','','Off'})
    % ylabel
    ylabel('Vb [mV/mm²]')
    ylim([0 max(max(AVREC))])
    % layer VI
    nexttile
    shadedErrorBar(1:size(VItrace,2),mean(VItrace,3),std(VItrace,0,3),'lineprops','b');
    % x axis
    xlim([0 size(CSD,2)])
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

    savefig(gcf,[subject '_' pupCondList{iMeas} '_Full_Call_Traces'])
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
    %
    % imagesc(CSD)
    % xline(PupTimes(:,1).*1000,'b')
    % xline(PupTimes(:,2).*1000,'r')

    callList = [1 18 30 44 60];

    for iCall = callList

        callCSD = PupTimesCSD(iCall,1);
        callWAV = PupTimes(iCall,1);

        % draw!
        figure
        tiledlayout('vertical')
        % AVREC
        nexttile
        % plot them with shaded error bar
        shadedErrorBar(1:size(AVREC,2),mean(AVREC,3),std(AVREC,0,3),'lineprops','b');
        % title
        title(['Response to Pupcall for subject ' subject ' measurement ' pupCondList{iMeas}])
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('AVREC [mV/mm²]')
        ylim([0 max(max(AVREC))])

        % next up is the wave file
        nexttile
        plot(t,ymod,'k'); ylabel('PupCall');
        xlim([callWAV-0.05 callWAV+0.2])
        xticks([callWAV callWAV+0.1 callWAV+0.2])
        xticklabels({'0', '100','200'})
        ylim([-1 1])

        % layer II
        nexttile
        shadedErrorBar(1:size(IItrace,2),mean(IItrace,3),std(IItrace,0,3),'lineprops','b');
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('II [mV/mm²]')
        ylim([0 max(max(AVREC))])
        % layer IV
        nexttile
        shadedErrorBar(1:size(IVtrace,2),mean(IVtrace,3),std(IVtrace,0,3),'lineprops','b');
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('IV [mV/mm²]')
        ylim([0 max(max(AVREC))])
        % layer Va
        nexttile
        shadedErrorBar(1:size(Vatrace,2),mean(Vatrace,3),std(Vatrace,0,3),'lineprops','b');
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('Va [mV/mm²]')
        ylim([0 max(max(AVREC))])
        % layer Vb
        nexttile
        shadedErrorBar(1:size(Vbtrace,2),mean(Vbtrace,3),std(Vbtrace,0,3),'lineprops','b');
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('Vb [mV/mm²]')
        ylim([0 max(max(AVREC))])
        % layer VI
        nexttile
        shadedErrorBar(1:size(VItrace,2),mean(VItrace,3),std(VItrace,0,3),'lineprops','b');
        % x axis
        xlim([callCSD-50,callCSD+200])
        xticks([callCSD callCSD+100 callCSD+200])
        xticklabels({'0', '100','200'})
        % ylabel
        ylabel('VI [mV/mm²]')
        ylim([0 max(max(AVREC))])

        savefig(gcf,[subject '_' pupCondList{iMeas} '_Call_Traces_' num2str(iCall)])
        close

    end
end
cd(homedir)