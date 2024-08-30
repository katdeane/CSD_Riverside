function LaminarPhaseLocking(homedir,Group,params)
% this function calculates phase coherence between layers based off of data
% from \output\WToutput. It saves table of traces averaged over phase
% coherence matrix: spectral frequency x time. Tables are saved with all
% subjects from both groups per condition and stimulus in \output\InterLam_PhaseCo

%It only compares same frequency bands across designated layers,
% e.g.: high gamma coherence between Lay II and IV. 


% actual intended frequencies commented
theta = (49:54);        %(4:7);
alpha = (44:48);        %(8:12);
beta_low = (39:43);     %(13:18);
beta_high = (34:38);    %(19:30);
gamma_low = (26:33);    %(31:60);
gamma_high = (19:25);   %(61:100);

% set up subject call lists
run([Group '.m'])
subList = animals; 

for iCond = 1:length(params.condList) 

    [stimList, ~, ~, ~, ~] = ...
        StimVariable(params.condList{iCond},1,'Awake');

    for iStim = 1:length(stimList) 

        % initialize table out
        sz = [10000 11]; % length will be cut at the end
        varTypes = ["string" ,"string"   ,"double","string","string","cell",...
            "cell"  ,"cell"    ,"cell"   ,"cell"  ,"cell"];
        varNames = ["Subject","Condition","Stim","Lay1","Lay2","GHtrace",...
            "GLtrace","BHtrace","BLtrace","Atrace","Ttrace"];
        dTab = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        count = 1; % I'm sorry 

        for iIn = 1:length(subList) 
            input =  [subList{iIn} '_' params.condList{iCond}...
                '_' num2str(stimList(iStim)) '_WT.mat'];

            load(input, 'wtTable')

            % loop through layer comparisons (if iLay == 'II', iComp -> 'IV' - 'VI')
            for iLay = 1:(length(params.layers)-1) 
                for iComp = iLay+1:length(params.layers)

                    % look at first trial scalogram of layers
                    Lay1 = wtTable(matches(wtTable.layer, params.layers{iLay}),:);
                    Lay2 = wtTable(matches(wtTable.layer, params.layers{iComp}),:);

                    % initialize container for trials
                    GHtracehold = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));
                    GLtracehold = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));
                    BHtracehold = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));
                    BLtracehold = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));
                    Atracehold  = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));
                    Ttracehold  = NaN(size(Lay1,1), size(Lay1.scalogram{1},2));

                    for iTr = 1:size(Lay1,1)
                        Lay1trl = Lay1((Lay1.trial == iTr),1).scalogram{:};
                        Lay2trl = Lay2((Lay2.trial == iTr),1).scalogram{:};

                        % calculate single trial interlaminar phase coherence
                        % (this is the SAME calculation as intertrial phase coherence)
                        Lay1ph = Lay1trl./abs(Lay1trl);
                        Lay2ph = Lay2trl./abs(Lay2trl);

                        Phaseco = Lay1ph + Lay2ph;
                        Phaseco = abs(Phaseco / 2); % 2 for only 2 datapoints, lay 1 and 2

                        GHtracehold(iTr,:) = mean(Phaseco(gamma_high,:),1);
                        GLtracehold(iTr,:) = mean(Phaseco(gamma_low,:),1);
                        BHtracehold(iTr,:) = mean(Phaseco(beta_high,:),1);
                        BLtracehold(iTr,:) = mean(Phaseco(beta_low,:),1);
                        Atracehold(iTr,:)  = mean(Phaseco(alpha,:),1);
                        Ttracehold(iTr,:)  = mean(Phaseco(theta,:),1);

                        % sanity check %
                        % Phasefig = tiledlayout('flow');
                        % title(Phasefig,input)
                        % xlabel(Phasefig, 'time [ms]')
                        % 
                        % nexttile
                        % title('Phase Coherence')
                        % imagesc(flipud(Phaseco(19:54,:)))
                        % set(gca,'Ydir','normal')
                        % yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
                        % yticklabels({'0','10','20','30','40','50','60','80','100'})
                        % ylabel('Frequency [Hz]')
                        % xline(400,'LineWidth',2)
                        % colorbar
                        % 
                        % nexttile
                        % plot(GHtracehold(iTr,:),'LineWidth',2);
                        % hold on
                        % plot(GLtracehold(iTr,:),'LineWidth',2)
                        % plot(BHtracehold(iTr,:),'LineWidth',2);
                        % plot(BLtracehold(iTr,:),'LineWidth',2);
                        % plot(Atracehold(iTr,:),'LineWidth',2);
                        % plot(Ttracehold(iTr,:),'LineWidth',2);
                        % xline(400,'LineWidth',2)
                        % legend('High Gamma', 'Low Gamma', 'High Beta', 'Low Beta','Alpha','Theta','Onset')
                        % ylabel('Phase Coherence')
                        % close

                        clear Lay1trl Lay2trl
                    end % trial

                    % average the trial traces
                    GHtrace = mean(GHtracehold);
                    GLtrace = mean(GLtracehold);
                    BHtrace = mean(BHtracehold);
                    BLtrace = mean(BLtracehold);
                    Atrace  = mean(Atracehold);
                    Ttrace  = mean(Ttracehold);

                    % "Subject","Condition","Stim",
                    % "Lay 1","Lay 2","GHtrace",
                    % "GLtrace","BHtrace","BLtrace","Atrace","Ttrace"
                    dTab(count,:) = {subList{iIn},params.condList{iCond},stimList(iStim)...
                        params.layers{iLay},params.layers{iComp},{GHtrace},...
                        {GLtrace},{BHtrace},{BLtrace},{Atrace},{Ttrace}};
                    count = count + 1;

                    clear Lay1 Lay2
                end % layer 2
            end % layer 1
            clear wtTable
        end % data input

        % remove all unfilled rows (trial column filled with 0 but 
        % trial == 0 is not possible)
        dTab = dTab(dTab.Stim ~= 0,:);

        % save out per condition/stimulus
        cd(homedir);cd output
        if ~exist('InterLam_PhaseCo','dir')
            mkdir('InterLam_PhaseCo');
        end
        cd InterLam_PhaseCo
        savename = ['InterLam_' Group '_' params.condList{iCond} '_' num2str(stimList(iStim)) '.mat'];
        save(savename, 'dTab')

    end % stimulus
end % condition

cd(homedir)

