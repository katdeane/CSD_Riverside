%%% Group FYS = FVB Young Saline
animals = {'FYS01'};

% notes:
% 01: months old

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... %01
    };

%           01
Layer.II = {'[1:3]'}; 
%           01
Layer.IV = {'[4:8]'};
%           01
Layer.Va = {'[9:12]'};
%           01
Layer.Vb = {'[13:15]'}; 
%           01
Layer.VI = {'[16:18]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS01
    };

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
    };

Cond.gapASSR70 = {...
    {'03'},... FYS01
    };

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    };

Cond.Spontaneous = {...
    {[]},... FYS01
	};

Cond.ClickTrain70 = {...
    {'05'},... FYS01
	};

Cond.Chirp70 = {...
    {'06'},... FYS01
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
    };

Cond.TreatTonotopy = {...
    {'09'},... FYS01 
    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
    };
