%%% Group YNG = FVB Young Saline & Nicotine
animals = {'FYS01','FYN02', 'FYN03','FYS02','FYS03','FYS04','FYS05',...
    'FYN04','FYN05','FYN06','FYN07','FYN08','FYN09','FYS06','FYS10','FYS07','FYS08','FYS09','FYN10','FYN12','FYN13'};

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

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YS01
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',... YN02
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6]',... YN03
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S04
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN04
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN05
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN06
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... YN07
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN08
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... YNO9
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS06
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS10
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...YS07
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...YS08
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',...YS09
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',...YN10
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',...YN12
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YN13
    };

%           S01        N02        N03      S02       S03        S04       S05      N04        N05
Layer.II = {'[1:3]','[1:3]',   '[1:3]',  '[1:3]', '[1:3]',   '[1:3]',  '[1:3]', '[1:3]',   '[1:3]',...
...%     YN06    YN07    YN08   YN09     YS06    YS10    YS07   YS08     YS09   YN10
    '[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:2]','[1:3]','[1:3]','[1:2]','[1:3]'}; 
%           S01         N02        N03      S02       S03    S04       S05      N04       N05
Layer.IV = {'[4:8]',  '[4:8]',  '[4:6]', '[4:8]', '[4:8]' ,'[4:8]', '[4:6]',  '[4:7]', '[4:10]',...
   ... %YN06     YN07    YN08    YN09     YS06    YS10    YS07   YS08     YS09   YN10
    '[4:8]','[4:8]','[4:8]','[4:9]','[4:8]','[4:8]','[4:8]','[3:6]','[4:8]','[4:9]','[3:8]','[4:7]'};
%           S01          N02        N03      S02       S03    S04       S05      N04      N05
Layer.Va = {'[9:12]', '[9:11]', '[7:8]','[9:11]','[9:12]','[9:11]','[7:10]','[8:10]','[11:14]',...
  ...  %YN06      YN07     YN08     YN09      YS06     YS10     YS07     YS08     YS09      YN10
    '[9:12]','[9:12]','[9:11]','[10:12]','[9:12]','[9:11]','[9:11]','[7:10]','[9:12]','[10:13]','[9:14]','[8:11]'};
%           S01          N02        N03      S02       S03        S04       S05      N04        N05
Layer.Vb = {'[13:15]','[12:14]', '[9:10]','[12:14]','[13:15]','[12:15]','[11:14]','[11:14]','[15:17]',...
  ...  %  YN06      YN07      YN08      YN09      YS06     YS10      YS07      YS08      YS09       YN10
    '[13:15]','[13:16]','[12:14]','[13:15]','[13:15]','[12:14]','[12:14]','[11:12]','[13:14]','[14:16]','[15:19]','[12:15]'}; 
%           S01          N02        N03      S02       S03        S04       S05      N04        N05
Layer.VI = {'[16:18]','[15:19]', '[11:14]','[15:18]','[16:19]','[16:20]','[15:18]','[15:18]','[18:21]',...
   ...  %  YN06      YN07      YN08      YN09      YS06     YS10      YS07      YS08      YS09       YN10
    '[16:18]','[17:22]','[15:18]','[16:18]','[16:18]','[15:17]','[15:19]','[13:18]','[15:20]','[17:18]','[20:26]','[16:20]'}; 


%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYS01
    {'01'},... FYN02
    {'03'},... FYN03
    {'01'},... FYS02
    {'01'},... FYS03
    {'02'},... FYS04
    {'02'},... FYS05
    {'01'},... FYN04
    {'04'},... FYN05
    {'01'},... FYN06
    {'03'},... FYN07
    {'01'},... FYN08
    {'01'},... FYN09
    {'01'},... FYS06
    {'01'},... FYS10
    {'01'},... FYS07
    {'01'},... FYS08
    {'01'},... FYS09
    {'01'},... FYN10
    {'01'},... FYN12
    {'02'},... FYN13
    };
    

