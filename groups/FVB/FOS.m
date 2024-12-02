%%% Group FOS = FVB Old Saline
animals = {'FOS01','FOS02','FOS03','FOS04','FOS05','FOS06','FOS07','FOS08','FOS09','FOS11','FOS12'};

% notes:
% S01: 19 months; male
% S02: 17.3 months; male
% S03: 19.5 months- Had a double stimulus line in CSD?; female
% S04: 17.7 months; female - Very low signal, deaf?- mouse was very lethargic after
%           recording
% S05: 16.2 months; female - had an eye infection, no treatment given, response to
%           noiseburst was still seen in raw signal, but low response in CSD
% S06: 17 months;male
%S07: 16 months; male
%SO8 - 16.2 months - female
%S09- 16.2 months - female
%S11- 16 months- male

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... SO1
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... S02
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... S05
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... S06 
    '[23 10 24 9 25 8 26 7 27 6 28 5 29]',... SO7
    '[10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S08
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... S09
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',... S11
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...S12
    };

%             S01        S02      S03        S04      S05       S06     S07
Layer.II = {'[1:3]',  '[1:3]',  '[1:3]',  '[1:2]',  '[1:3]',  '[1:3]','[1:2]','[1:3]','[1:3]','[1:3]','[1:3]'}; 
%             S01        S02      S03        S04      S05       S06      S07 
Layer.IV = {'[4:8]',  '[4:8]',  '[4:7]',  '[3:5]',  '[4:8]', '[4:10]', '[3:7]','[4:7]','[4:7]','[4:8]','[4:7]'};
%             S01        S02      S03        S04      S05       S06      S07 
Layer.Va = {'[9:12]', '[9:11]', '[8:10]','[6:9]','[9:11]','[11:14]','[8:9]','[8:11]','[8:11]','[9:12]','[8:10]'};
%             S01        S02      S03        S04      S05       S06      S07 
Layer.Vb = {'[13:15]','[12:15]','[11:14]','[10:12]','[12:14]','[15:16]','[10:11]','[12:13]','[12:15]','[13:15]','[11:13]'}; 
%             S01        S02      S03        S04      S05       S06      S07 
Layer.VI = {'[16:18]','[16:20]','[15:18]','[13:16]','[15:18]','[17:20]','[12:13]','[14:15]','[16:20]','[16:20]','[14:17]'}; 



%% Conditions
Cond.NoiseBurst70 = {...
    {'01'},... FOS01
    {'01'},... FOS02
    {'01'},... FOS03
    {'01'},... FOS04
    {'01'},... FOS05
    {'01'},... FOS06
    {'03'},... F0S07
    {'02'},... FOS08
    {'02'},... FOS09
    {'01'},... FOS11
    {'03'},... FOS12
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS01
    {'02'},... FOS02
    {'08'},... FOS03
    {'07'},... FOS04
    {'04'},... FOS05
    {'08'},... FOS06
    {'08'},... F0S07
    {'08'},... FOS08
    {'08'},... FOS09
    {'06'},... FOS11
    {'08'},... FOS12
    };

Cond.gapASSR70 = {...
    {'03'},... FOS01 
    {'07'},... FOS02
    {'03'},... FOS03
    {'04'},... FOS04
    {'06'},... FOS05
    {'04'},... FOS06
    {'12'},... F0S07
    {'06'},... FOS08
    {'06'},... FOS09
    {'02'},... FOS11
    {'06'},... FOS12
    };

Cond.gapASSR80 = {...
     {[]},... FOS01 
    {'10'},... FOS02
    {'10'},... FOS03 
    {'09'},... FOS04 
    {'10'},... FOS05 
    {'09'},... FOS06
    {'07'},... FOS07
    {'12'},... FOS08
    {'14'},... FOS09
    {'08'},... FOS11
    {'11'},... FOS12
    };

