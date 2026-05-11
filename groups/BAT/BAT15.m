%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT15a','BAT15b','BAT15c','BAT15d'};  

% notes:
% measurement d is 2 probe insertions, pre and BBN elevations. The
% Elevation stuff is a little weaker due to the second insertion although 15
% minutes for recovery were taken. The probe broke in the brain, did
% not seem to cause damage. Measurement is still in 1 because channels and
% layers were identical between the two insertions (go me!)

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...%15a
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7]',...%15b
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...%15c
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...%15d
    };

%           15a         15b         15c         15d       
Layer.II = {'[1:3]',    '[1:4]',    '[1:4]',    '[1:4]'}; 

Layer.IV = {'[4:8]',    '[5:9]',    '[5:9]',    '[5:9]'};

Layer.Va = {'[9:10]',  '[10:11]',   '[10:11]',  '[10:11]'};

Layer.Vb = {'[11:13]',  '[12:14]',  '[12:14]',  '[12:14]'}; 

Layer.VI = {'[14:16]',  '[15:17]',  '[15:17]',  '[15:16]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'02'},... %B15a %25KB
    {'19'},... %B15b
    {'36'},... %B15c
    {'56'},... %B15d
    };

Cond.CF = {...
    {'06'},... %B15a %210KB
    {'20'},... %B15b
    {'40'},... %B15c
    {'57'},... %B15d
    };

Cond.Spontaneous = {...
    {'03'},... %B15a %19.5KB
    {'24'},... %B15b
    {'37'},... %B15c 
    {'61'},... %B15d
    };

Cond.TonotopyNSR60 = {...
    {'04'},... %B15a %63.7KB
    {'23'},... %B15b
    {'39'},... %B15c
    {'58'},... %B15d
    };

Cond.TonotopyNSR70 = {...
    {'07'},... %B15a %63.7KB
    {'22'},... %B15b
    {'41'},... %B15c
    {'59'},... %B15d
    };

Cond.ClickTrain = {...
    {'05'},... %B15a %152.6KB
    {'21'},... %B15b
    {'38'},... %B15c
    {'60'},... %B15d
    };

Cond.BBN0 = {...
    {'08'},... %B15a %30.6-31KB
    {'25'},... %B15b
    {'42'},... %B15c
    {'62'},... %B15d
    };

Cond.BBN1 = {...
    {'09'},... %B15a
    {'26'},... %B15b
    {'43'},... %B15c
    {'63'},... %B15d
    };

Cond.BBN2 = {...
    {'10'},... %B15a
    {'27'},... %B15b
    {'44'},... %B15c
    {'64'},... %B15d
    };

Cond.BBN3 = {...
    {'11'},... %B15a
    {'28'},... %B15b
    {'45'},... %B15c
    {'65'},... %B15d
    };

Cond.BBN4 = {...
    {'12'},... %B15a
    {'29'},... %B15b
    {'46'},... %B15c
    {'66'},... %B15d
    };

Cond.BBNm1 = {...
    {'13'},... %B15a
    {'30'},... %B15b
    {'47'},... %B15c
    {'67'},... %B15d
    };

Cond.BBNm2 = {...
    {'14'},... %B15a
    {'31'},... %B15b
    {'48'},... %B15c
    {'68'},... %B15d
    };

Cond.BBNm3 = {...
    {'15'},... %B15a
    {'32'},... %B15b
    {'49'},... %B15c
    {'69'},... %B15d
    };

Cond.BBNm4 = {...
    {'16'},... %B15a
    {'33'},... %B15b
    {'50'},... %B15c
    {'70'},... %B15d
    };