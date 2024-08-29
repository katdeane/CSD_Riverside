function CWTFigs(homedir,whichtest,params,Group,type)
% Input:    Layer to analyze, (possible input: relative to BF)
%           Needs scalogramsfull.mat from Andrew Curran's wavelet analysis
% specifying Power: trials are averaged and then power is taken from
%           the complex WT output of runCwtCsd function above. Student's t
%           test and Cohen'd d effect size are the stats used for observed
%           and permutation difference
% specifying Phase: phase is taken per trial. mwu test and r effect
%           size are the stats used
% Output:   Figures for means and observed difference of comparison;
%           figures for observed t values, clusters
%           output; boxplot and significance of permutation test
%% standard operations

if ~exist('whichtest','var')
    whichtest = 'Power'; % or 'Phase'
end

disp(['Observed Individual ' whichtest])

%% Load in and concatonate Data
cd (homedir);
run([Group '.m']); % just need variable animals
clear channels Condition Cond Layer

for iSub = 1:length(animals)

    for iCond = 1:length(params.condList)
        tic
        disp(['For condition: ' params.condList{iCond}])

        % condition specific info
        [stimList, thisUnit, stimDur, ~, ~,~,~] = ...
            StimVariableCWT(params.condList{iCond},1,type);

        for iStim = 1:length(stimList)
            disp(['For stimulus: ' num2str(stimList(iStim))])


            % stack first group data
            input = [animals{iSub} '_' params.condList{iCond} '_' num2str(stimList(iStim)) '_WT.mat'];
            if ~exist(input,'file')
                continue
            end
            load(input, 'wtTable')

            % loop through layers here
            for iLay = 1:length(params.layers)
                % split out the one you want and get the power or phase mats
                LayTab = wtTable(matches(wtTable.layer, params.layers{iLay}),:);

                if contains(whichtest, 'Power')
                    OutTab = getpowerout(LayTab);
                elseif contains(whichtest, 'Phase')
                    OutTab = getphaseout(LayTab);
                end

                % relevant spectral bands: theta - high gamma
                OutTab = squeeze(OutTab(:,19:54,:));

                cd(homedir); cd figures;
                if exist('Single_CWT','dir') == 7
                    cd Single_CWT
                else
                    mkdir('Single_CWT'),cd Single_CWT
                end

                %% dif fig
                name = [whichtest ' ' animals{iSub} ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) ' ' params.layers{iLay}];
                tiledlayout('flow')
                nexttile
                imagesc(flipud(OutTab)) % the cwt function gives us back a yaxis flipped result
                set(gca,'Ydir','normal')
                yticks([0 8 16 21 24 26 29 32 35]) % 42 47 54 (for 200 300 500)
                yticklabels({'0','10','20','30','40','50','60','80','100'})
                xline(400,'LineWidth',2,'Color','w') % onset
                xline(400+stimDur,'LineWidth',2,'Color','w') % offset
                if contains(params.condList{iCond},'Chirp')
                    xlim([1400 3400]) % just the chirp
                else
                    xlim([300 stimDur+500])
                end
                clim([0 1])
                title(name)
                colorbar

                h = gcf;
                h.Renderer = 'Painters';
                set(h, 'PaperType', 'A4');
                set(h, 'PaperOrientation', 'landscape');
                set(h, 'PaperUnits', 'centimeters');
                savefig(name)
                saveas(gcf, ['Observed ' whichtest ' ' params.condList{iCond} ' ' num2str(stimList(iStim)) thisUnit ' ' params.layers{iLay} '.pdf'])
                close(h)



            end % layer
        end % stimulus order
        toc
    end % condition
end % subject
