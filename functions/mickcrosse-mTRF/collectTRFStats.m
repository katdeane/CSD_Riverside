function collectTRFStats

input = dir('*.mat');

TRFstats = table('Size',[length(input) 13],'VariableTypes',...
    {'string','double','double','double','double','double','double',...
    'double','double','double','double','double','double'});

TRFstats.Properties.VariableNames = ["Subject", "Mean_r_multi", "Max_r_mutli",...
    "Mean_err_multi","Max_err_multi","Mean_r_low","Max_r_low","Mean_err_low",...
    "Max_err_low", "Mean_r_high","Max_r_high","Mean_err_high","Max_err_high"];

for iTab = 1:length(input)

    load(input(iTab).name)

    % maxrm = max(rcorm);

    TRFstats(iTab,:).Subject        = input(iTab).name(1:5);
    TRFstats(iTab,:).Mean_r_multi   = meanrm;
    % TRFstats(iTab,:).Max_r_multi    = maxrm;
    TRFstats(iTab,:).Mean_err_multi = meanerrm;
    % TRFstats(iTab,:).Max_err_multi  = max(errm);
    TRFstats(iTab,:).Mean_r_low     = meanr1;
    % TRFstats(iTab,:).Max_r_low      = max(rcor1);
    TRFstats(iTab,:).Mean_err_low   = meanerr1;
    % TRFstats(iTab,:).Max_err_low    = max(err1);
    TRFstats(iTab,:).Mean_r_high    = meanr2;
    % TRFstats(iTab,:).Max_r_high     = max(rcor2);
    TRFstats(iTab,:).Mean_err_high  = meanerr2;
    % TRFstats(iTab,:).Max_err_high   = max(err2);

end

 writetable(TRFstats,'TRFstats.csv')