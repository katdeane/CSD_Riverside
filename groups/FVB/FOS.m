%%% Group FOS = FVB Old Saline
animals = {'FOS01','FOS02','FOS03','FOS04','FOS05','FOS06'};

% notes:
% S01: 19 months; male
% S02: 17.3 months; male
% S03: 19.5 months- Had a double stimulus line in CSD?; female
% S04: 17.7 months; female - Very low signal, deaf?- mouse was very lethargic after
%           recording
% S05: 16.2 months; female - had an eye infection, no treatment given, response to
%           noiseburst was still seen in raw signal, but low response in CSD
% S06: 17 months;male

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S05
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    };

%             S01        S02      S03        S04      S05       S06          
Layer.II = {'[1:3]',  '[1:3]',  '[1:5]',  '[1:4]',  '[1:5]',  '[1:3]'}; 
%             S01        S02      S03        S04      S05       S06    
Layer.IV = {'[4:8]',  '[4:8]',  '[6:9]',  '[5:9]',  '[6:11]', '[4:10]'};
%             S01        S02      S03        S04      S05       S06 
Layer.Va = {'[9:12]', '[9:11]', '[10:14]','[10:14]','[12:14]','[11:14]'};
%             S01        S02      S03        S04      S05       S06 
Layer.Vb = {'[13:15]','[12:15]','[15:17]','[15:17]','[15:17]','[15:16]'}; 
%             S01        S02      S03        S04      S05       S06 
Layer.VI = {'[16:18]','[16:20]','[18:20]','[18:20]','[18:20]','[17:20]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS01
    {'01'},... FOS02
    {'01'},... FOS03
    {'01'},... FOS04
    {'01'},... FOS05
    {'01'},... FOS06
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    {'02'},... FOS02
    {'08'},... FOS03
    {'07'},... FOS04
    {'04'},... FOS05
    {'08'},... FOS06
    };

Cond.gapASSR70 = {...
    {'03'},... FOS01 
    {'07'},... FOS02
    {'03'},... FOS03
    {'04'},... FOS04
    {'06'},... FOS05
    {'04'},... FOS06
    };

Cond.gapASSR80 = {...
     {[]},... FOS01 
    {'10'},... FOS02
    {'10'},... FOS03 
    {'09'},... FOS04 
    {'10'},... FOS05 
    {'09'},... FOS06
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS01
    {'04'},... FOS02
    {'05'},... FOS03
    {'03'},... FOS04
    {'05'},... FOS05
    {'03'},... FOS06
    };

Cond.Tonotopy80 = {...
    {[]},... FOS01
    {'08'},... FOS02
    {'11'},... FOS03
    {'08'},... FOS04
    {'09'},... FOS05
    {'07'},... FOS06
    };

Cond.Spontaneous = {...
    {[]},... FOS01
    {'03'},... FOS02
    {'04'},... FOS03
    {'02'},... FOS04
    {'02'},... FOS05
    {'02'},... FOS06
	};

Cond.ClickTrain70 = {...
    {'06'},... FOS01
    {'06'},... FOS02
    {'06'},... FOS03
    {'05'},... FOS04
    {'07'},... FOS05
    {'05'},... FOS06
	};

Cond.ClickTrain80 = {...
    {[]},... FOS01
    {'11'},... FOS02
    {'09'},... FOS03
    {'10'},... FOS04
    {'11'},... FOS05
    {'10'},... FOS06
	};

Cond.Chirp70 = {...
    {'04'},... FOS01
    {'05'},... FOS02
    {'02'},... FOS03
    {'06'},... FOS04
    {'08'},... FOS05
    {'06'},... FOS06
    };

Cond.Chirp80 = {...
    {[]},... FOS01
    {'09'},... FOS02
    {'07'},... FOS03
    {'11'},... FOS04
    {'12'},... FOS05
    {'11'},... FOS06
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'12'},... FOS06 Noiseburst 70dB
	};

Cond.TreatgapASSR70 = {...
    {'07'},... FOS01
    {'13'},... FOS02
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'13'},... FOS06
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS01
    {'14'},... FOS02
    {'13'},... FOS03
    {'13'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'14'},... FOS06
    };

Cond.TreatTonotopy = {...
    {[]},... FOS01 
    {[]},... FOS02
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {[]},... FOS06
    };

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'15'},... FOS06
    };
