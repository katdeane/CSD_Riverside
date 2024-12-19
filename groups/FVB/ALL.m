%%% Group YNG = FVB Young Saline & Nicotine
animals = {'FYS01','FYN02', 'FYN03','FYS02','FYS03','FYS04','FYS05',...
    'FYN04','FYN05','FYN06','FYN07','FYN08','FYN09','FYS06','FYS10','FYS07','FYS08','FYS09','FYN10','FYN12','FYN13','FOS01','FOS02','FOS03','FOS04','FOS05', 'FOS06',...
    'FON02','FON03','FON04','FOS07','FOS08','FOS09','FOS11','FON05','FON06','FON07','FON08','FON09','FON10','FON11','FOS12','FON12'};

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
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04 
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... S05
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... N02
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    '[23 10 24 9 25 8 26 7 27 6 28 5 29]',... SO7
    '[10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S08
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... S09
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... S11
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... N05
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... N06
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N07
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...N08
    '[9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N09
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...N10
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N11
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...S12
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...N12
    };

%           S01        N02        N03      S02       S03        S04       S05      N04        N05
Layer.II = {'[1:3]','[1:3]',   '[1:3]',  '[1:3]', '[1:3]',   '[1:3]',  '[1:3]', '[1:3]',   '[1:3]'...
%     YN06    YN07    YN08   YN09     YS06    YS10    YS07   YS08     YS09   YN10
    '[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:2]','[1:3]','[1:3]'...
%    YN12    YN13    S01         S02         S03         S04         S05         S06        N02       N03       N04      S07 
    '[1:2]','[1:3]','[1:3]',    '[1:3]',    '[1:3]',    '[1:2]',    '[1:3]',    '[1:3]',   '[1:3]',  '[1:3]',  '[1:3]','[1:2]'...
 %    S08     S09     S11     N05     N06     N07      N08    N09     N10     N11     
    '[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:2]'}; 
%           S01         N02        N03      S02       S03    S04       S05      N04       N05
Layer.IV = {'[4:8]',  '[4:8]',  '[4:6]', '[4:8]', '[4:8]' ,'[4:8]', '[4:6]',  '[4:7]', '[4:10]'...
    %YN06     YN07    YN08    YN09     YS06    YS10    YS07   YS08     YS09   YN10
    '[4:8]','[4:8]','[4:8]','[4:9]','[4:8]','[4:8]','[4:8]','[3:6]','[4:8]','[4:9]'...
 %    YN12    YN13    S01         S02         S03         S04         S05         S06        N02       N03       N04      S07
    '[3:8]','[4:7]','[4:8]',    '[4:8]',    '[4:7]',    '[3:5]',    '[4:8]',   '[4:10]',  '[4:8]', '[4:7]', '[4:9]','[3:7]'...
    % S08   S09     S11       N05     N06      N07      N08     N09    N10     N11 
    '[4:7]','[4:7]','[4:8]','[4:10]','[4:7]','[4:8]','[4:10]','[4:8]','[4:8]','[4:9]','[4:7]','[3:6]'};
%           S01          N02        N03      S02       S03    S04       S05      N04      N05
Layer.Va = {'[9:12]', '[9:11]', '[7:8]','[9:11]','[9:12]','[9:11]','[7:10]','[8:10]','[11:14]'...
    %YN06      YN07     YN08     YN09      YS06     YS10     YS07     YS08     YS09      YN10
    '[9:12]','[9:12]','[9:11]','[10:12]','[9:12]','[9:11]','[9:11]','[7:10]','[9:12]','[10:13]'...
%    YN12      YN13     S01         S02         S03        S04         S05         S06        N02      N03       N04      S07
    '[9:14]','[8:11]','[9:12]',   '[9:11]',   '[8:10]',  '[6:9]',     '[9:11]',  '[11:14]', '[9:11]','[8:9]','[10:12]','[8:9]'...
     % S08      S09     S11      N05       N06       N07      N08      N09      N10      N11
    '[8:11]','[8:11]','[9:12]','[11:13]','[8:10]','[9:11]','[11:13]','[9:11]','[9:10]','[10:12]','[8:10]','[7:9]'};
