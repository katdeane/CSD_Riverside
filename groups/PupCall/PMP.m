%%% Group VMP = Parent (father) Male Pupcall
animals = {'PMP01', 'PMP02', 'PMP03'}; 

% notes:
% PMP01 was stained in the recording location with Fluoro-ruby

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %01
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',...%02
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...%03
    };

%           01          02          03          04          05          06           
Layer.II = {'[1:3]',    '[1:3]',    '[1:4]'}; 
%           01          02          03          04          05          06
Layer.IV = {'[4:11]',   '[4:9]',    '[5:10]'};
%           01          02          03          04          05          06
Layer.Va = {'[12:16]',  '[10:14]',  '[11:16]'};
%           01          02          03          04          05          06
Layer.Vb = {'[17:21]',  '[15:19]',  '[17:20]'}; 
%           01          02          03          04          05          06
Layer.VI = {'[22:25]',  '[20:25]',  '[21:26]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'01','02'},... %VMP01
    {'01','02'},... %VMP02
    {'01','02'},... %VMP03
    };

Cond.Pupcall0 = {... % 0 dB attenuation  = 75-80 dB SPL
    {[]},... %VMP01
    {[]},... %VMP02
    {[]},... %VMP03
    };

Cond.Pupcall20 = {... % 20 dB attenuation  = 55-60 dB SPL
	{[]},... %VMP01
    {[]},... %VMP02
    {[]},... %VMP03
    };

Cond.Pupcall30 = {... % 30 dB attenuation  = 45-50 dB SPL
	{'04'},... %VMP01
    {'04'},... %VMP02
    {'04'},... %VMP03
    };

Cond.Pupcall40 = {... % 40 dB attenuation  = 35-40 dB SPL
	{[]},... %VMP01
    {[]},... %VMP02
    {[]},... %VMP03
    };

Cond.Pupcall50 = {... % 50 dB attenuation  = 25-30 dB SPL
	{[]},... %VMP01
    {[]},... %VMP02
    {[]},... %VMP03
    };


Cond.PostNoiseBurst = {...
	{'06'},... %VMP01
    {'05'},... %VMP02
    {'05'},... %VMP03
    };

Cond.Spontaneous = {...
    {'03'},... %VMP01
    {'03'},... %VMP02
    {'03'},... %VMP03
    };

Cond.Chirp = {...
    {'07'},... %VMP01
    {'08'},... %VMP02 - drop in amplitude after ~70 trials
    {'06'},... %VMP03 
    };

Cond.gapASSR = {...
    {'09'},... %VMP01
    {'07'},... %VMP02
    {'07'},... %VMP03
    };

Cond.ClickTrain = {...
    {'08'},... %VMP01
    {'06'},... %VMP02
    {'08'},... %VMP03
    };

Cond.Tonotopy = {...
    {'05'},... %VMP01
    {'09'},... %VMP02
    {'09'},... %VMP03 (has AMP Mod measurement)
    };