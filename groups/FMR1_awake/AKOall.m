%%% Group AKO = Male Knock Out (FMR1 C57 B6/J)
animals = {'AKO01','AKO02','AKO03','AKO04','AKO05','AKO06','AKO07','AKO08','AKO09','AKO10','AKO11'};

% notes:
% AKO01, 16 died during noise bursts
% AKO04, 05 died after tonotopies
% account for 08 09 10

% AKO14 is split in two because the subject became quickly wakeful and
% broke the probe

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %01
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... %02
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',... %03
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %04
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... %05
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %06
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %07
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',... %08
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... %09
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %10
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',... %11
    };

%           01          02          03          04          05          06           07           08         09          10         11
Layer.II = {'[1:3]',	'[1:4]',    '[1:4]',    '[1:3]',    '[1:3]',    '[1:3]',    '[1:2]',    '[1:3]',    '[1:4]',    '[1:3]',    '[1:3]'}; 

Layer.IV = {'[4:9]',	'[5:8]',    '[5:10]',   '[4:9]',    '[4:9]',    '[4:9]',    '[3:8]',    '[4:9]',    '[5:9]',    '[4:9]',    '[4:9]'};

Layer.Va = {'[10:12]',	'[9:13]',  '[11:13]',  '[10:14]',  '[10:14]',  '[10:13]',   '[9:12]',   '[10:13]',  '[10:14]',  '[10:14]',  '[10:14]'};

Layer.Vb = {'[13:16]',	'[14:17]',  '[14:19]',  '[15:20]',  '[15:18]',  '[14:16]',  '[13:17]',  '[14:20]',  '[15:17]',  '[15:19]',  '[15:19]'}; 

Layer.VI = {'[17:21]',	'[18:22]',  '[20:22]',  '[21:21]',  '[19:19]',  '[17:22]',  '[18:20]',  '[21:21]',  '[18:20]',  '[20:20]',  '[20:20]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'03'},... %AKO01
    {'04'},... %AKO02
    {'01','02'},... %AKO03
    {'01','02'},... %AKO04
    {'01','02'},... %AKO05
    {'04'},... %AKO06
    {'01','02'},... %AKO07
    {'02','03'},... %AKO08
    {'02','03'},... %AKO09
    {'05','06'},... %AKO10
    {'01','02'},... %AKO11
    };

Cond.Spontaneous = {...
    {'04'},... %AKO01
    {'05'},... %AKO02
    {'03'},... %AKO03
    {'03'},... %AKO04
    {'03'},... %AKO05
    {'05'},... %AKO06
    {[]},... %AKO07
    {[]},... %AKO08
    {'04'},... %AKO09
    {'07'},... %AKO10
    {'03'},... %AKO11
	};

Cond.Tonotopy = {...
    {'05'},... %AKO01
    {'07'},... %AKO02
    {'06'},... %AKO03
    {'07'},... %AKO04
    {'04'},... %AKO05
    {'07'},... %AKO06
    {'05'},... %AKO07
    {'05'},... %AKO08
    {'05'},... %AKO09
    {'08'},... %AKO10
    {'07'},... %AKO11
    };

Cond.ClickTrain = {...
    {'06'},... %AKO01
    {'09'},... %AKO02
    {'04'},... %AKO03
    {'06'},... %AKO04
    {'05'},... %AKO05
    {'09'},... %AKO06
    {'04'},... %AKO07
    {'04'},... %AKO08
    {'08'},... %AKO09
    {'10'},... %AKO10
    {'05'},... %AKO11
	};

Cond.Chirp = {...
    {'08'},... %AKO01
    {'08'},... %AKO02
    {'07'},... %AKO03
    {'04'},... %AKO04
    {'06'},... %AKO05
    {'06'},... %AKO06
    {'03'},... %AKO07
    {'07'},... %AKO08
    {'07'},... %AKO09
    {'11'},... %AKO10
    {'06'},... %AKO11
    };

Cond.gapASSR = {...
    {'07'},... %AKO01
    {'06'},... %AKO02
    {'05'},... %AKO03
    {'05'},... %AKO04
    {'07'},... %AKO05
    {'08'},... %AKO06
    {'06'},... %AKO07
    {'06'},... %AKO08
    {'06'},... %AKO09
    {'09'},... %AKO10
    {'04'},... %AKO11
    };

Cond.postNoiseBurst = {...
    {[]},... %AKO01
    {[]},... %AKO02
    {[]},... %AKO03
    {'08'},... %AKO04
    {'08'},... %AKO05
    {'10'},... %AKO06
    {'07'},... %AKO07
    {'08'},... %AKO08
    {'09'},... %AKO09
    {'12'},... %AKO10
    {'08'},... %AKO11
    };
