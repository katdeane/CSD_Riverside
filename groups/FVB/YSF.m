%%YSF - Young Saline Female  
%%CSD
animals = {'FYS02','FYS03','FYS04','FYS06','FYS10'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S03
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S04
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS06
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS10
   };

%             S02      S03        S04     S06 .   YS10 
Layer.II = {'[1:3]', '[1:3]', '[1:3]','[1:3]','[1:3]'}; 
%              
Layer.IV = {'[4:8]', '[4:8]' ,'[4:8]','[4:8]','[4:8]'};
%              
Layer.Va = {'[9:11]','[9:12]','[9:11]','[9:12]','[9:11]'};
%              
Layer.Vb = {'[12:14]','[13:15]','[12:15]','[13:15]','[12:14]'}; 
%              
Layer.VI = {'[15:18]','[16:19]','[16:20]','[16:18]','[15:17]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.NoiseBurst80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    };

Cond.gapASSR70 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.gapASSR80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
   
    };

Cond.Tonotopy70 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
   
    };

Cond.Tonotopy80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.Spontaneous = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
	};

Cond.ClickTrain70 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
   
	};

Cond.ClickTrain80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
   
    };

Cond.Chirp70 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.Chirp80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS02 - directly after saline Noiseburst 70db
    {'07'},... FYS03 - directly after saline Noiseburst 70db
    {'08'},... FYS04 - directly after saline Noiseburst 70db
    {'07'},... FYS06
    {'07'},... FYS10
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS02
    {'08'},... FYS03
    {'09'},... FYS04
    {'08'},... FYS06
    {'08'},... FYS10
    
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10
    
    };

Cond.TreatTonotopy = {...
    {[]},... FYS02
    {[]},... FYS03
    {[]},... FYS04
    {[]},... FYS06
    {[]},... FYS10

    };

Cond.TreatNoiseBurst2 = {...
    {'09'},... FYS02 Noiseburst 70db
    {'09'},... FYS03 Noiseburst 70db
    {'10'},... FYS04 Noiseburst 70db
    {'09'},... FYS06
    {'09'},... FYS10
    };
