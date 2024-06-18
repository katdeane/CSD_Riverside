%%% Group PMP = Parent (father) Male Pupcall
animals = {'PMP01', 'PMP02', 'PMP03','PMP04','PMP05','PMP06','PMP07','PMP08','PMP09'};  

% notes:
% PMP01 was stained in the recording location with Fluoro-ruby
% PMP07 had a probe removal and replacement, but the channels and layers
% ended up being a match, so it is a continuous file
% PMP04 had loss of amplitude after around 25 pupcall trials but did not die 
% PMP05 and PMP09 died ~30 & ~45 minutes after pup call 

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %01
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',...%02
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...%03
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %P04
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %P05
    '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %P06
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %P07
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %P08
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',...%P09
    };

%           01          02          03          04          05          06           07          08         09
Layer.II = {'[1:3]',    '[1:3]',    '[1:4]',    '[1:4]',    '[1:5]',    '[1:2]',    '[1:3]',    '[1:3]',    '[1:4]'}; 
%           01          02          03          04          05          06
Layer.IV = {'[4:11]',   '[4:9]',    '[5:10]',   '[5:9]',    '[6:13]',   '[3:7]',    '[4:7]',    '[4:10]',   '[5:10]'};
%           01          02          03          04          05          06
Layer.Va = {'[12:16]',  '[10:14]',  '[11:16]',  '[10:15]',  '[15:17]',  '[8:11]',   '[8:11]',   '[11:13]',  '[11:16]'};
%           01          02          03          04          05          06
Layer.Vb = {'[17:21]',  '[15:19]',  '[17:20]',  '[16:20]',  '[18:21]',  '[12:16]',  '[12:15]',  '[14:17]',  '[17:21]'}; 
%           01          02          03          04          05          06
Layer.VI = {'[22:25]',  '[20:25]',  '[21:26]',  '[21:25]',  '[22:24]',  '[17:21]',  '[16:20]',  '[18:21]',  '[22:27]'}; 



%% Conditions
Cond.NoiseBurst = {...
	{'01','02'},... %PMP01
    {'01','02'},... %PMP02
    {'01','02'},... %PMP03
    {'01','02','03'},... %PMP04
    {'01','02','03'},... %PMP05
    {'01','02','03'},... %PMP06
    {'01','02','03'},... %PMP07
    {'01','03'},... %PMP08
    {'01','02','03'}
    };

Cond.Pupcall30 = {... % 30 dB attenuation  = 45-50 dB SPL
	{'04'},... %PMP01
    {'04'},... %PMP02
    {'04'},... %PMP03
    {'05'},... %PMP04
    {'05'},... %PMP05
    {'05'},... %PMP06
    {'05'},... %PMP07
    {'05'},... %PMP08
    {'05'},... %PMP09
    };

Cond.PostNoiseBurst = {...
	{'06'},... %PMP01
    {'05'},... %PMP02
    {'05'},... %PMP03
    {[]},... %PMP04
    {'06'},... %PMP05
    {'06'},... %PMP06
    {'06'},... %PMP07
    {'06'},... %PMP08
    {'06'},... %PMP09
    };

Cond.Spontaneous = {...
    {'03'},... %PMP01
    {'03'},... %PMP02
    {'03'},... %PMP03
    {'04'},... %PMP04
    {'04'},... %PMP05
    {'04'},... %PMP06
    {'04'},... %PMP07
    {'04'},... %PMP08
    {'04'},... %PMP09
    };

Cond.Chirp = {...
    {'07'},... %PMP01
    {'08'},... %PMP02 - drop in amplitude after ~70 trials
    {'06'},... %PMP03 
    {[]},... %PMP04
    {'07'},... %PMP05
    {'07'},... %PMP06
    {'09'},... %PMP07
    {'07'},... %PMP08
    {'07'},... %PMP09
    };

Cond.gapASSR = {...
    {'09'},... %PMP01
    {'07'},... %PMP02
    {'07'},... %PMP03
    {[]},... %PMP04
    {[]},... %PMP05
    {'09'},... %PMP06
    {'11'},... %PMP07
    {'09'},... %PMP08
    {[]},... %PMP09
    };

Cond.ClickTrain = {...
    {'08'},... %PMP01
    {'06'},... %PMP02
    {'08'},... %PMP03
    {[]},... %PMP04
    {[]},... %PMP05
    {'08'},... %PMP06
    {'12'},... %PMP07
    {'08'},... %PMP08
    {'08'},... %PMP09
    };

Cond.Tonotopy = {...
    {'05'},... %PMP01
    {'09'},... %PMP02
    {'09'},... %PMP03 (has AMP Mod measurement)
    {[]},... %PMP04
    {[]},... %PMP05
    {[]},... %PMP06
    {[]},... %PMP07
    {[]},... %PMP08
    {[]},... %PMP09
    };