Cond.Tonotopy70 = {...
    {'05'},... FOS01
    {'04'},... FOS02
    {'05'},... FOS03
    {'03'},... FOS04
    {'05'},... FOS05
    {'03'},... FOS06
    {'10'},... FOS07
    {'10'},... FOS08
    {'04'},... FOS09
    {'04'},... FOS11
    {'04'},... FOS12
    };

Cond.Tonotopy80 = {...
    {[]},... FOS01
    {'08'},... FOS02
    {'11'},... FOS03
    {'08'},... FOS04
    {'09'},... FOS05
    {'07'},... FOS06
    {'05'},... FOS07
    {'04'},... FOS08
    {'12'},... FOS09
    {'10'},... FOS11
    {'09'},... FOS12
    };

Cond.Spontaneous = {...
    {[]},... FOS01
    {'03'},... FOS02
    {'04'},... FOS03
    {'02'},... FOS04
    {'02'},... FOS05
    {'02'},... FOS06
    {'13'},... FOS07
    {'07'},... FOS08
    {'07'},... FOS09
    {'07'},... FOS11
    {'13'},... FOS12
	};

Cond.ClickTrain70 = {...
    {'06'},... FOS01
    {'06'},... FOS02
    {'06'},... FOS03
    {'05'},... FOS04
    {'07'},... FOS05
    {'05'},... FOS06
    {'04'},... FOS07
    {'09'},... FOS08
    {'06'},... FOS09
    {'11'},... FOS11
    {'10'},... FOS12
	};

Cond.ClickTrain80 = {...
    {[]},... FOS01
    {'11'},... FOS02
    {'09'},... FOS03
    {'10'},... FOS04
    {'11'},... FOS05
    {'10'},... FOS06
    {'09'},... FOS07
    {'03'},... FOS08
    {'09'},... FOS09
    {'05'},... FOS11
    {'05'},... FOS12
	};

Cond.Chirp70 = {...
    {'04'},... FOS01
    {'05'},... FOS02
    {'02'},... FOS03
    {'06'},... FOS04
    {'08'},... FOS05
    {'06'},... FOS06
    {'06'},... FOS07
    {'11'},... FOS08
    {'13'},... FOS09
    {'09'},... FOS11
    {'12'},... FOS12
    };

Cond.Chirp80 = {...
    {[]},... FOS01
    {'09'},... FOS02
    {'07'},... FOS03
    {'11'},... FOS04
    {'12'},... FOS05
    {'11'},... FOS06
    {'11'},... FOS07
    {'05'},... FOS08
    {'05'},... FOS09
    {'03'},... FOS11
    {'07'},... FOS12
    };

Cond.TreatNoiseBurst1 = {...
    {[]},... FOS01
    {'12'},... FOS02
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'12'},... FOS06 Noiseburst 70dB
    {'14'},... FOS07 Noiseburst 70dB
    {'13'},... FOS08 Noiseburst 70dB
    {'15'},... FOS09 Noiseburst 70dB
    {'12'},... FOS11 Noiseburst 70dB
    {[]},... FOS12 Mouse broke out of headfixation
	};

Cond.TreatgapASSR70 = {...
    {'07'},... FOS01
    {'13'},... FOS02
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'13'},... FOS06
    {'15'},... FOS07 
    {'15'},... FOS08
    {'17'},... FOS09
    {'14'},... FOS11
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS01
    {'14'},... FOS02
    {'13'},... FOS03
    {'13'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'14'},... FOS06
    {'16'},... FOS07
    {'14'},... FOS08
    {'16'},... FOS09
    {'13'},... FOS11
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatTonotopy = {...
    {[]},... FOS01 
    {[]},... FOS02
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection
    {[]},... FOS06
    {[]},... FOS07
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS11
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatNoiseBurst2 = {...
    {'08'},... %FOS01 - 29 minutes after saline
    {'15'},... FOS02
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'15'},... FOS06
    {'17'},... FOS07
    {'16'},... FOS08
    {'18'},... FOS09
    {'15'},... FOS11
    {[]},... FOS12 Mouse broke out of headfixation
    };
