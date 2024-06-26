%%% Group FOS = FVB Old Saline
animals = {'FOS01', 'FOS02'};

% notes:
% 01: 19.5 months old

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... %01
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... %OS02
    };

%           01          02
Layer.II = {'[1:3]',    '[1:3]'}; 
%           01     
Layer.IV = {'[4:8]',    '[4:8]'};
%           01
Layer.Va = {'[9:12]',   '[9:11]'};
%           01
Layer.Vb = {'[13:15]',  '[12:15]'}; 
%           01
Layer.VI = {'[16:18]',  '[16:20]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS01
    {'01'},... FOS02
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    {'02'},... FOS02
    };

Cond.gapASSR70 = {...
    {'03'},... FOS01 
    {'07'},... FOS02
    };

Cond.gapASSR80 = {...
    {[]},... FOS01 
    {'10'},... FOS02
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS01
    {'04'},... FOS02
    };

Cond.Tonotopy80 = {...
    {[]},... FOS01
    {'08'},... FOS02
    };

Cond.Spontaneous = {...
    {[]},... FOS01
    {'03'},... FOS02
	};

Cond.ClickTrain70 = {...
    {'06'},... FOS01
    {'06'},... FOS02
	};

Cond.ClickTrain80 = {...
    {[]},... FOS01
    {'11'},... FOS02
	};

Cond.Chirp70 = {...
    {'04'},... FOS01
    {'05'},... FOS02
    };

Cond.Chirp80 = {...
    {[]},... FOS01
    {'09'},... FOS02
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... FOS01
    {'12'},... FOS02
	};

Cond.TreatgapASSR70 = {...
    {'07'},... FOS01
    {'13'},... FOS02
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS01
    {'14'},... FOS02
    };

Cond.TreatTonotopy = {...
    {[]},... FOS01 
    {[]},... FOS02
    };

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    };
