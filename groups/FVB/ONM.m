%%ONM - Old Nicotine Male
%%CSD
animals = {'FON04','FON06','FON07','FON08','FON12'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
  '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... N04
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... N06
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N07
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...N08
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...N12
   };

%             
Layer.II = {'[1:4]','[1:3]','[1:3]','[1:3]','[1:2]'}; 
%              
Layer.IV = {'[5:9]','[4:7]','[4:8]','[4:10]','[3:6]'};
%              
Layer.Va = {'[10:12]','[8:10]','[9:11]','[11:13]','[7:9]'};
%              
Layer.Vb = {'[13:17]','[11:14]','[12:14]','[14:16]','[10:13]'}; 
%              
Layer.VI = {'[18:23]','[15:20]','[15:16]','[17:18]','[14:20]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.NoiseBurst80 = {...
  {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.gapASSR70 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.gapASSR80 = {...
   {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.Tonotopy70 = {...
   {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.Tonotopy80 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.Spontaneous = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
	};

Cond.ClickTrain70 = {...
   {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
	};

Cond.ClickTrain80 = {...
   {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.Chirp70 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.Chirp80 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.TreatNoiseBurst1 = {...
     {'14'},... FON04 Noiseburst 70 dB
    {'15'},... FON06 Noiseburst 70 db
    {'12'},... FON07 Noiseburst 70db
    {'15'},... FON08 Noiseburst 70dB
    {'12'},... FON12 Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'15'},... FON04 
    {'17'},... FON06
    {[]},... FON07
    {[]},... FON08
    {'14'},... FON12
    };

Cond.TreatgapASSR80 = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.TreatTonotopy = {...
    {[]},... FON04
    {[]},... FON06
    {[]},... FON07
    {[]},... FON08
    {[]},... FON12
    };

Cond.TreatNoiseBurst2 = {...
    {'17'},... FON04 Noiseburst 70dB
    {'18'},... FON06
    {[]},... FON07
    {'17'},... FON08
    {'15'},... FON12 noiseburst 70db
    };
