%%ONF - Old Nicotine Female
%%CSD
animals = {'FON02','FON03','FON05''FON09','FON10'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
  '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... N02
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N03
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... N05
    '[9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N09
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...N10
   };

%             N02 .   N03 .   N05 .    N09 .  N10
Layer.II = {'[1:3]','[1:3]','[1:3]','[1:3]','[1:3]'}; 
%              
Layer.IV = {'[4:8]', '[4:7]','[4:10]','[4:8]','[4:8]'};
%              
Layer.Va = {'[9:11]','[8:9]','[11:13]','[9:11]','[9:10]'};
%              
Layer.Vb = {'[12:14]','[10:12]','[14:16]','[12:14]','[11:12]'}; 
%              
Layer.VI = {'[15:18]','[13:16]','[17:20]','[15:16]','[13:16]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.NoiseBurst80 = {...
  {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.gapASSR70 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.gapASSR80 = {...
   {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.Tonotopy70 = {...
   {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.Tonotopy80 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.Spontaneous = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
	};

Cond.ClickTrain70 = {...
   {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
	};

Cond.ClickTrain80 = {...
   {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.Chirp70 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.Chirp80 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    {'12'},... FON05 Noiseburst 70 db
    {'11'},... FON09 Noiseburst 70db
    {'12'},... FON10 Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'13'},... FON02 
    {'13'},... FON03
    {'14'},... FON05
    {[]},... FON09 Mouse died
    {'13'},... FON10
    };

Cond.TreatgapASSR80 = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.TreatTonotopy = {...
    {[]},... FON02
    {[]},... FON03
    {[]},... FON05 
    {[]},... FON09
    {[]},... FON10
    };

Cond.TreatNoiseBurst2 = {...
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    {'15'},... FON05
    {[]},... FON09
    {'15'},... FON10
    };
