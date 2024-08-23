function Group_Avrec_Stack(homedir,Group,Condition,type)

% This script takes *.mat files out of the figures\Group_Avrec folder which is
% generated by the Avrec_Layers.m script. MAKE SURE you run the previous
% Avrec script on the current group.m and datastructs\*_DATA.mat so that things match
% up. This script is dynamic in group size but will need tweaking if a
% group is added.

%Input:     ..\Figures\Group_Avrec -> *AvrecAll.mat
%Output:    ..\Figures\Group_Avrec -> figures of full and layer-wise Avrecs
%           pre laser and post laser, including standard deviation

% Normalization of the layer to the highest peak of the average trace of
%   measurements can be toggled (yesnorm)

% set some species specific variables:
cd(homedir)
BL     = 399;
layers = {'All', 'II', 'IV', 'Va', 'Vb', 'VI'};
[stimList, thisUnit, stimDur, stimITI, ~] = StimVariable(Condition,1,type);
timeaxis = BL + stimDur + stimITI;
colors = {'-b', '-r', '-c', '-g', '-k', '-m', '-y','-b','-r','-c','-g'};

%% Choose Type

yesnorm = 1;            % 1 = normalize to highest Pre peak; 0 = don't

if exist([Group '_' Condition '_AvrecCSDAll.mat'])

    load([Group '_' Condition '_AvrecCSDAll.mat'],'AvrecCSDAll','PeakofAvgCSD')

    %% To Norm or not to Norm

    % normalize to the peak of avrec activity during 70 dB noiseburst or first
    % peak of first stimulus (if not noiseburst)
    Subject = 0;
    if yesnorm == 1
        for iAn = 1:length(PeakofAvgCSD)
            if isempty(PeakofAvgCSD{iAn}) % skip empty ones
                continue
            end
            Subject = Subject + 1; % yes this isn't great, sorry
            for iStim = 1:size(AvrecCSDAll,1)
                for iLay = 1:size(AvrecCSDAll,2)
                    % normalize each animal's measuremnt to their 2Hz peak
                    % of activity of the Avrec.
                    toNormto = PeakofAvgCSD{iAn};
                    AvrecCSDAll{iStim,iLay,Subject} = AvrecCSDAll{iStim,iLay,iAn} ./ toNormto;
                end
            end
        end
    end

    if length(size(AvrecCSDAll)) == 3 % more than 1 subject
        subjects = size(AvrecCSDAll,3);
    else
        subjects = 1;
    end

    cd figures; cd Group_Avrec;

    for iStim = 1:length(stimList)

        savenamecsd = ['Stacked_' Group '_' Condition '_' num2str(stimList(iStim))];

        CSDfig = tiledlayout('vertical');
        title(CSDfig,[Group ' ' Condition ' ' num2str(stimList(iStim)) ' ' thisUnit])
        xlabel(CSDfig, 'time [ms]')
        ylabel(CSDfig, 'depth [channels]')

        for iLay = 1:length(layers)

            % CSD
            nexttile
            title([num2str(stimList(iStim)) ' ' thisUnit ' ' layers{iLay}])
            hold on

            for iSub = 1:subjects
                thissub = squeeze(AvrecCSDAll{iStim,iLay,iSub});
                shadedErrorBar(1:size(thissub,1),nanmean(thissub,2),...
                    nanstd(thissub,0,2),'lineProps', colors{iSub})
            end
        end
        xticks(0:200:timeaxis)
        linkaxes;
        xlim([BL-99 BL+stimDur+101])
        cury = get(gca,'ylim');
        ylim([0 cury(2)])
        savefig(gcf,savenamecsd,'compact')
        close all
    end

    cd(homedir)
end


