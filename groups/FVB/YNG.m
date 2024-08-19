%%% Group YNG = FVB Young Saline & Nicotine
<<<<<<< Updated upstream
animals = {'FYS01','FYN01', 'FYN02', 'FYN03','FYS02','FYS03','FYS04','FYS05','FYN04','FYN05'};

%notes
%S01 - 4 months; male
%N01 - 4 months; male
%N02 - 4 months; male
%N03 - 4 months; male
%S02 - 2.8 months; female
%S03 - 2.8 months; female
%S04 - 2.8 months; female
%S05 - 3.15 months; male
%N04 - 3.15 months; female
%N05 - 3.15 months; male


=======
animals = {'FYS01'};

% notes:
% 01: months old
>>>>>>> Stashed changes

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
<<<<<<< Updated upstream
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YS01
    '[23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YN01
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YN02
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... YN03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN04
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN05
    };

%           S01         N01         N02        N03      S02       S03        S04       S05      N04        N05
Layer.II = {'[1:3]',   '[1:3]',   '[1:5]',   '[1:6]',  '[1:6]', '[1:5]',   '[1:7]',  '[1:6]', '[1:6]',   '[1:7]'}; 
%           S01         N01         N02        N03      S02       S03        S04       S05      N04        N05
Layer.IV = {'[4:8]',   '[4:8]',   '[6:10]',  '[7:12]', '[7:11]', '[6:11]' ,'[8:12]', '[7:9]',  '[7:11]', '[8:13]'};
%           S01         N01         N02        N03      S02       S03        S04       S05      N04        N05
Layer.Va = {'[9:12]',  '[9:12]',  '[11:14]', '[13:15]','[12:13]','[12:14]','[13:14]','[10:12]','[12:14]','[14:15]'};
%           S01         N01         N02        N03      S02       S03        S04       S05      N04        N05
Layer.Vb = {'[13:15]', '[13:15]', '[15:17]', '[16:17]','[14:16]','[15:17]','[15:17]','[13:14]','[15:16]','[15:21]'}; 
%           S01         N01         N02        N03      S02       S03        S04       S05      N04        N05
Layer.VI = {'[16:18]', '[16:18]', '[18:23]', '[18:22]','[17:20]','[18:21]','[18:21]','[15:21]','[17:22]','[12:27]'}; 
=======
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
>>>>>>> Stashed changes



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS01
<<<<<<< Updated upstream
    {'01'},... FYN01
    {'01'},... FYN02
    {'03'},... FYN03
    {'01'},... FYS03
    {'02'},... FYS04
    {'02'},... FYS05
    {'01'},... FYN04
    {'04'},... FYN05
    {'01'},... FYS02
    };
    

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
    {'02'},... FYN01
    {'02'},... FYN02
    {'04'},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
=======
    };

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
>>>>>>> Stashed changes
    };

Cond.gapASSR70 = {...
    {'03'},... FYS01
<<<<<<< Updated upstream
    {'04'},... FYN01
    {'07'},... FYN02
    {'08'},... FYN03
    {'04'},... FYS03
    {'04'},... FYS04
    {'05'},... FYS05
    {'04'},... FYN04
    {'06'},... FYN05
    {'06'},... FYS02
    };

Cond.gapASSR80 = {...
    {[]},... FYS01
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
    };  

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    {'06'},... FYN01
    {'06'},... FYN02
    {'05'},... FYN03
    {'03'},... FYS03
    {'03'},... FYS04
    {'04'},... FYS05
    {'03'},... FYN04
    {'05'},... FYN05
    {'03'},... FYS02
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS01
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
    };   

Cond.Spontaneous = {...
    {[]},... FYS01
	{[]},... FYN01
    {'03'},... FYN02
    {[]},... FYN03
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
    {'02'},... FYN04
    {[]},... FYN05
    {'02'},... FYS02
=======
    };

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    };

Cond.Spontaneous = {...
    {[]},... FYS01
>>>>>>> Stashed changes
	};

Cond.ClickTrain70 = {...
    {'05'},... FYS01
<<<<<<< Updated upstream
	{'05'},... FYN01
    {'05'},... FYN02
    {'07'},... FYN03
    {'02'},... FYS03
    {'05'},... FYS04
    {'06'},... FYS05
    {'05'},... FYN04
    {'07'},... FYN05
    {'05'},... FYS02
    };

Cond.ClickTrain80 = {...
    {[]},... FYS01
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
    };

Cond.Chirp70 = {...
    {'06'},... FYS01
    {'03'},... FYN01
    {'04'},... FYN02
    {'06'},... FYN03
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    {'06'},... FYN04
    {'08'},... FYN05
    {'04'},... FYS02
    };

Cond.Chirp80 = {...
    {[]},... FYS01
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
=======
	};

Cond.Chirp70 = {...
    {'06'},... FYS01
>>>>>>> Stashed changes
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
<<<<<<< Updated upstream
    {'07'},... FYN01
    {'08'},... FYN02
    {[]},... FYN03 -- broke from head-fixation during injection
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    {'07'},... FYN04 -- Noiseburst 70db - survived nic injec
    {'09'},... FYN05 -- survived, Noiseburst 70db
    {'07'},... FYS02 - directly after saline Noiseburst 70db
=======
>>>>>>> Stashed changes
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
<<<<<<< Updated upstream
    {'08'},... FYN01 - died during
    {'09'},... FYN02 - died during
    {[]},... FYN03
    {'08'},... FYS03
    {'09'},... FYS04
    {'09'},... FYS05
    {'08'},... FYN04
    {'10'},... FYN05
    {'08'},... FYS02
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS01
    {[]},... FYN01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
=======
>>>>>>> Stashed changes
    };

Cond.TreatTonotopy = {...
    {'09'},... FYS01 
<<<<<<< Updated upstream
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYS02
=======
>>>>>>> Stashed changes
    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
<<<<<<< Updated upstream
    {[]},... FYN01
    {[]},... FYN02
    {[]},... FYN03
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'10'},... FYS05 Noiseburst 70db
    {'09'},... FYN04 Noiseburst 70db
    {'11'},... FYN05
    {'09'},... FYS02 Noiseburst 70db
=======
>>>>>>> Stashed changes
    };
