%%% Group MKO = Male Knock Out (FMR1 C57 B6/J)
animals = {'VMP01'};

% notes:
% 

%% Channels and Layers

channels = {...
    '[1 32]',... %01
    };

%           01          02          03          04          05          06           
Layer.II = {'[1:3]'}; 
%           01          02          03          04          05          06
Layer.IV = {'[4:9]'};
%           01          02          03          04          05          06
Layer.Va = {'[10:18]'};
%           01          02          03          04          05          06
Layer.Vb = {'[19:24]'}; 
%           01          02          03          04          05          06
Layer.VI = {'[25:27]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'01','02','04','06'},... %MKO01
    };

Cond.Pupcall = {...
	{'05','07'},... %MKO01
    };
