function interlamPhaseFig(homedir,params)

% write the stuff here


% baseline
BL = 399;

for iCond = 1:length(params.condList) 

    [stimList, ~, ~, ~, ~] = ...
        StimVariable(params.condList{iCond},1);

    if matches(params.condList{iCond},'gapASSR')
        delay = 250; % ms of noise before first gaps
    elseif matches(params.condList{iCond},'Chirp')
        delay = 1000; % ms of noise before chirp
    else
        delay = 0;
    end

    % during baseline
    pretime   = (BL-299):(BL-249);
    xpre = [pretime(1);pretime(1);pretime(end);pretime(end)];
    ypre = [0;         1;         1;           0];
    % directly at stim onset
    onsettime = (BL+delay+1):(BL+delay+51);
    xonset = [onsettime(1);onsettime(1);onsettime(end);onsettime(end)];
    yonset = [0;         1;         1;           0];
    % 300 ms after onset (after stim in NB, during stim in others)
    posttime  = (BL+delay+301):(BL+delay+351);
    xpost = [posttime(1);posttime(1);posttime(end);posttime(end)];
    ypost = [0;         1;         1;           0];

    for iStim = 1:length(stimList) 

        cd (homedir); cd output; cd InterLam_PhaseCo
        input = dir(['InterLam_' params.condList{iCond}...
            '_' num2str(stimList(iStim)) '.mat']);
        % should always just be one
        load(input.name,'dTab')

        % loop through layer comparisons (if iLay == 'II', iComp -> 'IV' - 'VI')
        for iLay = 1:(length(params.layers)-1)
            for iComp = iLay+1:length(params.layers)

                compTab = dTab(matches(dTab.Lay1,params.layers{iLay}),:);
                compTab = compTab(matches(compTab.Lay2,params.layers{iComp}),:);

                % final traces will be organized: trials x time
                grp1GH = compTab.GHtrace(contains(compTab.Subject,params.groups{1}),:);
                grp1GH = vertcat(grp1GH{:});
                grp1GL = compTab.GLtrace(contains(compTab.Subject,params.groups{1}),:);
                grp1GL = vertcat(grp1GL{:});
                grp1BH = compTab.BHtrace(contains(compTab.Subject,params.groups{1}),:);
                grp1BH = vertcat(grp1BH{:});
                grp1BL = compTab.BLtrace(contains(compTab.Subject,params.groups{1}),:);
                grp1BL = vertcat(grp1BL{:});
                grp1A  = compTab.Atrace(contains(compTab.Subject,params.groups{1}),:);
                grp1A  = vertcat(grp1A{:});
                grp1T  = compTab.Ttrace(contains(compTab.Subject,params.groups{1}),:);
                grp1T  = vertcat(grp1T{:});
                
                % initialize figure
                phasefig = tiledlayout('flow');
                title(['Interlaminar phase coherence ' params.layers{iLay} ' & ' params.layers{iComp}]);
                % group one averaged interlaminar phase coherence at each
                % frequency band:
                nexttile
                % patch in boxplot oberservation windows
                patch(xpre,ypre,'black','FaceAlpha',.2); hold on
                patch(xonset,yonset,'black','FaceAlpha',.2)
                patch(xpost,ypost,'black','FaceAlpha',.2)
                % plot the averaged data trace
                plot(mean(grp1GH),'LineWidth',2);
                plot(mean(grp1GL),'LineWidth',2)
                plot(mean(grp1BH),'LineWidth',2);
                plot(mean(grp1BL),'LineWidth',2);
                plot(mean(grp1A),'LineWidth',2);
                plot(mean(grp1T),'LineWidth',2);
                % mark stim onset
                xline(400,'LineWidth',2)
                % axes and legend
                legend('','','','High Gamma', 'Low Gamma', 'High Beta', 'Low Beta','Alpha','Theta','Onset')
                ylabel('Phase Coherence')
                ylim([0 1])
                xlabel('Time [ms]')
                title([params.groups{1} ' ' params.layers{iLay} ' & ' params.layers{iComp}])
                hold off

                
                grp2GH = compTab.GHtrace(contains(compTab.Subject,params.groups{2}),:);
                grp2GH = vertcat(grp2GH{:});
                grp2GL = compTab.GLtrace(contains(compTab.Subject,params.groups{2}),:);
                grp2GL = vertcat(grp2GL{:});
                grp2BH = compTab.BHtrace(contains(compTab.Subject,params.groups{2}),:);
                grp2BH = vertcat(grp2BH{:});
                grp2BL = compTab.BLtrace(contains(compTab.Subject,params.groups{2}),:);
                grp2BL = vertcat(grp2BL{:});
                grp2A  = compTab.Atrace(contains(compTab.Subject,params.groups{2}),:);
                grp2A  = vertcat(grp2A{:});
                grp2T  = compTab.Ttrace(contains(compTab.Subject,params.groups{2}),:);
                grp2T  = vertcat(grp2T{:});
                % group 2 figure
                nexttile
                % patch in boxplot oberservation windows
                patch(xpre,ypre,'black','FaceAlpha',.2); hold on
                patch(xonset,yonset,'black','FaceAlpha',.2)
                patch(xpost,ypost,'black','FaceAlpha',.2)
                % plot the averaged data trace
                plot(mean(grp2GH),'LineWidth',2);
                plot(mean(grp2GL),'LineWidth',2)
                plot(mean(grp2BH),'LineWidth',2);
                plot(mean(grp2BL),'LineWidth',2);
                plot(mean(grp2A),'LineWidth',2);
                plot(mean(grp2T),'LineWidth',2);
                xline(400,'LineWidth',2)
                ylabel('Phase Coherence')
                ylim([0 1])
                xlabel('Time [ms]')
                title([params.groups{2} ' ' params.layers{iLay} ' & ' params.layers{iComp}])
                hold off

                %% boxplots now
                % build a whole table so we can use better plotting tools
                GH1pre = mean(grp1GH(:,pretime),2);
                GL1pre = mean(grp1GL(:,pretime),2);
                BH1pre = mean(grp1BH(:,pretime),2);
                BL1pre = mean(grp1BL(:,pretime),2);
                A1pre  = mean(grp1A(:,pretime),2);
                T1pre  = mean(grp1T(:,pretime),2);

                datalist1pre = vertcat(GH1pre,GL1pre,BH1pre,BL1pre,A1pre,T1pre);

                freqlist1pre = vertcat(repmat("GammaHigh",length(GH1pre),1), ...
                    repmat("GammaLow",length(GL1pre),1), repmat("BetaHigh",length(BH1pre),1),...
                    repmat("BetaLow",length(BL1pre),1), repmat("Alpha",length(A1pre),1),...
                    repmat("Theta",length(T1pre),1));

                GH1onset = mean(grp1GH(:,onsettime),2);
                GL1onset = mean(grp1GL(:,onsettime),2);
                BH1onset = mean(grp1BH(:,onsettime),2);
                BL1onset = mean(grp1BL(:,onsettime),2);
                A1onset  = mean(grp1A(:,onsettime),2);
                T1onset  = mean(grp1T(:,onsettime),2);

                datalist1onset = vertcat(GH1onset,GL1onset,BH1onset,BL1onset,A1onset,T1onset);

                freqlist1onset = vertcat(repmat("GammaHigh",length(GH1onset),1), ...
                    repmat("GammaLow",length(GL1onset),1), repmat("BetaHigh",length(BH1onset),1),...
                    repmat("BetaLow",length(BL1onset),1), repmat("Alpha",length(A1onset),1),...
                    repmat("Theta",length(T1onset),1));

                GH1post = mean(grp1GH(:,posttime),2);
                GL1post = mean(grp1GL(:,posttime),2);
                BH1post = mean(grp1BH(:,posttime),2);
                BL1post = mean(grp1BL(:,posttime),2);
                A1post  = mean(grp1A(:,posttime),2);
                T1post  = mean(grp1T(:,posttime),2);

                datalist1post = vertcat(GH1post,GL1post,BH1post,BL1post,A1post,T1post);

                freqlist1post = vertcat(repmat("GammaHigh",length(GH1post),1), ...
                    repmat("GammaLow",length(GL1post),1), repmat("BetaHigh",length(BH1post),1),...
                    repmat("BetaLow",length(BL1post),1), repmat("Alpha",length(A1post),1),...
                    repmat("Theta",length(T1post),1));

                datalist1 = vertcat(datalist1pre,datalist1onset,datalist1post);
                freqlist1 = vertcat(freqlist1pre,freqlist1onset,freqlist1post);
                timelist1 = vertcat(ones(length(datalist1pre),1),...
                    (ones(length(datalist1onset),1)*2),...
                    (ones(length(datalist1post),1)*3));
                % group 1 figure
                nexttile;
                boxchart(timelist1,datalist1,'GroupByColor',freqlist1)
                xline(1.5)
                xline(2.5)
                ylabel('Phase Coherence')
                ylim([0 1])
                xticks(1:1:3)
                xticklabels({'Pre', 'Onset', 'Post'})
                xlabel('Time [ms]')
                title(params.groups{1})
                
                % group 2 now
                GH2pre = mean(grp2GH(:,pretime),2);
                GL2pre = mean(grp2GL(:,pretime),2);
                BH2pre = mean(grp2BH(:,pretime),2);
                BL2pre = mean(grp2BL(:,pretime),2);
                A2pre  = mean(grp2A(:,pretime),2);
                T2pre  = mean(grp2T(:,pretime),2);

                datalist2pre = vertcat(GH2pre,GL2pre,BH2pre,BL2pre,A2pre,T2pre);

                freqlist2pre = vertcat(repmat("GammaHigh",length(GH2pre),1), ...
                    repmat("GammaLow",length(GL2pre),1), repmat("BetaHigh",length(BH2pre),1),...
                    repmat("BetaLow",length(BL2pre),1), repmat("Alpha",length(A2pre),1),...
                    repmat("Theta",length(T2pre),1));

                GH2onset = mean(grp2GH(:,onsettime),2);
                GL2onset = mean(grp2GL(:,onsettime),2);
                BH2onset = mean(grp2BH(:,onsettime),2);
                BL2onset = mean(grp2BL(:,onsettime),2);
                A2onset  = mean(grp2A(:,onsettime),2);
                T2onset  = mean(grp2T(:,onsettime),2);

                datalist2onset = vertcat(GH2onset,GL2onset,BH2onset,BL2onset,A2onset,T2onset);

                freqlist2onset = vertcat(repmat("GammaHigh",length(GH2onset),1), ...
                    repmat("GammaLow",length(GL2onset),1), repmat("BetaHigh",length(BH2onset),1),...
                    repmat("BetaLow",length(BL2onset),1), repmat("Alpha",length(A2onset),1),...
                    repmat("Theta",length(T2onset),1));

                GH2post = mean(grp2GH(:,posttime),2);
                GL2post = mean(grp2GL(:,posttime),2);
                BH2post = mean(grp2BH(:,posttime),2);
                BL2post = mean(grp2BL(:,posttime),2);
                A2post  = mean(grp2A(:,posttime),2);
                T2post  = mean(grp2T(:,posttime),2);

                datalist2post = vertcat(GH2post,GL2post,BH2post,BL2post,A2post,T2post);

                freqlist2post = vertcat(repmat("GammaHigh",length(GH2post),1), ...
                    repmat("GammaLow",length(GL2post),1), repmat("BetaHigh",length(BH2post),1),...
                    repmat("BetaLow",length(BL2post),1), repmat("Alpha",length(A2post),1),...
                    repmat("Theta",length(T2post),1));

                datalist2 = vertcat(datalist2pre,datalist2onset,datalist2post);
                freqlist2 = vertcat(freqlist2pre,freqlist2onset,freqlist2post);
                timelist2 = vertcat(ones(length(datalist2pre),1),...
                    (ones(length(datalist2onset),1)*2),...
                    (ones(length(datalist2post),1)*3));

                nexttile;
                boxchart(timelist2,datalist2,'GroupByColor',freqlist2)
                xline(1.5)
                xline(2.5)
                 ylabel('Phase Coherence')
                ylim([0 1])
                xticks(1:1:3)
                xticklabels({'Pre', 'Onset', 'Post'})
                xlabel('Time [ms]')
                title(params.groups{2})

                cd(homedir);cd figures
                if ~exist('InterLam_Fig','dir')
                    mkdir('InterLam_Fig');
                end
                cd InterLam_Fig
                savename = ['InterLam_' params.condList{iCond} '_' num2str(stimList(iStim)) '_' params.layers{iLay} '_' params.layers{iComp}];
                savefig(gcf,savename)

            end % comparison
        end % layer
    end % stimulus
end % condition

cd(homedir)