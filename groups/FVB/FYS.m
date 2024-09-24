%%% Group FYS = FVB Young Saline
animals = {'FYS01','FYS02','FYS03','FYS04','FYS05'};

% notes:
% 01: months old

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YS01
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    };

%             S01       S02      S03        S04       S05
Layer.II = {'[1:3]',  '[1:6]', '[1:5]',   '[1:7]',  '[1:6]'}; 
%             S01       S02      S03        S04       S05
Layer.IV = {'[4:8]','[7:11]', '[6:11]' ,'[8:12]', '[7:9]'};
%             S01       S02      S03        S04       S05
Layer.Va = {'[9:12]','[12:13]','[12:14]','[13:14]','[10:12]'};
%             S01       S02      S03        S04       S05
Layer.Vb = {'[13:15]','[14:16]','[15:17]','[15:17]','[13:14]'}; 
%             S01       S02      S03        S04       S05
Layer.VI = {'[16:18]','[17:20]','[18:21]','[18:21]','[15:21]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS01
    {'01'},... FYS02
    {'01'},... FYS03
    {'02'},... FYS04
    {'02'},... FYS05
    };

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.gapASSR70 = {...
    {'03'},... FYS01
    {'06'},... FYS02
    {'04'},... FYS03
    {'04'},... FYS04
    {'05'},... FYS05
    };

Cond.gapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
	};

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    {'03'},... FYS02
    {'03'},... FYS03
    {'03'},... FYS04
    {'04'},... FYS05
    };

Cond.Tonotopy80 = {...
    {[]},... FYS01
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
	};

Cond.Spontaneous = {...
    {[]},... FYS01
    {'02'},... FYS02
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
	};

Cond.ClickTrain70 = {...
    {'05'},... FYS01
    {'02'},... FYS02
    {'02'},... FYS03
    {'05'},... FYS04
    {'06'},... FYS05
	};

Cond.ClickTrain80 = {...
    {[]},... FYS01
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
	};

Cond.Chirp70 = {...
    {'06'},... FYS01
    {'04'},... FYS02
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    };

Cond.Chirp80 = {...
    {[]},... FYS01
    {'04'},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
	};

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
    {'07'},... FYS02 - directly after saline Noiseburst 70db
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
    {'08'},... FYS02
    {'08'},... FYS03
    {'09'},... FYS04
    {'09'},... FYS05
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
	};

Cond.TreatTonotopy = {...
    {'09'},... FYS01 
    {[]},... FYS02
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
    {'09'},... FYS02 Noiseburst 70db
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'10'},... FYS05 Noiseburst 70db
    };
