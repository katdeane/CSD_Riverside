%%% Group VMP = Virgin Male Pupcall
animals = {'VMP02'}; %'VMP01', --- need to downsample these files!

% notes:
% 

%% Channels and Layers

channels = {...
    %'[2 32]',... %01
    '[1 32]',... %02
    };

%           01          02          03          04          05          06           
Layer.II = {'[1:5]',    '[1:5]'}; 
%           01          02          03          04          05          06
Layer.IV = {'[6:12]',   '[6:12]'};
%           01          02          03          04          05          06
Layer.Va = {'[13:18]',  '[13:18]'};
%           01          02          03          04          05          06
Layer.Vb = {'[19:25]',  '[19:25]'}; 
%           01          02          03          04          05          06
Layer.VI = {'[25:31]',  '[25:31]'}; 



%% Conditions
Cond.NoiseBurst = {...
	%{'01','02','04'},... %VMP01
    {'01','02','03'},... %VMP02
    };

Cond.Pupcall = {...
	%{'05','07'},... %VMP01
    {'05','06','07','08'},... %VMP02 (20:10:50 dB attenuation)
    };

Cond.PostNoiseBurst = {...
	%{'06'},... %VMP01
    {'12'},... %VMP01
    };

Cond.Spontaneous = {...
    {'04'},... %VMP02
    };

Cond.Chirp = {...
    {'09'},... %VMP02
    };

Cond.gapASSR = {...
    {'10'},... %VMP02
    };

Cond.ClickTrain = {...
    {'11'},... %VMP02
    };