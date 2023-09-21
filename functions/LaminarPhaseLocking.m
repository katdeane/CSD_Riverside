function LaminarPhaseLocking(homedir,params)
% this function calculates phase coherence between layers based off of data
% from \output\WToutput. It saves table of traces averaged over phase
% coherence matrix: spectral frequency x time. Tables are saved with all
% subjects from both groups per condition and stimulus in \output\InterLam_PhaseCo

% This is a novel analysis method developed by Katrina Deane for the
% purpose of exploring phase-phase relationships throughout the laminar
% profile. It only compares same frequency bands across designated layers,
% e.g.: high gamma coherence between Lay II and IV. This will be called
% interlaminar phase coherence and it is based on the calculation of
% intertrial phase coherence.


% actual intended frequencies commented
theta = (49:54);        %(4:7);
alpha = (44:48);        %(8:12);
beta_low = (39:43);     %(13:18);
beta_high = (34:38);    %(19:30);
gamma_low = (26:33);    %(31:60);
gamma_high = (19:25);   %(61:100);


for iCond = 1:length(params.condList) 

    [stimList, ~, ~, ~, ~] = ...
        StimVariable(params.condList{iCond},1);

    for iStim = 1:length(stimList) 

        cd (homedir); cd output; cd WToutput
        input = dir(['*_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '_WT.mat']);

        % initialize table out
        sz = [10000 12]; % length will be cut at the end
        varTypes = ["string" ,"string"   ,"double","string","string","double","cell",...
            "cell"  ,"cell"    ,"cell"   ,"cell"  ,"cell"];
        varNames = ["Subject","Condition","Stim","Lay1","Lay2","trial","GHtrace",...
            "GLtrace","BHtrace","BLtrace","Atrace","Ttrace"];
        dTab = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        count = 1; % I'm sorry 

        for iIn = 1:length(input) 
            load(input(iIn).name, 'wtTable')

            % loop through layer comparisons (if iLay == 'II', iComp -> 'IV' - 'VI')
            for iLay = 1:(length(params.layers)-1) 
                for iComp = iLay+1:length(params.layers)

                    % look at first trial scalogram of layers
                    Lay1 = wtTable(matches(wtTable.layer, params.layers{iLay}),:);
                    Lay2 = wtTable(matches(wtTable.layer, params.layers{iComp}),:);

                    for iTr = 1:size(Lay1,1)
                        Lay1trl = Lay1((Lay1.trial == iTr),1).scalogram{:};
                        Lay2trl = Lay2((Lay2.trial == iTr),1).scalogram{:};

                        % calculate single trial interlaminar phase coherence
                        % (this is the SAME calculation as intertrial phase coherence)
                        Lay1ph = Lay1trl./abs(Lay1trl);
                        Lay2ph = Lay2trl./abs(Lay2trl);

                        Phaseco = Lay1ph + Lay2ph;
                        Phaseco = abs(Phaseco / 2); % 2 for only 2 datapoints, lay 1 and 2

                        GHtrace = mean(Phaseco(gamma_high,:),1);
                        GLtrace = mean(Phaseco(gamma_low,:),1);
                        BHtrace = mean(Phaseco(beta_high,:),1);
                        BLtrace = mean(Phaseco(beta_low,:),1);
                        Atrace  = mean(Phaseco(alpha,:),1);
                        Ttrace  = mean(Phaseco(theta,:),1);

                        % sanity check %
                        % Phasefig = tiledlayout('flow');
                        % title(Phasefig,[input(1).name])
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
                        % plot(GHtrace,'LineWidth',2);
                        % hold on
                        % plot(GLtrace,'LineWidth',2)
                        % plot(BHtrace,'LineWidth',2);
                        % plot(BLtrace,'LineWidth',2);
                        % plot(Atrace,'LineWidth',2);
                        % plot(Ttrace,'LineWidth',2);
                        % xline(400,'LineWidth',2)
                        % legend('High Gamma', 'Low Gamma', 'High Beta', 'Low Beta','Alpha','Theta','Onset')
                        % ylabel('Phase Coherence')
                        % close

                        % "Subject","Condition","Stim",
                        % "Lay 1","Lay 2","trial","GHtrace",
                        % "GLtrace","BHtrace","BLtrace","Atrace","Ttrace"
                        dTab(count,:) = {input(iIn).name(1:5),params.condList{iCond},stimList(iStim)...
                            params.layers{iLay},params.layers{iComp},iTr,{GHtrace},...
                            {GLtrace},{BHtrace},{BLtrace},{Atrace},{Ttrace}};
                        count = count + 1;

                        clear Lay1trl Lay2trl
                    end % trial
                    clear Lay1 Lay2
                end % layer 2
            end % layer 1
            clear wtTable
        end % data input

        % remove all unfilled rows (trial column filled with 0 but 
        % trial == 0 is not possible)
        dTab = dTab(dTab.trial ~= 0,:);

        % save out per condition/stimulus
        cd(homedir);cd output
        if ~exist('InterLam_PhaseCo','dir')
            mkdir('InterLam_PhaseCo');
        end
        cd InterLam_PhaseCo
        savename = ['InterLam_' params.condList{iCond} '_' num2str(stimList(iStim)) '.mat'];
        save(savename, 'dTab')

    end % stimulus
end % condition

cd(homedir)

