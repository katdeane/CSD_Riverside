%%EMP - Just an empty script for AJ to fill in single animals to look at
%%CSD
animals = {'FYN10'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
  '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]'
   };

%             
Layer.II = {'[1:3]'}; 
%              
Layer.IV = {'[4:9]'};
%              
Layer.Va = {'[10:13]'};
%              
Layer.Vb = {'[14:16]'}; 
%              
Layer.VI = {'[17:18]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYN10
    
    };

Cond.NoiseBurst80 = {...
  
    };

Cond.gapASSR70 = {...
    
    };

Cond.gapASSR80 = {...
   
    };

Cond.Tonotopy70 = {...
   
    };

Cond.Tonotopy80 = {...
    
    };

Cond.Spontaneous = {...
    
	};

Cond.ClickTrain70 = {...
   
	};

Cond.ClickTrain80 = {...
   
    };

Cond.Chirp70 = {...
    
    };

Cond.Chirp80 = {...
    
    };

Cond.TreatNoiseBurst1 = {...
 
    };

Cond.TreatgapASSR70 = {...
    
    };

Cond.TreatgapASSR80 = {...
    
    };

Cond.TreatTonotopy = {...

    };

Cond.TreatNoiseBurst2 = {...
    
    };
