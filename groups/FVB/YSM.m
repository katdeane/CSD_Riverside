%%% Group YNG = FVB Young Saline & Nicotine
animals = {'FYS01','FYS05'};

%notes
%S01 - 4 months; male
%S05 - 3.15 months; male



%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YS01
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    };

%           S01       S05 
Layer.II = {'[1:3]','[1:6]'}; 
%           S01       S05
Layer.IV = {'[4:8]','[7:9]'};
%           S01       S05
Layer.Va = {'[9:12]','[10:12]'};
%           S01       S05
Layer.Vb = {'[13:15]','[13:14]'}; 
%           S01       S05
Layer.VI = {'[16:18]','[15:21]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS01
    {'02'},... FYS05
    };
    

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
    {[]},... FYS05
    };

Cond.gapASSR70 = {...
    {'03'},... FYS01
    {'05'},... FYS05
    };

Cond.gapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS05
    };  

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    {'04'},... FYS05
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS01
    {[]},... FYS05
    };   

Cond.Spontaneous = {...
    {[]},... FYS01
    {'03'},... FYS05
	};

Cond.ClickTrain70 = {...
    {'05'},... FYS01
    {'06'},... FYS05
    };

Cond.ClickTrain80 = {...
    {[]},... FYS01
    {[]},... FYS05
    };

Cond.Chirp70 = {...
    {'06'},... FYS01
    {'07'},... FYS05
    };

Cond.Chirp80 = {...
    {[]},... FYS01
    {[]},... FYS05
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
    {'09'},... FYS05
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS05
    };

Cond.TreatTonotopy = {...
    {'09'},... FYS01 
    {[]},... FYS05
    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
    {'10'},... FYS05 Noiseburst 70db
    };
