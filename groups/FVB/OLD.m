<<<<<<< Updated upstream
%%% Group OLD = FVB Old (N and S combined)
animals = {'FON01','FOS01','FOS02','FOS03','FOS04','FOS05','FOS06','FON02','FON03','FON04'};

% notes:
% N01: 16 months; male
% S01: 19 months; male
% S02: 17.3 months; male
% S03: 19.5 months- Had a double stimulus line in CSD?; female
% S04: 17.7 months; female - Very low signal, deaf?- mouse was very lethargic after
%           recording
% S05: 16.2 months; female - had an eye infection, no treatment given, response to
%           noiseburst was still seen in raw signal, but low response in CSD
% S06: 17 months;male
% N02: 17.3 months;female
% N03: 18.5 months;female
% N04: 16.8 months
=======
%%% Group OLD = FVB Old (N and S compbined
animals = {'FON01','FOS01'};

% notes:
% 01: 
>>>>>>> Stashed changes

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
<<<<<<< Updated upstream
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N01
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... N02
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... N03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    };

%           N01         S01        S02      S03        S04      S05       S06        N02       N03       N04   
Layer.II = {'[1:3]',  '[1:3]',  '[1:3]',  '[1:5]',  '[1:4]',  '[1:5]',  '[1:3]',   '[1:7]',  '[1:6]',  '[1:4]'};        
%           N01         S01        S02      S03        S04      S05       S06        N02       N03       N04  
Layer.IV = {'[4:8]',  '[4:8]',  '[4:8]',  '[6:9]',  '[5:9]',  '[6:11]', '[4:10]',  '[8:12]', '[7:12]', '[5:9]'};
%           N01          S01       S02      S03        S04      S05       S06        N02       N03        N04 
Layer.Va = {'[9:11]', '[9:12]', '[9:11]', '[10:14]','[10:14]','[12:14]','[11:14]', '[13:15]','[13:16]','[10:12]'};
%           N01          S01       S02       S03       S04      S05       S06        N02       N03        N04 
Layer.Vb = {'[9:11]','[13:15]','[12:15]','[15:17]','[15:17]','[15:17]','[15:16]', '[16:18]','[17:20]','[13:17]'}; 
%           N01          S01       S02       S03       S04      S05       S06        N02       N03        N04 
Layer.VI = {'[14:18]','[16:18]','[16:20]','[18:20]','[18:20]','[18:20]','[17:20]', '[19:21]','[21:22]','[18:23]'}; 
=======
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %01
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... %01
    };

%           01
Layer.II = {'[1:3]','[1:3]'}; 
%           01     
Layer.IV = {'[4:8]'};
%           01
Layer.Va = {'[9:11]'};
%           01
Layer.Vb = {'[12:13]'}; 
%           01
Layer.VI = {'[14:18]'}; 
>>>>>>> Stashed changes



%% Conditions
Cond.NoiseBurst70 = {...
<<<<<<< Updated upstream
    {'01'},...%FON01
    {'01'},... FOS01
    {'01'},... FOS02
    {'01'},... FOS03
    {'01'},... FOS04
    {'01'},... FOS05
    {'01'},... FOS06
    {'01'},... FON02
    {'01'},... FON03
    {'03'},... FON04
    };

Cond.NoiseBurst80 = {...
    {'02'},... %FON01
    {[]},... FOS01
    {'02'},... FOS02
    {'08'},... FOS03
    {'07'},... FOS04
    {'04'},... FOS05
    {'08'},... FOS06
    {'07'},... FON02
    {'10'},... FON03
    {'10'},... FON04
=======
    {'01'},... FON01
    };

Cond.NoiseBurst80 = {...
    {'02'},... FON01
>>>>>>> Stashed changes
    };

