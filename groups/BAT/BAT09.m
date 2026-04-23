%%% Group BAT - ALL bats, each letter denotes a different recording location
animals = {'BAT09a'};  

% notes:
% 2-5 are anesthetized
% 6 is all awake

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7]',...%09a
    };

%           09a        
Layer.II = {'[1:3]'}; 

Layer.IV = {'[4:7]'};

Layer.Va = {'[8:10]'};

Layer.Vb = {'[11:14]'}; 

Layer.VI = {'[15:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'04'},... %B09a %25KB
    };

Cond.CF = {...
    {'08'},... %B09a %210KB
    };

Cond.Spontaneous = {...
    {'07'},... %B09a %19.5KB
    };

Cond.TonotopyNSR60 = {...
    {[]},... %B09a %63.7KB
    };

Cond.TonotopyNSR70 = {...
    {'06'},... %B09a %63.7KB
    };

Cond.ClickTrain = {...
    {'05'},... %B09a %152.6KB
    };

Cond.BBN0 = {...
    {'10'},... %B09a %30.6-31KB
    };

Cond.BBN1 = {...
    {'11'},... %B09a
    };

Cond.BBN2 = {...
    {'12'},... %B09a
    };

Cond.BBN3 = {...
    {'13'},... %B09a
    };

Cond.BBN4 = {...
    {'14'},... %B09a
    };

Cond.BBNm1 = {...
    {'15'},... %B09a
    };

Cond.BBNm2 = {...
    {'16'},... %B09a
    };

Cond.BBNm3 = {...
    {'17'},... %B09a
    };

Cond.BBNm4 = {...
    {'18'},... %B09a
    };