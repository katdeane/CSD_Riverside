%%% Group FYN = FVB Young Nicotine
animals = {'FYN01'};  %'FYN02', 'FYN03'
 
% notes:
% 01:  months old - died ~10 minutes after nicotine injection during gapASSR

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... 01
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
    {'01'},... FYN01
    };

Cond.NoiseBurst80 = {...
    {'02'},... FYN01
    };

Cond.gapASSR70 = {...
    {'04'},... FYN01
    };

Cond.Tonotopy70 = {...
    {'06'},... FYN01
    };

Cond.Spontaneous = {...
    {[]},... FYN01
	};

Cond.ClickTrain70 = {...
    {'05'},... FYN01
	};

Cond.Chirp70 = {...
    {'03'},... FYN01
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYN01 - directly after nicotine
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYN01 - died during
    };

Cond.TreatTonotopy = {...
    {[]},... FYN01 
    };

Cond.TreatNoiseBurst2 = {...
    {[]},... FYN01 - 31 minutes after nicotine
    };
