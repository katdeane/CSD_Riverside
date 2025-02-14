%%YSM - Young Saline Male
%%CSD
animals = {'FYS01','FYS05','FYS07','FYS08','FYS09'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
'[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YS01
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...YS07
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...YS08
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',...YS09
   };

%             S01    S05      S07     S08     S09
Layer.II = {'[1:3]','[1:3]','[1:3]','[1:2]','[1:3]'}; 
%              
Layer.IV = {'[4:8]','[4:6]','[4:8]','[3:6]','[4:8]'};
%              
Layer.Va = {'[9:12]','[7:10]','[9:11]','[7:10]','[9:12]'};
%              
Layer.Vb = {'[13:15]','[11:14]','[12:14]','[11:12]','[13:14]'}; 
%              
Layer.VI = {'[16:18]','[15:18]','[15:19]','[13:18]','[15:20]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
   
    };

Cond.NoiseBurst80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
  
    };

Cond.gapASSR70 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
    };

Cond.gapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
   
    };

Cond.Tonotopy70 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
   
    };

Cond.Tonotopy80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
    };

Cond.Spontaneous = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
	};

Cond.ClickTrain70 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
   
	};

Cond.ClickTrain80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
   
    };

Cond.Chirp70 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
    };

Cond.Chirp80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYS01 - directly after saline
    {'08'},... FYS05 - directly after saline Noiseburst 70db
    {'06'},... FYS07
    {'07'},... FYS08
    {'06'},... FYS09
 
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYS01
    {'09'},... FYS05
    {'07'},... FYS07
    {'08'},... FYS08
    {'07'},... FYS09
    
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09
    
    };

Cond.TreatTonotopy = {...
    {[]},... FYS01
    {[]},... FYS05
    {[]},... FYS07
    {[]},... FYS08
    {[]},... FYS09

    };

Cond.TreatNoiseBurst2 = {...
    {'10'},... FYS01 - 31 minutes after saline
    {'10'},... FYS05 Noiseburst 70db
    {'08'},... FYS07
    {'09'},... FYS08
    {'08'},... FYS09
    
    };
