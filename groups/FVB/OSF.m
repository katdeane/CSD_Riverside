%%OSF - Old Saline Female
%%CSD
animals = {'FOS03','FOS04','FOS05','FOS08','FOS09','FOS12'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... S03 
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... S04
    '[24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... S05
    '[10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... S08
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... S09
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...S12
   };

%             S03      S04       S05      S08      S09    S12
Layer.II = {'[1:3]',  '[1:2]',  '[1:3]', '[1:3]','[1:3]','[1:3]'}; 
%              
Layer.IV = {'[4:7]',  '[3:5]',  '[4:8]','[4:7]','[4:7]','[4:7]'};
%              
Layer.Va = {'[8:10]','[6:9]','[9:11]','[8:11]','[8:11]','[8:10]'};
%              
Layer.Vb = {'[11:14]','[10:12]','[12:14]','[12:13]','[12:15]','[11:13]'}; 
%              
Layer.VI = {'[15:18]','[13:16]','[15:18]','[14:15]','[16:20]','[14:17]'};

%% Conditions
Cond.NoiseBurst70 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12 
    };

Cond.NoiseBurst80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.gapASSR70 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12 
    };

Cond.gapASSR80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12 
    };

Cond.Tonotopy70 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12 
    };

Cond.Tonotopy80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.Spontaneous = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
	};

Cond.ClickTrain70 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
	};

Cond.ClickTrain80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.Chirp70 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.Chirp80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.TreatNoiseBurst1 = {...
    {'12'},... FOS03 Noiseburst 80db
    {'12'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'13'},... FOS08 Noiseburst 70dB
    {'15'},... FOS09 Noiseburst 70dB
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatgapASSR70 = {...
    {'14'},... FOS03
    {'14'},... FOS04
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'15'},... FOS08
    {'17'},... FOS09
    {[]},... FOS12 Mouse broke out of headfixation
    };

Cond.TreatgapASSR80 = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.TreatTonotopy = {...
    {[]},... FOS03
    {[]},... FOS04
    {[]},... FOS05
    {[]},... FOS08
    {[]},... FOS09
    {[]},... FOS12
    };

Cond.TreatNoiseBurst2 = {...
    {'15'},... FOS03 Noiseburst 70db
    {'15'},... FOS04 Noiseburst 70db
    {[]},... FOS05 Didn't do a treatment due to it's eye infection 
    {'16'},... FOS08
    {'18'},... FOS09
    {[]},... FOS12 Mouse broke out of headfixation
    };
