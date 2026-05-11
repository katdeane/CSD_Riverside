%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT19a','BAT19b'};  

% notes:


%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8]',...%19a
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...%19b
    };

%           19a         19b                     
Layer.II = {'[1:3]',    '[1:4]'}; 

Layer.IV = {'[4:8]',    '[5:9]'};

Layer.Va = {'[9:10]',  '[10:11]'};

Layer.Vb = {'[11:13]',  '[12:14]'}; 

Layer.VI = {'[14:16]',  '[15:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'07'},... %B19a %25KB
    {'27'},... %B19b
    };

Cond.CF = {...
    {'10'},... %B19a %210KB
    {'30'},... %B19b
    };

Cond.Spontaneous = {...
    {'08'},... %B19a %19.5KB
    {'28'},... %B19b
    };

Cond.TonotopyNSR60 = {...
    {'12'},... %B19a %63.7KB
    {'31'},... %B19b
    };

Cond.TonotopyNSR70 = {...
    {'11'},... %B19a %63.7KB
    {'29'},... %B19b
    };

Cond.ClickTrain = {...
    {'09'},... %B19a %152.6KB
    {'32'},... %B19b
    };

Cond.BBN0 = {...
    {'13'},... %B19a %30.6-31KB
    {'33'},... %B19b
    };

Cond.BBN1 = {...
    {'14'},... %B19a
    {'34'},... %B19b
    };

Cond.BBN2 = {...
    {'15'},... %B19a
    {'35'},... %B19b
    };

Cond.BBN3 = {...
    {'16'},... %B19a
    {'36'},... %B19b
    };

Cond.BBN4 = {...
    {'17'},... %B19a
    {'37'},... %B19b
    };

Cond.BBNm1 = {...
    {'18'},... %B19a
    {'38'},... %B19b 
    };

Cond.BBNm2 = {...
    {'19'},... %B19a
    {'39'},... %B19b
    };

Cond.BBNm3 = {...
    {'20'},... %B19a
    {'40'},... %B19b
    };

Cond.BBNm4 = {...
    {'21'},... %B19a
    {'41'},... %B19b
    };