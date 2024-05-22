%%% Group FYN = FVB Young Nicotine
animals = {'FYN01', 'FYN02', 'FYN03'};  
 
% notes:
% 01:  months old - died ~10 minutes after nicotine injection during gapASSR

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YN01
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YN02
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN03
    };

%           01          02          03
Layer.II = {'[1:3]',    '[1:5]',    '[1:5]'}; 
%           01     
Layer.IV = {'[4:8]',    '[6:10]',   '[6:10]'};
%           01
Layer.Va = {'[9:12]',   '[11:14]',  '[11:13]'};
%           01
Layer.Vb = {'[13:15]',  '[15:17]',  '[14:17]'}; 
%           01
Layer.VI = {'[16:18]',  '[18:23]',  '[18:22]'}; 


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
