%%% Group YNG = FVB Young Saline & Nicotine
animals = {'FYN01', 'FYN02', 'FYN03','FYN05'};

%notes

%N01 - 4 months; male
%N02 - 4 months; male
%N03 - 4 months; male
%N05 - 3.15 months; male



%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... YN01
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... YN02
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... YN03
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... YN05
    };

%            N01         N02        N03     N05
Layer.II = {'[1:3]',   '[1:5]',   '[1:6]','[1:7]'}; 
%            N01         N02        N03     N05
Layer.IV = {'[4:8]',   '[6:10]',  '[7:12]','[8:13]'};
%            N01         N02        N03     N05
Layer.Va = {'[9:12]',  '[11:14]', '[13:15]','[14:15]'};
%            N01         N02        N03     N05
Layer.Vb = {'[13:15]', '[15:17]', '[16:17]','[15:21]'}; 
%            N01         N02        N03     N05
Layer.VI = {'[16:18]', '[18:23]', '[18:22]','[12:27]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FYN01
    {'01'},... FYN02
    {'03'},... FYN03
    {'04'},... FYN05
    };
    

Cond.NoiseBurst80 = {...
    {'02'},... FYN01
    {'02'},... FYN02
    {'04'},... FYN03
    {[]},... FYN05
    };

Cond.gapASSR70 = {...
    {'04'},... FYN01
    {'07'},... FYN02
    {'08'},... FYN03
    {'06'},... FYN05
    };

Cond.gapASSR80 = {...
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };  

Cond.Tonotopy70 = {...
    {'06'},... FYN01
    {'06'},... FYN02
    {'05'},... FYN03
    {'05'},... FYN05
    };

 Cond.Tonotopy80 = {...
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };   

Cond.Spontaneous = {...
	{[]},... FYN01
    {'03'},... FYN02
    {[]},... FYN03
    {[]},... FYN05
	};

Cond.ClickTrain70 = {...
	{'05'},... FYN01
    {'05'},... FYN02
    {'07'},... FYN03
    {'07'},... FYN05
    };

Cond.ClickTrain80 = {...
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };

Cond.Chirp70 = {...
    {'03'},... FYN01
    {'04'},... FYN02
    {'06'},... FYN03
    {'08'},... FYN05
    };

Cond.Chirp80 = {...
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };

Cond.TreatNoiseBurst1 = {...
    {'07'},... FYN01
    {'08'},... FYN02
    {[]},... FYN03 -- broke from head-fixation during injection
    {'09'},... FYN05 -- survived, Noiseburst 70db
    };

Cond.TreatgapASSR70 = {...
    {'08'},... FYN01 - died during
    {'09'},... FYN02 - died during
    {[]},... FYN03
    {'10'},... FYN05
    };

Cond.TreatgapASSR80 = {...
    {[]},... FYN01
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };

Cond.TreatTonotopy = {...
    {[]},... FYN01 
    {[]},... FYN02
    {[]},... FYN03
    {[]},... FYN05
    };

Cond.TreatNoiseBurst2 = {...
    {[]},... FYN01
    {[]},... FYN02
    {[]},... FYN03
    {'11'},... FYN05
    };
