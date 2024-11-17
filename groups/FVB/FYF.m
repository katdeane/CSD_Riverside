%%% Group FYF = FVB Young Female
animals = {'FYS02','FYS03','FYS04','FYN04','FYN06','FYN07','FYN08','FYN09','FYS06','FYS10'};

%notes

%S02 - 2.8 months; female
%S03 - 2.8 months; female
%S04 - 2.8 months; female




%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S04
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN04
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN06
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... YN07
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN08
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YNO9
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS06
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS10
    };

%            S02       S03        S04     N04     N06     N07     N08   N09
Layer.II = {'[1:3]', '[1:3]',   '[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]'}; 
%           S02       S03        S04 
Layer.IV = {'[4:8]', '[4:8]' ,'[4:8]','[4:7]','[4:8]','[4:8]','[4:8]','[4:9]','[4:8]','[4:8]'};
%            S02       S03      S04 
Layer.Va = {'[9:11]','[9:12]','[9:11]','[8:10]','[9:12]','[9:12]','[9:11]','[10:12]','[9:12]','[9:11]'};
%            S02       S03        S04 
Layer.Vb = {'[12:14]','[13:15]','[12:15]','[11:14]','[13:15]','[13:16]','[12:14]','[13:15]','[13:15]','[12:14]'}; 
%            S02       S03        S04 
Layer.VI = {'[15:18]','[16:19]','[16:20]','[15:18]','[16:18]','[17:22]','[15:18]','[16:18]','[16:18]','[15:17]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS02
    {'01'},... FYS03
    {'02'},... FYS04
    {'01'},... FYN04
    {'01'},... FYN06
    {'03'},... FYN07
    {'01'},... FYN08
    {'01'},... FYN09
    {'01'},... FYS06
    {'01'},... FYS10
    };
    

Cond.NoiseBurst80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.gapASSR70 = {...
    {'06'},... FYS02
    {'04'},... FYS03
    {'04'},... FYS04
    {'04'},... FYN04
    {[]},... FYN06 %'02'
    {'04'},... FYN07
    {'02'},... FYN08
    {'02'},... FYN09
    {'04'},... FYS06
    {'05'},... FYS10
    };

Cond.gapASSR80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };  

Cond.Tonotopy70 = {...
    {'03'},... FYS02
    {'03'},... FYS03
    {'03'},... FYS04
    {'03'},... FYN04
    {'05'},... FYN06
    {'07'},... FYN07
    {'05'},... FYN08
    {'05'},... FYN09
    {'03'},... FYS06
    {'02'},... FYS10
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };   

Cond.Spontaneous = {...
    {'02'},... FYS02
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
    {'02'},... FYN04
    {[]},... FYN06
    {'06'},... FYN07
    {'03'},... FYN08
    {'04'},... FYN09
    {'06'},... FYS06
    {'06'},... FYS10
	};

Cond.ClickTrain70 = {...
    {'02'},... FYS02
    {'05'},... FYS03
    {'07'},... FYS04
    {'05'},... FYN04
    {'06'},... FYN06
    {'08'},... FYN07
    {'06'},... FYN08
    {'06'},... FYN09
    {'05'},... FYS06
    {'04'},... FYS10
    };

Cond.ClickTrain80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.Chirp70 = {...
    {'04'},... FYS02
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    {'06'},... FYN04
    {'03'},... FYN06
    {'05'},... FYN07
    {'04'},... FYN08
    {'03'},... FYN09
    {'03'},... FYS06
    {'03'},... FYS10
    };

Cond.Chirp80 = {...
    {'04'},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS02 - directly after saline Noiseburst 70db
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'07'},... FYN04 -- Noiseburst 70db - survived nic injec
    {'07'},... FYN06- survived, Noiseburst 70db
    {'09'},... FYN07
    {'07'},... FYN08
    {'07'},... FYN09
    {'07'},... FYS06
    {'07'},... FYS10
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS02
    {'08'},... FYS03
    {'09'},... FYS04
    {'08'},... FYN04
    {'08'},... FYN06
    {'10'},... FYN07
    {'08'},... FYN08
    {'08'},... FYN09
    {'08'},... FYS06
    {'08'},... FYS10
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.TreatTonotopy = {...
    {[]},... FYS02
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYN04
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.TreatNoiseBurst2 = {...
    {'09'},... FYS02 Noiseburst 70db
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'09'},... FYN04 Noiseburst 70db
    {'09'},... FYN06
    {'11'},... FYN07
    {'09'},... FYN08
    {'09'},... FYN09
    {'09'},... FYS06
    {'09'},... FYS10
    };
