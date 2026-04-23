%%% Group BAT - ALL bats, each letter denotes a different recording location
animals = {'BAT08a'};  

% notes:
% 

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7]',...%08a
    };

%           08a        
Layer.II = {'[1:4]'}; 

Layer.IV = {'[5:8]'};

Layer.Va = {'[9:10]'};

Layer.Vb = {'[11:13]'}; 

Layer.VI = {'[14:16]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'04'},... %B08a %25KB
    };

Cond.CF = {...
    {'06'},... %B08a %210KB
    };

Cond.Spontaneous = {...
    {'05'},... %B08a %19.5KB
    };

Cond.TonotopyNSR60 = {...
    {[]},... %B08a %63.7KB
    };

Cond.TonotopyNSR70 = {...
    {'08'},... %B08a %63.7KB
    };

Cond.ClickTrain = {...
    {'07'},... %B08a %152.6KB
    };

Cond.BBN0 = {...
    {'10'},... %B08a %30.6-31KB
    };

Cond.BBN1 = {...
    {'11'},... %B08a
    };

Cond.BBN2 = {...
    {'12'},... %B08a
    };

Cond.BBN3 = {...
    {'13'},... %B08a
    };

Cond.BBN4 = {...
    {'14'},... %B08a
    };

Cond.BBNm1 = {...
    {'15'},... %B08a
    };

Cond.BBNm2 = {...
    {'16'},... %B08a
    };

Cond.BBNm3 = {...
    {'17'},... %B08a
    };

Cond.BBNm4 = {...
    {'18'},... %B08a
    };