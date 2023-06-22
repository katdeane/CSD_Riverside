%%% Group MWT = Male Wild Type (C57 B6/J)
animals = {'MWT01','MWT02','MWT03'};

% ruled out:
% CIC03 - had one successful recording day and then nothing but noise on day 2 and 3. Setup was confirmed ok. Hemorrhaging suspected but could not be confirmed
% CIC05 - no recording beyond mapping during surgery, animal died in recovery
% CIC01 & CIC04 - no redeemable signal after implantation 

%% Channels and Layers

channels = {...
    '[4 30]',... %01
    '[4 30]',... %02
    '[4 30]',... %03
    };

%           01          02          03           
Layer.II = {'[1:3]',	'[1:3]',    '[1:3]'}; 
%           01          02          03
Layer.IV = {'[4:10]',	'[4:9]',    '[4:9]'};
%           01          02          03
Layer.V  = {'[11:14]',	'[10:15]',  '[10:15]'};
%           01          02          03
Layer.VI = {'[15:20]',	'[16:20]',  '[16:20]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'01','02','03','04','05','06'},... %MWT01
	{'01','02','03','04','05'},... %MWT02
    {'01','02','03','04','05'},... %MWT03
    };

Cond.Tonotopy = {...
	{'07'},... %MWT01
    {'06'},... %MWT02
    {'06'},... %MWT03
    };

Cond.Spontaneous = {...
	{'08'},... %MWT01
    {'07'},... %MWT02
    {'07'},... %MWT03
	};

Cond.ClickTrain = {...
	{'09'},... %MWT01
    {'08','13'},... %MWT02
    {'08','13'},... %MWT03
	};

Cond.Chirp = {...
	{'10'},... %MWT01
    {'09','14'},... %MWT02
    {'09','14'},... %MWT03
    };

Cond.gapASSR = {...
	{'11'},... %MWT01
    {'10','15'},... %MWT02
    {'10','15'},... %MWT03
    };

Cond.postNoise = {...
	{'12'},... %MWT01
    {'11','16'},... %MWT02
    {'11','16'},... %MWT03
    };

Cond.postSpont = {...
	{'13'},... %MWT01
    {'12','17'},... %MWT02
    {'12','17'},... %MWT03
    };