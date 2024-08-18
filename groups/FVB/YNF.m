%%% Group YNG = FVB Young Saline & Nicotine
animals = {'FYN04'};

%notes
%N04 - 3.15 months; female



%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... YN04
    };

%             N04 
Layer.II = {'[1:6]'}; 
%             N04 
Layer.IV = {'[7:11]'};
%             N04 
Layer.Va = {'[12:14]'};
%             N04 
Layer.Vb = {'[15:16]'}; 
%             N04 
Layer.VI = {'[17:22]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYN04
    };
    

Cond.NoiseBurst80 = {...
    {[]},... FYN04
    };

Cond.gapASSR70 = {...
    {'04'},... FYN04
    };

Cond.gapASSR80 = {...
    {[]},... FYN04
    };  

Cond.Tonotopy70 = {...
    {'03'},... FYN04
    };

 Cond.Tonotopy80 = {...
    {[]},... FYN04
    };   

Cond.Spontaneous = {...
    {'02'},... FYN04
	};

Cond.ClickTrain70 = {...
    {'05'},... FYN04
    };

Cond.ClickTrain80 = {...
    {[]},... FYN04
    };

Cond.Chirp70 = {...
    {'06'},... FYN04
    };

Cond.Chirp80 = {...
    {[]},... FYN04
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYN04 -- Noiseburst 70db - survived nic injec
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYN04
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYN04
    };

Cond.TreatTonotopy = {...
    {[]},... FYN04
    };

Cond.TreatNoiseBurst2 = {...
    {'09'},... FYN04 Noiseburst 70db
    };
