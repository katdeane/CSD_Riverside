function visualize_PAC(homedir,Groups, Condition,whichsig)
% This function takes the phase amplitude zscore modulation index values 
% collected by core_PAC.m along with the added layer column from 
% AddLayerColumns.m and gives back the bat and mouse zMI matrixes with
% frequency amplitudes over frequency phases, the difference between them,
% the significant p values calculated and cohen's d as a figure as well as
% matrices Bat and Mouse zMI, t test result matrix, the t value threshold,
% and the cohen's d matrix results. 

% Out:  \figures\PACoutput\*.fig  

% NOTE: This is currently being run only with the center channel for each
% layer and not all channels in the layer together.

% load all the data in together
Grp1     = readtable([Groups{1} '_' Condition '_' whichsig '_PhaseAmpCoupling.csv']);
Grp2     = readtable([Groups{2} '_' Condition '_' whichsig '_PhaseAmpCoupling.csv']);
% stimfreq list
Grp1stimlist = unique(Grp1.StimFreq);
Grp2stimlist = unique(Grp2.StimFreq);
% layer list
laylist  = {'II' 'IV' 'Va' 'Vb' 'VI'};
% condition specific info
[~, thisUnit, ~, ~, ~] = ...
    StimVariablePAC(Condition,1);

% get unique phases and amps and number of each
phases    = unique([Grp1.phase_from]);
amps      = unique([Grp1.amp_from]);
Nph       = numel(phases);
Namp      = numel(amps);

