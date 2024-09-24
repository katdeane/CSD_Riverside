%%% Group FYF = FVB Young Female
animals = {'FYS02','FYS03','FYS04','FYN04','FYN06','FYN07','FYN08','FYN09'};

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
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN04
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN06
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... YN07
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YN08
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YNO9
    };

%            S02       S03        S04     N04     N06     N07     N08   N09
Layer.II = {'[1:6]', '[1:5]',   '[1:7]','[1:6]','[1:8]','[1:5]','[1:8]','[1:6]'}; 
%           S02       S03        S04 
Layer.IV = {'[7:11]', '[6:11]' ,'[8:12]','[7:11]','[9:13]','[6:10]','[9:13]','[7:12]'};
%            S02       S03        S04 
Layer.Va = {'[12:13]','[12:14]','[13:14]','[12:14]','[14:17]','[11:15]','[14:18]','[13:17]'};
%            S02       S03        S04 
Layer.Vb = {'[14:16]','[15:17]','[15:17]','[15:16]','[18:19]','[16:21]','[19:23]','[18:21]'}; 
%            S02       S03        S04 
Layer.VI = {'[17:20]','[18:21]','[18:21]','[17:22]','[20:23]','[22:26]','[24:26]','[22:26]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS03
    {'02'},... FYS04
    {'01'},... FYS02
    {'01'},... FYN04
    {'01'},... FYN06
    {'03'},... FYN07
    {'01'},... FYN08
    {'01'},... FYN09
    };
    

Cond.NoiseBurst80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };

Cond.gapASSR70 = {...
    {'04'},... FYS03
    {'04'},... FYS04
    {'06'},... FYS02
    {'04'},... FYN04
    {'02'},... FYN06
    {'04'},... FYN07
    {'02'},... FYN08
    {'02'},... FYN09
    };

Cond.gapASSR80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };  

Cond.Tonotopy70 = {...
    {'03'},... FYS03
    {'03'},... FYS04
    {'03'},... FYS02
    {'03'},... FYN04
    {'05'},... FYN06
    {'07'},... FYN07
    {'05'},... FYN08
    {'05'},... FYN09
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };   

Cond.Spontaneous = {...
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
    {'02'},... FYN04
    {[]},... FYN06
    {'06'},... FYN07
    {'03'},... FYN08
    {'04'},... FYN09
	};

Cond.ClickTrain70 = {...
    {'05'},... FYS03
    {'07'},... FYS04
    {'02'},... FYS02
    {'05'},... FYN04
    {'06'},... FYN06
    {'08'},... FYN07
    {'06'},... FYN08
    {'06'},... FYN09
    };

Cond.ClickTrain80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };

Cond.Chirp70 = {...
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    {'06'},... FYN04
    {'03'},... FYN06
    {'05'},... FYN07
    {'04'},... FYN08
    {'03'},... FYN09
    };

Cond.Chirp80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {'04'},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'07'},... FYS02 - directly after saline Noiseburst 70db
    {'07'},... FYN04 -- Noiseburst 70db - survived nic injec
    {'07'},... FYN06- survived, Noiseburst 70db
    {'09'},... FYN07
    {'07'},... FYN08
    {'07'},... FYN09
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS03
    {'09'},... FYS04
    {'08'},... FYS02
    {'08'},... FYN04
    {'08'},... FYN06
    {'10'},... FYN07
    {'08'},... FYN08
    {'08'},... FYN09
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };

Cond.TreatTonotopy = {...
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYS02
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    };

Cond.TreatNoiseBurst2 = {...
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'09'},... FYS02 Noiseburst 70db
    {'09'},... FYN04 Noiseburst 70db
    {'09'},... FYN06
    {'11'},... FYN07
    {'09'},... FYN08
    {'09'},... FYN09
    };
