%%% Group FON = FVB Old Nicotine
animals = {'FON01'};

% notes:
% 01: 

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %01
    };

%           01
Layer.II = {'[1:3]'}; 
%           01     
Layer.IV = {'[4:8]'};
%           01
Layer.Va = {'[9:11]'};
%           01
Layer.Vb = {'[12:13]'}; 
%           01
Layer.VI = {'[14:18]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FON01
    };

Cond.NoiseBurst80 = {...
    {'02'},... FON01
    };

Cond.gapASSR70 = {...
    {'06'},... %FON01
    };

Cond.gapASSR80 = {...
    {'09'},... %FON01
    };

Cond.Tonotopy70 = {...
    {'05'},... %FON01
    };

Cond.Tonotopy80 = {...
    {'08'},... %FON01
    };

Cond.Spontaneous = {...
    {'03'},... %FON01
	};

Cond.ClickTrain70 = {...
    {'07'},... %FON01
	};

Cond.ClickTrain80 = {...
    {'10'},... %FON01
	};

Cond.Chirp70 = {...
    {'04'},... %FON01
    };

Cond.Chirp80 = {...
    {'11'},... %FON01
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... %FON01
	};

Cond.TreatgapASSR70 = {...
    {'13'},... %FON01
    };

Cond.TreatgapASSR80 = {...
    {'14'},... %FON01
    };

Cond.TreatTonotopy = {...
    {[]},... %FON01
	};

Cond.TreatNoiseBurst2 = {...
    {'15'},... %FON01 - 29 minutes after saline
    };
