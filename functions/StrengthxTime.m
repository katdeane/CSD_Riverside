function StrengthxTime(homedir, Group, Condition)

%% pull relevant data 

[stimList, thisUnit, ~, ~, ~] = ...
    StimVariable(Condition,1);

% load current table, includes all group data for this condition
Table = readtable([Group '_' Condition '_AVRECPeak.csv']);

% we'll focus on just AVREC peak amplitude for OVERALL strength of activity
Table = Table(matches(Table.Layer,'All'),:);

% now we only need the very first stimulus response across each trial 
% (That's "OrderofClick" as a relic for when this was explicitely created
% for click train stimuli)
Table = Table(Table.OrderofClick == 1,:);

% table should now be length: number of trials x number of stim types 
% (ClickFreq also a relic). Double check that stim list in table matches
% what it should
if length(stimList) ~= length(unique(Table.ClickFreq))
    error('the stim list and data in the table dont match')
end
subList = unique(Table.Animal);

%% 
cd(homedir); cd figures; 
if exist('Strength_x_Time','dir')
    cd Strength_x_Time;
else
    mkdir Strength_x_Time, cd Strength_x_Time;
end

for iSub = 1:length(subList)

    subTable = Table(matches(Table.Animal,subList{iSub}),:);

    for istim = 1:length(stimList)

        % visualize data
        stimTable = subTable(subTable.ClickFreq == stimList(istim),:);
        PeakAmp   = stimTable.PeakAmp;
        clear stimTable

        figure
        plot(PeakAmp,'-o','MarkerFaceColor','m')
        ylim([0 inf])
        xlabel('Trials')
        ylabel('Avrec Peak Amplitude of first stim response [mV/mm²]')
        title([subList{iSub} ' ' Condition ' ' num2str(stimList(istim)) ' ' ...
            thisUnit ' reponse strength over time'])

        % calculate the percent drop in strength
        firstfive = mean(PeakAmp(1:5)); % max of first 10
        lastfive  = mean(PeakAmp(end-4:end)); % min of last 10 trials

        drop = 100 - (lastfive/firstfive * 100);

        % add it to the figure
        legend(['avg first 5 = ' sprintf('%0.2f', firstfive) ...
            '; avg end 5 = ' sprintf('%0.2f', lastfive) '; ' ...
            sprintf('%0.2f', drop) '% drop of response strength'],...
            'Location','south')

        savefig(gcf,[subList{iSub} ' ' Condition ' ' num2str(stimList(istim)) ' ' ...
            thisUnit ' strength x time'],'compact')
        close

    end
    clear subTable
end
cd(homedir)
