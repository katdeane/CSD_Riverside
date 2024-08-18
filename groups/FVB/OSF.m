%%% Group OSF = Old Saline Female
animals = {'FOS03','FOS04','FOS05'};

% notes:
% S03: 19.5 months- Had a double stimulus line in CSD?; female
% S04: 17.7 months; female - Very low signal, deaf?- mouse was very lethargic after
%           recording
% S05: 16.2 months; female - had an eye infection, no treatment given, response to
%           noiseburst was still seen in raw signal, but low response in CSD


%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    };

%             S03        S04        S05   
Layer.II = {'[1:5]',  '[1:4]',  '[1:5]'};        
%             S03        S04      S05 
Layer.IV = {'[6:9]',  '[5:9]',  '[6:11]'};
%             S03         S04        S05   
Layer.Va = {'[10:14]','[10:14]','[12:14]'};
%             S03       S04      S05  
Layer.Vb = {'[15:17]','[15:17]','[15:17]'}; 
%             S03       S04      S05    
Layer.VI = {'[18:20]','[18:20]','[18:20]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS03
    {'01'},... FOS04
    {'01'},... FOS05
    };

Cond.NoiseBurst80 = {...
    {'08'},... FOS03
    {'07'},... FOS04
    {'04'},... FOS05
    };

Cond.gapASSR70 = {...
    {'03'},... FOS03
    {'04'},... FOS04
    {'06'},... FOS05
    };

Cond.gapASSR80 = {...
    {'10'},... FOS03 
    {'09'},... FOS04 
    {'10'},... FOS05 
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS03
    {'03'},... FOS04
    {'05'},... FOS05
    };

Cond.Tonotopy80 = {...
    {'11'},... FOS03
    {'08'},... FOS04
    {'09'},... FOS05
    };

Cond.Spontaneous = {...
    {'04'},... FOS03
    {'02'},... FOS04
    {'02'},... FOS05
	};

Cond.ClickTrain70 = {...
    {'06'},... FOS03
    {'05'},... FOS04
    {'07'},... FOS05
	};

Cond.ClickTrain80 = {...
    {'09'},... FOS03
    {'10'},... FOS04
    {'11'},... FOS05
	};

Cond.Chirp70 = {...
    {'02'},... FOS03
    {'06'},... FOS04
    {'08'},... FOS05
    };

Cond.Chirp80 = {...
    {'07'},... FOS03
    {'11'},... FOS04
    {'12'},... FOS05
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
	};

Cond.TreatgapASSR70 = {...
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    };

Cond.TreatgapASSR80 = {...
    {'13'},... FOS03
    {'13'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    };

Cond.TreatTonotopy = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
	};

Cond.TreatNoiseBurst2 = {...
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    };
