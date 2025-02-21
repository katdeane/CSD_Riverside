%%YNM - Young Nicotine Male 
%%CSD
animals = {'FYN02', 'FYN03','FYN05','FYN10','FYN13'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',... YN02
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6]',... YN03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN05
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',...YN10
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YN13
   };

%             N02      N03     N05     N10     N13
Layer.II = {'[1:3]', '[1:3]','[1:3]','[1:3]','[1:3]'}; 
%              
Layer.IV = {'[4:8]','[4:6]','[4:10]','[4:9]','[4:7]'};
%              
Layer.Va = {'[9:11]', '[7:8]','[11:14]','[10:13]','[8:11]'};
%              
Layer.Vb = {'[12:14]', '[9:10]','[15:17]','[14:16]','[12:15]'}; 
%              
Layer.VI = {'[15:19]', '[11:14]','[18:21]','[17:18]','[16:20]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.NoiseBurst80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
  
    };

Cond.gapASSR70 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.gapASSR80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
   
    };

Cond.Tonotopy70 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
   
    };

Cond.Tonotopy80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.Spontaneous = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
	};

Cond.ClickTrain70 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
   
	};

Cond.ClickTrain80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
   
    };

Cond.Chirp70 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.Chirp80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.TreatNoiseBurst1 = {...
    {'08'},... FYN02
    {[]},... FYN03 -- broke from head-fixation during injection
    {'09'},... FYN05 -- survived, Noiseburst 70db
    {'07'},... FYN10
    {[]},... FYN13
 
    };

Cond.TreatgapASSR70 = {...
    {[]},... FYN02 - died during
    {[]},... FYN03
    {'10'},... FYN05
    {'08'},... FYN10
    {[]},... FYN13
    
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13
    
    };

Cond.TreatTonotopy = {...
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    {[]},... FYN10
    {[]},... FYN13

    };

Cond.TreatNoiseBurst2 = {...
    {[]},... FYN02
    {[]},... FYN03
    {'11'},... FYN05
    {'09'},... FYN10
    {[]},... FYN13
    
    };
