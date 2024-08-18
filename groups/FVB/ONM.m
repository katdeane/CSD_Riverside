%%% Group ONM = Old Nicotine Male
animals = {'FON01','FON04'};

% notes:
% N01: 16 months; male
% N04: 16.8 months;male

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N01
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    };

%           N01         N04   
Layer.II = {'[1:3]',  '[1:4]'};        
%           N01        N04  
Layer.IV = {'[4:8]', '[5:9]'};
%           N01         N04 
Layer.Va = {'[9:11]','[10:12]'};
%           N01          N04 
Layer.Vb = {'[9:11]','[13:17]'}; 
%           N01         N04 
Layer.VI = {'[14:18]','[18:23]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},...%FON01
    {'03'},... FON04
    };

Cond.NoiseBurst80 = {...
    {'02'},... %FON01
    {'10'},... FON04
    };

Cond.gapASSR70 = {...
    {'06'},... %FON01
    {'06'},... FON04
    };

Cond.gapASSR80 = {...
    {'09'},... %FON01
    {'09'},... FON04
    };

Cond.Tonotopy70 = {...
    {'05'},... %FON01
    {'05'},... FON04
    };

Cond.Tonotopy80 = {...
    {'08'},... %FON01
    {'11'},... FON04
    };

Cond.Spontaneous = {...
    {'03'},... %FON01
    {'04'},... FON04
	};

Cond.ClickTrain70 = {...
    {'07'},... %FON01
    {'07'},... FON04
	};

Cond.ClickTrain80 = {...
    {'10'},... %FON01
    {'12'},... FON04
	};

Cond.Chirp70 = {...
    {'04'},... %FON01
    {'08'},... FON04
    };

Cond.Chirp80 = {...
    {'11'},... %FON01
    {'13'},... FON04
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... %FON01
    {'14'},... FON04 Noiseburst 70 dB
	};

Cond.TreatgapASSR70 = {...
    {'13'},... %FON01
    {'15'},... FON04
    };

Cond.TreatgapASSR80 = {...
    {'14'},... %FON01
    {'16'},... FON04
    };

Cond.TreatTonotopy = {...
    {[]},... %FON01
    {[]},... FON04 
	};

Cond.TreatNoiseBurst2 = {...
    {'15'},... %FON01 - 29 minutes after saline
    {'17'},... FON04 Noiseburst 70dB
    };
