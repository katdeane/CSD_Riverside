%%% Group AKO = Male Knock Out (FMR1 C57 B6/J)
animals = {'AKO02','AKO06'};

% notes:
% AKO01, 16 died during noise bursts
% AKO04, 05 died after tonotopies
% account for 08 09 10

% AKO14 is split in two because the subject became quickly wakeful and
% broke the probe

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... %02
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %06
    };

%           01          02          03          04          05          06           07           08         09          10         11
Layer.II = {'[1:4]',    '[1:3]'}; 

Layer.IV = {'[5:8]',    '[4:9]'};

Layer.Va = {'[9:13]',   '[10:13]'};

Layer.Vb = {'[14:17]',  '[14:16]'}; 

Layer.VI = {'[18:22]',  '[17:22]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'04'},... %AKO02
    {'04'},... %AKO06
    };

Cond.ClickTrain = {...
    {'09'},... %AKO02
    {'09'},... %AKO06
	};

Cond.gapASSR = {...
    {'06'},... %AKO02
    {'08'},... %AKO06
    };
