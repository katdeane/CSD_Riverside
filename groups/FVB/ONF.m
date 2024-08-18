%%% Group ONF = Old Nicotine Female

animals = {'FON02','FON03'};

% notes:
% N02: 17.3 months;female
% N03: 18.5 months;female

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... N02
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... N03
    
    };

%              N02       N03       
Layer.II = {  '[1:7]',  '[1:6]'};        
%             N02       N03        
Layer.IV = { '[8:12]', '[7:12]'};
%             N02       N03       
Layer.Va = {'[13:16]','[10:12]'};
%             N02       N03        
Layer.Vb = {'[16:18]','[17:20]'}; 
%             N02       N03        
Layer.VI = {'[19:21]','[21:22]',}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FON02
    {'01'},... FON03
    };

Cond.NoiseBurst80 = {...
    {'07'},... FON02
    {'10'},... FON03
    };

Cond.gapASSR70 = {...
    {'04'},... FON02
    {'03'},... FON03
    };

Cond.gapASSR80 = {...
    {'11'},... FON02
    {'09'},... FON03
    };

Cond.Tonotopy70 = {...
    {'03'},... FON02
    {'02'},... FON03
    };

Cond.Tonotopy80 = {...
    {'08'},... FON02
    {'11'},... FON03
    };

Cond.Spontaneous = {...
    {'02'},... FON02
    {'06'},... FON03
   };

Cond.ClickTrain70 = {...
    {'05'},... FON02
    {'04'},... FON03
    };

Cond.ClickTrain80 = {...
    {'10'},... FON02
    {'08'},... FON03
    };

Cond.Chirp70 = {...
    {'06'},... FON02
    {'05'},... FON03
    };

Cond.Chirp80 = {...
    {'09'},... FON02
    {'07'},... FON03
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    };

Cond.TreatgapASSR70 = {...
    {'13'},... FON02 
    {'13'},... FON03
    };

Cond.TreatgapASSR80 = {...
    {'14'},... FON02
    {'14'},... FON03
    };

Cond.TreatTonotopy = {...
    {[]},... FON02
    {[]},... FON03
    };

Cond.TreatNoiseBurst2 = {...
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    };
