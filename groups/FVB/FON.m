%%% Group FON = FVB Old Nicotine
animals = {'FON01','FON02','FON03','FON04'};

% notes:
% N01: 16 months; male 
% N02: 17.3 months;female
% N03: 18.5 months;female
% N04: 16.8 months

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N01
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... N02
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... N03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    };

%            N01       N02       N03     N04
Layer.II = {'[1:3]', '[1:7]',  '[1:6]','[1:4]'}; 
%                
Layer.IV = {'[4:8]', '[8:12]', '[7:12]','[5:9]'};
%           
Layer.Va = {'[9:11]','[13:15]','[13:16]','[10:12]'};
%           
Layer.Vb = {'[9:11]','[16:18]','[17:20]','[13:17]'}; 
%           
Layer.VI = {'[14:18]','[19:21]','[21:22]','[18:23]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FON01
    {'01'},... FON02
    {'01'},... FON03
    {'03'},... FON04
    };

Cond.NoiseBurst80 = {...
    {'02'},... FON01
    {'07'},... FON02
    {'10'},... FON03
    {'10'},... FON04
    };

Cond.gapASSR70 = {...
    {'06'},... FON01
    {'04'},... FON02
    {'03'},... FON03
    {'06'},... FON04
    };

Cond.gapASSR80 = {...
    {'09'},... FON01
    {'11'},... FON02
    {'09'},... FON03
    {'09'},... FON04
    };

Cond.Tonotopy70 = {...
    {'05'},... FON01
    {'03'},... FON02
    {'02'},... FON03
    {'05'},... FON04
    };

Cond.Tonotopy80 = {...
    {'08'},... FON01
    {'08'},... FON02
    {'11'},... FON03
    {'11'},... FON04
    };

Cond.Spontaneous = {...
    {'03'},... FON01
    {'02'},... FON02
    {'06'},... FON03
    {'04'},... FON04
	};

Cond.ClickTrain70 = {...
    {'07'},... FON01
    {'05'},... FON02
    {'04'},... FON03
    {'07'},... FON04
	};

Cond.ClickTrain80 = {...
    {'10'},... FON01
    {'10'},... FON02
    {'08'},... FON03
    {'12'},... FON04
	};

Cond.Chirp70 = {...
    {'04'},... FON01
    {'06'},... FON02
    {'05'},... FON03
    {'08'},... FON04
    };

Cond.Chirp80 = {...
    {'11'},... FON01
    {'09'},... FON02
    {'07'},... FON03
    {'13'},... FON04
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FON01
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    {'14'},... FON04 Noiseburst 70 dB
	};

Cond.TreatgapASSR70 = {...
    {'13'},... FON01
    {'13'},... FON02 
    {'13'},... FON03
    {'15'},... FON04 
    };

Cond.TreatgapASSR80 = {...
    {'14'},... FON01
    {'14'},... FON02
    {'14'},... FON03
    {'16'},... FON04
    };

Cond.TreatTonotopy = {...
    {[]},... FON01
    {[]},... FON02
    {[]},... FON03
    {[]},... FON04 
    };

Cond.TreatNoiseBurst2 = {...
    {'15'},... FON01 - 29 minutes after saline
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    {'17'},... FON04 Noiseburst 70dB
    };
