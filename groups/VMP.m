%%% Group MKO = Male Knock Out (FMR1 C57 B6/J)
animals = {'VMP01'};

% notes:
% 

%% Channels and Layers

channels = {...
    '[2 32]',... %01
    };

%           01          02          03          04          05          06           
Layer.II = {'[1:5]'}; 
%           01          02          03          04          05          06
Layer.IV = {'[6:12]'};
%           01          02          03          04          05          06
Layer.Va = {'[13:18]'};
%           01          02          03          04          05          06
Layer.Vb = {'[19:25]'}; 
%           01          02          03          04          05          06
Layer.VI = {'[25:31]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'01','02','04'},... %MKO01
    };

Cond.Pupcall = {...
	{'05','07'},... %MKO01
    };

Cond.PostNoiseBurst = {...
	{'06'},... %MKO01
    };