Cond.NoiseBurst80 = {...
    {'02'},... FYS01
    {[]},... FYN02 %'02'
    {'04'},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.gapASSR70 = {...
    {'03'},... FYS01
    {'07'},... FYN02
    {'08'},... FYN03
    {'06'},... FYS02
    {'04'},... FYS03
    {'04'},... FYS04
    {'05'},... FYS05
    {'04'},... FYN04
    {'06'},... FYN05
    {'02'},... FYN06
    {'04'},... FYN07
    {'02'},... FYN08
    {'02'},... FYN09
    {'04'},... FYS06
    {'05'},... FYS10
    {'03'},... FYS07
    {'04'},... FYS08
    {'03'},... FYS09
    {'03'},... FYN10
    {'04'},... FYN12
    {'03'},... FYN13
    };

Cond.gapASSR80 = {...
    {[]},... FYS01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };  

Cond.Tonotopy70 = {...
    {'04'},... FYS01
    {'06'},... FYN02
    {'05'},... FYN03
    {'03'},... FYS02
    {'03'},... FYS03
    {'03'},... FYS04
    {'04'},... FYS05
    {'03'},... FYN04
    {'05'},... FYN05
    {'05'},... FYN06
    {'07'},... FYN07
    {'05'},... FYN08
    {'05'},... FYN09
    {'03'},... FYS06
    {'02'},... FYS10
    {'02'},... FYS07
    {'03'},... FYS08
    {'02'},... FYS09
    {'05'},... FYN10
    {'02'},... FYN12
    {'04'},... FYN13
    };

 Cond.Tonotopy80 = {...
    {[]},... FYS01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };   

Cond.Spontaneous = {...
    {[]},... FYS01
    {'03'},... FYN02
    {[]},... FYN03
    {'02'},... FYS02
    {'05'},... FYS03
    {'07'},... FYS04
    {'03'},... FYS05
    {'02'},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {'06'},... FYN07
    {'03'},... FYN08
    {'04'},... FYN09
    {'06'},... FYS06
    {'06'},... FYS10
    {'09'},... FYS07
    {'02'},... FYS08
    {'09'},... FYS09
    {'06'},... FYN10
    {'06'},... FYN12
    {'07'},... FYN13
    };

Cond.ClickTrain70 = {...
    {'05'},... FYS01
    {'05'},... FYN02
    {'07'},... FYN03
    {'05'},... FYS02
    {'02'},... FYS03
    {'05'},... FYS04
    {'06'},... FYS05
    {'05'},... FYN04
    {'07'},... FYN05
    {'06'},... FYN06
    {'08'},... FYN07
    {'06'},... FYN08
    {'06'},... FYN09
    {'05'},... FYS06
    {'04'},... FYS10
    {'04'},... FYS07
    {'05'},... FYS08
    {'04'},... FYS09
    {'04'},... FYN10
    {'03'},... FYN12
    {'05'},... FYN13
    };

Cond.ClickTrain80 = {...
    {[]},... FYS01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.Chirp70 = {...
    {'06'},... FYS01
    {'04'},... FYN02
    {'06'},... FYN03
    {'04'},... FYS02
    {'06'},... FYS03
    {'06'},... FYS04
    {'07'},... FYS05
    {'06'},... FYN04
    {'08'},... FYN05
    {'03'},... FYN06
    {'05'},... FYN07
    {'04'},... FYN08
    {'03'},... FYN09
    {'02'},... FYS06
    {'03'},... FYS10
    {'05'},... FYS07
    {'06'},... FYS08
    {'05'},... FYS09
    {'02'},... FYN10
    {'05'},... FYN12
    {'06'},... FYN13
    };

Cond.Chirp80 = {...
    {[]},... FYS01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
    {'08'},... FYN02
    {[]},... FYN03 -- broke from head-fixation during injection
    {'07'},... FYS02 - directly after saline Noiseburst 70db
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    {'07'},... FYN04 -- Noiseburst 70db - survived nic injec
    {'09'},... FYN05 -- survived, Noiseburst 70db
    {'07'},... FYN06- survived, Noiseburst 70db
    {'09'},... FYN07
    {'07'},... FYN08
    {'07'},... FYN09
    {'07'},... FYS06
    {'07'},... FYS10
    {'06'},... FYS07
    {'07'},... FYS08
    {'06'},... FYS09
    {'07'},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
    {'09'},... FYN02 - died during
    {[]},... FYN03
    {'08'},... FYS02
    {'08'},... FYS03
    {'09'},... FYS04
    {'09'},... FYS05
    {'08'},... FYN04
    {'10'},... FYN05
    {'08'},... FYN06
    {'10'},... FYN07
    {'08'},... FYN08
    {'08'},... FYN09
    {'08'},... FYS06
    {'08'},... FYS10
    {'07'},... FYS07
    {'08'},... FYS08
    {'07'},... FYS09
    {'08'},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.TreatTonotopy = {...
    {'09'},... FYS01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYS02
    {[]},... FYS03 
    {[]},... FYS04
    {[]},... FYS05
    {[]},... FYN04
    {[]},... FYN05
    {[]},... FYN06
    {[]},... FYN07
    {[]},... FYN08
    {[]},... FYN09
    {[]},... FYS06
    {[]},... FYS10
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    {[]},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
    {[]},... FYN02
    {[]},... FYN03
    {'09'},... FYS02 Noiseburst 70db
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'10'},... FYS05 Noiseburst 70db
    {'09'},... FYN04 Noiseburst 70db
    {'11'},... FYN05
    {'09'},... FYN06
    {'11'},... FYN07
    {'09'},... FYN08
    {'09'},... FYN09
    {'09'},... FYS06
    {'09'},... FYS10
    {'08'},... FYS07
    {'09'},... FYS08
    {'08'},... FYS09
    {'09'},... FYN10
    {[]},... FYN12
    {[]},... FYN13
    };
