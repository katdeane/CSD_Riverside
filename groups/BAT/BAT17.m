%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT17a','BAT17b','BAT17c','BAT17d','BAT17e'};  

% notes:
% measurement d is 2 probe insertions, pre and BBN elevations. The
% Elevation stuff is a little weaker due to the second insertion although 17
% minutes for recovery were taken. The probe broke in the brain, did
% not seem to cause damage. Measurement is still in 1 because channels and
% layers were identical between the two insertions (go me!)

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...%17a
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27]',...%17b
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',...%17c
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27]',...%17d
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...%17e
    };

%           17a         17b         17c         17d         17e         
Layer.II = {'[1:3]',    '[1:3]',    '[1:4]',    '[1:4]',    '[1:4]'}; 

Layer.IV = {'[4:8]',    '[4:7]',    '[5:8]',    '[5:9]',    '[5:9]'};

Layer.Va = {'[9:10]',   '[8:9]',    '[9:10]',   '[10:11]',  '[10:11]'};

Layer.Vb = {'[11:13]',  '[10:14]',  '[11:14]',  '[12:14]',  '[12:14]'}; 

Layer.VI = {'[14:16]',  '[15:17]',  '[15:16]',  '[15:16]',  '[15:16]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'04'},... %B17a %25KB
    {'21'},... %B17b
    {'39'},... %B17c
    {'61'},... %B17d
    {'77'},... %B17e
    };

Cond.CF = {...
    {'06'},... %B17a %210KB
    {'26'},... %B17b
    {'42'},... %B17c
    {'63'},... %B17d
    {'82'},... %B17e
    };

Cond.Spontaneous = {...
    {'05'},... %B17a %19.5KB
    {'22'},... %B17b
    {'40'},... %B17c 
    {'62'},... %B17d
    {'78'},... %B17e
    };

Cond.TonotopyNSR60 = {...
    {'07'},... %B17a %63.7KB
    {'23'},... %B17b
    {'44'},... %B17c
    {'65'},... %B17d
    {'80'},... %B17e
    };

Cond.TonotopyNSR70 = {...
    {[]},... %B17a %63.7KB
    {'27'},... %B17b
    {'41'},... %B17c
    {'64'},... %B17d
    {'81'},... %B17e
    };

Cond.ClickTrain = {...
    {[]},... %B17a %152.6KB
    {'25'},... %B17b
    {'43'},... %B17c
    {'66'},... %B17d
    {'79'},... %B17e
    };

Cond.BBN0 = {...
    {'08'},... %B17a %30.6-31KB
    {'28'},... %B17b
    {'45'},... %B17c
    {'67'},... %B17d
    {'83'},... %B17e
    };

Cond.BBN1 = {...
    {'09'},... %B17a
    {'29'},... %B17b
    {'46'},... %B17c
    {'68'},... %B17d
    {'84'},... %B17e
    };

Cond.BBN2 = {...
    {'10'},... %B17a
    {'30'},... %B17b
    {'47'},... %B17c
    {'69'},... %B17d
    {'85'},... %B17e
    };

Cond.BBN3 = {...
    {'11'},... %B17a
    {'31'},... %B17b
    {'48'},... %B17c
    {'70'},... %B17d
    {'86'},... %B17e
    };

Cond.BBN4 = {...
    {'12'},... %B17a
    {'32'},... %B17b
    {'49'},... %B17c
    {'71'},... %B17d
    {'87'},... %B17e
    };

Cond.BBNm1 = {...
    {'13'},... %B17a
    {'33'},... %B17b
    {'50'},... %B17c
    {'72'},... %B17d
    {'88'},... %B17e
    };

Cond.BBNm2 = {...
    {'14'},... %B17a
    {'34'},... %B17b
    {'51'},... %B17c
    {'73'},... %B17d
    {'89'},... %B17e
    };

Cond.BBNm3 = {...
    {'15'},... %B17a
    {'35'},... %B17b
    {'52'},... %B17c
    {'74'},... %B17d
    {'90'},... %B17e
    };

Cond.BBNm4 = {...
    {'16'},... %B17a
    {'36'},... %B17b
    {'53'},... %B17c
    {'75'},... %B17d
    {'91'},... %B17e
    };