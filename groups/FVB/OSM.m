%%OSM - Old Saline Male
%%CSD
animals = {'FOS01','FOS02','FOS06','FOS07','FOS11'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    '[23 10 24 9 25 8 26 7 27 6 28 5 29]',... SO7
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... S11
   };

%             S01      S02      S06     S07     S11
Layer.II = {'[1:3]',  '[1:3]','[1:3]','[1:2]','[1:3]'}; 
%              
Layer.IV = {'[4:8]',  '[4:8]', '[4:10]', '[3:7]','[4:8]'};
%              
Layer.Va = {'[9:12]', '[9:11]','[11:14]','[8:9]','[9:12]'};
%              
Layer.Vb = {'[13:15]','[12:15]','[15:16]','[10:11]','[13:15]'}; 
%              
Layer.VI = {'[16:18]','[16:20]','[17:20]','[12:13]','[16:20]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.gapASSR70 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.gapASSR80 = {...
   {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.Tonotopy70 = {...
   {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.Tonotopy80 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.Spontaneous = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
	};

Cond.ClickTrain70 = {...
   {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
	};

Cond.ClickTrain80 = {...
   {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.Chirp70 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.Chirp80 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS06 Noiseburst 70dB
    {'14'},... FOS07 Noiseburst 70dB
    {'12'},... FOS11 Noiseburst 70dB
    };

Cond.TreatgapASSR70 = {...
    {'07'},... FOS01
    {'13'},... FOS02
    {'13'},... FOS06
    {'15'},... FOS07 
    {'14'},... FOS11
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.TreatTonotopy = {...
    {[]},... FOS01
    {[]},... FOS02
    {[]},... FOS06
    {[]},... F0S07
    {[]},... FOS11
    };

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS06
    {'17'},... FOS07
    {'15'},... FOS11
    };
