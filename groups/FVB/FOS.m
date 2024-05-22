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
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    };

Cond.gapASSR = {...
    {'03'},... %FOS01 (02 was a mistaken stim presentation)
    };

Cond.Tonotopy = {...
    {'05'},... %FOS01
    };

Cond.Spontaneous = {...
    {[]},... %FOS01
	};

Cond.ClickTrain = {...
    {'06'},... %FOS01
	};

Cond.Chirp = {...
    {'04'},... %FOS01
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... %FOS01
	};

Cond.TreatgapASSR = {...
    {'07'},... %FOS01
    };

Cond.TreatTonotopy = {...
    {[]},... %FOS01
	};

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    };