Cond.gapASSR70 = {...
    {'06'},... %FON01
<<<<<<< Updated upstream
    {'03'},... FOS01 
    {'07'},... FOS02
    {'03'},... FOS03
    {'04'},... FOS04
    {'06'},... FOS05
    {'04'},... FOS06
    {'04'},... FON02
    {'03'},... FON03
    {'06'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.gapASSR80 = {...
    {'09'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01 
    {'10'},... FOS02
    {'10'},... FOS03 
    {'09'},... FOS04 
    {'10'},... FOS05 
    {'09'},... FOS06
    {'11'},... FON02
    {'09'},... FON03
    {'09'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.Tonotopy70 = {...
    {'05'},... %FON01
<<<<<<< Updated upstream
    {'05'},... FOS01
    {'04'},... FOS02
    {'05'},... FOS03
    {'03'},... FOS04
    {'05'},... FOS05
    {'03'},... FOS06
    {'03'},... FON02
    {'02'},... FON03
    {'05'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.Tonotopy80 = {...
    {'08'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'08'},... FOS02
    {'11'},... FOS03
    {'08'},... FOS04
    {'09'},... FOS05
    {'07'},... FOS06
    {'08'},... FON02
    {'11'},... FON03
    {'11'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.Spontaneous = {...
    {'03'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'03'},... FOS02
    {'04'},... FOS03
    {'02'},... FOS04
    {'02'},... FOS05
    {'02'},... FOS06
    {'02'},... FON02
    {'06'},... FON03
    {'04'},... FON04
=======
>>>>>>> Stashed changes
	};

Cond.ClickTrain70 = {...
    {'07'},... %FON01
<<<<<<< Updated upstream
    {'06'},... FOS01
    {'06'},... FOS02
    {'06'},... FOS03
    {'05'},... FOS04
    {'07'},... FOS05
    {'05'},... FOS06
    {'05'},... FON02
    {'04'},... FON03
    {'07'},... FON04
=======
>>>>>>> Stashed changes
	};

Cond.ClickTrain80 = {...
    {'10'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'11'},... FOS02
    {'09'},... FOS03
    {'10'},... FOS04
    {'11'},... FOS05
    {'10'},... FOS06
    {'10'},... FON02
    {'08'},... FON03
    {'12'},... FON04
=======
>>>>>>> Stashed changes
	};

Cond.Chirp70 = {...
    {'04'},... %FON01
<<<<<<< Updated upstream
    {'04'},... FOS01
    {'05'},... FOS02
    {'02'},... FOS03
    {'06'},... FOS04
    {'08'},... FOS05
    {'06'},... FOS06
    {'06'},... FON02
    {'05'},... FON03
    {'08'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.Chirp80 = {...
    {'11'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'09'},... FOS02
    {'07'},... FOS03
    {'11'},... FOS04
    {'12'},... FOS05
    {'11'},... FOS06
    {'09'},... FON02
    {'07'},... FON03
    {'13'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'12'},... FOS06 Noiseburst 70dB
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    {'14'},... FON04 Noiseburst 70 dB
=======
>>>>>>> Stashed changes
	};

Cond.TreatgapASSR70 = {...
    {'13'},... %FON01
<<<<<<< Updated upstream
    {'07'},... FOS01
    {'13'},... FOS02
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'13'},... FOS06
    {'13'},... FON02 
    {'13'},... FON03
    {'15'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.TreatgapASSR80 = {...
    {'14'},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01
    {'14'},... FOS02
    {'13'},... FOS03
    {'13'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'14'},... FOS06
    {'14'},... FON02
    {'14'},... FON03
    {'16'},... FON04
=======
>>>>>>> Stashed changes
    };

Cond.TreatTonotopy = {...
    {[]},... %FON01
<<<<<<< Updated upstream
    {[]},... FOS01 
    {[]},... FOS02
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {[]},... FOS06
    {[]},... FON02
    {[]},... FON03
    {[]},... FON04 
=======
>>>>>>> Stashed changes
	};

Cond.TreatNoiseBurst2 = {...
    {'15'},... %FON01 - 29 minutes after saline
<<<<<<< Updated upstream
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'15'},... FOS06
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    {'17'},... FON04 Noiseburst 70dB
=======
>>>>>>> Stashed changes
    };
