% function gapASSRcorr_ITPCmean(homedir,Groups,highcalls,lowcalls)

% Correlate the ITPC means between the gap ASSR at all
% widths with quiet and loud calls and noise bursts

% pull in the data first 
gap2  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_2_ITPCmean.csv']);
gap4  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_4_ITPCmean.csv']);
gap6  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_6_ITPCmean.csv']);
gap8  = readtable([Groups{1} 'and' Groups{2} '_gapASSR_8_ITPCmean.csv']);
gap10 = readtable([Groups{1} 'and' Groups{2} '_gapASSR_10_ITPCmean.csv']);

NBquiet = readtable([Groups{1} 'and' Groups{2} '_NoiseBurst_20_ITPCmean.csv']);
NBloud  = readtable([Groups{1} 'and' Groups{2} '_NoiseBurst_50_ITPCmean.csv']);

PC = readtable([Groups{1} 'and' Groups{2} '_Pupcall_1_ITPCmean.csv']);

% we'll look at the 5th gap in noise block
gap2  = gap2(gap2.Order_Presentation == 5,:);
gap4  = gap4(gap4.Order_Presentation == 5,:);
gap6  = gap6(gap6.Order_Presentation == 5,:);
gap8  = gap8(gap8.Order_Presentation == 5,:);
gap10 = gap10(gap10.Order_Presentation == 5,:);

% now the quietest and loudest calls
PCquiet = PC(PC.Order_Presentation == lowcalls(1),:);
PCloud  = PC(PC.Order_Presentation == highcalls(end),:);

% we're missing some subjects in gap: PMP04, PMP09, VMP08
% NB and PC subject lists match so we only need one boolean list
sublist = unique(gap2.Subject);
complist = zeros(length(PCloud.Subject),1);
for iSub = 1:length(sublist)
    complist = complist + contains(PCloud.Subject,sublist{iSub});
end

NBquiet = NBquiet(complist>0,:);
NBloud  = NBloud(complist>0,:);
PCquiet = PCquiet(complist>0,:);
PCloud  = PCloud(complist>0,:);

% now we are equal. Yay!

%% Figures


%% Stats