for iStim = 1:length(Grp1stimlist)
    
    Grp1Stim = Grp1(Grp1.StimFreq == Grp1stimlist(iStim),:);
    Grp2Stim = Grp2(Grp2.StimFreq == Grp2stimlist(iStim),:);
    
    for iLay = 1:length(laylist)
        %% Group 1
        
        PACfig = tiledlayout('flow');
        title(PACfig,[Condition ' CSD PAC at ' num2str(Grp1stimlist(iStim)) ...
            ' ' thisUnit])
        xlabel(PACfig, 'Frequency phase')
        ylabel(PACfig, 'Frequency amplitude')

        % choosing *just* the center channel now, not all layer channels:
        Grp1Ch = Grp1Stim(contains(Grp1Stim.LayerColumn, ['center' ...
            laylist{iLay}]),:);
        % find number of measurements here (not all layers have all)
        Nmeas = size(Grp1Ch,1)/Namp/Nph;
        % preallocate PAC figure matrix
        Grp1PAC = NaN(Namp, Nph, Nmeas);
        
        for iamp = 1:Namp
            
            Grp1Am = Grp1Ch(Grp1Ch.amp_from == amps(iamp),:);
            
            for iph = 1:Nph
                
                Grp1Ph = Grp1Am(Grp1Am.phase_from == phases(iph),:);
                % all of the zscore modulation index values stored for testing
                Grp1PAC(iamp, iph, :) = Grp1Ph.zMI;
                
            end
        end
        
        % mouse figure,
        nexttile
        % flip so phase 1 v amp 1 is lower left corner
        Grp1Avg = flip(nanmean(Grp1PAC,3),1);
        imagesc(Grp1Avg);
        xtickangle(45)
        xticks(1:Nph)
        xticklabels({'1-3','3-5','5-7','7-9','9-11','11-13','11-15'})
        yticks(1:Namp)
        yticklabels({'95-105','90-100','85-95','80-90','75-85','70-80','65-75','60-70','55-65',...
            '50-60','45-55','40-50','35-45','30-40','25-35'})
        % caxis([-0.5 1.5])
        colorbar
        title([Groups{1}  ' Avg: ' num2str(nanmean(nanmean(nanmean(Grp1PAC))))])
        
        %% Group 2
        
        % choosing *just* the center channel now, not all layer channels:
        Grp2Ch = Grp2Stim(contains(Grp2Stim.LayerColumn, ['center' laylist{iLay}]),:);
        % find number of measurements here (not all layers have all)
        Nmeas = size(Grp2Ch,1)/Namp/Nph;
        % preallocate PAC figure matrix
        Grp2PAC = NaN(Namp, Nph, Nmeas);
        
        for iamp = 1:Namp
            
            Grp2Am = Grp2Ch(Grp2Ch.amp_from == amps(iamp),:);
            
            for iph = 1:Nph
                
                Grp2Ph = Grp2Am(Grp2Am.phase_from == phases(iph),:);
                % all of the zscore modulation index values stored for testing
                Grp2PAC(iamp, iph, :) = Grp2Ph.zMI;
                
            end
        end
        
        % bat figure,
        nexttile
        % flip so phase 1 v amp 1 is lower left corner
        GrpAvg = flip(nanmean(Grp2PAC,3),1);
        imagesc(GrpAvg);
        xtickangle(45)
        xticks(1:Nph)
        xticklabels({'1-3','3-5','5-7','7-9','9-11','11-13','11-15'})
        yticks(1:Namp)
        yticklabels({'95-105','90-100','85-95','80-90','75-85','70-80','65-75','60-70','55-65',...
            '50-60','45-55','40-50','35-45','30-40','25-35'})
        % caxis([-0.5 1.5])
        colorbar
        title([Groups{2} ' Avg: ' num2str(nanmean(nanmean(nanmean(Grp2PAC))))])
        
        % %% DIFF
        % Diff = MouseAvg - BatAvg;
        % 
        % % difference figure,
        % subplot(1,5,3)
        % imagesc(Diff);
        % xtickangle(45)
        % xticks(1:Nph)
        % xticklabels({'1-3','3-5','5-7','7-9','9-11','11-13','11-15'})
        % xlabel('Frequency phase')
        % yticks(1:Namp)
        % yticklabels({'95-105','90-100','85-95','80-90','75-85','70-80','65-75','60-70','55-65',...
        %     '50-60','45-55','40-50','35-45','30-40','25-35'})
        % ylabel('Frequency amplitude')
        % caxis([-1.5 1.5])
        % colorbar
        % title('Difference')
        
        % %% Student's t test
        % df = MouseAnMe+BatAnMe-2;
        % % get significance threshold
        % if df == 72
        %     t_thresh = 1.668; %two tailed: 1.995
        % elseif df == 5
        %     t_thresh = 2.015; %two tailed: 2.571
        % else
        %     error('You need to change your tvalue threshold! Check this link: http://www.ttable.org/')
        % end
        % % get the std of each groups
        % MouseSTD = flip(nanstd(MousePAC,0,3),1); % 0 = don't normalize
        % BatSTD   = flip(nanstd(BatPAC,0,3),1);
        % % run a matrix t-test
        % tmatrix = (MouseAvg - BatAvg)./...
        %     sqrt((MouseSTD.^2/MouseAnMe) + (BatSTD.^2/BatAnMe));
        % 
        % clusters = tmatrix;
        % clusters(t_thresh*-1 < clusters & clusters < t_thresh) = 0;
        % clusters(clusters <= t_thresh*-1) = -1;
        % clusters(clusters >= t_thresh) = 1;
        % 
        % tmap = [5/255 36/255 56/255
        %     205/255 197/255 180/255
        %     189/255 64/255 6/255];
        % 
        % % t-test figure,
        % tfig = subplot(1,5,4);
        % imagesc(clusters)
        % xtickangle(45)
        % xticks(1:Nph)
        % xticklabels({'1-3','3-5','5-7','7-9','9-11','11-13','11-15'})
        % xlabel('Frequency phase')
        % yticks(1:Namp)
        % yticklabels({'95-105','90-100','85-95','80-90','75-85','70-80','65-75','60-70','55-65',...
        %     '50-60','45-55','40-50','35-45','30-40','25-35'})
        % ylabel('Frequency amplitude')
        % colormap(tfig,tmap)
        % title('p<0.05 t Test')
        % 
        % %% Cohen's d test
        % 
        % S = sqrt((((MouseAnMe - 1) .* MouseSTD.^2) + ((BatAnMe-1) .* BatSTD.^2)) ...
        %     / (MouseAnMe + BatAnMe - 2));
        % cohensD = (MouseAvg-BatAvg)./S;
        % 
        % newD = cohensD;
        % newD(newD<0.2   & newD>-0.2)    = 0;   % very small
        % newD(newD>0.2   & newD<0.5)     = 0.35; % small
        % newD(newD<-0.2  & newD>-0.5)    = 0.35; % small
        % newD(newD>0.5   & newD<0.8)     = 0.65; % medium
        % newD(newD<-0.5  & newD>-0.8)    = 0.65; % medium
        % newD(newD>0.8   & newD<1.2)     = 1;   % large
        % newD(newD<-0.8  & newD>-1.2)    = 1;   % large
        % newD(newD>1.2   & newD<1.5)     = 1.35; % very large
        % newD(newD<-1.2  & newD>-1.5)    = 1.35; % very large
        % newD(newD>1.5)                  = 1.65;   % huge
        % newD(newD<-1.5)                 = 1.65;   % huge
        % 
        % % a new color map for this because matlab sucks at color
        % CDmap = [250/255 240/255 240/255
        %     230/255 179/255 179/255
        %     209/255 117/255 120/255
        %     184/255 61/255 65/255
        %     122/255 41/255 44/255
        %     61/255 20/255 22/255];
        % 
        % % cohen's d effect size figure,
        % CDfig = subplot(1,5,5);
        % imagesc(newD);
        % xtickangle(45)
        % xticks(1:Nph)
        % xticklabels({'1-3','3-5','5-7','7-9','9-11','11-13','11-15'})
        % xlabel('Frequency phase')
        % yticks(1:Namp)
        % yticklabels({'95-105','90-100','85-95','80-90','75-85','70-80','65-75','60-70','55-65',...
        %     '50-60','45-55','40-50','35-45','30-40','25-35'})
        % ylabel('Frequency amplitude')
        % colorbar;
        % colormap(CDfig,CDmap)
        % title('Cohens d')
        % 
        % % save the data for possible further use
        % cd(homedir); cd Comparison; cd PACoutput % should exist already
        Savename = [Condition ' PAC at ' num2str(Grp1stimlist(iStim)) ...
            ' ' thisUnit];
        % save([Savename '.mat'],'MousePAC','BatPAC','tmatrix','t_thresh','cohensD')
        % 
        % % save the figure cause it's pretty (and we need it ofc)
        % set(H, 'PaperType', 'A4');
        % set(H, 'PaperOrientation', 'landscape');
        % set(H, 'PaperUnits', 'centimeters');
        % 
        cd(homedir); cd figures
        if exist('PACoutput','dir') == 7
            cd PACoutput
        else
            mkdir('PACoutput'),cd PACoutput
        end
        savefig([Savename '.fig'])
        close
    end
end
end