%           S01          N02        N03      S02       S03        S04       S05      N04        N05
Layer.Vb = {'[13:15]','[12:14]', '[9:10]','[12:14]','[13:15]','[12:15]','[11:14]','[11:14]','[15:17]'...
    %  YN06      YN07      YN08      YN09      YS06     YS10      YS07      YS08      YS09       YN10
    '[13:15]','[13:16]','[12:14]','[13:15]','[13:15]','[12:14]','[12:14]','[11:12]','[13:14]','[14:16]'...
 %    YN12       YN13     S01         S02         S03         S04         S05         S06        N02       N03       N04       S07
    '[15:19]','[12:15]','[13:15]',  '[12:15]',  '[11:14]',  '[10:12]',  '[12:14]',  '[15:16]', '[12:14]','[10:12]','[13:17]','[10:11]'...
    % S08       S09        S11       N05      N06       N07       N08        N09      N10      N11
    '[12:13]','[12:15]','[13:15]','[14:16]','[11:14]','[12:14]','[14:16]','[12:14]','[11:12]','[13:15]','[11:13]','[10:13]' }; 
%           S01          N02        N03      S02       S03        S04       S05      N04        N05
Layer.VI = {'[16:18]','[15:19]', '[11:14]','[15:18]','[16:19]','[16:20]','[15:18]','[15:18]','[18:21]'...
     %  YN06      YN07      YN08      YN09      YS06     YS10      YS07      YS08      YS09       YN10
    '[16:18]','[17:22]','[15:18]','[16:18]','[16:18]','[15:17]','[15:19]','[13:18]','[15:20]','[17:18]'...
%      YN12    YN13        S01         S02         S03         S04         S05         S06        N02       N03       N04      S07
    '[20:26]','[16:20]','[16:18]',  '[16:20]',  '[15:18]',  '[13:16]',  '[15:18]',  '[17:20]', '[15:18]','[13:16]','[18:23]','[12:13]'...
     % .S08      S09       S11       N05       N06       N07       N08       N09       N10       N11 
    '[14:15]','[16:20]','[16:20]','[17:20]','[15:20]','[15:16]','[17:18]','[15:16]','[13:16]','[16:20]','[14:17]','[14:20]'}; 


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
    {'01'},... FOS01
    {'01'},... FOS02
    {'01'},... FOS03
    {'01'},... FOS04 
    {'01'},... FOS05
    {'01'},... FOS06
    {'01'},... FON02
    {'01'},... FON03
    {'03'},... FON04
    {'03'},... FOS07
    {'02'},... FOS08
    {'02'},... FOS09
    {'01'},... FOS11
    {'02'},... FON05
    {'04'},... FON06
    {'01'},... FON07
    {'02'},... FON08
    {'01'},... FON09
    {'01'},... FON10
    {'02'},... FON11
    {'03'},... FOS12
    {'01'},... FON12
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
    {[]},... FOS01
    {'02'},... FOS02
    {'08'},... FOS03
    {'07'},... FOS04 
    {'04'},... FOS05
    {'08'},... FOS06
    {'07'},... FON02
    {'10'},... FON03
    {'10'},... FON04
    {'01'},... FON01
    {'08'},... FOS07
    {'08'},... FOS08
    {'08'},... FOS09
    {'06'},... FOS11
    {'11'},... FON05
    {'14'},... FON06
    {'07'},... FON07
    {'09'},... FON08
    {'07'},... FON09
    {'06'},... FON10
    {'07'},... FON11
    {'08'},... FOS12
    {'06'},... FON12
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
    {'03'},... FOS01 
    {'07'},... FOS02
    {'03'},... FOS03
    {'04'},... FOS04    
    {'06'},... FOS05
    {'04'},... FOS06
    {'04'},... FON02
    {'03'},... FON03
    {'06'},... FON04
    {'12'},... FOS07
    {'06'},... FOS08
    {'06'},... FOS09
    {'02'},... FOS11
    {'06'},... FON05
    {'06'},... FON06
    {'04'},... FON07
    {'11'},... FON08
    {'04'},... FON09
    {'08'},... FON10
    {[]},... FON11
    {'06'},... FOS12
    {'04'},... FON12
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
    {[]},... FOS01 
    {'10'},... FOS02
    {'10'},... FOS03 
    {'09'},... FOS04     
    {'10'},... FOS05 
    {'09'},... FOS06
    {'11'},... FON02
    {'09'},... FON03
    {'09'},... FON04
    {'07'},... FOS07
    {'12'},... FOS08
    {'14'},... FOS09
    {'08'},... FOS11
    {'09'},... FON05
    {'09'},... FON06
    {'10'},... FON07
    {'05'},... FON08
    {'09'},... FON09
    {'03'},... FON10
    {'05'},... FON11
    {'11'},... FOS12
    {'09'},... FON12
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
    {'05'},... FOS01
    {'04'},... FOS02
    {'05'},... FOS03
    {'03'},... FOS04    
    {'05'},... FOS05
    {'03'},... FOS06
    {'03'},... FON02
    {'02'},... FON03
    {'05'},... FON04
    {'10'},... FOS07
    {'10'},... FOS08
    {'04'},... FOS09
    {'04'},... FOS11
    {'04'},... FON05
    {'10'},... FON06
    {'09'},... FON07
    {'13'},... FON08
    {'08'},... FON09
    {'04'},... FON10
    {'08'},... FON11
    {'04'},... FOS12
    {'02'},... FON12
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
    {[]},... FOS01
    {'08'},... FOS02
    {'11'},... FOS03
    {'08'},... FOS04    
    {'09'},... FOS05
    {'07'},... FOS06
    {'08'},... FON02
    {'11'},... FON03
    {'11'},... FON04
    {'05'},... FOS07
    {'04'},... FOS08
    {'12'},... FOS09
    {'10'},... FOS11
    {'08'},... FON05
    {'07'},... FON06
    {'03'},... FON07
    {'08'},... FON08
    {'03'},... FON09
    {'09'},... FON10
    {'03'},... FON11
    {'09'},... FOS12
    {'07'},... FON12
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
    {[]},... FOS01
    {'03'},... FOS02
    {'04'},... FOS03
    {'02'},... FOS04    
    {'02'},... FOS05
    {'02'},... FOS06
    {'02'},... FON02
    {'06'},... FON03
    {'04'},... FON04
    {'13'},... FOS07
    {'07'},... FOS08
    {'07'},... FOS09
    {'07'},... FOS11
    {[]},... FON05
    {'12'},... FON06
    {'06'},... FON07
    {'07'},... FON08
    {[]},... FON09
    {'11'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {'13'},... FOS12
    {'11'},... FON12
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
    {'06'},... FOS01
    {'06'},... FOS02
    {'06'},... FOS03
    {'05'},... FOS04    
    {'07'},... FOS05
    {'05'},... FOS06
    {'05'},... FON02
    {'04'},... FON03
    {'07'},... FON04
    {'04'},... FOS07
    {'09'},... FOS08
    {'06'},... FOS09
    {'11'},... FOS11
    {'07'},... FON05
    {'08'},... FON06
    {'11'},... FON07
    {'04'},... FON08
    {'05'},... FON09
    {'02'},... FON10
    {'04'},... FON11
    {'10'},... FOS12
    {'10'},... FON12
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
    {[]},... FOS01
    {'11'},... FOS02
    {'09'},... FOS03
    {'10'},... FOS04    
    {'11'},... FOS05
    {'10'},... FOS06
    {'10'},... FON02
    {'08'},... FON03
    {'12'},... FON04
    {'09'},... FOS07
    {'03'},... FOS08
    {'09'},... FOS09
    {'05'},... FOS11
    {'10'},... FON05
    {'13'},... FON06
    {'05'},... FON07
    {'12'},... FON08
    {'10'},... FON09
    {'07'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {'05'},... FOS12
    {'05'},... FON12
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
    {'03'},... FYS06
    {'03'},... FYS10
    {'05'},... FYS07
    {'06'},... FYS08
    {'05'},... FYS09
    {'02'},... FYN10
    {'05'},... FYN12
    {'06'},... FYN13
    {'04'},... FOS01
    {'05'},... FOS02
    {'02'},... FOS03
    {'06'},... FOS04    
    {'08'},... FOS05
    {'06'},... FOS06
    {'06'},... FON02
    {'05'},... FON03
    {'08'},... FON04
    {'06'},... FOS07
    {'11'},... FOS08
    {'13'},... FOS09
    {'09'},... FOS11
    {'03'},... FON05
    {'11'},... FON06
    {'02'},... FON07
    {'03'},... FON08
    {'02'},... FON09
    {'10'},... FON10
    {'06'},... FON11
    {'12'},... FOS12
    {'08'},... FON12
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
    {[]},... FOS01
    {'09'},... FOS02
    {'07'},... FOS03
    {'11'},... FOS04    
    {'12'},... FOS05
    {'11'},... FOS06
    {'09'},... FON02
    {'07'},... FON03
    {'13'},... FON04
    {'11'},... FOS07
    {'05'},... FOS08
    {'05'},... FOS09
    {'03'},... FOS11
    {'05'},... FON05
    {'05'},... FON06
    {'08'},... FON07
    {'10'},... FON08
    {'06'},... FON09
    {'05'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {'07'},... FOS12
    {'03'},... FON12
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
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db    
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'12'},... FOS06 Noiseburst 70dB
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    {'14'},... FON04 Noiseburst 70 dB
    {'14'},... FOS07 Noiseburst 70dB
    {'13'},... FOS08 Noiseburst 70dB
    {'15'},... FOS09 Noiseburst 70dB
    {'12'},... FOS11 Noiseburst 70dB
    {'12'},... FON05 Noiseburst 70 db
    {'15'},... FON06 Noiseburst 70 db
    {'12'},... FON07 Noiseburst 70db
    {'15'},... FON08 Noiseburst 70dB
    {'11'},... FON09 Noiseburst 70db
    {'12'},... FON10 Noiseburst 70db
    {[]},... FON11 Mouse broke out of headfixation
    {[]},... FOS12 Mouse broke out of headfixation
    {'12'},... FON12 Noiseburst 70db
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
    {'07'},... FOS01
    {'13'},... FOS02
    {'14'},... FOS03
    {'14'},... FOS04    
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'13'},... FOS06
    {'13'},... FON02 
    {'13'},... FON03
    {'15'},... FON04
    {'15'},... FOS07 
    {'15'},... FOS08
    {'17'},... FOS09
    {'14'},... FOS11
    {'14'},... FON05
    {'17'},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON09 Mouse died
    {'13'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {[]},... FOS12 Mouse broke out of headfixation
    {'14'},... FON12
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
    {[]},... FOS01
    {'14'},... FOS02
    {'13'},... FOS03
    {'13'},... FOS04    
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'14'},... FOS06
    {'14'},... FON02
    {'14'},... FON03
    {'16'},... FON04
    {'16'},... FOS07
    {'14'},... FOS08
    {'16'},... FOS09
    {'13'},... FOS11
    {'13'},... FON05
    {'16'},... FON06
    {'13'},... FON07
    {'16'},... FON08
    {[]},... FON09
    {'14'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {[]},... FOS12 Mouse broke out of headfixation
    {'13'},... FON12
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
    {[]},... FOS01 
    {[]},... FOS02
    {[]},... FOS03
    {[]},... FOS04    
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {[]},... FOS06
    {[]},... FON02
    {[]},... FON03
    {[]},... FON04
    {[]},... FOS07
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS11
    {[]},... FON05 
    {[]},... FON06 
    {[]},... FON07
    {[]},... FON08
    {[]},... FON09
    {[]},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {[]},... FOS12 Mouse broke out of headfixation
    {[]},... FON12
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
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db    
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'15'},... FOS06
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    {'17'},... FON04 Noiseburst 70dB
    {'17'},... FOS07
    {'16'},... FOS08
    {'18'},... FOS09
    {'15'},... FOS11
    {'15'},... FON05
    {'18'},... FON06
    {[]},... FON07
    {'17'},... FON08
    {[]},... FON09
    {'15'},... FON10
    {[]},... FON11 Mouse broke out of headfixation
    {[]},... FOS12 Mouse broke out of headfixation
    {'15'},... FON12 noiseburst 70db
    };
