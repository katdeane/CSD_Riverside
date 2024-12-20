%%% Group FOF = FVB Old Female
animals = {'FOS03','FOS04','FOS05','FOS08','FOS09','FON02','FON03','FON05','FON09','FON10','FOS12'};

% notes:
% S03: 19.5 months- Had a double stimulus line in CSD?; female
% S04: 17.7 months; female - Very low signal, deaf?- mouse was very lethargic after
%           recording
% S05: 16.2 months; female - had an eye infection, no treatment given, response to
%           noiseburst was still seen in raw signal, but low response in CSD


%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... S05
    '[10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S08
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... S09
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... N02
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... N03
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... N05
    '[9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...N09
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...N10
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...S12
    };

%             S03        S04       S05    S08      S09     N02       N03
Layer.II = {'[1:3]',  '[1:2]',  '[1:3]','[1:3]','[1:3]','[1:3]',  '[1:3]','[1:3]','[1:3]','[1:3]','[1:3]'};        
%             S03        S04      S05     S08     S09     N02
Layer.IV = {'[4:7]',  '[3:5]',  '[4:8]','[4:7]','[4:7]','[4:8]', '[4:7]','[4:10]','[4:8]','[4:8]','[4:7]'};
%             S03     S04       S05        S08     S09      N02
Layer.Va = {'[8:10]','[6:9]','[9:11]',  '[8:11]','[8:11]','[9:11]','[8:9]','[11:13]','[9:11]','[9:10]','[8:10]'};
%             S03       S04      S05          S08     S09       N02
Layer.Vb = {'[11:14]','[10:12]','[12:14]','[12:13]','[12:15]','[12:14]','[10:12]','[14:16]','[12:14]','[11:12]','[11:13]'}; 
%             S03       S04      S05          S08     S09         N02
Layer.VI = {'[15:18]','[13:16]','[15:18]','[14:15]','[16:20]','[15:18]','[13:16]','[17:20]','[15:16]','[13:16]','[14:17]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS03
    {'01'},... FOS04
    {'01'},... FOS05
    {'02'},... FOS08
    {'02'},... FOS09
    {'01'},... FON02
    {'01'},... FON03
    {'02'},... FON05
    {'01'},... FON09
    {'01'},... FON10
    {'03'},... FOS12
    };

Cond.NoiseBurst80 = {...
    {'08'},... FOS03
    {'07'},... FOS04
    {'04'},... FOS05
    {'08'},... FOS08
    {'08'},... FOS09
    {'07'},... FON02
    {'10'},... FON03
    {'11'},... FON05
    {'07'},... FON09
    {'06'},... FON10
    {'08'},... FOS12
    };

Cond.gapASSR70 = {...
    {'03'},... FOS03
    {'04'},... FOS04
    {'06'},... FOS05
    {'06'},... FOS08
    {'06'},... FOS09
    {'04'},... FON02
    {'03'},... FON03
    {'06'},... FON05
    {'04'},... FON09
    {'08'},... FON10
    {'06'},... FOS12
    };

Cond.gapASSR80 = {...
    {'10'},... FOS03 
    {'09'},... FOS04 
    {'10'},... FOS05 
    {'12'},... FOS08
    {'14'},... FOS09
    {'11'},... FON02
    {'09'},... FON03
    {'09'},... FON05
    {'09'},... FON09
    {'03'},... FON10
    {'11'},... FOS12
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS03
    {'03'},... FOS04
    {'05'},... FOS05
    {'10'},... FOS08
    {'04'},... FOS09
    {'03'},... FON02
    {'02'},... FON03
    {'04'},... FON05
    {'08'},... FON09
    {'04'},... FON10
    {'04'},... FOS12
    };

Cond.Tonotopy80 = {...
    {'11'},... FOS03
    {'08'},... FOS04
    {'09'},... FOS05
    {'04'},... FOS08
    {'12'},... FOS09
    {'08'},... FON02
    {'11'},... FON03
    {'08'},... FON05
    {'03'},... FON09
    {'09'},... FON10
    {'09'},... FOS12
    };

Cond.Spontaneous = {...
    {'04'},... FOS03
    {'02'},... FOS04
    {'02'},... FOS05
    {'07'},... FOS08
    {'07'},... FOS09
    {'02'},... FON02
    {'06'},... FON03
    {[]},... FON05
    {[]},... FON09
    {'11'},... FON10
    {'13'},... FOS12
	};

Cond.ClickTrain70 = {...
    {'06'},... FOS03
    {'05'},... FOS04
    {'07'},... FOS05
    {'09'},... FOS08
    {'06'},... FOS09
    {'05'},... FON02
    {'04'},... FON03
    {'07'},... FON05
    {'05'},... FON09
    {'02'},... FON10
    {'10'},... FOS12
	};

Cond.ClickTrain80 = {...
    {'09'},... FOS03
    {'10'},... FOS04
    {'11'},... FOS05
    {'03'},... FOS08
    {'09'},... FOS09
    {'10'},... FON02
    {'08'},... FON03
    {'10'},... FON05
    {'10'},... FON09
    {'07'},... FON10
    {'05'},... FOS12
    
	};

Cond.Chirp70 = {...
    {'02'},... FOS03
    {'06'},... FOS04
    {'08'},... FOS05
    {'11'},... FOS08
    {'13'},... FOS09
    {'06'},... FON02
    {'05'},... FON03
    {'03'},... FON05
    {'02'},... FON09
    {'10'},... FON10
    {'12'},... FOS12
    };

Cond.Chirp80 = {...
    {'07'},... FOS03
    {'11'},... FOS04
    {'12'},... FOS05
    {'05'},... FOS08
    {'05'},... FOS09
    {'09'},... FON02
    {'07'},... FON03
    {'05'},... FON05
    {'06'},... FON09
    {'05'},... FON10
    {'07'},... FOS12
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {'13'},... FOS08 Noiseburst 70dB
    {'15'},... FOS09 Noiseburst 70dB
    {'12'},... FON02 Noiseburst 70 dB
    {'12'},... FON03 Noiseburst 70 dB
    {'12'},... FON05 Noiseburst 70 db
    {'11'},... FON09 Noiseburst 70db
    {'12'},... FON10 Noiseburst 70db
    {[]},... FOS12 Mouse broke out of headfixation
	};

Cond.TreatgapASSR70 = {...
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {'15'},... FOS08
    {'17'},... FOS09
    {'13'},... FON02 
    {'13'},... FON03
    {'14'},... FON05
    {[]},... FON09 Mouse died
    {'13'},... FON10
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatgapASSR80 = {...
    {'13'},... FOS03
    {'13'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'14'},... FOS08
    {'16'},... FOS09
    {'14'},... FON02
    {'14'},... FON03
    {'13'},... FON05
    {[]},... FON09
    {'14'},... FON10
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatTonotopy = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FON02
    {[]},... FON03
    {[]},... FON06 
    {[]},... FON09
    {[]},... FON10
    {[]},... FOS12 Mouse broke out of headfixation
	};

Cond.TreatNoiseBurst2 = {...
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {'16'},... FOS08
    {'18'},... FOS09
    {'15'},... FON02 Noiseburst 70dB
    {'15'},... FON03 Noiseburst 70dB
    {'15'},... FON05
    {[]},... FON09
    {'15'},... FON10
    {[]},... FOS12 Mouse broke out of headfixation
    };
