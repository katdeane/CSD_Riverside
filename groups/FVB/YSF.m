%%% Group YSF = Young Saline Female
animals = {'FYS02','FYS03','FYS04'};

%notes

%S02 - 2.8 months; female
%S03 - 2.8 months; female
%S04 - 2.8 months; female




%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    };

%            S02       S03        S04 
Layer.II = {'[1:6]', '[1:5]',   '[1:7]'}; 
%           S02       S03        S04 
Layer.IV = {'[7:11]', '[6:11]' ,'[8:12]'};
%            S02       S03        S04 
Layer.Va = {'[12:13]','[12:14]','[13:14]'};
%            S02       S03        S04 
Layer.Vb = {'[14:16]','[15:17]','[15:17]'}; 
%            S02       S03        S04 
Layer.VI = {'[17:20]','[18:21]','[18:21]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS03
    {'02'},... FYS04
    {'02'},... FYS05
    };
    

Cond.NoiseBurst80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.gapASSR70 = {...
    {'04'},... FYS03
    {'04'},... FYS04
    {'05'},... FYS05
    };

Cond.gapASSR80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };  

Cond.Tonotopy70 = {...
    {'03'},... FYS03
    {'03'},... FYS04
    {'04'},... FYS05
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };   

Cond.Spontaneous = {...
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
	};

Cond.ClickTrain70 = {...
    {'02'},... FYS03
    {'05'},... FYS04
    {'06'},... FYS05
    };

Cond.ClickTrain80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.Chirp70 = {...
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    };

Cond.Chirp80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS03
    {'09'},... FYS04
    {'09'},... FYS05
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.TreatTonotopy = {...
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYS05
    };

Cond.TreatNoiseBurst2 = {...
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'10'},... FYS05 Noiseburst 70db
    };
