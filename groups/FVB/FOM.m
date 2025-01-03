%%% Group FOM = FVB Old Male

animals = {'FOS01','FOS02','FOS06','FON04','FOS07','FOS11','FON06','FON07','FON08','FON11'};

% notes:
% 

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    '[23 10 24 9 25 8 26 7 27 6 28 5 29]',... SO7
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... S11
     '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... N06
     '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N07
     '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...N08
     '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N11
    };

%             S01      S02      S06      N04    S07    S11      N06     N07
Layer.II = {'[1:3]',  '[1:3]','[1:3]','[1:4]','[1:2]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]'};        
%                  
Layer.IV = {'[4:8]',  '[4:8]','[4:10]','[5:9]','[3:7]','[4:8]','[4:7]','[4:8]','[4:10]','[4:9]'};
%                    
Layer.Va = {'[9:12]', '[9:11]','[11:14]','[10:12]','[8:9]','[9:12]','[8:10]','[9:11]','[11:13]','[10:12]'};
%                   
Layer.Vb = {'[13:15]','[12:15]','[15:16]','[13:17]','[10:11]','[13:15]','[11:14]','[12:14]','[14:16]','[13:15]'}; 
%                    
Layer.VI = {'[16:18]','[16:20]','[17:20]','[18:23]','[12:13]','[16:20]','[15:20]','[15:16]','[17:18]','[16:20]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS01
    {'01'},... FOS02
    {'01'},... FOS06
    {'03'},... FON04
    {'03'},... FOS07
    {'01'},... FOS11
    {'04'},... FON06
    {'01'},... FON07
    {'02'},... FON08
    {'02'},... FON11
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    {'02'},... FOS02
    {'08'},... FOS06
    {'10'},... FON04
    {'08'},... FOS07
    {'06'},... FOS11
    {'14'},... FON06
    {'07'},... FON07
    {'09'},... FON08
    {'07'},... FON11
    };

Cond.gapASSR70 = {...
    {'03'},... FOS01 
    {'07'},... FOS02
    {'04'},... FOS06
    {'06'},... FON04
    {'12'},... FOS07
    {'02'},... FOS11
    {'06'},... FON06
    {'04'},... FON07
    {'11'},... FON08
    {[]},... FON11
    };

Cond.gapASSR80 = {...
     {[]},... FOS01 
    {'10'},... FOS02
    {'09'},... FOS06
    {'09'},... FON04
    {'07'},... FOS07
    {'08'},... FOS11
    {'09'},... FON06
    {'10'},... FON07
    {'05'},... FON08
    {'05'},... FON11
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS01
    {'04'},... FOS02
    {'03'},... FOS06
    {'05'},... FON04
    {'10'},... FOS07
    {'04'},... FOS11
    {'10'},... FON06
    {'09'},... FON07
    {'13'},... FON08
    {'08'},... FON11
    };

Cond.Tonotopy80 = {...
    {[]},... FOS01
    {'08'},... FOS02
    {'07'},... FOS06
    {'11'},... FON04
    {'05'},... FOS07
    {'10'},... FOS11
    {'07'},... FON06
    {'03'},... FON07
    {'08'},... FON08
    {'03'},... FON11
    };

Cond.Spontaneous = {...
    {[]},... FOS01
    {'03'},... FOS02
    {'02'},... FOS06
    {'04'},... FON04
    {'13'},... FOS07
    {'07'},... FOS11
    {'12'},... FON06
    {'06'},... FON07
    {'07'},... FON08
    {[]},... FON11 Mouse broke out of headfixation
   };

Cond.ClickTrain70 = {...
    {'06'},... FOS01
    {'06'},... FOS02
    {'05'},... FOS06
    {'07'},... FON04
    {'04'},... FOS07
    {'11'},... FOS11
    {'08'},... FON06
    {'11'},... FON07
    {'04'},... FON08
    {'04'},... FON11
    };

Cond.ClickTrain80 = {...
    {[]},... FOS01
    {'11'},... FOS02
    {'10'},... FOS06
    {'12'},... FON04
    {'09'},... FOS07
    {'05'},... FOS11
    {'13'},... FON06
    {'05'},... FON07
    {'12'},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.Chirp70 = {...
    {'04'},... FOS01
    {'05'},... FOS02
    {'06'},... FOS06
    {'08'},... FON04
    {'06'},... FOS07
    {'09'},... FOS11
    {'11'},... FON06
    {'02'},... FON07
    {'03'},... FON08
    {'06'},... FON11
    };

Cond.Chirp80 = {...
    {[]},... FOS01
    {'09'},... FOS02
    {'11'},... FOS06
    {'13'},... FON04
    {'11'},... FOS07
    {'03'},... FOS11
    {'05'},... FON06
    {'08'},... FON07
    {'10'},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS06 Noiseburst 70dB
    {'14'},... FON04 Noiseburst 70 dB
    {'14'},... FOS07 Noiseburst 70dB
    {'12'},... FOS11
    {'15'},... FON06 Noiseburst 70 db
    {'12'},... FON07 Noiseburst 70db
    {'15'},... FON08 Noiseburst 70dB
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.TreatgapASSR70 = {...
    {'07'},... FOS01
    {'13'},... FOS02
    {'13'},... FOS06
    {'15'},... FON04 
    {'15'},... FOS07 
    {'14'},... FOS11
    {'17'},... FON06
     {[]},... FON07
    {[]},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS01
    {'14'},... FOS02
    {'14'},... FOS06
    {'16'},... FON04
    {'16'},... FOS07
    {'13'},... FOS11
    {'16'},... FON06
    {'13'},... FON07
    {'16'},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.TreatTonotopy = {...
    {[]},... FOS01 
    {[]},... FOS02
    {[]},... FOS06
    {[]},... FON04 
    {[]},... FOS07
    {[]},... FOS11
    {[]},... FON06 
    {[]},... FON07
    {[]},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS06
    {'17'},... FON04 Noiseburst 70dB
    {'17'},... FOS07
    {'15'},... FOS11
    {'18'},... FON06
    {[]},... FON07
    {'17'},... FON08
    {[]},... FON11 Mouse broke out of headfixation
    };
