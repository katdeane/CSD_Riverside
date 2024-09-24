%%% Group AWT = Awake Wild Type (C57 B6/J) males
animals = {'AWT01','AWT02','AWT03','AWT04','AWT05','AWT06','AWT07','AWT08'};

% ruled out:

% notes:
% AWT03 had huge artifacts throughout (last click train not bad through)
% AWT05 has no distinguishable sound onset response (in clicks at least)

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %01
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... %02
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %03
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %04
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %06
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... %07
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',... %08
    };

%           01          02          03          04          06          07          08      
Layer.II = {'[1:3]',	'[1:3]',    '[1:4]',    '[1:3]',	'[1:4]',    '[1:3]',    '[1:2]'}; 
         
Layer.IV = {'[4:11]',	'[4:11]',   '[5:11]',   '[4:9]',	'[5:12]',   '[4:8]',    '[3:7]'};
     
Layer.Va = {'[12:14]',	'[12:15]',  '[12:14]',  '[10:12]',	'[13:15]',  '[9:12]',   '[8:10]'};
   
Layer.Vb = {'[15:19]',	'[16:19]',  '[15:18]',  '[13:17]',	'[16:18]',  '[13:16]',  '[11:16]'};
    
Layer.VI = {'[21:23]',	'[20:21]',  '[19:21]',  '[18:20]',	'[19:22]',  '[17:23]',  '[17:21]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'02','03'},... %AWT01 
	{'01','02'},... %AWT02
    {'05','06'},... %AWT03
    {'01','02'},... %AWT04
    {'05','06'},... %AWT05 
	{'01','02'},... %AWT06
    {'01','02'},... %AWT07
    {'01','02'},... %AWT08
    };

Cond.Spontaneous = {...
	{'04'},... %AWT01
    {'03'},... %AWT02
    {'07'},... %AWT03
    {'03'},... %AWT04
    {'07'},... %AWT05
    {'03'},... %AWT06
    {'03'},... %AWT07
    {'03'},... %AWT08
	};

Cond.Tonotopy = {...
	{'05'},... %AWT01
    {'05'},... %AWT02
    {'10'},... %AWT03
    {'07'},... %AWT04
    {'08'},... %AWT05
    {'05'},... %AWT06
    {'06'},... %AWT07
    {'05'},... %AWT08
    };

Cond.ClickTrain = {...
	{'06'},... %AWT01
    {'07'},... %AWT02
    {'08','13'},... %AWT03 - second taken due to less artifacts later 
    {'06'},... %AWT04
    {'09'},... %AWT05
    {'07'},... %AWT06
    {'05'},... %AWT07
    {'04'},... %AWT08
	};

Cond.Chirp = {...
	{'08'},... %AWT01
    {'06'},... %AWT02
    {'11'},... %AWT03
    {'04'},... %AWT04
    {'10'},... %AWT05
    {'04'},... %AWT06
    {'04'},... %AWT07
    {'07'},... %AWT08
    };

Cond.gapASSR = {...
	{'07'},... %AWT01
    {'04'},... %AWT02
    {'09'},... %AWT03
    {'05'},... %AWT04
    {'11'},... %AWT05
    {'06'},... %AWT06
    {'07'},... %AWT07
    {'06'},... %AWT08
    };

Cond.postNoiseBurst = {...
	{[]},... %AWT01  - forgot
    {'08'},... %AWT02
    {'12'},... %AWT03
    {'08'},... %AWT04
    {'12'},... %AWT05
    {'08'},... %AWT06
    {'08'},... %AWT07
    {'08'},... %AWT08
    };