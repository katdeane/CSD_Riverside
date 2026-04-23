%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT14a','BAT14b'};  

% notes:


%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...%14a
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...%14b
    };

%           14a         14b                     
Layer.II = {'[1:4]',    '[1:4]'}; 

Layer.IV = {'[5:8]',    '[5:9]'};

Layer.Va = {'[9:10]',   '[10:11]'};

Layer.Vb = {'[11:13]',  '[12:14]'}; 

Layer.VI = {'[14:16]',  '[15:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'04'},... %B14a %25KB
    {'19'},... %B14b
    };

Cond.CF = {...
    {'06'},... %B14a %210KB
    {'21'},... %B14b
    };

Cond.Spontaneous = {...
    {'05'},... %B14a %19.5KB
    {'20'},... %B14b
    };

Cond.TonotopyNSR60 = {...
    {'07'},... %B14a %63.7KB
    {'22'},... %B14b
    };

Cond.TonotopyNSR70 = {...
    {[]},... %B14a %63.7KB
    {'24'},... %B14b
    };

Cond.ClickTrain = {...
    {[]},... %B14a %152.6KB
    {'23'},... %B14b
    };

Cond.BBN0 = {...
    {'08'},... %B14a %30.6-31KB
    {'26'},... %B14b
    };

Cond.BBN1 = {...
    {'09'},... %B14a
    {'27'},... %B14b
    };

Cond.BBN2 = {...
    {'10'},... %B14a
    {'28'},... %B14b
    };

Cond.BBN3 = {...
    {'11'},... %B14a
    {'29'},... %B14b
    };

Cond.BBN4 = {...
    {'12'},... %B14a
    {'30'},... %B14b
    };

Cond.BBNm1 = {...
    {'13'},... %B14a
    {'35'},... %B14b - redid at end
    };

Cond.BBNm2 = {...
    {'14'},... %B14a
    {'32'},... %B14b
    };

Cond.BBNm3 = {...
    {'15'},... %B14a
    {'33'},... %B14b
    };

Cond.BBNm4 = {...
    {'16'},... %B14a
    {'34'},... %B14b
    };