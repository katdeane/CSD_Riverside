%%% Group BAT - ALL bats, each letter denotes a different recording location
animals = {'BAT21a'};  

% notes:
% 2-5 are anesthetized
% 6 is all awake

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...%21a
    };

%           21a        
Layer.II = {'[1:4]'}; 

Layer.IV = {'[5:10]'};

Layer.Va = {'[11:12]'};

Layer.Vb = {'[13:15]'}; 

Layer.VI = {'[16:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'03'},... %B21a %25KB
    };

Cond.CF = {...
    {'08'},... %B21a %210KB
    };

Cond.Spontaneous = {...
    {'04'},... %B21a %19.5KB
    };

Cond.TonotopyNSR60 = {...
    {'05'},... %B21a %63.7KB
    };

Cond.TonotopyNSR70 = {...
    {'06'},... %B21a %63.7KB
    };

Cond.ClickTrain = {...
    {'07'},... %B21a %152.6KB
    };

Cond.BBN0 = {...
    {'09'},... %B21a %30.6-31KB
    };

Cond.BBN1 = {...
    {'10'},... %B21a
    };

Cond.BBN2 = {...
    {'11'},... %B21a
    };

Cond.BBN3 = {...
    {'12'},... %B21a
    };

Cond.BBN4 = {...
    {'13'},... %B21a
    };

Cond.BBNm1 = {...
    {'14'},... %B21a
    };

Cond.BBNm2 = {...
    {'15'},... %B21a
    };

Cond.BBNm3 = {...
    {'16'},... %B21a
    };

Cond.BBNm4 = {...
    {'17'},... %B21a
    };